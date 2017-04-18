/** 
 *  Created by   : Gzelle
 *  Date Created : 11-09-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIACGlAcctRefNoService {

	JSONObject showGlAcctRefNo(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showKnockOffAccount(HttpServletRequest request) throws SQLException, JSONException;
	JSONArray valGlAcctIdGiacs030(HttpServletRequest request) throws SQLException, JSONException;
	String getOutstandingBal (HttpServletRequest request) throws SQLException;
	void valAddGlAcctRefNo (HttpServletRequest request) throws SQLException;
	JSONArray valRemainingBalGiacs30(HttpServletRequest request) throws SQLException, JSONException;
}
