/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISUserIssCd;


/**
 * The Interface GIISUserIssCdDAO.
 */
public interface GIISUserIssCdDAO {

	/**
	 * Gets the giis user iss cd list.
	 * 
	 * @param userID the user id
	 * @return the giis user iss cd list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserIssCd> getGiisUserIssCdList(String userID) throws SQLException;
	
	/**
	 * Sets the giis user iss cd.
	 * 
	 * @param userIssCd the new giis user iss cd
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserIssCd(GIISUserIssCd userIssCd) throws SQLException;
	
	/**
	 * Delete giis user iss cd.
	 * 
	 * @param userID the user id
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserIssCd(String userID) throws SQLException;
	
	String checkUserPerIssCdAcctg2(Map<String, Object> params) throws SQLException;
}
