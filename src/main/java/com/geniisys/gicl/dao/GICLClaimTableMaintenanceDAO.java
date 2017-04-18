/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	Fons
 * Create Date	:	05.03.2013
 ***************************************************/
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GICLClaimTableMaintenanceDAO {	
	//Claim Payee
	JSONObject getClaimPayeeClass(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject getClaimPayeeInfo(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject getBankAcctHstryField(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject getBankAcctHstryValue(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject getBankAcctApprovals(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateMobileNo (Map<String, Object> params) throws SQLException;
	Map<String, Object> validateUserFunc (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveGicls150(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveBankAcctDtls(Map<String, Object> params) throws SQLException;	
	Map<String, Object> approveBankAcctDtls(Map<String, Object> params) throws SQLException;	
	Map<String, Object> getBankAcctDtls (Map<String, Object> params) throws SQLException;
}

