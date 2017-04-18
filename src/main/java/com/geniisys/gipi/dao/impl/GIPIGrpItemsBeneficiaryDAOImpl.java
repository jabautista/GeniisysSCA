package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIGrpItemsBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIGrpItemsBeneficiaryDAOImpl implements GIPIGrpItemsBeneficiaryDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIGrpItemsBeneficiary> getGrpItemsBeneficiaries(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGrpItemsBeneficiaries",params);
	}
	
	
}
