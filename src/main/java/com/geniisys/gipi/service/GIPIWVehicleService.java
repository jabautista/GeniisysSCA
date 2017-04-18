package com.geniisys.gipi.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.MediaAlreadyExistingException;
import com.geniisys.gipi.entity.GIPIWVehicle;

public interface GIPIWVehicleService {
	Map<String, Object> newFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWVehicle(String param, GIISUser user) throws SQLException, JSONException, ParseException;
	String checkCOCSerialNoInPolicyAndPar(HttpServletRequest request) throws SQLException;
	String validateOtherInfo(String param) throws SQLException, JSONException, ParseException;
	void uploadFleetData(Map<String, Object> params) throws SQLException, JSONException, IOException, MediaAlreadyExistingException;
	Map<String, Object> gipis060NewFormInstance(Map<String, Object> params)throws SQLException, JSONException;
	void gipis060ValidateItem(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validatePlateNo(Map<String, Object> params) throws SQLException;
	String validateCocSerialNo(Map<String, Object> params) throws SQLException; 
	List<GIPIWVehicle> getVehiclesForPAR(Integer parId) throws SQLException;
	
}
