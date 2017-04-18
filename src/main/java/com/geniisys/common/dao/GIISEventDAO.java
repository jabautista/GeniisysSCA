package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISEvent;

public interface GIISEventDAO {

	List<GIISEvent> getGIISEventListing() throws SQLException;
	void saveGIISEvents(Map<String, Object> params) throws SQLException;
	void createTransferEvent(Map<String, Object> params) throws SQLException;
	void valDeleteGIISEvents(String recId) throws SQLException;
	void valDeleteGIISEventsColumn(String recId) throws SQLException;
	void valAddGIISEventsColumn(Map<String, Object> params) throws SQLException;
	void setGIISEventsColumn(Map<String, Object> params) throws SQLException;
	void valAddGIISEventsDisplay(Map<String, Object> params) throws SQLException;
	void setGIISEventsDisplay(Map<String, Object> params) throws SQLException;
}
