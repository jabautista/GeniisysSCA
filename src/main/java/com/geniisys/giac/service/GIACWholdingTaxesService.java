package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACWholdingTaxesService {

	/**
	 * Executes WHEN-VALIDATE-ITEM trigger of WHTAX_CODE in GIACS022 
	 * @param params
	 * @throws SQLException
	 */
	void validateGiacs022WhtaxCode(Map<String, Object> params) throws SQLException;
	/**
	 * Executes WHEN-VALIDATE-ITEM trigger of ITEM_NO in GIACS022 
	 * @param params
	 * @throws SQLException
	 */
	String validateItemNo(Map<String, Object> params) throws SQLException;
	JSONObject showGiacs318(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteWhtax(HttpServletRequest request) throws SQLException;
	void saveGiacs318(HttpServletRequest request, String userId) throws SQLException, JSONException;	
	JSONObject showAllGiacs318(HttpServletRequest request, String userId)throws SQLException, JSONException;
}
