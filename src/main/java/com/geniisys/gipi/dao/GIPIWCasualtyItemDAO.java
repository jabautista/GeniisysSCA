package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWCasualtyItem;

public interface GIPIWCasualtyItemDAO {

	List<GIPIWCasualtyItem> getGipiWCasualtyItem(Integer parId) throws SQLException;
	void saveGIPIParCasualtyItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis061NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIEndtCasualtyItem(Map<String, Object> allParams) throws SQLException, ParseException;
	boolean saveCasualtyItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis011NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIWCasualtyItem(Map<String, Object> params) throws SQLException, JSONException;
}
