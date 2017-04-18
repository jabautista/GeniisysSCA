/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLEvalCslDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 2, 2012
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.gicl.dao.GICLEvalCslDAO;
import com.geniisys.gicl.exceptions.LoaCslGenerationException;
import com.seer.framework.util.StringFormatter;

public class GICLEvalCslDAOImpl extends DAOImpl implements GICLEvalCslDAO{
	private static Logger log = Logger.getLogger(GICLEvalCslDAOImpl.class);
	
	public BigDecimal getTotalPartAmtCsl(Map<String, Object> params)
			throws SQLException {
		log.info("RETRIEVING TOTAL PART AMOUNT CSL..");
		return (BigDecimal) getSqlMapClient().queryForObject("getTotalPartAmtCsl", params);
	}

	@Override
	public void generateCsl(List<Map<String, Object>> cslList, String userId)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("GENERATING CSL...");
			for (Map<String, Object> map : cslList) {
				map.put("userId", userId);
				this.getSqlMapClient().update("generateCsl", map);
			}
			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public String generateCslFromLossEx(List<Map<String, Object>> cslList,
			String userId) throws SQLException, Exception {
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start Generating CSL from Loss Expense History");
			
			for(Map<String, Object> map : cslList){
				map.put("userId", userId);
				String remarks = map.containsValue("remarks") ? StringFormatter.unescapeHTML2(map.get("remarks").toString().replaceAll("&#92;", "\\\\")) : ""; //added by robert 10.22.2013
				map.put("remarks", remarks); //added by Halley 10.04.2013 - workaround to retain backslashes after prepareJsonAsParameter
				
				log.info("Generating CSL for: "+ map);
				this.getSqlMapClient().update("generateCslFromLossExp", map);
			}
					
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Generation of CSL from Loss Expense History successful.");
			message = "SUCCESS";
			
		}catch (LoaCslGenerationException e) {
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
			log.info("End Generating CSL from Loss Expense History");
		}
		return message;
	}
}
