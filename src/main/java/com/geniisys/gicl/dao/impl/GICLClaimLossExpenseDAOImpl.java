/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 11, 2010
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClaimLossExpenseDAO;
import com.geniisys.gicl.entity.GICLClaimLossExpense;
import com.geniisys.gicl.entity.GICLLossExpBill;
import com.geniisys.gicl.entity.GICLLossExpDtl;
import com.geniisys.gicl.entity.GICLLossExpPayees;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GICLClaimLossExpenseDAOImpl implements GICLClaimLossExpenseDAO{

	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GICLClaimLossExpenseDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimLossExpenseDAO#getClaimLossExpense(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GICLClaimLossExpense getClaimLossExpense(Integer claimId,
			Integer claimLossId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", claimId);
		params.put("claimLossId", claimLossId);
		return (GICLClaimLossExpense) this.getSqlMapClient().queryForObject("getClaimLossExpense", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimLossExpenseDAO#getClaimLossExpenseByTransType(java.lang.Integer, java.lang.String, java.lang.Integer, java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GICLClaimLossExpense getClaimLossExpenseByTransType(
			Integer transType, String lineCd, Integer adviceId,
			Integer claimId, Integer claimLossId) throws SQLException {
		GICLClaimLossExpense claimLossExpense = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		@SuppressWarnings("unused")
		Map<String, Object> claimLossMap = new HashMap<String, Object>();
		
		System.out.println("PARAMETERS: adviceId=" + adviceId + ",lineCd=" + lineCd + ",claimId=" + claimId + ",claimLossId=" + claimLossId);
		
		params.put("adviceId", adviceId);
		params.put("lineCd", lineCd);
		params.put("claimId", claimId);
		//params.put("claimLossId", claimLossId);
		
		System.out.println("TRANS TYPE = " + transType);
		if(transType == 1){
			try{
				claimLossExpense = (GICLClaimLossExpense)this.getSqlMapClient().queryForObject("getClaimLossExpenseTransType1", params);
			}catch (SQLException e) {
				System.out.println("eeengk: " + e.getMessage());
			}catch (Exception e){
				System.out.println("eeengk: " + e.getMessage());
			}
		}else if(transType == 2){
			try{
				claimLossExpense = (GICLClaimLossExpense)this.getSqlMapClient().queryForObject("getClaimLossExpenseTransType2", params);
			}catch (SQLException e) {
				System.out.println("eeengk: " + e.getMessage());
			}catch (Exception e){
				System.out.println("eeengk: " + e.getMessage());
			}
		}
		/*
		if(claimLossMap!=null){ // FOR TESTING LANG
			Iterator<String> iter = claimLossMap.keySet().iterator();
			int ctr = 0;
			while(iter.hasNext()){
				String key = iter.next();
				System.out.println("-------- loop " + ctr + " -------- key: " + key);
				System.out.println("k: " + key + " // value: " + claimLossMap.get(key));
				ctr++;
			}
		}
		 */
		return claimLossExpense;
	}
	
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

	/* (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClaimLossExpenseDAO#setClaimLossExpense(com.geniisys.gicl.entity.GICLClaimLossExpense)
	 */
	@Override
	public void setClaimLossExpense(GICLClaimLossExpense claimLossExpense)
			throws SQLException {
		
		/*Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("claimId", claimLossExpense.getClaimId());
		params.put("claimLossId", claimLossExpense.getClaimLossId());
		params.put("histSeqNo", claimLossExpense.getHistorySequenceNumber());
		params.put("itemNo", claimLossExpense.getItemNo());
		params.put("perilCd", claimLossExpense.getPerilCode());
		params.put("itemStatusCd", claimLossExpense.getItemStatusCd());
		params.put("payeeType", claimLossExpense.getPayeeType());
		params.put("payeeCd", claimLossExpense.getPayeeCode());
		params.put("payeeClassCd", claimLossExpense.getPayeeClassCode());
		params.put("exGratiaSw", claimLossExpense.getExGratiaSw());
		params.put("userId", claimLossExpense.getUserId());
		
		params.put("distSw", claimLossExpense.getDistSw());
		params.put("paidAmount", claimLossExpense.getPaidAmount());
		params.put("netAmount", claimLossExpense.getNetAmount());
		params.put("adviceId", claimLossExpense.getAdviceId());
		params.put("cpiRecNo", claimLossExpense.getCpiRecNo());
		params.put("cpiBranchCode", claimLossExpense.getCpiBranchCode());
		params.put("remarks", claimLossExpense.getRemarks());
		params.put("cancelSw", claimLossExpense.getCancelSwitch());
		params.put("adviceId", claimLossExpense.getAdviceId());
		params.put("tranId", claimLossExpense.getTranId());
		params.put("distType", claimLossExpense.getDistibutionType());
		params.put("claimClmntNo", claimLossExpense.getClaimClmntNo());
		params.put("finalTag", claimLossExpense.getFinalTag());
		params.put("tranDate", claimLossExpense.getTranDate());
		params.put("currencyCd", claimLossExpense.getCurrencyCode());
		params.put("currencyRate", claimLossExpense.getCurrencyRate());
		params.put("groupedItemNo", claimLossExpense.getGroupedItemNo());
		
		this.getSqlMapClient().insert("setClaimLossExpense", params);*/
		this.getSqlMapClient().insert("setClaimLossExpense", claimLossExpense);
	}

	@Override
	public Integer getNextClmLossIdValue(Integer claimId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getNextClmLossIdValue", claimId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveLossExpenseHistory(Map<String, Object> params)
			throws SQLException, Exception {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLLossExpPayees> setGiclLossExpPayees = (List<GICLLossExpPayees>) params.get("setGiclLossExpPayees");
			List<GICLClaimLossExpense> setGiclClmLossExp = (List<GICLClaimLossExpense>) params.get("setGiclClmLossExp");
			List<GICLClaimLossExpense> delGiclClmLossExp = (List<GICLClaimLossExpense>) params.get("delGiclClmLossExp");
			List<GICLLossExpDtl> setGiclLossExpDtl       = (List<GICLLossExpDtl>) params.get("setGiclLossExpDtl");
			List<GICLLossExpDtl> delGiclLossExpDtl       = (List<GICLLossExpDtl>) params.get("delGiclLossExpDtl");
			
			log.info("Saving Loss Expense History");
						
			for(GICLClaimLossExpense clmLossExp : delGiclClmLossExp){
				//Pre-Delete
				GICLLossExpBill lossExpBill = new GICLLossExpBill();
				lossExpBill.setClaimId(clmLossExp.getClaimId());
				lossExpBill.setClaimLossId(clmLossExp.getClaimLossId());
				log.info("Deleting Loss Expense Bill with claim_id ="+lossExpBill.getClaimId()+ " and clm_loss_id="+lossExpBill.getClaimLossId());
				this.getSqlMapClient().delete("deleteGiclLossExpBill", lossExpBill);
				this.getSqlMapClient().executeBatch();
				
				//Delete
				log.info("Deleting Claim Loss Expense with claim_id ="+clmLossExp.getClaimId()+ " and clm_loss_id="+clmLossExp.getClaimLossId());
				this.getSqlMapClient().delete("deleteGiclClmLossExp", clmLossExp);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLLossExpDtl lossExpDtl : delGiclLossExpDtl){
				//Pre-Delete
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("claimId", lossExpDtl.getClaimId());
				delParams.put("clmLossId", lossExpDtl.getClmLossId());
				delParams.put("lossExpCd", lossExpDtl.getLossExpCd());
				delParams.put("userId", lossExpDtl.getUserId());
				String withDed = this.getSqlMapClient().queryForObject("checkExistLossExpDedDtl", delParams).toString();
				String withTax = this.getSqlMapClient().queryForObject("checkExistLossExpTax", delParams).toString();
				
				if(withTax.equals("Y")){
					log.info("Deleting tax records..");
					this.getSqlMapClient().delete("deleteLossExpTax2", delParams);
					this.getSqlMapClient().executeBatch();
				}
				
				if(withDed.equals("Y")){
					log.info("Deleting deductibles records..");
					this.getSqlMapClient().delete("deleteLossExpDedDtl", delParams);
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().delete("deleteLossExpDedDtl2", delParams);
					this.getSqlMapClient().executeBatch();
				}
				
				// Delete
				log.info("Deleting Loss Expense Detail with claim_id="+lossExpDtl.getClaimId()+", clm_loss_id="+lossExpDtl.getClmLossId()+ " and loss_exp_cd="+lossExpDtl.getLossExpCd());
				this.getSqlMapClient().delete("deleteGiclLossExpDtl", lossExpDtl);
				this.getSqlMapClient().executeBatch();
				
				// Updates the amount columns of the corresponding GICL_CLM_LOSS_EXP records
				this.getSqlMapClient().update("updateClmLossExpAmtsWithTax", delParams);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLLossExpPayees payee : setGiclLossExpPayees){
				log.info("Inserting new gicl_loss_exp_payees with claim_id="+payee.getClaimId()+", clm_clmnt_no="+payee.getClmClmntNo()+
						 ", payeeClassCd="+payee.getPayeeClassCd()+", payeeCd="+payee.getPayeeCd()+" and payeeType="+payee.getPayeeType());
				this.getSqlMapClient().update("insertGiclLossExpPayees", payee);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLClaimLossExpense clmLossExpense : setGiclClmLossExp){
				log.info("Saving gicl_clm_loss_exp with claim_id="+clmLossExpense.getClaimId()+" and clm_loss_id="+clmLossExpense.getClaimLossId());
				this.getSqlMapClient().update("setGiclClmLossExp", clmLossExpense);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLLossExpDtl lossExpDtl : setGiclLossExpDtl){
				Map<String, Object> setLossExpDtlParams = new HashMap<String, Object>();
				setLossExpDtlParams.put("claimId", lossExpDtl.getClaimId());
				setLossExpDtlParams.put("clmLossId", lossExpDtl.getClmLossId());
				setLossExpDtlParams.put("lossExpCd", lossExpDtl.getLossExpCd());
				setLossExpDtlParams.put("userId", lossExpDtl.getUserId());
				
				String exist = (String) this.getSqlMapClient().queryForObject("checkExistGiclLossExpDtl", setLossExpDtlParams);
				
				if(exist.equals("Y")){
					String withDed = this.getSqlMapClient().queryForObject("checkExistLossExpDedDtl", setLossExpDtlParams).toString();
					String withTax = this.getSqlMapClient().queryForObject("checkExistLossExpTax", setLossExpDtlParams).toString();
					
					log.info("Updating gicl_loss_exp_dtl with claim_id="+lossExpDtl.getClaimId()+", clm_loss_id="+lossExpDtl.getClmLossId()+" and loss_exp_cd="+lossExpDtl.getLossExpCd());
					
					if(withTax.equals("Y")){
						log.info("Deleting tax records of the updated record..");
						this.getSqlMapClient().delete("deleteLossExpTax2", setLossExpDtlParams);
						this.getSqlMapClient().executeBatch();
					}
					
					if(withDed.equals("Y")){
						log.info("Deleting deductibles records of the updated record..");
						this.getSqlMapClient().delete("deleteLossExpDedDtl", setLossExpDtlParams);
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().delete("deleteLossExpDedDtl2", setLossExpDtlParams);
						this.getSqlMapClient().executeBatch();
					}
				}else{
					String withTax = this.getSqlMapClient().queryForObject("checkExistLossExpTax", setLossExpDtlParams).toString();
					
					log.info("Inserting gicl_loss_exp_dtl with claim_id="+lossExpDtl.getClaimId()+", clm_loss_id="+lossExpDtl.getClmLossId()+" and loss_exp_cd="+lossExpDtl.getLossExpCd());
					this.getSqlMapClient().delete("deleteDedEqualsAll", setLossExpDtlParams);
					this.getSqlMapClient().executeBatch();
					
					if(withTax.equals("Y")){
						log.info("Deleting tax records...");
						this.getSqlMapClient().delete("deleteLossExpTax2", setLossExpDtlParams);
						this.getSqlMapClient().executeBatch();
					}
				}
				
				this.getSqlMapClient().update("setGiclLossExpDtl", lossExpDtl);
				this.getSqlMapClient().executeBatch();
				
				// Updates the amount columns of the corresponding GICL_CLM_LOSS_EXP records
				this.getSqlMapClient().update("updateClmLossExpAmtsWithTax", setLossExpDtlParams);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Saving Loss Expense History successful.");
		}catch (SQLException e) {
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
			log.info("End of Saving Loss Expense History");
		}
		
	}

	@Override
	public String validateHistSeqNo(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForObject("validateHistSeqNo", params).toString();
	}

	@Override
	public void cancelHistory(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Cancelling Loss Expense History with claimId="+params.get("claimId")+" and clmLossId="+params.get("clmLossId"));
			Debug.print("Parameters: " + params);
			
			this.getSqlMapClient().update("cancelEvalPayment", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("cancelGiclClmLossExp", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
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
			log.info("End of Loss Expense History Cancellation");
		}
	}

	@Override
	public void clearHistory(Map<String, Object> params) throws SQLException,
			Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Clearing details for Loss expense History with claimId="+params.get("claimId")+" and clmLossId="+params.get("clmLossId"));
			
			this.getSqlMapClient().delete("deleteGiclLossExpDtl2", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().delete("deleteLossExpTax", params);
			this.getSqlMapClient().executeBatch();
			
			params.put("adviseAmt", 0);
			params.put("paidAmt", 0);
			params.put("netAmt", 0);
			Debug.print("Parameters: " + params);
			
			log.info("Updating gicl_clm_loss_exp amounts...");
			this.getSqlMapClient().update("updateClmLossExpAmts", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
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
			log.info("End of Clear Loss Expense History.");
		}
		
	}

	@Override
	public String copyHistory(Map<String, Object> params) throws SQLException,
			Exception {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Copying GICL_CLM_LOSS_EXPENSE with parameters: " + params);
			
			this.getSqlMapClient().update("copyHistory", params);
			this.getSqlMapClient().executeBatch();
			
			message = params.get("msgAlert") == null ? "" : params.get("msgAlert").toString();
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
			log.info("End of Copy History");
		}
		return message;
	}

	@Override //Kenneth 06162015 SR 3616
	public void checkHistoryNumber(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkHistoryNumber", params);
	}
}
