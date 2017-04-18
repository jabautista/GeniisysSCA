package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIErrorLogDAO;
import com.geniisys.gipi.entity.GIPIErrorLog;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIErrorLogDAOImpl implements GIPIErrorLogDAO{

	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIErrorLog> getGipiErrorLog(String filename)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIErrorLog", filename);
	}
	
}

