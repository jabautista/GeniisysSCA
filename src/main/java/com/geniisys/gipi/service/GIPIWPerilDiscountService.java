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
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWPerilDiscount;


/**
 * The Interface GIPIWPerilDiscountService.
 */
public interface GIPIWPerilDiscountService {
	
	/**
	 * Gets the gipi w peril discount.
	 * 
	 * @param parId the par id
	 * @return the gipi w peril discount
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWPerilDiscount> getGipiWPerilDiscount(Integer parId) throws SQLException;
	
	/**
	 * Gets the orig peril prem.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @return the orig peril prem
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getOrigPerilPrem(Integer parId, String itemNo, String perilCd) throws SQLException;
	
	/**
	 * Sets the orig amount2.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @param sequence the sequence
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> setOrigAmount2(Integer parId, String itemNo, String perilCd, String sequence) throws SQLException;
	
	/**
	 * Gets the net peril prem.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @return the net peril prem
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getNetPerilPrem(Integer parId, String itemNo, String perilCd) throws SQLException;
	List<GIPIWPerilDiscount> getDeleteDiscountList(Integer parId) throws SQLException;
}
