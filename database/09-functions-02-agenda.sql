
CREATE OR REPLACE FUNCTION get_agenda_info(_fecha DATE)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
    stack_info TEXT;
BEGIN
    -- Obtener la información de la agenda y el tema del restaurante para la fecha especificada
    SELECT
        json_build_object(
            'fecha', a.fecha,
            'theme_name', rt.theme_name,
            'image_url', rt.image_url,
            '19:00', a.t1900,
            '19:15', a.t1915,
            '19:30', a.t1930,
            '19:45', a.t1945,
            '20:00', a.t2000,
            '20:15', a.t2015,
            '20:30', a.t2030,
            '20:45', a.t2045,
            '21:00', a.t2100,
            '21:15', a.t2115,
            '21:30', a.t2130,
            '21:45', a.t2145
        ) INTO agenda_info
    FROM
        agenda AS a
    JOIN
        restaurant_themes AS rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha = _fecha;
    
    RETURN json_build_object(
        'isError', FALSE,
        'result', agenda_info -- schema | NULL
    );
    
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
        -- Capturar y devolver el error como objeto JSON
        RETURN json_build_object(
            'isError', TRUE,
            'message', SQLERRM,
            'errorCode', SQLSTATE,
            'stack', stack_info
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_agenda(_fecha DATE, _restaurant_theme_id INTEGER)
RETURNS JSON AS $$
DECLARE
    stack_info TEXT;
    agenda_info JSON;
BEGIN
    -- Verificar si la fecha es anterior al CURRENT_DATE
    IF _fecha < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se puede crear una agenda pasada';
    END IF;

    -- Insertar el nuevo registro en la tabla agenda
    INSERT INTO agenda (fecha, restaurant_theme_id)
    VALUES (_fecha, _restaurant_theme_id);

    -- Obtener la información de la agenda y el tema del restaurante para el registro recién creado
    SELECT
        json_build_object(
            'fecha', a.fecha,
            'theme_name', rt.theme_name,
            'image_url', rt.image_url,
            '19:00', a.t1900,
            '19:15', a.t1915,
            '19:30', a.t1930,
            '19:45', a.t1945,
            '20:00', a.t2000,
            '20:15', a.t2015,
            '20:30', a.t2030,
            '20:45', a.t2045,
            '21:00', a.t2100,
            '21:15', a.t2115,
            '21:30', a.t2130,
            '21:45', a.t2145
        ) INTO agenda_info
    FROM
        agenda a
    JOIN
        restaurant_themes rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha = _fecha;

    -- Retornar JSON con statusCode y data en caso de éxito
    RETURN json_build_object('isError', FALSE, 'result', agenda_info);

EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
        RETURN json_build_object(
            'isError', TRUE,
            'message', SQLERRM,
            'errorCode', SQLSTATE,
            'stack', stack_info
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_agenda(_fecha DATE, _restaurant_theme_id INTEGER DEFAULT NULL,
                                        _t1900 INTEGER DEFAULT NULL, _t1915 INTEGER DEFAULT NULL,
                                        _t1930 INTEGER DEFAULT NULL, _t1945 INTEGER DEFAULT NULL,
                                        _t2000 INTEGER DEFAULT NULL, _t2015 INTEGER DEFAULT NULL,
                                        _t2030 INTEGER DEFAULT NULL, _t2045 INTEGER DEFAULT NULL,
                                        _t2100 INTEGER DEFAULT NULL, _t2115 INTEGER DEFAULT NULL,
                                        _t2130 INTEGER DEFAULT NULL, _t2145 INTEGER DEFAULT NULL)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
    stack_info TEXT;
BEGIN
    -- Verificar si la fecha es anterior al CURRENT_DATE
    IF _fecha < CURRENT_DATE THEN
        RETURN json_build_object(
            'isError', TRUE,
            'message', 'Bad Request 400 No se puede modificar una agenda pasada',
            'errorCode', 'P0001'
        );
    END IF;

    -- Actualizar los campos modificables de la tabla agenda
    UPDATE agenda
    SET
        restaurant_theme_id = COALESCE(_restaurant_theme_id, agenda.restaurant_theme_id),
        t1900 = COALESCE(_t1900, agenda.t1900),
        t1915 = COALESCE(_t1915, agenda.t1915),
        t1930 = COALESCE(_t1930, agenda.t1930),
        t1945 = COALESCE(_t1945, agenda.t1945),
        t2000 = COALESCE(_t2000, agenda.t2000),
        t2015 = COALESCE(_t2015, agenda.t2015),
        t2030 = COALESCE(_t2030, agenda.t2030),
        t2045 = COALESCE(_t2045, agenda.t2045),
        t2100 = COALESCE(_t2100, agenda.t2100),
        t2115 = COALESCE(_t2115, agenda.t2115),
        t2130 = COALESCE(_t2130, agenda.t2130),
        t2145 = COALESCE(_t2145, agenda.t2145),
        updated_at = NOW()
    WHERE
        agenda.fecha = _fecha;

    -- Verificar si se modificó alguna fila
    IF FOUND THEN
        -- Obtener la información actualizada de la agenda y el tema del restaurante
        SELECT
            json_build_object(
                'fecha', a.fecha,
                'theme_name', rt.theme_name,
                'image_url', rt.image_url,
                '19:00', a.t1900,
                '19:15', a.t1915,
                '19:30', a.t1930,
                '19:45', a.t1945,
                '20:00', a.t2000,
                '20:15', a.t2015,
                '20:30', a.t2030,
                '20:45', a.t2045,
                '21:00', a.t2100,
                '21:15', a.t2115,
                '21:30', a.t2130,
                '21:45', a.t2145
            ) INTO agenda_info
        FROM
            agenda a
        JOIN
            restaurant_themes rt ON a.restaurant_theme_id = rt.id
        WHERE
            a.fecha = _fecha;

        RETURN json_build_object('isError', FALSE, 'result', agenda_info, 'rowsAffected', 1);
    ELSE
        RETURN json_build_object('isError', FALSE, 'result', NULL, 'rowsAffected', 0);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
        RETURN json_build_object('isError', TRUE, 'message', SQLERRM, 'errorCode', SQLSTATE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_agenda(_fecha DATE)
RETURNS JSON AS $$
DECLARE
  res_count INTEGER;
  stack_info TEXT;
BEGIN
  IF _fecha < CURRENT_DATE THEN
    RETURN '{"isError": true, "message": "BAD REQUEST 400 No se puede borrar una agenda pasada"}';
  END IF;
  UPDATE agenda SET is_deleted = TRUE WHERE fecha = _fecha AND is_deleted = FALSE;
  GET DIAGNOSTICS res_count = ROW_COUNT;
  IF res_count = 0 THEN
    RETURN '{"isError": false, "message": "No se encontró agenda con la fecha especificada", "rowsAffected":0, "reservationsDeleted":0}';
  END IF;
  UPDATE reservations SET is_deleted = TRUE WHERE fecha = _fecha AND is_deleted = FALSE;
  GET DIAGNOSTICS res_count = ROW_COUNT;
  -- RAISE NOTICE 'reservas %', res_count; 
  RETURN json_build_object(
    'isError', FALSE,
    'message', 'Agenda del día '||_fecha||' borrada con '||res_count||' reservas borradas',
    'rowsAffected', 1,
    'reservationsDeleted', COALESCE(res_count, 0)
  );
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
        'isError', TRUE,
        'message', SQLERRM,
        'errorCode', SQLSTATE,
        'stack', stack_info
    );
END;
$$ LANGUAGE plpgsql;
