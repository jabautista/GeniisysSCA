package com.geniisys.gism.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gism.dao.GISMSmsReportDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GISMSmsReportDAOImpl implements GISMSmsReportDAO{
	private SqlMapClient sqlMapClient;

	@Override
	public Map<String, Object> populateSmsReportPrint(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("populateSmsReportPrint", params);
		return params;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> validateGisms012User(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGisms012User", params);
		return params;
	}

}
