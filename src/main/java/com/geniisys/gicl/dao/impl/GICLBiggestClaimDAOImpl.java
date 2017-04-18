package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.geniisys.gicl.dao.GICLBiggestClaimDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLBiggestClaimDAOImpl implements GICLBiggestClaimDAO{

	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstanceGICLS220()
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGICLS220");
	}

	@Override
	public HashMap<String, Object> extractGICLS220(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractGICLS220", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("extractGICLS220 params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String extractParametersExistGicls220(Map<String, Object> params)
			throws SQLException {
		return (String) getSqlMapClient().queryForObject("extractParametersExistGicls220",params);
	}

}
