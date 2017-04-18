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

import com.geniisys.gipi.entity.GIPIQuoteItemAC;


/**
 * The Interface GIPIQuoteItemACFacadeService.
 */
public interface GIPIQuoteItemACFacadeService {
	
	/**
	 * Gets the gIPI quote item ac.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item ac
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemAC getGIPIQuoteItemAc(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Save gip iquote item ac.
	 * 
	 * @param quoteItemAC the quote item ac
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIquoteItemAC(GIPIQuoteItemAC quoteItemAC) throws SQLException;
	
	/**
	 * Delete gipi quote item ac.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemAC(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item ACs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item ACs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemAC> getGIPIQuoteItemACs(int quoteId) throws SQLException;
	
	/**
	 * saves the set of additional information of a quote
	 * @param request
	 * @throws SQLException
	 */
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)throws SQLException;
	
	/**
	 * Prepare Accident Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemAC
	 * @throws JSONException
	 */
	List<GIPIQuoteItemAC> prepareAccidentInformationJSON(JSONArray rows)throws JSONException;
	
}
