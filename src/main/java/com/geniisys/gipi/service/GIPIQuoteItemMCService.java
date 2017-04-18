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

import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemMC;


/**
 * The Interface GIPIQuoteItemMCService.
 */
public interface GIPIQuoteItemMCService {

	/**
	 * Gets the gIPI quote item mc.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item mc
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemMC getGIPIQuoteItemMC(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item m cs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item m cs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMC> getGIPIQuoteItemMCs(int quoteId) throws SQLException;
	
    /*get all attributes for validation*/
	List<String> getAllSerialMc() throws SQLException;
	
	List<String> getAllMotorMc() throws SQLException;
	
	List<String> getAllPlateMc() throws SQLException;
	
	List<String> getAllCocMc() throws SQLException;
	
	int getDefaultTow(String subline) throws SQLException;
	/**
	 * Save gipi quote item mc.
	 * 
	 * @param quoteItemMC the quote item mc
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemMC(GIPIQuoteItemMC quoteItemMC) throws SQLException;
	
	/**
	 * Delete gipi quote item mc.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuoteItemMC(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * delete all of the item's additional info
	 * 
	 * */
	void deleteGipiQuoteItemAddInfoMc(int quoteId) throws SQLException;
	
	/**
	 * Save MC Quote Item Additional Information
	 * @param request
	 * @throws SQLException
	 */
	void saveQuoteItemAdditionalInformation(HttpServletRequest request, String sublineCd, String userId) throws SQLException;
	
	/**
	 * Prepare Motor Car Additional Information for Transaction
	 * @param request
	 * @return additionalInformationParams
	 */
	Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request, GIPIQuote gipiQuote);
	
	/**
	 * Prepare list of additional information from jsonArray rows 
	 * @param rows from jsp
	 * @return List of GIPIQuoteItemMC
	 * @throws JSONException
	 * @throws ParseException 
	 */
	List<GIPIQuoteItemMC> prepareMotorCarInformation(JSONArray rows) throws JSONException, ParseException;

	void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper,
			GIPIQuote gipiQuote);
}
