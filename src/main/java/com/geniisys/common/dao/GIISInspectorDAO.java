package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISInspector;

public interface GIISInspectorDAO {

	List<GIISInspector> getInspectorListing(String keyword) throws SQLException;

	void saveGiiss169(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String inspName) throws SQLException;

	List<GIISInspector> getInspNameList() throws SQLException;
	
}
