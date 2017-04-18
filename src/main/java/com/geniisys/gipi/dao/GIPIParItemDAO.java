/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIItem;


/**
 * The Interface GIPIParItemDAO.
 */
public interface GIPIParItemDAO {
	
	/**
	 * Save gipi par item.
	 * 
	 * @param parItem the par item
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIParItem(GIPIItem parItem) throws SQLException;
	
	/**
	 * Sets the gIPI par item.
	 * 
	 * @param items the new gIPI par item
	 * @throws SQLException the sQL exception
	 */
	void setGIPIParItem(List<GIPIItem> items) throws SQLException;
	
	/**
	 * Delete gipi par item.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIParItem(int parId, int itemNo) throws SQLException;
	
	/**
	 * Delete gipi endt par item.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIEndtParItem(int parId, int itemNo) throws SQLException;
	
	/**
	 * Delete all gipi par item.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteAllGIPIParItem(int parId) throws SQLException;
	
	/**
	 * Del gipi par item.
	 * 
	 * @param items the items
	 * @throws SQLException the sQL exception
	 */
	void delGIPIParItem(List<GIPIItem> items) throws SQLException;
	
	/**
	 * Del gipi endt par item.
	 * 
	 * @param items the items
	 * @throws SQLException the sQL exception
	 */
	void delGIPIEndtParItem(List<GIPIItem> items) throws SQLException;
	
	/**
	 * Confirm copy item.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String confirmCopyItem(Integer parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Confirm copy endt par item.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String confirmCopyEndtParItem(Integer parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Copy item.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param newItemNo the new item no
	 * @throws SQLException the sQL exception
	 */
	void copyItem(int parId, int itemNo, int newItemNo) throws SQLException;
	
	/**
	 * Copy additional info mc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param newItemNo the new item no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @throws SQLException the sQL exception
	 */
	void copyAdditionalInfoMC(int parId, int itemNo, int newItemNo, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Copy additional info for motor car item on endt par.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param newItemNo the new item no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @throws SQLException the sQL exception
	 */
	void copyAdditionalInfoMCEndt(int parId, int itemNo, int newItemNo, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Copy additional info for fire item on endt par.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param newItemNo the new item no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @throws SQLException the sQL exception
	 */
	void copyAdditionalInfoFIEndt(int parId, int itemNo, int newItemNo, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Delete item deductible.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @throws SQLException the sQL exception
	 */
	void deleteItemDeductible(int parId, int itemNo, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Confirm copy item peril info.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String confirmCopyItemPerilInfo(Integer parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Copy item peril.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param newItemNo the new item no
	 * @throws SQLException the sQL exception
	 */
	void copyItemPeril(int parId, int itemNo, int newItemNo) throws SQLException;
	
	/**
	 * Delete pol deductibles.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @throws SQLException the sQL exception
	 */
	void deletePolDeductibles(Integer parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Confirm renumber.
	 * 
	 * @param parId the par id
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String confirmRenumber(int parId) throws SQLException;
	
	/**
	 * Renumber.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void renumber(int parId) throws SQLException;
	
	/**
	 * Confirm assign deductibles.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String confirmAssignDeductibles(int parId, int itemNo) throws SQLException;
	
	/**
	 * Assign deductibles.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void assignDeductibles(int parId, int itemNo) throws SQLException;
	
	/**
	 * Check if discount exists.
	 * 
	 * @param parId the par id
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkIfDiscountExists(int parId) throws SQLException;
	
	/**
	 * Gets the max w item no.
	 * 
	 * @param parId the par id
	 * @return the max w item no
	 * @throws SQLException the sQL exception
	 */
	int getMaxWItemNo(int parId) throws SQLException;	
	
	/**
	 * Gets the max w item no for endt par.
	 * 
	 * @param parId the par id
	 * @return the max w item no
	 * @throws SQLException the sQL exception
	 */
	int getMaxEndtParItemNo(int parId) throws SQLException;
	
	/**
	 * Check gipiw item.
	 * 
	 * @param checkBoth the check both
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkGIPIWItem(int checkBoth, int parId, int itemNo) throws SQLException;
	
	/**
	 * Post delete gipiw item.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param sublineCd the subline cd
	 * @throws SQLException the sQL exception
	 */
	void postDeleteGIPIWItem(int parId, String lineCd, String sublineCd) throws SQLException;
	
	/**
	 * Insert parhist.
	 * 
	 * @param parId the par id
	 * @param userName the user name
	 * @throws SQLException the sQL exception
	 */
	void insertParhist(int parId, String userName) throws SQLException;
	
	/**
	 * Delete discount.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteDiscount(int parId) throws SQLException;
	
	/**
	 * Update gipiw pack line subline.
	 * 
	 * @param parId the par id
	 * @param packLineCd the pack line cd
	 * @param packSublineCd the pack subline cd
	 * @throws SQLException the sQL exception
	 */
	void updateGIPIWPackLineSubline(int parId, String packLineCd, String packSublineCd) throws SQLException;
	
	/**
	 * Delete co insurer.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteCoInsurer(int parId) throws SQLException;
	
	/**
	 * Delete bill.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteBill(int parId) throws SQLException;
	
	/**
	 * Change item group.
	 * 
	 * @param parId the par id
	 * @param packPolFlag the pack pol flag
	 * @throws SQLException the sQL exception
	 */
	void changeItemGroup(int parId, String packPolFlag) throws SQLException;
	
	/**
	 * Adds the par status no.
	 * 
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @param parStatus the par status
	 * @param invoiceSw the invoice sw
	 * @param issCd the iss cd
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> addParStatusNo(int parId, String lineCd, int parStatus, String invoiceSw, String issCd) throws SQLException;
	
	/**
	 * Update gipi w polbas no of item.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void updateGipiWPolbasNoOfItem(int parId) throws SQLException;
	
	/**
	 * Check additional info mc.
	 * 
	 * @param parId the par id
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkAdditionalInfoMC(int parId) throws SQLException;
	
	/**
	 * Check additional info fi.
	 * 
	 * @param parId the par id
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkAdditionalInfoFI(int parId) throws SQLException;
	
	/**
	 * Gets the max risk item no.
	 * 
	 * @param parId the par id
	 * @param riskNo the risk no
	 * @return the max risk item no
	 * @throws SQLException the sQL exception
	 */
	int getMaxRiskItemNo(int parId, int riskNo) throws SQLException;
	
	/**
	 * Function for validation before proceeding to item negation.
	 * @param parId The Par ID
	 * @param itemNo The current item no.
	 * @return The result message
	 * @throws SQLException
	 */
	String validateNegateItem(int parId, int itemNo) throws SQLException;
	
	/**
	 * Checks if item on existing endt par is a backward endorsement.
	 * @param parId The Par ID
	 * @param itemNo The current item no.
	 * @return The result message
	 * @throws SQLException
	 */
	String checkBackEndtBeforeDelete(int parId, int itemNo) throws SQLException;
	
	/**
	 * Extracts the latest expiry date in case there is an endorsement of expiry. 
	 * @param parId The Par ID
	 * @return
	 * @throws SQLException
	 */
	Date extractExpiry(int parId) throws SQLException;
	
	/**
	 * Delete discount without calling the function for updating GIPI_WPOLBAS.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteDiscount2(int parId) throws SQLException;
	
	/**
	 * Calls the last parts of the procedure NEG_DEL_ITEM in GIPIS060. Returns the updated values of some GIPI_WITEM fields.
	 * @param parId The Par Id
	 * @param itemNo The item no.
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> negateItem(int parId, int itemNo) throws SQLException;
	
	/**
	 * First part of procedures to create distribution. This checks for confirmations first.
	 * @param parId The Par Id
	 * @param distNo The dist no.
	 * @return The confirmation messages.
	 * @throws SQLException
	 */
	String createEndtParDistribution1(int parId, int distNo) throws SQLException;
	
	/**
	 * Create distribution.
	 * @param parId The par Id
	 * @param distNo The dist no
	 * @param recExistsAlert The answer to confirmation to proceed when record exists in post_pol_tab
	 * @param distributionAlert Confirmation answer for changes will be done in distribution tables.
	 * @return The result message
	 * @throws SQLException
	 */
	String createEndtParDistribution2(int parId, int distNo, String recExistsAlert, String distributionAlert) throws SQLException;
	
	/**
	 * For endt par item. Calls the stored procedure that will create/update the invoice tables 
	 * based on the changes made in the gipi_witem table.
	 * @param parId The Par ID
	 * @return The result message
	 * @throws SQLException
	 */
	String createEndtInvoiceItem(int parId) throws SQLException;
	
	/**
	 * First part of procedures to create distribution item. This checks for confirmations first.
	 * @param parId The Par Id
	 * @param distNo The dist no.
	 * @return The confirmation messages.
	 * @throws SQLException
	 */
	String createEndtDistributionItem1(int parId, int distNo) throws SQLException;
	
	/**
	 * Delete all distribution tables if any affecting changes have been made to the records in gipi_witem.
	 * @param parId The par Id
	 * @param distNo The dist no
	 * @param recExistsAlert The answer to confirmation to proceed when record exists in post_pol_tab
	 * @param distributionAlert Confirmation answer for changes will be done in distribution tables.
	 * @return The result message
	 * @throws SQLException
	 */
	String createEndtDistributionItem2(int parId, int distNo, String recExistsAlert, String distributionAlert) throws SQLException;
	
	/**
	 * Calls the procedure ADD_PAR_STATUS_NO for endt par.
	 * @param parId The Par Id
	 * @param lineCd The line code
	 * @param issCd The ISS code
	 * @param endtTaxSw The endt. tax switch
	 * @param coInsSw The co. ins. switch
	 * @param negateItem The negate item flag.
	 * @param prorateFlag The prorate flag
	 * @param compSw The comp. switch
	 * @param endtExpiryDate The endt. expiry date
	 * @param effDate The effectivity date
	 * @param shortRtPercent The short rate percent
	 * @param expiryDate The expiry date
	 * @return The result message
	 * @throws SQLException
	 */
	String addEndtParStatusNo(int parId, String lineCd, String issCd, String endtTaxSw, String coInsSw, String negateItem, String prorateFlag, String compSw, String endtExpiryDate, String effDate, BigDecimal shortRtPercent, String expiryDate) throws SQLException;
	
	/**
	 * Updates Gipi Wpack Line Subline table for endt par.
	 * @param parId The Par Id
	 * @param packLineCd The pack line code
	 * @param packSublineCd The pack subline code
	 * @return
	 * @throws SQLException
	 */
	boolean updateEndtGipiWpackLineSubline(int parId, String packLineCd, String packSublineCd) throws SQLException;
	
	/**
	 * Calls the procedure SET_PACKAGE_MENU for endt par.
	 * @param parId The Par ID.
	 * @param packParId The Pack Par Id.
	 * @return
	 * @throws SQLException
	 */
	boolean setPackageMenu(int parId, int packParId) throws SQLException;
	
	/**
	 * Validate other info on endt par item.
	 * @param parId The Par Id
	 * @param funcPart The part of the function to execute. The function has two parts, separated by a confirm dialog.
	 * @param alertConfirm The answer choice of the user to the confirm dialog.
	 * @return The result message
	 * @throws SQLException
	 */
	String endtParValidateOtherInfo(int parId, int funcPart, String alertConfirm) throws SQLException;
}
