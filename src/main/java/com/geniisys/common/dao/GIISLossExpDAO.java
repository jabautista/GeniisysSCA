package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISLossExpDAO {

	void saveGicls104(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> valPartSw(Map<String, Object> params) throws SQLException;
	String valLpsSw(String lossExpCd) throws SQLException;
	Map<String, Object> valCompSw(Map<String, Object> params) throws SQLException;
	String valLossExpType(Map<String, Object> params) throws SQLException;
	Map<String, Object> getOrigSurplusAmt(Map<String, Object> params) throws SQLException; //Added by Kenneth L. 06.11.2015 SR 3626
}
