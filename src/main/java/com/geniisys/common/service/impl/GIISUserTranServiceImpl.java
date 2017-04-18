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

import com.geniisys.common.dao.GIISUserTranDAO;
import com.geniisys.common.entity.GIISUserTran;
import com.geniisys.common.service.GIISUserTranService;


/**
 * The Class GIISUserTranServiceImpl.
 */
public class GIISUserTranServiceImpl implements GIISUserTranService {

	/** The giis user tran dao. */
	private GIISUserTranDAO giisUserTranDAO;
	
	/**
	 * Sets the giis user tran dao.
	 * 
	 * @param giisUserTranDAO the new giis user tran dao
	 */
	public void setGiisUserTranDAO(GIISUserTranDAO giisUserTranDAO) {
		this.giisUserTranDAO = giisUserTranDAO;
	}

	/**
	 * Gets the giis user tran dao.
	 * 
	 * @return the giis user tran dao
	 */
	public GIISUserTranDAO getGiisUserTranDAO() {
		return giisUserTranDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserTranService#deleteGiisUserTran(java.lang.String)
	 */
	@Override
	public void deleteGiisUserTran(String userID) throws SQLException {
		this.getGiisUserTranDAO().deleteGiisUserTran(userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserTranService#getGiisUserTranList(java.lang.String)
	 */
	@Override
	public List<GIISUserTran> getGiisUserTranList(String userID) throws SQLException {
		return this.getGiisUserTranDAO().getGiisUserTranList(userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserTranService#setGiisUserTran(com.geniisys.common.entity.GIISUserTran)
	 */
	@Override
	public void setGiisUserTran(GIISUserTran userTran) throws SQLException {
		this.setGiisUserTran(userTran);
	}

}
