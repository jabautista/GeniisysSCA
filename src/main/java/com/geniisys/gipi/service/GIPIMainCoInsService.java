package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.entity.GIPIMainCoIns;

public interface GIPIMainCoInsService {
	
	GIPIMainCoIns getPolicyMainCoIns(Integer policyId) throws SQLException;
	//shan 10.21.2013
	String limitEntryGIPIS154(HttpServletRequest request) throws SQLException;
}
