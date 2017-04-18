/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIQuoteInvTaxDAO;
import com.geniisys.gipi.entity.GIPIQuoteInvTax;
import com.seer.framework.util.GenericDAOiBatis;


/**
 * The Class GIPIQuoteInvTaxDAOImpl.
 */
public class GIPIQuoteInvTaxDAOImpl extends GenericDAOiBatis<GIPIQuoteInvTax> implements GIPIQuoteInvTaxDAO {

	/**
	 * Instantiates a new gIPI quote inv tax dao impl.
	 * 
	 * @param persistentClass the persistent class
	 */
	public GIPIQuoteInvTaxDAOImpl(Class<GIPIQuoteInvTax> persistentClass) {
		super(persistentClass);	
	}
	
	/**
	 * Instantiates a new gIPI quote inv tax dao impl.
	 */
	public GIPIQuoteInvTaxDAOImpl(){
		super(GIPIQuoteInvTax.class);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvTaxDAO#saveGIPIQuoteInvTax(com.geniisys.gipi.entity.GIPIQuoteInvTax)
	 */
	@Override
	public void saveGIPIQuoteInvTax(GIPIQuoteInvTax gipiQuoteInvTax) throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteInvTax",gipiQuoteInvTax );
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvTaxDAO#deleteGIPIQuoteInvTax(int)
	 */
	@Override
	public void deleteGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteInvNo", quoteInvNo);
		params.put("issCd", issCd);
		params.put("lineCd", lineCd);
		this.getSqlMapClient().delete("deleteInvTax", params);	
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvTaxDAO#getGIPIQuoteInvTax(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteInvTax> getGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteInvNo",quoteInvNo);
		params.put("lineCd", 	lineCd);
		params.put("issCd", 	issCd);
		return this.getSqlMapClient().queryForList("getGIPIQuoteInvTax", params);
	}

}
