package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLBatchCsr;

public interface GICLBatchCsrDAO {
	GICLBatchCsr getGICLBatchCsr(Map<String, Object> params) throws SQLException;
	Integer generateBatchNumber(Map<String, Object> params) throws SQLException, Exception;
	void cancelBatchCsr(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> gicls043C024PostQuery(Map<String, Object> params) throws SQLException, Exception;
	void saveBatchCsr(Map<String, Object> params) throws SQLException, Exception;
	String getBatchCsrReportId(Map<String, Object> params) throws SQLException, Exception;
}
