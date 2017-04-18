package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISUserGrpHistDAO;
import com.geniisys.common.entity.GIISUserGrpHist;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISUserGrpHistDAOImpl implements GIISUserGrpHistDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserGrpHist> getUserHistory(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getUserHistory", params);
	}
}
