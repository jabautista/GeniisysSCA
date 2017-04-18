package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GICLLossExpBillService {
	
	void saveLossExpBill(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> chkLossExpBill (HttpServletRequest request) throws SQLException, Exception; //Added by: Jerome Bautista 05.28.2015 
}
