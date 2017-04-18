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

import com.geniisys.gipi.dao.GIPIWOpenPerilDAO;
import com.geniisys.gipi.entity.GIPIWOpenPeril;
import com.geniisys.gipi.service.GIPIWOpenPerilService;


/**
 * The Class GIPIWOpenPerilServiceImpl.
 */
public class GIPIWOpenPerilServiceImpl implements GIPIWOpenPerilService{

	/** The gipi w open peril dao. */
	private GIPIWOpenPerilDAO gipiWOpenPerilDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenPerilServiceImpl.class);
	
	/**
	 * Sets the gipi w open peril dao.
	 * 
	 * @param gipiWOpenPerilDAO the new gipi w open peril dao
	 */
	public void setGipiWOpenPerilDAO(GIPIWOpenPerilDAO gipiWOpenPerilDAO) {
		this.gipiWOpenPerilDAO = gipiWOpenPerilDAO;
	}
	
	/**
	 * Gets the gipi w open peril dao.
	 * 
	 * @return the gipi w open peril dao
	 */
	public GIPIWOpenPerilDAO getGipiWOpenPerilDAO() {
		return gipiWOpenPerilDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenPerilService#getWOpenPeril(int, int, java.lang.String)
	 */
	@Override
	public List<GIPIWOpenPeril> getWOpenPeril(int parId, int geogCd, String lineCd) throws SQLException {
		
		log.info("Retrieving OpenPeril/s...");
		List<GIPIWOpenPeril> wopenPerils = this.getGipiWOpenPerilDAO().getWOpenPeril(parId, geogCd, lineCd); 
		log.info(wopenPerils.size() + " OpenPeril/s retrieved");
		
		return wopenPerils;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenPerilService#deleteAllWOpenPeril(int, int, java.lang.String)
	 */
	@Override
	public boolean deleteAllWOpenPeril(int parId, int geogCd, String lineCd)
			throws SQLException {
		
		log.info("Deleting All WOpenPeril...");
		this.getGipiWOpenPerilDAO().deleteAllWOpenPeril(parId, geogCd, lineCd);
		log.info("All WOpenPeril deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenPerilService#saveWOpenPeril(java.util.Map)
	 */
	@Override
	public boolean saveWOpenPeril(Map<String, Object> params)
			throws SQLException {
		
		int parId 			  = (Integer) params.get("parId");
		int geogCd 			  = (Integer) params.get("geogCd");
		String lineCd 		  = (String) params.get("lineCd");
		String[] perilCds 	  = (String[]) params.get("perilCds");
		String[] premiumRates = (String[]) params.get("premiumRates");
		String[] remarks 	  = (String[]) params.get("remarks");
		String userId 		  = (String) params.get("userId");

		this.getGipiWOpenPerilDAO().deleteAllWOpenPeril(parId, geogCd, lineCd);
		
		if (perilCds != null){
			GIPIWOpenPeril wopenPeril = null;
			log.info("Inserting WOpenPeril/s...");
			for(int i=0; i<perilCds.length; i++){
				wopenPeril = new GIPIWOpenPeril();
				
				wopenPeril.setParId(parId);
				wopenPeril.setGeogCd(geogCd);
				wopenPeril.setLineCd(lineCd);
				wopenPeril.setPerilCd(Integer.parseInt(perilCds[i]));
				//wopenPeril.setPremiumRate(new BigDecimal(premiumRates[i]));
				wopenPeril.setPremiumRate(Double.parseDouble(premiumRates[i]));
				wopenPeril.setRemarks(remarks[i]);
				wopenPeril.setUserId(userId);
				
				this.getGipiWOpenPerilDAO().saveWOpenPeril(wopenPeril);
			}
			log.info(perilCds.length + " WOpenPeril/s inserted.");
		}
		
		return true;
	}

	@Override
	public String checkWOpenPeril(Map<String, Object> params)
			throws SQLException {
		log.info("Checking WOpenPeril...");
		String message = this.getGipiWOpenPerilDAO().checkWOpenPeril(params);
		log.info("WOpenPeril checked: " + message);
		
		return message ;
	}

}
