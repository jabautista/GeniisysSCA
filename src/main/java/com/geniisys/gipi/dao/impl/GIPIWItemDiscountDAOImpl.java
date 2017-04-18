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
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWItemDiscountDAO;
import com.geniisys.gipi.entity.GIPIWItemDiscount;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWItemDiscountDAOImpl.
 */
public class GIPIWItemDiscountDAOImpl implements GIPIWItemDiscountDAO{

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWItemDiscountDAOImpl.class);
	
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
	 * @see com.geniisys.gipi.dao.GIPIWItemDiscountDAO#getGipiWItemDiscount(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemDiscount> getGipiWItemDiscount(Integer parId)
			throws SQLException {
		log.info("Getting item discount/surcharge...");
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		return this.getSqlMapClient().queryForList("selectGIPIWItemDiscount", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDiscountDAO#getOrigItemPrem(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> getOrigItemPrem(Integer parId, String itemNo)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo);
		this.sqlMapClient.queryForObject("getOrigItemPrem", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDiscountDAO#getNetItemPrem(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> getNetItemPrem(Integer parId, String itemNo, HashMap<String, Object> mainParams)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo);
		this.sqlMapClient.queryForObject("getNetItemPrem", params);
		return params;
	}

}
