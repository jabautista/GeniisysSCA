package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLClmAdjuster;

public interface GICLClmAdjusterService {
	
	Map<String, Object> getClmAdjusterListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String checkBeforeDeleteAdj(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveClmAdjuster(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	List<GICLClmAdjuster> getLossExpAdjusterList(Integer claimId) throws SQLException;
	List<GICLClmAdjuster> getClmAdjusterList(Integer claimId) throws SQLException;
}
