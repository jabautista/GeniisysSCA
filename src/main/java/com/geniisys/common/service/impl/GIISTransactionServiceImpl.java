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

import com.geniisys.common.dao.GIISTransactionDAO;
import com.geniisys.common.entity.GIISTransaction;
import com.geniisys.common.service.GIISTransactionService;


/**
 * The Class GIISTransactionServiceImpl.
 */
public class GIISTransactionServiceImpl implements GIISTransactionService {

	/** The giis transaction dao. */
	private GIISTransactionDAO giisTransactionDAO;
	
	/**
	 * Gets the giis transaction dao.
	 * 
	 * @return the giis transaction dao
	 */
	public GIISTransactionDAO getGiisTransactionDAO() {
		return giisTransactionDAO;
	}

	/**
	 * Sets the giis transaction dao.
	 * 
	 * @param giisTransactionDAO the new giis transaction dao
	 */
	public void setGiisTransactionDAO(GIISTransactionDAO giisTransactionDAO) {
		this.giisTransactionDAO = giisTransactionDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISTransactionService#getGiisTransactionList()
	 */
	@Override
	public List<GIISTransaction> getGiisTransactionList() throws SQLException {
		return this.getGiisTransactionDAO().getGiisTransactionList();
	}

}
