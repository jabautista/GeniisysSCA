/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 9, 2010
 ***************************************************/
package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLAdvice;

public interface GICLAdviceService {
	/**
	 * Retrieve a GICLAdvice from database using its adviceId
	 * @param adviceId
	 * @return a GICLAdvice
	 */
	GICLAdvice getGICLAdvice(Integer adviceId) throws SQLException;
	Map<String, Object> getGiacs086AdviseList(HttpServletRequest request, GIISUser user)throws SQLException, JSONException;
	JSONObject showGICLAdvice(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject gicls032EnableDisableButtons(HttpServletRequest request,	String userId) throws SQLException;
	void gicls032CancelAdvice(HttpServletRequest request, String userId) throws SQLException;
	String gicls032GenerateAdvice(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void gicls032ApproveCsr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void gicls032GenerateAcc(HttpServletRequest request, String userId)	throws SQLException;
	void gicls032SaveRemarks(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject gicls032ComputeAmounts(HttpServletRequest request) throws JSONException;
	Integer gicls032CheckRequestExists(HttpServletRequest request) throws SQLException;
	void gicls032CreateOverrideRequest(HttpServletRequest request, String userId) throws SQLException;
	void gicls032CheckTsi(HttpServletRequest request, String userId) throws SQLException;
	String checkGeneratedFla(Map<String, Object> params) throws SQLException;
	JSONObject gicls032WhenCurrencyChanged(HttpServletRequest request) throws JSONException;
	Map<String, Object> getGICLS260Advice(Map<String, Object> params) throws SQLException;
	
}
