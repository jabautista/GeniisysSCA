package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.pack.entity.GIPIPackPolbasic;

public interface GIPIPackPolbasicService {

	/**
	 * Check if there is an existing claim.
	 * @param params
	 * @param pageNo
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getPolicyForPackEndt(Map<String, Object> params, int pageNo) throws SQLException;
	void getPackageBinders(HttpServletRequest request, GIISUser USER) throws SQLException;
	List<GIPIPackPolbasic> checkPackPolicyGiexs006(Map<String, Object> params) throws SQLException;
	Map<String, Object> copyPackPolbasicGiuts008a(Map<String, Object> params) throws SQLException;
	String checkIfPackGIACS007(Map<String, Object> params) throws SQLException;
	String checkIfBillsSettledGIACS007(Map<String, Object> params) throws SQLException;
	String checkIfWithMc(Integer packParId) throws SQLException;
	
	/*joms GIUTS028A 07.29.2013*/
	JSONObject showReinstateHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
}
