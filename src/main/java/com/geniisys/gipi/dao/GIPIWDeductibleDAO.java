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

import com.geniisys.gipi.entity.GIPIWDeductible;


/**
 * The Interface GIPIWDeductibleDAO.
 */
public interface GIPIWDeductibleDAO {

	/**
	 * Gets the w policy deductibles.
	 * 
	 * @param parId the par id
	 * @return the w policy deductibles
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWDeductible> getWPolicyDeductibles(int parId) throws SQLException ;
	
	/**
	 * Gets the w item deductibles.
	 * 
	 * @param parId the par id
	 * @return the w item deductibles
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWDeductible> getWItemDeductibles(int parId) throws SQLException ;
	
	/**
	 * Gets the w peril deductibles.
	 * 
	 * @param parId the par id
	 * @return the w peril deductibles
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWDeductible> getWPerilDeductibles(int parId) throws SQLException ;
	
	/**
	 * Save gipiw deductible.
	 * 
	 * @param gipiWDeductible the gipi w deductible
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveGIPIWDeductible(GIPIWDeductible gipiWDeductible) throws SQLException;
	
	/**
	 * Delete all w policy deductibles.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllWPolicyDeductibles(int parId) throws SQLException;
	
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
	 * Delete all w item deductibles.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllWItemDeductibles(int parId) throws SQLException;
	
	/**
	 * Delete all w peril deductibles.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllWPerilDeductibles(int parId) throws SQLException;
	
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
	public void insertGIPIWDeductibles(Map<String, Object> insParams, int parId, String lineCd, String sublineCd, String userId) throws SQLException;
	public void saveDeductibles(Map<String, Object> params) throws SQLException;
	public List<GIPIWDeductible> getAllGIPIWDeductibles(Integer parId) throws SQLException;
}
