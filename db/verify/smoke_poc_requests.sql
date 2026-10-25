-- Smoke test (TC-01): table, package and sample data work. Changes are rolled back.
whenever sqlerror exit failure rollback
set serveroutput on

declare
  l_before pls_integer;
  l_id     poc_requests.id%type;
begin
  l_before := poc_requests_api.open_count;
  if l_before < 1 then
    raise_application_error(-20200, 'Expected sample open requests, found ' || l_before);
  end if;

  l_id := poc_requests_api.create_request('Smoke test request', 'Smoke Tester');
  if poc_requests_api.open_count <> l_before + 1 then
    raise_application_error(-20201, 'create_request did not add an open request');
  end if;

  poc_requests_api.set_status(l_id, 'DONE');
  if poc_requests_api.open_count <> l_before then
    raise_application_error(-20202, 'set_status did not close the request');
  end if;

  rollback;
  dbms_output.put_line('OK: poc_requests smoke test passed');
end;
/
