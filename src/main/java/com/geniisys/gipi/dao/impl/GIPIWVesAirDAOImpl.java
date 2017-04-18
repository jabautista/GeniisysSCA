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
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWVesAirDAO;
import com.geniisys.gipi.entity.GIPIWVesAir;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWVesAirDAOImpl.
 */
public class GIPIWVesAirDAOImpl implements GIPIWVesAirDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWVesAirDAOImpl.class);
	
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
	 * @see com.geniisys.gipi.dao.GIPIWVesAirDAO#getWVesAir(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWVesAir> getWVesAir(int parId) throws SQLException {
		
		log.info("DAO - Retrieving VesAir...");
		List<GIPIWVesAir> wvesAirs = (List<GIPIWVesAir>) StringFormatter.escapeHTMLJavascriptInList(this.getSqlMapClient().queryForList("getGIPIWVesAir", parId));
		log.info("DAO - " + wvesAirs.size() + " VesAir/s retrieved");
		
		return wvesAirs;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWVesAirDAO#deleteAllWVesAir(int)
	 */
	@Override
	public boolean deleteAllWVesAir(int parId) throws SQLException {
		
		log.info("DAO - Deleting VesAir...");
		this.getSqlMapClient().delete("deleteAllGIPIWVesAir", parId);
		log.info("DAO - All VesAir/s deleted");		
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWVesAirDAO#saveWVesAir(com.geniisys.gipi.entity.GIPIWVesAir)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveWVesAir(Map<String, Object> allParameters) throws Exception {
		
		Map<String, Object> delParams = (Map<String, Object>) allParameters.get("delParams");
		Map<String, Object> insParams = (Map<String, Object>) allParameters.get("insParams");
		
		String[] vesselCds = (String[]) insParams.get("vesselCds");
		String[] recFlags  = (String[]) insParams.get("recFlags");
		Integer parId	   = (Integer) insParams.get("parId");
		String userId	   = (String) insParams.get("userId");
			
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.deleteWVesAir(delParams);
			
			if (vesselCds != null){
				GIPIWVesAir wvesAir = null;
				log.info("DAO - Inserting VesAir/s...");
				for(int i = 0; i < vesselCds.length; i++){
					wvesAir = new GIPIWVesAir();
					wvesAir.setParId(parId);
					wvesAir.setUserId(userId);
					wvesAir.setVesselCd(vesselCds[i]);
					wvesAir.setRecFlag(recFlags[i]);
					
					this.getSqlMapClient().insert("saveGIPIWVesAir", wvesAir);
				}
				log.info("DAO - " + vesselCds.length + " VesAir/s inserted.");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWVesAirDAO#deleteWVesAir(java.util.Map)
	 */
	@Override
	public boolean deleteWVesAir(Map<String, Object> delParams)
			throws SQLException {
		
		String[] vesselCds = (String[]) delParams.get("vesselCds");
		Integer parId	   = (Integer) delParams.get("parId");
		
		if (vesselCds != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			
			log.info("DAO - Deleting VesAir/s...");
			for(int i = 0; i < vesselCds.length; i++){
				params.put("vesselCd", vesselCds[i]);
				
				this.getSqlMapClient().delete("deleteGIPIWVesAir", params);
			}
			log.info("DAO - " + vesselCds.length + " VesAir/s deleted.");
		}
		
		return false;
	}

	@Override
	public void saveGIPIWVesAir(Map<String, List<GIPIWVesAir>> params) throws SQLException {
		List<GIPIWVesAir> setCIList = params.get("setCarInfo");
		List<GIPIWVesAir> delCIList = params.get("delCarInfo");
		try {
			log.info("Starting transaction...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = null;
			
			if (!delCIList.isEmpty()) {
				log.info("Deleting Required Documents...");
				for (GIPIWVesAir rd : delCIList) {
					parId = rd.getParId();
					log.info("Deleting Record: "
							+ (new JSONObject(rd)).toString());
					Map<String, Object> rec = new HashMap<String, Object>();
					rec.put("parId", rd.getParId());
					rec.put("vesselCd", rd.getVesselCd());
					this.getSqlMapClient().delete("deleteGIPIWVesAir", rec);
				}
				log.info("Finished deleting records.");
			}

			if (!setCIList.isEmpty()) {
				log.info("Saving Required Documents...");
				for (GIPIWVesAir wc : setCIList) {
					parId = wc.getParId();
					log.info("Saving Record: "
							+ (new JSONObject(wc)).toString());
					this.getSqlMapClient().insert("saveGIPIWVesAir", wc);
				}
				log.info("Finished inserting/updating records.");
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("valMultiVessel", parId);
			
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Transaction commited, finished.");
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
	
	public String checkUserPerIssCdAcctg2(Map<String, Object> params) //Added by Jerome 08.31.2016 SR 5623
			throws SQLException {
		//log.info("checkUserPerIssCdAcctg2...");
		Debug.print("checkUserPerIssCdAcctg2 - "+params);
		return (String) this.getSqlMapClient().queryForObject("checkUserPerIssCdAcctg3", params);
	}
		
}
