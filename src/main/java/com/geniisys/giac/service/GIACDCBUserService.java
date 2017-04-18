package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.entity.GIACDCBUser;

public interface GIACDCBUserService {

	public GIACDCBUser getDCBCashierCd(String fundCd, String branchCd, String userId) throws SQLException;
	
	Map<String, Object> getValidUSerInfo(String orTag, String orCancel, String fundCd, String branchCd, String userId) throws SQLException;
	
	String checkIfDcbUserExists(String userId) throws SQLException;
	
	// added by Kris 01.30.2013: for GIACS001
	GIACDCBUser getValidUSerInfo(String fundCd, String branchCd, String userId) throws SQLException;
	
	JSONObject showGiacs319(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs319(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;

}
