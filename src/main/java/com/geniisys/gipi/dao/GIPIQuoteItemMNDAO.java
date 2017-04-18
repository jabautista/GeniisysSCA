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

import com.geniisys.gipi.entity.GIPIQuoteItemMN;


/**
 * The Interface GIPIQuoteItemMNDAO.
 */
public interface GIPIQuoteItemMNDAO {

	/**
	 * Gets the gIPI quote item mn details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item mn details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemMN getGIPIQuoteItemMNDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item MNs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item MNs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMN> getGIPIQuoteItemMNs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item mn.
	 * 
	 * @param quoteItemMN the quote item mn
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemMN(GIPIQuoteItemMN quoteItemMN) throws SQLException;
	
	/**
	 * Delete gipi quote item mn.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemMN(int quoteId, int itemNo) throws SQLException;
	
}
