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

import com.geniisys.gipi.entity.GIPIWOpenCargo;


/**
 * The Interface GIPIWOpenCargoService.
 */
public interface GIPIWOpenCargoService {

	/**
	 * Gets the w open cargo.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @return the w open cargo
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWOpenCargo> getWOpenCargo(int parId, int geogCd) throws SQLException;
	
	/**
	 * Save w open cargo.
	 * 
	 * @param params the params
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveWOpenCargo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Delete w open cargo.
	 * 
	 * @param delParams the del params
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWOpenCargo(Map<String, Object> delParams) throws SQLException;
	
}
