-- One-time: put the existing DEVOPS-UAT schema under migration tracking without re-creating PROJECTS.
-- Run connected as DEVOPS-UAT, AFTER db/migrations/V001__create_schema_migrations.sql has run there.
whenever sqlerror exit failure rollback

insert into poc_schema_migrations (version, description)
values ('V002', 'baseline projects table (app 182) - pre-existing, recorded only');
commit;

select version, description, status from poc_schema_migrations order by version;
