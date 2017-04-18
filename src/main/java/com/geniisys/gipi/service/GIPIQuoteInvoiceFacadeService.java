/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISQuoteInvSeq;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIQuoteInvoice;
import com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary;

/**
 * The Interface GIPIQuoteInvoiceFacadeService.
 */
public interface GIPIQuoteInvoiceFacadeService {
	
	/**
	 * Gets the gIPI quote invoice summary list.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote invoice summary list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteInvoiceSummary> getGIPIQuoteInvoiceSummaryList(Integer quoteId) throws SQLException;
	
	/**
	 * Retrieves a simplified gipiQuoteInvoice list - without the invTaxes;
	 * @author rencela - 01/10/2011
	 * @param quoteId
	 * @param issCd
	 * @return simplified gipiQuoteInvoice list - without the invTaxes;
	 * @throws SQLException
	 */
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoices(Integer quoteId, String issCd, String lineCd) throws SQLException;
	
	/**
	 * Get GIPI quote Invoice by QuoteId
	 * @param quoteId
	 * @return list of gipiQuoteInvoices
	 * @throws SQLException
	 */
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoiceByQuoteId(Integer quoteId) throws SQLException;
	
	/**
	 * Get GIPI quote Invoice by QuoteId and Currency Code and Currency Rate
	 * @param quoteId
	 * @return list of gipiQuoteInvoices
	 * @throws SQLException
	 */
	public GIPIQuoteInvoice getGIPIQuoteInvoiceByCurrency(Integer quoteId, Integer currencyCd, BigDecimal currencyRate, String lineCd, String issCd) throws SQLException;
	
	/**
	 * Save gipi quote invoice.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteInvoice(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save gipi quote invoice.
	 * 
	 * @param issCd the iss cd
	 * @param gipiQuoteInv the gipi quote inv
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteInvoice(String issCd, GIPIQuoteInvoiceSummary gipiQuoteInv) throws SQLException;
	
	/**
	 * Delete gipi quote invoice.
	 * 
	 * @param quoteId the quote id
	 * @param quoteInvNo the quote inv no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteInvoice(Integer quoteId, Integer quoteInvNo) throws SQLException;
	//public void deleteGIPIQuoteInvoice(int quoteInvNo) throws SQLException;
	/**
	 * Gets the gIPI quote invoice.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote invoice
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoice(Integer quoteId) throws SQLException;
	
	/**
	 * Gets the gIPI quote inv seq.
	 * 
	 * @param issCd the iss cd
	 * @return the gIPI quote inv seq
	 * @throws SQLException the sQL exception
	 */
	public GIISQuoteInvSeq getGIPIQuoteInvSeq(String issCd, String userId)	throws SQLException;
	
	/**
	 * Gets the GIPIQuoteInvSeq
	 * - also creates a new GIPIQuoteInvSeq row in case target issCd does not exist // preventing NULL Exceptions in new DB's
	 * - replaces getGIPIQuoteInvSeq method
	 * @param issCd
	 * @return current invoice sequence
	 * @throws SQLException
	 */
	public Integer getCurrentInvoiceSequence(String issCd, String userId) throws SQLException;
	
	/**
	 * Prepare GIPIQuoteInvoice from JSONArray
	 * @param jsonArray
	 * @return
	 * @throws JSONException
	 */
	public List<GIPIQuoteInvoice> prepareQuoteInvoiceJSON(JSONArray jsonArray, GIISUser USER) throws JSONException;
	
	/**
	 * Gets list of GIPI quote invoice for package quotation.
	 * 
	 * @param packQuoteId - the pack quote id
	 * @return list of  GIPI quote invoice
	 * @throws SQLException the SQL exception
	 */
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoiceForPackQuotation (Integer packQuoteId) throws SQLException;
}
