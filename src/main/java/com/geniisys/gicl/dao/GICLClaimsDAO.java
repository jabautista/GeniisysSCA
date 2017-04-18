/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 8, 2010
 ***************************************************/
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClaims;

public interface GICLClaimsDAO {
	/**
	 * Retrieves the Claims Object based on its claimId
	 * @param claimId
	 * @return
	 * @throws SQLException
	 */
	GICLClaims getClaims(Integer claimId) throws SQLException;
	
	/**
	 * Retrieves List of Claims for a given policy
	 * @param   a HashMap containing table grid parameters and policyId
	 * @returns list of Claims
	 * @throws  SQLException
	 */
	List<GICLClaims> getRelatedClaims(HashMap<String,Object> params) throws SQLException;
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getClaimsTableGridListing(Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getLossRecoveryTableGridListing(Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param claimId
	 * @return
	 * @throws SQLException
	 */
	GICLClaims getClaimsBasicInfoDtls(Integer claimId) throws SQLException;
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> initializeClaimsMenu(Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getClmAssuredDtls(Map<String, Object> params) throws SQLException;
	Map<String, Object> enableMenus(Map<String, Object> params) throws SQLException;
	void updateClaimsBasicInfo(Map<String, Object> params) throws Exception;
	List<Map<String, Object>> getBasicIntmDtls(Map<String, Object> params) throws SQLException;
	void clmItemPreDelete(Map<String, Object> params) throws SQLException;
	void clmItemPostFormCommit(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkClaimPlateNo(Map<String, Object>params) throws SQLException;
	Map<String, Object> checkClaimMotorNo(Map<String, Object>params) throws SQLException;
	Map<String, Object> checkClaimSerialNo(Map<String, Object>params) throws SQLException;
	String checkClaimStatus(String lineCode, String sublineCd, String issueCode, Integer claimYy, Integer claimSequenceNo) throws SQLException;
	GICLClaims getClaimInfo(Integer claimId) throws SQLException;
	Map<String, Object> validateClmPolicyNo(Map<String, Object> params) throws SQLException; 
	List<GICLClaims> getBasicClaimDtls(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> chkItemForTotalLoss(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkExistingClaims(Map<String, Object> params) throws SQLException;
	String checkTotalLossSettlement(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePlateMotorSerialNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkLossDateTime(Map<String, Object> params) throws SQLException;
	String getSublineTime(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateLossDatePlateNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateLossTime(Map<String, Object> params) throws SQLException;
	Map<String, Object> claimCheck(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateCatastrophicCode(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCheckLocationDtl(Map<String, Object> params) throws SQLException;
	void deleteWorkflowRec3(String eventDesc, String moduleId, String userId, Object colValue) throws SQLException;
	Map<String, Object> saveGICLS010(Map<String, Object> params) throws SQLException;
	String checkPrivAdjExist(Map<String, Object> params) throws SQLException;
	void refreshClaims(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getUpdateLossRecoveryTagListing(Map<String, Object>params) throws SQLException;
	void updateLossTagRecovery(Map<String, Object>params)throws SQLException;
	Map<String, Object> checkUnpaidPremiums(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> checkUnpaidPremiums2(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> getRecoveryAmounts(Map<String, Object> params) throws SQLException;
	Map<String, Object>checkClaimReqDocs(Integer claimId) throws SQLException;
	GICLClaims getRelatedClaimsGICLS024(Integer claimId) throws SQLException;

	String validateLineCd(Map<String, Object> params) throws SQLException;
	String validatePolIssCd(Map<String, Object> params) throws SQLException;
	String validateSublineCd(Map<String, Object> params) throws SQLException;
	String validateRenewNoGIACS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkUserFunction(Map<String, Object> params) throws SQLException, Exception;
	public void saveBatchClaimCLosing(Map<String, Object> parameters) throws Exception;
	String checkClaimToOpen(Integer claimId) throws SQLException;
	List<GICLClaims> getObjClaimClosingList(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> openClaims(Map<String, Object> params) throws SQLException, Exception;
	void reOpenClaimsGICLS039(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> confirmUserGICLS039(Map<String, Object> params) throws SQLException, Exception;
	String denyWithdrawCancelClaims(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> checkClaimClosing(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> validateFlaGICLS039(Map<String, Object> params) throws SQLException, Exception;
	String closeClaims(Map<String, Object> params) throws SQLException, Exception;
	//added by cherrie 12.19.2012
	Map<String, Object> getGiclClaim() throws SQLException, Exception;
	GICLClaims getGICLS260BasicInfoDetails(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> initializeGICLS260Variables(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> gicls125ReopenRecovery(Map<String, Object> params) throws SQLException;
	
	void validateGiacParameterStatus(Map<String, Object> params) throws SQLException;
	String validateGICLS010Line(Map<String, Object> params) throws SQLException;
	String checkSharePercentage(Map<String, Object> params) throws SQLException; //carlo 01-06-2016 SR-5900
	List<String> getClaimItemAttachments(Map<String, Object> params) throws SQLException;
	void deleteClaimItemAttachments(Map<String, Object> params) throws SQLException;
}

