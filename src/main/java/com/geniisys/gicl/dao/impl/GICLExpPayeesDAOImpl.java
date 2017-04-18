package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLExpPayeesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLExpPayeesDAOImpl implements GICLExpPayeesDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String checkGiclExpPayeesExist(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGiclExpPayeesExist", params);
	}
}
