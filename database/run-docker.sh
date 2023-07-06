docker run -d \
	--name some-postgres \
	-e POSTGRES_PASSWORD=password \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v /home/ec2-user/reservas-spice-garden/database:/var/lib/postgresql/data \
	postgres
