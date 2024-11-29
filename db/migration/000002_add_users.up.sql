CREATE TABLE "users" (
  "username" varchar PRIMARY KEY,
  "hashed_password" varchar NOT NULL,
  "full_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "password_changed_at" timestamp NOT NULL DEFAULT '0001-01-01 00:00:00'
);



-- CREATE UNIQUE INDEX ON "account" ("owner", "currency");



ALTER TABLE "account" ADD CONSTRAINT "owner_currency_key" UNIQUE  ("owner", "currency");

ALTER TABLE "account" ADD FOREIGN KEY ("owner") REFERENCES "users" ("username");

