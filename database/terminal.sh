echo "" > X_respaldo.sql &&
echo "-- cambia el nombre de la base de datos y añade _test" > Y_respaldo_test.sql &&
cat 00-create-db.sql >> X_respaldo.sql &&
cat 00-create-db.sql >> Y_respaldo_test.sql &&
cat 01-users.sql >> X_respaldo.sql &&
cat 01-users.sql >> Y_respaldo_test.sql &&
cat 02-restaurant_themes.sql >> X_respaldo.sql &&
cat 02-restaurant_themes.sql >> Y_respaldo_test.sql &&
nano Y_respaldo_test.sql