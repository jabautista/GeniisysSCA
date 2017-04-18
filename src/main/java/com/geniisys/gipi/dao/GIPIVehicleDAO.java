package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIVehicle;

public interface GIPIVehicleDAO {
	
	List<GIPIVehicle> getMotorCars(HashMap<String,Object> params) throws SQLException;
	
	GIPIVehicle	getVehicleInfo(HashMap<String,Object> params) throws SQLException;
	
	List<Map<String, Object>> getMotorCoCList(HashMap<String, Object> params) throws SQLException;
	
	void updateVehiclesGIPIS091(List<Map<String, Object>> vehicles) throws SQLException;
	
	String checkExistingCOCSerial(Map<String, Object> params) throws SQLException; 
	
	List<Map<String, Object>> getPlateDtl(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getMotorDtl(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getSerialDtl(Map<String, Object> params) throws SQLException;
	/**
	 * @author rey
	 * @date 08.18.2011
	 * @param params
	 * @return carrier list
	 * @throws SQLException
	 */
	List<GIPIVehicle> getCarrierListDAO(HashMap<String, Object>params) throws SQLException;
	
	GIPIVehicle getMotcarItemDtls(Map<String,Object> params) throws SQLException;
	
	Map<String, Object> validateGipis192Make(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGipis192Company(Map<String, Object> params) throws SQLException;
	
	//shan 10.10.2013
	Map<String, Object> getGipis193VehicleItemTotals(Map<String, Object> params) throws SQLException;
}
