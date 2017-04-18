/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.common.entity.GIISLostBid;
import com.geniisys.gipi.dao.GIPIQuoteVesAirDAO;
import com.geniisys.gipi.entity.GIPIQuotation;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteVesAir;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWVesAirDAOImpl.
 */
public class GIPIQuoteVesAirDAOImpl implements GIPIQuoteVesAirDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteVesAirDAOImpl.class);
	
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
	public List<GIPIQuoteVesAir> getQuoteVesAir(int quoteId) throws SQLException {
		
		log.info("DAO - Retrieving VesAir...");
		List<GIPIQuoteVesAir> quoteVesAirs = this.getSqlMapClient().queryForList("getGIPIQuoteVesAir", quoteId);
		log.info("DAO - " + quoteVesAirs.size() + " VesAir/s retrieved");
		
		return quoteVesAirs;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWVesAirDAO#deleteAllWVesAir(int)
	 */
	
	/*@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteVesAir> getQuoteVesAir2(Map<String, Object> params) throws SQLException, JSONException { //steven 3.13.2012
		log.info("DAO - Retrieving VesAir...");
		List<GIPIQuoteVesAir> quoteVesAirs=new ArrayList<GIPIQuoteVesAir>();
		quoteVesAirs=this.getSqlMapClient().queryForList("getGIPIQuoteVesAir", params);
		log.info("DAO - " + quoteVesAirs.size() + " VesAir/s retrieved");
		
		return quoteVesAirs;
	}
	*/
	@Override
	public boolean deleteAllQuoteVesAir(int quoteId) throws SQLException {
		
		log.info("DAO - Deleting VesAir...");
		this.getSqlMapClient().delete("deleteAllGIPIWVesAir", quoteId);
		log.info("DAO - All VesAir/s deleted");		
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWVesAirDAO#saveWVesAir(com.geniisys.gipi.entity.GIPIWVesAir)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveQuoteVesAir(Map<String, Object> allParameters) throws Exception {
		
		Map<String, Object> delParams = (Map<String, Object>) allParameters.get("delParams");
		Map<String, Object> insParams = (Map<String, Object>) allParameters.get("insParams");
		
		String[] vesselCds = (String[]) insParams.get("vesselCds");
		String[] recFlags  = (String[]) insParams.get("recFlags");
		Integer quoteId	   = (Integer) insParams.get("quoteId");
			
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.deleteQuoteVesAir(delParams);
			
			if (vesselCds != null){
				GIPIQuoteVesAir quoteVesAir = null;
				log.info("DAO - Inserting VesAir/s...");
				for(int i = 0; i < vesselCds.length; i++){
					quoteVesAir = new GIPIQuoteVesAir();
					quoteVesAir.setQuoteId(quoteId);
					quoteVesAir.setVesselCd(vesselCds[i]);
					quoteVesAir.setRecFlag(recFlags[i]);
					System.out.println(quoteId+" - "+vesselCds[i]+" - "+recFlags[i]);
					this.getSqlMapClient().insert("saveGIPIQuoteVesAir", quoteVesAir);
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
	public boolean deleteQuoteVesAir(Map<String, Object> delParams)
			throws SQLException {
		
		String[] vesselCds = (String[]) delParams.get("vesselCds");
		Integer quoteId	   = (Integer) delParams.get("quoteId");
		
		if (vesselCds != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", quoteId);
			
			log.info("DAO - Deleting VesAir/s...");
			for(int i = 0; i < vesselCds.length; i++){				
				params.put("vesselCd", vesselCds[i]);
				
				//this.getSqlMapClient().delete("deleteGIPIWVesAir", params);
				this.getSqlMapClient().delete("deleteGIPIQuoteVesAir", params);
			}
			log.info("DAO - " + vesselCds.length + " VesAir/s deleted.");
		}
		
		return false;
	}

	@Override
	public Map<String, String> isGIPIQuoteVesAirExist(Integer quoteId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("quoteId", quoteId.toString());
		this.sqlMapClient.update("checkIfGIPIQuoteVesAirExist", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteVesAir> getPackQuoteVesAir(Integer packQuoteId)
			throws SQLException {
		List<GIPIQuote> packQuoteList = this.getSqlMapClient().queryForList("getPackQuoteListForCarrierInfo", packQuoteId);
		List<GIPIQuoteVesAir> packQuoteVesAir = new ArrayList<GIPIQuoteVesAir>();
		
		for(GIPIQuote quote : packQuoteList){
			List<GIPIQuoteVesAir> quoteVesAir = this.getQuoteVesAir(quote.getQuoteId());
			
			for(GIPIQuoteVesAir va : quoteVesAir){
				packQuoteVesAir.add(va);
			}
		}
		return packQuoteVesAir;
	}

	@Override
	public void saveCarrierInfoForPackQuotation(List<GIPIQuoteVesAir> setRows,
			List<GIPIQuoteVesAir> delRows) throws Exception {
		
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			Map<String, Object> params = new HashMap<String, Object>();
			
			for(GIPIQuoteVesAir del: delRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", del.getQuoteId());
				params.put("vesselCd", del.getVesselCd());
				this.getSqlMapClient().delete("deleteGIPIQuoteVesAir", params);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteVesAir set: setRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteVesAir", set);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		
	}

	@Override
	public void deleteQuoteVesAir2(int quoteId,String[] vesselCds) throws SQLException { //steven 3.15.2012
		if (vesselCds != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", quoteId);
			
			log.info("DAO - Deleting VesAir/s...");
			for(int i = 0; i < vesselCds.length; i++){				
				params.put("vesselCd", vesselCds[i]);
				
				this.getSqlMapClient().delete("deleteGIPIQuoteVesAir", params);
			}
			log.info("DAO - " + vesselCds.length + " VesAir/s deleted.");
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveQuoteVesAir2(Map<String, Object> allParameters)
			throws Exception { //steven 3.15.2012
		List<GIPIQuoteVesAir> delParams =  (List<GIPIQuoteVesAir>) allParameters.get("delParams");
		List<GIPIQuoteVesAir> insParams =  (List<GIPIQuoteVesAir>) allParameters.get("insParams");
 		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(delParams != null){
				String[] delVesselCds = new String[delParams.size()];
				int delQuoteId=0;
				int cnt = 0;
				for(GIPIQuoteVesAir carrierInfo: delParams){
					delVesselCds[cnt] = carrierInfo.getVesselCd();
					delQuoteId=carrierInfo.getQuoteId();
					cnt++;
				}
				this.deleteQuoteVesAir2(delQuoteId, delVesselCds);
			}
			
			if(insParams != null){
				GIPIQuoteVesAir quoteVesAir = null;
				for(GIPIQuoteVesAir carrierInfo: insParams){
					quoteVesAir = new GIPIQuoteVesAir();
					quoteVesAir.setQuoteId(carrierInfo.getQuoteId());
					quoteVesAir.setVesselCd(carrierInfo.getVesselCd());
					quoteVesAir.setRecFlag(carrierInfo.getRecFlag());
					this.getSqlMapClient().insert("saveGIPIQuoteVesAir", quoteVesAir);
				}
					log.info("DAO - VesAir/s inserted");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Updating Reasons successful.");
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Integer checkIfGIPIQuoteVesAirExist2(Integer quoteId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkIfGIPIQuoteVesAirExist2", quoteId);
	}
}
