postgres:
	docker run --name postgres14 -p 5000:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14.1-alpine

postgresrun:
	docker start postgres14
	
createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank
	
dropdb:
	docker exec -it postgres14 dropdb --username=root --owner=root simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5400/simple_bank?sslmode=disable" -verbose up

migrateupone:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5400/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5400/simple_bank?sslmode=disable" -verbose down

migratedownone:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5400/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/lekejosh/simplebank/db/sqlc Store

.PHONY: postgres postgrerun createdb dropdb migrateup migratedown sqlc test server mock migratedownone migrateupone