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

import com.geniisys.common.entity.GIISUserGrpLine;


/**
 * The Interface GIISUserGrpLineDAO.
 */
public interface GIISUserGrpLineDAO {

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
	
	void valDeleteLine(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getAllLineCodes(Map<String, Object> params) throws SQLException, JSONException;
}
