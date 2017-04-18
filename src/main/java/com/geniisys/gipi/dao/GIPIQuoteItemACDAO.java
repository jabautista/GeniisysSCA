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

import com.geniisys.gipi.entity.GIPIQuoteItemAC;

/**
 * The Interface GIPIQuoteItemACDAO.
 */
public interface GIPIQuoteItemACDAO {
	
	/**
	 * Gets the gIPI quote item ac.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item ac
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemAC getGIPIQuoteItemAc(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item ACs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item ACs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemAC> getGIPIQuoteItemACs(int quoteId) throws SQLException;
	
	/**
	 * Save gip iquote item ac.
	 * 
	 * @param quoteItemAC the quote item ac
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIquoteItemAC(GIPIQuoteItemAC quoteItemAC) throws SQLException;
	
	/**
	 * Delete gipi quote item ac.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemAC(int quoteId, int itemNo) throws SQLException;

}
