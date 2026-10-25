-- Smoke test: PROJECTS accepts a row the way the Page 3 form inserts it (ID from identity). Rolled back.
whenever sqlerror exit failure rollback
set serveroutput on

declare
  l_id projects.id%type;
begin
  insert into projects (name, start_date, end_date)
  values ('Smoke test project', date '2026-01-01', date '2026-12-31')
  returning id into l_id;
  if l_id is null then
    raise_application_error(-20200, 'Identity did not generate PROJECTS.ID');
  end if;

  -- V003: end date before start date must be rejected
  begin
    insert into projects (name, start_date, end_date)
    values ('Bad dates', date '2026-12-31', date '2026-01-01');
    raise_application_error(-20201, 'projects_dates_ck did not reject end_date < start_date');
  exception
    when others then
      if sqlcode <> -2290 then raise; end if;  -- ORA-02290 check constraint violated = expected
  end;
  rollback;
  dbms_output.put_line('OK: projects smoke test passed');
end;
/
