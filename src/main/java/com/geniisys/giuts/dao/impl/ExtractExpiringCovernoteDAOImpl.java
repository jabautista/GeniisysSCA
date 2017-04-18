package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.geniisys.giuts.dao.ExtractExpiringCovernoteDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class ExtractExpiringCovernoteDAOImpl implements ExtractExpiringCovernoteDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstanceGIUTS031(Map<String, Object> params)
			throws SQLException {
		System.out.println("whenNewFormInstanceGIUTS031 params....." + params);
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGIUTS031");
	}

	@Override
	public HashMap<String, Object> extractGIUTS031(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractGIUTS031", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("extractGIUTS031 params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateExtractParameters(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateExtractParameters", params);
	}
	
}
