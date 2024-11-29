CREATE TABLE "users" (
  "username" varchar PRIMARY KEY,
  "hashed_password" varchar NOT NULL,
  "full_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "password_changed_at" timestamp NOT NULL DEFAULT (0001-01-01 00:00:00Z)
);

CREATE TABLE "account" (
  "id" bigint PRIMARY KEY NOT NULL,
  "owner" "character varying" NOT NULL,
  "balance" bigint NOT NULL,
  "currency" "character varying" NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "entries" (
  "id" bigint PRIMARY KEY NOT NULL,
  "account_id" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now())
);

CREATE TABLE "schema_migrations" (
  "version" bigint PRIMARY KEY NOT NULL,
  "dirty" boolean NOT NULL
);

CREATE TABLE "transfers" (
  "id" bigint PRIMARY KEY NOT NULL,
  "from_account_id" bigint NOT NULL,
  "to_account_id" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now())
);

CREATE INDEX "account_owner_idx" ON "account" USING BTREE ("owner");

CREATE UNIQUE INDEX ON "account" ("owner", "currency");

CREATE INDEX "entries_account_id_idx" ON "entries" USING BTREE ("account_id");

CREATE INDEX "transfers_from_account_id_idx" ON "transfers" USING BTREE ("from_account_id");

CREATE INDEX "transfers_from_account_id_to_account_id_idx" ON "transfers" USING BTREE ("from_account_id", "to_account_id");

CREATE INDEX "transfers_to_account_id_idx" ON "transfers" USING BTREE ("to_account_id");

COMMENT ON COLUMN "entries"."amount" IS 'can be negative or positive';

COMMENT ON COLUMN "transfers"."amount" IS 'must be positive';

ALTER TABLE "account" ADD FOREIGN KEY ("owner") REFERENCES "users" ("username");

ALTER TABLE "entries" ADD CONSTRAINT "entries_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "account" ("id");

ALTER TABLE "transfers" ADD CONSTRAINT "transfers_from_account_id_fkey" FOREIGN KEY ("from_account_id") REFERENCES "account" ("id");

ALTER TABLE "transfers" ADD CONSTRAINT "transfers_to_account_id_fkey" FOREIGN KEY ("to_account_id") REFERENCES "account" ("id");
