/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWPolbasDiscount;


/**
 * The Interface GIPIWPolbasDiscountDAO.
 */
public interface GIPIWPolbasDiscountDAO {

	/**
	 * Gets the gipi w polbas discount.
	 * 
	 * @param parId the par id
	 * @return the gipi w polbas discount
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWPolbasDiscount> getGipiWPolbasDiscount(Integer parId) throws SQLException;
	
	/**
	 * Gets the orig prem amt.
	 * 
	 * @param parId the par id
	 * @return the orig prem amt
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getOrigPremAmt(Integer parId) throws SQLException;
	
	/**
	 * Gets the orig prem amt2.
	 * 
	 * @param parId the par id
	 * @return the orig prem amt2
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getOrigPremAmt2(Integer parId) throws SQLException;
	
	/**
	 * Gets the net pol prem.
	 * 
	 * @param parId the par id
	 * @return the net pol prem
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getNetPolPrem(Integer parId) throws SQLException;
	
	void saveAllDiscount(HashMap<String, Object> mainParams) throws SQLException;
	String validateSurchargeAmt(HashMap<String, Object> mainParams) throws SQLException;
	Map<String, String> getNetItemPrem(HashMap<String, Object> mainParams) throws SQLException;
	String validateDiscSurcAmtItem(HashMap<String, Object> mainParams) throws SQLException;
	String getItemPerilsPerItem(HashMap<String, Object> mainParams) throws SQLException;
	Map<String, String> getNetPerilPrem(HashMap<String, Object> mainParams) throws SQLException;
	String validateDiscSurcAmtPeril(HashMap<String, Object> mainParams) throws SQLException;
}
