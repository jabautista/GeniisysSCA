/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIWPolBasic;


/**
 * The Interface GIPIWPolBasicService.
 */
public interface GIPIWPolBasicService {
	
	/**
	 * Gets the w pol basic from par.
	 * 
	 * @param parId the par id
	 * @return the w pol basic from par
	 * @throws SQLException the sQL exception
	 */
	GIPIWPolBasic getWPolBasicFromPar(Integer parId)throws SQLException;
	
	/**
	 * Gets the expiry date.
	 * 
	 * @param parId the par id
	 * @return the expiry date
	 * @throws SQLException the sQL exception
	 */
	Date getExpiryDate(Integer parId) throws SQLException;
	
	/**
	 * Update pack w polbas.
	 * 
	 * @param packParId the pack par id
	 * @throws SQLException the sQL exception
	 */
	void updatePackWPolbas(Integer packParId) throws SQLException;
	
	String getAcctOfName(Integer parId) throws SQLException;
	
	String getTakeupTerm(Integer parId) throws SQLException;
	
	void validateBookingDate2 (HashMap<String, Object> params) throws SQLException;
	
}
