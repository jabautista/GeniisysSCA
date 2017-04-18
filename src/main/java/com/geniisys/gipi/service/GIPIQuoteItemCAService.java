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
import com.geniisys.gipi.entity.GIPIQuoteItemCA;


/**
 * The Interface GIPIQuoteItemCAService.
 */
public interface GIPIQuoteItemCAService {
	
	/**
	 * Gets the gIPI quote item ca details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item ca details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemCA getGIPIQuoteItemCADetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item CAs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item CAs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemCA> getGIPIQuoteItemCAs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item ca.
	 * 
	 * @param quoteItemCA the quote item ca
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemCA(GIPIQuoteItemCA quoteItemCA) throws SQLException;
	
	/**
	 * Save quotation items' additional information
	 * @param request
	 * @throws SQLException
	 */
	void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItemCA
	 * @param quoteId the quote id
	 * @param itemNo the item number
	 * @throws SQLException an sql exception
	 */
	void deleteGIPIQuoteCA(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Prepare Casualty Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemCA
	 * @throws JSONException
	 */
	List<GIPIQuoteItemCA> prepareCasualtyInformation(JSONArray rows) throws JSONException;
	
	void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIQuote gipiQuote);
}
