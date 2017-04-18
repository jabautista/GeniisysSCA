package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface GICLGeneratePLAFLAService {

	Map<String, Object> queryCountUngenerated(HttpServletRequest request, String userId) throws SQLException;
}
