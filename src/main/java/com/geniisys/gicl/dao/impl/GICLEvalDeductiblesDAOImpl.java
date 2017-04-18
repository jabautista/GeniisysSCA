package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import com.geniisys.gicl.dao.GICLEvalDeductiblesDAO;
import com.geniisys.gicl.entity.GICLEvalDeductibles;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLEvalDeductiblesDAOImpl implements GICLEvalDeductiblesDAO{
	
	private Logger log = Logger.getLogger(GICLEvalDeductiblesDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveGiclEvalDeductibles(Map<String, Object> params)
			throws SQLException, Exception {
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving MC Evaluation Deductibles.");
			
			String userId = (String) params.get("userId");
			List<GICLEvalDeductibles> delGiclEvalDeductibles = (List<GICLEvalDeductibles>) params.get("delGiclEvalDeductibles");
			List<GICLEvalDeductibles> setGiclEvalDeductibles = (List<GICLEvalDeductibles>) params.get("setGiclEvalDeductibles");
			List<GICLEvalDeductibles> replaceGiclEvalDeductibles = (List<GICLEvalDeductibles>) params.get("replaceGiclEvalDeductibles");
			
			for(GICLEvalDeductibles delDed : delGiclEvalDeductibles){
				Map<String, Object> delDedParamMap = new HashMap<String, Object>();
				delDedParamMap.put("evalId", delDed.getEvalId());
				delDedParamMap.put("dedCd", delDed.getDedCd());
				delDedParamMap.put("sublineCd", delDed.getSublineCd());
				delDedParamMap.put("noOfUnit", delDed.getNoOfUnit());
				delDedParamMap.put("dedBaseAmt", delDed.getDedBaseAmt());
				delDedParamMap.put("dedAmt", delDed.getDedAmt());
				delDedParamMap.put("dedRate", delDed.getDedRate());
				delDedParamMap.put("payeeTypeCd", delDed.getPayeeTypeCd());
				delDedParamMap.put("payeeCd", delDed.getPayeeCd());
				delDedParamMap.put("userId", userId);
				log.info("Deleting deductible with parameters: "+ delDedParamMap);
				this.getSqlMapClient().delete("deleteGiclEvalDeductibles", delDedParamMap);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLEvalDeductibles replaceDed: replaceGiclEvalDeductibles){
				Map<String, Object> replaceDedParamMap = new HashMap<String, Object>();
				replaceDedParamMap.put("evalId", replaceDed.getEvalId());
				replaceDedParamMap.put("dedCd", replaceDed.getDedCd());
				replaceDedParamMap.put("sublineCd", replaceDed.getSublineCd());
				replaceDedParamMap.put("noOfUnit", replaceDed.getNoOfUnit());
				replaceDedParamMap.put("dedBaseAmt", replaceDed.getDedBaseAmt());
				replaceDedParamMap.put("dedAmt", replaceDed.getDedAmt());
				replaceDedParamMap.put("dedRate", replaceDed.getDedRate());
				replaceDedParamMap.put("payeeTypeCd", replaceDed.getPayeeTypeCd());
				replaceDedParamMap.put("payeeCd", replaceDed.getPayeeCd());
				replaceDedParamMap.put("userId", userId);
				log.info("Deleting deductible record to be replace with parameters: "+replaceDedParamMap);
				this.getSqlMapClient().delete("deleteGiclEvalDeductibles", replaceDedParamMap);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLEvalDeductibles setDed: setGiclEvalDeductibles){
				log.info("Saving deductible with ded_cd="+ setDed.getDedCd());
				this.getSqlMapClient().update("insertGiclEvalDeductibles", setDed);
				this.getSqlMapClient().executeBatch();
			}
			
			Map<String, Object> dedMap = new HashMap<String, Object>();
			dedMap.put("evalId", params.get("evalId"));
			dedMap.put("userId", userId);
			
			log.info("Updating MC Evaluation record:"+dedMap);
			this.getSqlMapClient().update("updateDeductibleOfMcEval", dedMap);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			message = "SUCCESS";
			log.info("Saving Mc Evaluation Deductibles successful.");
		}catch(SQLException e){
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
			log.info("End of saving Mc Evaluation Deductibles.");
		}

		return message;
	}

	@Override
	public void applyDeductiblesForMcEval(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of Apply MC Evaluation Deductibles with parameters: "+params);
			
			String evalVatExist = this.getSqlMapClient().queryForObject("checkGiclEvalVatExist", params).toString();
			
			if(evalVatExist.equals("Y")){
				log.info("Deleting gicl_eval_vat records for eval_id="+params.get("evalId"));
				this.getSqlMapClient().delete("deleteAllEvalVat", params);
			}
			
			this.getSqlMapClient().update("applyDeductiblesForMcEval", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Updating MC Evaluation record...");
			this.getSqlMapClient().update("updateDeductibleOfMcEval", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Applying MC Evaluation Deductibles successful.");
			
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
			log.info("End of Apply MC Evaluation Deductibles.");
		}	
	}
	
}
