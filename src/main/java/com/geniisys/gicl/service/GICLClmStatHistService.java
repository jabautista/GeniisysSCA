package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLClmStatHistService {
	Map<String, Object> getClmStatHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
