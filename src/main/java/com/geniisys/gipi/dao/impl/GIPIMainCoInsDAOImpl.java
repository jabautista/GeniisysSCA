package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIMainCoInsDAO;
import com.geniisys.gipi.entity.GIPIMainCoIns;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIMainCoInsDAOImpl implements GIPIMainCoInsDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIMainCoIns getPolicyMainCoIns(Integer policyId) throws SQLException {
		return (GIPIMainCoIns) this.sqlMapClient.queryForObject("getPolicyMainCoIns",policyId);
	}
	
	public String limitEntryGIPIS154(Map<String, Object> params) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("limitEntryGIPIS154", params);
	}
	
}
