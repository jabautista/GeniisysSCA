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

import org.json.JSONArray;
import org.json.JSONException;


import com.geniisys.gipi.entity.GIPIWinvTax;


/**
 * The Interface GIPIWinvTaxFacadeService.
 */
public interface GIPIWinvTaxFacadeService {
	
	/**
	 * Gets the gIPI winv tax.
	 * 
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @return the gIPI winv tax
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvTax> getGIPIWinvTax(int parId, int itemGrp) throws SQLException;
	
	/**
	 * Save winv tax.
	 * 
	 * @param parameters the parameters
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveWinvTax(Map<String, Object> parameters) throws SQLException;
	
	/**
	 * Delete all gipi winv tax.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllGIPIWinvTax(int parId) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> isExist(Integer parId) throws SQLException;
	
	/** Created by: TONIO January 27, 2011
	 * Gets the gIPI winv tax.
	 * 
	 * @param parId the par id
	 * 
	 * @return the gIPI winv tax
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvTax> getGIPIWinvTax2(int parId) throws SQLException;
	
	public List<GIPIWinvTax> prepareAddModifiedTaxInfo(JSONArray setRows) throws JSONException, ParseException;
	
	public List<Map<String, Object>> prepareTaxInfoToDelete(JSONArray delRows) throws JSONException, ParseException;
	
}

