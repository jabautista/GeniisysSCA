/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIWPerilDiscountDAO;
import com.geniisys.gipi.entity.GIPIWPerilDiscount;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWPerilDiscountServiceImpl.
 */
public class GIPIWPerilDiscountServiceImpl implements GIPIWPerilDiscountService{

	/** The gipi w peril discount dao. */
	private GIPIWPerilDiscountDAO gipiWPerilDiscountDAO;
	
	/**
	 * Gets the gipi w peril discount dao.
	 * 
	 * @return the gipi w peril discount dao
	 */
	public GIPIWPerilDiscountDAO getGipiWPerilDiscountDAO() {
		return gipiWPerilDiscountDAO;
	}
	
	/**
	 * Sets the gipi w peril discount dao.
	 * 
	 * @param gipiWPerilDiscountDAO the new gipi w peril discount dao
	 */
	public void setGipiWPerilDiscountDAO(GIPIWPerilDiscountDAO gipiWPerilDiscountDAO) {
		this.gipiWPerilDiscountDAO = gipiWPerilDiscountDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPerilDiscountService#getGipiWPerilDiscount(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPerilDiscount> getGipiWPerilDiscount(Integer parId)
			throws SQLException {
		return (List<GIPIWPerilDiscount>) StringFormatter.replaceQuotesInList(this.gipiWPerilDiscountDAO.getGipiWPerilDiscount(parId));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPerilDiscountService#getOrigPerilPrem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> getOrigPerilPrem(Integer parId, String itemNo,
			String perilCd) throws SQLException {
		return this.gipiWPerilDiscountDAO.getOrigPerilPrem(parId, itemNo, perilCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPerilDiscountService#setOrigAmount2(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> setOrigAmount2(Integer parId, String itemNo,
			String perilCd, String sequence) throws SQLException {
		return this.gipiWPerilDiscountDAO.setOrigAmount2(parId, itemNo, perilCd, sequence);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPerilDiscountService#getNetPerilPrem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> getNetPerilPrem(Integer parId, String itemNo,
			String perilCd) throws SQLException {
		return this.gipiWPerilDiscountDAO.getNetPerilPrem(parId, itemNo, perilCd);
	}

	@Override
	public List<GIPIWPerilDiscount> getDeleteDiscountList(Integer parId)
			throws SQLException {		
		return (List<GIPIWPerilDiscount>) this.getGipiWPerilDiscountDAO().getDeleteDiscountList(parId);
	}

}
