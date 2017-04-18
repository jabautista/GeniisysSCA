package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.dao.GIEXPackExpiryDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXPackExpiryDAOImpl implements GIEXPackExpiryDAO{

	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public String checkPackPolicyIdGiexs006(Integer packPolicyId)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPackPolicyIdGiexs006", packPolicyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getPackPolicyId(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getPackPolicyId", params);
	}

	@Override
	public String checkPackRecordUser(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPackRecordUser", params);
	}

}
