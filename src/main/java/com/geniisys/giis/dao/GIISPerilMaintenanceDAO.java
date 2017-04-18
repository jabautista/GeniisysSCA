package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface GIISPerilMaintenanceDAO {
	String savePeril(Map<String, Object> allParams) throws SQLException;
	String perilIsExist (Map<String, Object> param)throws SQLException;
	String validatePerilSname (Map<String, Object> param)throws SQLException;
	String validatePerilName (Map<String, Object> param)throws SQLException;
	String validateDeletePeril (Map<String, Object> param)throws SQLException;
	String saveTariff (Map<String, Object> allParams) throws SQLException;
	String validateDeleteTariff (Map<String, Object> param) throws SQLException;
	String saveWarrCla (Map<String, Object> allParams) throws SQLException;
	String validateDefaultTsi (Map<String, Object> param)throws SQLException;
	String getSublineCdName (Map<String, Object> param)throws SQLException;
	String getBasicPerilCdName (Map<String, Object> param)throws SQLException;
	String getZoneNameFiName (Map<String, Object> param)throws SQLException;
	String getZoneNameMcName (Map<String, Object> param)throws SQLException;
	String checkAvailableWarrcla (Map<String, Object> param)throws SQLException;
	////test
	String validateSublineName (Map<String, Object> param)throws SQLException;
	String validateFiList (Map<String, Object> param)throws SQLException;
	String validateMcList (Map<String, Object> param)throws SQLException;
	
	List<Map<String, Object>> getAllGIISPerilGIISS003 (String lineCd)throws SQLException; //pol cruz 01.13.2015 
}
