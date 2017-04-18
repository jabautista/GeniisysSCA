package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLRecoveryRidsDAO;
import com.geniisys.gicl.entity.GICLRecoveryRids;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLRecoveryRidsDAOImpl implements GICLRecoveryRidsDAO{
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public GICLRecoveryRids getFlaRecovery(Map<String, Object> params)
			throws SQLException {
		return (GICLRecoveryRids) this.getSqlMapClient().queryForObject("getFlaRecovery", params);
	}
	
	@Override
	public void updGiclRecovRids(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("updGiclRecovRids", params);
	}
	
	@Override
	public void delGiclRecovRids(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("delGiclRecovRids", params);
	}
	
}
