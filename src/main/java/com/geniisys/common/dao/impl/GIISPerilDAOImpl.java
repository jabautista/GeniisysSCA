/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISPerilDAO;
import com.geniisys.common.entity.GIISPeril;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISPerilDAOImpl.
 */
public class GIISPerilDAOImpl implements GIISPerilDAO {
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISPerilDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISPerilDAO#checkIfPerilExists(java.lang.String, java.lang.String)
	 */
	@Override
	public String checkIfPerilExists(String nbtSublineCd, String lineCd)
			throws SQLException {
		log.info("Checking if peril exists...");
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("nbtSublineCd", nbtSublineCd);
		params.put("lineCd", lineCd);
		return (String) this.getSqlMapClient().queryForObject("checkIfPerilExists", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISPerilDAO#getDefaultPerils(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISPeril> getDefaultPerils(Map<String, Object> params)
			throws SQLException {
		log.info("Getting default perils...");
		return this.getSqlMapClient().queryForList("getDefaultPerils", params);
	}

	@Override
	public String getDefaultRate(String perilCd, String lineCd)
			throws SQLException {
		log.info("Getting Default Rate");
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("perilCd", perilCd);
		params.put("lineCd", lineCd);
		return (String) this.getSqlMapClient().queryForObject("getDefaultRate", params);
	}

	@SuppressWarnings("unchecked")
	public List<GIISPeril> getPackPlanPerils(Map<String, Object> params)
			throws SQLException {
		log.info("Getting package plan perils...");
		return this.getSqlMapClient().queryForList("getPackPlanPerils", params);
	}
	
	public String getDefPerilAmts(Map<String, Object> params)
			throws SQLException {
		log.info("Getting default peril amounts...");
		return (String) this.getSqlMapClient().queryForObject("getDefPerilAmts", params);
	}

	@Override
	public String chkIfTariffPerilExsts(Map<String, Object> params)
			throws SQLException {
		log.info("Checking if perils based on tariff exists...");
		return (String) this.getSqlMapClient().queryForObject("chkIfTariffPerilExsts", params);
	}

	@Override
	public String chkPerilZoneType(Map<String, Object> params) throws SQLException {	//Gzelle 05252015 SR4347
		log.info("Checking if peril has maintained zone type...");
		return (String) this.getSqlMapClient().queryForObject("chkPerilZoneType", params);
	}
}
