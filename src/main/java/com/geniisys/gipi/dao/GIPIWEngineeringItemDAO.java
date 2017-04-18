package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWEngineeringItem;
import com.geniisys.gipi.entity.GIPIWLocation;

public interface GIPIWEngineeringItemDAO {
	
	//Map<String, String> isExist(Integer parId) throws SQLException;
	//Map<String, Object> preCommitENItem(Integer parId) throws SQLException;
	List<GIPIWEngineeringItem> getGipiWENItems(Integer parId) throws SQLException;
	void saveEngineeringItem(Map<String, Object> params) throws SQLException, JSONException;
	void saveEndtEngineeringItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis004NewFormInstance(Map<String, Object> params) throws SQLException;

	public List<GIPIWLocation> getWLocPerItem(int parId) throws SQLException;
}
