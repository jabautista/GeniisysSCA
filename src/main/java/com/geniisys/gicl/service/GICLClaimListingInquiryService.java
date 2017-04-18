/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	gzelle
 * Create Date	:	02.07.2013
 ***************************************************/
package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLClaimListingInquiryService {
	//perColor
	JSONObject showClaimListingPerColor (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateColorPerColor (HttpServletRequest request) throws SQLException;
	String validateBasicColorPerColor(HttpServletRequest request) throws SQLException;
	
	//perLawyer
	JSONObject showClaimListingPerLawyer(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateLawyer(HttpServletRequest request) throws SQLException;
	JSONObject showGicls276RecoveryDetails(HttpServletRequest request) throws SQLException, JSONException;
	
	//perAdjuster
	JSONObject showClmListingPerAdjuster (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validatePayeePerAdjuster (HttpServletRequest request) throws SQLException;
	
	//perAssured
	JSONObject showClaimListingPerAssured (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showPerAssuredFreeText (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//perIntermediary
	JSONObject showClaimListingPerIntermediary (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getClaimDetails (HttpServletRequest request) throws SQLException, JSONException;
	
	//perMake
	JSONObject showClaimListingPerMake (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//perMotorcarReplacementParts
	JSONObject showClaimListingPerMotorcarReplacementParts (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getLossDtlsField (HttpServletRequest request) throws SQLException, JSONException;
	
	//perPlateNo
	JSONObject showClaimListingPerPlateNo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//recoveryDetails
	JSONObject getRecoveryDetails (HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getPayorDetails (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getHistory (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//policy
	JSONObject showClaimListingPerPolicy (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//packagePolicy
	JSONObject showClaimListingPerPackagePolicy (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//perRecoveryType
	JSONObject showClaimListingPerRecoveryType (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGICLS258Details (HttpServletRequest request) throws SQLException, JSONException;
	
	//perUser
	JSONObject showClaimListingPerUser (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showClaimListingPerPayee(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showPerPayeeDtl(HttpServletRequest request) throws SQLException, JSONException, Exception;

	//perBlock
	JSONObject showClaimListingPerBlock (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateDistrictPerBlock (HttpServletRequest request) throws SQLException;
	String validateBlockPerBlock(HttpServletRequest request) throws SQLException;
	JSONObject getBlockByDistrictNo(HttpServletRequest request) throws SQLException;
	
	//perCargoType
	JSONObject showClaimListingPerCargoType(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateCargoClassPerCargoClass(HttpServletRequest request) throws SQLException;
	String validateCargoTypePerCargoClass(HttpServletRequest request) throws SQLException;
	JSONObject fetchCorrespondingCargoTypeBasedOnClassCd(HttpServletRequest request) throws SQLException;
	JSONArray fetchValidCargo(HttpServletRequest request) throws SQLException;
	
	//perMotorshop
	JSONObject showClaimListingPerMotorshop(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateMotorshop(HttpServletRequest request) throws SQLException;
	
	//perNatureOfLoss
	JSONObject showClaimListingPerNatureOfLoss(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateLineCdByLineName(HttpServletRequest request) throws SQLException;
	String validateLossCatDescPerLineCd(HttpServletRequest request) throws SQLException;
	JSONObject fetchValidLossCatDesc(HttpServletRequest request) throws SQLException;
	JSONArray fetchValidLineCd(HttpServletRequest request) throws SQLException;
	Map<String, Object> populateGicls256Totals(HttpServletRequest request, GIISUser USER) throws SQLException;
	
	//perVessel
	JSONObject showClaimListingPerVessel(HttpServletRequest request)throws SQLException, JSONException, ParseException;

	//per Bill
	JSONObject showClaimListingPerBill(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String validatePayees(HttpServletRequest request) throws SQLException;
	String validatePayeeClass(HttpServletRequest request) throws SQLException;
	String validateDocNumber(HttpServletRequest request) throws SQLException;
	
	//perThirdParty
	JSONObject showClaimListingPerThirdParty(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONArray fetchValidThirdParty(HttpServletRequest request, GIISUser USER) throws SQLException;
	JSONArray validateClassPerClass(HttpServletRequest request) throws SQLException;
	JSONArray validatePayeePerClassCd(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGicls277PayeeName(HttpServletRequest request) throws SQLException;
	
	//perPolicyWithEnrollees
	JSONObject getClaimsWithEnrollees(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String validateGICLS278Field(HttpServletRequest request) throws SQLException;
	String validateGICLS278Entries(HttpServletRequest request, String userId) throws SQLException;
}
