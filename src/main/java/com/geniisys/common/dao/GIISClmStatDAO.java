package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISClmStatDAO {
	List<Map<String, Object>> getClmStatDtls(Map<String, Object> params) throws SQLException;
	String getClmStatDesc(String clmStatCd) throws SQLException;
	
	//Claim Status Maintenance
	JSONObject showClaimStatusMaintenance(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> saveClaimStatusMaintenance(Map<String, Object> params) throws SQLException;
	Map<String, Object> chkIfValidInput (Map<String, Object> params) throws SQLException;
}
