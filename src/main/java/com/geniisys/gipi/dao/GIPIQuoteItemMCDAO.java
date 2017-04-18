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

import com.geniisys.gipi.entity.GIPIQuoteItemMC;


/**
 * The Interface GIPIQuoteItemMCDAO.
 */
public interface GIPIQuoteItemMCDAO {

	/**
	 * Gets the gIPI quote item mc.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item mc
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemMC getGIPIQuoteItemMC(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item m cs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item m cs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMC> getGIPIQuoteItemMCs(int quoteId) throws SQLException;
	
	/**
	 * Gets the gIPI quote item m cs.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item m cs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemMC> getGIPIQuoteItemMCs(int quoteId, int itemNo) throws SQLException;
	
	/**
	  Gets all serial no in gipi quote item cs,
	  this is for the validation of serial inputed by the user, so that validation will be done front end.
	*/
	
	List<String> getAllSerialMc() throws SQLException;
	
	/**
	  Gets all motor no in gipi quote item cs,
	  this is for the validation of serial inputed by the user, so that validation will be done front end.
	*/
	
	List<String> getAllMotorMc() throws SQLException;
	
	/**
	  Gets all plate no in gipi quote item cs,
	  this is for the validation of serial inputed by the user, so that validation will be done front end.
	*/
	
	List<String> getAllPlateMc() throws SQLException;
	
	/**
	  Gets all coc no in gipi quote item cs,
	  this is for the validation of serial inputed by the user, so that validation will be done front end.
	*/
	
	List<String> getAllCocMc() throws SQLException;
	/**
	 * Save gipi quote item mc.
	 * 
	 * @param quoteItemMC the quote item mc
	 * @throws SQLException the sQL exception
	 */
	
	int getDefaultTow(String subline) throws SQLException;
	
	void saveGIPIQuoteItemMC(GIPIQuoteItemMC quoteItemMC) throws SQLException;
	
	/**
	 * Delete gipi quote item mc.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuoteItemMC(int quoteId, int itemNo) throws SQLException;
	
	void deleteGipiQuoteItemAddInfoMc(int quoteId) throws SQLException;
	
}
