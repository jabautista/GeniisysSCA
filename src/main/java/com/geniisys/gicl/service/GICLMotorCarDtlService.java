/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLMotorCarDtlService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 24, 2011
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLMcTpDtl;

public interface GICLMotorCarDtlService {
	public void getGICLMotorCarDtlGrid(HttpServletRequest request, GIISUser USER, ApplicationContext APPLICATION_CONTEXT)
	throws SQLException, JSONException; 
	public void getGiclMcTpDtl(HttpServletRequest request, GIISUser user)throws SQLException, JSONException; 
	void saveMcTpDtl(String strParameters,String userId)throws SQLException, JSONException;
	String validateClmItemNo(HttpServletRequest request, GIISUser USER)
	throws SQLException, JSONException, ParseException;
	String saveClmItemMotorCar(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String getTowAmount(Map<String, Object> params) throws SQLException;
	
	//vehicle information for gicls268
	void getGICLS268MotorCarDetail(HttpServletRequest request) throws SQLException;
	GICLMcTpDtl getGICLS260McTpOtherDtls(Map<String, Object>params) throws SQLException;
}
