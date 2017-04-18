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
import com.geniisys.gipi.dao.GIPIWOpenLiabDAO;
import com.geniisys.gipi.dao.GIPIWOpenPerilDAO;
import com.geniisys.gipi.entity.GIPIWOpenCargo;
import com.geniisys.gipi.entity.GIPIWOpenLiab;
import com.geniisys.gipi.entity.GIPIWOpenPeril;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWOpenLiabDAOImpl.
 */
public class GIPIWOpenLiabDAOImpl implements GIPIWOpenLiabDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	private GIPIWOpenPerilDAO gipiWOpenPerilDAO;
	private GIPIWOpenCargoDAO gipiWOpenCargoDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenLiabDAOImpl.class);
	
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
	 * @see com.geniisys.gipi.dao.GIPIWOpenLiabDAO#getWOpenLiab(int)
	 */
	@Override
	public GIPIWOpenLiab getWOpenLiab(int parId) throws SQLException {
		
		log.info("DAO - Retrieving WOpenLiab...");
		GIPIWOpenLiab wopenLiab = (GIPIWOpenLiab) this.getSqlMapClient().queryForObject("getGIPIWOpenLiab", parId); 
		log.info("DAO - WOpenLiab retrieved.");
		
		return wopenLiab;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenLiabDAO#saveWOpenLiab(com.geniisys.gipi.entity.GIPIWOpenLiab)
	 */
/*	@Override
	public boolean saveWOpenLiab(GIPIWOpenLiab wopenLiab) throws SQLException {
		
		log.info("DAO - Saving WOpenLiab...");
		this.getSqlMapClient().insert("saveGIPIWOpenLiab", wopenLiab);
		log.info("DAO - WOpenLiab saved.");
		
		return true;
	}*/

	@Override
	public boolean deleteWOpenLiab(int parId, int geogCd) throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("geogCd", geogCd);
		
		log.info("DAO - Deleting WOpenLiab...");
		this.getSqlMapClient().delete("deleteGIPIWOpenLiab", params);
		log.info("DAO - WOpenLiab deleted.");
		
		return true;
	}
	
	public boolean deleteWOpenLiab(Map<String, Object> delWOpenLiab) throws SQLException {
		
		if(0 != (Integer) delWOpenLiab.get("geogCd")){
			log.info("DAO - Deleting WOpenLiab...");
			this.getSqlMapClient().delete("deleteGIPIWOpenLiab", delWOpenLiab);
			log.info("DAO - WOpenLiab deleted.");
		}
		
		return true;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveLimitOfLiability(Map<String, Object> preparedParams)
			throws Exception {
		GIPIWOpenLiab wopenLiab = (GIPIWOpenLiab) preparedParams.get("wopenLiab");
		List<GIPIWOpenCargo> wopenCargos = (List<GIPIWOpenCargo>) preparedParams.get("wopenCargos");
		List<GIPIWOpenPeril> wopenPerils = (List<GIPIWOpenPeril>) preparedParams.get("wopenPerils");
		
		Map<String, Object> delWOpenLiab = (Map<String, Object>) preparedParams.get("delWOpenLiab");
		Map<String, Object> delWOpenCargo = (Map<String, Object>) preparedParams.get("delWOpenCargo");
		Map<String, Object> delWOpenPeril = (Map<String, Object>) preparedParams.get("delWOpenPeril");
		Map<String, Object> checkParams = (Map<String, Object>) preparedParams.get("checkParams");
		Map<String, Object> postParams = (Map<String, Object>) preparedParams.get("postParams");
		
		try {
			log.info("DAO - Saving Limit of Liability...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getGipiWOpenPerilDAO().deleteWOpenPeril(delWOpenPeril);			
			this.getGipiWOpenCargoDAO().deleteWOpenCargo(delWOpenCargo);
			//this.deleteWOpenPeril(delWOpenPeril);
			//this.deleteWOpenCargo(delWOpenCargo);
			this.deleteWOpenLiab(delWOpenLiab);
			
			if(wopenLiab != null){
				String recFlag = this.getRecFlag(checkParams);
				wopenLiab.setRecFlag(recFlag);
				
				log.info("DAO - Inserting WOpenLiab...");
				this.getSqlMapClient().insert("saveGIPIWOpenLiab", wopenLiab);
				log.info("DAO - WOpenLiab inserted");	
			}				
			
			if(wopenCargos != null){
				log.info("DAO - Inserting WOpenCargo/s...");	
				for(GIPIWOpenCargo cargo : wopenCargos){
					this.getSqlMapClient().insert("saveGIPIWOpenCargo", cargo);
				}
				log.info("DAO - " + wopenCargos.size() +" WOpenCargo/s inserted.");
			}						
			
			if(wopenPerils != null){
				log.info("DAO - Inserting WOpenPeril/s...");
				for(GIPIWOpenPeril peril : wopenPerils){
					this.getSqlMapClient().insert("saveGIPIWOpenPeril", peril);					
				}
				log.info("DAO - " + wopenPerils.size() +" WOpenPeril/s inserted.");
			}
			
			if(wopenLiab != null){
				this.doPostActions(postParams);
			}
			
			if(0 != (Integer) delWOpenLiab.get("geogCd")){
				this.doPostDeleteActions(delWOpenLiab);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();

			log.info("DAO - Limit of Liability saved.");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return true;
	}
	
/*	private boolean deleteWOpenCargo(Map<String, Object> delWOpenCargo) throws SQLException{
		
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
	}*/
	
/*	private boolean deleteWOpenPeril(Map<String, Object> delWOpenPeril) throws SQLException{
		
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
	}*/
	
	private String getRecFlag(Map<String, Object> checkParams) throws SQLException{
		
		log.info("DAO - Retrieving recFlag....");
		this.getSqlMapClient().update("getRecFlag", checkParams);
		log.info("DAO - recFlag retrieved: " + checkParams.get("message"));
		
		return (String) checkParams.get("recFlag");
	}
	
	private String doPostActions(Map<String, Object> postParams) throws SQLException{
		
		log.info("DAO - Executing post actions....");
		this.getSqlMapClient().insert("doPostActions", postParams);
		log.info("DAO - Post actions done.");
		
		return null;
	}
	
	private String doPostDeleteActions(Map<String, Object> postDeleteParams) throws SQLException{
		
		log.info("DAO - Executing post delete actions....");
		this.getSqlMapClient().insert("doPostDeleteActions", postDeleteParams);
		log.info("DAO - Post Delete actions done.");
		
		return null;
	}

	public void setGipiWOpenPerilDAO(GIPIWOpenPerilDAO gipiWOpenPerilDAO) {
		this.gipiWOpenPerilDAO = gipiWOpenPerilDAO;
	}

	public GIPIWOpenPerilDAO getGipiWOpenPerilDAO() {
		return gipiWOpenPerilDAO;
	}

	public void setGipiWOpenCargoDAO(GIPIWOpenCargoDAO gipiWOpenCargoDAO) {
		this.gipiWOpenCargoDAO = gipiWOpenCargoDAO;
	}

	public GIPIWOpenCargoDAO getGipiWOpenCargoDAO() {
		return gipiWOpenCargoDAO;
	}

	@Override
	public GIPIWOpenLiab getWOpenLiab(Map<String, Object> params)
			throws SQLException {
		log.info("DAO - Retrieving WOpenLiab...");
		GIPIWOpenLiab wopenLiab = (GIPIWOpenLiab) this.getSqlMapClient().queryForObject("getGIPIWOpenLiab", params); 
		log.info("DAO - WOpenLiab retrieved.");
		
		return wopenLiab;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getEndtLolVars(Integer parId)
			throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getEndtLolVars", parId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveEndtLimitOfLiability(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving Endorsement Limit Of Liability.");
			
			List<GIPIWOpenCargo> setCargoRows = (List<GIPIWOpenCargo>) params.get("setCargoRows");
			List<GIPIWOpenCargo> delCargoRows = (List<GIPIWOpenCargo>) params.get("delCargoRows");
			List<GIPIWOpenPeril> setPerilRows = (List<GIPIWOpenPeril>) params.get("setPerilRows");
			List<GIPIWOpenPeril> delPerilRows = (List<GIPIWOpenPeril>) params.get("delPerilRows");
			GIPIWOpenLiab gipiwOpenLiab = (GIPIWOpenLiab) params.get("gipiWOpenLiab");
			
			HashMap<String, Object> lolParams = new HashMap<String, Object>();
			lolParams.put("parId", params.get("parId"));
			lolParams.put("userId", params.get("userId"));
			
			if(params.get("deleteSw").equals("Y")){
				log.info("DELETING GIPIWOPenLiab...");
				this.getSqlMapClient().delete("preDeleteEndtLol", lolParams);
				this.getSqlMapClient().delete("deleteEndtLol", lolParams);
				this.getSqlMapClient().executeBatch();
			}
			if(params.get("geogCd") != ""){
				log.info("INSERTING GipiWOpenLiab...");
				this.getSqlMapClient().insert("saveGIPIWOpenLiabEndt", gipiwOpenLiab);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIWOpenCargo del : delCargoRows){
				log.info("DELETING: " + del);
				HashMap<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("parId", del.getParId());
				delParams.put("geogCd", del.getGeogCd());
				delParams.put("cargoClassCd", del.getCargoClassCd());
				this.getSqlMapClient().delete("deleteGIPIWOpenCargo", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWOpenCargo set : setCargoRows){
				log.info("INSERTING: " + set);
				set.setUserId((String)params.get("userId"));
				this.getSqlMapClient().insert("setGIPIWOpenCargo", set);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWOpenPeril del : delPerilRows){
				log.info("DELETING: " + del);
				HashMap<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("parId", del.getParId());
				delParams.put("geogCd", del.getGeogCd());
				delParams.put("lineCd", del.getLineCd());
				delParams.put("perilCd", del.getPerilCd());
				this.getSqlMapClient().delete("deleteGIPIWOpenPeril", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWOpenPeril set : setPerilRows){
				log.info("INSERTING: " + set);
				set.setUserId((String)params.get("userId"));
				this.getSqlMapClient().insert("saveGIPIWOpenPeril", set);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("postFormsCommitGIPIS078...");
			this.getSqlMapClient().update("postFormsCommitGIPIS078", params.get("postFormParams"));
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving Endorsement Limit of Liability.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public Map<String, Object> getDefaultCurrency(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getDefaultCurrencyGIPIS078", params);
		return params;
	}

	@Override
	public Map<String, Object> checkRiskNote(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkRiskNote", params);
		return params;
	}
	
	
	
	// start of methods for GIPIS173
	@Override
	public Map<String, Object> getDefaultCurrencyGIPIS173(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getDefaultCurrencyGIPIS173", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveEndtLolGIPIS173(Map<String, Object> params) throws SQLException {
		String message = ""; //"SUCCESS";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DAO - Start of saving Endorsement Limit Of Liability Data Entry.");
			
			List<GIPIWOpenPeril> delPerilRows = (List<GIPIWOpenPeril>) params.get("delPerilRows");
			List<GIPIWOpenPeril> setPerilRows = (List<GIPIWOpenPeril>) params.get("setPerilRows");
			GIPIWOpenLiab gipiWOpenLiab = (GIPIWOpenLiab) params.get("gipiWOpenLiab");
			System.out.println("delPerilRows: " + delPerilRows);
			System.out.println("setPerilRows: " + setPerilRows);
			
			Map<String, Object> lolParams = new HashMap<String, Object>();
			lolParams.put("parId", params.get("parId"));
			lolParams.put("userId", params.get("userId"));
			
			if(params.get("deleteSw").equals("Y")){
				lolParams.put("geogCd", params.get("geogCd"));
				log.info("DAO - DELETING GIPIWOPenLiab...");
				
				this.getSqlMapClient().delete("deleteEndtLolGIPIS173", lolParams);
				this.getSqlMapClient().executeBatch();
			} else {
				if(params.get("geogCd") != ""){ // bi
					log.info("DAO - Inserting Limit of Liability...");
					this.getSqlMapClient().insert("saveGIPIWOpenLiab", gipiWOpenLiab);
					this.getSqlMapClient().executeBatch();
					log.info("DAO - Inserted Limit of Liability...");
				}
				
				if(delPerilRows != null){ //bi
					for(GIPIWOpenPeril peril : delPerilRows){
						log.info("DAO - DELETING: " + peril);
						Map<String, Object> delParams = new HashMap<String, Object>();
						delParams.put("parId", peril.getParId());
						delParams.put("geogCd", peril.getGeogCd());
						delParams.put("lineCd", peril.getLineCd());
						delParams.put("perilCd", peril.getPerilCd());
						this.getSqlMapClient().delete("deleteGIPIWOpenPeril", delParams);
						log.info("DAO - DELETED: " + peril);
					}
					this.getSqlMapClient().executeBatch();
					log.info("DAO - " + delPerilRows.size() +" peril/s successfully deleted.");
				}
				
				if(setPerilRows != null){ //bi
					for(GIPIWOpenPeril peril : setPerilRows){
						log.info("INSERTING: " + peril);
						peril.setUserId((String)params.get("userId"));
						this.getSqlMapClient().insert("saveGIPIWOpenPeril", peril);
					}
					this.getSqlMapClient().executeBatch();
					log.info("DAO - " + setPerilRows.size() + " peril/s successfully inserted/updated.");
				}
			}
			
			// Execute the Post-Forms-Commit
			log.info("DAO - Post-Forms-Commit begin...");
			
			this.getSqlMapClient().update("doPostFormsCommitGIPIS173",  params.get("postFormParams"));
			this.getSqlMapClient().executeBatch();
			
			log.info("DAO - Post-Forms-Commit done.");
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			log.info("End of saving Endorsement Limit of Liability Data Entry.");
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}

	@Override
	public Map<String, Object> getRecFlagGIPIS173(Map<String, Object> params)
			throws SQLException {
		
		log.info("DAO - Retrieving recFlag....");
		this.getSqlMapClient().update("getRecFlagGIPIS173", params);
		
		return params;
	}
}
