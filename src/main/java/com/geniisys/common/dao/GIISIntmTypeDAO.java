package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISIntmType;

public interface GIISIntmTypeDAO {
	JSONObject showIntmType(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> valDelGIISS083IntmType (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveIntmType(Map<String, Object> params) throws SQLException;
	void valAddRec(String recId) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	//shan 11.8.2013
	List<GIISIntmType> getIntmTypeGiiss203() throws SQLException;
	String valUpdateIntmType(Map <String, Object> params) throws JSONException, SQLException; //Added by Jerome 08.11.2016 SR 5583
}