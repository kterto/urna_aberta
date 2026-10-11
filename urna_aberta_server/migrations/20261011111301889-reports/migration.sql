BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "report_request" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "spec" json NOT NULL,
    "status" text NOT NULL,
    "filesDone" bigint NOT NULL,
    "filesTotal" bigint NOT NULL,
    "errorReason" text,
    "createdAt" timestamp without time zone NOT NULL,
    "startedAt" timestamp without time zone,
    "finishedAt" timestamp without time zone,
    "sha256" text,
    "publicToken" text
);

-- Indexes
CREATE INDEX "report_request_owner_idx" ON "report_request" USING btree ("authUserId", "createdAt");
CREATE INDEX "report_request_status_idx" ON "report_request" USING btree ("status", "createdAt");
CREATE UNIQUE INDEX "report_request_public_idx" ON "report_request" USING btree ("publicToken");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_core_profile" DROP CONSTRAINT IF EXISTS "serverpod_auth_core_profile_fk_1";
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "report_request"
    ADD CONSTRAINT "report_request_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY DEFERRED;

--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261011111301889-reports', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261011111301889-reports', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
