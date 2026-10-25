prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>587678005602845528
,p_default_application_id=>182
,p_default_id_offset=>0
,p_default_owner=>'DEVOPS-UAT'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(587755705806078653)
,p_name=>'Navigation Menu'
,p_list_status=>'PUBLIC'
,p_version_scn=>782928416
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(587767544618078670)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(587778393134082012)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Projects'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-table'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2,3'
);
wwv_flow_imp.component_end;
end;
/
