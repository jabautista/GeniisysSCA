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
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.seer.framework.db.GenericDAO;


/**
 * The Interface GIPIQuoteItemDAO.
 */
public interface GIPIQuoteItemDAO extends GenericDAO<GIPIQuoteItem> {
	
	/**
	 * Gets the gIPI quote item list.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItem> getGIPIQuoteItemList(int quoteId, String lineCd) throws SQLException;
	public List<GIPIQuoteItem> getGIPIQuoteItemList(int quoteId) throws SQLException;
	/**
	 * Sets the gIPI quote item.
	 * 
	 * @param quoteItem the new gIPI quote item
	 * @throws SQLException the sQL exception
	 */
	public void setGIPIQuoteItem(GIPIQuoteItem quoteItem) throws SQLException;
	
	/**
	 * Save gipi quote item.
	 * @deprecated
	 * @param quoteItem the quote item
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItem(GIPIQuoteItem quoteItem) throws SQLException; // whofeih
	
	/**
	 * Save gipi quote item.
	 * 
	 * @param quoteItem the quote item
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItem(Map<String,Object> preparedParams) throws Exception;
	
	/**
	 * - replacement for the code above.
	 * Saves the whole quotationInformation page.
	 * @param listParams
	 * @throws Exception
	 */
	public void saveGIPIQuoteItemJSON(Map<String, Object> listParams) throws Exception;
	
	/**
	 * Del gipi quote item.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void delGIPIQuoteItem(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Delete GIPIQuoteItem along with its child Information values.
	 * i.e.: deleting itemNo 1 will also delete all mortgagees having itemNo = 1;
	 * @param params
	 * @throws SQLException
	 */
	public void delGIPIQuoteItem(Map<String, Object> params) throws SQLException;
	
	/**
	 * Delete gipi quote all items.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuoteAllItems(int quoteId) throws SQLException;
	
	/**
	 * Updates the premium amt.
	 * 
	 * @param updates the premium amt
	 * @return none
	 */
	public void updateQuoteItemPremAmt(int quoteId, int itemNo, BigDecimal premAmt) throws SQLException;
	
	/**
	 * 
	 * @param packQuoteId
	 * @return
	 * @throws SQLException
	 */
	public List<GIPIQuoteItem> getGIPIQuoteItemListForPack(Integer packQuoteId) throws SQLException;
	
	/**
	 * 
	 * @param listParams
	 * @throws SQLException
	 * @throws Exception
	 */
	public void saveGIPIQuoteItemForPackQuotation(Map<String, Object> listParams) throws SQLException, Exception;
}