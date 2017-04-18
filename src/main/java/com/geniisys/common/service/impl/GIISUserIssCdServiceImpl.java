/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISUserIssCdDAO;
import com.geniisys.common.entity.GIISUserIssCd;
import com.geniisys.common.service.GIISUserIssCdService;


/**
 * The Class GIISUserIssCdServiceImpl.
 */
public class GIISUserIssCdServiceImpl implements GIISUserIssCdService {

	/** The giis user iss cd dao. */
	private GIISUserIssCdDAO giisUserIssCdDAO;

	/**
	 * Gets the giis user iss cd dao.
	 * 
	 * @return the giis user iss cd dao
	 */
	public GIISUserIssCdDAO getGiisUserIssCdDAO() {
		return giisUserIssCdDAO;
	}

	/**
	 * Sets the giis user iss cd dao.
	 * 
	 * @param giisUserIssCdDAO the new giis user iss cd dao
	 */
	public void setGiisUserIssCdDAO(GIISUserIssCdDAO giisUserIssCdDAO) {
		this.giisUserIssCdDAO = giisUserIssCdDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserIssCdService#deleteGiisUserIssCd(java.lang.String)
	 */
	@Override
	public void deleteGiisUserIssCd(String userID) throws SQLException {
		this.getGiisUserIssCdDAO().deleteGiisUserIssCd(userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserIssCdService#getGiisUserIssCdList(java.lang.String)
	 */
	@Override
	public List<GIISUserIssCd> getGiisUserIssCdList(String userID) throws SQLException {
		return this.getGiisUserIssCdDAO().getGiisUserIssCdList(userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserIssCdService#setGiisUserIssCd(com.geniisys.common.entity.GIISUserIssCd)
	 */
	@Override
	public void setGiisUserIssCd(GIISUserIssCd userIssCd) throws SQLException {
		this.getGiisUserIssCdDAO().setGiisUserIssCd(userIssCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserIssCdService#checkUserPerIssCdAcctg2(java.util.Map)
	 */
	@Override
	public String checkUserPerIssCdAcctg2(Map<String, Object> params)
			throws SQLException {
		return this.getGiisUserIssCdDAO().checkUserPerIssCdAcctg2(params);
	}

}
