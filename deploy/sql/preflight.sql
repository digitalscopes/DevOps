-- Preflight: abort unless connected to the expected schema at the expected migration version.
-- Usage: @deploy/sql/preflight.sql <EXPECTED_SCHEMA> <EXPECTED_DB_VERSION>
whenever sqlerror exit failure
set verify off serveroutput on

declare
  l_schema varchar2(128) := sys_context('USERENV', 'CURRENT_SCHEMA');
  l_last   varchar2(20);
begin
  if l_schema <> upper('&1') then
    raise_application_error(-20001, 'Connected to ' || l_schema || ', expected &1');
  end if;

  begin
    execute immediate q'[select max(version) from poc_schema_migrations where status = 'SUCCESS']' into l_last;
  exception
    when others then
      if sqlcode = -942 then l_last := null; else raise; end if;  -- table not created yet
  end;

  if nvl(l_last, 'V000') <> '&2' then
    raise_application_error(-20002, 'Schema is at ' || nvl(l_last, 'V000') || ', release expects &2 (drift)');
  end if;

  dbms_output.put_line('Preflight OK: ' || l_schema || ' at ' || nvl(l_last, 'V000'));
end;
/
