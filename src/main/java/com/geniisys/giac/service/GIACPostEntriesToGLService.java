package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;


public interface GIACPostEntriesToGLService {

	public Integer getGLNo() throws SQLException;
	public Integer getFinanceEnd() throws SQLException;
	public Integer getFiscalEnd() throws SQLException;
	public Integer validateTranYear(HttpServletRequest request) throws SQLException;
	public String validateTranMonth(HttpServletRequest request) throws SQLException;
	public void checkIsPrevMonthClosed(HttpServletRequest request) throws SQLException;
	public String postToGL(HttpServletRequest request) throws SQLException;
}
