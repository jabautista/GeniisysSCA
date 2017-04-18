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

import com.geniisys.gipi.entity.GIPIQuoteVesAir;

/**
 * The Interface GIPIQuoteVesAirDAO.
 */
public interface GIPIQuoteVesAirDAO {

	/**
	 * Gets the quote ves air.
	 * 
	 * @param quoteId the quote id
	 * @return the quote ves air
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteVesAir> getQuoteVesAir(int quoteId) throws SQLException;
	
	/**
	 * Delete quote ves air.
	 * 
	 * @param delParam the del param
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	/*List<GIPIQuoteVesAir> getQuoteVesAir2(Map<String, Object> params) throws SQLException, JSONException;  //steven 3.13.2012
*/	
	/**
	 * Delete quote ves air.
	 * 
	 * @param delParam the del param
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteQuoteVesAir(Map<String, Object> delParam) throws SQLException;
	
	/**
	 * Delete all quote ves air.
	 * 
	 * @param quoteId the quote id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteAllQuoteVesAir(int quoteId) throws SQLException;
	
	/**
	 * Save quote ves air.
	 * 
	 * @param params the Map<String, Object>
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 * @throws Exception 
	 */
	boolean saveQuoteVesAir(Map<String, Object> allParameters) throws Exception;
	
	/**
	 * Checks if gipi_quote_ves_air records exists for the given quoteId
	 * @param quoteId - the quoteId
	 * @return Map 
	 * @throws SQLException - the SQL Exception
	 */
	public Map<String, String> isGIPIQuoteVesAirExist(Integer quoteId) throws SQLException;
	
	/**
	 * Gets the quote ves air records for Package Quotation.
	 * 
	 * @param packQuoteId the pack quote id
	 * @return the quote ves air
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteVesAir> getPackQuoteVesAir(Integer packQuoteId) throws SQLException;
	
	/**
	 * Saves Carrier Information for Package Quotation
	 * @param setRows - list of gipiQuoteVesAir to be inserted
	 * @param delRows - list of gipiQuoteVesAir to be deleted
	 * @throws SQLException - the SQL Exception
	 * @throws Exception 
	 */
	public void saveCarrierInfoForPackQuotation(List<GIPIQuoteVesAir> setRows, List<GIPIQuoteVesAir> delRows) throws SQLException, Exception;
	
	public void deleteQuoteVesAir2(int quoteId,String[] vesselCds) throws SQLException;	
	
	public void saveQuoteVesAir2(Map<String, Object> allParameters) throws Exception;
	
	Integer checkIfGIPIQuoteVesAirExist2(Integer quoteId) throws SQLException;
}
