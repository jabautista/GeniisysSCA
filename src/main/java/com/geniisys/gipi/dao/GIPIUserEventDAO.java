package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIUserEvent;

public interface GIPIUserEventDAO {

	List<GIPIUserEvent> getGIPIUserEventTableGrid(Map<String, Object> params) throws SQLException;
	List<GIPIUserEvent> getGIPIUserEventDetailTableGrid(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveCreatedEvent(Map<String, Object> params) throws SQLException, Exception;
	void setWorkflowGICLS010(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> transferEvents(Map<String, Object> params) throws SQLException, JSONException, Exception;
	void deleteEvents(Map<String, Object> params) throws SQLException;
	void saveGIPIUserEventDtls(Map<String, Object> params) throws SQLException;
}
