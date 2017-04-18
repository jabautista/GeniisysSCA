package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.dao.GIACAgingRiSoaDetailsDAO;
import com.geniisys.giac.entity.GIACAgingRiSoaDetails;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACAgingRiSoaDetailsDAOImpl implements GIACAgingRiSoaDetailsDAO {
	
	/** The SQL Map Client**/
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAgingRiSoaDetailsDAO#getAgingRiSoaDetails(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACAgingRiSoaDetails> getAgingRiSoaDetails(String keyword)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGiacAgingRiSoaDetails", keyword);
	}
}
