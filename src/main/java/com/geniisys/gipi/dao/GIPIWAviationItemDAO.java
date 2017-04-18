package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWAviationItem;

public interface GIPIWAviationItemDAO {

	Map<String, String> isExist(Integer parId) throws SQLException;
	List<GIPIWAviationItem> getGipiWAviationItem(Integer parId) throws SQLException;
	void saveGipiWAviation(List<GIPIWAviationItem> aviationItems) throws SQLException;
	Map<String, String> preCommitAviationItem(Integer parId, Integer itemNo,String vesselCd) throws SQLException;
	boolean saveAvaiationItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis019NewFormInstance(Map<String, Object> newInstanceMap) throws SQLException;
	void saveGIPIWAviationItm(Map<String, Object> params) throws SQLException, JSONException;
}
