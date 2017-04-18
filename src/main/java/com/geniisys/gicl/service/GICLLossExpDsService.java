package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GICLLossExpDsService {
	Map<String, Object> checkXOL(HttpServletRequest request, GIISUser USER) throws SQLException;
	String distributeLossExpHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	String redistributeLossExpHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	String negateLossExpenseHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
}
