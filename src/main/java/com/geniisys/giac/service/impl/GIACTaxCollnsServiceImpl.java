/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.dao.GIACTaxCollnsDAO;
import com.geniisys.giac.entity.GIACTaxCollns;
import com.geniisys.giac.service.GIACTaxCollnsService;

public class GIACTaxCollnsServiceImpl implements GIACTaxCollnsService{

	private GIACTaxCollnsDAO giacTaxCollnsDAO;
	
	/**
	 * @return the giacTaxCollnsDAO
	 */
	public GIACTaxCollnsDAO getGiacTaxCollnsDAO() {
		return giacTaxCollnsDAO;
	}

	/**
	 * @param giacTaxCollnsDAO the giacTaxCollnsDAO to set
	 */
	public void setGiacTaxCollnsDAO(GIACTaxCollnsDAO giacTaxCollnsDAO) {
		this.giacTaxCollnsDAO = giacTaxCollnsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACTaxCollnsService#getTaxCollnsListing(java.lang.Integer)
	 */
	@Override
	public List<GIACTaxCollns> getTaxCollnsListing(Integer gaccTranId)
			throws SQLException {
		return this.getGiacTaxCollnsDAO().getTaxCollnsListing(gaccTranId);
	}

}