BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "result_file" (
    "id" bigserial PRIMARY KEY,
    "electionCode" bigint NOT NULL,
    "officeCode" bigint NOT NULL,
    "scopeCode" text NOT NULL,
    "tseGeneratedAt" timestamp without time zone NOT NULL,
    "fetchedAt" timestamp without time zone NOT NULL,
    "rawSha256" text NOT NULL,
    "signature" text NOT NULL,
    "jws" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "result_file_version_idx" ON "result_file" USING btree ("electionCode", "officeCode", "scopeCode", "rawSha256");
CREATE INDEX "result_file_latest_idx" ON "result_file" USING btree ("electionCode", "officeCode", "scopeCode", "tseGeneratedAt");


--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261010190059813-result-files', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261010190059813-result-files', "timestamp" = now();

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
