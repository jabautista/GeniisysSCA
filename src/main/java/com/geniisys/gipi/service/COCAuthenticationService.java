package com.geniisys.gipi.service;

import java.net.ConnectException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface COCAuthenticationService {

	Boolean registerCOCs(HttpServletRequest request, GIISUser user, String cocafAddress) throws ConnectException, SQLException, Exception;
	
}
