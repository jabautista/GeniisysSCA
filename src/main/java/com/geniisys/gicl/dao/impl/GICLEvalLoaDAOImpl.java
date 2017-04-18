/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLEvalLoaDAOImpl.java
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
import com.geniisys.gicl.dao.GICLEvalLoaDAO;
import com.geniisys.gicl.exceptions.LoaCslGenerationException;
import com.seer.framework.util.StringFormatter;

public class GICLEvalLoaDAOImpl extends DAOImpl implements GICLEvalLoaDAO{
	
	private static Logger log = Logger.getLogger(GICLEvalLoaDAOImpl.class);
	
	@Override
	public BigDecimal getTotalPartAmt(Map<String, Object> params)
			throws SQLException {
		log.info("RETRIEVING TOTAL PART AMOUNT LOA..");
		return (BigDecimal) getSqlMapClient().queryForObject("getTotalPartAmt", params);
	}
	
	@Override
	public void generateLoa(List<Map<String, Object>> loaList, String userId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("GENERATING LOA...");
			for (Map<String, Object> map : loaList) {
				map.put("userId", userId);
				this.getSqlMapClient().update("generateLoa", map);
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
	public String generateLoaFromLossExp(List<Map<String, Object>> loaList,
			String userId) throws SQLException, Exception {
		
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start Generating LOA from Loss Expense History");
			String generateFlag = "N";
			
			for(Map<String, Object> map : loaList){
				map.put("userId", userId);
				String remarks = map.containsValue("remarks") ? StringFormatter.unescapeHTML2(map.get("remarks").toString().replaceAll("&#92;", "\\\\")) : ""; //added by robert 10.22.2013
				map.put("remarks", remarks); //added by Halley 10.04.2013 - workaround to retain backslashes after prepareJsonAsParameter
				
				String loaGenSw = (String) this.getSqlMapClient().queryForObject("checkIfLoaGenerated", map);
				
				if(loaGenSw.equals("Y")){
					generateFlag = "Y";
					log.info("LOA already generated for: "+ map);
				}else{
					generateFlag = "Y";
					log.info("Generating LOA for: "+ map);
					this.getSqlMapClient().update("generateLoaFromLossExp", map);
				}
			}
			
			if(generateFlag.equals("N") && loaList.size() > 0){
				throw new LoaCslGenerationException("There is no LOA to be generated/printed.");
			}
		
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Generation of LOA from Loss Expense History successful.");
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
			log.info("End Generating LOA from Loss Expense History");
		}
		return message;
	}
}
