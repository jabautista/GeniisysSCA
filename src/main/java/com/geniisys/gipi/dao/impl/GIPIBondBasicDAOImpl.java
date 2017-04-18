package com.geniisys.gipi.dao.impl;


import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIBondBasicDAO;
import com.geniisys.gipi.entity.GIPIBondBasic;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIBondBasicDAOImpl implements GIPIBondBasicDAO{

	private Logger log = Logger.getLogger(GIPIBondBasicDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIBondBasic> getBondPolicyData(Map<String, Object> params)
			throws SQLException {
		log.info("Getting bond policy data : "+params);
		return (List<GIPIBondBasic>) this.sqlMapClient.queryForList("getBondPolicyData2", params);
	}
	
}
