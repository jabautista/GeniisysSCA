package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLProcessorHistService {
	Map<String, Object> getProcessorHist(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
