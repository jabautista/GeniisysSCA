package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

public interface GIACCommSlipExtDAO {

	void populateBatchCommSlip(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCommSlipNo(Map<String, Object> params) throws SQLException;
	void tagAll(Map<String, Object> params) throws SQLException;
	void untagAll() throws SQLException;
	Map<String, Object> generateCommSlipNo(Map<String, Object> params) throws SQLException;
	void saveGenerateFlag(Map<String, Object> params) throws SQLException, JSONException;
	List<Map<String, Object>> getBatchCommSlipReports() throws SQLException;
	Map<String, Object> updateCommSlip(Map<String, Object> params) throws SQLException;
	void clearCommSlipNo(Map<String, Object> params) throws SQLException;
	
}
