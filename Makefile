postgres:
	docker run --name postgres14 -p 5000:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14.1-alpine

postgresrun:
	docker start postgres14
	
createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank
	
dropdb:
	docker exec -it postgres14 dropdb --username=root --owner=root simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5000/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5000/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres postgrerun createdb dropdb migrateup migratedown sqlc test