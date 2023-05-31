
CREATE OR REPLACE FUNCTION create_restaurant_theme(
  _theme_name VARCHAR(255),
  _description TEXT,
  _image_url VARCHAR(255) DEFAULT ''
)
RETURNS JSON AS $$
DECLARE
  res restaurant_themes;
BEGIN
  INSERT INTO restaurant_themes (theme_name, description, image_url)
  VALUES (_theme_name, _description, _image_url)
  RETURNING id, theme_name, description, image_url, created_at, updated_at, is_deleted
  INTO res;
  
  RETURN json_build_object(
    'statusCode', 201,
    'message', 'Restaurant theme created successfully',
    'data', row_to_json(res)
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'statusCode', 500,
      'message', 'Error creating restaurant theme',
      'sqlError', SQLERRM
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
      'statusCode', 404,
      'message', 'Restaurant theme not found'
    );
  ELSE
    RETURN json_build_object(
      'statusCode', 202,
      'message', 'Restaurant theme updated successfully',
      'data', row_to_json(result)
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'statusCode', 500,
      'message', 'Error updating restaurant theme',
      'sqlError', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- Función para borrar un restaurant_theme
CREATE OR REPLACE FUNCTION delete_restaurant_theme(
  _id INTEGER
)
RETURNS JSON AS $$
BEGIN
  UPDATE restaurant_themes
  SET is_deleted = TRUE
  WHERE id = _id AND is_deleted = FALSE;
  
  IF FOUND THEN
    RETURN json_build_object(
      'statusCode', 202,
      'message', 'Restaurant theme deleted successfully'
    );
  ELSE
    RETURN json_build_object(
      'statusCode', 404,
      'message', 'Restaurant theme not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'statusCode', 500,
      'message', 'Error deleting restaurant theme',
      'sqlError', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;
