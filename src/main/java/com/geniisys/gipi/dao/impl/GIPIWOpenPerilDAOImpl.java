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

import com.geniisys.gipi.dao.GIPIWOpenPerilDAO;
import com.geniisys.gipi.entity.GIPIWOpenPeril;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWOpenPerilDAOImpl.
 */
public class GIPIWOpenPerilDAOImpl implements GIPIWOpenPerilDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenPerilDAOImpl.class);
	
	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenPerilDAO#getWOpenPeril(int, int, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWOpenPeril> getWOpenPeril(int parId, int geogCd, String lineCd) throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("geogCd", geogCd);
		params.put("lineCd", lineCd);
		
		log.info("DAO - Retrieving WOpenPeril/s...");
		List<GIPIWOpenPeril> wopenPerils = this.getSqlMapClient().queryForList("getGIPIWOpenPeril", params); 
		log.info("DAO - " + wopenPerils.size() + " WOpenPeril/s retrieved.");
		
		return wopenPerils;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenPerilDAO#deleteAllWOpenPeril(int, int, java.lang.String)
	 */
	@Override
	public boolean deleteAllWOpenPeril(int parId, int geogCd, String lineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("geogCd", geogCd);
		params.put("lineCd", lineCd);
		
		log.info("DAO - Deleting All WOpenPeril...");
		this.getSqlMapClient().delete("deleteAllGIPIWOpenPeril", params);
		log.info("DAO - All WOpenPeril deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenPerilDAO#saveWOpenPeril(com.geniisys.gipi.entity.GIPIWOpenPeril)
	 */
	@Override
	public boolean saveWOpenPeril(GIPIWOpenPeril wopenPeril)
			throws SQLException {
		
		log.info("DAO - Inserting WOpenPeril...");
		this.getSqlMapClient().insert("saveGIPIWOpenPeril", wopenPeril);
		log.info("DAO - WOpenPeril Inserted.");
		
		return true;
	}

	@Override
	public String checkWOpenPeril(Map<String, Object> params)
			throws SQLException {
		String message = null;
		
		log.info("DAO - Checking WOpenPeril...");
		this.getSqlMapClient().update("checkWOpenPeril", params);
		message = (String) params.get("message");
		log.info("DAO - WOpenPeril checked: " + message);
		
		return message;
	}
	
	public boolean deleteWOpenPeril(Map<String, Object> delWOpenPeril) throws SQLException{
		
		String[] perilCds = (String[]) delWOpenPeril.get("perilCds");
		int parId  		  = (Integer) delWOpenPeril.get("parId");
		int geogCd		  = (Integer) delWOpenPeril.get("geogCd");
		String lineCd	  = (String) delWOpenPeril.get("lineCd");
		
		if (perilCds != null){
			log.info("DAO - Deleting WOpenPeril/s....");
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("geogCd", geogCd);
			params.put("lineCd", lineCd);
			
			for (int i = 0; i < perilCds.length; i++){
				params.put("perilCd", perilCds[i]);
				this.getSqlMapClient().delete("deleteGIPIWOpenPeril", params);
			}
			log.info("DAO - " + perilCds.length + " WOpenPeril/s deleted");
		}
		
		return true;
	}

}
