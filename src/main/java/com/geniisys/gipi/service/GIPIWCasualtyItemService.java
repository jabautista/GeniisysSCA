package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWCasualtyItem;

public interface GIPIWCasualtyItemService {

	List<GIPIWCasualtyItem> getGipiWCasualtyItem(Integer parId) throws SQLException;
	void saveGIPIParCasualtyItem(Map<String, Object> params) throws SQLException;
	//Map<String, Object> gipis061NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIEndtCasualtyItem(String param, GIISUser user) throws SQLException, JSONException, ParseException;
	boolean saveCasualtyItem(Map<String, Object> param) throws SQLException;
	Map<String, Object> newFormInstace(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWCasualtyItem(String param, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> gipis061NewFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
}
