package com.geniisys.giri.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIRIFrpsRiService {
	
	HashMap<String, Object> getFrpsRiParams(HashMap<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> checkBinderGiuts004(Map<String, Object> params) throws SQLException;
	Map<String, Object> performReversalGiuts004(Map<String, Object> params) throws SQLException;
	void getGiriFrpsRiGrid3(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String reversePackageBinder(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String generatePackageBinder(HttpServletRequest request, GIISUser USER) throws Exception;
	void groupBinders(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void ungroupBinders(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Integer getOutFaculTotAmtGIUTS004(Map<String, Object> params) throws SQLException;
	String checkBinderWithClaimsGIUTS004(Map<String, Object> params) throws SQLException;
}
