/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWItemPeril;


/**
 * The Interface GIPIWItemPerilDAO.
 */
public interface GIPIWItemPerilDAO {
	
	/**
	 * Gets the gIPIW item peril.
	 * 
	 * @param parId the par id
	 * @return the gIPIW item peril
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWItemPeril> getGIPIWItemPeril(Integer parId) throws SQLException;
	
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
	 * Insert w item peril.
	 * 
	 * @param gipiWItemPeril the gipi w item peril
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean insertWItemPeril(GIPIWItemPeril gipiWItemPeril) throws SQLException;
	
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
	boolean deleteWItemPeril(Integer parId, Integer itemNo, String lineCd, Integer perilCd) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> isExist(Integer parId) throws SQLException;
	
	/**
	 * Check deductible item no if null.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param nbtSublineCd the nbt subline cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkDeductibleItemNoIfNull(Integer parId, String lineCd, String nbtSublineCd) throws SQLException;
	
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
	
	/**
	 * Insert peril to wc.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param perilCd the peril cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean insertPerilToWC(Integer parId, String lineCd, Integer perilCd) throws SQLException;
	
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
	
	boolean deleteWItemPeril(List<GIPIWItemPeril> itemPerils) throws SQLException;
	
	String getIssCdRi() throws SQLException;
	
	GIPIWItemPeril getPerilDetails(Map<String, Object> params) throws SQLException;
	
	List<GIPIWItemPeril> getEndtItemPeril(int parId) throws SQLException;
	boolean saveEndtItemPeril(Map<String, Object> allEndtPerilParams) throws SQLException, Exception;
	
	/***TEMPORARY METHOD SIMILAR TO saveEndtItemPeril UNIMPLEMENTING TRANSACTIONS ******/
	boolean saveEndtItemPeril2(Map<String, Object> allEndtPerilParams) throws SQLException, Exception;
	
	Map<String, Object> checkEndtPeril(Map<String, Object> params) throws SQLException;	
	//Map<String, Object> computePremium(Map<String, Object> params) throws SQLException;
	Integer getEndtTariff(Map<String, Object> params) throws SQLException;
	//List<GIPIWItemPeril> retrievePeril(int policyId, int itemNo) throws SQLException;
	
	/**
	 * Deletes the item peril with specified par id and item no
	 * @param parId The Par ID
	 * @param itemNo The item no.
	 * @throws SQLException
	 */
	void deleteWItemPeril2(int parId, int itemNo) throws SQLException;
	
	GIPIWItemPeril getPostTextTsiAmtDetails(Map<String, Object> params) throws SQLException;
	
	List<GIPIWItemPeril> getNegateItemPerils(Map<String, Object> params) throws SQLException;
	Map<String, Object> getNegateDeleteItem(Map<String, Object> params) throws SQLException, Exception;
	List<GIPIWItemPeril> getMaintainedPerilListing(Map<String, Object> params) throws SQLException;
	void updateItemPerilRecords(Map<String, Object> param) throws SQLException;
	void parItemPerilPostFormsCommit(Map<String, Object> param) throws SQLException;
	void endtItemPerilPostFormsCommit(Map<String, Object> params) throws SQLException;
	void saveGIPIWItemPeril(Map<String, Object> params) throws SQLException;
    Integer checkPerilExist(Integer parId) throws SQLException;
    String checkItmPerilExists(HashMap<String, Object> params) throws SQLException;
    public List<GIPIWItemPeril> getGIPIWItemPerilsByItem(Map<String, Object> params) throws SQLException;
    void computeTsi(Map<String, Object> params) throws SQLException;
    List<Map<String, Object>> getItemsWithNoPerils(Map<String, Object> params) throws SQLException;
    String getItemPerilDefaultTag(Map<String, Object> params) throws SQLException;
    Map<String, Object> validatePremiumAmount(Map<String, Object> params) throws SQLException, Exception;
    void retrievePerils(Map<String, Object> params) throws SQLException;
    void validatePeril(Map<String, Object> params) throws SQLException;
    void computePremium(Map<String, Object> params) throws SQLException;
    void computePremiumRate(Map<String, Object> params) throws SQLException;
	void saveCopiedPeril(Map<String, Object> params)throws SQLException, Exception;//added by steven 10/23/2012
	void validateBackAllied(Map<String, Object> params) throws SQLException;
	void updatePlanDetails(Map<String, Object> params) throws SQLException;	//added by Gzelle 09252014
	void deleteWitemPerilTariff(Map<String, Object> params) throws SQLException;	//added by Gzelle 12022014
	void updateWithTariffSw(Map<String, Object> params) throws SQLException;	//added by Gzelle 12022014
}
