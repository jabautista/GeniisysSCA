package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPICasualtyItemDAO;
import com.geniisys.gipi.entity.GIPICasualtyItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPICasualtyItemDAOImpl implements GIPICasualtyItemDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPICasualtyItem getCasualtyItemInfo(HashMap<String, Object> params) throws SQLException {
		return (GIPICasualtyItem) this.getSqlMapClient().queryForObject("getCasualtyItemInfo",params);
	}
	
	
}
