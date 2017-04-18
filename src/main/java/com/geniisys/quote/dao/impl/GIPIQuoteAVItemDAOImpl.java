package com.geniisys.quote.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.dao.GIPIQuoteAVItemDAO;
import com.geniisys.quote.entity.GIPIQuoteAVItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteAVItemDAOImpl implements GIPIQuoteAVItemDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIQuoteAVItem getGIPIQuoteAVItemDetails(Map<String, Object> params)
			throws SQLException {
		return (GIPIQuoteAVItem) this.getSqlMapClient().queryForObject("getGIPIQuoteAVItemDetails", params);
	}

}
