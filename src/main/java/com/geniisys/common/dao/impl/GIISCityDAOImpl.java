package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISCityDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCityDAOImpl implements GIISCityDAO{
	
	/** The log. */
	private Logger log = Logger.getLogger(GIISCityDAOImpl.class);
	
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
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISCityDAO#getCityDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCityDtls(Map<String, Object> params)
			throws SQLException {
		log.info("get City Details");
		return this.getSqlMapClient().queryForList("getCityDtlLOV", params);
	}

}
