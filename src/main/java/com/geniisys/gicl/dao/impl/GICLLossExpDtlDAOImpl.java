package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLLossExpDtlDAO;
import com.geniisys.gicl.entity.GICLLossExpDtl;
import com.geniisys.gicl.exceptions.DepreciationException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossExpDtlDAOImpl implements GICLLossExpDtlDAO{
	
	/** The log. */
	private static Logger log = Logger.getLogger(GICLLossExpDtlDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String validateLossExpDtlDelete(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForObject("validateLossExpDtlDelete", params).toString();
	}
	
	@Override
	public String validateLossExpDtlAdd(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLossExpDtlAdd", params);
	}

	@Override
	public String validateLossExpDtlUpdate(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForObject("validateLossExpDtlUpdate", params).toString();
	}

	@Override
	public String computeDepreciation(Map<String, Object> params) throws SQLException, Exception {
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Starting computing depreciation with parameters: " + params);
			String existDepreciation = "";
			String existOrigPart = "";
			String msgAlert = "";
			
			existDepreciation = (String) this.getSqlMapClient().queryForObject("checkExistingDepreciation", params);
			log.info("Depreciation exist: " + existDepreciation);
			
			if(existDepreciation.equals("Y")){
				throw new DepreciationException("Depreciation is already computed for this history.");
			}
			
			existOrigPart = (String) this.getSqlMapClient().queryForObject("checkExistingOrigPart", params);
			log.info("Original Part exist: " + existOrigPart);
			
			if(existOrigPart.equals("N")|| existOrigPart.equals("")){
				throw new DepreciationException("Depreciation cannot be computed, there is no existing original part.");
			}
			
			String deductibleSw = params.get("deductibleSw") == null ? "N" : params.get("deductibleSw").toString();
			
			if(deductibleSw.equals("Y")){
				this.getSqlMapClient().update("computeDepreciationForDed", params);
			}else{
				this.getSqlMapClient().update("computeDepreciation", params);
			}
			
			log.info("Executed computation of depreciation with parameters: " + params);
			
			msgAlert = params.get("msgAlert") == null ? "" : params.get("msgAlert").toString();
			if(!msgAlert.equals("") && !msgAlert.equals(null)){
				throw new DepreciationException(msgAlert);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "SUCCESS";
			
		}catch (DepreciationException e) {
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
			log.info("End of Computing for Depreciation.");
		}
		return message;
	}

	@Override
	public String checkExistLossDtlAllWTax(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkExistLossDtlAllTax", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String clearLossExpenseDeductibles(Map<String, Object> params)
			throws SQLException, Exception {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Starting to clear deductibles with parameters: "+params);
			List<GICLLossExpDtl> deductibleList = this.getSqlMapClient().queryForList("getLossExpDeductiblesList", params);
			log.info("Deleting "+deductibleList.size()+" deductible/s.");
			
			for(GICLLossExpDtl ded: deductibleList){
				Map<String, Object> dedParams = new HashMap<String, Object>();
				dedParams.put("claimId", ded.getClaimId());
				dedParams.put("clmLossId", ded.getClmLossId());
				dedParams.put("lossExpCd", ded.getLossExpCd());
				
				log.info("Deleting deductible and taxes for: "+dedParams);
				
				// Pre-Delete - delete records in GICL_LOSS_EXP_DED_DTL fisrt 
				this.getSqlMapClient().delete("deleteLossExpDedDtl", dedParams);
				this.getSqlMapClient().executeBatch();
				
				// Delete the deductible
				this.getSqlMapClient().delete("deleteGiclLossExpDtl", ded);
				this.getSqlMapClient().executeBatch();
				
				// Delete the corresponding taxes
				this.getSqlMapClient().delete("deleteLossExpTax", dedParams);
				this.getSqlMapClient().executeBatch();
				
				// Updates the amount columns of the corresponding GICL_CLM_LOSS_EXP records
				this.getSqlMapClient().update("updateClmLossExpAmtsWithTax", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Clearing of loss expense deductibles successful.");
			message = "SUCCESS";
		
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
			log.info("End of Clearing Loss Expense Deductibles.");
		}
		return message;
	}

	@Override
	public Map<String, Object> validateSelectedLEDeductible(
			Map<String, Object> params) throws SQLException, Exception {
		log.info("Parameters before: "+ params);
		this.getSqlMapClient().update("validateSelectedLEDeductible", params);
		log.info("Parameters after: "+ params);
		return params;
	}

	@Override
	public Map<String, Object> getLossExpDeductibleAmts(
			Map<String, Object> params) throws SQLException, Exception {
		log.info("Parameters before: "+ params);
		this.getSqlMapClient().update("getLossExpDeductibleAmts", params);
		log.info("Parameters after: "+ params);
		return params;
	}

	@Override
	public String validateLossExpDeductibleDelete(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForObject("validateLossExpDeductibleDelete", params).toString();
	}
	
	@Override
	public String validateLossExpDeductibleUpdate(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForObject("validateLossExpDeductibleUpdate", params).toString();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveLossExpDeductibles(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLLossExpDtl> setGiclLossExpDeductibles = (List<GICLLossExpDtl>) params.get("setGiclLossExpDeductibles");
			List<GICLLossExpDtl> delGiclLossExpDeductibles = (List<GICLLossExpDtl>) params.get("delGiclLossExpDeductibles");
			
			for(GICLLossExpDtl delDed : delGiclLossExpDeductibles){
				Map<String, Object> delDedMap = new HashMap<String, Object>();
				delDedMap.put("claimId", delDed.getClaimId());
				delDedMap.put("clmLossId", delDed.getClmLossId());
				delDedMap.put("lossExpCd", delDed.getLossExpCd());
				delDedMap.put("dedLossExpCd", delDed.getDedLossExpCd());
				delDedMap.put("userId", delDed.getUserId());
				
				String exist = (String) this.getSqlMapClient().queryForObject("checkExistGiclLossExpDtl", delDedMap);
				
				if("Y".equals(exist)){
					log.info("Deleting loss expense deductibles with parameters: "+delDedMap);
					
					//Delete the loss exp deductible
					this.getSqlMapClient().delete("deleteGiclLossExpDtl", delDed);
					this.getSqlMapClient().executeBatch();
					
					//Delete the gicl_loss_exp_ded_dtl records of the deductible
					this.getSqlMapClient().delete("deleteLossExpDedDtl", delDedMap);
					this.getSqlMapClient().executeBatch();
					
					//Delete from gicl_loss_exp_tax if detail has tax/es
					this.getSqlMapClient().delete("deleteLossExpTax4", delDedMap);
					this.getSqlMapClient().executeBatch();
					
					// Updates the amount columns of the corresponding GICL_CLM_LOSS_EXP records
					this.getSqlMapClient().update("updateClmLossExpAmtsWithTax", delDedMap);
					this.getSqlMapClient().executeBatch();
				}				
			}
			
			for(GICLLossExpDtl setDed : setGiclLossExpDeductibles){
				Map<String, Object> setDedMap = new HashMap<String, Object>();
				setDedMap.put("claimId", setDed.getClaimId());
				setDedMap.put("clmLossId", setDed.getClmLossId());
				setDedMap.put("lineCd", setDed.getLineCd());
				setDedMap.put("sublineCd", setDed.getSublineCd());
				setDedMap.put("payeeType", setDed.getLossExpType());
				setDedMap.put("lossExpCd", setDed.getLossExpCd());
				setDedMap.put("dedLossExpCd", setDed.getDedLossExpCd());
				setDedMap.put("dtlAmt", setDed.getDtlAmt());
				setDedMap.put("dedRate", setDed.getDedRate());
				setDedMap.put("aggregateSw", setDed.getAggregateSw());
				setDedMap.put("ceilingSw", setDed.getCeilingSw());
				setDedMap.put("minAmt", setDed.getNbtMinAmt());
				setDedMap.put("maxAmt", setDed.getNbtMaxAmt());
				setDedMap.put("rangeSw", setDed.getNbtRangeSw());
				setDedMap.put("userId", setDed.getUserId());
				
				String exist = (String) this.getSqlMapClient().queryForObject("checkExistGiclLossExpDtl", setDedMap);
				
				if("Y".equals(exist)){ // Update
					log.info("Updating loss expense deductibles with parameters: "+ setDedMap);
					this.getSqlMapClient().delete("deleteLossExpDedDtl", setDedMap);
					this.getSqlMapClient().executeBatch();
					
					//Delete from gicl_loss_exp_tax if detail has tax/es
					this.getSqlMapClient().delete("deleteLossExpTax5", setDedMap);
					this.getSqlMapClient().executeBatch();
					
				}else{ // Insert
					log.info("Inserting loss expense deductibles with parameters: "+ setDedMap);
				}
				
				this.getSqlMapClient().update("setGiclLossExpDtlForDed", setDed);
				this.getSqlMapClient().executeBatch();
				
				String dedLossExpCd = setDed.getDedLossExpCd();
				
				if(dedLossExpCd.equals("%ALL%")){
					this.getSqlMapClient().insert("insertLeDedDtlForAll", setDedMap);
					this.getSqlMapClient().executeBatch();
				}else{
					this.getSqlMapClient().insert("insertLeDedDtlNotForAll", setDedMap);
					this.getSqlMapClient().executeBatch();
				}
				
				this.getSqlMapClient().delete("deleteExcessLossExpDedDtl", setDedMap);
				this.getSqlMapClient().executeBatch();
				
				// Updates the amount columns of the corresponding GICL_CLM_LOSS_EXP records
				this.getSqlMapClient().update("updateClmLossExpAmtsWithTax", setDedMap);
				this.getSqlMapClient().executeBatch();
			}
						
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Saving Loss Expense Deductibles successful.");
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
			log.info("End of Saving Loss Expense Deductibles.");
		}
		
	}

	@Override
	public Map<String, Object> checkLOAOverrideRequestExist(
			Map<String, Object> params) throws SQLException, Exception {
		this.getSqlMapClient().update("checkLOAOverrideRequestExist", params);
		return params;
	}

	@Override
	public void createLOAOverrideRequest(Map<String, Object> params)
			throws SQLException, Exception {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start creating override request for LOA/CSL with parameters: "+params);
			this.getSqlMapClient().update("createLOAOverrideRequest", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Creating override request for LOA/CSL successful.");
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
			log.info("End of creating override request for LOA/CSL.");
		}
		
	}

}
