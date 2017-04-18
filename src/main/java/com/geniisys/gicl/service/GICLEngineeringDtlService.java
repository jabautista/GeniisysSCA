package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLEngineeringDtlService {

	/**
	 * Loads all required items and records for Engineering Item Info page
	 * @param params
	 * @throws SQLException
	 */
	void loadEngineeringItemInfoItems(Map<String, Object> params) throws SQLException;
	
	/**
	 * Loads the table grid list of GICL_ENGINEERING_DTL items
	 * @param request
	 * @param USER
	 * @param APPLICATION_CONTEXT
	 * @throws SQLException
	 * @throws JSONException
	 */
	void getGiclEngineeringDtlGrid(HttpServletRequest request, GIISUser USER, ApplicationContext APPLICATION_CONTEXT) throws SQLException, JSONException;
	
	/**
	 * Save Engineering Claim Item Info
	 * @param request
	 * @param USER
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	String saveClmItemEngineering(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	/**
	 * Validate item no
	 * @param request
	 * @param USER
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	String validateClmItemNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
}
