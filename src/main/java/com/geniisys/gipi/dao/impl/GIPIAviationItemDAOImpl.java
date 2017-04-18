package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIAviationItemDAO;
import com.geniisys.gipi.entity.GIPIAviationItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIAviationItemDAOImpl implements GIPIAviationItemDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIAviationItem getAviationItemInfo(HashMap<String, Object> params) throws SQLException {
		return (GIPIAviationItem) this.getSqlMapClient().queryForObject("getAviationItemInfo",params);
	}
	
	
}
