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

import com.geniisys.gipi.entity.GIPIWOpenPeril;


/**
 * The Interface GIPIWOpenPerilService.
 */
public interface GIPIWOpenPerilService {

	/**
	 * Gets the w open peril.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @param lineCd the line cd
	 * @return the w open peril
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWOpenPeril> getWOpenPeril(int parId, int geogCd, String lineCd) throws SQLException;
	
	/**
	 * Delete all w open peril.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @param lineCd the line cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteAllWOpenPeril(int parId, int geogCd, String lineCd) throws SQLException;
	
	/**
	 * Save w open peril.
	 * 
	 * @param params the params
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveWOpenPeril(Map<String, Object> params) throws SQLException;
	String checkWOpenPeril(Map<String, Object> params) throws SQLException;
	
}
