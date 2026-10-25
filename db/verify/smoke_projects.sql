-- Smoke test: PROJECTS accepts a row the way the Page 3 form inserts it (ID from identity). Rolled back.
whenever sqlerror exit failure rollback
set serveroutput on

declare
  l_id projects.id%type;
begin
  insert into projects (name) values ('Smoke test project') returning id into l_id;
  if l_id is null then
    raise_application_error(-20200, 'Identity did not generate PROJECTS.ID');
  end if;
  rollback;
  dbms_output.put_line('OK: projects smoke test passed');
end;
/
