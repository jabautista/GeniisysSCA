package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIBeneficiary;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIBeneficiaryDAOImpl implements GIPIBeneficiaryDAO{
	
	private SqlMapClient sqlMapClient;	
	
	private static Logger log = Logger.getLogger(GIPIBeneficiaryDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIBeneficiary> getGipiBeneficiaries(HashMap<String, Object> params) throws SQLException {
		System.out.println(params);
		return this.getSqlMapClient().queryForList("getGipiBeneficiaries",params);
	}
	
	@Override
	public GIPIBeneficiary getGIPIBeneficiary(Map<String, Object> params)
			throws SQLException {		
		log.info("Getting beneficiary record ...");
		return (GIPIBeneficiary) this.getSqlMapClient().queryForObject("getGIPIBeneficiary", params);
	}
}
