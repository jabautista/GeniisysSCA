/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIWOpenPolicyDAO;
import com.geniisys.gipi.entity.GIPIWOpenPolicy;
import com.geniisys.gipi.service.GIPIWOpenPolicyService;


/**
 * The Class GIPIWOpenPolicyServiceImpl.
 */
public class GIPIWOpenPolicyServiceImpl implements GIPIWOpenPolicyService {

	/** The gipi w open policy dao. */
	private GIPIWOpenPolicyDAO gipiWOpenPolicyDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenPolicyService#saveOpenPolicyDetails(com.geniisys.gipi.entity.GIPIWOpenPolicy)
	 */
	@Override
	public void saveOpenPolicyDetails(Map<String, Object> params)
			throws SQLException {
		this.getGipiWOpenPolicyDAO().saveOpenPolicyDetails(params);
	}

	/**
	 * Sets the gipi w open policy dao.
	 * 
	 * @param gipiWOpenPolicyDAO the new gipi w open policy dao
	 */
	public void setGipiWOpenPolicyDAO(GIPIWOpenPolicyDAO gipiWOpenPolicyDAO) {
		this.gipiWOpenPolicyDAO = gipiWOpenPolicyDAO;
	}

	/**
	 * Gets the gipi w open policy dao.
	 * 
	 * @return the gipi w open policy dao
	 */
	public GIPIWOpenPolicyDAO getGipiWOpenPolicyDAO() {
		return gipiWOpenPolicyDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenPolicyService#getWOpenPolicy(java.lang.Integer)
	 */
	@Override
	public GIPIWOpenPolicy getWOpenPolicy(Integer parId) throws SQLException {
		return gipiWOpenPolicyDAO.getWOpenPolicy(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWOpenPolicyService#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWOpenPolicyDAO.isExist(parId);
	}

	@Override
	public Map<String, Object> validatePolicyDate(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWOpenPolicyDAO().validatePolicyDate(params);
	}

}
