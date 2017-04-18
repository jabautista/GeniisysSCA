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

import com.geniisys.gipi.entity.GIPIWDeductible;


/**
 * The Interface GIPIWDeductibleFacadeService.
 */
public interface GIPIWDeductibleFacadeService {

	/**
	 * Gets the w deductibles.
	 * 
	 * @param parId the par id
	 * @param deductibleLevel the deductible level
	 * @return the w deductibles
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWDeductible> getWDeductibles(int parId, int deductibleLevel) throws SQLException;
	
	/**
	 * Save gipiw deductible.
	 * 
	 * @param parameters the parameters
	 * @param deductibleLevel the deductible level
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveGIPIWDeductible(Map<String, Object> parameters, int deductibleLevel) throws SQLException, JSONException;
	
	/**
	 * Delete all w deductibles.
	 * 
	 * @param parId the par id
	 * @param deductibleLevel the deductible level
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllWDeductibles(int parId, int deductibleLevel) throws SQLException;
	
	/**
	 * Delete all w policy deductibles.
	 * 
	 * @param parId The Par ID
	 * @param lineCd The line code
	 * @param sublineCd
	 * @return
	 * @throws SQLException
	 */
	public boolean deleteAllWPolicyDeductibles2(int parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Delete w peril deductibles.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param nbtSublineCd the nbt subline cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteWPerilDeductibles(int parId, String lineCd, String nbtSublineCd) throws SQLException;
	
	/**
	 * Check w deductible.
	 * 
	 * @param parId the par id
	 * @param deductibleType the deductible type
	 * @param deductibleLevel the deductible level
	 * @param itemNo the item no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	public String checkWDeductible(int parId, String deductibleType, int deductibleLevel, int itemNo) throws SQLException;

	/**
	 * Checks if PAR has an existing deductible based on % of TSI.
	 * @param parId The Par ID
	 * @param lineCd The line code
	 * @param sublineCd The subline code
	 * @return The result. 'Y' if exists, otherwise 'N'
	 * @throws SQLException
	 */
	public String isExistGipiWdeductible(int parId, String lineCd, String sublineCd) throws SQLException;
	
	public List<GIPIWDeductible> getDeductibleItemAndPeril(int parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Deletes existing deductible based on % TSI.
	 * @param parId The Par Id
	 * @param lineCd The line code
	 * @param sublineCd The subline code
	 * @return
	 * @throws SQLException
	 */
	public boolean deleteGipiWDeductibles2(int parId, String lineCd, String sublineCd) throws SQLException; 
	public List<GIPIWDeductible> prepareGIPIWDeductible(Map<String, Object> parameters);
	public List<GIPIWDeductible> prepareGIPIWDeductibleForInsert(JSONArray jsonArray) throws JSONException;
	public List<GIPIWDeductible> prepareGIPIWDeductibleForDelete(JSONArray jsonArray) throws JSONException;
	public List<GIPIWDeductible> getAllGIPIWDeductibles(Integer parId) throws SQLException;
}
