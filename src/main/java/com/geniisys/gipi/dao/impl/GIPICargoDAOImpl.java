package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPICargoDAO;
import com.geniisys.gipi.entity.GIPICargo;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPICargoDAOImpl implements GIPICargoDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPICargo getCargoInfo(HashMap<String, Object> params)throws SQLException {
		
		return (GIPICargo) this.getSqlMapClient().queryForObject("getCargoInfo",params);
	}
	
}
