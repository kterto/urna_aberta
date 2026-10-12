BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "voter_place" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "uf" text NOT NULL,
    "municipio" bigint NOT NULL,
    "municipioNome" text NOT NULL,
    "zona" bigint,
    "secao" bigint,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "voter_place_auth_user_idx" ON "voter_place" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "voter_place"
    ADD CONSTRAINT "voter_place_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261011005310570-voter-place', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261011005310570-voter-place', "timestamp" = now();

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
