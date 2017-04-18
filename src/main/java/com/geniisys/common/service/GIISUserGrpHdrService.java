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
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUserGrpHdr;
import com.geniisys.framework.util.PaginatedList;


/**
 * The Interface GIISUserGrpHdrService.
 */
public interface GIISUserGrpHdrService {

	/**
	 * Sets the giis user grp hdr.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserGrpHdr(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the giis user grp list.
	 * 
	 * @param param the param
	 * @return the giis user grp list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserGrpHdr> getGiisUserGrpList(String param) throws SQLException;
	
	/**
	 * Gets the giis user group list.
	 * 
	 * @param param the param
	 * @param pageNo the page no
	 * @return the giis user group list
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getGiisUserGroupList(String param, int pageNo) throws SQLException;
	
	/**
	 * Gets the giis user grp hdr.
	 * 
	 * @param userGrp the user grp
	 * @return the giis user grp hdr
	 * @throws SQLException the sQL exception
	 */
	GIISUserGrpHdr getGiisUserGrpHdr(int userGrp) throws SQLException;
	
	/**
	 * Delete giis user grp hdr.
	 * 
	 * @param userGrp the user grp
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserGrpHdr(int userGrp) throws SQLException;
	
	/**
	 * Delete giis user grp hdr details.
	 * 
	 * @param userGrpHdr the user grp hdr
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserGrpHdrDetails(GIISUserGrpHdr userGrpHdr) throws SQLException;
	
	String getUserGrpHdrs() throws SQLException;
	
	String copyUserGrp(Map<String, Object> params) throws SQLException;
	
	JSONObject showGIISS041(HttpServletRequest request) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGIISS041(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
