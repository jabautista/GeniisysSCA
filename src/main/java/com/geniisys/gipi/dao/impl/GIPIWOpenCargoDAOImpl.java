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

import com.geniisys.gipi.dao.GIPIWOpenCargoDAO;
import com.geniisys.gipi.entity.GIPIWOpenCargo;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWOpenCargoDAOImpl.
 */
public class GIPIWOpenCargoDAOImpl implements GIPIWOpenCargoDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenCargoDAOImpl.class);
	
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
	 * @see com.geniisys.gipi.dao.GIPIWOpenCargoDAO#getWOpenCargo(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWOpenCargo> getWOpenCargo(int parId, int geogCd) throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("geogCd", geogCd);
		
		log.info("DAO - Retrieving WOpenCargo/s...");
		List<GIPIWOpenCargo> wopenCargos = this.getSqlMapClient().queryForList("getGIPIWOpenCargo", params); 
		log.info("DAO - " + wopenCargos.size() + " WOpenCargo/s retrieved.");
		
		return wopenCargos;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenCargoDAO#saveWOpenCargo(com.geniisys.gipi.entity.GIPIWOpenCargo)
	 */
	@Override
	public boolean saveWOpenCargo(GIPIWOpenCargo wopenCargo)
			throws SQLException {
		
		log.info("DAO - Inserting WOpenCargo...");
		this.getSqlMapClient().insert("saveGIPIWOpenCargo", wopenCargo);
		log.info("DAO - WOpenCargo inserted.");
		
		return true;
	}

	/*	 (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenCargoDAO#deleteWOpenCargo(int, int, int)
	 */ 
	@Override
	public boolean deleteWOpenCargo(int parId, int geogCd, int cargoClassCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("geogCd", geogCd);
		params.put("cargoClassCd", cargoClassCd);
		
		log.info("DAO - Deleting WOpenCargo...");
		this.getSqlMapClient().delete("deleteGIPIWOpenCargo", params);
		log.info("DAO - WOpenCargo deleted.");
		
		return true;
	}
	
	public boolean deleteWOpenCargo(Map<String, Object> delWOpenCargo) throws SQLException{
		
		String[] cargoClassCds = (String[]) delWOpenCargo.get("cargoClassCds");
		int parId  			   = (Integer) delWOpenCargo.get("parId");
		int geogCd			   = (Integer) delWOpenCargo.get("geogCd");
		
		if (cargoClassCds != null){
			log.info("DAO - Deleting WOpenCargo/s....");
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("geogCd", geogCd);
			
			for (int i = 0; i < cargoClassCds.length; i++){
				params.put("cargoClassCd", cargoClassCds[i]);
				this.getSqlMapClient().delete("deleteGIPIWOpenCargo", params);
			}
			log.info("DAO - " + cargoClassCds.length + " WOpenCargo/s deleted");
		}
		
		return true;
	}
	
}
