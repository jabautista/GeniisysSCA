/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.service
	File Name: GICLEvalDepDtlService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 10, 2012
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GICLEvalDepDtlService {
	Map<String, Object>getDepPayeeDtls(Integer evalId) throws SQLException;
	Map<String, Object>getEvalDepList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object>checkDepVat(Map<String, Object>params)throws SQLException;
	void saveDepreciationDtls(String strParameters, String userId)throws SQLException, JSONException;
	String applyDepreciation(Map<String, Object>params) throws SQLException;
}
