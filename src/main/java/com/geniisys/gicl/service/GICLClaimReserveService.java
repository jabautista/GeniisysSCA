/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Jan 26, 2012
 ***************************************************/
package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLClaimReserve;

public interface GICLClaimReserveService {
	
	/**
	 * Retrieves initial values for claim reserve screen.
	 * @param claimId
	 * @return values
	 * @throws SQLException
	 */
	Map<String,Object> getClaimReserveInitValues(HttpServletRequest request) throws SQLException;
	
	/**
	 * Get specific claim reserve
	 * @param claimId
	 * @param itemNo
	 * @return claim reserve
	 * @throws SQLException
	 */
	GICLClaimReserve getClaimReserve(HttpServletRequest request) throws SQLException;
	JSONObject getPreValidationParams(HttpServletRequest request) throws SQLException;
	void updateStatus(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> getAvailmentTotals(Map<String, Object> params) throws SQLException;
	String checkUWDist(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String redistributeReserve(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String checkLossRsrv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String gicls024OverrideExpense(HttpServletRequest request) throws SQLException;
	void createOverrideRequest(Map<String, Object> params) throws SQLException;
	String saveClaimReserve(HttpServletRequest request, String userId) throws SQLException;
	String gicls024ChckLossRsrv(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	String chckBkngDteExist(Integer claimId) throws SQLException;
	String gicls024OverrideCount(Integer claimId) throws SQLException;
	Map<String, Object> validateExistingDistGICLS024(HttpServletRequest request) throws SQLException;
	String redistributeReserveGICLS038(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String redistributeLossExpenseGICLS038(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void createOverrideBasicInfo(Map<String, Object> params) throws SQLException;
	
}