package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIDeductiblesDAO;
import com.geniisys.gipi.entity.GIPIDeductibles;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIDeductiblesDAOImpl implements GIPIDeductiblesDAO{
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIDeductibles> getDeductibles(HashMap<String, Object> params) throws SQLException {
		//return this.getSqlMapClient().queryForList("getDeductibles",params);
		return this.getSqlMapClient().queryForList("getGIPIS100Deductibles",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIDeductibles> getItemDeductibles(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getItemDeductibles",params);
	}

	
}
