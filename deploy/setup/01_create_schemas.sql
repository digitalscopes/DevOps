-- One-time setup: create the two PoC schemas in the TEST database.
-- Run as a DBA user (e.g. SYSTEM) with SQLcl:  sql system@//<test-host>:1521/<service> @deploy/setup/01_create_schemas.sql
-- Passwords are prompted and never stored in the repo.
whenever sqlerror exit failure
set verify off

define ts = USERS
accept dev_secret  char prompt 'New password for POC_DEV : ' hide
accept prod_secret char prompt 'New password for POC_PROD: ' hide

create user poc_dev  identified by "&dev_secret"  default tablespace &ts quota 500M on &ts;
create user poc_prod identified by "&prod_secret" default tablespace &ts quota 500M on &ts;

-- Privileges an APEX parsing schema needs for this PoC (tables, packages, views, sequences, triggers)
grant create session, create table, create view, create sequence, create procedure,
      create trigger, create type, create synonym, create job
   to poc_dev, poc_prod;

prompt Schemas POC_DEV and POC_PROD created.
