package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GICLLossExpTaxService {

	Integer getNextTaxId(Map<String, Object> params) throws SQLException, Exception;
	void saveLossExpTax(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Integer checkLossExpTaxType(HttpServletRequest request) throws SQLException;
	String checkLossExpTaxExist(HttpServletRequest request) throws SQLException; //benjo 03.08.2017 SR-5945
}
