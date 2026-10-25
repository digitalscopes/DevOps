-- One-time setup: create the PROD-simulation APEX workspace and the PoC test accounts.
-- Run as SYS / an APEX instance admin after 01_create_schemas.sql.
-- Workspace 1 = DEVOPS-UAT -> DEVOPS-UAT (exists, app 182),  Workspace 2 = DEVOPS-PROD -> DEVOPS_PROD (created here).
-- Accounts: DEV_A, DEV_B (developers in DEVOPS-UAT), RELEASE_MGR (reviewer/release manager, both workspaces).
-- Every account must change its password on first login. Skip any account that already exists.
whenever sqlerror exit failure
set verify off

accept init_secret char prompt 'Initial password for the PoC APEX accounts: ' hide

begin
  apex_instance_admin.add_workspace(p_workspace => 'DEVOPS-PROD', p_primary_schema => 'DEVOPS_PROD');
  commit;
end;
/

declare
  procedure add_user(p_workspace varchar2, p_user varchar2, p_schema varchar2, p_privs varchar2) is
  begin
    apex_util.set_security_group_id(apex_util.find_security_group_id(p_workspace));
    apex_util.create_user(
      p_user_name                    => p_user,
      p_web_password                 => '&init_secret',
      p_developer_privs              => p_privs,
      p_default_schema               => p_schema,
      p_change_password_on_first_use => 'Y');
  end;
begin
  add_user('DEVOPS-UAT',  'DEV_A',       'DEVOPS-UAT',  'CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  add_user('DEVOPS-UAT',  'DEV_B',       'DEVOPS-UAT',  'CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  add_user('DEVOPS-UAT',  'RELEASE_MGR', 'DEVOPS-UAT',  'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  -- Only the release manager can change the PROD simulation
  add_user('DEVOPS-PROD', 'RELEASE_MGR', 'DEVOPS_PROD', 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL');
  commit;
end;
/

prompt Workspace DEVOPS-PROD created; PoC accounts added.
