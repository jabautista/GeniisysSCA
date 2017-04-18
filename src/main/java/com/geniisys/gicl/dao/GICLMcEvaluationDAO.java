/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLMcEvaluationDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jan 16, 2012
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLMcEvaluation;
import com.geniisys.gicl.entity.GICLMcTpDtl;

public interface GICLMcEvaluationDAO {
	Map<String, Object> getClaimPolicyInfo(Map<String, Object>params) throws SQLException;
	Map<String,  Object> getVariables(Map<String, Object>params) throws SQLException;
	void saveMCEvaluationReport(Map<String, Object>params) throws SQLException;
	void updateMcEvaluationReport(Map<String, Object>params) throws SQLException;
	void cancelMcEvalreport(GICLMcEvaluation giclMcEval, String userId) throws SQLException;
	GICLMcTpDtl getGiclMcTpDtlVehicleInfo(Map<String, Object>params) throws SQLException;
	Map<String, Object> getGiclMotorCarDtlVehicleInfo(Map<String, Object>params)throws SQLException;
	String validateBeforePostMap(Map<String, Object>params)throws SQLException;
	void postEvalReport(Map<String, Object>params)throws SQLException;
	void createSettlementForReport(Map<String, Object>params) throws SQLException;
	String validateOverrideUserMcEval(Map<String, Object>params) throws SQLException;
	void updateEvalDepVatAmt(Map<String, Object> params) throws SQLException;
	void createSettlementForLossExpEvalReport(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object>popGiclMcEval(Map<String, Object>params) throws SQLException;
	Map<String, Object> checkEvalCSLOverrideRequestExist (Map<String, Object>params)throws SQLException;
	Map<String, Object> getMcItemPeril (Map<String, Object>params) throws SQLException;
}
