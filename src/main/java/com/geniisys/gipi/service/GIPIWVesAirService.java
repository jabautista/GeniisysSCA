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

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWVesAir;


/**
 * The Interface GIPIWVesAirService.
 */
public interface GIPIWVesAirService {

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
	 * @param params the params
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWVesAir(Map<String, Object> params) throws SQLException;
	
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
	 * @param params the params
	 * @return true, if successful
	 * @throws Exception 
	 */
	boolean saveWVesAir(Map<String, Object> allParameters) throws Exception;
	
	/**
	 * Save vesair.
	 * @author agazarraga
	 * @param params the params
	 * @throws Exception 
	 */
	public void saveGIPIWVesAir(HttpServletRequest request,String userId)
	throws SQLException, JSONException;
	
	String checkUserPerIssCdAcctg2(Map<String, Object> params) throws SQLException; //Added by Jerome 08.31.2016 SR 5623
}
