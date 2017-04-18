package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIVehicle;

public interface GIPIVehicleService {
	
	JSONObject getMotorCars (HttpServletRequest request) throws SQLException, JSONException;
	
	GIPIVehicle	getVehicleInfo(HashMap<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getMotorCoCTableGrid(HashMap<String, Object> params) throws SQLException, JSONException;
	
	void updateVehiclesGIPIS091(String param, String userId) throws SQLException, JSONException;
	
	String checkExistingCOCSerial(Map<String, Object> params) throws SQLException; 
	
	Map<String, Object> getPlateDtl(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getMotorDtl(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getSerialDtl(Map<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.18.2011l
	 * @param params
	 * @return carrier list
	 * @throws SQLException
	 */
	List<GIPIVehicle> getCarrierList(HashMap<String, Object> params) throws SQLException;
	
	GIPIVehicle	getMotcarItemDtls(Map<String, Object> params) throws SQLException;
	JSONObject getCTPLPolicies(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject getPolListingPerMake(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateGipis192Make(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGipis192Company(HttpServletRequest request) throws SQLException;

	JSONObject showPolListingPerMotorType(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	//shan 10.10.2013
	JSONObject getGipis193VehicleItemSum(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
