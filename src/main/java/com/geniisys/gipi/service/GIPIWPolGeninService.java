/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import com.geniisys.gipi.entity.GIPIWPolGenin;


/**
 * The Interface GIPIWPolGeninService.
 */
public interface GIPIWPolGeninService {

	/**
	 * Gets the gipi w pol genin.
	 * 
	 * @param parId the par id
	 * @return the gipi w pol genin
	 * @throws SQLException the sQL exception
	 */
	GIPIWPolGenin getGipiWPolGenin(int parId) throws SQLException;
	
	/**
	 * Save gipi w pol genin.
	 * 
	 * @param gipiWPolGenin the gipi w pol genin
	 * @throws SQLException the sQL exception
	 */
	void saveGipiWPolGenin(GIPIWPolGenin gipiWPolGenin) throws SQLException;
	
	/**
	 * Delete gipi w pol genin.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void deleteGipiWPolGenin(Integer parId) throws SQLException;
	
	String getGenInfo(int parId) throws SQLException;
}
