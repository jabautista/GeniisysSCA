/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISTaxPeril;

public interface GIISTaxPerilService {
	
	/**
	 * Retrieve the list of invoice tax codes and their required perils 
	 * @param issCd
	 * @param lineCd
	 * @return list of GIISTaxPerils of :issCd and :lineCd
	 * @throws SQLException
	 */
	List<GIISTaxPeril> getRequiredTaxPerils(String issCd, String lineCd) throws SQLException;
	
	JSONObject showTaxPeril(HttpServletRequest request, String userId) throws SQLException, JSONException; // kenneth L. 11.22.2013
	
	void saveGiiss028TaxPeril(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
