-- V001: migration history table. Run once per schema (POC_DEV, POC_PROD).
-- Every later migration must insert its own row; deploy aborts if the version is already recorded.
whenever sqlerror exit failure rollback

create table poc_schema_migrations (
  version      varchar2(20)   not null,
  description  varchar2(200)  not null,
  checksum     varchar2(64),
  applied_by   varchar2(128)  default sys_context('USERENV','SESSION_USER') not null,
  applied_at   timestamp      default systimestamp not null,
  status       varchar2(20)   default 'SUCCESS' not null,
  constraint poc_schema_migrations_pk primary key (version),
  constraint poc_schema_migrations_st_ck check (status in ('SUCCESS','FAILED','COMPENSATED'))
);

insert into poc_schema_migrations (version, description)
values ('V001', 'create schema migrations table');
commit;
