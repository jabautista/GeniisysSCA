package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLRecoveryRids;

public interface GICLRecoveryRidsService {
	GICLRecoveryRids getFlaRecovery(Map<String, Object> params) throws SQLException;
	String getClmRecoveryRIDistGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
}
