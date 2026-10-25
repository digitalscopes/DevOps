prompt --application/plugin_settings
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>587678005602845528
,p_default_application_id=>182
,p_default_id_offset=>0
,p_default_owner=>'DEVOPS-UAT'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587750429122078648)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_DISPLAY_SELECTOR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'include_slider', 'Y')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587750720791078648)
,p_plugin_type=>'DYNAMIC ACTION'
,p_plugin=>'NATIVE_OPEN_AI_ASSISTANT'
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587751012426078650)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_DATE_PICKER_APEX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_behavior', 'MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON',
  'days_outside_month', 'VISIBLE',
  'show_on', 'FOCUS',
  'time_increment', '15')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587751391972078650)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_GEOCODED_ADDRESS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'background', 'default',
  'display_as', 'LIST',
  'map_preview', 'POPUP:ITEM',
  'match_mode', 'RELAX_HOUSE_NUMBER',
  'show_coordinates', 'N')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587751680456078650)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_MAP_REGION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_vector_tile_layers', 'Y')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587751904384078650)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_BOSS'
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587752201348078650)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_ADFBC'
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587752502310078650)
,p_plugin_type=>'PROCESS TYPE'
,p_plugin=>'NATIVE_GEOCODING'
,p_attribute_01=>'RELAX_HOUSE_NUMBER'
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587752814949078651)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SINGLE_CHECKBOX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'checked_value', 'Y',
  'unchecked_value', 'N')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587753114541078651)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_IR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'actions_menu_structure', 'IG')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587753498924078651)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SELECT_MANY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_values_as', 'separated')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587753754815078651)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_COLOR_PICKER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'mode', 'FULL')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587754092751078651)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_STAR_RATING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'default_icon', 'fa-star',
  'tooltip', '#VALUE#')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(587754308308078651)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_YES_NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_style', 'SWITCH_CB',
  'off_value', 'N',
  'on_value', 'Y')).to_clob
,p_version_scn=>782919100
);
wwv_flow_imp.component_end;
end;
/
