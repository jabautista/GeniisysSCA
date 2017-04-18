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

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.jfree.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIWVesAirDAO;
import com.geniisys.gipi.entity.GIPIWVesAir;
import com.geniisys.gipi.service.GIPIWVesAirService;


/**
 * The Class GIPIWVesAirServiceImpl.
 */
public class GIPIWVesAirServiceImpl implements GIPIWVesAirService{

	/** The gipi w ves air dao. */
	private GIPIWVesAirDAO gipiWVesAirDAO;
	
	/** The log. */
	private Logger log = Logger.getLogger(GIPIWVesAirServiceImpl.class);
	
	/**
	 * Sets the gipi w ves air dao.
	 * 
	 * @param gipiWVesAirDAO the new gipi w ves air dao
	 */
	public void setGipiWVesAirDAO(GIPIWVesAirDAO gipiWVesAirDAO) {
		this.gipiWVesAirDAO = gipiWVesAirDAO;
	}
	
	/**
	 * Gets the gipi w ves air dao.
	 * 
	 * @return the gipi w ves air dao
	 */
	public GIPIWVesAirDAO getGipiWVesAirDAO() {
		return gipiWVesAirDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#getWVesAir(int)
	 */
	@Override
	public List<GIPIWVesAir> getWVesAir(int parId) throws SQLException {
		
		log.info("Retrieving VesAir...");
		List<GIPIWVesAir> wvesAirs = this.getGipiWVesAirDAO().getWVesAir(parId);
		log.info(wvesAirs.size() + " VesAir/s retrieved");
		
		return wvesAirs;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#deleteAllWVesAir(int)
	 */
	@Override
	public boolean deleteAllWVesAir(int parId) throws SQLException {
		
		log.info("Deleting VesAir...");
		this.getGipiWVesAirDAO().deleteAllWVesAir(parId);
		log.info("All VesAir/s deleted");	
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#saveWVesAir(java.util.Map)
	 */
	@Override
	public boolean saveWVesAir(Map<String, Object> allParameters) throws Exception {

		log.info("Saving WVesAir...");
		this.getGipiWVesAirDAO().saveWVesAir(allParameters);
		log.info("WVesAir saved.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVesAirService#deleteWVesAir(java.util.Map)
	 */
	@Override
	public boolean deleteWVesAir(Map<String, Object> params)
			throws SQLException {
		String[] vesselCds = (String[]) params.get("vesselCds");
		Integer parId	   = (Integer) params.get("parId");
		
		if (vesselCds != null){
			Map<String, Object> delParam = new HashMap<String, Object>();
			delParam.put("parId", parId);
			
			log.info("Deleting VesAir/s...");
			for(int i = 0; i < vesselCds.length; i++){
				delParam.put("vesselCd", vesselCds[i]);
				
				this.getGipiWVesAirDAO().deleteWVesAir(delParam);
			}
			log.info(vesselCds.length + " VesAir/s deleted.");
		}
		
		return true;
	}
	
	@SuppressWarnings("unchecked")
	public void saveGIPIWVesAir(HttpServletRequest request,String userId)
		throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, List<GIPIWVesAir>> params = new HashMap<String, List<GIPIWVesAir>>();
		Log.info("Preparing records for saving...");
		params.put("setCarInfo", (List<GIPIWVesAir>) JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setCI")), userId, GIPIWVesAir.class));
		params.put("delCarInfo", (List<GIPIWVesAir>) JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delCI")), userId, GIPIWVesAir.class));
		Log.info("Finished preparing records.");
		this.gipiWVesAirDAO.saveGIPIWVesAir(params);

}
	public String checkUserPerIssCdAcctg2(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWVesAirDAO().checkUserPerIssCdAcctg2(params);
	}
}
