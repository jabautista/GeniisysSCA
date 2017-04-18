/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.entity.GIPIParItemMC;


/**
 * The Interface GIPIParItemMCService.
 */
public interface GIPIParItemMCService {
	
	/**
	 * Gets the gIPI par item mc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the gIPI par item mc
	 * @throws SQLException the sQL exception
	 */
	GIPIParItemMC getGIPIParItemMC(int parId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI par item m cs.
	 * 
	 * @param parId the par id
	 * @return the gIPI par item m cs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIParItemMC> getGIPIParItemMCs(int parId) throws SQLException;
	
	/**
	 * Save gipi par item mc.
	 * 
	 * @param itemMC the item mc
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIParItemMC(GIPIItem itemMC) throws SQLException;
	
	/**
	 * Save gipiw vehicle.
	 * 
	 * @param parItemMC the par item mc
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIWVehicle(GIPIParItemMC parItemMC) throws SQLException;
	
	/**
	 * Save gipi par vehicle.
	 * 
	 * @param vehicleParam the vehicle param
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIParVehicle(Map<String, Object> vehicleParam) throws SQLException;
	
	/**
	 * Delete gipi par item mc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIParItemMC(int parId, int itemNo) throws SQLException;	
	
	/**
	 * Gets the gIPI items.
	 * 
	 * @param parId the par id
	 * @return the gIPI items
	 * @throws SQLException the sQL exception
	 */
	List<GIPIItem> getGIPIItems(int parId) throws SQLException;
	
	/**
	 * Check for existing deductibles.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkForExistingDeductibles(int parId, int itemNo) throws SQLException;
	
	/**
	 * Gets the par no.
	 * 
	 * @param parId the par id
	 * @return the par no
	 * @throws SQLException the sQL exception
	 */
	String getParNo(int parId) throws SQLException;
	
	/**
	 * Gets the assured name.
	 * 
	 * @param assdNo the assd no
	 * @return the assured name
	 * @throws SQLException the sQL exception
	 */
	String getAssuredName(String assdNo) throws SQLException;
	
	/**
	 * Check coc serial no in policy.
	 * 
	 * @param cocSerialNo the coc serial no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkCOCSerialNoInPolicy(int cocSerialNo) throws SQLException;
	
	/**
	 * Check coc serial no in par.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param cocSerialNo the coc serial no
	 * @param cocType the coc type
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkCOCSerialNoInPar(int parId, int itemNo, int cocSerialNo, String cocType) throws SQLException;
	
	/**
	 * Validate other info.
	 * 
	 * @param parId the par id
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateOtherInfo(int parId) throws SQLException;
	
	/**
	 * Gets the endt_tax for the specified par id
	 * @param parId The Par ID
	 * @return The endt tax
	 * @throws SQLException
	 */
	String getEndtTax(int parId) throws SQLException;
	
	/**
	 * Checks if discount exists for the specified Par ID
	 * @param parId The Par ID
	 * @return The result if discount exists
	 * @throws SQLException
	 */
	String checkIfDiscountExists(int parId) throws SQLException;
	
	/**
	 * Executes procedure DELETE_ITEM from Gipis060.
	 * @param parId The Par Id
	 * @param itemNo The item no.
	 * @param currentItemNo The item no. selected.
	 * @return
	 * @throws SQLException
	 */
	boolean deleteEndtItem(int parId, int[] itemNo, int currentItemNo) throws SQLException;
	
	/**
	 * Executes procedure ADD_ITEM from Gipis060.
	 * @param parId The Par Id
	 * @param itemNo The item no.
	 * @param currentItemNo The item no. selected.
	 * @return
	 * @throws SQLException
	 */
	String addEndtItem(int parId, int[] itemNo) throws SQLException;
	
	/**
	 * Checks the presence of information in the table gipi_wvehicle before proceeding. Gipi_wvehicle is required for all items.
	 * @param parId The Par Id
	 * @return The result message.
	 * @throws SQLException
	 */
	String checkAddtlInfo(int parId) throws SQLException;
	
	/**
	 * Populate orig item peril function.
	 * @param parId The par Id
	 * @return The result message
	 * @throws SQLException
	 */
	String populateOrigItmperil(int parId) throws SQLException;
	
	/**
	 * Get dist no. for specified Par.
	 * @param parId The Par Id
	 * @return The dist. no.
	 * @throws SQLException
	 */
	int getDistNo(int parId) throws SQLException;
	
	/**
	 * Delete distribution records.
	 * @param parId The Par Id
	 * @param distNo The dist. no.
	 * @return The result message.
	 * @throws SQLException
	 */
	String deleteDistribution(int parId, int distNo) throws SQLException;
	
	/**
	 * Delete records of specified PAR on tables GIPI_WINVPERL, GIPI_WINV_TAX, and GIPI_WINVOICE.
	 * @param parId The par Id
	 * @return
	 * @throws SQLException
	 */
	boolean deleteWinvRecords(int parId) throws SQLException;
	
	/**
	 * Validates the item no. for this Endt Par MC Item
	 * @param parId The Par Id
	 * @param itemNo The item no.
	 * @param dfltCoverage The default coverage
	 * @param expiryDate The expiry date
	 * @return The result message
	 * @throws SQLException
	 */
	String validateEndtParMCItemNo(int parId, int itemNo, String dfltCoverage, String expiryDate) throws SQLException;
	
	/**
	 * Validates additional info for endt motor item
	 * @param parId The Par Id
	 * @param itemNo The item no
	 * @param towing The towing value
	 * @param cocType The COC Type
	 * @param plateNo The Plate no
	 * @throws SQLException
	 */
	void validateEndtMotorItemAddtlInfo(int parId, int itemNo, BigDecimal towing, String cocType, String plateNo) throws SQLException;
	Map<String, Object> gipis010NewFormInstance(Map<String, Object> params) throws SQLException;
	boolean saveItemMotorCar(Map<String, Object> params) throws SQLException;
	Map<String, Object> preFormsCommit(Map<String, Object> params) throws SQLException;
}
