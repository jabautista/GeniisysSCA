package com.geniisys.common.dao.impl;

import java.sql.SQLException;

import com.geniisys.common.dao.GIISDocumentDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISDocumentDAOImpl implements GIISDocumentDAO{

	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String checkDisplayGiexs006(String title) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkDisplayGiexs006", title);
	}

	@Override
	public String checkPrintPremiumDetails(String lineCd)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkPrintPremiumDetails", lineCd);
	}
	
}
