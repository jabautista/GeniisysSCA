package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIVesAirDAO;
import com.geniisys.gipi.entity.GIPIVesAir;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIVesAirDAOImpl implements GIPIVesAirDAO{

	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIVesAir> getCargoInformations(HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getCargoInformations", params);
	}
	
}
