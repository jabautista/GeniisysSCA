/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLMcEvaluationDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jan 16, 2012
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.DAOImpl;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLMcEvaluationDAO;
import com.geniisys.gicl.entity.GICLMcEvaluation;
import com.geniisys.gicl.entity.GICLMcTpDtl;

public class GICLMcEvaluationDAOImpl extends DAOImpl implements GICLMcEvaluationDAO{
	private static Logger log = Logger.getLogger(GICLMcEvaluationDAOImpl.class);
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getClaimPolicyInfo(Map<String, Object> params)
			throws SQLException {
		log.info("Retrieving MC Policy Info..");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getClaimPolicyInfo", params);
	}
	@Override
	public Map<String, Object> getVariables(Map<String, Object> params)
			throws SQLException {
		log.info("Getting variables..");
		this.getSqlMapClient().update("getVariables", params);
		return params;
	}
	@SuppressWarnings("unchecked")
	@Override
	public void saveMCEvaluationReport(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Map<String, Object> newEval = (Map<String, Object>) params.get("newEval");
			Map<String, Object> mcMainObj = (Map<String, Object>) params.get("mcMainObj");
			Map<String, Object> extraParam = (Map<String, Object>) params.get("extraParam");
			Map<String, Object> varMcMainObj = (Map<String, Object>) params.get("varMcMainObj");
			GIISUser user = (GIISUser) params.get("user");
			String replaceAmt = (String) extraParam.get("replaceAmt");
			String repairAmt = (String) extraParam.get("repairAmt");
			
			if (extraParam.get("copyDtlFlag").equals("Y")) {
				log.info("Copying report of eval Id: "+ extraParam.get("evalMasterId"));
			}
			
			
			Map<String, Object> preInsertParams = new HashMap<String, Object>();
			log.info("Executing GICL_MC_EVALUATION BLK Pre Insert.");
			preInsertParams.put("userId", user.getUserId());
			preInsertParams.put("newRepFlag", extraParam.get("newRepFlag"));
			preInsertParams.put("copyDtlFlag", extraParam.get("copyDtlFlag"));
			preInsertParams.put("reviseFlag", extraParam.get("reviseFlag"));
			preInsertParams.put("issCd", mcMainObj.get("clmIssCd"));
			preInsertParams.put("sublineCd", mcMainObj.get("clmSublineCd"));
			preInsertParams.put("inspectDate", newEval.get("inspectDate"));
			preInsertParams.put("inspectPlace", newEval.get("inspectPlace")); //marco - 03.27.2014
			preInsertParams.put("adjusterId", newEval.get("adjusterId").equals("") || newEval.get("adjusterId") == null ? null : Integer.parseInt((String)newEval.get("adjusterId"))); //marco - 03.27.2014
			
			preInsertParams.put("evalMasterId", extraParam.get("evalMasterId").equals("")? null: Integer.parseInt((String) extraParam.get("evalMasterId")));
			preInsertParams.put("replaceAmt", replaceAmt.equals("")? null: new BigDecimal(replaceAmt));
			preInsertParams.put("repairAmt", repairAmt.equals("")? null: new BigDecimal(repairAmt));
			preInsertParams.put("evalStatCd", extraParam.get("evalStatCd"));
			preInsertParams.put("reportType", extraParam.get("reportType"));
		
			this.getSqlMapClient().update("mcEvalBlkPreInsert", preInsertParams);
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting to GICL_MC_EVALUATION table");
			preInsertParams.put("itemNo", mcMainObj.get("itemNo"));
			preInsertParams.put("claimId", mcMainObj.get("claimId"));
			preInsertParams.put("perilCd", mcMainObj.get("perilCd"));
			preInsertParams.put("plateNo", mcMainObj.get("plateNo").equals(null) ? "" : mcMainObj.get("plateNo"));
			preInsertParams.put("tpSw", mcMainObj.get("tpSw"));
			preInsertParams.put("payeeNo", mcMainObj.get("payeeNo").equals(null) ? "" : mcMainObj.get("payeeNo"));
			preInsertParams.put("payeeClassCd", mcMainObj.get("payeeClassCd").equals(null ) ? "" : mcMainObj.get("payeeClassCd"));
			preInsertParams.put("currencyCd", mcMainObj.get("currencyCd"));
			preInsertParams.put("currencyRate", mcMainObj.get("currencyRate"));
			preInsertParams.put("remarks", StringEscapeUtils.unescapeHtml((String) newEval.get("remarks")));
			//preInsertParams.put("adjusterId", newEval.get("adjusterId"));
			//preInsertParams.put("inspectPlace", newEval.get("inspectPlace"));
			
			log.info("pre insert params:" +preInsertParams);
			this.getSqlMapClient().insert("insertMcEval", preInsertParams);
			this.getSqlMapClient().executeBatch();
			
			// master blk key commit.
			//this.executeMasterBlkKeyCommit(mcMainObj, varMcMainObj, user.getUserId()); Commented out by robert, for update only
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
	@Override
	public void updateMcEvaluationReport(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("UPDATING MC EVAL");
			/* commented out by robert to properly handle special characters 04.24.2013
			params.put("remarks", StringEscapeUtils.escapeHtml((String) params.get("remarks")));
			params.put("inspectPlace", StringEscapeUtils.escapeHtml((String) params.get("inspectPlace")));*/
			this.getSqlMapClient().update("updateMcEvaluationReport",params);
			
			// master blk key commit
			System.out.println("robert    ::::::::::: "+params.get("evalId"));
			JSONObject jsonObj = (JSONObject) params.get("json");
			System.out.println(jsonObj);
			Map<String, Object> mcMainObj = JSONUtil.prepareMapFromJSON(new JSONObject(jsonObj.getString("mcMainObj")));
			Map<String, Object> varMcMainObj = JSONUtil.prepareMapFromJSON(new JSONObject(jsonObj.getString("varMcMainObj")));
			this.executeMasterBlkKeyCommit(mcMainObj, varMcMainObj, (String) params.get("userId"), (String) params.get("evalId"));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}catch(Exception e){
			
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	private void executeMasterBlkKeyCommit(Map<String, Object> mcMainObj, Map<String, Object> varMcMainObj,String userId, String evalId)throws SQLException{
		/*added evalId by robert*/
		log.info("EXECUTING MASTER BLK KEY COMMIT");
		Map<String, Object>params = new HashMap<String, Object>();
		System.out.println(mcMainObj);
		System.out.println(varMcMainObj);
		
		params.put("itemNo", varMcMainObj.containsKey("itemNo") ? varMcMainObj.get("itemNo") : mcMainObj.get("itemNo")); //modified by robert 04.20.2013 sr 12800
		params.put("plateNo", varMcMainObj.containsKey("plateNo") ? varMcMainObj.get("plateNo").equals(null) ? "" : varMcMainObj.get("plateNo") : ""); //modified by robert 04.20.2013 sr 12800
		params.put("tpSw", varMcMainObj.get("tpSw")); 
		params.put("perilCd", mcMainObj.get("perilCd")); //varMcMainObj.get("perilCd")); changed by robert 
		params.put("payeeClassCd", varMcMainObj.get("payeeClassCd").equals(null) ? "" : varMcMainObj.get("payeeClassCd"));
		params.put("payeeNo", varMcMainObj.get("payeeNo").equals(null) ? "" : varMcMainObj.get("payeeNo"));

		params.put("claimId", mcMainObj.get("claimId"));
		params.put("itemNoValue", mcMainObj.get("itemNo"));
		params.put("plateNoValue", mcMainObj.get("plateNo").equals(null) ? "" : mcMainObj.get("plateNo"));
		params.put("tpSwValue", mcMainObj.get("tpSw"));
		params.put("perilCdValue", mcMainObj.get("perilCd"));
		params.put("payeeClassCdValue", mcMainObj.get("payeeClassCd").equals(null ) ? "" : mcMainObj.get("payeeClassCd"));
		params.put("payeeNoValue",  mcMainObj.get("payeeNo").equals(null) ? "" : mcMainObj.get("payeeNo") );
		params.put("userId", userId);
		params.put("evalId", evalId);
		System.out.println("final params: "+params);
		getSqlMapClient().update("executeMasterBlkKeyCommit",params);
		getSqlMapClient().executeBatch();
	}
	@Override
	public void cancelMcEvalreport(GICLMcEvaluation giclMcEval, String userId)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> params = new HashMap<String, Object>();
			log.info("CANCELLING MC EVAL REPORT ID: "+giclMcEval.getEvalId());
			log.info("EVAL MASTER ID: "+giclMcEval.getEvalMasterId());
			params.put("userId", userId);
			params.put("evalId", giclMcEval.getEvalId());
			params.put("evalMasterId", giclMcEval.getEvalMasterId() == null ? "" : giclMcEval.getEvalMasterId());
			params.put("reportType", giclMcEval.getReportType());
			this.getSqlMapClient().update("cancelMcEvalreport",params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}	
		
	}
	@Override
	public GICLMcTpDtl getGiclMcTpDtlVehicleInfo(Map<String, Object> params)
			throws SQLException {
		log.info("GETTING VEHICLE INFO FROM GICL_MC_TP_DTL");
		return (GICLMcTpDtl) getSqlMapClient().queryForObject("getGiclMcTpDtlVehicleInfo",params);
		
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGiclMotorCarDtlVehicleInfo(
			Map<String, Object> params) throws SQLException {
		log.info("GETTING VEHICLE INFO FROM GICL_MOTOR_CAR_CAR_DTL");
		return (Map<String, Object>) getSqlMapClient().queryForObject("getGiclMotorCarDtlVehicleInfo", params);
	}
	@Override
	public String validateBeforePostMap(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING REPORT");
		log.debug(params);
		this.getSqlMapClient().update("validateBeforePostMap", params);
		return (String) params.get("pMessage");
	}
	@Override
	public void postEvalReport(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("POSTING REPORT OF EVALUATION ID: "+params.get("evalId"));
			this.getSqlMapClient().update("postEvalReport", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}
	@Override
	public void createSettlementForReport(Map<String, Object> params)
			throws SQLException {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("CREATING SETTLEMENT FOR EVAL ID: "+params.get("evalId"));
			System.out.println("settlement params: "+params);
			this.getSqlMapClient().update("createSettlementForReport", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public String validateOverrideUserMcEval(Map<String, Object> params)
			throws SQLException {
		log.info("vOverrideProc: "+params.get("vOverrideProc"));
		return (String) getSqlMapClient().queryForObject("validateOverrideUserMcEval", params);
	}
	@Override
	public void updateEvalDepVatAmt(Map<String, Object> params)
			throws SQLException {
		log.info("UPDATING VAT AND DEP OF EVAL ID:"+params.get("evalId"));
		getSqlMapClient().update("updateEvalDepVatAmt",params);
	}
	
	@Override
	public void createSettlementForLossExpEvalReport(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Creating Settlement Report from Loss Expense History with parameters: "+params);
			this.getSqlMapClient().update("createSettlementForLossExpEvalReport", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}
	@Override
	public Map<String, Object> popGiclMcEval(Map<String, Object> params)
			throws SQLException {
		getSqlMapClient().update("popGiclMcEval",params);
		return params;
	}
	@Override
	public Map<String, Object> checkEvalCSLOverrideRequestExist(
			Map<String, Object> params) throws SQLException {
		log.info("checking if override request is existing, params: "+params);
		getSqlMapClient().update("checkEvalCSLOverrideRequestExist", params);
		return params;
	}
	@Override
	public Map<String, Object> getMcItemPeril(Map<String, Object> params)
			throws SQLException {
		log.info("Getting peril information..");
		getSqlMapClient().update("getMcItemPeril",params);
		return params;
	}
	
}
