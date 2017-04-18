/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWOpenCargoDAO;
import com.geniisys.gipi.entity.GIPIWOpenCargo;
import com.geniisys.gipi.service.GIPIWOpenCargoService;


/**
 * The Class GIPIWOpenCargoServiceImpl.
 */
public class GIPIWOpenCargoServiceImpl implements GIPIWOpenCargoService{

	/** The gipi w open cargo dao. */
	private GIPIWOpenCargoDAO gipiWOpenCargoDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenCargoServiceImpl.class);
	
	/**
	 * Sets the gipi w open cargo dao.
	 * 
	 * @param gipiWOpenCargoDAO the new gipi w open cargo dao
	 */
	public void setGipiWOpenCargoDAO(GIPIWOpenCargoDAO gipiWOpenCargoDAO) {
		this.gipiWOpenCargoDAO = gipiWOpenCargoDAO;
	}
	
	/**
	 * Gets the gipi w open cargo dao.
	 * 
	 * @return the gipi w open cargo dao
	 */
	public GIPIWOpenCargoDAO getGipiWOpenCargoDAO() {
		return gipiWOpenCargoDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenCargoService#getWOpenCargo(int, int)
	 */
	@Override
	public List<GIPIWOpenCargo> getWOpenCargo(int parId, int geogCd) throws SQLException {
		
		log.info("Retrieving OpenCargo/s...");
		List<GIPIWOpenCargo> wopenCargos = this.getGipiWOpenCargoDAO().getWOpenCargo(parId, geogCd); 
		log.info(wopenCargos.size() + " OpenCargo/s retrieved");
		
		return wopenCargos;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenCargoService#saveWOpenCargo(java.util.Map)
	 */
	@Override
	public boolean saveWOpenCargo(Map<String, Object> params)
			throws SQLException {
		String[] cargoClassCds = (String[]) params.get("cargoClassCds");
		int parId  			   = (Integer) params.get("parId");
		int geogCd			   = (Integer) params.get("geogCd");
		String userId 		   = (String) params.get("userId");
		
		if (cargoClassCds != null){
			log.info("Inserting WOpenCargo/s...");
			GIPIWOpenCargo wopenCargo = null;
			for (int i = 0; i < cargoClassCds.length; i++){
				wopenCargo = new GIPIWOpenCargo();
				
				wopenCargo.setParId(parId);
				wopenCargo.setGeogCd(geogCd);
				wopenCargo.setCargoClassCd(Integer.parseInt(cargoClassCds[i]));
				wopenCargo.setUserId(userId);
				
				this.getGipiWOpenCargoDAO().saveWOpenCargo(wopenCargo);
			}
			log.info(cargoClassCds.length + " WOpenCargo/s inserted.");
		}
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenCargoService#deleteWOpenCargo(java.util.Map)
	 */
	@Override
	public boolean deleteWOpenCargo(Map<String, Object> delParams)
			throws SQLException {
		String[] cargoClassCds = (String[]) delParams.get("cargoClassCds");
		int parId  			   = (Integer) delParams.get("parId");
		int geogCd			   = (Integer) delParams.get("geogCd");
		
		if (cargoClassCds != null){
			log.info("Deleting WOpenCargo/s...");
			for (int i = 0; i < cargoClassCds.length; i++){
				this.getGipiWOpenCargoDAO().deleteWOpenCargo(parId, geogCd, Integer.parseInt(cargoClassCds[i]));
			}
			log.info(cargoClassCds.length + " WOpenCargo/s deleted.");
		}
		
		return true;
	}
}
