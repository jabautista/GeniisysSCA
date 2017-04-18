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

import com.geniisys.gipi.dao.GIPIWinvTaxDAO;
import com.geniisys.gipi.entity.GIPIWinvTax;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWinvTaxDAOImpl.
 */
public class GIPIWinvTaxDAOImpl implements GIPIWinvTaxDAO {
	
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
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWinvTaxDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvTaxDAO#getGIPIWinvTax(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWinvTax> getGIPIWinvTax(int parId, int itemGrp)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("itemGrp", itemGrp);
		//param.put("takeupSeqNo", takeupSeqNo);
		log.info("DAO - Retrieving Tax...");
		List<GIPIWinvTax> gipiWinvTax = getSqlMapClient().queryForList("getWinvTax", param);
		log.info("DAO - WinvTax Size(): " + gipiWinvTax.size());
		return gipiWinvTax;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvTaxDAO#saveGIPIWinvTax(com.geniisys.gipi.entity.GIPIWinvTax)
	 */
	@Override
	public boolean saveGIPIWinvTax(GIPIWinvTax winvtax) throws SQLException {
		log.info("DAO - Inserting Winvtax ...");
		this.sqlMapClient.insert("saveGIPIWinvTax", winvtax);
		log.info("DAO - Winvtax inserted.");
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvTaxDAO#deleteAllGIPIWinvTax(int)
	 */
	@Override
	public boolean deleteAllGIPIWinvTax(int parId) throws SQLException {
			Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("parId", parId);
		//param.put("itemGrp", itemGrp);
		
		log.info("DAO - Deleting all WinvTax... " + parId);// + " " + itemGrp);
		this.sqlMapClient.delete("deleteAllGIPIWinvTax", parId);
		log.info("DAO - All WinvTax deleted.");
		
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvTaxDAO#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWinvTax", params);
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvTaxDAO#getGIPIWinvTax2(int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWinvTax> getGIPIWinvTax2(int parId)	throws SQLException {
		//param.put("takeupSeqNo", takeupSeqNo);
		log.info("DAO - Retrieving Tax2()...");
		List<GIPIWinvTax> gipiWinvTax = getSqlMapClient().queryForList("getWinvTax3", parId);
		log.info("DAO - WinvTax Size2(): " + gipiWinvTax.size());
		return gipiWinvTax;
	}
}
