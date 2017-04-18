package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWAviationItem;

public interface GIPIWAviationItemService {
	
	Map<String, String> isExist(Integer parId) throws SQLException;
	List<GIPIWAviationItem> getGipiWAviationItem(Integer parId) throws SQLException;
	void saveGipiWAviation(List<GIPIWAviationItem> aviationItems) throws SQLException;
	Map<String, String> preCommitAviationItem(Integer parId,Integer itemNo,String vesselCd) throws SQLException;
	boolean saveAvaiationItem(Map<String, Object> param) throws SQLException;
	Map<String, Object> newFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWAviationItm(String param, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> gipis082NewFormInstance(Map<String, Object> params)	throws SQLException, JSONException;
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
}
