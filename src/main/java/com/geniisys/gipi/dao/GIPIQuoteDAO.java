/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIQuotation;
import com.geniisys.gipi.entity.GIPIQuote;
import com.seer.framework.db.GenericDAO;
import com.geniisys.gipi.entity.GIPIQuotePictures;

/**
 * The Interface GIPIQuoteDAO.
 */
public interface GIPIQuoteDAO extends GenericDAO<GIPIQuote>{
	
	/**
	 * Gets the gIPI quotation list.
	 * 
	 * @param userId the user id
	 * @param lineCd the line cd
	 * @return the gIPI quotation list
	 */
	public List<GIPIQuote> getGIPIQuotationList(String userId, String lineCd);
	
	/**
	 * Save gipi quote details.
	 * 
	 * @param gipiQuote the gipi quote
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteDetails (GIPIQuote gipiQuote) throws SQLException;	
	
	/**
	 * Gets the quotation details by quote id.
	 * 
	 * @param quoteId the quote id
	 * @return the quotation details by quote id
	 * @throws SQLException the sQL exception
	 */
	public GIPIQuote getQuotationDetailsByQuoteId(int quoteId)throws SQLException;
	
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
	 * @throws SQLException the sQL exception
	 */
	void copyQuotation(GIPIQuote quote) throws SQLException;
	
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
	Integer getCopiedQuoteId(int quoteId) throws SQLException;
	
	/**
	 * Duplicate quotation.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	void duplicateQuotation(GIPIQuote quote) throws SQLException;
	
	/**
	 * Gets the filter quote listing.
	 * 
	 * @param params the params
	 * @return the filter quote listing
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuote> getFilterQuoteListing(Map<String, Object> params) throws SQLException;
	
	/**
	 * Reassign quotation.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void reassignQuotation(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the quote list status.
	 * 
	 * @param params the params
	 * @return the quote list status
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuotation> getQuoteListStatus(Map<String, Object> params) throws SQLException;
	
	List<GIPIQuotation> getQuotationListStatus(Map<String, Object> params) throws SQLException, JSONException;  //Rey
	
	/**
	 * Gets the quote list from iss cd.
	 * 
	 * @param issCd the iss cd
	 * @param keyWord the key word
	 * @param keyWord2 
	 * @return the quote list from iss cd
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuotation> getQuoteListFromIssCd(String issCd, String lineCd, String userId, String keyWord) throws SQLException;
	
	/**
	 * Save quote to par updates.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void saveQuoteToParUpdates(Map<String, Object> params) throws SQLException;
	
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
	
	public void updateReasonCd(Map<String, Object> params) throws SQLException;

	public String getExistMessage(Map<String, Object> params) throws SQLException;
	
	public List<GIPIQuote> getExistingQuotesPolsListing(Map<String, Object> params) throws SQLException;

	public Map<String, Object> checkAssdName(Map<String, Object> params)throws SQLException;
	
	public List<GIPIQuote> getGIPIQuoteListing(HashMap<String, Object> params) throws SQLException, JSONException;
	
	void reassignQuotation2(List<GIPIQuote> quoteList) throws SQLException;
	
	void reassignPackageQuotation (List<GIPIQuote> quoteList) throws SQLException;
	
	List<GIPIQuote> getQuotationByPackQuoteId(Map<String, Object>params) throws SQLException;
	
	void savePackLineSubline(Map<String, Object>params) throws SQLException, JSONException;
	
	String checkIfGIPIQuoteItemExsist(int quoteId) throws SQLException;

	List<GIPIQuote> getGipiPackQuoteList(Integer packQuoteId) throws SQLException;

	void saveQuoteInspectionDetails(Map<String, Object>params)throws SQLException;
	Map<String, Object>generateQuoteBankRefNo (Map<String, Object>params)throws SQLException;
	
	List<GIPIQuote> getIncludedLinesOfPackQuote(Integer packQuoteId) throws SQLException;
	
	List<GIPIQuote> getPackQuoteListForCarrierInfo(Integer packQuoteId) throws SQLException;
	
	List<GIPIQuote> getPackQuoteListForENInfo(Integer packQuoteId) throws SQLException;
	
	Integer copyQuotation2(Map<String, Object> params) throws SQLException, Exception;
	
	Integer duplicateQuotation2(Map<String, Object> params) throws SQLException, Exception;
	
	com.geniisys.quote.entity.GIPIQuote getQuotationInfoByQuoteId(Integer quoteId) throws SQLException;
	Integer checkIfInspExists(Integer assdNo) throws SQLException;
	
	List<GIPIQuote> getReassignQuoteListing(Map<String, Object> params) throws SQLException;
	String saveQuoteInspectionDetails2(Map<String, Object>params)throws SQLException;
	void deleteQuotation2(Map<String, Object>params) throws SQLException;
	
	List<GIPIQuotePictures> getAttachmentByQuote(String quoteId) throws SQLException;
	void updateFileName2(Map<String, Object> params) throws SQLException;
}
