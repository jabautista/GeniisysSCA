package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISIntmType;
import com.geniisys.common.entity.GIISUser;

public interface GIISIntmTypeService {
	JSONObject showIntmType (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> saveIntmType(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	//shan 11.8.2013
	List<GIISIntmType> getIntmTypeGiiss203() throws SQLException;
	String valUpdateIntmType(Map <String, Object> params) throws JSONException, SQLException; //Added by Jerome 08.11.2016 SR 5583
}