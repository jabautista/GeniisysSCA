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

import com.geniisys.common.dao.GIISUserLineDAO;
import com.geniisys.common.entity.GIISUserLine;
import com.geniisys.common.service.GIISUserLineService;


/**
 * The Class GIISUserLineServiceImpl.
 */
public class GIISUserLineServiceImpl implements GIISUserLineService {

	/** The giis user line dao. */
	private GIISUserLineDAO giisUserLineDAO;

	/**
	 * Gets the giis user line dao.
	 * 
	 * @return the giis user line dao
	 */
	public GIISUserLineDAO getGiisUserLineDAO() {
		return giisUserLineDAO;
	}

	/**
	 * Sets the giis user line dao.
	 * 
	 * @param giisUserLineDAO the new giis user line dao
	 */
	public void setGiisUserLineDAO(GIISUserLineDAO giisUserLineDAO) {
		this.giisUserLineDAO = giisUserLineDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserLineService#deleteGiisUserLine(java.lang.String)
	 */
	@Override
	public void deleteGiisUserLine(String userID) throws SQLException {
		this.getGiisUserLineDAO().deleteGiisUserLine(userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserLineService#getGiisUserLineList(java.lang.String)
	 */
	@Override
	public List<GIISUserLine> getGiisUserLineList(String userID) throws SQLException {
		return this.getGiisUserLineDAO().getGiisUserLineList(userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserLineService#setGiisUserLine(com.geniisys.common.entity.GIISUserLine)
	 */
	@Override
	public void setGiisUserLine(GIISUserLine userLine) throws SQLException {
		this.getGiisUserLineDAO().setGiisUserLine(userLine);
	}

}
