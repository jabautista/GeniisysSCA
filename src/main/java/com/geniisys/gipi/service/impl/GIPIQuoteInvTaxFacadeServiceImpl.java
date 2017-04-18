/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.dao.GIPIQuoteInvTaxDAO;
import com.geniisys.gipi.entity.GIPIQuoteInvTax;
import com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService;

/**
 * The Class GIPIQuoteInvTaxFacadeServiceImpl.
 */
public class GIPIQuoteInvTaxFacadeServiceImpl implements GIPIQuoteInvTaxFacadeService{

	/** The gipi quote inv tax dao. */
	GIPIQuoteInvTaxDAO gipiQuoteInvTaxDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteInvTaxFacadeServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService#saveGIPIQuoteInvTax(java.util.Map)
	 */
	@Override
	public void saveGIPIQuoteInvTax(Map<String, Object> params)	throws SQLException {
		String[] taxCodes = (String[]) params.get("taxCodes");
		String[] taxIds = (String[]) params.get("taxIds");
		String[] taxAmts = (String[]) params.get("taxAmts");
		String[] rates = (String[]) params.get("rates");
		Integer quoteInvNo = (Integer) params.get("quoteInvInt");
		String lineCd = (String) params.get("lineCd");
		String issCd = (String) params.get("issCd");
		String fixedTaxAllocation = (String) params.get("fixedTaxAllocation");
		Integer itemGrp = (Integer) params.get("itemGrp");
		String taxAllocation = (String) params.get("taxAllocation");
		
		log.info("Deleting Taxes for GIPIQuoteInvoice...");
		this.gipiQuoteInvTaxDAO.deleteGIPIQuoteInvTax(lineCd,issCd,quoteInvNo.intValue());
		
		GIPIQuoteInvTax invTax = null;
		for(int i=0; i<taxCodes.length; i++){
			invTax = new GIPIQuoteInvTax(lineCd, issCd, quoteInvNo.intValue(), taxCodes[i] == null ? 0 : Integer.parseInt(taxCodes[i]),
					taxIds[i] == null ? 0 : Integer.parseInt(taxIds[i]), (taxAmts[i] == null) ? new BigDecimal("0") : new BigDecimal(taxAmts[i].replaceAll(",", "")),
					(rates[i] == null) ? new BigDecimal("0") : new BigDecimal(rates[i].replaceAll(",", "")),
					fixedTaxAllocation, itemGrp, taxAllocation);
			log.info("Saving Taxes for GIPIQuoteInvoice...");
			this.gipiQuoteInvTaxDAO.saveGIPIQuoteInvTax(invTax);
		}		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService#saveGIPIQuoteTaxInvoice(com.geniisys.gipi.entity.GIPIQuoteInvTax)
	 */
	public void saveGIPIQuoteTaxInvoice(GIPIQuoteInvTax taxInvoice) throws SQLException {
		this.gipiQuoteInvTaxDAO.saveGIPIQuoteInvTax(taxInvoice);
	}
	
	//getter and setter for gipiQuoteInvTaxDAO
	/**
	 * Gets the gipi quote inv tax dao.
	 * 
	 * @return the gipi quote inv tax dao
	 */
	public GIPIQuoteInvTaxDAO getGipiQuoteInvTaxDAO() {
		return gipiQuoteInvTaxDAO;
	}
	
	/**
	 * Sets the gipi quote inv tax dao.
	 * 
	 * @param gipiQuoteInvTaxDAO the new gipi quote inv tax dao
	 */
	public void setGipiQuoteInvTaxDAO(GIPIQuoteInvTaxDAO gipiQuoteInvTaxDAO) {
		this.gipiQuoteInvTaxDAO = gipiQuoteInvTaxDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService#deleteGIPIQuoteInvTax(int)
	 */
	@Override
	public void deleteGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo) throws SQLException {
		this.gipiQuoteInvTaxDAO.deleteGIPIQuoteInvTax(lineCd, issCd, quoteInvNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService#getGIPIQuoteInvTax(int)
	 */
	@Override
	public List<GIPIQuoteInvTax> getGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo)
			throws SQLException {
		return this.gipiQuoteInvTaxDAO.getGIPIQuoteInvTax(lineCd, issCd, quoteInvNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService#prepareGIPIQuoteInvTax(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteInvTax> prepareGIPIQuoteInvTax(JSONArray jsonArray)
			throws JSONException {
		List<GIPIQuoteInvTax> invTaxList = new ArrayList<GIPIQuoteInvTax>();
		GIPIQuoteInvTax invTax = null;
		
		for(int index=0; index<jsonArray.length(); index++){
			invTax = new GIPIQuoteInvTax();
			invTax = (GIPIQuoteInvTax)jsonArray.get(index);
			// TODO - not finished... even the parameters may be changed
			
			invTaxList.add(invTax);
		}
		
		return null;
	}
}