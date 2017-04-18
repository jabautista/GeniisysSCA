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

import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;


/**
 * The Interface GIPIQuoteWarrantyAndClauseFacadeService.
 */
public interface GIPIQuoteWarrantyAndClauseFacadeService {

	/**
	 * Gets the gIPI quote warranty and clauses.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote warranty and clauses
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteWarrantyAndClause> getGIPIQuoteWarrantyAndClauses(int quoteId) throws SQLException;
	
	/**
	 * Save wc.
	 * 
	 * @param parameters the parameters
	 * @throws SQLException the sQL exception
	 */
	public void saveWC(Map<String, Object> parameters) throws SQLException;
	
	/**
	 * Delete wc.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	public void deleteWC(int quoteId) throws SQLException;
	
	public void attachWarranty(int quoteId, String lineCd, int perilCd) throws SQLException;
	
	public String checkQuotePerilDefaultWarranty (Integer quoteId, String lineCd, Integer perilCd) throws SQLException;
	
	/**
	 * Gets the gIPI quote warranty and clauses for Package Quotation.
	 * 
	 * @param packQuoteId the pack quote id
	 * @return the gIPI quote warranty and clauses
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteWarrantyAndClause> getPackQuotationWarrantiesAndClauses(Integer packQuoteId) throws SQLException;
	
	public void savePackQuotationWarrantiesAndClauses(JSONArray setRows, JSONArray delRows, String userId) throws SQLException, JSONException;
	
	/**
	 * Saves quotation warranties and clauses
	 * @param request - contains records setObjQuoteWarrCla and delObjQuoteWarrCla in JSONObject 
	 * @param userId - app user
	 * @throws SQLException
	 * @throws JSONException
	 */
	public void saveGIPIQuoteWc(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	/**
	 * Check if Print Sequence No. already exist in quotation warranties and clauses
	 * @param request - contains records setObjQuoteWarrCla and delObjQuoteWarrCla in JSONObject 
	 * @param userId - app user
	 * @throws SQLException
	 */
	public String validatePrintSeqNo(Map<String, Object> parameters) throws SQLException; //added by steven 2.25.2012
}
