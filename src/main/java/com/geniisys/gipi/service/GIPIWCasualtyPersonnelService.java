package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWCasualtyPersonnel;

public interface GIPIWCasualtyPersonnelService {

	List<GIPIWCasualtyPersonnel> getGipiWCasualtyPersonnel(Integer parId) throws SQLException;
	Map<String, Object> getCasualtyPersonnelDetails(HttpServletRequest request) throws SQLException;
	List<GIPIWCasualtyPersonnel> prepareGIPIWCasualtyPersonnelForInsertUpdate(JSONArray setRows) throws JSONException;
	List<Map<String, Object>> prepareGIPIWCasualtyPersonnelForDelete(JSONArray delRows) throws JSONException;
}
