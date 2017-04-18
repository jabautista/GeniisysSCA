package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIAccidentItemDAO;
import com.geniisys.gipi.entity.GIPIAccidentItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIAccidentItemDAOImpl implements GIPIAccidentItemDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIAccidentItem getAccidentItemInfo(HashMap<String, Object> params) throws SQLException {
		return (GIPIAccidentItem) this.getSqlMapClient().queryForObject("getAccidentItemInfo",params);
	}
	
	
}
