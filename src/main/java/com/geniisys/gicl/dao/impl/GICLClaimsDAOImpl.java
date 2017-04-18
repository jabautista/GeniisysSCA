/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 8, 2010
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.acegisecurity.userdetails.User;
import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.exceptions.SavingException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClaimsDAOImpl implements GICLClaimsDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLClaimsDAOImpl.class);
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getClaims(java.lang.Integer)
	 */
	@Override
	public GICLClaims getClaims(Integer claimId) throws SQLException {
		log.info("Retrieving Claims");
		return (GICLClaims)this.getSqlMapClient().queryForObject("getGiclClaimById", claimId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getRelatedClaims(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClaims> getRelatedClaims(HashMap<String, Object> params)throws SQLException {
		return this.getSqlMapClient().queryForList("getRelatedClaims",params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getClaimsTableGridListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getClaimsTableGridListing(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getClaimsTableGridListing2", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getLossRecoveryTableGridListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getLossRecoveryTableGridListing(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getLossRecoveryTableGridListing", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getClaimsBasicInfoDtls(java.lang.Integer)
	 */
	@Override
	public GICLClaims getClaimsBasicInfoDtls(Integer claimId) throws SQLException {
		return (GICLClaims) this.getSqlMapClient().queryForObject("getClaimsBasicInfoDtls", claimId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#initializeClaimsMenu(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> initializeClaimsMenu(Map<String, Object> params)	throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("initializeMenu", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getClmAssuredDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getClmAssuredDtls(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getClmAssuredDtlLOV", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#enableMenus(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> enableMenus(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("enableMenu", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#updateClaimsBasicInfo(java.util.Map)
	 */
	@Override
	public void updateClaimsBasicInfo(Map<String, Object> params) throws Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateClaimsBasicInfo", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#getBasicIntmDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBasicIntmDtls(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getBasicIntmDtls", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimsDAO#clmItemPreDelete(java.util.Map)
	 */
	@Override
	public void clmItemPreDelete(Map<String, Object> params)
			throws SQLException {
		log.info("Pre-delete in claim item information :: claim id = "+params.get("claimId")+" / item no = "+params.get("itemNo"));
		this.sqlMapClient.delete("delGiclItemPeril", params);
		this.sqlMapClient.delete("delGiclMortgagee", params);
		this.sqlMapClient.delete("delGiclItemBeneficiary", params);
	}

	@Override
	public GICLClaims getClaimInfo(Integer claimId) throws SQLException {
		return (GICLClaims) this.getSqlMapClient().queryForObject("getClaimInfo", claimId);
	}

	@Override
	public void clmItemPostFormCommit(Map<String, Object> params)
			throws SQLException {
		log.info("Post form commit...");
		this.sqlMapClient.update("clmItemPostFormCommit", params);
	}

	@Override
	public Map<String, Object> checkClaimPlateNo(Map<String, Object> params)
			throws SQLException {
		log.info("CHECKING PLATE NO: "+params.get("plateNo"));
		log.info("loss date : "+params.get("dspLossDate"));
		this.getSqlMapClient().update("checkClaimPlateNo", params);
		return params;
	}

	@Override
	public Map<String, Object> checkClaimMotorNo(Map<String, Object> params)
			throws SQLException {
		log.info("CHECKING MOTOR NO: "+params.get("motorNo"));
		log.info("loss date : "+params.get("dspLossDate"));
		this.getSqlMapClient().update("checkClaimMotorNo", params);
		return params;
	}

	@Override
	public Map<String, Object> checkClaimSerialNo(Map<String, Object> params)
			throws SQLException {
		log.info("CHECKING Serial NO: "+params.get("serialNo"));
		log.info("loss date : "+params.get("dspLossDate"));
		this.getSqlMapClient().update("checkClaimSerialNo", params);
		return params;
	}

	@Override
	public String checkClaimStatus(String lineCode, String sublineCd,
			String issueCode, Integer claimYy, Integer claimSequenceNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCode", lineCode);
		params.put("sublineCd", sublineCd);
		params.put("issueCode", issueCode);
		params.put("claimYy", claimYy);
		params.put("claimSequenceNo", claimSequenceNo);
		this.sqlMapClient.update("checkClaimStatus", params);
		log.info("Checking claims status : "+params);
		return (String) params.get("msgAlert");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClaims> getBasicClaimDtls(HashMap<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBasicClaimDtls", params);
	}

	@Override
	public Map<String, Object> validateClmPolicyNo(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateClmPolicyNo", params);
		return params;
	}

	@Override
	public Map<String, Object> chkItemForTotalLoss(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("chkItemForTotalLoss", params);
		return params;
	}

	@Override
	public Map<String, Object> checkExistingClaims(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkExistingClaims", params);
		return params;
	}

	@Override
	public String checkTotalLossSettlement(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkTotalLossSettlement", params);
	}

	@Override
	public Map<String, Object> validatePlateMotorSerialNo(Map<String, Object> params)
			throws SQLException {
		if ("PLATE_NO".equals((String) params.get("param1"))){
			this.sqlMapClient.update("validatePlateNoGICLS010", params);
		}else if ("MOTOR_NO".equals((String) params.get("param1"))){
			this.sqlMapClient.update("validateMotorNoGICLS010", params);
		}else if ("SERIAL_NO".equals((String) params.get("param1"))){
			this.sqlMapClient.update("validateSerialNoGICLS010", params);
		}
		return params;
	}

	@Override
	public Map<String, Object> checkLossDateTime(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkLossDateTimeGICLS010", params);
		return params;
	}

	@Override
	public String getSublineTime(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getSublineTime", params);
	}

	@Override
	public Map<String, Object> validateLossDatePlateNo(
			Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validateLossDatePlateNo", params);
		return params;
	}

	@Override
	public Map<String, Object> validateLossTime(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateLossTime", params);
		return params;
	}

	@Override
	public Map<String, Object> claimCheck(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkClaimGICLS010", params);
		return params;
	}

	@Override
	public Map<String, Object> validateCatastrophicCode(
			Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validateCatastrophicCode", params);
		return params;
	}

	@Override
	public Map<String, Object> getCheckLocationDtl(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getCheckLocationDtl", params);
		return params;
	}
	
	@Override
	public void deleteWorkflowRec3(String eventDesc, String moduleId, String userId, Object colValue) throws SQLException{
		log.info("Deleting workflow...");
		Map<String, Object> delWorkflow = new HashMap<String, Object>();
		delWorkflow.put("userId", userId);
		delWorkflow.put("eventDesc", eventDesc);
		delWorkflow.put("moduleId", moduleId);
		delWorkflow.put("colValue", colValue);
		this.sqlMapClient.update("deleteWorkflowRec3", delWorkflow);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveGICLS010(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Claim Basic Information.");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List <Map<String,Object>> procs = (List <Map<String,Object>>) params.get("procs");
			GICLClaims basic = (GICLClaims) params.get("basicInfo");
			params.put("claimId", basic.getClaimId());
			params.put("lineCd", basic.getLineCode());
			params.put("sublineCd", basic.getSublineCd());
			params.put("polIssCd", basic.getPolicyIssueCode());
			params.put("issueYy", basic.getIssueYy());
			params.put("polSeqNo", basic.getPolicySequenceNo());
			params.put("renewNo", basic.getRenewNo());
			params.put("lossDate", basic.getLossDate());
			params.put("polEffDate", basic.getPolicyEffectivityDate());
			params.put("expiryDate", basic.getExpiryDate());
			params.put("dspLossDate", basic.getDspLossDate());
			params.put("dspLossTime", basic.getDspLossTime());
			params.put("nbtClmStatCd", basic.getNbtClmStatCd());
			params.put("checkNoAlert", null);
			
			if ("N".equals(params.get("checkNoClaimSw"))){
				log.info("Checking no claims..."+params);
				this.sqlMapClient.update("checkNoClaim", params);
				if (params.get("checkNoAlert") != null){
					throw new SavingException((String) params.get("checkNoAlert"));
				}
			}
			
			String insClmItemAndPerilSU = "";
			String insertClaimMortgagee = ""; //added by robert 11.26.2013
			for (Map<String, Object> func: procs){
				if ("deleteWorkflowRec".equals(func.get("name"))){
					this.deleteWorkflowRec3("CLAIMS WITH UNPAID PREMIUM PROCESSING", "GICLS010",(String) params.get("userId"), basic.getClaimId());
					this.getSqlMapClient().executeBatch();
					/*}else if ("createWorkflowRec".equals(func.get("name"))){
					log.info("Creating workflow...");
					this.sqlMapClient.update("validateUnpaidPremGICLS010", params);
					this.getSqlMapClient().executeBatch();
					if (params.get("msgAlert") != null){
						throw new Exception((String) params.get("msgAlert"));
					}*/
				}else if ("clearItemPerilFunc".equals(func.get("name"))){
					log.info("Deleting item & peril...");
					this.sqlMapClient.update("clearClmItemPeril", params);
					this.getSqlMapClient().executeBatch();
					if (params.get("msgAlert") != null){
						throw new Exception((String) params.get("msgAlert"));
					}
				}else if ("insClmItemAndItemPeril".equals(func.get("name"))){
					//log.info("Inserting item & peril...");
					insClmItemAndPerilSU = "Y"; // moved adter claim basic has been saved, error caused by null claim Id, in CS, there is a commit command on onOkProcessing checkbox. - irwin 
					//this.sqlMapClient.insert("insClmItemAndPeril", basic);
					//this.getSqlMapClient().executeBatch();
				}else if ("insertClaimMortgagee".equals(func.get("name"))){
					insertClaimMortgagee = "Y"; // added by robert 11.26.2013 -- moved after claim basic has been saved, error caused by null claim Id
					/*log.info("Inserting mortgagee...");
					params.put("itemNo", "0");
					this.sqlMapClient.delete("delGiclMortgagee", params);
					this.getSqlMapClient().executeBatch();
					
					this.sqlMapClient.insert("insertClaimMortgagee", params);
					this.getSqlMapClient().executeBatch();*/
				}
			}
			
			if (basic.getClaimId() == null){
				log.info("Inserting gicl_claims...");
				//insert new record
				Integer claimId = (Integer) this.getSqlMapClient().queryForObject("createClaimId");
				params.put("claimId", claimId);
				basic.setClaimId(claimId);
				System.out.println(basic.getLossDate()+" === "+basic.getDspLossDate()+" === "+basic.getExpiryDate());
				this.getSqlMapClient().insert("setNewGiclClaims", basic);
				this.getSqlMapClient().executeBatch();
				
				//post-insert trigger
				this.getSqlMapClient().update("postInsGICLS010", params);
				this.getSqlMapClient().executeBatch();
				if (params.get("msgAlert") != null){
					throw new Exception((String) params.get("msgAlert"));
				}
				
				if(insClmItemAndPerilSU.equals("Y")){
					log.info("Inserting item & peril...");
					this.sqlMapClient.insert("insClmItemAndPeril", basic);
					this.getSqlMapClient().executeBatch();
				}
				
				if(insertClaimMortgagee.equals("Y")){ //added by robert 11.26.2013
					log.info("Inserting mortgagee...");
					params.put("itemNo", "0");
					this.sqlMapClient.delete("delGiclMortgagee", params);
					this.getSqlMapClient().executeBatch();
					
					this.sqlMapClient.insert("insertClaimMortgagee", params);
					this.getSqlMapClient().executeBatch();
				}
				
				params.put("itemNo", "0");
				this.sqlMapClient.delete("delGiclMortgagee", params);
				this.getSqlMapClient().executeBatch();
				
				this.sqlMapClient.insert("insertClaimMortgagee", params);
				this.getSqlMapClient().executeBatch();
			}else{
				//update record
				log.info("Updating gicl_claims...");
				System.out.println(basic.getLossDate()+" === "+basic.getDspLossDate()+" === "+basic.getExpiryDate());
				this.getSqlMapClient().insert("setGiclClaims", basic);
				this.getSqlMapClient().executeBatch();
				//robert --03.07.2013 sr12375
				if(insClmItemAndPerilSU.equals("Y")){
					log.info("Inserting item & peril...");
					this.sqlMapClient.insert("insClmItemAndPeril", basic);
					this.getSqlMapClient().executeBatch();
				}
				//-- END robert
				
				if(insertClaimMortgagee.equals("Y")){ //added by robert 11.26.2013
					log.info("Inserting mortgagee...");
					params.put("itemNo", "0");
					this.sqlMapClient.delete("delGiclMortgagee", params);
					this.getSqlMapClient().executeBatch();
					
					this.sqlMapClient.insert("insertClaimMortgagee", params);
					this.getSqlMapClient().executeBatch();
				}
				
			}
			
			for (Map<String, Object> func: procs){
				if ("createWorkflowRec".equals(func.get("name"))){
					log.info("Creating workflow...");
					this.sqlMapClient.update("validateUnpaidPremGICLS010", params);
					this.getSqlMapClient().executeBatch();
					if (params.get("msgAlert") != null){
						throw new Exception((String) params.get("msgAlert"));
					}
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("message", "SUCCESS");
		}catch(SavingException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e) {
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Claim Basic Information.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String checkPrivAdjExist(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPrivAdjExist", params);
	}

	@Override
	public void refreshClaims(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("refreshClaims", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getUpdateLossRecoveryTagListing(
			Map<String, Object> params) throws SQLException {
		log.info("Retrieving Update Loss Recovery Tag Listing");
		return this.getSqlMapClient().queryForList("getUpdateLossRecoveryTagListing");
	}

	@Override
	public void updateLossTagRecovery(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> claims = (List<Map<String, Object>>) params.get("claims");
			for (Map<String, Object> c : claims) {
				c.put("userId", params.get("userId"));
				log.info("UPDATING LOSS RECOVERY TAG OF CLAIM ID: "+c.get("claimId"));
				log.info("TAG: " +c.get("recoverySw"));	
				this.getSqlMapClient().update("updateLossTagRecovery",c);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> checkUnpaidPremiums(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("Check unpaid premiums parameters before: "+params);
		this.sqlMapClient.update("checkUnpaidPremiums", params);
		log.info("After: "+params);
		return params;
	}

	@Override
	public Map<String, Object> checkUnpaidPremiums2(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("Check unpaid premiums parameters before: "+params);
		this.sqlMapClient.update("checkUnpaidPremiums2", params);
		log.info("After: "+params);
		return params;
	}

	@Override
	public Map<String, Object> getRecoveryAmounts(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getRecoveryAmountsGICLS010", params);
		return params;
	}

	@Override
	public Map<String, Object> checkClaimReqDocs(Integer claimId)
			throws SQLException {
		log.info("checking required docs, claim Id: "+claimId);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", claimId);
		this.sqlMapClient.update("checkClaimReqDocs", params);
		return params;
	}

	@Override
	public GICLClaims getRelatedClaimsGICLS024(Integer claimId)
			throws SQLException {
		log.info("Retrieving GICLS024 Claims");
		return (GICLClaims)this.getSqlMapClient().queryForObject("getRelatedClaimsGICLS024", claimId);
	}

	@Override
	public String validateRenewNoGIACS007(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateRenewNoGIACS007", params);
	}
	
	public Map<String, Object> checkUserFunction(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("Check unpaid premiums parameters before: "+params);
		this.sqlMapClient.update("checkUserFunction", params);
		log.info("After: "+params);
		return params;
	}

	@Override
	public String validateLineCd(Map<String, Object> params) 
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateLineCd", params);
	}

	@Override
	public String validatePolIssCd(Map<String, Object> params) 
			throws SQLException {
		log.info("Retrieving Validate PolIssCd Params: "+params);
		return (String) this.sqlMapClient.queryForObject("gicls010ValidatePolIssCd", params);
	}

	@Override
	public String validateSublineCd(Map<String, Object> params)
			throws SQLException {
		log.info("Retrieving Validate SublineCd Params: "+params);
		return (String) this.sqlMapClient.queryForObject("gicls010ValidateSublineCd", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveBatchClaimCLosing(Map<String, Object> parameters)
			throws Exception {
		try{
			List<GICLClaims> insParams =  (List<GICLClaims>) parameters.get("insParams");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
				
			if(insParams != null){
				GICLClaims batchClaimClosingList = null;
				for(GICLClaims batchClaims: insParams){
					batchClaimClosingList = new GICLClaims();
					batchClaimClosingList.setClaimId(batchClaims.getClaimId());
					batchClaimClosingList.setLastUpdate(batchClaims.getUserLastUpdate());
					batchClaimClosingList.setUserId(batchClaims.getUserId());
					batchClaimClosingList.setRemarks(batchClaims.getRemarks());
					batchClaimClosingList.setReasonCode(batchClaims.getReasonCode()); //kenneth 11.05,2015 SR 5147
					System.out.println("saveBatchClaimClosing Params " + batchClaimClosingList.toString());
					this.getSqlMapClient().insert("saveBatchClaimCLosing", batchClaimClosingList);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String checkClaimToOpen(Integer claimId) throws SQLException {
		log.info("checkClaimToOpen");
		return (String) this.getSqlMapClient().queryForObject("checkClaimToOpen", claimId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClaims> getObjClaimClosingList(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("getObjClaimClosingList: "+params);
		return this.sqlMapClient.queryForList("getClaimClosingList", params);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> openClaims(Map<String, Object> parameters)
			throws SQLException, Exception {
		System.out.println("openClaims params: " + parameters);
		List<GICLClaims> objParams =  (List<GICLClaims>) parameters.get("insParams");
		Map<String, Object> params =new HashMap<String, Object>();
		
		if(objParams != null){
			for(GICLClaims claimClosing: objParams){
				params.put("claimId", claimClosing.getClaimId());
				params.put("lossDate", claimClosing.getLossDate());
				this.getSqlMapClient().update("openClaims", params);
			}
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	public void reOpenClaimsGICLS039(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			List<GICLClaims> insParams =  (List<GICLClaims>) params.get("insParams");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(insParams != null){
				Map<String, Object> params3 = new HashMap<String, Object>();
				for(GICLClaims batchClaims: insParams){
					params3.put("claimId", batchClaims.getClaimId());
					params3.put("lineCd", batchClaims.getLineCd());
					params3.put("sublineCd", batchClaims.getSublineCd());
					params3.put("polIssCd", batchClaims.getPolIssCd());
					params3.put("issueYy", batchClaims.getIssueYy());
					params3.put("policySequenceNo", batchClaims.getPolicySequenceNo());
					params3.put("renewNo", batchClaims.getRenewNo());
					params3.put("policyEffectivityDate", batchClaims.getPolicyEffectivityDate());
					params3.put("expiryDate", batchClaims.getExpiryDate());
					params3.put("dspLossDate", batchClaims.getDspLossDate());
					params3.put("clmFileDate", batchClaims.getClaimFileDate());
					params3.put("catastrophicCode", batchClaims.getCatastrophicCode());
					params3.put("userId", batchClaims.getUserId());
					this.getSqlMapClient().insert("redistributeReserveGICLS039", params3);
				}
			}
			
			if(insParams != null){
				Map<String, Object> params2 =new HashMap<String, Object>();
				for(GICLClaims batchClaims: insParams){
					params2.put("claimId", batchClaims.getClaimId());
					params2.put("refreshSw", batchClaims.getRefreshSw());
					params2.put("maxEndorsementSequenceNumber", batchClaims.getMaxEndorsementSequenceNumber());
					params2.put("dspLossDate", batchClaims.getDspLossDate());
					params2.put("policyEffectivityDate", batchClaims.getPolicyEffectivityDate());
					params2.put("lineCd", batchClaims.getLineCd());
					params2.put("sublineCd", batchClaims.getSublineCd());
					params2.put("polIssCd", batchClaims.getPolIssCd());
					params2.put("issueYy", batchClaims.getIssueYy());
					params2.put("policySequenceNo", batchClaims.getPolicySequenceNo());
					params2.put("renewNo", batchClaims.getRenewNo());
					params2.put("assdNo", batchClaims.getAssuredNo());
					params2.put("acctOfCd", batchClaims.getAccountOfCode());
					params2.put("assuredName", batchClaims.getAssuredName());
					params2.put("assdName2", batchClaims.getAssuredName2());
					params2.put("userId", batchClaims.getUserId());
					System.out.println("reOpen Params " + params2);
					this.getSqlMapClient().insert("reOpenGICLS039", params2);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}


	@Override
	public Map<String, Object> confirmUserGICLS039(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("Retrieving confirmUserGICLS039 Params: "+params);
		this.getSqlMapClient().update("confirmUserGICLS039", params);
		log.info("AFTER confirmUserGICLS039 Params: "+params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public String denyWithdrawCancelClaims(Map<String, Object> params)
			throws SQLException, Exception {
		Map<String, Object> params2 =new HashMap<String, Object>();
		try{
			List<GICLClaims> insParams =  (List<GICLClaims>) params.get("insParams");
			String statusControl = (String) params.get("statusControl");
			
			System.out.println("denyWithdrawCancelClaims statusControl: " + statusControl);
			String query = statusControl.equals("DN") ? "denyClaimsGICLS039": statusControl.equals("WD") ? "withdrawClaimsGICLS039": "cancelClaimsGICLS039";
					
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			System.out.println("denyWithdrawCancelClaims: " + params);
			System.out.println("query: " + query);
			if(insParams != null ){
				for(GICLClaims batchClaims: insParams){
					params2.put("claimId", batchClaims.getClaimId());
					params2.put("catastrophicCd", batchClaims.getCatastrophicCd() == null ? "" : batchClaims.getCatastrophicCd());
					params2.put("lineCd", batchClaims.getLineCode());
					params2.put("sublineCd", batchClaims.getSublineCd());
					params2.put("issCd", batchClaims.getIssCd());
					params2.put("clmYy", batchClaims.getClaimYy());
					params2.put("claimSequenceNo", batchClaims.getClaimSequenceNo());
					params2.put("clmStatCd", batchClaims.getClaimStatusCd());
					params2.put("catPaytResFlag", "");
					params2.put("userId", batchClaims.getUserId());
					System.out.println("DWCClaims Params " + params2);
					this.getSqlMapClient().update(query, params2);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return (String) params2.get("alertMessage");
		}catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> checkClaimClosing(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("checkClaimClosing pre: "+params);
		this.sqlMapClient.update("checkClaimClosing", params);
		log.info("checkClaimClosing post: "+params);
		return params;
	}

	@Override
	public Map<String, Object> validateFlaGICLS039(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("validateFlaGICLS039 pre: "+params);
		this.sqlMapClient.update("validateFlaGICLS039", params);
		log.info("validateFlaGICLS039 post: "+params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String closeClaims(Map<String, Object> params) throws SQLException,
			Exception {
		Map<String, Object> params2 =new HashMap<String, Object>();
		try{
			List<GICLClaims> insParams =  (List<GICLClaims>) params.get("insParams");

			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			if(insParams != null ){
				for(GICLClaims batchClaims: insParams){
					params2.put("claimId", batchClaims.getClaimId());
					params2.put("lineCd", batchClaims.getLineCode());
					params2.put("remarks", batchClaims.getRemarks());
					params2.put("recoverySw", batchClaims.getRecoverySw());
					params2.put("closedStatus", params.get("closedStatus"));
					params2.put("userId", batchClaims.getUserId());
					System.out.println("closeClaims Params " + params2);
					//this.getSqlMapClient().update("closeClaimsGICLS039", params2);
					this.getSqlMapClient().update("closeClaimsGICLS0392", params2);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return (String) params2.get("alertMessage");
		}catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGiclClaim()
			throws SQLException, Exception {
		return (Map<String, Object>) this.getSqlMapClient().queryForList("getGiclClaim");
	}

	@Override
	public GICLClaims getGICLS260BasicInfoDetails(
			Map<String, Object> params) throws SQLException, Exception {
		return (GICLClaims) this.getSqlMapClient().queryForObject("getClaimInfoBasicDetails", params);
	}

	@Override
	public Map<String, Object> initializeGICLS260Variables(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("initializeGICLS260Variables", params);
		log.info("initialize GICLS260 Variables: "+params);
		return params;
	}

	@Override
	public Map<String, Object> gicls125ReopenRecovery(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gicls125ReopenRecovery", params);
		return params;
	}

	@Override
	public void validateGiacParameterStatus(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateGiacParameterStatus", params);
	}

	@Override
	public String validateGICLS010Line(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateGICLS010Line", params);
	}
	
	@Override
	public String checkSharePercentage(Map<String, Object> params)
			throws SQLException {
		log.info("Checking share percentage...");
		return (String) this.getSqlMapClient().queryForObject("checkSharePercentage", params);
	}
	
	public List<String> getClaimItemAttachments(Map<String, Object> params) throws SQLException {
		List<String> attachments = new ArrayList<String>();
		
		attachments = this.getSqlMapClient().queryForList("getClaimItemAttachments", params);
		
		return attachments;
	}
	
	public void deleteClaimItemAttachments(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.delete("deleteClaimItemAttachments", params);
	}
}