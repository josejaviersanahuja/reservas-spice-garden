docker run -d \
	--name some-postgres \
	-e POSTGRES_PASSWORD=password \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v /home/ec2-user/docker-mounts/database:/var/lib/postgresql/data \
	-p 5432:5432 \
	postgres
