package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.dao.GIACPaytRequestsDtlDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPaytRequestsDtlDAOImpl implements GIACPaytRequestsDtlDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Object getGiacPaytRequestsDtl(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForObject("getGiacPaytRequestsDtl", params);
	}
	
	
}
