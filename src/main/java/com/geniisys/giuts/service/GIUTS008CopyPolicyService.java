package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIUTS008CopyPolicyService {
	String validateOpFlag(HashMap<String, Object> params) throws SQLException, ParseException;
	String validateLineCd(String lineCd) throws SQLException, ParseException;
	String validateGIUTS008LineCd(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Integer validateUserPassIssCd(HashMap<String, Object> params) throws SQLException, ParseException;
	Integer getPolicyId(HashMap<String, Object> params) throws SQLException, ParseException;
	String copyMainQuery(HashMap<String, Object> params) throws SQLException, ParseException;
	HashMap<String, Object> copyPARPolicyMainQuery(HashMap<String, Object> params) throws SQLException, ParseException, JSONException, Exception;
	Map<String, Object> copyPolicyEndtToPAR(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	
}
