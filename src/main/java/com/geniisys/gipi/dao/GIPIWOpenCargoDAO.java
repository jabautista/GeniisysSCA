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

import com.geniisys.gipi.entity.GIPIWOpenCargo;


/**
 * The Interface GIPIWOpenCargoDAO.
 */
public interface GIPIWOpenCargoDAO {

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
	 * @param wopenCargo the wopen cargo
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveWOpenCargo(GIPIWOpenCargo wopenCargo) throws SQLException;
	
	/**
	 * Delete w open cargo.
	 * 
	 * @param parId the par id
	 * @param geogCd the geog cd
	 * @param cargoClassCd the cargo class cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWOpenCargo(int parId, int geogCd, int cargoClassCd) throws SQLException;
	boolean deleteWOpenCargo(Map<String, Object> delWOpenCargo) throws SQLException;
	
}
