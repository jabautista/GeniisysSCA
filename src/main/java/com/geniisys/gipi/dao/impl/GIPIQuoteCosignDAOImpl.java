package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIQuoteCosignDAO;
import com.geniisys.gipi.entity.GIPIQuoteCosign;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteCosignDAOImpl implements GIPIQuoteCosignDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteCosign>  getGIPIQuoteCosigns(Integer quoteId)
			throws SQLException {
		return this.sqlMapClient.queryForList("getGIPIQuoteCosigns", quoteId);
	}

}
