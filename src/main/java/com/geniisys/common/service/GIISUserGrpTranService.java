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

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISTransaction;
import com.geniisys.common.entity.GIISUserGrpTran;


/**
 * The Interface GIISUserGrpTranService.
 */
public interface GIISUserGrpTranService {

	/**
	 * Gets the giis user grp tran list.
	 * 
	 * @param userGrp the user grp
	 * @return the giis user grp tran list
	 * @throws SQLException the sQL exception
	 */
	List<GIISTransaction> getGiisUserGrpTranList(int userGrp) throws SQLException;
	
	/**
	 * Delete giis user grp tran.
	 * 
	 * @param userGrpTran the user grp tran
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserGrpTran(GIISUserGrpTran userGrpTran) throws SQLException;
	
	JSONObject getUserGrpTran(HttpServletRequest request) throws SQLException, JSONException;
	void valAddUserGrpTran(HttpServletRequest request) throws SQLException;
	void saveUserGrpTran(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
