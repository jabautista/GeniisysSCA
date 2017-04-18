package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLBatchCsr;

public interface GICLBatchCsrService {
	GICLBatchCsr getGICLBatchCsr(Map<String, Object> params) throws SQLException;
	Integer generateBatchNumber(JSONObject objParams, GIISUser USER) throws SQLException, Exception;
	void cancelBatchCsr(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> gicls043C024PostQuery(Map<String, Object> params) throws SQLException, Exception;
	void saveBatchCsr(JSONObject objParams, GIISUser USER) throws SQLException, Exception;
	String getBatchCsrReportId(Map<String, Object> params) throws SQLException, Exception;
}
