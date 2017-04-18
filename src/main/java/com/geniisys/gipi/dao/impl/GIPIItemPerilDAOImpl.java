/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIItemPerilDAO;
import com.geniisys.gipi.entity.GIPIItemPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIItemPerilDAOImpl implements GIPIItemPerilDAO {

	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIPIItemPerilDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIItemPerilDAO#getGIPIItemPerils(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItemPeril> getGIPIItemPerils(Integer parId)
			throws SQLException {
		log.info("DAO - Retrieving Item Peril/s...");
		List<GIPIItemPeril> perils = this.getSqlMapClient().queryForList("getGIPIItemPeril", parId);
		log.info("DAO - " + perils.size() + " Item Peril/s retrieved.");
		
		return perils;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIItemPerilDAO#checkCompulsoryDeath(java.lang.Integer)
	 */
	@Override
	public String checkCompulsoryDeath(Integer policyId) throws SQLException {
		log.info("Checking compulsory death details for policyId "+policyId+"...");
		return (String) this.getSqlMapClient().queryForObject("checkCompulsoryDeath", policyId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIItemPerilDAO#getItemPerilCount(java.lang.Integer)
	 */
	@Override
	public Integer getItemPerilCount(Integer policyId) throws SQLException {
		log.info("Getting item peril counts for policyId " + policyId + "...");
		return (Integer) this.getSqlMapClient().queryForObject("getItemPerilCount", policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItemPeril> getItemPerils(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getItemPerils", params);
	}
	
}