package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIItmperilBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIItmperilBeneficiary;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIItmperilBeneficiaryDAOImpl implements GIPIItmperilBeneficiaryDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItmperilBeneficiary> getItmperilBeneficiaries(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getItmperilBeneficiaries",params);
	}
	
	
}
