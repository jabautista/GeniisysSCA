package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACApdcPayt;

public interface GIACApdcPaytDAO {

	List<GIACApdcPayt> getApdcPaytListing(Map<String, Object> params) throws SQLException;
	Map<String, Object> popApdc(Map<String, Object> params) throws SQLException;
	Integer generateApdcId() throws SQLException;
	void saveAcknowledgmentReceipt(Map<String, Object> allParams) throws Exception;
	String verifyApdcNo(Map<String, Object> params) throws SQLException;
	void getDocSeqNo(Map<String, Object> params) throws SQLException;
	void savePrintChanges(Map<String, Object> params) throws Exception;
	
	GIACApdcPayt getApdcPayt(Map<String, Object> params) throws SQLException;
	GIACApdcPayt getGIACApdcPayt(Integer apdcId) throws SQLException;
	void getBreakdownAmounts(Map<String, Object> params) throws SQLException;
	void delGIACApdcPayt(Integer apdcId) throws SQLException;
	void saveGIACApdcPayt(Map<String, Object> params) throws SQLException;
	void cancelGIACApdcPayt(Map<String, Object> params) throws SQLException;
	void valDelApdc(Map<String, Object> params) throws SQLException;
}
