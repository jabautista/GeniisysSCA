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

import com.geniisys.common.entity.GIISUserGrpDtl;


/**
 * The Interface GIISUserGrpDtlService.
 */
public interface GIISUserGrpDtlService {

	/**
	 * Gets the giis user grp dtl grp list.
	 * 
	 * @param userGrp the user grp
	 * @return the giis user grp dtl grp list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserGrpDtl> getGiisUserGrpDtlGrpList(String userGrp) throws SQLException;
	
	/**
	 * Sets the giis user grp dtl.
	 * 
	 * @param giisUserGrpDtl the new giis user grp dtl
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserGrpDtl(GIISUserGrpDtl giisUserGrpDtl) throws SQLException;
	
	/**
	 * Delete giis user grp dtl.
	 * 
	 * @param giisUserGrpDtl the giis user grp dtl
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserGrpDtl(GIISUserGrpDtl giisUserGrpDtl) throws SQLException;
	
	JSONObject getUserGrpDtl(HttpServletRequest request) throws SQLException, JSONException;
	void valAddDeleteDtl(HttpServletRequest request) throws SQLException;
	JSONArray getAllIssCodes(HttpServletRequest request) throws SQLException, JSONException;
}
