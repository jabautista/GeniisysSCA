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

import com.geniisys.gipi.dao.GIPIQuoteItemACDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemAC;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemACDAOImpl.
 */
public class GIPIQuoteItemACDAOImpl implements GIPIQuoteItemACDAO {

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
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemACDAO#getGIPIQuoteItemAc(int, int)
	 */
	public GIPIQuoteItemAC getGIPIQuoteItemAc(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		return (GIPIQuoteItemAC) this.sqlMapClient.queryForObject("getGIPIQuoteItemAC", params);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemACDAO#saveGIPIquoteItemAC(com.geniisys.gipi.entity.GIPIQuoteItemAC)
	 */
	@Override
	public void saveGIPIquoteItemAC(GIPIQuoteItemAC quoteItemAC)
			throws SQLException {
		this.sqlMapClient.insert("saveGIPIQuoteItemAC", quoteItemAC);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemACDAO#deleteGIPIQuoteItemAC(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemAC(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemAC", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemACDAO#getGIPIQuoteItemACs(int)
	 */
	@Override
	public List<GIPIQuoteItemAC> getGIPIQuoteItemACs(int quoteId)
			throws SQLException {
		// TODO retrieve all gipi quote item mcs
		// create ibatis query
		return null;
	}

}
