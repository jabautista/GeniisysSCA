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

import com.geniisys.gipi.entity.GIPIWVesAir;


/**
 * The Interface GIPIWVesAirDAO.
 */
public interface GIPIWVesAirDAO {

	/**
	 * Gets the w ves air.
	 * 
	 * @param parId the par id
	 * @return the w ves air
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWVesAir> getWVesAir(int parId) throws SQLException;
	
	/**
	 * Delete w ves air.
	 * 
	 * @param delParam the del param
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWVesAir(Map<String, Object> delParam) throws SQLException;
	
	/**
	 * Delete all w ves air.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteAllWVesAir(int parId) throws SQLException;
	
	/**
	 * Save w ves air.
	 * 
	 * @param params the Map<String, Object>
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 * @throws Exception 
	 */
	boolean saveWVesAir(Map<String, Object> allParameters) throws Exception;

	void saveGIPIWVesAir(Map<String, List<GIPIWVesAir>> params) throws SQLException;
	String checkUserPerIssCdAcctg2(Map<String, Object> params) throws SQLException; //Added by Jerome 08.31.2016 SR 5623
}
