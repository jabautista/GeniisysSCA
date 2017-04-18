/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUserGrpHdr;


/**
 * The Interface GIISUserGrpHdrDAO.
 */
public interface GIISUserGrpHdrDAO {

	/**
	 * Sets the giis user grp hdr.
	 * 
	 * @param userGrpHdr the new giis user grp hdr
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserGrpHdr(GIISUserGrpHdr userGrpHdr) throws SQLException;
	
	/**
	 * Gets the giis user grp list.
	 * 
	 * @param param the param
	 * @return the giis user grp list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserGrpHdr> getGiisUserGrpList(String param) throws SQLException;
	
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
	
	String copyUserGrp(Map<String, Object> params) throws SQLException;
	
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGIISS041(Map<String, Object> params) throws SQLException, JSONException;
}
