package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;

public interface GIISVessClassService {
	JSONObject showVesselClassification (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateGIISS047VesselClass (HttpServletRequest request) throws SQLException;
	Map<String, Object> saveVessClass(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	void valDelRec(HttpServletRequest request) throws SQLException;
}