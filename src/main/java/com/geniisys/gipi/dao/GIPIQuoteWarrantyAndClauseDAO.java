/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;


/**
 * The Interface GIPIQuoteWarrantyAndClauseDAO.
 */
public interface GIPIQuoteWarrantyAndClauseDAO	{
	
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
	 * @param wc the wc
	 * @throws SQLException the sQL exception
	 */
	public void saveWC(GIPIQuoteWarrantyAndClause wc) throws SQLException;
	
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
	
	public void savePackQuotationWarrantiesAndClauses(List<GIPIQuoteWarrantyAndClause> setRows, List<GIPIQuoteWarrantyAndClause> delRows, String userId) throws SQLException; 
	
	/**
	 * Saves the list of Quotation Warranties and Causes.
	 * @param params - contains list of objects to be saved and deleted.
	 * @throws SQLException
	 */
	public void saveGIPIQuoteWc(Map<String, List<GIPIQuoteWarrantyAndClause>> params) throws SQLException;
	
	/**
	 * Check if Print Sequence No. already exist in quotation warranties and clauses
	 * @param request - contains records setObjQuoteWarrCla and delObjQuoteWarrCla in JSONObject 
	 * @param userId - app user
	 * @throws SQLException
	 */
	public String validatePrintSeqNo(Map<String, Object> parameters) throws SQLException; //added by steven 2.25.2012
}
