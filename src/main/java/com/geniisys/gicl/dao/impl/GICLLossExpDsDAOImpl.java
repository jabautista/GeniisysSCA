package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLLossExpDsDAO;
import com.geniisys.gicl.entity.GICLCatDtl;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.entity.GICLLossExpDtl;
import com.geniisys.gicl.exceptions.LossExpDistException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossExpDsDAOImpl implements GICLLossExpDsDAO{
	
	/** The log. */
	private static Logger log = Logger.getLogger(GICLLossExpDsDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Map<String, Object> checkXOL(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkXOL", params);
		log.info("Check XOL parameters: " +params);
		return params;
	}

	@Override
	public String distributeLossExpHistory(Map<String, Object> params)
			throws SQLException, Exception {
		
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GICLClaims claim = (GICLClaims) this.getSqlMapClient().queryForObject("getClaimsBasicInfoDtls", params.get("claimId"));
			Integer clmDistNo = (Integer) this.getSqlMapClient().queryForObject("getMaxClmDistNo", params);
			String userId = (String) params.get("userId");
			String distRG = (String) params.get("distRG");
			String distSw = (String) params.get("distSw");
			String msgAlert = "";
			
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("userId", userId);
			paramMap.put("v1ClaimId", params.get("claimId"));
			paramMap.put("v1ClmLossId", params.get("clmLossId"));
			paramMap.put("v1ItemNo", params.get("itemNo"));
			paramMap.put("v1PerilCd", params.get("perilCd"));
			paramMap.put("v1GroupedItemNo", params.get("groupedItemNo"));
			paramMap.put("v1HistSeqNo", params.get("histSeqNo"));
			paramMap.put("claimId", claim.getClaimId());
			paramMap.put("clmLossId", params.get("clmLossId"));
			paramMap.put("polEffDate", claim.getPolicyEffectivityDate());
			paramMap.put("expiryDate", claim.getExpiryDate());
			paramMap.put("lossDate", claim.getLossDate());
			paramMap.put("lineCd", claim.getLineCode());
			paramMap.put("sublineCd", claim.getSublineCd());
			paramMap.put("polIssCd", claim.getPolicyIssueCode()); //change by steven 11/15/2012 from: claim.getIssCd()   to:claim.getPolicyIssueCode() 
			paramMap.put("issueYy", claim.getIssueYy());
			paramMap.put("polSeqNo", claim.getPolicySequenceNo());
			paramMap.put("renewNo", claim.getRenewNo());
			paramMap.put("maxEndtSeqNo", claim.getMaxEndorsementSequenceNumber());
			paramMap.put("catastrophicCd", claim.getCatastrophicCode());
			paramMap.put("nbtDistDate", params.get("nbtDistDate"));
			paramMap.put("payeeCd", params.get("payeeCd"));
			paramMap.put("payeeType", params.get("payeeType"));
			paramMap.put("clmDistNo", clmDistNo);
			log.info("Distribute Loss Expense History Parameters: " + paramMap);
			
			this.checkDeductibles(paramMap);
			
			msgAlert = (String) this.getSqlMapClient().queryForObject("validateExistDistGicls030", paramMap);
			
			if(!msgAlert.equals("") && !msgAlert.equals("EMPTY")){
				log.info("Message Alert: " + msgAlert);
				throw new LossExpDistException(msgAlert);
			}
			
			log.info("Distribution=" + distRG +" and distSw="+distSw);
			
			if(distRG.equals("1")){
				if(distSw.equals("N")){
					log.info("Executing DISTRIBUTE_LOSS_EXP...");
					this.getSqlMapClient().update("distributeLossExp", paramMap);
					this.getSqlMapClient().executeBatch();
				}
			}else if(distRG.equals("2")){
				String distByRiskLoc = (String) this.getSqlMapClient().queryForObject("getDistByRiskLoc", params);
				log.info("DistByRiskLoc = " + distByRiskLoc);
				
				if(distByRiskLoc.equals("Y") && distSw.equals("N")){
					log.info("Executing DIST_BY_RESERVE_RISK_LOC...");
					paramMap.put("clmDistNo", clmDistNo+1);
					this.getSqlMapClient().update("distByReserveRiskLoc", paramMap);
					this.getSqlMapClient().executeBatch();
				}else if(distSw.equals("N")){
					log.info("Executing DISTRIBUTE_BY_RESERVE...");
					this.getSqlMapClient().update("distributeByReserve", paramMap);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			log.info("Updated Parameters for executing DISTRIBUTE_LOSS_EXP_XOL: " + paramMap);
			this.getSqlMapClient().update("distributeLossExpXol", paramMap);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "SUCCESS";
			
		}catch (LossExpDistException e) {
			message = e.getMessage();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (SQLException e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of Distribution for Loss Expense History.");
		}
		return message;
	}
	
	@Override
	public String redistributeLossExpHistory(Map<String, Object> params)
			throws SQLException, Exception {
		
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GICLClaims claim = (GICLClaims) this.getSqlMapClient().queryForObject("getClaimsBasicInfoDtls", params.get("claimId"));
			Integer clmDistNo = (Integer) this.getSqlMapClient().queryForObject("getMaxClmDistNo", params);
			String userId = (String) params.get("userId");
			String distRG = (String) params.get("distRG");
			String distSw = (String) params.get("distSw");
			String msgAlert = "";
			
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("userId", userId);
			paramMap.put("v1ClaimId", params.get("claimId"));
			paramMap.put("v1ClmLossId", params.get("clmLossId"));
			paramMap.put("v1ItemNo", params.get("itemNo"));
			paramMap.put("v1PerilCd", params.get("perilCd"));
			paramMap.put("v1GroupedItemNo", params.get("groupedItemNo"));
			paramMap.put("claimId", claim.getClaimId());
			paramMap.put("clmLossId", params.get("clmLossId"));
			paramMap.put("polEffDate", claim.getPolicyEffectivityDate());
			paramMap.put("expiryDate", claim.getExpiryDate());
			paramMap.put("lossDate", claim.getLossDate());
			paramMap.put("lineCd", claim.getLineCode());
			paramMap.put("sublineCd", claim.getSublineCd());
			paramMap.put("polIssCd", claim.getIssCd());
			paramMap.put("issueYy", claim.getIssueYy());
			paramMap.put("polSeqNo", claim.getPolicySequenceNo());
			paramMap.put("renewNo", claim.getRenewNo());
			paramMap.put("maxEndtSeqNo", claim.getMaxEndorsementSequenceNumber());
			paramMap.put("nbtDistDate", params.get("nbtDistDate"));
			paramMap.put("payeeCd", params.get("payeeCd"));
			paramMap.put("payeeType", params.get("payeeType"));
			paramMap.put("clmDistNo", clmDistNo);
			log.info("Redistribute Loss Expense History Parameters: " + paramMap);
			
			this.checkDeductibles(paramMap);
			
			msgAlert = (String) this.getSqlMapClient().queryForObject("validateExistDistGicls030", paramMap);
			
			if(!msgAlert.equals("") && !msgAlert.equals("EMPTY")){
				log.info("Message Alert: " + msgAlert);
				throw new LossExpDistException(msgAlert);
			}
			
			log.info("Distribution=" + distRG +" and distSw="+distSw);
			
			if(distRG.equals("1")){
				if(distSw.equals("N")){
					log.info("Executing DISTRIBUTE_LOSS_EXP for Redistribution...");
					this.getSqlMapClient().update("distributeLossExp", paramMap);
					this.getSqlMapClient().executeBatch();
				}
			}else if(distRG.equals("2")){
				String distByRiskLoc = (String) this.getSqlMapClient().queryForObject("getDistByRiskLoc", params);
				log.info("DistByRiskLoc = " + distByRiskLoc);
				
				if(distByRiskLoc.equals("Y") && distSw.equals("N")){
					log.info("Executing DIST_BY_RESERVE_RISK_LOC for Redistribution...");
					paramMap.put("clmDistNo", clmDistNo+1);
					this.getSqlMapClient().update("distByReserveRiskLoc", paramMap);
					this.getSqlMapClient().executeBatch();
				}else if(distSw.equals("N")){
					log.info("Executing DISTRIBUTE_BY_RESERVE for Redistribution...");
					this.getSqlMapClient().update("distributeByReserve", paramMap);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			log.info("Updated Parameters of Redistribution: " + paramMap);
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "SUCCESS";
			
		}catch (LossExpDistException e) {
			message = e.getMessage();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (SQLException e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of Distribution for Loss Expense History.");
		}
		return message;
	}

	
	@Override
	public String negateLossExpenseHistory(Map<String, Object> params)
			throws SQLException, Exception {
		
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String vXol = (String) params.get("vXol");
			String vCurrXol = (String) params.get("vCurrXol");
			
			log.info("Starting Negation of Loss Expense History with parameters: " + params);
			this.getSqlMapClient().update("negateLossExpHist", params);
			this.getSqlMapClient().executeBatch();
			
			if(vXol.equals("Y") || vCurrXol.equals("Y")){
				log.info("Updating XOL Payment...");
				this.getSqlMapClient().update("updateXolPayt", params);
				this.getSqlMapClient().executeBatch();
			}
			
			if(vXol.equals("Y")){
				String catastrophicCd = (String) params.get("catastrophicCd");
				if(catastrophicCd.equals("") || catastrophicCd.equals(null)){
					message = "Negation successful. Please redistribute all claim's valid loss expense records.";
				}else{
					GICLCatDtl cat = (GICLCatDtl) this.getSqlMapClient().queryForObject("getCatDtlByCatastrophicCd", params);
					message = "Negation successful. Please redistribute all records under catastrophic event "+
					           cat.getCatCd() + " - " + cat.getCatDesc()+ ".";
				}
			}else{
				message = "Negation successful.";
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of Negation for Loss Expense History.");
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String checkDeductibles(Map<String, Object> params)
			throws SQLException, Exception, LossExpDistException {
		String message = "";
		List<GICLLossExpDtl> dedList = this.getSqlMapClient().queryForList("getGiclLossExpDtlForDed", params);
		
		log.info("Checking Deductibles list with length = " + dedList.size());
		for(GICLLossExpDtl ded : dedList){
			log.info("Checking deductible with loss_exp_cd="+ded.getLossExpCd() + " and deductible_type = "+ded.getNbtDeductibleType());
			if("F".equals(ded.getNbtDeductibleType())){
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.clear();
				paramMap.put("userId", params.get("userId"));
				paramMap.put("v1ClaimId", params.get("v1ClaimId"));
				paramMap.put("v1ClmLossId", params.get("v1ClmLossId"));
				paramMap.put("v1ItemNo", params.get("v1ItemNo"));
				paramMap.put("v1PerilCd", params.get("v1PerilCd"));
				paramMap.put("v1GroupedItemNo", params.get("v1GroupedItemNo"));
				paramMap.put("lossExpCd", ded.getLossExpCd());
				paramMap.put("nbtDedAggSw", "");
				paramMap.put("dtlAmt", ded.getDtlAmt());
				paramMap.put("nbtDeductType", ded.getNbtDeductibleType());
				paramMap.put("payeeType", params.get("payeeType"));
				paramMap.put("lineCd", params.get("lineCd"));
				paramMap.put("sublineCd", params.get("sublineCd"));
				paramMap.put("polIssCd", params.get("polIssCd"));
				paramMap.put("issueYy", params.get("issueYy"));
				paramMap.put("polSeqNo", params.get("polSeqNo"));
				paramMap.put("renewNo", params.get("renewNo"));
				paramMap.put("lossDate", params.get("lossDate"));
				paramMap.put("polEffDate", params.get("polEffDate"));
				paramMap.put("expiryDate", params.get("expiryDate"));
				log.info("Parameters for check deductibles: " + paramMap);
				this.getSqlMapClient().update("checkDeductiblesGicls030", paramMap);
				log.info("Parameters for check deductibles after: " + paramMap);
				
				String msgAlert = paramMap.get("msgAlert") == null ? "" : paramMap.get("msgAlert").toString();
				
				if(!msgAlert.equals("") && !msgAlert.equals(null)){
					message = msgAlert;
					log.info("Check Deductible Message Alert: " + msgAlert);
					throw new LossExpDistException(msgAlert);
				}
			}
		}
		return message;
	}
}
