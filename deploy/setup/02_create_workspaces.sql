-- One-time setup: create the two APEX workspaces and the three PoC test accounts.
-- Run as SYS / an APEX instance admin after 01_create_schemas.sql.
-- Workspace 1 = POC_DEV_UAT -> POC_DEV,  Workspace 2 = POC_PROD -> POC_PROD.
-- Accounts: DEV_A, DEV_B (developers in DEV/UAT), RELEASE_MGR (reviewer/release manager, both workspaces).
-- Every account must change its password on first login.
whenever sqlerror exit failure
set verify off

accept init_secret char prompt 'Initial password for the PoC APEX accounts: ' hide

begin
  apex_instance_admin.add_workspace(p_workspace => 'POC_DEV_UAT', p_primary_schema => 'POC_DEV');
  apex_instance_admin.add_workspace(p_workspace => 'POC_PROD',    p_primary_schema => 'POC_PROD');
  commit;
end;
/

declare
  procedure add_user(p_workspace varchar2, p_user varchar2, p_privs varchar2) is
  begin
    apex_util.set_security_group_id(apex_util.find_security_group_id(p_workspace));
    apex_util.create_user(
      p_user_name                    => p_user,
      p_web_password                 => '&init_secret',
      p_developer_privs              => p_privs,
      p_default_schema               => case p_workspace when 'POC_PROD' then 'POC_PROD' else 'POC_DEV' end,
      p_change_password_on_first_use => 'Y');
  end;
begin
  add_user('POC_DEV_UAT', 'DEV_A',       'CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  add_user('POC_DEV_UAT', 'DEV_B',       'CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  add_user('POC_DEV_UAT', 'RELEASE_MGR', 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  -- Only the release manager can change the PROD simulation
  add_user('POC_PROD',    'RELEASE_MGR', 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  commit;
end;
/

prompt Workspaces POC_DEV_UAT and POC_PROD created with PoC accounts.
