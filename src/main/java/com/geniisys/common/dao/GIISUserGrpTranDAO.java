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

import com.geniisys.common.entity.GIISTransaction;
import com.geniisys.common.entity.GIISUserGrpTran;


/**
 * The Interface GIISUserGrpTranDAO.
 */
public interface GIISUserGrpTranDAO {

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
	void valAddUserGrpTran(Map<String, Object> params) throws SQLException;
	void saveUserGrpTran(Map<String, Object> params) throws SQLException, JSONException;
}
