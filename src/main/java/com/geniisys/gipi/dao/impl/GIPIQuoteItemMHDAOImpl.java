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

import com.geniisys.gipi.dao.GIPIQuoteItemMHDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemMH;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemMHDAOImpl.
 */
public class GIPIQuoteItemMHDAOImpl implements GIPIQuoteItemMHDAO {

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
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMHDAO#getGIPIQuoteItemMHDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemMH getGIPIQuoteItemMHDetails(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		return (GIPIQuoteItemMH) this.getSqlMapClient().queryForObject("getGIPIQuoteItemMHDetails", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMHDAO#saveGIPIQuoteItemMH(com.geniisys.gipi.entity.GIPIQuoteItemMH)
	 */
	@Override
	public void saveGIPIQuoteItemMH(GIPIQuoteItemMH quoteItemMH)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteItemMH", quoteItemMH);
	}

	@Override
	public void deleteGIPIQuoteItemMH(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemMH", params);
	}

	@Override
	public List<GIPIQuoteItemMH> getGIPIQuoteItemMHs(int quoteId)
			throws SQLException {
		return null;
	}

}
