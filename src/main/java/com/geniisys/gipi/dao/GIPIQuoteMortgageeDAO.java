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

import com.geniisys.gipi.entity.GIPIQuoteMortgagee;


/**
 * The Interface GIPIQuoteMortgageeDAO.
 */
public interface GIPIQuoteMortgageeDAO{

	/**
	 * Gets the GIPI quote mortgagee.
	 * @param quoteId the quote id
	 * @return the gIPI quote mortgagee
	 * @throws SQLException the SQL exception
	 */
	public List<GIPIQuoteMortgagee> getGIPIQuoteMortgagee(Integer quoteId) throws SQLException;
	
	/**
	 * Get 
	 * @param quoteId
	 * @return List of gipi quote mortgagee
	 * @throws SQLException
	 */
	public List<GIPIQuoteMortgagee> getGIPIQuoteLevelMortgagee(Integer quoteId) throws SQLException;
		
	/**
	 * Save gipi quote mortgagee.
	 * @param gipiQuoteMortgagee the gipi quote mortgagee
	 * @throws SQLException the SQL exception
	 */
	public void saveGIPIQuoteMortgagee(GIPIQuoteMortgagee gipiQuoteMortgagee) throws SQLException;
	
	public void saveGIPIQuoteMortgagee(Map<String, Object>params) throws SQLException;
	
	public List<GIPIQuoteMortgagee> getPackQuotationsMortgagee(Integer packQuoteId) throws SQLException;
	
	public void savePackQuotationMortgagee(Map<String, Object>params)throws SQLException;
	
	/**
	 * Delete gipi quote mortgagee.
	 * @param quoteId
	 * @param itemNo
	 * @param issCd
	 * @param mortgCd
	 * @throws SQLException
	 * edited: re-added issCd and mortgCd parameters
	 */ 
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Integer itemNo, String issCd, String mortgCd) throws SQLException;
	
	/**
	 * Delete gipi quote mortgagee.
	 * @param quoteId
	 * @param itemNo
	 * @param issCd
	 * @param mortgCd
	 * @throws SQLException
	 * edited: re-added issCd and mortgCd parameters
	 */ 
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Map<String, Object> params) throws SQLException;
	
	/**
	 * Delete all gipi quote mortgagees of :quoteId and :itemNo.
	 * @param quoteId the quote id
	 * @param issCd the issue code
	 * @throws SQLException the SQL exception
	 * edited: changed parameter set from (quoteId, itemNo) to (quoteId, issCd)
	 */
	public void deleteAllGIPIQuoteMortgagee(Integer quoteId, String issCd) throws SQLException;
}