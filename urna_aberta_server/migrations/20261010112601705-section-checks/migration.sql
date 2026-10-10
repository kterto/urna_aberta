BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "section_check" (
    "id" bigserial PRIMARY KEY,
    "pleito" bigint NOT NULL,
    "uf" text NOT NULL,
    "municipio" bigint NOT NULL,
    "zona" bigint NOT NULL,
    "secao" bigint NOT NULL,
    "auxStatus" text NOT NULL,
    "auxGeneratedAt" timestamp without time zone NOT NULL,
    "fetchedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "section_check_identity_idx" ON "section_check" USING btree ("pleito", "uf", "municipio", "zona", "secao");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "section_file" (
    "id" bigserial PRIMARY KEY,
    "checkId" bigint NOT NULL,
    "kind" text NOT NULL,
    "name" text NOT NULL,
    "url" text NOT NULL,
    "sha256" text NOT NULL,
    "content" bytea NOT NULL,
    "receivedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "section_file_check_idx" ON "section_file" USING btree ("checkId", "kind");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "section_file"
    ADD CONSTRAINT "section_file_fk_0"
    FOREIGN KEY("checkId")
    REFERENCES "section_check"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261010112601705-section-checks', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261010112601705-section-checks', "timestamp" = now();

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
