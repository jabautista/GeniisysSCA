/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	Fons
 * Create Date	:	05.03.2013
 ***************************************************/
package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;

public interface GICLClaimTableMaintenanceService {
	//Claim Status
	JSONObject showMenuClaimPayeeClass (HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showMenuClaimPayeeInfo (HttpServletRequest request, String payeeClassCd) throws SQLException, JSONException;
	JSONObject getBankAcctHstryField	(HttpServletRequest request) throws SQLException, JSONException;	
	JSONObject getBankAcctHstryValue	(HttpServletRequest request) throws SQLException, JSONException;	
	JSONObject showBankAcctApprovals (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateMobileNo (HttpServletRequest request) throws SQLException;
	Map<String, Object> validateUserFunc (HttpServletRequest request, GIISUser USER) throws SQLException;	
	Map<String, Object> saveGicls150(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> saveBankAcctDtls(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> approveBankAcctDtls(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> getBankAcctDtls (HttpServletRequest request) throws SQLException;
}
