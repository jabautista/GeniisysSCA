package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;


public interface BatchPostingService {
	
	void deleteLog(HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkIfBackEndt(HttpServletRequest request) throws SQLException;
	String batchPost(HttpServletRequest request, GIISUser USER) throws SQLException;
	JSONObject getParListForBatchPosting (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> getParListByParameter (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	//added user to getErrorLogForBatchPosting Kenenth L. 02.10.2014
	JSONObject getErrorLogForBatchPosting (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getPostedLogForBatchPosting (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
}
