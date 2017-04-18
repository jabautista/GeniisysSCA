/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACGlAccountTypesService {

	JSONObject showGiacs340(HttpServletRequest request) throws SQLException, JSONException;
	void valDelGlAcctType(HttpServletRequest request) throws SQLException;
	void valAddGlAcctType(HttpServletRequest request) throws SQLException;
	void valUpdGlAcctType(HttpServletRequest request) throws SQLException;
	void saveGiacs340(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
