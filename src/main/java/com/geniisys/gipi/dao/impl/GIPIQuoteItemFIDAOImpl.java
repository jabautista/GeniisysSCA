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

import com.geniisys.gipi.dao.GIPIQuoteItemFIDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemFI;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemFIDAOImpl.
 */
public class GIPIQuoteItemFIDAOImpl implements GIPIQuoteItemFIDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemFIDAO#getGIPIQuoteItemFI(int, int)
	 */
	@Override
	public GIPIQuoteItemFI getGIPIQuoteItemFI(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		System.out.println(quoteId);
		System.out.println(itemNo);
		GIPIQuoteItemFI fi = (GIPIQuoteItemFI) this.getSqlMapClient().queryForObject("getGIPIQuoteItemFI", params);
	
		return fi; 
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemFIDAO#deleteGIPIQuoteItemFI(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemFI(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemFI", params);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemFIDAO#saveGIPIQuoteItemFI(com.geniisys.gipi.entity.GIPIQuoteItemFI)
	 */
	@Override
	public void saveGIPIQuoteItemFI(GIPIQuoteItemFI quoteItemFI)
			throws SQLException {
		this.sqlMapClient.insert("saveGIPIQuoteItemFI", quoteItemFI);
	}

	@Override
	public List<GIPIQuoteItemFI> getGIPIQuoteItemFIs(int quoteId)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}
