create or replace package poc_requests_api as
  -- Business API used by the APEX app (Page 20 process) and by smoke tests.

  function create_request(
    p_title     in poc_requests.title%type,
    p_requester in poc_requests.requester%type,
    p_phone     in poc_requests.phone%type default null
  ) return poc_requests.id%type;

  procedure set_status(p_id in poc_requests.id%type, p_status in poc_requests.status%type);

  function open_count return pls_integer;
end poc_requests_api;
/
