/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLMcEvaluationService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jan 16, 2012
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLMcEvaluation;
import com.geniisys.gicl.entity.GICLMcTpDtl;

public interface GICLMcEvaluationService {
	Map<String, Object> getClaimPolicyInfo(Map<String, Object>params) throws SQLException;
	Map<String, Object> getMcEvaluationTGList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException ;
	Map<String,  Object> getVariables(Map<String, Object>params) throws SQLException;
	void saveMCEvaluationReport(JSONObject jsonObj, GIISUser USER) throws SQLException, JSONException;
	void updateMcEvaluationReport(Map<String, Object> params) throws SQLException;  
	void cancelMcEvalreport(GICLMcEvaluation giclMcEval, String userId) throws SQLException;
	GICLMcTpDtl getGiclMcTpDtlVehicleInfo(Map<String, Object>params) throws SQLException;
	Map<String, Object> getGiclMotorCarDtlVehicleInfo(Map<String, Object>params)throws SQLException;
	String validateBeforePostMap(Map<String, Object>params)throws SQLException;
	void postEvalReport(Map<String, Object>params)throws SQLException;
	void createSettlementForReport(Map<String, Object> params)throws SQLException;
	String validateOverrideUserMcEval(Map<String, Object>params) throws SQLException;
	void updateEvalDepVatAmt(Map<String, Object> params) throws SQLException;
	void createSettlementForLossExpEvalReport(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object>popGiclMcEval(Map<String, Object>params) throws SQLException;
	Map<String, Object>checkEvalCSLOverrideRequestExist(Map<String, Object>params) throws SQLException;
	Map<String, Object>getMcItemPeril(Map<String, Object> params) throws SQLException;
}
