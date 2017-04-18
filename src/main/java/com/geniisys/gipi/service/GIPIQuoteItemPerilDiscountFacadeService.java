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

import com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount;


/**
 * The Interface GIPIQuoteItemPerilDiscountFacadeService.
 */
public interface GIPIQuoteItemPerilDiscountFacadeService {

	/**
	 * Retrieve item peril discount list.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @return the list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItemPerilDiscount> retrieveItemPerilDiscountList(int quoteId) throws SQLException;
	
	/**
	 * Save item peril discount.
	 * 
	 * @param list the list
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveItemPerilDiscount(List<GIPIQuoteItemPerilDiscount> list) throws SQLException;
	
	/**
	 * Delete item peril discount.
	 * 
	 * @param list the list
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteItemPerilDiscount(List<GIPIQuoteItemPerilDiscount> list) throws SQLException;
	
}
