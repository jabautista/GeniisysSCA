package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIQuoteBondBasic;

public interface GIPIQuoteBondBasicService {

	GIPIQuoteBondBasic getGIPIQuoteBondBasic(Integer quoteId) throws SQLException;
	GIPIQuoteBondBasic prepareBondPolicyData(HttpServletRequest request, GIISUser USER) throws ParseException;
	String saveBondPolicyData(Map<String, Object> params) throws SQLException;
}
