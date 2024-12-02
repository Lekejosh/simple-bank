CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE "sessions" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "username" VARCHAR NOT NULL,
  "refresh_token" VARCHAR NOT NULL,
  "user_agent" VARCHAR NOT NULL,
  "client_ip" VARCHAR NOT NULL,
"is_blocked" BOOLEAN NOT NULL DEFAULT false,
  "expires_at"TIMESTAMP NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (now())
);

ALTER TABLE "sessions"
  ADD FOREIGN KEY ("username") REFERENCES "users" ("username");
