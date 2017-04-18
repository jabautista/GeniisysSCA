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

import com.geniisys.gipi.dao.GIPIWinvperlDAO;
import com.geniisys.gipi.entity.GIPIWinvperl;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWinvperlDAOImpl.
 */
public class GIPIWinvperlDAOImpl implements GIPIWinvperlDAO{
	
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
	private static Logger log = Logger.getLogger(GIPIWinvperlDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvperlDAO#getGIPIWinvperl(int, int, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWinvperl> getGIPIWinvperl(int parId, int itemGrp, String lineCd) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("itemGrp", itemGrp);
		param.put("lineCd", lineCd);
		log.info("DAO - Retrieving invoice perils...");
		List<GIPIWinvperl> gipiWinvperl = getSqlMapClient().queryForList("getGIPIWinvperl", param);
		log.info("DAO - Winvperl Size(): " + gipiWinvperl.size());
		return gipiWinvperl;
		
		
		}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWinvperlDAO#getGIPIWinvperl(int, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWinvperl> getGIPIWinvperl(int parId, String lineCd)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("lineCd", lineCd);
		log.info("DAO - Retrieving invoice perils...");
		List<GIPIWinvperl> gipiWinvperl = getSqlMapClient().queryForList("getGIPIWinvperl2", param);
		log.info("DAO - Winvperl Size(): " + gipiWinvperl.size());
		return gipiWinvperl;
	}
		
		/* (non-Javadoc)
		 * @see com.geniisys.gipi.dao.GIPIWinvperlDAO#getItemGrpWinvperl(int)
		 */
		@SuppressWarnings("unchecked")
		public List<GIPIWinvperl> getItemGrpWinvperl(int parId) throws SQLException {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("parId", parId);
		
			log.info("DAO - Retrieving Distinct winvperl...");
			List<GIPIWinvperl> gipiWinvperl = getSqlMapClient().queryForList("getItemGrpWinvperl", param);
			log.info("DAO -  Distinct Winvperl Size(): " + gipiWinvperl.size());
			return gipiWinvperl;
		}
	
		/* (non-Javadoc)
		 * @see com.geniisys.gipi.dao.GIPIWinvperlDAO#getTakeupWinvperl(int)
		 */
		@SuppressWarnings("unchecked")
		public List<GIPIWinvperl> getTakeupWinvperl(int parId) throws SQLException{
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("parId", parId);
			
			log.info("DAO - Retrieving Distinct takeup winvperl...");
			List<GIPIWinvperl> gipiWinvperl = getSqlMapClient().queryForList("getTakeupWinvperl", param);
			log.info("DAO -  Distinct takeup Winvperl Size(): " + gipiWinvperl.size());
			return gipiWinvperl;
			
		}
}


