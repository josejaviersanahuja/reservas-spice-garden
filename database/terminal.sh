echo "" > X_respaldo.sql &&
echo "-- cambia el nombre de la base de datos y añade _test" > Y_respaldo_test.sql &&
cat 01-users.sql >> X_respaldo.sql &&
cat 01-users.sql >> Y_respaldo_test.sql &&
cat 02-restaurant_themes.sql >> X_respaldo.sql &&
cat 02-restaurant_themes.sql >> Y_respaldo_test.sql &&
cat 03-agenda.sql >> X_respaldo.sql &&
cat 03-agenda.sql >> Y_respaldo_test.sql &&
cat 04-reservations.sql >> X_respaldo.sql &&
cat 04-reservations.sql >> Y_respaldo_test.sql &&
cat 05-seed-agenda.sql >> Y_respaldo_test.sql &&
cat 06-seed-reservations.sql >> Y_respaldo_test.sql &&
cat 07-constraints.sql >> X_respaldo.sql &&
cat 07-constraints.sql >> Y_respaldo_test.sql &&
cat 08-views.sql >> X_respaldo.sql &&
cat 08-views.sql >> Y_respaldo_test.sql &&
cat 09-functions.sql >> X_respaldo.sql &&
cat 09-functions.sql >> Y_respaldo_test.sql &&
cat 10-triggers.sql >> X_respaldo.sql &&
cat 10-triggers.sql >> Y_respaldo_test.sql &&
nano Y_respaldo_test.sql