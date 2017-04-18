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

import com.geniisys.gipi.dao.GIPIQuoteItemMNDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemMN;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemMNDAOImpl.
 */
public class GIPIQuoteItemMNDAOImpl implements GIPIQuoteItemMNDAO {

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
	 * @param getSqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient getSqlMapClient) {
		this.sqlMapClient = getSqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMNDAO#getGIPIQuoteItemMNDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemMN getGIPIQuoteItemMNDetails(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		return (GIPIQuoteItemMN) this.getSqlMapClient().queryForObject("getGIPIQuoteItemMNDetails", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMNDAO#saveGIPIQuoteItemMN(com.geniisys.gipi.entity.GIPIQuoteItemMN)
	 */
	@Override
	public void saveGIPIQuoteItemMN(GIPIQuoteItemMN quoteItemMN)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteItemMN", quoteItemMN);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMNDAO#deleteGIPIQuoteItemMN(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemMN(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemMN", params);
	}

	@Override
	public List<GIPIQuoteItemMN> getGIPIQuoteItemMNs(int quoteId)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

}
