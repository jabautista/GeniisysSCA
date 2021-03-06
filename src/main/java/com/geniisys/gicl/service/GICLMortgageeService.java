package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLMortgageeService {
	
	void getGiclMortgageeGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void setClmItemMortgagee(Map<String, Object> params) throws SQLException;
	String checkIfGiclMortgageeExist(Map<String, Object> params) throws SQLException;
}
