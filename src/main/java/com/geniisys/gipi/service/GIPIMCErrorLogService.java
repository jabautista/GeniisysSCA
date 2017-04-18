/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIMCErrorLog;


/**
 * The Interface GIPIMCErrorLogService.
 */
public interface GIPIMCErrorLogService {

	/**
	 * Gets the gipi mc error list.
	 * 
	 * @param fileName the file name
	 * @return the gipi mc error list
	 * @throws SQLException the sQL exception
	 */
	List<GIPIMCErrorLog> getGipiMCErrorList(String fileName) throws SQLException;
	JSONObject getGipiMCErrorList2(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	
}
