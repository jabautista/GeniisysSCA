package com.geniisys.giuw.dao.impl;

import java.sql.SQLException;

import com.geniisys.giuw.dao.GIUWWpolicydsDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUWWpolicydsDAOImpl implements GIUWWpolicydsDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String isExistGIUWWpolicyds(Integer distNo) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("isExistGIUWWpolicyds", distNo);
	}
	
}
