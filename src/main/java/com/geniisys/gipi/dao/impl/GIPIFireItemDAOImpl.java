package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIFireItemDAO;
import com.geniisys.gipi.entity.GIPIFireItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIFireItemDAOImpl implements GIPIFireItemDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIPIFireItem getFireitemInfo(HashMap<String, Object> params)throws SQLException {
		return (GIPIFireItem) this.getSqlMapClient().queryForObject("getFireitemInfo",params);
		
	}

}
