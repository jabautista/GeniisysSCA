/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIQuoteInvTax;


/**
 * The Interface GIPIQuoteInvTaxFacadeService.
 */
public interface GIPIQuoteInvTaxFacadeService {
	
	/**
	 * Retrieve GIPIQuoteInvTax list
	 * 
	 * @param quoteInvNo
	 * @return List of GIPIQuoteInvTax
	 * @throws SQLException
	 */
	public List<GIPIQuoteInvTax> getGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo) throws SQLException;
	
	/**
	 * Save gipi quote inv tax.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteInvTax(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save gipi quote tax invoice.
	 * 
	 * @param taxInvoice the tax invoice
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteTaxInvoice(GIPIQuoteInvTax taxInvoice) throws SQLException;
	
	/**
	 * Delete gipi quote inv tax.
	 * 
	 * @param quoteInvNo the quote inv no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo) throws SQLException;
	
	/**
	 * 
	 * @param jsonArray
	 * @throws JSONException
	 */
	public List<GIPIQuoteInvTax> prepareGIPIQuoteInvTax(JSONArray jsonArray)throws JSONException;
	
}
