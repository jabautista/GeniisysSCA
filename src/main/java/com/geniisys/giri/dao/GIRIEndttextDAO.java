package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giri.entity.GIRIEndttext;

public interface GIRIEndttextDAO {
	
	Map<String, Object> getRiDtlsGIUTS024(Map<String, Object> params) throws SQLException;
	List<GIRIEndttext> getRiDtlsList (HashMap<String, Object> params) throws SQLException;
	void updateCreateEndtTextBinder(Map<String, Object> params) throws Exception;
	public void deleteRiDtlsGIUTS024(Map<String, Object> params) throws SQLException;
	void saveEndtTextBinder(Map<String, Object> params) throws SQLException;
	
}
