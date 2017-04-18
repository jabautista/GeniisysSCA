package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIOpenPolicyDAO;
import com.geniisys.gipi.entity.GIPIOpenPolicy;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIOpenPolicyDAOImpl implements GIPIOpenPolicyDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIOpenPolicy getEndtseq0OpenPolicy(Integer policyEndSeq0) throws SQLException {
		return (GIPIOpenPolicy) this.getSqlMapClient().queryForObject("getEndtseq0OpenPolicy",policyEndSeq0);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getOpenLiabFiMn(String policyId)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getOpenLiabFiMn", policyId);
	}
	
}
