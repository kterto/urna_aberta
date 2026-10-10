BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "candidate" (
    "id" bigserial PRIMARY KEY,
    "electionCode" bigint NOT NULL,
    "officeCode" bigint NOT NULL,
    "scopeCode" text NOT NULL,
    "number" bigint NOT NULL,
    "ballotName" text NOT NULL,
    "party" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "candidate_identity_idx" ON "candidate" USING btree ("electionCode", "officeCode", "scopeCode", "number");


--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261010103102709-candidates', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261010103102709-candidates', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
