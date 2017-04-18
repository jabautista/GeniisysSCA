package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLReserveDsService {

	void getGiclReserveDsGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	/**
	 * Retrieve Reserve DS TableGrid for Claim Reserve Page
	 * @module GICLS024
	 * @param request
	 * @param USER
	 * @throws SQLException
	 * @throws JSONException
	 */
	void getGiclReserveDsGrid2(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	String saveReserveDs(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String validateXolDeduc(HttpServletRequest request) throws SQLException, JSONException;
	String continueXolDeduc(HttpServletRequest request) throws SQLException, JSONException;
	String checkXOLAmtLimits(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> updateShrLossResGICLS024(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> updateShrPctGICLS024(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> updateShrExpResGICLS024(HttpServletRequest request, GIISUser USER) throws SQLException;
	
}
