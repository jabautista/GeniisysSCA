package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWItemVes;

public interface GIPIWItemVesService {
	List<GIPIWItemVes> getGipiWItemVes(Integer parId) throws SQLException;
	void saveGIPIParMarineHullItem (Map<String, Object> params) throws SQLException;
	GIPIWItemVes getEndtGipiWItemVesDetails(Map<String, Object> params) throws SQLException;
	String validateVessel(Map<String, Object> params) throws SQLException;
	void saveEndtMarineHullItemInfoPage(Map<String, Object> params) throws SQLException;
	String preInsertMarineHull(Map<String, Object> params) throws SQLException;
	String checkItemVesAddtlInfo(Integer parId) throws SQLException;
	void changeItemVesGroup(Integer parId) throws SQLException; 
	String checkUpdateGipiWPolbasValidity(Map<String, Object> params) throws SQLException;
	String checkCreateDistributionValidity(Integer parId) throws SQLException;
	public String checkGiriDistfrpsExist(Integer parId) throws SQLException;
	void updateGipiWPolbas2(Map<String, Object> updateGIPIWPolbasParams) throws SQLException;
	List<GIPIWItemVes> prepareGIPIWItemVesListing(JSONArray setRows) throws SQLException, JSONException;
	public void saveGIPIEndtItemVes(String param, GIISUser user) throws SQLException, JSONException, ParseException;
	
	Map<String, Object> newFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWItemVes(String param, GIISUser user) throws SQLException, JSONException, ParseException;
	Map<String, Object> gipis081NewFormInstance(Map<String, Object> params)	throws SQLException, JSONException;
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
}
