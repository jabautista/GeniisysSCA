/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuoteItemDiscount;


/**
 * The Interface GIPIQuoteItemDiscountFacadeService.
 */
public interface GIPIQuoteItemDiscountFacadeService {

	/**
	 * Retrieve item discount list.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItemDiscount> retrieveItemDiscountList(int quoteId) throws SQLException;
	
	/**
	 * Save item discount.
	 * 
	 * @param list the list
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveItemDiscount(List<GIPIQuoteItemDiscount> list) throws SQLException;
	
	/**
	 * Delete item discount.
	 * 
	 * @param list the list
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteItemDiscount(List<GIPIQuoteItemDiscount> list) throws SQLException;
	
}
