package com.geniisys.giac.service;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIACOtherCollnsService {
	JSONObject  getGIACOtherCollns(HttpServletRequest request) throws JSONException, SQLException, IOException;
	String setOtherCollnsDtls(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
	public String validateOldTranNoGIACS015(HttpServletRequest request) throws SQLException;
	public String validateOldItemNoGIACS015(HttpServletRequest request) throws SQLException;
	public String validateItemNoGIACS015(HttpServletRequest request) throws SQLException;
	public String validateDeleteGiacs015(HttpServletRequest request) throws SQLException;
	String checkSLCode(HttpServletRequest request) throws SQLException, Exception; //added by John Daniel SR-5056
}
