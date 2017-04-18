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

import com.geniisys.gipi.entity.GIPIQuoteItemMH;


/**
 * The Interface GIPIQuoteItemMHService.
 */
public interface GIPIQuoteItemMHService {
	
	/**
	 * Gets the gIPI quote item mh details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item mh details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemMH getGIPIQuoteItemMHDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item MHs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item MHs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMH> getGIPIQuoteItemMHs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item mh.
	 * 
	 * @param quoteItemMH the quote item mh
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemMH(GIPIQuoteItemMH quoteItemMH) throws SQLException;

	void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItemMH
	 * @param quoteId the quote id
	 * @param itemNo the item number
	 * @throws SQLException an sql exception
	 */
	void deleteGIPIQuoteMH(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Prepare Marine Hull Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemMH
	 * @throws JSONException
	 */
	List<GIPIQuoteItemMH> prepareMarineHullInformationJSON(JSONArray rows) throws JSONException;
	
	List<GIPIQuoteItemMH> prepareMarineHullInformation(JSONArray rows)throws JSONException ;
}
