package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIWBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIWBeneficiary;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWBeneficiaryDAOImpl implements GIPIWBeneficiaryDAO{

	public SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBeneficiaryDAO#getGipiWBeneficiary(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWBeneficiary> getGipiWBeneficiary(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWBeneficiary", parId);
	}
	
}
