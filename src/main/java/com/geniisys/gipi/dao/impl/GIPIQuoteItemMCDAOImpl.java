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

import com.geniisys.gipi.dao.GIPIQuoteItemMCDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemMC;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteItemMCDAOImpl.
 */
public class GIPIQuoteItemMCDAOImpl implements GIPIQuoteItemMCDAO {

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
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getGIPIQuoteItemMC(int, int)
	 */
	@Override
	public GIPIQuoteItemMC getGIPIQuoteItemMC(int quoteId, int itemNo) throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		System.out.println("Quote Id: " + quoteId + " || item No: " + itemNo);
		return (GIPIQuoteItemMC) this.getSqlMapClient().queryForObject("getGIPIQuoteItemMC", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getAllSerialMc()
	 */
	@SuppressWarnings("unchecked")
	public List<String> getAllSerialMc() throws SQLException{
		return (List<String>) sqlMapClient.queryForList("getAllSerialMc");
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getAllMotorMc()
	 */
	@SuppressWarnings("unchecked")
	public List<String> getAllMotorMc() throws SQLException{
		return (List<String>) sqlMapClient.queryForList("getAllMotorMc");
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getAllPlateMc()
	 */
	@SuppressWarnings("unchecked")
	public List<String> getAllPlateMc() throws SQLException{
		return (List<String>) sqlMapClient.queryForList("getAllPlateMc");
	
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getAllCocMc()
	 */
	@SuppressWarnings("unchecked")
	public List<String> getAllCocMc() throws SQLException{
		return (List<String>) sqlMapClient.queryForList("getAllCocMc");
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getGIPIQuoteItemMCs(int, int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItemMC> getGIPIQuoteItemMCs(int quoteId, int itemNo) throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", 0);
		return (List<GIPIQuoteItemMC>) this.getSqlMapClient().queryForObject("getGIPIQuoteItemMC", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#saveGIPIQuoteItemMC(com.geniisys.gipi.entity.GIPIQuoteItemMC)
	 */
	@Override
	public void saveGIPIQuoteItemMC(GIPIQuoteItemMC quoteItemMC)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteItemMC", quoteItemMC);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#deleteGIPIQuoteItemMC(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemMC(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().delete("deleteGIPIQuoteItemMC", params);
	}
	
	public void deleteGipiQuoteItemAddInfoMc(int quoteId)throws SQLException{
		this.getSqlMapClient().delete("deleteAllItemAddInfoMC", quoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getGIPIQuoteItemMCs(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItemMC> getGIPIQuoteItemMCs(int quoteId) throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIQuoteItemMCs", quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemMCDAO#getDefaultTow(java.lang.String)
	 */
	@Override
	public int getDefaultTow(String subline) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("towing", "%TOWING%");
		params.put("subline", subline);
		int aa = 0;
		
		try{
			aa = (Integer) this.getSqlMapClient().queryForObject("getDefaultTow", params); // ****!
		}catch(NullPointerException nul){
			//nul.printStackTrace();
		}
		
		return aa;
	}

}
