package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACDataCheckDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACDataCheckDAOImpl implements GIACDataCheckDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> checkQuery(String month, String year, String query) throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("month", month);
		params.put("year", year);
		params.put("query", query);
		return this.getSqlMapClient().queryForList("giacs353CheckQuery", params);
	}
	
	
	//mikel 06.20.2016; GENQA 5544
	public void patchRecords(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("patchRecords", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
}
