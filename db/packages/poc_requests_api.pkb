create or replace package body poc_requests_api as

  function create_request(
    p_title     in poc_requests.title%type,
    p_requester in poc_requests.requester%type,
    p_phone     in poc_requests.phone%type default null
  ) return poc_requests.id%type is
    l_id poc_requests.id%type;
  begin
    insert into poc_requests (title, requester, phone)
    values (p_title, p_requester, p_phone)
    returning id into l_id;
    return l_id;
  end create_request;

  procedure set_status(p_id in poc_requests.id%type, p_status in poc_requests.status%type) is
  begin
    update poc_requests set status = p_status where id = p_id;
    if sql%rowcount = 0 then
      raise_application_error(-20100, 'Request ' || p_id || ' not found');
    end if;
  end set_status;

  function open_count return pls_integer is
    l_cnt pls_integer;
  begin
    select count(*) into l_cnt from poc_requests where status in ('NEW', 'IN_PROGRESS');
    return l_cnt;
  end open_count;

end poc_requests_api;
/
