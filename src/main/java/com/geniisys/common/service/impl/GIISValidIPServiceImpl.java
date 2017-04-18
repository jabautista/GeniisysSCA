/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;

import com.geniisys.common.dao.GIISValidIPDAO;
import com.geniisys.common.entity.GIISValidIP;
import com.geniisys.common.service.GIISValidIPService;


/**
 * The Class GIISValidIPServiceImpl.
 */
public class GIISValidIPServiceImpl implements GIISValidIPService {

	/** The giis valid ip dao. */
	private GIISValidIPDAO giisValidIpDAO; 
	
	/**
	 * Gets the giis valid ip dao.
	 * 
	 * @return the giis valid ip dao
	 */
	public GIISValidIPDAO getGiisValidIpDAO() {
		return giisValidIpDAO;
	}
	
	/**
	 * Sets the giis valid ip dao.
	 * 
	 * @param giisValidIpDAO the new giis valid ip dao
	 */
	public void setGiisValidIpDAO(GIISValidIPDAO giisValidIpDAO) {
		this.giisValidIpDAO = giisValidIpDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISValidIPService#getValidUser(java.lang.String)
	 */
	@Override
	public GIISValidIP getValidUser(String ipAddress) throws SQLException {
		return this.getGiisValidIpDAO().getValidUser(ipAddress);
	}

}
