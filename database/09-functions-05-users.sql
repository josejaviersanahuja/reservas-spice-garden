
CREATE OR REPLACE FUNCTION create_user(
  _username VARCHAR(50),
  _user_password VARCHAR(255)
)
RETURNS JSON AS $$
DECLARE
  res users;
  stack_info TEXT;
BEGIN
  INSERT INTO users (username, user_password)
  VALUES (_username, _user_password)
  RETURNING id, username, user_password, created_at, updated_at, is_deleted
  INTO res;
  
  RETURN json_build_object(
    'isError', FALSE,
    'message', 'User created successfully',
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

CREATE OR REPLACE FUNCTION update_user(
  _id INTEGER,
  _username VARCHAR(50) DEFAULT NULL,
  _user_password VARCHAR(255) DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
  result users;
BEGIN
  UPDATE users
  SET
    username = COALESCE(_username, username),
    user_password = COALESCE(_user_password, user_password),
    updated_at = NOW()
  WHERE id = _id
  RETURNING id, username, user_password, created_at, updated_at, is_deleted
  INTO result;
  
  IF result IS NULL THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User not found',
      'result', NULL,
      'rowsAffected', 0
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User updated successfully',
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

CREATE OR REPLACE FUNCTION delete_user(
  _id INTEGER
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
BEGIN
  UPDATE users
  SET is_deleted = TRUE
  WHERE id = _id AND is_deleted = FALSE;
  
  IF FOUND THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User deleted successfully',
      'rowsAffected', 1
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User not found',
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
