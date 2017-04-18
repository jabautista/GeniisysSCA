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
import com.geniisys.gipi.entity.GIPIQuoteItemMN;

/**
 * The Interface GIPIQuoteItemMNService.
 */
public interface GIPIQuoteItemMNService {
	
	/**
	 * Gets the gIPI quote item mn details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item mn details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemMN getGIPIQuoteItemMNDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item MNs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item MNs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMN> getGIPIQuoteItemMNs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item mn.
	 * 
	 * @param quoteItemMN the quote item mn
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemMN(GIPIQuoteItemMN quoteItemMN) throws SQLException;
	
	void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItemMN
	 * @param quoteId the quote id
	 * @param itemNo the item number
	 * @throws SQLException an sql exception
	 */
	void deleteGIPIQuoteMN(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Prepare Marine Cargo Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemMN
	 * @throws JSONException
	 */
	List<GIPIQuoteItemMN> prepareMarineCargoInformationJSON(JSONArray rows) throws JSONException;
	void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIQuote gipiQuote);
	
}