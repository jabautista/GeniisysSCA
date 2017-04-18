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

import com.geniisys.gipi.entity.GIPIQuoteInvTax;


/**
 * The Interface GIPIQuoteInvTaxDAO.
 */
public interface GIPIQuoteInvTaxDAO {
	
	/**
	 * Save gipi quote inv tax.
	 * 
	 * @param gipiQuoteInvTax the gipi quote inv tax
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteInvTax(GIPIQuoteInvTax gipiQuoteInvTax) throws SQLException;
	
	/**
	 * Delete gipi quote inv tax.
	 * 
	 * @param quoteInvNo the quote inv no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo) throws SQLException;
	
	/**
	 * Retrieve GIPIQuoteInvTax list
	 * 
	 * @param quoteInvNo
	 * @return List of GIPIQuoteInvTax
	 * @throws SQLException
	 */
	public List<GIPIQuoteInvTax> getGIPIQuoteInvTax(String lineCd, String issCd, int quoteInvNo) throws SQLException;
	
}
