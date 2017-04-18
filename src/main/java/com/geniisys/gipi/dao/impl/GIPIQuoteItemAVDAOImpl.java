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

import com.geniisys.gipi.dao.GIPIQuoteItemAVDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemAV;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemAVDAOImpl.
 */
public class GIPIQuoteItemAVDAOImpl implements GIPIQuoteItemAVDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/**
	 * Gets the sql map client.
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemAVDAO#getGIPIQuoteItemAVDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemAV getGIPIQuoteItemAVDetails(int quoteId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		
		return (GIPIQuoteItemAV) getSqlMapClient().queryForObject("getGIPIQuoteItemAVDetails", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemAVDAO#saveGIPIQuoteItemAV(com.geniisys.gipi.entity.GIPIQuoteItemAV)
	 */
	@Override
	public void saveGIPIQuoteItemAV(GIPIQuoteItemAV quoteItemAV) throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteItemAV", quoteItemAV);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemAVDAO#deleteGIPIQuoteItemAV(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemAV(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemAV", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemAVDAO#getGIPIQuoteItemAVs(int)
	 */
	@Override
	public List<GIPIQuoteItemAV> getGIPIQuoteItemAVs(int quoteId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		//return this.sqlMapClient.queryForList("", params);
		return null;
	}

}
