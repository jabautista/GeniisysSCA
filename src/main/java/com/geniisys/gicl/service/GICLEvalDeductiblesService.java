package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GICLEvalDeductiblesService {
	String saveGiclEvalDeductibles(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	void applyDeductiblesForMcEval(Map<String, Object> params) throws SQLException, Exception;
}
