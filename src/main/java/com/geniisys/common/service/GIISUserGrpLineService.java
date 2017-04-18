/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUserGrpLine;


/**
 * The Interface GIISUserGrpLineService.
 */
public interface GIISUserGrpLineService {

	/**
	 * Gets the giis user grp line list.
	 * 
	 * @param userGrp the user grp
	 * @return the giis user grp line list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserGrpLine> getGiisUserGrpLineList(String userGrp) throws SQLException;
	
	/**
	 * Sets the giis user grp line.
	 * 
	 * @param giisUserGrpLine the new giis user grp line
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserGrpLine(GIISUserGrpLine giisUserGrpLine) throws SQLException;
	
	/**
	 * Delete giis user grp line.
	 * 
	 * @param giisUserGrpLine the giis user grp line
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserGrpLine(GIISUserGrpLine giisUserGrpLine) throws SQLException;
	
	JSONObject getUserGrpLine(HttpServletRequest request) throws SQLException, JSONException;
	void valDeleteLine(HttpServletRequest request) throws SQLException;
	JSONArray getAllLineCodes(HttpServletRequest request) throws SQLException, JSONException;
}
