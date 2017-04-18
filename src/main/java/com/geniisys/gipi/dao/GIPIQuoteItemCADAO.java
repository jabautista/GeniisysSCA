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

import com.geniisys.gipi.entity.GIPIQuoteItemCA;


/**
 * The Interface GIPIQuoteItemCADAO.
 */
public interface GIPIQuoteItemCADAO {

	/**
	 * Gets the gIPI quote item ca details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item ca details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemCA getGIPIQuoteItemCADetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item CAs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item CAs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemCA> getGIPIQuoteItemCAs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item ca.
	 * 
	 * @param quoteItemCA the quote item ca
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemCA(GIPIQuoteItemCA quoteItemCA) throws SQLException;
	
	/**
	 * Delete gipi quote item ca.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemCA(int quoteId, int itemNo) throws SQLException;
}
