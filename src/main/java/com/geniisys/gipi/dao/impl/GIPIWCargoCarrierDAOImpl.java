package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIWCargoCarrierDAO;
import com.geniisys.gipi.entity.GIPIWCargoCarrier;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWCargoCarrierDAOImpl implements GIPIWCargoCarrierDAO{

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoCarrierDAO#getGipiWCargoCarrier(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCargoCarrier> getGipiWCargoCarrier(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWCargoCarrier", parId);
	}

}
