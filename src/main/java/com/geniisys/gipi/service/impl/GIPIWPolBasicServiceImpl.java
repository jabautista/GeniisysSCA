/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIWPolBasicDAO;
import com.geniisys.gipi.entity.GIPIWPolBasic;
import com.geniisys.gipi.service.GIPIWPolBasicService;


/**
 * The Class GIPIWPolBasicServiceImpl.
 */
public class GIPIWPolBasicServiceImpl implements GIPIWPolBasicService{

	/** The gipi w pol basic dao. */
	private GIPIWPolBasicDAO gipiWPolBasicDAO; 
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolBasicService#getWPolBasicFromPar(java.lang.Integer)
	 */
	@Override
	public GIPIWPolBasic getWPolBasicFromPar(Integer parId) throws SQLException {
		return this.gipiWPolBasicDAO.getWPolBasicFromPar(parId);
	}

	/**
	 * Sets the gipi w pol basic dao.
	 * 
	 * @param gipiWPolBasicDAO the new gipi w pol basic dao
	 */
	public void setGipiWPolBasicDAO(GIPIWPolBasicDAO gipiWPolBasicDAO) {
		this.gipiWPolBasicDAO = gipiWPolBasicDAO;
	}

	/**
	 * Gets the gipi w pol basic dao.
	 * 
	 * @return the gipi w pol basic dao
	 */
	public GIPIWPolBasicDAO getGipiWPolBasicDAO() {
		return gipiWPolBasicDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolBasicService#getExpiryDate(java.lang.Integer)
	 */
	@Override
	public Date getExpiryDate(Integer parId) throws SQLException {
		return this.getGipiWPolBasicDAO().getExpiryDate(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolBasicService#updatePackWPolbas(java.lang.Integer)
	 */
	@Override
	public void updatePackWPolbas(Integer packParId) throws SQLException {
		this.getGipiWPolBasicDAO().updatePackWPolbas(packParId);
	}

	@Override
	public String getAcctOfName(Integer parId) throws SQLException {
		return this.getGipiWPolBasicDAO().getAcctOfName(parId);
	}

	@Override
	public String getTakeupTerm(Integer parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiWPolBasicDAO().getTakeupTerm(parId);
	}

	@Override
	public void validateBookingDate2(HashMap<String, Object> params)
		throws SQLException {
		this.getGipiWPolBasicDAO().validateBookingDate2(params);
	}

}
