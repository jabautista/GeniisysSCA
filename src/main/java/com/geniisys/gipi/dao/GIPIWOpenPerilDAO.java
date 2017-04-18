/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWOpenPeril;



/**
 * The Interface GIPIWOpenPerilDAO.
 */
public interface GIPIWOpenPerilDAO {

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
	 * @param wopenPeril the wopen peril
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveWOpenPeril(GIPIWOpenPeril wopenPeril) throws SQLException;
	String checkWOpenPeril(Map<String, Object> params) throws SQLException;
	boolean deleteWOpenPeril(Map<String, Object> delWOpenPeril) throws SQLException;
		
}
