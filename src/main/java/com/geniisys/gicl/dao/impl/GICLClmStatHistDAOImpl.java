package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClmStatHistDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmStatHistDAOImpl implements GICLClmStatHistDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GICLClmStatHistDAOImpl.class);
	
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
	 * @see com.geniisys.gicl.dao.GICLClmStatHistDAO#getClmStatHistory(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getClmStatHistory(Map<String, Object> params) throws SQLException {
		log.info("get claim status history");
		return this.getSqlMapClient().queryForList("getStatHistTableGridListing", params);
	}

}
