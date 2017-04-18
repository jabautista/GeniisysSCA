package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIItemVesDAO;
import com.geniisys.gipi.entity.GIPIItemVes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIItemVesDAOImpl implements GIPIItemVesDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItemVes> getMarineHulls(HashMap<String, Object> params) throws SQLException {
		
		return this.getSqlMapClient().queryForList("getMarineHulls", params);
		
	}

	@Override
	public GIPIItemVes getItemVesInfo(HashMap<String, Object> params) throws SQLException {
		
		return (GIPIItemVes) this.getSqlMapClient().queryForObject("getItemVesInfo",params);
		
	}		
	
}
