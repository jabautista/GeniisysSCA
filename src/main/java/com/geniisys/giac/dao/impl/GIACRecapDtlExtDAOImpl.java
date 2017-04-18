package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.dao.GIACRecapDtlExtDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACRecapDtlExtDAOImpl implements GIACRecapDtlExtDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getRecapVariables() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getRecapVariables");
	}

	@Override
	public void extractRecap(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractRecap", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().update("extractRecapLoss", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().update("extractRecapOsLoss", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().update("extractRecapSummary", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().update("extractRecapLosspd", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().update("extractRecapOsloss", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().update("getCount", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("keepDates", params);
			this.getSqlMapClient().executeBatch();
			
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Integer checkDataFetched() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkDataFetched");
	}
	
}
