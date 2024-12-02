DB_URL=postgresql://postgres:admin@localhost:5400/simple_bank?sslmode=disable

postgres:
	docker run --name postgres14 -p 5400:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin -d postgres:14.1-alpine

postgresrun:
	docker start postgres14
	
createdb:
	docker exec -it postgres14 createdb --username=postgres --owner=postgres simple_bank
	
dropdb:
	docker exec -it postgres14 dropdb --username=postgres --owner=postgres simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateupone:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedownone:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/lekejosh/simplebank/db/sqlc Store

db_docs:  
	dbdocs build doc/db.dbml 
db_schema: 
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

.PHONY: postgres postgrerun createdb dropdb migrateup migratedown sqlc test server mock migratedownone migrateupone db_docs db_schema