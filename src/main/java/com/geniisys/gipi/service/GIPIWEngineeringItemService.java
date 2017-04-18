package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import java.text.ParseException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWEngineeringItem;
import com.geniisys.gipi.entity.GIPIWLocation;

public interface GIPIWEngineeringItemService {
	
	List<GIPIWEngineeringItem> getGipiWENItems(Integer parId) throws SQLException;	
	void saveEngineeringItem(String param, GIISUser user) throws SQLException, JSONException, ParseException;
	void saveEndtEngineeringItem(String endtEngineeringItemInfo, Map<String, Object> params) throws SQLException, JSONException, ParseException;

	public List<GIPIWLocation> getWLocPerItem(int parId) throws SQLException;
	
	Map<String, Object> newENInstance(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> gipis067NewFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> newENInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
}
