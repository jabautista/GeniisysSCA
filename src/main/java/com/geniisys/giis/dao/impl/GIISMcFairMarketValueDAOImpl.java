package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giis.dao.GIISMcFairMarketValueDAO;
import com.geniisys.giis.entity.GIISMcFairMarketValue;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMcFairMarketValueDAOImpl implements GIISMcFairMarketValueDAO {
	
	private Logger log = Logger.getLogger(GIISMcFairMarketValueDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveFmv(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		List<GIISMcFairMarketValue> setRows = (List<GIISMcFairMarketValue>) allParams.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			log.info("Saving GIIS Mortgagee...");
			for(GIISMcFairMarketValue set : setRows){
				this.sqlMapClient.insert("setGiisFmv", set);
				this.getSqlMapClient().executeBatch();
			}
			log.info(setRows.size() + " GIIS Fair Market Value/s inserted/updated.");			
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

}
