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

import com.geniisys.gipi.entity.GIPIQuoteItemMH;


/**
 * The Interface GIPIQuoteItemMHDAO.
 */
public interface GIPIQuoteItemMHDAO {

	/**
	 * Gets the gIPI quote item mh details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item mh details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemMH getGIPIQuoteItemMHDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item MHs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item MHs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMH> getGIPIQuoteItemMHs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item mh.
	 * 
	 * @param quoteItemMH the quote item mh
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemMH(GIPIQuoteItemMH quoteItemMH) throws SQLException;
	
	/**
	 * Delete gipi quote item mh.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemMH(int quoteId, int itemNo) throws SQLException;
}
