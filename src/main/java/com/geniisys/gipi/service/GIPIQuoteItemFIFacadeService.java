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

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemFI;


/**
 * The Interface GIPIQuoteItemFIFacadeService.
 */
public interface GIPIQuoteItemFIFacadeService {
	
	/**
	 * Gets the gIPI quote item fi.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item fi
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemFI getGIPIQuoteItemFI(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item FIs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item FIs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemFI> getGIPIQuoteItemFIs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item fi.
	 * 
	 * @param quoteItemFI the quote item fi
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItemFI(GIPIQuoteItemFI quoteItemFI) throws SQLException;
	
	/**
	 * Delete gipi quote item fi.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemFI(int quoteId, int itemNo) throws SQLException;

	/**
	 * Save quote item additional information
	 * @param request
	 * @throws SQLException
	 */
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItemFI
	 * @param quoteId the quote id
	 * @param itemNo the item number
	 * @throws SQLException an sql exception
	 */
	void deleteGIPIQuoteFI(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Prepare Fire Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemFI
	 * @throws JSONException
	 */
	List<GIPIQuoteItemFI> prepareFireInformationJSON(JSONArray rows) throws JSONException;
	void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIQuote gipiQuote);
}
