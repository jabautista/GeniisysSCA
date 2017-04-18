package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLItemPeril;

public interface GICLItemPerilService {

	void getGiclItemPerilGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	//void getGiclItemPerilGrid2(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGiclItemPerilGrid2(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException; // bonok :: 04.14.2014 :: fix for Item Information tablegrid sort
	void setGiclItemPeril(Map<String, Object> params) throws SQLException;
	void delGiclItemPeril(Map<String, Object> params) throws SQLException;
	String checkAggPeril (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String getGiclItemPerilDfltPayee(Map<String, Object> params) throws SQLException;
	String checkPerilStatus(HttpServletRequest request) throws SQLException, JSONException;
	GICLItemPeril getGICLS024ItemPeril(Integer claimId) throws SQLException;
	Integer checkIfGroupGICLS024(Integer claimId) throws SQLException;
}
