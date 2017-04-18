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

import com.geniisys.gipi.dao.GIPIQuoteItemCADAO;
import com.geniisys.gipi.entity.GIPIQuoteItemCA;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemCADAOImpl.
 */
public class GIPIQuoteItemCADAOImpl implements GIPIQuoteItemCADAO {

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
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemCADAO#getGIPIQuoteItemCADetails(int, int)
	 */
	@Override
	public GIPIQuoteItemCA getGIPIQuoteItemCADetails(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		return (GIPIQuoteItemCA) this.getSqlMapClient().queryForObject("getGIPIQuoteItemCADetails", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemCADAO#saveGIPIQuoteItemCA(com.geniisys.gipi.entity.GIPIQuoteItemCA)
	 */
	@Override
	public void saveGIPIQuoteItemCA(GIPIQuoteItemCA quoteItemCA)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteItemCA", quoteItemCA);
	}

	@Override
	public void deleteGIPIQuoteItemCA(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemCA", params);
	}

	@Override
	public List<GIPIQuoteItemCA> getGIPIQuoteItemCAs(int quoteId)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

}
