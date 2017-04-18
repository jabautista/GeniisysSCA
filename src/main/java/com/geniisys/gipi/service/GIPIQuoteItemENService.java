/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;


/**
 * The Interface GIPIQuoteItemENService.
 */
public interface GIPIQuoteItemENService {
	
	/**
	 * Gets the gIPI quote item en details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item en details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemEN getGIPIQuoteItemENDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item ENs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item ENs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemEN> getGIPIQuoteItemENs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item en.
	 * 
	 * @param quoteItemEN the quote item en
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemEN(GIPIQuoteItemEN quoteItemEN) throws SQLException;
	
	/**
	 * Save Engineering Quotation Quote Item
	 * 
	 * @param HttpServletRequest
	 * @throws SQLException
	 */
	void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItemEN
	 * @param quoteId the quote id
	 * @param itemNo the item number
	 * @throws SQLException an sql exception
	 */
	void deleteGIPIQuoteEN(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Prepare Engineering Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request);

	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemEN
	 * @throws JSONException
	 */
	List<GIPIQuoteItemEN> prepareEngineeringInformationJSON(JSONArray rows) throws JSONException;
	
	void saveGIPIQuoteItemEN2(GIPIQuoteItemEN quoteItemEN, String parameters) throws SQLException, JSONException, ParseException;
	
	public List<GIPIQuoteItemEN> getQuoteENDetailsForPackQuotation(List<GIPIQuote> enQuoteList) throws SQLException;
	
	public void saveGIPIQuoteENDetailsForPackQuote(Map<String, Object> listParams) throws SQLException;
	
}
