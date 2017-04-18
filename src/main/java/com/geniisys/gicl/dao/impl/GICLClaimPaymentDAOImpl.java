package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLClaimPaymentDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
	
public class GICLClaimPaymentDAOImpl implements GICLClaimPaymentDAO{

	private SqlMapClient sqlMapClient;
	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public String validateEntries(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateEntries", params);
	}


}
