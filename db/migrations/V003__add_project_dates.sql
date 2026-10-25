-- V003 (#5): project start and end dates, used by app 182 Page 3 (P3_START_DATE, P3_END_DATE).
-- Additive and optional (nullable), so existing rows and inserts keep working.
-- Compensating script if it must be undone:
--   alter table projects drop constraint projects_dates_ck;
--   alter table projects drop (start_date, end_date);
whenever sqlerror exit failure rollback

alter table projects add (
  start_date  date,
  end_date    date,
  constraint projects_dates_ck check (end_date is null or start_date is null or end_date >= start_date)
);

insert into poc_schema_migrations (version, description)
values ('V003', 'add projects start_date and end_date');
commit;
