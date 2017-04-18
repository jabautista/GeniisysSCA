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

import com.geniisys.gipi.entity.GIPIQuoteItemAV;


/**
 * The Interface GIPIQuoteItemAVDAO.
 */
public interface GIPIQuoteItemAVDAO {

	/**
	 * Gets the gIPI quote item av details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item av details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemAV getGIPIQuoteItemAVDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item av's
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item av details
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemAV> getGIPIQuoteItemAVs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item av.
	 * 
	 * @param quoteItemAV the quote item av
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemAV(GIPIQuoteItemAV quoteItemAV) throws SQLException;
	
	/**
	 * Delete gipi quote item av.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemAV(int quoteId, int itemNo) throws SQLException;
	
}
