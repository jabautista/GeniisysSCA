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

import com.geniisys.gipi.dao.GIPIWPerilDiscountDAO;
import com.geniisys.gipi.entity.GIPIWPerilDiscount;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWPerilDiscountDAOImpl.
 */
public class GIPIWPerilDiscountDAOImpl implements GIPIWPerilDiscountDAO{
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPerilDiscountDAOImpl.class);
	
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
	 * @see com.geniisys.gipi.dao.GIPIWPerilDiscountDAO#getGipiWPerilDiscount(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPerilDiscount> getGipiWPerilDiscount(Integer parId)
			throws SQLException {
		log.info("Getting peril discount/surcharge...");
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		return this.getSqlMapClient().queryForList("selectGIPIWPerilDiscount", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPerilDiscountDAO#getOrigPerilPrem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> getOrigPerilPrem(Integer parId, String itemNo,
			String perilCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo);
		params.put("perilCd", perilCd);
		this.sqlMapClient.queryForObject("getOrigPerilPrem", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPerilDiscountDAO#setOrigAmount2(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> setOrigAmount2(Integer parId, String itemNo,
			String perilCd, String sequence) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo);
		params.put("perilCd", perilCd);
		params.put("sequence", sequence);
		this.sqlMapClient.queryForObject("setOrigAmount2", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPerilDiscountDAO#getNetPerilPrem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> getNetPerilPrem(Integer parId, String itemNo,
			String perilCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo);
		params.put("perilCd", perilCd);
		this.sqlMapClient.queryForObject("getNetPerilPrem", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPerilDiscount> getDeleteDiscountList(Integer parId)
			throws SQLException {		
		return this.getSqlMapClient().queryForList("getGIPIWPerilDiscount", parId);
	}

}
