/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIQuoteVesAirDAO;
import com.geniisys.gipi.entity.GIPIQuoteVesAir;
import com.geniisys.gipi.service.GIPIQuoteVesAirService;


/**
 * The Class GIPIQuoteVesAirServiceImpl.
 */
public class GIPIQuoteVesAirServiceImpl implements GIPIQuoteVesAirService{

	/** The gipi w ves air dao. */
	private GIPIQuoteVesAirDAO gipiQuoteVesAirDAO;
	
	/** The log. */
	private Logger log = Logger.getLogger(GIPIQuoteVesAirServiceImpl.class);
	
	/**
	 * Sets the gipi quote ves air dao.
	 * 
	 * @param gipiQuoteVesAirDAO the new gipi quote ves air dao
	 */
	public void setGipiQuoteVesAirDAO(GIPIQuoteVesAirDAO gipiQuoteVesAirDAO) {
		this.gipiQuoteVesAirDAO = gipiQuoteVesAirDAO;
	}
	
	/**
	 * Gets the gipi quote ves air dao.
	 * 
	 * @return the gipi quote ves air dao
	 */
	public GIPIQuoteVesAirDAO getGipiQuoteVesAirDAO() {
		return gipiQuoteVesAirDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#getWVesAir(int)
	 */
	@Override
	public List<GIPIQuoteVesAir> getQuoteVesAir(int quoteId) throws SQLException {
		
		log.info("Retrieving VesAir...");
		List<GIPIQuoteVesAir> quoteVesAirs = this.getGipiQuoteVesAirDAO().getQuoteVesAir(quoteId);
		log.info(quoteVesAirs.size() + " VesAir/s retrieved");
		
		return quoteVesAirs;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#deleteAllWVesAir(int)
	 */
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean deleteAllQuoteVesAir(int quoteId) throws SQLException {
		
		log.info("Deleting VesAir...");
		this.getGipiQuoteVesAirDAO().deleteAllQuoteVesAir(quoteId);
		log.info("All VesAir/s deleted");	
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#saveWVesAir(java.util.Map)
	 */
	@Override
	public boolean saveQuoteVesAir(Map<String, Object> allParameters) throws Exception {

		log.info("Saving QuoteVesAir...");
		this.getGipiQuoteVesAirDAO().saveQuoteVesAir2(allParameters);
		log.info("QuoteVesAir saved.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#deleteWVesAir(java.util.Map)
	 */
	@Override
	public boolean deleteQuoteVesAir(Map<String, Object> params)
			throws SQLException {
		String[] vesselCds = (String[]) params.get("vesselCds");
		Integer quoteId	   = (Integer) params.get("quoteId");
		
		if (vesselCds != null){
			Map<String, Object> delParam = new HashMap<String, Object>();
			delParam.put("quoteId", quoteId);
			
			log.info("Deleting VesAir/s...");
			for(int i = 0; i < vesselCds.length; i++){
				delParam.put("vesselCd", vesselCds[i]);
				
				this.getGipiQuoteVesAirDAO().deleteQuoteVesAir(delParam);
			}
			log.info(vesselCds.length + " VesAir/s deleted.");
		}
		
		return true;
	}

	@Override
	public Map<String, String> isGIPIQuoteVesAirExist(Integer quoteId) throws SQLException {
		return this.gipiQuoteVesAirDAO.isGIPIQuoteVesAirExist(quoteId);
	}

	@Override
	public List<GIPIQuoteVesAir> getPackQuoteVesAir(Integer packQuoteId)
			throws SQLException {
		return this.getGipiQuoteVesAirDAO().getPackQuoteVesAir(packQuoteId);
	}

	@Override
	public void saveCarrierInfoForPackQuotation(List<GIPIQuoteVesAir> setRows,
			List<GIPIQuoteVesAir> delRows) throws Exception {
		log.info("Saving carrier information for package quotation..");
		this.getGipiQuoteVesAirDAO().saveCarrierInfoForPackQuotation(setRows, delRows);
	}

	@Override
	public Integer checkIfGIPIQuoteVesAirExist2(Integer quoteId) throws SQLException {
		return this.getGipiQuoteVesAirDAO().checkIfGIPIQuoteVesAirExist2(quoteId);
	}
}
