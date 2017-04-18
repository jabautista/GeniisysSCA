package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GICLBiggestClaimService {
	
	String whenNewFormInstanceGICLS220(HttpServletRequest request) throws SQLException;
	String extractGICLS220(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String extractParametersExistGicls220(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
}
