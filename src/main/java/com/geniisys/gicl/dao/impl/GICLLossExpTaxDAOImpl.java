package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLLossExpTaxDAO;
import com.geniisys.gicl.entity.GICLLossExpenseTax;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossExpTaxDAOImpl implements GICLLossExpTaxDAO{
	
	private Logger log = Logger.getLogger(GICLLossExpTaxDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Integer getNextTaxId(Map<String, Object> params) throws SQLException,
			Exception {
		return (Integer) this.getSqlMapClient().queryForObject("getLETaxNextTaxId", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveLossExpTax(Map<String, Object> params) throws SQLException,
			Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLLossExpenseTax> setGiclLossExpTax = (List<GICLLossExpenseTax>) params.get("setGiclLossExpTax");
			List<GICLLossExpenseTax> delGiclLossExpTax = (List<GICLLossExpenseTax>) params.get("delGiclLossExpTax");
			
			for(GICLLossExpenseTax delTax : delGiclLossExpTax){
				Map<String, Object> delTaxParams = new HashMap<String, Object>();
				delTaxParams.put("claimId", delTax.getClaimId());
				delTaxParams.put("clmLossId", delTax.getClmLossId());
				delTaxParams.put("taxId", delTax.getTaxId());
				delTaxParams.put("taxCd", delTax.getTaxCd());
				delTaxParams.put("taxType", delTax.getTaxType());
				delTaxParams.put("userId", delTax.getUserId());
				log.info("Deleting loss expense tax with parameters: "+ delTaxParams);
				
				this.getSqlMapClient().delete("deleteLossExpTax3", delTaxParams);
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().update("gicls030KeyCommitC009", delTaxParams);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLLossExpenseTax setTax: setGiclLossExpTax){
				Map<String, Object> setTaxParams = new HashMap<String, Object>();
				setTaxParams.put("claimId", setTax.getClaimId());
				setTaxParams.put("clmLossId", setTax.getClmLossId());
				setTaxParams.put("taxId", setTax.getTaxId());
				setTaxParams.put("taxCd", setTax.getTaxCd());
				setTaxParams.put("taxType", setTax.getTaxType());
				setTaxParams.put("userId", setTax.getUserId());
				
				Integer nextTaxId = this.getNextTaxId(setTaxParams);
				setTax.setTaxId(nextTaxId);
				
				log.info("Saving loss exp tax with parameters: "+ setTaxParams);
				this.getSqlMapClient().update("setGiclLossExpTax", setTax);
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().update("gicls030KeyCommitC009", setTaxParams);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Saving Loss Expense Tax successful.");
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
			log.info("End of Saving Loss Expense Tax");
		}
		
	}

	@Override
	public Integer checkLossExpTaxType(Map<String, Object> params) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkLossExpTaxType", params);
	}
	
	@Override
	public String checkLossExpTaxExist(Map<String, Object> params) throws SQLException { //benjo 03.08.2017 SR-5945
		return (String) this.getSqlMapClient().queryForObject("checkExistLossExpTax", params);
	}
	
}
