package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClmAdjHistDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmAdjHistDAOImpl implements GICLClmAdjHistDAO{

	private Logger log = Logger.getLogger(GICLClmAdjHistDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String getGiclClmAdjHistExist(String claimId) throws SQLException {
		log.info("Checking gicl_clm_adj_hist exist : claim id = "+claimId);
		return (String) this.sqlMapClient.queryForObject("getGiclClmAdjHistExist", claimId);
	}

	@Override
	public String getDateCancelled(Map<String, Object> params)
			throws SQLException {
		log.info("Getting date cancelled");
		return (String) this.sqlMapClient.queryForObject("getCLmAdjDateCancelled", params);
	}
	
}
