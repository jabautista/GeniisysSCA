package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIItmPerilGroupedDAO;
import com.geniisys.gipi.entity.GIPIItmPerilGrouped;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIItmPerilGroupedDAOImpl implements GIPIItmPerilGroupedDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItmPerilGrouped> getItmPerilGroupedList(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getItmPerilGroupedList",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItmPerilGrouped> getPolItmPerils(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPolItmGroupedPerils", parId);
	}
}
