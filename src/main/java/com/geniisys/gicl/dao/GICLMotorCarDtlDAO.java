/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLMotorCarDtlDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 24, 2011
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLMcTpDtl;

public interface GICLMotorCarDtlDAO {
	void saveMcTpDtl(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemMotorCar(Map<String, Object> params) throws SQLException;
	String getTowAmount(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getGICLS268MotorCarDetail(Map<String, String> params) throws SQLException;
	GICLMcTpDtl getGICLS260McTpOtherDtls(Map<String, Object>params) throws SQLException;
}
