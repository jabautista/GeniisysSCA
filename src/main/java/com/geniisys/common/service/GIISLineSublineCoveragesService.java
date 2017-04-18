package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;

public interface GIISLineSublineCoveragesService {
	JSONObject showPackageLineSublineCoverage (HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showPackageLineCoverage (HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> saveGiiss096(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	void valDeleteRec (HttpServletRequest request) throws SQLException;
	void valAddRec (HttpServletRequest request) throws SQLException;
}
