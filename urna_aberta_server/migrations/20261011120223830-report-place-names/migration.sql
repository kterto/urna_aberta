BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "report_request" ADD COLUMN "placeNames" json;

--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261011120223830-report-place-names', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261011120223830-report-place-names', "timestamp" = now();

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
