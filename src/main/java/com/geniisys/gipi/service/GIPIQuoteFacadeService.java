/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIQuote;


/**
 * The Interface GIPIQuoteFacadeService.
 */
public interface GIPIQuoteFacadeService {
	
	/**
	 * Gets the gIPI quotation listing.
	 * 
	 * @param userId the user id
	 * @param lineCd the line cd
	 * @return the gIPI quotation listing
	 */
	public List<GIPIQuote> getGIPIQuotationListing(String userId, String lineCd);
	
	Map<String, Object> getGIPIQuoteList (Map<String,Object>params) throws SQLException, JSONException, ParseException; //Rey
	
	/**
	 * Gets the quotation listing.
	 * 
	 * @param userId the user id
	 * @param lineCd the line cd
	 * @return the quotation listing
	 */
	public PaginatedList getQuotationListing(String userId, String lineCd);
	
	/**
	 * Save gipi quote details.
	 * 
	 * @param gipiQuote the gipi quote
	 * @return the integer
	 * @throws SQLException the sQL exception
	 */
	public Integer saveGIPIQuoteDetails(GIPIQuote gipiQuote) throws SQLException;
	
	/**
	 * Gets the quotation details by quote id.
	 * 
	 * @param quoteId the quote id
	 * @return the quotation details by quote id
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuote getQuotationDetailsByQuoteId(int quoteId) throws SQLException;
	
	/**
	 * Gets the quote id by params.
	 * 
	 * @param gipiQuote the gipi quote
	 * @return the quote id by params
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuote getQuoteIdByParams(GIPIQuote gipiQuote) throws SQLException;
	
	/**
	 * Gets the quote id sequence.
	 * 
	 * @return the quote id sequence
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuote getQuoteIdSequence() throws SQLException;
	
	/**
	 * Copy quotation.
	 * 
	 * @param quoteId the quote id
	 * @return the integer
	 * @throws SQLException the sQL exception
	 */
	Integer copyQuotation(GIPIQuote quote) throws SQLException;
	
	/**
	 * Delete quotation.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	void deleteQuotation(int quoteId) throws SQLException;
	
	/**
	 * Deny quotation.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	void denyQuotation(int quoteId) throws SQLException;
	
	/**
	 * Gets the copied quote id.
	 * 
	 * @param quoteId the quote id
	 * @return the copied quote id
	 * @throws SQLException the sQL exception
	 */
	void getCopiedQuoteId(int quoteId) throws SQLException;
	
	/**
	 * Duplicate quotation.
	 * 
	 * @param quoteId the quote id
	 * @return the integer
	 * @throws SQLException the sQL exception
	 */
	Integer duplicateQuotation(GIPIQuote quote) throws SQLException;
	
	/**
	 * Gets the filter quote listing.
	 * 
	 * @param params the params
	 * @return the filter quote listing
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getFilterQuoteListing(Map<String, Object> params) throws SQLException;

	/** CURRENTLY BEING EDITED #leftOff
	 * 
	 * @param params
	 * @author rencela
	 * @return 
	 * @throws SQLException
	 */
	Map<String, Object> getQuotationListing(Map<String, Object> params) throws SQLException;
	
	/**
	 * Reassign quotation.
	 * 
	 * @param userId the user id
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	void reassignQuotation(String userId, int quoteId) throws SQLException;
	
	/**
	 * Gets the quote list status.
	 * 
	 * @param params the params
	 * @return the quote list status
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getQuoteListStatus(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the quote list from iss cd.
	 * 
	 * @param issCd the iss cd
	 * @param keyWord the key word
	 * @param userId 
	 * @param pageNo the page no
	 * @return the quote list from iss cd
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getQuoteListFromIssCd(String issCd, String lineCd, String keyWord, String userId, int pageNo) throws SQLException;
	
	/**
	 * Save quote to par updates.
	 * 
	 * @param quoteId the quote id
	 * @param assdNo the assd no
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @throws SQLException the sQL exception
	 */
	void saveQuoteToParUpdates(int quoteId, Integer assdNo, String lineCd, String issCd) throws SQLException;
	
	/**
	 * Update status.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void updateStatus(Map<String, Object> params) throws SQLException;
	
	public void updateQuotePremAmt(int quoteId, BigDecimal premAmt) throws SQLException;
	
	public List<GIPIQuote> getDistinctReasonCds() throws SQLException;
	
	public void updateStatusFromPar(int quoteId) throws SQLException;
	
	public void updateReasonCd(Integer quoteId, Integer reasonCd)  throws SQLException;
	
	public String getExistMessage(String lineCd, Integer assdNo, String assdName, String quoteId) throws SQLException;
	
	public Map<String, Object> getExistingQuotesPolsListing(Map<String, Object> params) throws SQLException, JSONException;
	
	Map<String, Object> checkAssdName(HttpServletRequest request) throws SQLException;
	
    HashMap<String, Object> getGIPIQuoteListing(HashMap<String, Object> params) throws SQLException, JSONException, ParseException;
    
    void reassignQuoatation2(String params) throws SQLException, JSONException;
    
    List<GIPIQuote> getQuotationByPackQuoteId(Map<String, Object>params) throws SQLException;
    
    JSONObject getQuotationByPackQuoteIdJson(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
    
    void savePackLineSubline(Map<String, Object> params)throws SQLException, JSONException;
    public String checkIfGIPIQuoteItemExsist(int quoteId) throws SQLException;
    
    List<GIPIQuote> getGipiPackQuoteList(Integer packQuoteId) throws SQLException;
    
    List<GIPIQuote> getPackQuoteListForCarrierInfo(Integer packQuoteId) throws SQLException;
    
    List<GIPIQuote> getPackQuoteListForENInfo(Integer packQuoteId) throws SQLException;
    
    List<GIPIQuote> getIncludedLinesOfPackQuote(Integer packQuoteId) throws SQLException;
    
    void saveQuoteInspectionDetails(Map<String, Object> params)throws SQLException;
    Map<String, Object>generateQuoteBankRefNo (Map<String, Object>params)throws SQLException;
    
    Integer copyQuotation2(Map<String, Object> params) throws SQLException, Exception;
	
	Integer duplicateQuotation2(Map<String, Object> params) throws SQLException, Exception;
	
	com.geniisys.quote.entity.GIPIQuote getQuotationInfoByQuoteId(Integer quoteId) throws SQLException;
	Integer checkIfInspExists(Integer assdNo) throws SQLException;
	
	Map<String, Object> getReassignQuoteListing(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	String saveQuoteInspectionDetails2(HttpServletRequest request, String userId)throws SQLException;
	
	void deleteQuotation2(Map<String, Object> params) throws SQLException;
	
	String copyAttachments(Map<String, Object> params) throws SQLException, IOException;
}
