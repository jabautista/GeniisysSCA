/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIACGlSubAccountTypesService {

	JSONObject showGiacs341(HttpServletRequest request) throws SQLException, JSONException;
	void valDelGlSubAcctType(HttpServletRequest request) throws SQLException;
	void valAddGlSubAcctType(HttpServletRequest request) throws SQLException;
	void valUpdGlSubAcctType(HttpServletRequest request) throws SQLException;
	JSONArray getAllGlAcctIdGiacs341(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiacs341(HttpServletRequest request, String userId) throws SQLException, JSONException;
	/*giac_gl_transaction_types*/
	JSONObject showTransactionTypes(HttpServletRequest request) throws SQLException, JSONException;
	void valDelGlTransactionType(HttpServletRequest request) throws SQLException;
	void valAddGlTransactionType(HttpServletRequest request) throws SQLException;
	void valUpdGlTransactionType(HttpServletRequest request) throws SQLException;
	void saveGlTransactionType(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
