package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.common.dao.GIISEventModUserDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISEventModUserDAOImpl implements GIISEventModUserDAO {

	private SqlMapClient sqlMapClient;
	
	@Override
	public String validatePassingUser(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validatePassingUser", params);
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

}
