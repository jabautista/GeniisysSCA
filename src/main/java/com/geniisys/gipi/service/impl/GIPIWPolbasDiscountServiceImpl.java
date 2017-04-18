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

import com.geniisys.gipi.dao.GIPIWPolbasDiscountDAO;
import com.geniisys.gipi.entity.GIPIWPolbasDiscount;
import com.geniisys.gipi.service.GIPIWPolbasDiscountService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWPolbasDiscountServiceImpl.
 */
public class GIPIWPolbasDiscountServiceImpl implements GIPIWPolbasDiscountService{

	/** The gipi w polbas discount dao. */
	private GIPIWPolbasDiscountDAO gipiWPolbasDiscountDAO;
	
	/**
	 * Gets the gipi w polbas discount dao.
	 * 
	 * @return the gipi w polbas discount dao
	 */
	public GIPIWPolbasDiscountDAO getGipiWPolbasDiscountDAO() {
		return gipiWPolbasDiscountDAO;
	}

	/**
	 * Sets the gipi w polbas discount dao.
	 * 
	 * @param gipiWPolbasDiscountDAO the new gipi w polbas discount dao
	 */
	public void setGipiWPolbasDiscountDAO(GIPIWPolbasDiscountDAO gipiWPolbasDiscountDAO) {
		this.gipiWPolbasDiscountDAO = gipiWPolbasDiscountDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasDiscountService#getGipiWPolbasDiscount(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolbasDiscount> getGipiWPolbasDiscount(Integer parId)
			throws SQLException {
		return (List<GIPIWPolbasDiscount>) StringFormatter.replaceQuotesInList(gipiWPolbasDiscountDAO.getGipiWPolbasDiscount(parId));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasDiscountService#getOrigPremAmt(java.lang.Integer)
	 */
	@Override
	public  Map<String, String> getOrigPremAmt(Integer parId)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.getOrigPremAmt(parId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasDiscountService#getOrigPremAmt2(java.lang.Integer)
	 */
	@Override
	public  Map<String, String> getOrigPremAmt2(Integer parId)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.getOrigPremAmt2(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasDiscountService#getNetPolPrem(java.lang.Integer)
	 */
	@Override
	public Map<String, String> getNetPolPrem(Integer parId) throws SQLException {
		return this.gipiWPolbasDiscountDAO.getNetPolPrem(parId);
	}

	@Override
	public void saveAllDiscount(HashMap<String, Object> mainParams) throws SQLException {
		this.gipiWPolbasDiscountDAO.saveAllDiscount(mainParams);
	}

	@Override
	public String validateSurchargeAmt(HashMap<String, Object> mainParams)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.validateSurchargeAmt(mainParams);
	}

	@Override
	public Map<String, String> getNetItemPrem(HashMap<String, Object> mainParams)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.getNetItemPrem(mainParams);
	}

	@Override
	public String validateDiscSurcAmtItem(HashMap<String, Object> mainParams)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.validateDiscSurcAmtItem(mainParams);
	}

	@Override
	public String getItemPerilsPerItem(HashMap<String, Object> mainParams)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.getItemPerilsPerItem(mainParams);
	}

	@Override
	public Map<String, String> getNetPerilPrem(
			HashMap<String, Object> mainParams) throws SQLException {
		return this.gipiWPolbasDiscountDAO.getNetPerilPrem(mainParams);
	}

	@Override
	public String validateDiscSurcAmtPeril(HashMap<String, Object> mainParams)
			throws SQLException {
		return this.gipiWPolbasDiscountDAO.validateDiscSurcAmtPeril(mainParams);
	}

}
