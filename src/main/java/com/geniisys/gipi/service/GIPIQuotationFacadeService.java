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

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIQuote;


/**
 * The Interface GIPIQuotationFacadeService.
 */
public interface GIPIQuotationFacadeService {
	
	/**
	 * Gets the gIPI quotation listing.
	 * @param userId the user id
	 * @param lineCd the line cd
	 * @return the gIPI quotation listing
	 */
	public List<GIPIQuote> getGIPIQuotationListing(String userId, String lineCd);
	
	/**
	 * Save gipi quote details.
	 * @param gipiQuote the gipi quote
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteDetails(GIPIQuote gipiQuote) throws SQLException;	
	
	/**
	 * Gets the quotation details by quote id.
	 * 
	 * @param quoteId the quote id
	 * @return the quotation details by quote id
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuote getQuotationDetailsByQuoteId(int quoteId) throws SQLException;
	
	//public PaginatedList getGIPIQuotationListing(Integer pageNo, String userId, String lineCd);
	
	/**
	 * Gets the quote id by params.
	 * 
	 * @param gipiQuote the gipi quote
	 * @return the quote id by params
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuote getQuoteIdByParams(GIPIQuote gipiQuote) throws SQLException;
	
	/**
	 * Make a GIPIQuote object from json object -- WARNING -- The gipiQuote Object only contains the primary keys and prem/tsi amounts </br> complete the other fields you want to use this method
	 * @param jsonObject
	 * @param USER
	 * @return
	 * @throws JSONException
	 */
	public GIPIQuote prepareGIPIQuoteJSONObject(JSONObject jsonObject, GIISUser USER) throws JSONException;
	
}
