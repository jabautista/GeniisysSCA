package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLCatDtlDAO;
import com.geniisys.gicl.entity.GICLCatDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLCatDtlDAOImpl implements GICLCatDtlDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GICLCatDtlDAOImpl.class);
	
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
	 * @see com.geniisys.gicl.dao.GICLCatDtlDAO#getCatDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLCatDtl> getCatDtls(Map<String, Object> params) throws SQLException {
		log.info("getCatDtls");
		return this.getSqlMapClient().queryForList("getGiclCatDtlLOV", params);
	}

}
