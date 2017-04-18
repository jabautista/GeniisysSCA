package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLClmRecoveryDistService {
	String getClmRecoveryDistGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void distributeRecovery(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void negateDistRecovery(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveRecoveryDist(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
