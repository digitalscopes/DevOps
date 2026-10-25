-- One-time setup: create the PROD-simulation schema in the TEST database.
-- DEV/UAT already exists: schema DEVOPS-UAT (workspace DEVOPS-UAT, app 182).
-- The PROD schema name deliberately has no hyphen, so it never needs quoting.
-- Run as a DBA user (e.g. SYSTEM):  sql system@//<test-host>:1521/<service> @deploy/setup/01_create_schemas.sql
-- The password is prompted and never stored in the repo.
whenever sqlerror exit failure
set verify off

define ts = USERS
accept prod_secret char prompt 'New password for DEVOPS_PROD: ' hide

create user devops_prod identified by "&prod_secret" default tablespace &ts quota 500M on &ts;

-- Same object privileges an APEX parsing schema needs (tables, packages, views, sequences, triggers)
grant create session, create table, create view, create sequence, create procedure,
      create trigger, create type, create synonym, create job
   to devops_prod;

prompt Schema DEVOPS_PROD created.
