-- Fails (exit code) if the current schema has invalid objects or compile errors.
whenever sqlerror exit failure
set serveroutput on

prompt == Invalid objects ==
select object_type, object_name from user_objects where status <> 'VALID' order by 1, 2;

prompt == Compile errors ==
select name, type, line, position, text from user_errors order by name, type, sequence;

declare
  l_cnt pls_integer;
begin
  select count(*) into l_cnt from user_objects where status <> 'VALID';
  if l_cnt > 0 then
    raise_application_error(-20001, l_cnt || ' invalid object(s) found');
  end if;
  dbms_output.put_line('OK: no invalid objects');
end;
/
