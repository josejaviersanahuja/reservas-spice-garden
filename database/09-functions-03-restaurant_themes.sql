
CREATE OR REPLACE FUNCTION create_restaurant_theme(
  _theme_name VARCHAR(255),
  _description TEXT,
  _image_url VARCHAR(255) DEFAULT ''
)
RETURNS JSON AS $$
DECLARE
  res restaurant_themes;
  stack_info TEXT;
BEGIN
  INSERT INTO restaurant_themes (theme_name, description, image_url)
  VALUES (_theme_name, _description, _image_url)
  RETURNING id, theme_name, description, image_url, created_at, updated_at, is_deleted
  INTO res;
  
  RETURN json_build_object(
    'isError', FALSE,
    'message', 'Restaurant theme created successfully',
    'result', row_to_json(res)
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

-- Función para actualizar un restaurant_theme
CREATE OR REPLACE FUNCTION update_restaurant_theme(
  _id INTEGER,
  _theme_name VARCHAR(255) DEFAULT NULL,
  _description TEXT DEFAULT NULL,
  _image_url VARCHAR(255) DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
  result restaurant_themes;
BEGIN
  UPDATE restaurant_themes
  SET
    theme_name = COALESCE(_theme_name, theme_name),
    description = COALESCE(_description, description),
    image_url = COALESCE(_image_url, image_url),
    updated_at = NOW()
  WHERE id = _id
  RETURNING id, theme_name, description, image_url, created_at, updated_at, is_deleted
  INTO result;
  
  IF result IS NULL THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme not found',
      'result', NULL,
      'rowsAffected', 0
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme updated successfully',
      'result', row_to_json(result),
      'rowsAffected', 1
    );
  END IF;
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

-- Función para borrar un restaurant_theme
CREATE OR REPLACE FUNCTION delete_restaurant_theme(
  _id INTEGER
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
BEGIN
  UPDATE restaurant_themes
  SET is_deleted = TRUE
  WHERE id = _id AND is_deleted = FALSE;
  
  IF FOUND THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme deleted successfully',
      'rowsAffected', 1
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme not found',
      'rowsAffected', 0
    );
  END IF;
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
