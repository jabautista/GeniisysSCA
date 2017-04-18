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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWItemPeril;


/**
 * The Interface GIPIWItemPerilService.
 */
public interface GIPIWItemPerilService {
	
	/**
	 * Gets the gIPIW item perils.
	 * 
	 * @param parId the par id
	 * @return the gIPIW item perils
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWItemPeril> getGIPIWItemPerils(Integer parId) throws SQLException;
	
	/**
	 * Checks if itemNo on specified par exists in GIPI_WITMPERL
	 * @param parId The Par ID
	 * @param itemNo The item no.
	 * @return The result. 'Y' if it exists, otherwise 'N'.
	 * @throws SQLException
	 */
	String isExist2(int parId, int itemNo) throws SQLException;
	
	/**
	 * Checks if par item has peril.
	 * @param parId The Par ID
	 * @param itemNo The item no.
	 * @return The result. 'Y' if exists, otherwise 'N'.
	 * @throws SQLException
	 */
	String checkIfParItemHasPeril(int parId, int itemNo) throws SQLException;
	
	/**
	 * Save w item peril.
	 * 
	 * @param params the params
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveWItemPeril(Map<String, Object> params)throws SQLException;
	public boolean deleteWItemPeril(Map<String, Object> params) throws SQLException;
	
	/**
	 * Delete w item peril.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param lineCd the line cd
	 * @param perilCd the peril cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteWItemPeril(Integer parId, Integer itemNo,
			String lineCd, Integer perilCd) throws SQLException;
	
	/**
	 * Check deductible item no.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param nbtSublineCd the nbt subline cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	public String checkDeductibleItemNo(Integer parId, String lineCd, String nbtSublineCd) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> isExist(Integer parId) throws SQLException;
	
	/**
	 * Delete deductibles.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> deleteDeductibles(Integer parId, Integer itemNo) throws SQLException;
	
	/**
	 * Update w item.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean updateWItem(Integer parId, Integer itemNo) throws SQLException;
	
	/**
	 * Creates the w invoice for par.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param issCd the iss cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean createWInvoiceForPAR(Integer parId, String lineCd, String issCd) throws SQLException;
	//boolean insertPerilToWC(Integer parId, String lineCd, Integer perilCd) throws SQLException;
	/**
	 * Delete other discount.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteOtherDiscount(Integer parId, Integer itemNo) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String isExist(Integer parId, Integer itemNo) throws SQLException;
	
	String getIssCdRi() throws SQLException;
	
	GIPIWItemPeril getPerilDetails(Map<String, Object> params) throws SQLException;
	
	List<GIPIWItemPeril> getEndtItemPeril(int parId) throws SQLException;
	boolean saveEndtItemPeril(Map<String, Object> allEndtPerilParams) throws SQLException, Exception;
	String checkEndtPeril(Map<String, Object> params) throws SQLException;
	//String computePremium(Map<String, Object> params) throws SQLException;	
	Integer getEndtTariff(Map<String, Object> params) throws SQLException;

	/**
	 * Deletes the item peril with specified par id and item no
	 * @param parId The Par ID
	 * @param itemNo The item no.
	 * @throws SQLException
	 */
	void deleteWItemPeril2(int parId, int itemNo) throws SQLException;
	
	GIPIWItemPeril getPostTextTsiAmtDetails(Map<String, Object> params) throws SQLException;
	List<GIPIWItemPeril> prepareEndtItemPerilForInsert(JSONArray jsonArray) throws JSONException;
	List<Map<String, Object>> prepareEndtItemPerilForDelete(JSONArray jsonArray) throws JSONException;
	List<Map<String, Object>> preparePerilWCs(JSONArray jsonArray) throws JSONException;
	List<GIPIWItemPeril> getNegateItemPerils(Map<String, Object> params) throws SQLException;
	Map<String, Object> getNegateDeleteItem(HttpServletRequest request) throws SQLException, Exception;
	List<GIPIWItemPeril> getMaintainedPerilListing(Map<String, Object> params) throws SQLException;
	List<GIPIWItemPeril> prepareGIPIWItemPerilsListing(JSONArray setRows) throws SQLException, JSONException;
	Map<String, Object> updateItemServiceParams(Map<String, Object> params, JSONObject objParams)
		throws SQLException, JSONException, ParseException;
	//Map<String, Object> updateParamForItemPerils(JSONObject params, Map<String, Object> param) throws SQLException, JSONException;
	Integer checkPerilExist(Integer parId) throws SQLException;
	String checkItmPerilExists(HashMap<String, Object> params) throws SQLException;
	List<GIPIWItemPeril> getGIPIWItemPerilsByItem(Integer parId, Integer itemNo) throws SQLException;
	JSONObject computeTsi(HttpServletRequest request) throws SQLException, ParseException;
	String checkPerilOnAllItems(HttpServletRequest request) throws SQLException;
	String getItemPerilDefaultTag(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePremiumAmount(Map<String, Object> params) throws SQLException, Exception;
	JSONObject retrievePerils(HttpServletRequest request, GIISUser USER) throws SQLException;
	JSONObject validatePeril(HttpServletRequest request) throws SQLException;
	JSONObject computePremium(HttpServletRequest request) throws SQLException;
	JSONObject computePremiumRate(HttpServletRequest request) throws SQLException;
	void saveCopiedPeril(HttpServletRequest request)throws SQLException, Exception; //added by steven 10/23/2012
	void validateBackAllied(HttpServletRequest request) throws SQLException, JSONException;
	void updatePlanDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;	//added by Gzelle 09252014
	void deleteWitemPerilTariff(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;	//added by Gzelle 12022014
	void updateWithTariffSw(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;	//added by Gzelle 12032014
}
