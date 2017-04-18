package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIParItemMC;

/**
 * The interface GIPIEndtParItemMCDAO
 *
 */

public interface GIPIEndtParItemMCDAO {

	/**
	 * Gets the GIPI endt par item mc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the gIPI par item mc
	 * @throws SQLException the sQL exception
	 */
	GIPIParItemMC getGIPIEndtParItemMC(int parId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI endt par item mcs.
	 * 
	 * @param parId the par id
	 * @return the gIPI par item m cs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIParItemMC> getGIPIEndtParItemMCs(int parId) throws SQLException;
	
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
	boolean deleteItem(int parId, int[] itemNo, int currentItemNo) throws SQLException;
	
	/**
	 * Executes procedure ADD_ITEM from Gipis060.
	 * @param parId The Par Id
	 * @param itemNo The item no.
	 * @param currentItemNo The item no. selected.
	 * @return
	 * @throws SQLException
	 */
	String addItem(int parId, int[] itemNo) throws SQLException;
	
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
}
