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

import com.geniisys.common.entity.GIISUserGrpDtl;


/**
 * The Interface GIISUserGrpDtlDAO.
 */
public interface GIISUserGrpDtlDAO {

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
	
	void valAddDeleteDtl(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getAllIssCodes(Map<String, Object> params) throws SQLException, JSONException;
}
