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

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIQuoteMortgagee;


/**
 * The Interface GIPIQuoteMortgageeFacadeService.
 */
public interface GIPIQuoteMortgageeFacadeService {

	/**
	 * Gets the gIPI quote mortgagee.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote mortgagee
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteMortgagee> getGIPIQuoteMortgagee(Integer quoteId) throws SQLException;
	
	/**
	 * 
	 * @param quoteId
	 * @return
	 * @throws SQLException
	 */
	public List<GIPIQuoteMortgagee> getGIPIQuoteLevelMortgagee(Integer quoteId) throws SQLException;
	
	/**
	 * Save gipi quote mortgagee.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteMortgagee(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save gipi quote mortgagee.
	 * @param mortgagee the mortgagee
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteMortgagee(GIPIQuoteMortgagee mortgagee) throws SQLException;
	
	/**
	 * Delete gipi quote mortgagee.
	 * @param quoteId
	 * @param itemNo
	 * @param issCd
	 * @param mortgCd
	 * @throws SQLException
	 */
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Integer itemNo, String issCd, String mortgCd) throws SQLException;
	
	/**
	 * Delete gipi quote mortgagee.
	 * @param quoteId the quote id
	 * @param parameter map - should contain any of the following
	 * 			{} - when deleting all mortgagees of a quoteId
	 * 			{issCd, itemNo} - when deleting specific itemNo of a quotation
	 * 			{issCd, mortgCd} - deletes a mortgagee of a quotation, specifically 
	 * 			{}
	 * 			mortgCd
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param quoteId
	 * @param issCd
	 * @throws SQLException
	 */
	public void deleteAllGIPIQuoteMortgagees(Integer quoteId, String issCd) throws SQLException;

	/**
	 * 
	 * @param rows
	 * @param USER
	 * @return
	 * @throws JSONException
	 */
	public List<GIPIQuoteMortgagee> prepareMortgageeInformationJSON(JSONArray rows, GIISUser USER)throws JSONException;
	
	public List<GIPIQuoteMortgagee> getPackQuotationsMortgagee(Integer packQuoteId) throws SQLException;
	public void savePackQuotationMortgagee(Map<String, Object> params) throws SQLException;
}
