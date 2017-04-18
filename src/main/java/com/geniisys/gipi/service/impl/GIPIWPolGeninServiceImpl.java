/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;

import com.geniisys.gipi.dao.GIPIWPolGeninDAO;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.geniisys.gipi.service.GIPIWPolGeninService;


/**
 * The Class GIPIWPolGeninServiceImpl.
 */
public class GIPIWPolGeninServiceImpl implements GIPIWPolGeninService {
	
	/** The gipi w pol genin dao. */
	private GIPIWPolGeninDAO gipiWPolGeninDAO;
	
	/**
	 * Gets the gipi w pol genin dao.
	 * 
	 * @return the gipi w pol genin dao
	 */
	public GIPIWPolGeninDAO getGipiWPolGeninDAO() {
		return gipiWPolGeninDAO;
	}

	/**
	 * Sets the gipi w pol genin dao.
	 * 
	 * @param gipiWPolGeninDAO the new gipi w pol genin dao
	 */
	public void setGipiWPolGeninDAO(GIPIWPolGeninDAO gipiWPolGeninDAO) {
		this.gipiWPolGeninDAO = gipiWPolGeninDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolGeninService#getGipiWPolGenin(int)
	 */
	@Override
	public GIPIWPolGenin getGipiWPolGenin(int parId) throws SQLException {
		return this.getGipiWPolGeninDAO().getGipiWPolGenin(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolGeninService#saveGipiWPolGenin(com.geniisys.gipi.entity.GIPIWPolGenin)
	 */
	@Override
	public void saveGipiWPolGenin(GIPIWPolGenin gipiWPolGenin)
			throws SQLException {
		this.gipiWPolGeninDAO.saveGipiWPolGenin(gipiWPolGenin);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolGeninService#deleteGipiWPolGenin(java.lang.Integer)
	 */
	@Override
	public void deleteGipiWPolGenin(Integer parId) throws SQLException {
		this.gipiWPolGeninDAO.deleteGipiWPolGenin(parId);
	}

	@Override
	public String getGenInfo(int parId) throws SQLException {		
		return this.getGipiWPolGeninDAO().getGenInfo(parId);
	}

}
