BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "candidate_tally" (
    "id" bigserial PRIMARY KEY,
    "snapshotId" bigint NOT NULL,
    "candidateNumber" bigint NOT NULL,
    "votes" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "candidate_tally_snapshot_idx" ON "candidate_tally" USING btree ("snapshotId", "candidateNumber");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "divergence_event" (
    "id" bigserial PRIMARY KEY,
    "origin" text NOT NULL,
    "electionCode" bigint NOT NULL,
    "startedAt" timestamp without time zone NOT NULL,
    "endedAt" timestamp without time zone,
    "nationalPctAtStart" double precision NOT NULL,
    "maxGap" double precision NOT NULL
);

-- Indexes
CREATE INDEX "divergence_event_election_idx" ON "divergence_event" USING btree ("origin", "electionCode", "startedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "result_snapshot" (
    "id" bigserial PRIMARY KEY,
    "origin" text NOT NULL,
    "electionCode" bigint NOT NULL,
    "officeCode" bigint NOT NULL,
    "scopeCode" text NOT NULL,
    "sectionsTotal" bigint NOT NULL,
    "sectionsTotalized" bigint NOT NULL,
    "tseGeneratedAt" timestamp without time zone NOT NULL,
    "fetchedAt" timestamp without time zone NOT NULL,
    "rawSha256" text NOT NULL,
    "signatureValid" boolean
);

-- Indexes
CREATE UNIQUE INDEX "result_snapshot_version_idx" ON "result_snapshot" USING btree ("origin", "electionCode", "officeCode", "scopeCode", "rawSha256");
CREATE INDEX "result_snapshot_timeline_idx" ON "result_snapshot" USING btree ("origin", "electionCode", "officeCode", "scopeCode", "tseGeneratedAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "candidate_tally"
    ADD CONSTRAINT "candidate_tally_fk_0"
    FOREIGN KEY("snapshotId")
    REFERENCES "result_snapshot"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR urna_aberta
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('urna_aberta', '20261010095725754-result-snapshots', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261010095725754-result-snapshots', "timestamp" = now();

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
