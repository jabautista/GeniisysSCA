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

import com.geniisys.common.entity.GIISUserTran;


/**
 * The Interface GIISUserTranDAO.
 */
public interface GIISUserTranDAO {

	/**
	 * Gets the giis user tran list.
	 * 
	 * @param userID the user id
	 * @return the giis user tran list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserTran> getGiisUserTranList(String userID) throws SQLException;
	
	/**
	 * Sets the giis user tran.
	 * 
	 * @param userTran the new giis user tran
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserTran(GIISUserTran userTran) throws SQLException;
	
	/**
	 * Delete giis user tran.
	 * 
	 * @param userID the user id
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserTran(String userID) throws SQLException;
	
}
