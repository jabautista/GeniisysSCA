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

import com.geniisys.gipi.entity.GIPIQuoteItemAV;


/**
 * The Interface GIPIQuoteItemAVService.
 */
public interface GIPIQuoteItemAVService {

	/**
	 * Gets the gIPI quote item av details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item av details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemAV getGIPIQuoteItemAVDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Save gipi quote item av.
	 * 
	 * @param quoteItemAV the quote item av
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemAV(GIPIQuoteItemAV quoteItemAV) throws SQLException;
	
	/**
	 * Save additional information of each 
	 * @param request
	 * @throws SQLException
	 */
	void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItemAV
	 * @param quoteId the quote id
	 * @param itemNo the item number
	 * @throws SQLException an sql exception
	 */
	void deleteGIPIQuoteAV(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Prepare Aviation AdditionalInformation for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemAV
	 * @throws JSONException
	 */
	List<GIPIQuoteItemAV> prepareAviationInformationJSON(JSONArray rows) throws JSONException;
	
}
