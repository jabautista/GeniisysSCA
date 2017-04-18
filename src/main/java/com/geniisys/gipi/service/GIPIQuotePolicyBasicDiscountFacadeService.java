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

import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;


/**
 * The Interface GIPIQuotePolicyBasicDiscountFacadeService.
 */
public interface GIPIQuotePolicyBasicDiscountFacadeService {
	
	/**
	 * Retrieve policy discount list.
	 * 
	 * @param quoteId the quote id
	 * @return the list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuotePolicyBasicDiscount> retrievePolicyDiscountList(int quoteId) throws SQLException;
	
	/**
	 * Save policy discount.
	 * 
	 * @param list the list
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean savePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list) throws SQLException;
	
	/**
	 * Delete policy discount.
	 * 
	 * @param list the list
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deletePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list, int sequenceNo) throws SQLException;

}
