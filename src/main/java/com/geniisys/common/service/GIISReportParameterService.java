package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIISReportParameterService {
	Map<String, Object> saveReportParameter(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
}
