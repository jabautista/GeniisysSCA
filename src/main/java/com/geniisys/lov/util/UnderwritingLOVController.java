package com.geniisys.lov.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.seer.framework.util.StringFormatter;

public class UnderwritingLOVController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -550839047683746398L;
	private static Logger log = Logger
			.getLogger(UnderwritingLOVController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		// common parameters
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("currentPage",
				Integer.parseInt(request.getParameter("page")));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("findText", request.getParameter("findText"));
		if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
			params.put("findText", request.getParameter("filterText"));
		}
		if (request.getParameter("notIn") != null
				&& !request.getParameter("notIn").equals("")) {
			params.put("notIn", request.getParameter("notIn"));
		}
		params.put("filter", "".equals(request.getParameter("objFilter"))
				|| "{}".equals(request.getParameter("objFilter")) ? null
				: request.getParameter("objFilter"));
		params.put("ACTION", ACTION);
		try {
			// IMPORTANT: use the specified action for controller as the id for
			// sqlMap select/procedure
			// NOTE: format for lov action is : "get<Entity Name>LOV"

			// parameters per action

			if("showGIUTS029PolicyLOV".equals(ACTION)) { 
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
			} else if ("getGIISProvinceLOV".equals(ACTION)) {
				params.put("regionCd", request.getParameter("regionCd"));
			} else if ("getGIISCityLOV".endsWith(ACTION)) {
				params.put("regionCd", request.getParameter("regionCd"));
				params.put("provinceCd", request.getParameter("provinceCd"));
			} else if ("getGIISRiskLOV".equals(ACTION)) {
				params.put("blockId", request.getParameter("blockId"));
			} else if ("getGIISReinsurerLOV".equals(ACTION)) {
				params.put("riName", request.getParameter("riName"));
			} else if ("getGIISPerilLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put(
						"perilType",
						(request.getParameter("perilType").equals("")
								|| request.getParameter("perilType").equals(
										"null") ? null : request
								.getParameter("perilType")));
				params.put("notIn",
						(request.getParameter("notIn").equals("") ? null
								: request.getParameter("notIn")));
				log.info(params);
			} else if ("getEQZoneLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getTyphoonZoneLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getFloodZoneLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getGIPIQuoteLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getPolicyNoLOV".equals(ACTION)
					|| "getPackPolicyNoLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put(
						"issueYy",
						"".equals(request.getParameter("issueYy")) ? null
								: Integer.parseInt(request
										.getParameter("issueYy")));
				params.put(
						"polSeqNo",
						"".equals(request.getParameter("polSeqNo")) ? null
								: Integer.parseInt(request
										.getParameter("polSeqNo")));
				params.put(
						"renewNo",
						"".equals(request.getParameter("renewNo")) ? null
								: Integer.parseInt(request
										.getParameter("renewNo")));
			} else if ("getGIISDeductibleLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("notIn",
						(request.getParameter("notIn").equals("") ? null
								: request.getParameter("notIn")));
			} else if ("getQuoteDeductibleLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("notIn", (request.getParameter("notIn").equals("") ? null : request.getParameter("notIn")));
			} else if ("getBasicColorLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBasicColorListLOV".equals(ACTION)) { // added by:
																// Gzelle
																// 02.15.2013
																// LOV with
																// search
				params.put("basicColor", request.getParameter("basicColor"));
			} else if ("getColorLOV".equals(ACTION)) {
				params.put("basicColorCd", request.getParameter("basicColorCd"));
			} else if ("getColorListLOV".equals(ACTION)) { // added by: Gzelle
															// 02.15.2013 LOV
															// with search
				params.put("basicColorCd", request.getParameter("basicColorCd"));
				params.put("color", request.getParameter("color"));
			} else if ("getGIRIDistFrpsLOV".equals(ACTION)) {
				params.put("moduleId", request.getParameter("moduleId"));
			} else if ("getGIRIDistFrpsLOV2".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
			} else if ("getGIRIDistFrpsLOV3".equals(ACTION)) { // added by: Nica
																// 12.10.2012
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("frpsNo", request.getParameter("frpsNo"));
				params.put("policyNo", request.getParameter("policyNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("endtNo", request.getParameter("endtNo"));
			} else if ("getGIPIPackQuoteLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				System.out.println(request.getParameter("lineCd"));
				System.out.println(request.getParameter("issCd"));
			} else if ("getGIISEventLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getCgRefCodeLOV".equals(ACTION)) {
				params.put("domain", request.getParameter("domain"));
			} else if ("getCgRefCodeLOV4".equals(ACTION)) {
				params.put("domain", request.getParameter("domain"));				
			} else if ("getMortgageeLOV".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getGIISPerilByItemLOV".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("perilType", (request.getParameter("perilType")
						.equals("") ? null : request.getParameter("perilType")));
			} else if ("getPerilTariffLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd",
						Integer.parseInt(request.getParameter("perilCd")));
			} else if ("getGIISDistrictBlockLOV".equals(ACTION)) {
				params.put("regionCd", request.getParameter("regionCd"));
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
				params.put("districtNo", request.getParameter("districtNo"));
			} else if ("getCarCompanyLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getMakeLOV".equals(ACTION)) {
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
			} else if ("getEngineSeriesLOV".equals(ACTION)) {
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
				params.put("makeCd", request.getParameter("makeCd"));
			} else if ("getLineCdFlagLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
			} else if ("getSublineCdNameLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getIssCdNameLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
			} else if ("getIntmCdNameLOV".equals(ACTION)) {
				params.put("keyword", request.getParameter("keyword"));
			} else if ("getAccessoryLOV".equals(ACTION)) {
				params.put("notIn",
						(request.getParameter("notIn").equals("") ? null
								: request.getParameter("notIn")));
			} else if ("getCargoClassLOV".equals(ACTION)) {
				params.put("filterDesc", request.getParameter("filterDesc"));
				params.put("cargosIn", request.getParameter("cargosIn"));
			} else if ("getCargoClassLOV2".equals(ACTION)) {
				params.put("notIn", request.getParameter("notIn"));
			} else if("getCargoTypeLOV".equals(ACTION)){
				params.put("cargoClassCd", request.getParameter("cargoClassCd").equals("") ? null : Integer.parseInt(request.getParameter("cargoClassCd")));
				params.put("filterText", request.getParameter("filterText")); //pol cruz, for filtering
				//if(!request.getParameter("filterDesc").equals(null)){		//commented out by shan 06.11.2013 for SR-13402
					//params.put("filterDesc", request.getParameter("filterDesc"));
				//}
			} else if("getVesselLOV".equals(ACTION)){
				params.put("parId", request.getParameter("parId"));
			} else if ("getIssueYyLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
			}else if("getPolbasicIssueYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getSublineByLineCdLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getPolSeqNoLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
			}else if("getPolbasicPolSeqNoLOV".equals(ACTION)){ //include cancelled / spoiled policies
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
			} else if ("getRenewNoLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
			}else if("getPolbasicRenewNoLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
			} else if ("getValidPlateNosLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if ("getAllLineLOV".equals(ACTION)) {
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
			} else if ("getAllNonPackLineLOV".equals(ACTION)) {
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getBeneficiaryPerilLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getGroupedPerilLOV".equals(ACTION)) {
				params.put("parId",
						Integer.parseInt(request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("perilType", request.getParameter("perilType"));
			} else if ("getProvinceDtlLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getGIISWarrClaLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getGIISWarrClaLOV2".equals(ACTION)) { // Gzelle
																// 12.26.2012
																// for new lov
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("wcTitle", request.getParameter("wcTitle"));
				params.put("notIn",
						(request.getParameter("notIn").equals("") ? null
								: request.getParameter("notIn")));
			} else if ("getNonRenewalCdLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getGIISAssuredLOVTG".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getHullVesselLOV".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("itemNo", request.getParameter("itemNo"));
			} else if ("getAviationVesselLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBinderPolicyNoLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId()); //added by steven 09.02.2014
			} else if ("getGIISReinsurerLOV2".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("riCd", request.getParameter("riCd"));
			} else if ("getGIUTS024LOV".equals(ACTION)) {
				//added policy number composition by j.diago 09.17.2014
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("userId", USER.getUserId());
			} else if ("getPackageBinders".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBusConservationLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBusSublineLOV".equals(ACTION)) {
				params.put("mainLineCd", request.getParameter("mainLineCd"));
			} else if ("getBusIssueLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBusCreditLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBusIntmTypeLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBusIntmLOV".equals(ACTION)) {
				params.put("intmMainType", request.getParameter("intmMainType"));
			} else if ("getBusDetailLineLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getBusDetailIssLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getSurveyAgentLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getSettlingAgentLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getDistFrpsWDistFrpsVLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
			} else if ("getGIPIS085IntermediaryLOV".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("parType", request.getParameter("parType"));
				params.put("notIn", request.getParameter("notIn"));
				params.put("defaultIntm", request.getParameter("defaultIntm"));
				params.put("polFlag", request.getParameter("polFlag"));
			} else if ("getDspPerilNameLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getTaxListLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("policyId", request.getParameter("policyId"));
			} else if ("getItemGIEXS007LOV".equals(ACTION)) {
				params.put("policyId", request.getParameter("policyId"));
			} else if ("getItmperilLOV".equals(ACTION)) {
				params.put("policyId", request.getParameter("policyId")); // andrew
																			// -
																			// 1.11.2012
				params.put("itemNo", request.getParameter("itemNo"));
			} else if ("getPrintExpReportLineLOV".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId()); //added by kenneth 05.23.2014
			} else if ("getDeductiblesLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getSublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getPrintExpReportSublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getPrintExpReportIssourceLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId()); //PHILFIRE-SR-15082 additional arg for incomplete LOV Issue Code listing --JC
			} else if ("getPrintExpReportAssuredLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getPrintExpReportIntmLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getReqDocsListingLOV".equals(ACTION)) {
				// agazarraga
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getCarInfoLOV".equals(ACTION)) {
				// agazarraga
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getCedantLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getIntmTypeLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getAllAssdLOV".equals(ACTION)) {
				// No specific parameter for this lov
			} else if ("getDistTreatyLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
			} else if ("getDistShareLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("nbtLineCd", request.getParameter("nbtLineCd"));
			} else if ("getDistTreatyLOV2".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("policyId", request.getParameter("policyId"));
			} else if ("getDistShareLOV2".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("nbtLineCd", request.getParameter("nbtLineCd"));
			} else if ("getBatchDistTreatyLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if ("getBatchDistShareLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getPolicyListForViewPolicyInfo".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("refPolNo", request.getParameter("refPolNo"));
				params.put("nbtLineCd", request.getParameter("nbtLineCd"));
				params.put("nbtIssCd", request.getParameter("nbtIssCd"));
				params.put("parYy", request.getParameter("parYy"));
				params.put("parSeqNo", request.getParameter("parSeqNo"));
				params.put("quoteSeqNo", request.getParameter("quoteSeqNo"));
				System.out
						.println("UnderwritingLOVController-getPolicyListForViewPolicyInfo-params = "
								+ params);
			} else if ("getGiriWinpolbasIssourceList".equals(ACTION)) {
				// GIRIS005A
			} else if ("getInspectorLOV".equals(ACTION)) {
				// gipis197 inspector LOV
			} else if ("getLineCdLOVGiuts036".equals(ACTION)) {
				// giuts036 generate bond sequence no. lineCd LOV
			} else if ("getSublineLOVGiuts036".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getReassignParPolicyLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getReassignParEndtLOV".equals(ACTION)) {// added by
																// steven
																// 03.18.2013
																// for
																// displaying
																// Users
																// (GIPIS057)
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getWOpenPerilLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("perilType", request.getParameter("perilType"));
			} else if ("getParListLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("parYy", request.getParameter("parYy"));
			} else if ("getLineCdLOVGiuts007".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", request.getParameter("userId"));
			} else if ("getMortgageeLOVGipis165".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
				params.put("mortgName", request.getParameter("mortgName"));
				params.put("keyword", request.getParameter("findText"));
			} else if ("getEndtTextLOV".equals(ACTION)) {
				params.put("keyword", request.getParameter("findText"));
			} else if ("getIssCdLOVGiuts007".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", request.getParameter("userId"));
			} else if ("getPolbasicForOpenPolicyLOV".equals(ACTION)) {
				if(request.getParameter("findText") == null){ //June Mark SR5767 [11.14.16]
					params.put("sublineCd", request.getParameter("sublineCd") == "" ? null : request.getParameter("sublineCd"));
					params.put("issCd", request.getParameter("issCd") == "" ? null : request.getParameter("issCd"));
					params.put("issYear", request.getParameter("issYear") == "" ? null : request.getParameter("issYear"));
					params.put("polSeqNo", request.getParameter("polSeqNo") == "" ? null : request.getParameter("polSeqNo"));
					params.put("renewNo", request.getParameter("renewNo") == "" ? null : request.getParameter("renewNo"));
				}//End SR5767
				
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
			} else if ("getApprovedInspectionList".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("assdNo", request.getParameter("assdNo"));
			} else if ("getApprovedInspectionList2".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("assdNo", request.getParameter("assdNo"));
			} else if ("getBillItemLOV".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
			} else if ("getBillItemPerilLOV".equals(ACTION)) {
				params.put("parId", request.getParameter("parId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("itemNo", request.getParameter("itemNo"));
			} else if ("getGIPIS171LOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd")); // gzelle
																			// 12.27.2012
																			// additional
																			// parameters
																			// for
																			// new
																			// lov
																			// version
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));

				params.put("parLineCd", request.getParameter("parLineCd"));
				params.put("parIssCd", request.getParameter("parIssCd"));
				params.put("parYy", request.getParameter("parYy"));
				params.put("parSeqNo", request.getParameter("parSeqNo"));
				params.put("parQuoteSeqNo",
						request.getParameter("parQuoteSeqNo"));
			} else if ("showINPolbasLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if ("getPerilDepNameLOV".equals(ACTION)) { // added by
																// Kenneth L.
																// for peril
																// depreciation
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("perilName", request.getParameter("perilName"));
			} else if ("getGiisPerilCdNameLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getMvPremTypeLOV".equals(ACTION)) { // added by: Nica
															// 10.30.2012 - for
															// COC
															// authentication
				params.put("mvTypeCd", request.getParameter("mvTypeCd"));
			} else if ("getSublineCdLOV".equals(ACTION)) { // added by Kenneth
															// L. for peril
															// maintenance(subline
															// LOV)
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineName", request.getParameter("sublineName"));
			} else if ("getBasicPerilCdLOV".equals(ACTION)) { // added by
																// Kenneth L.
																// for peril
																// maintenance(basic
																// peril LOV)
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilName", request.getParameter("perilName"));
			} else if ("getZoneTypeFiLOV".equals(ACTION)) { // added by Kenneth
															// L. for peril
															// maintenance(zone
															// FI LOV)
				params.put("rvMeaning", request.getParameter("rvMeaning"));
			} else if ("getZoneTypeMcLOV".equals(ACTION)) { // added by Kenneth
															// L. for peril
															// maintenance(zone
															// MC LOV)
				params.put("rvMeaning", request.getParameter("rvMeaning"));
			} else if ("getWarrClaLOV".equals(ACTION)) { // added by Kenneth L.
															// for peril
															// maintenance(warrcla
															// LOV)
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("notIn",
						(request.getParameter("notIn").equals("") ? null
								: request.getParameter("notIn")));
				params.put("mainWcCd", request.getParameter("mainWcCd"));
				params.put("wcTitle", request.getParameter("wcTitle"));
			} else if ("getGiiss207UserLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("search", request.getParameter("search"));
			} else if ("getGiiss207IssueSourceLOV".equals(ACTION)) {
				params.put("userId", request.getParameter("userId"));
				params.put("search", request.getParameter("search"));	
				params.put("maintenanceUser", USER.getUserId());
			} else if ("getGiisPostingLimitLOV".equals(ACTION)) {// added by:
																	// Gzelle
																	// 11.16.2012
																	// - for
																	// posting
																	// limit
																	// line LOV
				params.put("postingUser", request.getParameter("userId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("search", request.getParameter("search"));
				params.put("maintenanceUser", USER.getUserId());
			} else if ("getIssueSourceListingLOV".equals(ACTION)) {// added by:
																	// Gzelle
																	// 11.28.2012
																	// - for
																	// posting
																	// limit
																	// isscd LOV
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", request.getParameter("userId"));	//Gzelle 03212014
				params.put("maintenanceUser", USER.getUserId()); // added by jdiago 05.14.2014
			} else if ("getUserListingLOV".equals(ACTION)) {// added by: Gzelle
															// 12.19.2012 - for
															// posting limit
															// user LOV
				//params.put("userId", request.getParameter("userId")); // removed by jdiago 05.14.2014
				params.put("userIdFrom", request.getParameter("userId")); // added by jdiago 05.14.2014
			} else if ("getPackageBenefitLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getGroupCdLOV".equals(ACTION)) {
				params.put("assdNo",
						Integer.parseInt(request.getParameter("assdNo")));
			} else if ("getControlTypeLOV".equals(ACTION)) {
				// no specific parameters for this LOV
			} else if ("getCoveragePerilLOV".equals(ACTION)) {
				params.put("parId",
						Integer.parseInt(request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("perilType", request.getParameter("perilType"));
			} else if ("getPayTermsLOV".equals(ACTION)) {
				// no specific parameters for this LOV
			} else if ("getGIISGeninInfoLOV".equals(ACTION)) {
				// no specific parameters for this LOV
			} else if ("getGIISGenInitialInfoLOV".equals(ACTION)) {
				// no specific parameters for this LOV
			} else if ("getTariffLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("notIn",
						(request.getParameter("notIn").equals("") ? null
								: request.getParameter("notIn")));
				params.put("tarfCd", request.getParameter("tarfCd"));
				params.put("tarfDesc", request.getParameter("tarfDesc"));
			} else if ("getGIPIPolbasicPolDistV1List2".equals(ACTION)
					|| "getGIUWS012PolicyListing".equals(ACTION)
					|| "getGIUWS013PolicyListing".equals(ACTION)
					|| "getGIPIPolbasicPolDistV1TSIPremGrp".equals(ACTION)
					|| "getV1ListDistByTsiPremPeril".equals(ACTION)
					|| "getGIUTS002PolicyListing".equals(ACTION)
					|| "getGIUTS021PolicyListing".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if("getGIPIS171LOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
			}else if("showINPolbasLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getPerilDepNameLOV".equals(ACTION)){	
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiisPerilCdNameLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getTariffLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("notIn", (request.getParameter("notIn").equals("") ? null : request.getParameter("notIn")));
			} else if("getGeographyLOV".equals(ACTION)){ //added by Kris 01.16.2013 for displaying all geographies (GIPIS173)
				//no specific parameters for this LOV
			}else if("getGIISReinsurerLOV4".equals(ACTION)){	// added by Shan 01.29.2013 for displaying all reinsurers (GIRIS051)
				//no specific parameters for this LOV
			}else if("getGIISReinsurerTypeLOV".equals(ACTION)){	// added by Shan 02.11.2013 for displaying all reinsurer type (GIRIS051)
				// no specific parameters for this LOV
			}else if("getGIRIS051LinePPWLOV".equals(ACTION)) {	// added by Shan 05.15.2013 for displaying Line LOV for Expiry tab of GIRIS051
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
			}else if("getGiuts003aPackPolicyLOV".equals(ACTION)){	//added by Shan 02.25.2013 for displaying Spoil Pack Policy LOV (GIUTS003A)
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if ("getSpoilageReasonGiuts003aLOV".equals(ACTION)) { // added
																			// by
																			// Shan
																			// 02.26.2013
																			// for
																			// displaying
																			// Spoilage
																			// Reason
																			// LOV
																			// (GIUTS003A)
				// no specific parameters for this LOV
			} else if ("getPolicyGiuts003LOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if ("getSpoilCdGiuts003LOV".equals(ACTION)) {
				// no specific parameters for this LOV
			} else if ("getGIUTS023PolicyInformationLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("userId", USER.getUserId());
				System.out
						.println("--getGIUTS023PolicyInformationLOV params--");
				System.out.println(params);
			}else if ("getGIISS062LineLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
			} else if ("getLawyerListLOV".equals(ACTION)) {
				// no specific parameters for this LOV
			} else if ("getDistrictDtlLOV".equals(ACTION)) {
				params.put("block", request.getParameter("block"));
				params.put("searchString", request.getParameter("searchString"));			
			} else if ("getBlockDtlLOV".equals(ACTION)) {
				params.put("districtNo", request.getParameter("districtNo"));
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIUTS028PolicyLOV".equals(ACTION)) { // jomsdiago 07.25.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			} else if ("getGIUTS028APolicyLOV".equals(ACTION)) { // jomsdiago 07.29.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getGiexs008LineLov".equals(ACTION)){	//added by kenneth L. 08.02.2013
				params.put("search", request.getParameter("search"));			
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGiexs008SublineLov".equals(ACTION)){	//added by kenneth L. 08.02.2013
				params.put("search", request.getParameter("search"));			
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiexs008IssLov".equals(ACTION)){	//added by kenneth L. 08.02.2013
				params.put("search", request.getParameter("search"));			
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiexs008IntmLov".equals(ACTION)){	//added by kenneth L. 08.02.2013
				params.put("search", request.getParameter("search"));	
			}else if("getGiexs008UserLov".equals(ACTION)){	//added by kenneth L. 08.02.2013
				params.put("search", request.getParameter("search"));	
			} else if ("getGIUTS031LineLOV".equals(ACTION)) { // jomsdiago 08.08.2013
				params.put("issCd", request.getParameter("issCd"));
			} else if ("getGIUTS031SublineLOV".equals(ACTION)) { // jomsdiago 08.08.2013
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getGIUTS031IssueLOV".equals(ACTION)) { // jomsdiago 08.08.2013
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("showBinderLov".equals(ACTION)) { // J. Diago 08.15.2013
				params.put("userId", USER.getUserId());
			} else if ("getBinderStatusLOV".equals(ACTION)) { // J. Diago 08.15.2013
				// parameters here if any.
			}else if("getSublineForBatchPostingLOV".equals(ACTION)){	//added by Gzelle 08.27.2013
				params.put("search", request.getParameter("search"));
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getIssForBatchPostingLOV".equals(ACTION)){	//added by Gzelle 08.27.2013
				params.put("search", request.getParameter("search"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			}else if("getUserForBatchPostingLOV".equals(ACTION)){	//added by Gzelle 08.27.2013
				params.put("search", request.getParameter("search"));				
			}else if ("getGIISS119LineLov".equals(ACTION)) {//added by Fons 08.13.2013 for displaying Line LOV (GIISS119)
				params.put("searchString", request.getParameter("searchString"));		
			}else if ("getGIISSReportIdLOV".equals(ACTION)) {//added by Fons 08.13.2013 for displaying Line LOV (GIISS119)
				params.put("searchString", request.getParameter("searchString"));	
			} else if("getGipis170UserLov".equals(ACTION)){	//added by kenneth L. 08.23.2013
				params.put("search", request.getParameter("search"));
			} else if("getGipis170AssdLov".equals(ACTION)){	//added by kenneth L. 08.27.2013
				params.put("search", request.getParameter("search"));
			} else if("getGipis170RiLov".equals(ACTION)){	//added by kenneth L. 08.27.2013
				params.put("search", request.getParameter("search"));
			} else if("getGipis170IssLov".equals(ACTION)){	//added by kenneth L. 08.27.2013
				params.put("search", request.getParameter("search"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", "GIPIS170");
				params.put("userId", USER.getUserId());
			} else if("getGipis170LineLov".equals(ACTION)){	//added by kenneth L. 08.27.2013
				params.put("search", request.getParameter("search"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", "GIPIS170");
				params.put("userId", USER.getUserId());
			} else if("getGipis170SublineLov".equals(ACTION)){	//added by kenneth L. 08.27.2013
				params.put("search", request.getParameter("search"));
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiisCoverageLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGiuts027PolicyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", (request.getParameter("issueYy") != null && !request.getParameter("issueYy").equals("")) ? Integer.parseInt(request.getParameter("issueYy")) : null);
				params.put("polSeqNo", (request.getParameter("polSeqNo") != null && !request.getParameter("polSeqNo").equals("")) ? Integer.parseInt(request.getParameter("polSeqNo")) : null);
				params.put("renewNo", (request.getParameter("renewNo") != null && !request.getParameter("renewNo").equals("")) ? Integer.parseInt(request.getParameter("renewNo")) : null);
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", (request.getParameter("endtYy") != null && !request.getParameter("endtYy").equals("")) ? Integer.parseInt(request.getParameter("endtYy")) : null);
				params.put("endtSeqNo", (request.getParameter("endtSeqNo") != null && !request.getParameter("endtSeqNo").equals("")) ? Integer.parseInt(request.getParameter("endtSeqNo")) : null);
				params.put("assdName", request.getParameter("assdName"));
			} else if ("getAlarmUserLOV".equals(ACTION)){
				params.put("alarmUser", request.getParameter("alarmUser"));
			}else if("getUpdateInitEtcPolicyLOV".equals(ACTION)){	//added by Gzelle 09.17.2013
				params.put("userId", USER.getUserId());
				params.put("polLineCd", request.getParameter("polLineCd"));
				params.put("polSublineCd", request.getParameter("polSublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("polIssueYy", (request.getParameter("polIssueYy") != null && !request.getParameter("polIssueYy").equals("")) ? Integer.parseInt(request.getParameter("polIssueYy")) : null);
				params.put("polSeqNo", (request.getParameter("polSeqNo") != null && !request.getParameter("polSeqNo").equals("")) ? Integer.parseInt(request.getParameter("polSeqNo")) : null);
				params.put("polRenewNo", (request.getParameter("polRenewNo") != null && !request.getParameter("polRenewNo").equals("")) ? Integer.parseInt(request.getParameter("polRenewNo")) : null);
				params.put("parLineCd", request.getParameter("parLineCd"));
				params.put("parIssCd", request.getParameter("parIssCd"));
				params.put("parYy", (request.getParameter("parYy") != null && !request.getParameter("parYy").equals("")) ? Integer.parseInt(request.getParameter("parYy")) : null);
				params.put("parSeqNo", (request.getParameter("parSeqNo") != null && !request.getParameter("parSeqNo").equals("")) ? Integer.parseInt(request.getParameter("parSeqNo")) : null);
				params.put("parQuoteSeqNo", (request.getParameter("parQuoteSeqNo") != null && !request.getParameter("parQuoteSeqNo").equals("")) ? Integer.parseInt(request.getParameter("parQuoteSeqNo")) : null);
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", (request.getParameter("endtYy") != null && !request.getParameter("endtYy").equals("")) ? Integer.parseInt(request.getParameter("endtYy")) : null);
				params.put("endtSeqNo", (request.getParameter("endtSeqNo") != null && !request.getParameter("endtSeqNo").equals("")) ? Integer.parseInt(request.getParameter("endtSeqNo")) : null);
				params.put("assdName", request.getParameter("assdName"));
			} else if("getUpdateInitEtcPackPolicyLOV".equals(ACTION)){	// SR-21812 JET JUN-24-2016
				params.put("userId", USER.getUserId());
				params.put("packPolLineCd", request.getParameter("packPolLineCd"));
				params.put("packPolSublineCd", request.getParameter("packPolSublineCd"));
				params.put("packPolIssCd", request.getParameter("packPolIssCd"));
				params.put("packPolIssueYy", (request.getParameter("packPolIssueYy") != null && !request.getParameter("packPolIssueYy").equals("")) ? Integer.parseInt(request.getParameter("packPolIssueYy")) : null);
				params.put("packPolSeqNo", (request.getParameter("packPolSeqNo") != null && !request.getParameter("packPolSeqNo").equals("")) ? Integer.parseInt(request.getParameter("packPolSeqNo")) : null);
				params.put("packPolRenewNo", (request.getParameter("packPolRenewNo") != null && !request.getParameter("packPolRenewNo").equals("")) ? Integer.parseInt(request.getParameter("packPolRenewNo")) : null);
				params.put("packParLineCd", request.getParameter("packParLineCd"));
				params.put("packParIssCd", request.getParameter("packParIssCd"));
				params.put("packParYy", (request.getParameter("packParYy") != null && !request.getParameter("packParYy").equals("")) ? Integer.parseInt(request.getParameter("packParYy")) : null);
				params.put("packParSeqNo", (request.getParameter("packParSeqNo") != null && !request.getParameter("packParSeqNo").equals("")) ? Integer.parseInt(request.getParameter("packParSeqNo")) : null);
				params.put("packParQuoteSeqNo", (request.getParameter("packParQuoteSeqNo") != null && !request.getParameter("packParQuoteSeqNo").equals("")) ? Integer.parseInt(request.getParameter("packParQuoteSeqNo")) : null);
				params.put("packEndtIssCd", request.getParameter("packEndtIssCd"));
				params.put("packEndtYy", (request.getParameter("packEndtYy") != null && !request.getParameter("packEndtYy").equals("")) ? Integer.parseInt(request.getParameter("packEndtYy")) : null);
				params.put("packEndtSeqNo", (request.getParameter("packEndtSeqNo") != null && !request.getParameter("packEndtSeqNo").equals("")) ? Integer.parseInt(request.getParameter("packEndtSeqNo")) : null);
				params.put("assdName", request.getParameter("assdName"));
			} else if("getGiiss210LineRecList".equals(ACTION)){	//added by Gzelle 11.27.2013
				params.put("search", request.getParameter("search"));
				params.put("userId", USER.getUserId());
			} else if("getGipis170LineFilteredLov".equals(ACTION)){	//added by kenneth L. 08.28.2013
				params.put("search", request.getParameter("search"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", "GIPIS170");
				params.put("userId", USER.getUserId());
				params.put("documentType", request.getParameter("documentType"));
			}  else if("getGipis170LineSuLov".equals(ACTION)){	//added by kenneth L. 08.28.2013
				params.put("search", request.getParameter("search"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", "GIPIS170");
				params.put("userId", USER.getUserId());
				params.put("documentType", request.getParameter("documentType"));
			}else if ("showPackageLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("packPolId", request.getParameter("packPolId"));
			}else if("getCargoClassLOV3".equals(ACTION)){	//shan 09.03.2013
				
			}else if("getGipis901MnSublineLOV".equals(ACTION)){	//shan 09.03.2013
				
			}else if("getGipis901MnVesselLOV".equals(ACTION)){	//shan 09.03.2013
				
			}else if("getGIPIS901ZoneTypeLOV".equals(ACTION)){	// shan 09.04.2013
				
			}else if("getGIPIS901ZoneTypeLOV2".equals(ACTION)){	// shan 09.05.2013
				
			}else if("getGipis901AllLinesLOV".equals(ACTION)){	// shan 09.11.2013
				params.put("credBranch", request.getParameter("credBranch"));
			}else if ("getGipis901CredBranchLOV".equals(ACTION)){	// shan 09.11.2013
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGICLS038SublineCd".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getGICLS038BranchCd".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGipis047BondLov".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("filterField", "".equals(request.getParameter("objFilter2")) || "{}".equals(request.getParameter("objFilter2")) ? null : request.getParameter("objFilter2"));
				if ((String) params.get("filterField") != null ){
					params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filterField"))));
				}
			} else if("getGipis047NotaryLov".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			} else if ("showZoneGroupLOV".equals(ACTION)) {	//added by Fons 09.03.2013
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGIPIS156PolNoLOV".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("dspEndtIssCd", request.getParameter("dspEndtIssCd"));
				params.put("dspEndtSeqNo", request.getParameter("dspEndtSeqNo"));
				params.put("dspEndtYy", request.getParameter("dspEndtYy"));
			} else if ("getGIPIS156BookedLov".equals(ACTION)){
				
				String allowBookingInAdvTag = request.getParameter("allowBookingInAdvTag");
				
				if(allowBookingInAdvTag.equals("Y"))
					params.put("ACTION", "getGIPIS156Booked2Lov");
				else
					params.put("ACTION", "getGIPIS156BookedLov");
				
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("issueDate", request.getParameter("issueDate"));
				
			} else if ("getGIPIS156BookedInvoiceLov".equals(ACTION)){
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("issueDate", request.getParameter("issueDate"));
			} else if ("getGIPIS156BancAreaLOV".equals(ACTION)) {
				
			} else if("getGIPIS156BancBranchLOV".equals(ACTION)) {
				params.put("areaCd", request.getParameter("areaCd"));
			} else if ("getGIPIS156IssLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			} else if ("showGIRIS013PolNoLOV".equals(ACTION)) {	//added by J. Diago 09.09.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("effDate", request.getParameter("effDate") == null ? "" : request.getParameter("effDate"));
				params.put("expiryDate", request.getParameter("expiryDate") == null ? "" : request.getParameter("expiryDate"));
			}else if("getPolicyFrpsLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("userId", USER.getUserId());
			}else if("getBinderLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", request.getParameter("binderYy"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo"));
			}else if ("getPkgLineCvrgLOV".equals(ACTION)) {	//added by Fons 09.09.2013
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getPkgSublineCvrgLOV".equals(ACTION)) {	//added by Fons 09.09.2013
				params.put("searchString", request.getParameter("searchString"));
				params.put("packLineCd", request.getParameter("packLineCd"));
			}else if("showGipis139SublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("showGipis139LineLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("showGipis139IntmLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if ("getGIPIS156AcctIssCdLov".equals(ACTION)) {
				
			}else if("getGiris020RiLov".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIISS080ClassTypeLOV".equals(ACTION)) {	//added by Fons 09.12.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGIPIS175PolicyLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
				
				System.out.println(params);
				
			}else if ("getGipis192MakeLOV".equals(ACTION)){ //added by john dolon 9.16.2013
				params.put("makeCd", request.getParameter("makeCd"));
				params.put("companyCd", request.getParameter("companyCd"));
			}else if("getGIUTS035AcctIssCdLOV".equals(ACTION)){
				//params.put("searchString", request.getParameter("searchString"));
			}else if("getGIUTS035BancBranchLOV".equals(ACTION)){
				//params.put("searchString", request.getParameter("searchString"));
			}else if("getGipis192CompanyLOV".equals(ACTION)){
				//no specific param
			}else if ("getRiStatusLOV".equals(ACTION)) {	//added by Fons 09.18.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getRiTypeLOV".equals(ACTION)) {	//added by Fons 09.18.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGipis155PolicyListing".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("dspEndtIssCd", request.getParameter("dspEndtIssCd"));
				params.put("dspEndtSeqNo", request.getParameter("dspEndtSeqNo"));
				params.put("dspEndtYy", request.getParameter("dspEndtYy"));
			}else if ("getGiuts032PolLOV".equals(ACTION)) {	//added by john dolon 9.18.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getRecipientGroupLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIISProvinceLOV2".equals(ACTION)){	//shan 09.30.2013; GIPIS155
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGipis155CityLOV".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGipis155DistrictLOV".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));		
				params.put("searchString", request.getParameter("searchString"));		
			}else if("getGipis155BlockLOV".equals(ACTION)){
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
				params.put("districtNo", request.getParameter("districtNo"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGipis155TarfLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				
			}else if("getGIISRiskLOV2".equals(ACTION)){
				params.put("blockId", request.getParameter("blockId"));
				params.put("searchString", request.getParameter("searchString"));
				
			}else if("getEQZoneLOV2".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				
			}else if("getFloodZoneLOV2".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				
			}else if("getTyphoonZoneLOV2".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				
			}else if("getTariffZoneLOV2".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				
			}else if ("getCertPolicyTableGridListing".equals(ACTION)){ //added by john dolon 10.2.2013
				params.put("ACTION", ACTION);	
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtLineCd", request.getParameter("endtLineCd"));
				params.put("endtSublineCd", request.getParameter("endtSublineCd"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
			}else if("getGipis110ProvinceLOV".equals(ACTION)) {
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGipis110CityLOV".equals(ACTION)) {
				params.put("provinceCd",request.getParameter("provinceCd"));
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiuts025PolicyListing".equals(ACTION)){
				params.put("userId", USER.getUserId());
				params.put("dspLineCd", request.getParameter("lineCd"));
				params.put("dspSublineCd", request.getParameter("sublineCd"));
				params.put("dspIssCd", request.getParameter("issCd"));
				params.put("dspIssueYy", (request.getParameter("issueYy") != null && !request.getParameter("issueYy").equals("")) ? Integer.parseInt(request.getParameter("issueYy")) : null);
				params.put("dspPolSeqNo", (request.getParameter("polSeqNo") != null && !request.getParameter("polSeqNo").equals("")) ? Integer.parseInt(request.getParameter("polSeqNo")) : null);
				params.put("dspRenewNo", (request.getParameter("renewNo") != null && !request.getParameter("renewNo").equals("")) ? Integer.parseInt(request.getParameter("renewNo")) : null);
				params.put("dspNEndtIssCd", request.getParameter("nEndtIssCd"));
				params.put("dspNEndtYy", request.getParameter("nEndtYy")) ;
				params.put("dspNEndtSeqNo", request.getParameter("nEndtSeqNo"));
				params.put("dspRefPolNo", request.getParameter("refPolNo"));
				params.put("dspManualRenewNo", (request.getParameter("manualRenewNo") != null && !request.getParameter("manualRenewNo").equals("")) ? Integer.parseInt(request.getParameter("manualRenewNo")) : null);
				System.out.println(ACTION + " ===== " + params.toString());
			}else if("showGipis130LineCd".equals(ACTION)){
				// Parameters here if any...
			}else if ("getGIPIS200LineLOV".equals(ACTION)){ //added by fons 10.07.2013				
				params.put("line", request.getParameter("line"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
			}else if ("getGIPIS200SublineLOV".equals(ACTION)){ //added by fons 10.07.2013				
				params.put("subline", request.getParameter("subline"));
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGIPIS200IssueLOV".equals(ACTION)){ //added by fons 10.07.2013				
				params.put("issue", request.getParameter("issue"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			}else if ("getGIPIS200IssueYearLOV".equals(ACTION)){ //added by fons 10.07.2013				
				params.put("issueYy", request.getParameter("issueYy"));
			}else if ("getGIPIS200IntermediaryLOV".equals(ACTION)){ //added by fons 10.07.2013				
				params.put("intermediary", request.getParameter("intermediary"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			}else if("getGipis193PlateNoLOV".equals(ACTION)){	//shan 10.10.2013
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIRIS012FRPSLov".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("effDate", request.getParameter("effDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo,", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assured", request.getParameter("assured"));
				params.put("userId", USER.getUserId());
			}else if("getGipis212PolicyNoLov".equals(ACTION)){ // Added by J. Diago 10.09.2013
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
			}else if("getGIPIS194MotorTypeLOV".equals(ACTION)){
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "customOrder"); //added by steven 08.13.2014
				}
			}else if("getGIPIS190LineLOV".equals(ACTION)){
			}else if("getGiris019RiLOV".equals(ACTION)){
				if(params.get("sortColumn") == null){
					params.put("sortColumn", "riCd");
				}
				params.put("findText2", request.getParameter("findText2"));
			} else if("getGIISS040UserGrpLOV".equals(ACTION)){
				// no specific parameter for this action
			}else if("getGiacs313GiisUsersLOV".equals(ACTION)){
				params.put("findText2", request.getParameter("findText2"));
			}else if("getGiiss010LineLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));				
			}else if("getGiiss010SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			} else if("getOpPolicyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("opSublineCd", request.getParameter("opSublineCd"));
				params.put("opIssCd", request.getParameter("opIssCd"));
				params.put("opIssueYy", (request.getParameter("opIssueYy")!=null && !request.getParameter("opIssueYy").equals("")) ? Integer.parseInt(request.getParameter("opIssueYy")) : null);
				params.put("opPolSeqNo", (request.getParameter("opPolSeqNo")!= null && !request.getParameter("opPolSeqNo").equals("")) ? Integer.parseInt(request.getParameter("opPolSeqNo")) : null);
				params.put("opRenewNo", (request.getParameter("opRenewNo")!=null && !request.getParameter("opRenewNo").equals("")) ? Integer.parseInt(request.getParameter("opRenewNo")) : null);
				params.put("credBranch", request.getParameter("credBranch"));
				params.put("userId", USER.getUserId());
				params.put("inceptDate", (request.getParameter("inceptDate") != null && !request.getParameter("inceptDate").equals("")) ? request.getParameter("inceptDate") : null);
				params.put("expiryDate", (request.getParameter("expiryDate") != null && !request.getParameter("expiryDate").equals("")) ? request.getParameter("expiryDate") : null);
				if(request.getParameter("filterText")!=null && !request.getParameter("filterText").equals("")){
					params.put("searchString", request.getParameter("filterText"));
				}
			} else if("getGiiss049LOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			} else if("getGiiss084IssLOV".equals(ACTION)){
				// parameters here if any...
			} else if("getGiiss084CoIntmTypeLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			} else if("getGiiss084LineLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			} else if("getGiiss084SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss084PerilLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiiss213LineLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				params.put("moduleId", "GIISS212");
			}else if("getGiiss213PerilLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("notIn", (request.getParameter("notIn").equals("") ? null : request.getParameter("notIn")));
			}else if ("getGiiss004CredBranchCdLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("getGiiss004RegionLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss074LOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
			}else if ("getIndustryGroupLOV".equals(ACTION)) {
				
			} else if("getGIISS053ZoneGrpLOV".equals(ACTION)){
				if(request.getParameter("filterText")!=null && !request.getParameter("filterText").equals("")){
					params.put("searchString", request.getParameter("filterText"));
				}
			} else if("getGiiss113SublineCd".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));			
			//added by shan 11.20.2013
			}else if("getAllIssSourceLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIISS076WhtaxLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIISS076WhtaxLOV2".equals(ACTION)){//nieko 02092017, SR 23817
				params.put("searchString", request.getParameter("searchString"));	
			}else if("getIntmType3LOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGIISS076CoIntmTypeLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGIISS076PaytTermsLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGIISS076ParentIntmLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			//end 
			}else if("getGiiss201IssCdLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			}else if("getGiiss201LineCdLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
			}else if("getGiiss201SublineCdLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiiss201PerilLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("intmType", request.getParameter("intmType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getGiiss054LineLOV".equals(ACTION)) {	//added by Fons 11.20.2013
				params.put("searchString", request.getParameter("searchString"));
				params.put("userId", USER.getUserId());
			} else if ("getGiiss054SublineLOV".equals(ACTION)) {	//added by Fons 11.20.2013
				params.put("searchString", request.getParameter("searchString"));
				params.put("lineCd", request.getParameter("lineCd"));
			} else if ("getGiiss054TarfLOV".equals(ACTION)) {	//added by Fons 11.20.2013
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGiacs310FundCdLOV".equals(ACTION)) {
				
			} else if ("getGiacs310BranchCdLOV".equals(ACTION)) {
				
			}else if("getGiiss218IntmLOV".equals(ACTION)){
				params.put("bancTypeCd", request.getParameter("bancTypeCd"));
			}else if ("getGiiss120LineLOV".equals(ACTION)) {	
				params.put("userId", USER.getUserId());
			}else if ("getGiiss120SublineLOV".equals(ACTION)) {	
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGiiss120PerilLOV".equals(ACTION)) {	
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if ("getGiuts009LineLOV".equals(ACTION)) {
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
			}else if ("getGiiss219LineLOV".equals(ACTION)) { //added by steven 12.02.2013
				params.put("userId", USER.getUserId());
			}else if ("getGiiss219SublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGiiss219LinePackLOV".equals(ACTION)) { 
				params.put("userId", USER.getUserId());
			}else if ("getGiiss219SublinePackLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGiiss219PerilLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if ("getGiiss219PackLineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			}else if ("getGiiss219PackSublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("packLineCd", request.getParameter("packLineCd"));
			}  else if ("getGiiss035LineLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("filterText", request.getParameter("filterText"));
			}  else if ("getGiiss035SublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				//params.put("filterText", request.getParameter("filterText"));
				params.put("search", request.getParameter("search"));
			}else if ("getCgRefCodeLOV5".equals(ACTION)) {
				params.put("domain", request.getParameter("domain"));		
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss020LineLOV".equals(ACTION)){
				
			}else if("getGiiss020LineSublineLOV".equals(ACTION)){
				
			}else if("getGiiss020SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}  else if ("showIssueSourceLOV".equals(ACTION)) {	//added by Fons 11.26.2013
				params.put("searchString", request.getParameter("searchString"));
				params.put("userId", USER.getUserId());
			} else if("getGiiss032AcctgTypeLov".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss216AreaLov".equals(ACTION)) {
				params.put("filterText", request.getParameter("filterText"));
			} else if("getGiiss216ManagerLov".equals(ACTION)) {
				params.put("filterText", request.getParameter("filterText"));
			}  else if ("getGiiss028LineLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
			} else if ("getGiiss028IssLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
			} else if ("getGiiss028TaxLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				params.put("fundCd", request.getParameter("fundCd"));
			} else if ("getGiiss028TaxPerilLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("taxCd", request.getParameter("taxCd"));
				params.put("taxId", request.getParameter("taxId"));
				params.put("notIn", (request.getParameter("notIn").equals("") ? null : request.getParameter("notIn")));
			} else if ("getGiiss028TaxPlaceLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("taxCd", request.getParameter("taxCd"));
				params.put("taxId", request.getParameter("taxId"));
				params.put("notIn", (request.getParameter("notIn").equals("") ? null : request.getParameter("notIn")));
			} else if("getGiiss012FiItemGrpLov".equals(ACTION)) {
				params.put("filterText", request.getParameter("filterText"));
			}else if("getGIISS039VestypeLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));				
			}else if("getGIISS039VessClassLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));				
			}else if("getGIISS039HullTypeLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getA6401PerilCd".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss068SublineLov".equals(ACTION)) {
				params.put("filterText", request.getParameter("filterText"));
			} else if("getGiiss056SublineCdLov".equals(ACTION)) {
				params.put("filterText", request.getParameter("filterText"));
			} else if("getGiiss202IssLov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			} else if("getGiiss202LineLov".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
			} else if("getGiiss202SublineLov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
			}else if("getGiiss202PerilLov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("selectedPeril", request.getParameter("selectedPeril"));
			} else if("showAcctTreatyTypeGiiss031LOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			} else if("showProfCommTypeGiiss031LOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			} else if("getGiiss031RiLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			} else if("getGiiss031ParentRiLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			}else if("getGiiss082IssCdLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiiss082LineCdLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGiiss082SublineCdLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiiss082PerilLOV".equals(ACTION)){
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if("getCopyIssCdLOV".equals(ACTION)){
				params.put("intmNo", request.getParameter("intmNo"));
			}else if("getCopyLineCdLOV".equals(ACTION)){
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
			}else if("getCopySublineCdLOV".equals(ACTION)){
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiiss220SublineCdLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss167TableNameLov".equals(ACTION)){
				params.put("columnName", request.getParameter("columnName"));
			} else if("getGiiss167ColumnNameLov".equals(ACTION)){
				params.put("tableName", request.getParameter("tableName"));
				params.put("dspColId", request.getParameter("dspColId"));
			}else if("getGiss041TranLOV".equals(ACTION)){
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("notInDeleted", request.getParameter("notInDeleted"));
			}else if("getGiss041IssueLOV".equals(ACTION)){
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("tranCd", request.getParameter("tranCd"));
				params.put("grpIssCd", request.getParameter("grpIssCd"));
				params.put("notInDeleted", request.getParameter("notInDeleted"));
			}else if("getGiss041LineLOV".equals(ACTION)){
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("tranCd", request.getParameter("tranCd"));
				params.put("issCd", request.getParameter("issCd"));
				if(request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
					params.put("notIn", request.getParameter("notIn").toString());
				}
				if(request.getParameter("notInDeleted") != null && !request.getParameter("notInDeleted").equals("")){
					params.put("notInDeleted", request.getParameter("notInDeleted").toString());
				}
			} else if("getGiiss007ProvinceLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGiiss007CityLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
				params.put("provinceCd", request.getParameter("provinceCd"));
			} else if("getGiiss007EqZoneLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGiiss007FloodZoneLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGiiss007TyphoonZoneLOV".equals(ACTION)) {
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGiiss065LineLov".equals(ACTION)) {
				params.put("issCd", request.getParameter("issCd"));
			} else if("getGiiss065SublineLov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss065IssLov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss065Share01Lov".equals(ACTION) || "getGiiss065Share999Lov".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss165LineLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			} else if("getGiiss165SublineLOV".equals(ACTION) || "getGiiss165IssourceLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getGiiss165DistLOV".equals(ACTION)){
				params.put("rvDomain", request.getParameter("rvDomain"));
			} else if("getGiiss165TrtyLOV".equals(ACTION) || "getGiiss165TrtyV2LOV".equals(ACTION)){
				params.put("defaultNo", request.getParameter("defaultNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("notInDeleted", request.getParameter("notInDeleted"));
			}else if("getGiiss106LineLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss106MotortypeLOV".equals(ACTION)) {
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss106SublineLOV".equals(ACTION)) {
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss106PerilLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss106SublineTypeLOV".equals(ACTION)){
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("searchString", request.getParameter("searchString"));
			}else if("getGiiss106ConstructionLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			}else if ("GIIS166AllTabCol2LOV".equals(ACTION)) {
				params.put("tableName", request.getParameter("tableName"));
			}else if ("showGiuts031LineCd".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			}else if ("showGiuts031SublineCd".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("showGiuts031IssCd".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if ("getGiiss076IssCdLOV".equals(ACTION)){
				params.put("searchString", request.getParameter("searchString"));
			} else if("getGIISS116IssourceLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGIISS116LineLOV".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGipis902SublineLov".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiexs003SublineLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getPackageBindersLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
			}else if("getGIISS224Make".equals(ACTION)){ //Dren Niebres SR-5278 - Start
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
			}else if("getGIISS224EngineSeries".equals(ACTION)){
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
				params.put("makeCd", request.getParameter("makeCd"));
			}else if("getGIISS224Subline".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));	
			}else if("getGIISS224SublineType".equals(ACTION)){
				params.put("sublineCd", request.getParameter("sublineCd"));
			}else if("getGIISS224LineCd".equals(ACTION)){
				params.put("appUser", USER.getUserId());
			}else if("getGIISS224PerilName".equals(ACTION)){
				params.put("appUser", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));	
			}//Dren Niebres SR-5278 - End
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params)); //added by john 3.3.2014
			message = json.toString();
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
