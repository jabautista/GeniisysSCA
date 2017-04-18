package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWVehicle;

public interface GIPIWVehicleDAO {
	
	Map<String, Object> gipis010NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIWVehicle(Map<String, Object> params) throws SQLException, JSONException;
	String checkCOCSerialNoInPolicyAndPar(Map<String, Object> params) throws SQLException;
	String validateOtherInfo(Map<String, Object> params) throws SQLException, JSONException;
	void gipis060ValidateItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePlateNo(Map<String, Object> params) throws SQLException;
	String validateCocSerialNo(Map<String, Object> params) throws SQLException;
	List<GIPIWVehicle> getVehiclesForPAR(Integer parId) throws SQLException;
	
}
