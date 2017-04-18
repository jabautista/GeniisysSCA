package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

import org.json.JSONException;

public interface GICLCasualtyDtlService {
	
	void getGiclCasualtyDtlGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String validateClmItemNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String saveClmItemCasualty(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	void getPersonnelGrid(HttpServletRequest request, GIISUser USER) throws SQLException,JSONException, ParseException;
	/*String savePersonnel(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;*/
	String getCasualtyGroupedItemTitle(Map<String, Integer> params) throws SQLException;
	Map<String, Object> validateGroupItemNo(Map<String, Object>params) throws SQLException;
	Map<String, Object> validatePersonnelNo(Map<String, Object>params) throws SQLException;
	
}
