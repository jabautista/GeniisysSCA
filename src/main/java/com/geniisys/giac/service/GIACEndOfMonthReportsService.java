package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GIACEndOfMonthReportsService {

	void giacs138ExtractRecord(HttpServletRequest request, GIISUser USER) throws SQLException,Exception;
	void giacs128ExtractRecord(HttpServletRequest request, GIISUser USER) throws SQLException,Exception;
	//added by kenneth L. for Accounting Production Reports 10.30.2013
	String deleteGiacProdExt () throws SQLException;
	String insertGiacProdExt (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String checkPrevExt(GIISUser USER) throws SQLException, Exception;
}
