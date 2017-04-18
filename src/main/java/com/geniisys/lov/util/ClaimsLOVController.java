/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.lov.util
	File Name: ClaimsLOVController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 22, 2011
	Description: 
*/


package com.geniisys.lov.util;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONUtil;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="ClaimsLOVController", urlPatterns={"/ClaimsLOVController"})
public class ClaimsLOVController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6147788640928813060L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		// common parameters
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("currentPage", Integer.parseInt(request.getParameter("page")));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("findText", request.getParameter("findText"));
		if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
			params.put("findText", request.getParameter("filterText"));
		}
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
		}
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		params.put("ACTION", ACTION);
		
		try {		
			// IMPORTANT: use the specified action for controller as the id for sqlMap select/procedure			
			// NOTE: format for lov action is : "get<Entity Name>LOV"

			// parameters per action
			System.out.println("CLAIMS LOV CONTROLLER: "+ACTION);
			if("getGIISPayeeLOVDetails".equals(ACTION)){
				params.put("sendToCd", request.getParameter("sendToCd"));			
			}else if ("getGiisPayeesLOVByClassCdItemNo".equals(ACTION)) {
				params.put("claimId", request.getParameter("claimID"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
			}else if ("getColorLOV".equals(ACTION)) {
				params.put("basicColorCd", request.getParameter("basicColorCd"));
			}else if ("getGICLS275CompanyLov".equals(ACTION)) {
			//	params.put("carCompany", request.getParameter("carCompany"));
				params.put("carMake", request.getParameter("carMake")); // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
				params.put("carPart", request.getParameter("carPart")); 
				params.put("modelYear", request.getParameter("modelYear")); // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if ("getGICLS275MakeLov".equals(ACTION)) {
				params.put("carCompany", request.getParameter("carCompany"));
				params.put("carPart", request.getParameter("carPart")); // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - Start
				params.put("modelYear", request.getParameter("modelYear")); // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters. - End			
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if ("getGICLS275YearLov".equals(ACTION)) {
				params.put("make", request.getParameter("make"));
				params.put("carCompany", request.getParameter("carCompany"));
				params.put("carPart", request.getParameter("carPart")); // Dren 10.12.2015 SR-SIT : 0004920 - Additional LOV parameters.
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if ("getGICLS275PartsLov".equals(ACTION)) {
				params.put("modelYear", request.getParameter("modelYear"));
				params.put("make", request.getParameter("make"));
				params.put("carCompany", request.getParameter("carCompany"));
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}	
			}else if("getClmItemLOV".equals(ACTION)){
				params.put("ACTION", request.getParameter("action2"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
				params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemFrom", request.getParameter("itemFrom"));
				params.put("itemTo", request.getParameter("itemTo"));
				params.put("itemSortColumn", "".equals(request.getParameter("itemSortColumn")) || request.getParameter("itemSortColumn") == null ? null :request.getParameter("itemSortColumn"));
				params.put("itemAscDescFlg", request.getParameter("itemAscDescFlg"));
				params.put("issCd", request.getParameter("issCd"));
			}else if ("getClmAccidentGrpItemLOV".equals(ACTION)){ 
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
				params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("itemFrom", request.getParameter("itemFrom"));
				params.put("itemTo", request.getParameter("itemTo"));
				params.put("itemSortColumn", "".equals(request.getParameter("itemSortColumn")) || request.getParameter("itemSortColumn") == null ? null :request.getParameter("itemSortColumn"));
				params.put("itemAscDescFlg", request.getParameter("itemAscDescFlg"));
			}else if ("getMotorTypeLOV".equals(ACTION)) {
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if("getLossCatDtl2".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd", request.getParameter("perilCd"));
			}else if("getClmItemPerilList".equals(ACTION) || "getPAClmItemPerilList".equals(ACTION)|| "getMcClmItemPerilList".equals(ACTION)){ 
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
				params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("lossCatCd", request.getParameter("lossCatCd"));
				params.put("lossCatDes", request.getParameter("lossCatDes"));
				params.put("catPerilCd", request.getParameter("catPerilCd"));
			}else if("getPackPoliciesLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getPolicyNoLOVGICLS010".equals(ACTION)){
				params.put("param1", request.getParameter("param1"));
				params.put("param2", request.getParameter("param2"));
			}else if("getLossCatDtlLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiclCatDtlLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getUserListLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("polIssCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
			}else if("getClmUserLOV".equals(ACTION)){ //JEFF013013
				params.put("userId", USER.getUserId());
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getClmAssuredDtlLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getDistrictDtlLOV".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
			}else if("getBlockDtlLOV".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
				params.put("districtNo", request.getParameter("districtNo"));
			}else if("getCityDtlLOV".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
			}else if("getClmStatLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getTpClaimantLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("signatory", request.getParameter("signatory"));
			}else if("getPayeesByAdjusterLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getPayeesByAdjLOV".equals(ACTION)){		//added by Gzelle 02.20.2013
				params.put("desc", request.getParameter("desc"));
			}else if("getPayeesByAdjuster2LOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
			}else if("getPlateDtlLOV".equals(ACTION) 
					|| "getMotorDtlLOV".equals(ACTION)
					|| "getSerialDtlLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getGiisPayeeList".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
			}else if("getGiisPayeeListForGICLS259".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("searchString",request.getParameter("searchString"));
			}else if("getGIISPayeeClassLOV2".equals(ACTION)){
			}else if("getClmLineLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCdIn", request.getParameter("lineCdId"));
				if(request.getParameter("searchString") != "") {
					params.put("searchString", request.getParameter("searchString"));
				}/* else {
					params.put("searchString", "%");
				}*/
			} else if("getClmLineLOV2".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				if(request.getParameter("searchString") != "") {
					params.put("searchString", request.getParameter("searchString"));
			}
			}else if("getClmSublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getClmIssLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				if(request.getParameter("searchString") != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getClmIssLOV2".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				if(request.getParameter("searchString") != "") {
					params.put("searchString", request.getParameter("searchString"));
				}
			}else if("getClmIssueYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getClmPackLineLOV".equals(ACTION)){
				if(request.getParameter("searchLineCd").trim() != "") {
					params.put("searchLineCd", request.getParameter("searchLineCd"));
				} else {
					params.put("searchLineCd", "%");
				}
			}else if("getClmPackSublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				if(request.getParameter("searchSublineCd").trim() != "") {
					params.put("searchSublineCd", request.getParameter("searchSublineCd"));
				} else {
					params.put("searchSublineCd", "%");
				}
			}else if("getClmPackIssLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				if(request.getParameter("searchPolIssCd").trim() != "") {
					params.put("searchPolIssCd", request.getParameter("searchPolIssCd"));
				} else {
					params.put("searchPolIssCd", "%");
				}
			}else if("getClmPackIssueYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd").trim());
			}else if("getClmListPerPackagePolicyLov".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getMotCarItemLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getNonMotCarItemLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getPolbasicLineLOV".equals(ACTION)){	// parameters added by shan 10.14.2013
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
			}else if("getPolbasicSublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getPolbasicIssLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if("getPolbasicIssueYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
			}else if("getPolbasicPolSeqNoLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
			}else if("getPolbasicRenewNoLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
			}else if("getAssdNoLOV".equals(ACTION)){
				params.put("findText", request.getParameter("findText"));				
			}else if("getNoClmMultiYyPlateNoLOV".equals(ACTION)){
				params.put("assdNo",request.getParameter("assdNo"));
			}else if("getRecoveryAcctLOV".equals(ACTION)) {
				String claimId = request.getParameter("claimId");
				String recAcctId = request.getParameter("recoveryAcctId").equals("") || request.getParameter("recoveryAcctId").equals("null") ? 
						null : request.getParameter("recoveryAcctId");
				params.put("claimId", claimId.equals("")||claimId.equals("null") ? null : claimId);
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("recoveryAcctId", recAcctId);
			}else if ("getMcEvaluationIssSourceLOV".equals(ACTION)) {
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if("getMcEvaluationClmYyLOV".equals(ACTION)){
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
			}else if ("getMcEvaluationClmSeqNoLOV".equals(ACTION)) {
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("clmYy", request.getParameter("clmYy"));
			}else if("getMcEvalAdjusterListing".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if("getGiclLeStatList".equals(ACTION)){
				
			}else if("getGiisLossExpList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
			}else if("getGiisLossExpForDedList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
				params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
			}else if("getDeductibleLossExpList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
			}else if("getDeductibleLossExpList2".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
			}else if("getGiisLossTaxesLOV".equals(ACTION)){
				params.put("taxType", request.getParameter("taxType"));
				params.put("issCd", request.getParameter("issCd"));
			}else if("getSlListForTaxTypeW".equals(ACTION)){
				params.put("taxCd", request.getParameter("taxCd"));
			}else if("getSlListForTaxTypeI".equals(ACTION)){
				params.put("taxCd", request.getParameter("taxCd"));
			}else if("getSlListForTaxTypeO".equals(ACTION)){
				params.put("taxCd", request.getParameter("taxCd"));
			}else if("getLossDtlRgN".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("taxCd", request.getParameter("taxCd"));
				params.put("taxType", request.getParameter("taxType"));
			}else if("getLossDtlRgY".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("taxCd", request.getParameter("taxCd"));
				params.put("taxType", request.getParameter("taxType"));
			}else if("getLossDtlWonRg".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("taxCd", request.getParameter("taxCd"));
				params.put("taxType", request.getParameter("taxType"));
			}else if ("getClmBenNoLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("lossDate", request.getParameter("lossDate"));
			}else if("getCopyReportLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if ("getClmAvailPerilLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
			}else if("getAdviceNoLov".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if("getForAdditionalReportList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("plateNo", request.getParameter("plateNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd").equals("null")?null:request.getParameter("payeeClassCd"));
				params.put("payeeNo", request.getParameter("payeeNo").equals("null")?null:request.getParameter("payeeNo"));
				params.put("tpSw", request.getParameter("tpSw"));
				params.put("evalStatCd", request.getParameter("evalStatCd"));
				params.put("itemNo", request.getParameter("itemNo"));
			}else if("getLossExpPayeesList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeType", request.getParameter("payeeType"));
			}else if("getAllLossExpPayeesList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeType", request.getParameter("payeeType"));
			}else if("getLossExpPayeeMortgList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeType", request.getParameter("payeeType"));
			}else if("getLossExpPayeeAdjList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeType", request.getParameter("payeeType"));
			}else if("getAllLossExpPayeeAdjList".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeType", request.getParameter("payeeType"));
			}else if("getClmPersonnelLOV".equals(ACTION)){
		    	DateFormat dateFormat = new SimpleDateFormat("MM-dd-yyyy");
				params.put("claimId",request.getParameter("claimId"));
				params.put("itemNo",request.getParameter("itemNo"));
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("sublineCd",request.getParameter("sublineCd"));
				params.put("polIssCd",request.getParameter("polIssCd"));
				params.put("issueYy",request.getParameter("issueYy"));
				params.put("polSeqNo",request.getParameter("polSeqNo"));
				params.put("renewNo",request.getParameter("renewNo"));
				params.put("expiryDate",dateFormat.parse(request.getParameter("expiryDate")));
				params.put("lossDate",dateFormat.parse((request.getParameter("lossDate"))));
				params.put("personnelNo",request.getParameter("personnelNo"));
			}else if("getReplacePartsListLOV".equals(ACTION)){
				params.put("evalId", request.getParameter("evalId"));
				params.put("partType", request.getParameter("partType"));
			}else if ("getMcEvalCompanyTypeListLOV".equals(ACTION)) {
				
			}else if ("getCompanyListLOV".equals(ACTION)) {
				params.put("claimId", request.getParameter("claimId"));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
			}else if ("getPrevPartListLOV".equals(ACTION)) {
				params.putAll(FormInputUtil.getFormInputs(request));
			}else if("getGiisRecoveryTypeLOV".equals(ACTION)){
				String searchString = request.getParameter("searchString") == null ? "" : request.getParameter("searchString").trim();
				if(searchString != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getGiclClmItemCurrencyLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if ("getMultiplePartsLOV".equals(ACTION)) {
				params.putAll(FormInputUtil.getFormInputs(request));
			}else if("getRecoverableDetailsLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("recoveryId", request.getParameter("recoveryId"));
			}else if ("getMortgageeListLOV".equals(ACTION)) {
				params.putAll(FormInputUtil.getFormInputs(request));
			}else if("getGiisPayeeClassLOV".equals(ACTION)){
				// payeeClassCdIn - filter for valid payeeClassCd per module
				params.put("payeeClassCdIn", request.getParameter("payeeClassCdIn"));
			}else if("getGIISPayeeClassLOV3".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getLeEvalReportLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if("getGiisPayeesLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("itemFrom", request.getParameter("itemFrom"));
				params.put("itemTo", request.getParameter("itemTo"));
				params.put("itemSortColumn", "".equals(request.getParameter("itemSortColumn")) || request.getParameter("itemSortColumn") == null ? null :request.getParameter("itemSortColumn"));
				params.put("itemAscDescFlg", request.getParameter("itemAscDescFlg"));
				if ("{}".equals(request.getParameter("itemFilter"))){
					params.put("itemFilter", null);
				}else{
					params.put("itemFilter", request.getParameter("itemFilter"));
					params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("itemFilter"))));
				}
			}else if("getMCEvalDeductibleListing".equals(ACTION)){
				DateFormat dateFormat = new SimpleDateFormat("MM-dd-yyyy");
				params.put("claimId",request.getParameter("claimId"));
				params.put("itemNo",request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("sublineCd",request.getParameter("sublineCd"));
				params.put("polIssCd",request.getParameter("polIssCd"));
				params.put("issueYy",request.getParameter("issueYy"));
				params.put("polSeqNo",request.getParameter("polSeqNo"));
				params.put("renewNo",request.getParameter("renewNo"));
				params.put("lossDate",dateFormat.parse((request.getParameter("lossDate"))));
			}else if("getMcEvalDeductibleCompanyList".equals(ACTION)){
				params.put("evalId", request.getParameter("evalId"));
			}else if ("getVehiclePartsListLOV".equals(ACTION)) {
				params.put("evalId", request.getParameter("evalId"));
			}else if("getRecoveryStatusLOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if ("getRepairTypeLOV".equals(ACTION)) {
				params.put("evalId", request.getParameter("evalId"));
			}else if ("getDepCompanyLOV".equals(ACTION)) {
				params.put("evalId", request.getParameter("evalId"));
			}else if ("getDepCompanyTypeLOV".equals(ACTION)) {
				params.put("evalId", request.getParameter("evalId"));
			}else if ("getEvalVatComLOV".equals(ACTION)) {
				params.put("evalId", request.getParameter("evalId"));
			}else if ("getEvalVatPartLaborLOV".equals(ACTION)) {
				params.put("evalId", request.getParameter("evalId"));
				params.put("payeeCd", request.getParameter("payeeCd"));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
			}else if("getEvalPerilLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
			}else if("getGroupLOV".equals(ACTION)){
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("sublineCd",request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("polEffDate", request.getParameter("polEffDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("lossDate", request.getParameter("lossDate"));
				params.put("itemNo", request.getParameter("itemNo"));	
				System.out.println(":::::::::::::::::::::::::::::::"+request.getParameter("polEffDate")+"````````"+request.getParameter("expiryDate")+"````````"+request.getParameter("lossDate"));
			}else if("getGIISCaLocationTG".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
			}else if("getEvalItemLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if ("getMcEvalPlateNoLOV".equals(ACTION)) {
				params.put("claimId", request.getParameter("claimId"));	
				params.put("itemNo", request.getParameter("itemNo"));	
			}else if("getEngineSeriesAdverseLOV".equals(ACTION)){
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
				params.put("makeCd", request.getParameter("makeCd"));
			}else if("getBookingDateLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));	
			}else if("getGICLS024BookingDateLOV".equals(ACTION)){
				params.put("claimId", request.getParameter("claimId"));
			}else if("getClaimListLOV".equals(ACTION)){ //added by cherrie 12.19.2012 - modified by adpascual 05.17.2013
				params.put("lineCode", request.getParameter("lineCode"));
				params.put("sublineCode", request.getParameter("sublineCode"));
				params.put("clmLineCode", request.getParameter("clmLineCode"));
				params.put("clmSublineCode", request.getParameter("clmSublineCode"));
				params.put("issCode", request.getParameter("issCode"));
				params.put("polIssCode", request.getParameter("polIssCode"));
				params.put("clmYr", request.getParameter("clmYr"));
				params.put("issueYr", request.getParameter("issueYr"));
				params.put("clmSeqNum", request.getParameter("clmSeqNum"));
				params.put("polSeqNum", request.getParameter("polSeqNum"));
				params.put("renewNum", request.getParameter("renewNum"));
			}else if("getGICLS251Lov".equals(ACTION)) {
				params.put("controlModule", "GICLS251");
				params.put("userId", USER.getUserId());	
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			} else if("getGICLS263MakeLov".equals(ACTION)){
				params.put("userId", USER.getUserId());
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}			
			} else if("getGICLS266IntermediaryLov".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString")); 
			} else if ("getClaimCedantLOV".equals(ACTION)){
				params.put("riCd", request.getParameter("riCd"));
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
			}else if("getPlateNoGICLS268LOV".equals(ACTION)){
				if(request.getParameter("searchString").trim() != "") {
					params.put("searchString", request.getParameter("searchString"));
				} else {
					params.put("searchString", "%");
				}
				
			}else if ("getAllLineLOV".equals(ACTION)){	//added by shan 03.14.2013 for GICLS201 - Claims Recovery Register
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getIssSourceGicls201LOV".equals(ACTION)){	//added by shan 03.15.2013 for GICLS201 - Claims Recovery Register
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getLineCdGicls202LOV".equals(ACTION)){ // GICLS202 LOV start :: bonok :: 04.11.2013
				params.put("issCd", request.getParameter("issCd"));
				params.put("issCd2", request.getParameter("issCd2"));
			}else if("getSublineCd2Gicls202LOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("lineCd2", request.getParameter("lineCd2"));
				params.put("perPolicy", Integer.parseInt(request.getParameter("perPolicy")));
			}else if("getSublineCd2Gicls202LOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("lineCd2", request.getParameter("lineCd2"));
				params.put("perPolicy", Integer.parseInt(request.getParameter("perPolicy")));
			}else if("getIssCd2Gicls202LOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("lineCd2", request.getParameter("lineCd2"));
			}else if("getPerilCdGicls202LOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getLossCatCdGicls202LOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getIntmNoGicls202LOV".equals(ACTION)){
				// No specific parameter for this lov
			}else if("getControlTypeCdGicls202LOV".equals(ACTION)){
				// No specific parameter for this lov
			}   // GICLS202 LOV end :: bonok :: 04.11.2013
			else if("getuserLOVGICLS044".equals(ACTION)){			// Kenneth L : 05.22.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				// GICLS202 LOV end :: bonok :: 04.11.2013
			}else if("getMotshopLOV".equals(ACTION)){
				if(!request.getParameter("payeeName").equals("null")){
					params.put("payeeName", request.getParameter("payeeName"));
				}
			}else if("getLossCatCdDtlLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("filterDesc", request.getParameter("filterDesc"));
			}else if("getGICLS150MasterPayeeLov".equals(ACTION)){ //GICLS150 LOV start :: added by fons 04.30.2013
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));	
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGICLS150BankLov".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));				
			}else if("getBankAcctTypeLOV".equals(ACTION)){
				params.put("domain", "GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE");
				params.put("searchString", request.getParameter("searchString"));		
				// GICLS150 LOV end :: fons :: 04.30.2013
			}else if("getClmVesselLOV".equals(ACTION)){
				System.out.println();
				//String ss = (request.getParameter("searchString")!=null ? request.getParameter("searchString") : "");
				//System.out.println("SEARCH STRING =>" + ss + "<=");
				params.put("search", request.getParameter("search"));
			}else if("getClmLineCdLOV".equals(ACTION)){ //added by adpascual 5/29/2013
				params.put("issCd", request.getParameter("issCd"));
				params.put("ACTION", "getAllLineLOV");
			}else if("getClmSublineCdLOV".equals(ACTION)){ //added by adpascual 5/29/2013
				//params.put("searchString", (request.getParameter("searchString").equals("null") ? "" : request.getParameter("searchString"))); //changed by the codes below by robert 10.02.2013
				params.put("searchString", (request.getParameter("searchString")!=null ? request.getParameter("searchString") : "")); 
			}else if("getSublineCdLOVGICLS254".equals(ACTION)){ //GICLS254 LOV added by adpascual 5/29/2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("ACTION", "getSublineByLineCdLOV");
			}else if("getClmIssCdNameLOV".equals(ACTION)){ //added by adpascual 5/29/2013
				//params.put("searchString", (request.getParameter("searchString").equals("null") ? "" : request.getParameter("searchString"))); //changed by the codes below by robert 10.02.2013
				params.put("searchString", (request.getParameter("searchString")!=null ? request.getParameter("searchString") : "")); 
			}else if("getIssCdNameLOVGICLS254".equals(ACTION)){ //GICLS254 LOV added by adpascual 5/29/2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("ACTION", "getIssCdNameLOV");
				//params.put("searchString", (request.getParameter("searchString").equals("null") ? "" : request.getParameter("searchString"))); //changed by the codes below by robert 10.02.2013
				params.put("searchString", (request.getParameter("searchString")!=null ? request.getParameter("searchString") : "")); 
			}else if("getClaimsBillPayeeNamesLOV".equals(ACTION)){ //GICLS272 editted by john dolon 6.27.2013
				params.put("ACTION", "getClaimsBillPayeeNamesLOV");
				params.put("payeeClassNo", request.getParameter("payeeClassNo"));
				params.put("docNumber", request.getParameter("docNumber"));
				params.put("payeeNo", request.getParameter("payeeNo"));
				params.put("payeeName", request.getParameter("payeeName"));
			}else if("getClaimsBillPayeeClassLOV".equals(ACTION)){ //GICLS272 added by john dolon 7.1.2013
				params.put("ACTION", "getClaimsBillPayeeClassLOV");
				params.put("payeeNo", request.getParameter("payeeNo"));
				params.put("docNumber", request.getParameter("docNumber"));
				params.put("payeeClassNo", request.getParameter("payeeClassNo"));
				params.put("payeeClass", request.getParameter("payeeClass"));
			}else if("getClaimsBillDocNumberLOV".equals(ACTION)){ //GICLS272 added by john dolon 7.2.2013
				params.put("ACTION", "getClaimsBillDocNumberLOV");
				params.put("payeeNo", request.getParameter("payeeNo"));
				params.put("payeeClassNo", request.getParameter("payeeClassNo"));
				params.put("docTypeNo", request.getParameter("docTypeNo"));
				params.put("docType", request.getParameter("docType"));
				params.put("docNumber", request.getParameter("docNumber"));
				params.put("billAmt", request.getParameter("billAmt"));
				params.put("billDate", request.getParameter("billDate"));
			}else if("getClmPolLOV".equals(ACTION)){ //added by aliza garza 06.04.2013
				params.put("moduleId", request.getParameter("moduleId"));				
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("clmLineCd", request.getParameter("clmLineCd"));
				params.put("clmSublineCd", request.getParameter("clmSublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("clmYy", request.getParameter("clmYy"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("clmSeqNo", request.getParameter("clmSeqNo").equals("")? null: Integer.parseInt(request.getParameter("clmSeqNo")));
				params.put("polSeqNo", request.getParameter("polSeqNo").equals("")? null: Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("claimId", request.getParameter("claimId").equals("")? null: Integer.parseInt(request.getParameter("claimId")));
				params.put("filter", "".equals(request.getParameter("filter")) || request.getParameter("filter") == null ? null :request.getParameter("filter"));
				System.out.println("params: " + params.values());			
			} else if("getClaimLineLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());			
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getClaimSublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("subLineCd", request.getParameter("subLineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());				
				params.put("findText", request.getParameter("findText"));				
			}else if("getClaimIssLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
			}else if("getLawyerLOV".equals(ACTION)){
				params.put("lawyerName", request.getParameter("lawyerName"));
				System.out.println("params: " + params.values());
			}else if("getPayeesByClassLOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeNo", request.getParameter("payeeNo"));
				params.put("filterDesc", request.getParameter("filterDesc"));
			}else if("getPolicyLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("subLineCd", request.getParameter("subLineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getGICLS220LineLOV".equals(ACTION)){ // Joms 07.19.2013
				params.put("branchCd", request.getParameter("branchCd"));
			}else if("getGICLS220SublineLOV".equals(ACTION)){ // Joms 07.19.2013
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGICLS220BranchLOV".equals(ACTION)){ // Joms 07.19.2013
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGicls204LineLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGicls204SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGicls204IssLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGicls204IntmLOV".equals(ACTION)){
				
			}else if("getGicls204AssdLOV".equals(ACTION)){
				
			}else if("getGicls204PerilLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGicls051CdLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getOutstLOASublineLOV".equals(ACTION)){	//added by Gzelle 07.31.2013
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));				
			}else if ("getOutstLOABranchLOV".equals(ACTION)) {	//added by Gzelle 07.31.2013
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmBranchLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmPolIssCdLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("polSublineCd", request.getParameter("polSublineCd"));
				params.put("polLineCd", request.getParameter("polLineCd"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmLineLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmPolLineLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("polSublineCd", request.getParameter("polSublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmPolSublineLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("polLineCd", request.getParameter("polLineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmAssuredLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmIntmLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("search", request.getParameter("search"));
			}else if ("getReportedClmStatLOV".equals(ACTION)) {	//added by Gzelle 08.05.2013
				params.put("search", request.getParameter("search"));
			}else if("getGICLS278PolicyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getGICLS278LineLOV".equals(ACTION)){
				//no specific parameter
			}else if("getGICLS278SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGICLS278IssourceLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if("getGICLS278IssueYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if ("getClmStatReasonsLOV".equals(ACTION)) {	//added by Fons 08.27.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGicls057CatastrophicLOV".equals(ACTION)) {
				//no specific parameter
			}else if ("getGicls057LineLOV".equals(ACTION)) {
				//no specific parameter
			}else if ("getGicls057BranchLOV".equals(ACTION)) {
				//no specific parameter
			}else if ("getGicls057LossCatLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGicls057ProvinceLOV".equals(ACTION)) {
				//no specific parameter
			}else if ("getGicls057CityLOV".equals(ACTION)) {
				params.put("provinceCd", request.getParameter("provinceCd"));
			}else if ("getGicls057DistrictLOV".equals(ACTION)) {
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
			}else if ("getGicls057BlockLOV".equals(ACTION)) {
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
				params.put("districtCd", request.getParameter("districtCd"));
			}else if("getGicls211SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiclCatDtlLOV2".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getAllIssSourceLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getLocationLOV".equals(ACTION)){
				if(request.getParameter("searchString") != null && !request.getParameter("searchString").equals("")){
					params.put("searchString", request.getParameter("searchString"));
				}
			} else if("getLossCatLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGicls200RiLov".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGICLS254LineLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGICLS254SublineLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getGICLS254IssLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGICLS253MotorshopLOV".equals(ACTION)){
				if(!request.getParameter("payeeName").equals("null")){
					params.put("payeeName", request.getParameter("payeeName"));
				}
			}else if("getGicls105PerilLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGicls210PayeeNoLOV".equals(ACTION)){
				params.put("filterText", request.getParameter("filterText"));
			}else if("getGICLS180ReportLOV".equals(ACTION)){
				
			}else if("getGICLS180LineLOV".equals(ACTION)){
				
			}else if("getGICLS180DocumentLOV".equals(ACTION)){
				
			}else if("getGICLS180BranchLOV".equals(ACTION)){
				
			}else if ("getGicls058CarCompanyLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			}else if ("getGicls058MakeLOV".equals(ACTION)) {
				params.put("carCompanyCd", request.getParameter("carCompanyCd").equals("")?null:Integer.parseInt(request.getParameter("carCompanyCd")));
				params.put("search", request.getParameter("search"));
			}else if ("getGicls058ModelYearLOV".equals(ACTION)) {
				params.put("carCompanyCd", request.getParameter("carCompanyCd").equals("")?null:Integer.parseInt(request.getParameter("carCompanyCd")));
				params.put("makeCd", request.getParameter("makeCd").equals("")?null:Integer.parseInt(request.getParameter("makeCd")));
				params.put("search", request.getParameter("search"));
			}else if("getGicls056LossCatLov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGicls056ProvinceLov".equals(ACTION)){
				
			}else if("getGicls056CityLov".equals(ACTION)) {
				params.put("provinceCd", request.getParameter("provinceCd"));
			}else if("getGicls056DistrictLov".equals(ACTION)) {
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
			}else if("getGicls056BlockLov".equals(ACTION)) {
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
				params.put("districtNo", request.getParameter("districtNo"));
			}else if("getGicls181ReportLOV".equals(ACTION)){
				
			}else if("getGicls181SignatoryLOV".equals(ACTION)){
				
			} else if("getGicls104LineLOV".equals(ACTION)){
				if(!request.getParameter("filterText").equals("")){
					params.put("filterText", request.getParameter("filterText"));
				}
			} else if("getGicls104PerilLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").equals("")){
					params.put("findText", request.getParameter("filterText"));
				}
			} else if ("getGicls106TaxTypeLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			} else if ("getGicls106BranchLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			} else if ("getGicls106LineLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getGicls106LossExpLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("search", request.getParameter("search"));
			}else if("getGICLS182UserLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGICLS182IssLOV".equals(ACTION)){
				params.put("selectedUser", request.getParameter("userId"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGicls110LineLOV".equals(ACTION)){
				
			}else if("getGicls110SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGicls200LineLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("appUser", USER.getUserId());
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").equals("")){
					params.put("filterText", request.getParameter("filterText"));
				}
			} else if("getGicls200IssSourceLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("appUser", USER.getUserId());
				if(request.getParameter("filterText") != null && !request.getParameter("filterText").equals("")){
					params.put("filterText", request.getParameter("filterText"));
				}
			} else if("getEnrolleeGicls202LOV".equals(ACTION)){

			} else if ("getGicls056LineLOV".equals(ACTION)) {
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
					params.put("findText", request.getParameter("filterText"));
				}
			} else if ("getGicls039AssuredLOV".equals(ACTION)) {
				//params.put("findText", StringFormatter.unescapeBackslash3((StringFormatter.unescapeHTML2(request.getParameter("filterText").replace("'", "''").replace("&#124;", "|"))))); //--commented out edited by MarkS SR22736 7.26.2016
				
			}			
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params));
			message = json.toString();
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){  
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally {
			JSONObject json = new JSONObject(params);
			message = json.toString();					
			PAGE = "/pages/genericMessage.jsp";
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
