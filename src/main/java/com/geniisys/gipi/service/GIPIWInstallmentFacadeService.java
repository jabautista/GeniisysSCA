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
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWInstallment;


/**
 * The Interface GIPIWInstallmentFacadeService.
 */
public interface GIPIWInstallmentFacadeService {
	
	/**
	 * Gets the gIPIW installment.
	 * 
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @param takeupSeqNo the takeup seq no
	 * @return the gIPIW installment
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInstallment> getGIPIWInstallment(int parId, int itemGrp, int takeupSeqNo) throws SQLException;
	
	/**
	 * Delete gipi winstallment.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteGIPIWinstallment(int parId) throws SQLException;
	
	/**
	 * Save gipiw installment.
	 * 
	 * @param parameters the parameters
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveGIPIWInstallment(Map<String, Object> parameters) throws SQLException;
	
	/**
	 * Do payterm computation.
	 * 
	 * @param version the version
	 * @param dueDate the due date
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object>  doPaytermComputation(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the gIPIW installment.
	 * 
	 * @param parId the par id
	 * @return the gIPIW installment
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInstallment> getAllGIPIWInstallment(int parId) throws SQLException;
}
