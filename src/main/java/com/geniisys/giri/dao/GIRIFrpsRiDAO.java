package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giri.entity.GIRIFrpsRi;

public interface GIRIFrpsRiDAO {
	
	List<GIRIFrpsRi> getGIRIFrpsRiList (HashMap<String, Object> params) throws SQLException;
	Map<String, Object> checkBinderGiuts004(Map<String, Object> params) throws SQLException;
	Map<String, Object> performReversalGiuts004(Map<String, Object> params) throws SQLException;
	String reversePackageBinder(Map<String, Object> params) throws SQLException;
	String generatePackageBinder(Map<String, Object> params) throws Exception;
	void groupBinders(Map<String, Object> params) throws SQLException;
	void ungroupBinders(Map<String, Object> params) throws SQLException;
	Integer getOutFaculTotAmtGIUTS004(Map<String, Object> params) throws SQLException;
	String checkBinderWithClaimsGIUTS004(Map<String, Object> params) throws SQLException;
}
