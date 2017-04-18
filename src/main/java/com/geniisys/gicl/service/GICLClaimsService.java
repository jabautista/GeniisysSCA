/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 8, 2010
 ***************************************************/
package com.geniisys.gicl.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.entity.GICLClaims;

public interface GICLClaimsService{
	
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
	 * @returns HashMap that contains list of Claims
	 * @throws  SQLException
	 */
	HashMap<String, Object> getRelatedClaims(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> getClaimsTableGridListing(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> getLossRecoveryTableGridListing(Map<String, Object> params) throws SQLException, JSONException;
	GICLClaims getClaimsBasicInfoDtls(Integer claimId) throws SQLException;
	Map<String, Object> initializeClaimsMenu(Map<String, Object> params) throws SQLException;
	Map<String, Object> getClmAssuredDtls(Map<String, Object> params) throws SQLException;
	Map<String, Object> enableMenus(Map<String, Object> params) throws SQLException;
	void updateClaimsBasicInfo(Map<String, Object> params) throws Exception;
	Map<String, Object> getBasicIntmDtls(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void clmItemPreDelete(Map<String, Object> params) throws SQLException;
	void clmItemPostFormCommit(Map<String, Object> params) throws SQLException;
	public Map<String, Object> checkClaimPlateNo(Map<String, Object> params)throws SQLException;
	public Map<String, Object> checkClaimMotorNo(Map<String, Object> params)throws SQLException;
	public Map<String, Object> checkClaimSerialNo(Map<String, Object> params)throws SQLException;
	String checkClaimStatus(String lineCode, String sublineCd, String issueCode, Integer claimYy, Integer claimSequenceNo) throws SQLException;
	GICLClaims getClaimInfo(Integer claimId) throws SQLException; /*belle*/
	HashMap<String, Object> getBasicClaimDtls(HashMap<String, Object> params) throws SQLException, JSONException;
	String validateClmPolicyNo(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String chkItemForTotalLoss(HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkExistingClaims(HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkTotalLossSettlement(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String validatePlateMotorSerialNo(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	void getBasicParametersDetails(GIISParameterFacadeService paramService, GIACParameterFacadeService giacParamService, HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkLossDateTime(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String getSublineTime(HttpServletRequest request, GIISUser USER) throws SQLException;
	String validateLossDatePlateNo(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String validateLossTime(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String claimCheck(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String validateCatastrophicCode(HttpServletRequest request, GIISUser USER) throws SQLException;
	String getCheckLocationDtl(HttpServletRequest request, GIISUser USER) throws SQLException;
	void deleteWorkflowRec3(String eventDesc, String moduleId, String userId, Object colValue) throws SQLException;
	String saveGICLS010(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, IOException;
	String checkPrivAdjExist(HttpServletRequest request, GIISUser USER) throws SQLException;
	void refreshClaims(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	Map<String, Object> getUpdateLossRecoveryTagListing(HttpServletRequest request, GIISUser user) throws SQLException, JSONException;
	void getClaimsPerPolicy(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getClaimsPerPolicyDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	void updateLossTagRecovery(HttpServletRequest request, GIISUser user)throws SQLException, JSONException;
	Map<String, Object> checkUnpaidPremiums(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> checkUnpaidPremiums2(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	void getRecoveryAmounts(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object>checkClaimReqDocs(Integer claimId) throws SQLException;
	GICLClaims getRelatedClaimsGICLS024(Integer claimId) throws SQLException;
	String validateRenewNoGIACS007(HttpServletRequest request, GIISUser USER) throws SQLException;
	String validateLineCd(HttpServletRequest request) throws SQLException;
	String validatePolIssCd(HttpServletRequest request, String userId) throws SQLException;
	String validateSublineCd(HttpServletRequest request) throws SQLException;
	Map<String, Object> checkUserFunction(Map<String, Object> params) throws SQLException, Exception;
	public boolean saveBatchClaimCLosing(Map<String, Object> params) throws Exception;
	String checkClaimToOpen(Integer claimId) throws SQLException;
	List<GICLClaims> getObjClaimClosingList(HttpServletRequest request, Map<String, Object> params) throws Exception;
	Map<String, Object> openClaims(Map<String, Object> params) throws SQLException, Exception;
	void reOpenClaimsGICLS039(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> confirmUserGICLS039(Map<String, Object> params) throws SQLException, Exception;
	String denyWithdrawCancelClaims(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> checkClaimClosing(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> validateFlaGICLS039(Map<String, Object> params) throws SQLException, Exception;
	String closeClaims(Map<String, Object> params) throws SQLException, Exception;
	void showClaimsHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclClaim(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getClmReserv(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getLossExp(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	GICLClaims getGICLS260BasicInfoDetails(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> initializeGICLS260Variables(Map<String, Object> params) throws SQLException;
	Map<String, Object> gicls125ReopenRecovery(HttpServletRequest request, GIISUser USER) throws SQLException;
	
	void validateGiacParameterStatus(HttpServletRequest request) throws SQLException;
	String validateGICLS010Line(HttpServletRequest request, String userId) throws SQLException;
	JSONObject showGicls273(HttpServletRequest request, String userId) throws SQLException, JSONException;	//Gzelle 07182014
	JSONObject showGicls273PaymentDetails(HttpServletRequest request, String userId) throws SQLException, JSONException;	//Gzelle 07182014
	String checkSharePercentage (HttpServletRequest request) throws SQLException; //carlo 01-06-2017 SR-5900
}
