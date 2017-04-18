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

import com.geniisys.gipi.entity.GIPIQuoteItemFI;




/**
 * The Interface GIPIQuoteItemFIDAO.
 */
public interface GIPIQuoteItemFIDAO {
	
	/**
	 * Gets the gIPI quote item fi.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item fi
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemFI getGIPIQuoteItemFI(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item FIs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item FIs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemFI> getGIPIQuoteItemFIs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item fi.
	 * 
	 * @param quoteItemFI the quote item fi
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItemFI(GIPIQuoteItemFI quoteItemFI) throws SQLException;
	
	/**
	 * Delete gipi quote item fi.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemFI(int quoteId, int itemNo) throws SQLException;
	
	
}
