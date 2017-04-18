package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

import atg.taglib.json.util.JSONTokener;

import com.geniisys.common.entity.GIISUser;

public interface GIACEndOfMonthReportsDAO {
	void giacs138ExtractRecord(Map<String, Object> params) throws SQLException, Exception;
	void giacs128ExtractRecord(Map<String, Object> params) throws SQLException, Exception;
	
	//added by kenneth L. for Accounting Production Reports 10.30.2013
	String deleteGiacProdExt () throws SQLException;
	String insertGiacProdExt (Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPrevExt(GIISUser userId) throws SQLException;
}
