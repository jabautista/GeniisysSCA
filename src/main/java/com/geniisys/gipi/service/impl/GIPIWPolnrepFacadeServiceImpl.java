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
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWPolnrepDAO;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.geniisys.gipi.service.GIPIWPolnrepFacadeService;


/**
 * The Class GIPIWPolnrepFacadeServiceImpl.
 */
public class GIPIWPolnrepFacadeServiceImpl implements GIPIWPolnrepFacadeService{

	/** The gipi w polnrep dao. */
	private GIPIWPolnrepDAO gipiWPolnrepDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolnrep.class);
	
	/**
	 * Gets the gipi w polnrep dao.
	 * 
	 * @return the gipi w polnrep dao
	 */
	public GIPIWPolnrepDAO getGipiWPolnrepDAO() {
		return gipiWPolnrepDAO;
	}

	/**
	 * Sets the gipi w polnrep dao.
	 * 
	 * @param gipiWPolnrepDAO the new gipi w polnrep dao
	 */
	public void setGipiWPolnrepDAO(GIPIWPolnrepDAO gipiWPolnrepDAO) {
		this.gipiWPolnrepDAO = gipiWPolnrepDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolnrepFacadeService#getWPolnrep(int)
	 */
	@Override
	public List<GIPIWPolnrep> getWPolnrep(int parId) throws SQLException {
		
		log.info("Retrieving WPolnrep...");
		List<GIPIWPolnrep> wpolnrepList = this.getGipiWPolnrepDAO().getWPolnrep(parId);
		log.info("WPolnrep Size(): " + wpolnrepList.size());
				
		return wpolnrepList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolnrepFacadeService#deleteWPolnreps(int)
	 */
	@Override
	public boolean deleteWPolnreps(int parId) throws SQLException {
		
		log.info("Deleting all WDeductibles... ");
		this.getGipiWPolnrepDAO().deleteWPolnreps(parId);
		log.info("All WDeductibles deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolnrepFacadeService#saveWPolnrep(java.util.Map)
	 */
	@Override
	public boolean saveWPolnrep(Map<String, Object> params) throws SQLException {
		String[] oldPolicyIds 	= (String[]) params.get("oldPolicyIds");
		Integer parId 			= (Integer) params.get("parId");
		String polFlag 			= (String) params.get("polFlag");
		String userId			= (String) params.get("userId");
		
		this.deleteWPolnreps(parId);
		
		GIPIWPolnrep wpolnrep = null;
		
		if(null != oldPolicyIds) {
			for(int i = 0; i < oldPolicyIds.length; i++){
				wpolnrep = new GIPIWPolnrep();
				
				wpolnrep.setParId(parId);
				wpolnrep.setOldPolicyId(Integer.parseInt(oldPolicyIds[i]));
				wpolnrep.setUserId(userId);
				
				this.getGipiWPolnrepDAO().saveWPolnrep(wpolnrep, polFlag);
			}
		}		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolnrepFacadeService#checkPolicyForRenewal(com.geniisys.gipi.entity.GIPIWPolnrep, java.lang.String)
	 */
	@Override
	public String checkPolicyForRenewal(GIPIWPolnrep wpolnrep, String polFlag) throws SQLException {
		Map<String, Object> resultMap = this.getGipiWPolnrepDAO().checkPolicyForRenewal(wpolnrep, polFlag);
		System.out.println("Retrieved Renewal...");
		//String result;
		//String[] message = resultMap.get("message").toString().split("@@");
		
		//if("1".equals(message[0])){
			//result = resultMap.get("oldPolicyId").toString();
		//} else {
			//result = resultMap.get("message").toString();
		//} 
		return new JSONObject(resultMap).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolnrepFacadeService#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWPolnrepDAO.isExist(parId);
	}

	@Override
	public List<GIPIWPolnrep> getWPolnrep2(Integer parId) throws SQLException {
		return this.getGipiWPolnrepDAO().getWPolnrep2(parId);
	}

}
