package com.geniisys.giuw.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giuw.dao.GIUWWPerildsDAO;
import com.geniisys.giuw.entity.GIUWWPerilds;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUWWPerildsDAOImpl implements GIUWWPerildsDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWWPerilds> getGiuwWperildsForDistFinal(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiuwWperildsForDistFinal", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWWPerildsDAO#isExistGiuwWPerildsGIUWS012(java.lang.Integer)
	 */
	@Override
	public String isExistGiuwWPerildsGIUWS012(Integer distNo)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("isExistGiuwWPerildsGIUWS012", distNo);
	}
}
