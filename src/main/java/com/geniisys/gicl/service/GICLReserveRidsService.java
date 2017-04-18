/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GICLS024
 * Created By	:	rencela
 * Create Date	:	Apr 13, 2012
 ***************************************************/
package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLReserveRidsService {
	void getReserveRidsGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException; 
}
