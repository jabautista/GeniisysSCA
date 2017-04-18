package com.geniisys.quote.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.dao.GIPIQuoteCAItemDAO;
import com.geniisys.quote.entity.GIPIQuoteCAItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteCAItemDAOImpl implements GIPIQuoteCAItemDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIQuoteCAItem getGIPIQuoteCAItemDetails(Map<String, Object> params)
			throws SQLException {
		return (GIPIQuoteCAItem) this.getSqlMapClient().queryForObject("getGIPIQuoteCAItemDetails", params) ;
	}

}
