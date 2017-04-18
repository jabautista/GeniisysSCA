/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Feb 24, 2012
 ***************************************************/
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClaimReserve;

public interface GICLClaimReserveDAO {
	
	/**
	 * Retrieves initial values for claim reserve screen.
	 * @param claimId
	 * @return values
	 * @throws SQLException
	 */
	Map<String,Object> getClaimReserveInitValues(Map<String, Object> pars) throws SQLException;
	
	/**
	 * Get specific claim reserve
	 * @param claimId
	 * @param itemNo
	 * @return claim reserve
	 * @throws SQLException
	 */
	GICLClaimReserve getClaimReserve(Integer claimId, Integer itemNo, Integer perilCd) throws SQLException;
	void getPreValidationParams(Map<String, Object> params) throws SQLException;
	void updateStatus(Map<String, Object> params) throws SQLException;
	Map<String, Object> getAvailmentTotals(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkUWDist(Map<String, Object> params) throws SQLException;
	String redistributeReserve(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkLossRsrv(Map<String, Object> params) throws SQLException;
	String gicls024OverrideExpense(Map<String, Object> params) throws SQLException;
	void createOverrideRequest(Map<String, Object> params) throws SQLException;
	String saveClaimReserve(Map<String, Object> params) throws SQLException;
	public void executeGICLS024PostFormsCommit(Map<String, Object> params) throws SQLException;
	Map<String, Object> gicls024ChckLossRsrv(Map<String, Object> params) throws SQLException;
	String chckBkngDteExist(Integer claimId) throws SQLException;
	String gicls024OverrideCount(Integer claimId) throws SQLException;
	String checkIfExistGiclClmReserve(Integer claimId) throws SQLException;
	Map<String, Object> validateExistingDistGICLS024(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> redistributeReserveGICLS038(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> redistributeLossExpenseGICLS038(HashMap<String, Object> params) throws SQLException;
	void createOverrideBasicInfo(Map<String, Object> params) throws SQLException;
	
}
