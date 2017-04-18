package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giis.dao.GIISMcDepreciationRateDAO;
import com.geniisys.giis.entity.GIISMcDepreciationPeril;
import com.geniisys.giis.entity.GIISMcDepreciationRate;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMcDepreciationRateDAOImpl implements GIISMcDepreciationRateDAO {
	
	private Logger log = Logger.getLogger(GIISMcDepreciationRateDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveMcDr(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		List<GIISMcDepreciationRate> setRows = (List<GIISMcDepreciationRate>) allParams.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			log.info("Saving GIIS Depreciation Rate...");
			for(GIISMcDepreciationRate set : setRows){
				this.sqlMapClient.insert("setGiisMcDr", set);
				this.getSqlMapClient().executeBatch();
			}
			log.info(setRows.size() + " GIIS MC Depreciation Rate/s inserted/updated.");			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@Override
	public String validateAddMcDepRate(Map<String, Object> params) throws SQLException {
		log.info("Validating MC Depreciation Rate Entry...");
		return (String) this.getSqlMapClient().queryForObject("validateAddMcDepRate", params);
	}	
	
	@Override
	public String validateMcPerilRec(Map<String, Object> params) throws SQLException {
		log.info("Validating MC Peril Rate Entry...");
		return (String) this.getSqlMapClient().queryForObject("validateMcPerilRec", params);
	}		
	
	@Override
	public String deleteMcPerilRec(Map<String, Object> params) throws SQLException {
		log.info("Deleting MC Peril Rate Entry...");
		//return (String) this.getSqlMapClient().delete("deleteMcPerilRec", params);
		this.sqlMapClient.delete("deleteMcPerilRec", params);
		return null;
	}			
	
	@SuppressWarnings("unchecked")
	@Override
	public String savePerilDepRate(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		List<GIISMcDepreciationPeril> setRows = (List<GIISMcDepreciationPeril>) allParams.get("setRows");
		List<GIISMcDepreciationPeril> delRows = (List<GIISMcDepreciationPeril>) allParams.get("delRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIISMcDepreciationPeril del : delRows){
				this.sqlMapClient.delete("deletePerilDepRate", del);
			}
			for(GIISMcDepreciationPeril set : setRows){
				this.sqlMapClient.delete("setPerilDepRate", set);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}	

}
