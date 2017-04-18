package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPICasualtyPersonnelDAO;
import com.geniisys.gipi.entity.GIPICasualtyPersonnel;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPICasualtyPersonnelDAOImpl implements GIPICasualtyPersonnelDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPICasualtyPersonnel> getCasualtyItemPersonnel(HashMap<String, Object> params) throws SQLException {

		return this.getSqlMapClient().queryForList("getCasualtyItemPersonnel", params);
	}
	
	
}
