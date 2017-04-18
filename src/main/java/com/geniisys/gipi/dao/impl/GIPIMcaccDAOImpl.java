package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIMcaccDAO;
import com.geniisys.gipi.entity.GIPIMcacc;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIMcaccDAOImpl implements GIPIMcaccDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIMcacc> getVehicleAccessories(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getVehicleAccessories", params);
	}
	
	
}
