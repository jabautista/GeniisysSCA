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

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIQuoteItem;

/**
 * The Interface GIPIQuoteItemFacadeService.
 */
public interface GIPIQuoteItemFacadeService {
	
	/**
	 * Gets the quote item list.
	 * 
	 * @param quoteId the quote id
	 * @return the quote item list
	 */
	public List<GIPIQuoteItem> getQuoteItemList(int quoteId, String lineCd);
	public List<GIPIQuoteItem> getQuoteItemList(int quoteId);
	/**
	 * Save quote item.
	 * 
	 * @param quoteItem the quote item
	 * @return true, if successful
	 */
	public boolean saveQuoteItem(GIPIQuoteItem quoteItem);
	
	/**
	 * Save gipi quote item.
	 * 
	 * @param quoteItem the quote item
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItem(GIPIQuoteItem quoteItem) throws SQLException; // whofeih
	
	/**
	 * Delete quote item.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return true, if successful
	 */
	public boolean deleteQuoteItem(int quoteId, int itemNo);
	
	/**
	 * Delete gipi quote all items.
	 * 
	 * @param quoteId the quote id
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuoteAllItems(int quoteId) throws SQLException;
	
	/**
	 * Gets the paginated quote item list.
	 * 
	 * @param pageNo the page no
	 * @param quoteId the quote id
	 * @return the paginated quote item list
	 */
	public PaginatedList getPaginatedQuoteItemList(Integer pageNo, int quoteId);
	
	/**
	 * Gets the paginated quote item list.
	 * 
	 * @param pageNo the page no
	 * @param list the list
	 * @return the paginated quote item list
	 */
	public PaginatedList getPaginatedQuoteItemList(Integer pageNo, List<GIPIQuoteItem> list);
	
	/**
	 * Gets the last page.
	 * 
	 * @param list the list
	 * @return the last page
	 */
	public int getLastPage(List<GIPIQuoteItem> list);
	
	/**
	 * Updates the premium amt.
	 * 
	 * @param updates the premium amt
	 * @return none
	 */
	public void updateQuoteItemPremAmt(int quoteId, int itemNo, BigDecimal premAmt) throws SQLException;

	/**
	 * Save gipi quote item.
	 * 
	 * @param quoteItem the quote item
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItem(Map<String,Object> preparedParams) throws Exception;
	
	/**
	 * Creates a <b>List of GIPIQuoteItem</b> based on the JSONArray rows retrieved from JSP 
	 * @param JSONArray Object from JSP
	 * @param otherParams
	 * @return List of GIPIQuoteItem
	 * @throws JSONException
	 */
	public List<GIPIQuoteItem> prepareGipiQuoteItemJSON(JSONArray rows, GIISUser USER) throws JSONException;
	
	/**
	 * Save the whole content of quotationInformationMain.jsp PAGE
	 * @param a Map Object containing the Lists of quoteInfo to be added/updated/deleted
	 * @throws Exception
	 */
	public void saveQuotationInformation(Map<String, Object> quotationInformation) throws Exception;
	
	public List<GIPIQuoteItem> getGIPIQuoteItemListForPack(Integer packQuoteId) throws SQLException;
	
	public void saveGIPIQuoteItemForPackQuotation(Map<String, Object> listParams) throws SQLException, Exception;
}