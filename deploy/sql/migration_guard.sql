-- Stops the deploy if a migration version is already recorded in this schema.
-- Usage: @deploy/sql/migration_guard.sql <VERSION>
whenever sqlerror exit failure
set verify off

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from user_tables where table_name = 'POC_SCHEMA_MIGRATIONS';
  if l_cnt = 1 then
    execute immediate 'select count(*) from poc_schema_migrations where version = :v' into l_cnt using '&1';
    if l_cnt > 0 then
      raise_application_error(-20010, 'Migration &1 is already applied - refusing to re-run');
    end if;
  end if;
end;
/
