/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIWItemDiscountDAO;
import com.geniisys.gipi.entity.GIPIWItemDiscount;
import com.geniisys.gipi.service.GIPIWItemDiscountService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItemDiscountServiceImpl.
 */
public class GIPIWItemDiscountServiceImpl implements GIPIWItemDiscountService{

	/** The gipi w item discount dao. */
	private GIPIWItemDiscountDAO gipiWItemDiscountDAO;
	
	/**
	 * Gets the gipi w item discount dao.
	 * 
	 * @return the gipi w item discount dao
	 */
	public GIPIWItemDiscountDAO getGipiWItemDiscountDAO() {
		return gipiWItemDiscountDAO;
	}

	/**
	 * Sets the gipi w item discount dao.
	 * 
	 * @param gipiWItemDiscountDAO the new gipi w item discount dao
	 */
	public void setGipiWItemDiscountDAO(GIPIWItemDiscountDAO gipiWItemDiscountDAO) {
		this.gipiWItemDiscountDAO = gipiWItemDiscountDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemDiscountService#getGipiWItemDiscount(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemDiscount> getGipiWItemDiscount(Integer parId)
			throws SQLException {
		return (List<GIPIWItemDiscount>) StringFormatter.replaceQuotesInList(this.gipiWItemDiscountDAO.getGipiWItemDiscount(parId));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemDiscountService#getOrigItemPrem(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> getOrigItemPrem(Integer parId, String itemNo)
			throws SQLException {
		return this.gipiWItemDiscountDAO.getOrigItemPrem(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemDiscountService#getNetItemPrem(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> getNetItemPrem(Integer parId, String itemNo, HashMap<String, Object> mainParams)
			throws SQLException {
		return this.gipiWItemDiscountDAO.getNetItemPrem(parId, itemNo, mainParams);
	}

}
