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

import com.geniisys.common.entity.GIISPeril;


/**
 * The Interface GIISPerilDAO.
 */
public interface GIISPerilDAO {
	
	/**
	 * Check if peril exists.
	 * 
	 * @param nbtSublineCd the nbt subline cd
	 * @param lineCd the line cd
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String checkIfPerilExists (String nbtSublineCd, String lineCd)throws SQLException;
	
	/**
	 * Gets the default perils.
	 * 
	 * @param params the params
	 * @return the default perils
	 * @throws SQLException the sQL exception
	 */
	List<GIISPeril> getDefaultPerils (Map<String, Object> params) throws SQLException;
	
	String getDefaultRate (String perilCd, String lineCd)throws SQLException;
	
	List<GIISPeril> getPackPlanPerils (Map<String, Object> params) throws SQLException;
	String getDefPerilAmts (Map<String, Object> params) throws SQLException;
	String chkIfTariffPerilExsts (Map<String, Object> params) throws SQLException;
	String chkPerilZoneType (Map<String, Object> params) throws SQLException;	//Gzelle 05252015 SR4347
}
