package com.geniisys.giex.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISNonRenewReasonService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClaimsService;
import com.geniisys.giex.service.GIEXExpiriesVService;
import com.geniisys.giex.service.GIEXItmperilService;
import com.geniisys.giis.service.GIISUserService;
import com.geniisys.gipi.service.GIPIInvoiceService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIEXExpiriesVController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIEXExpiriesVController.class);


	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXExpiriesVService giexExpiriesVService = (GIEXExpiriesVService) APPLICATION_CONTEXT.getBean("giexExpiriesVService");
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
			GIISNonRenewReasonService giisNonRenewReasonService = (GIISNonRenewReasonService) APPLICATION_CONTEXT.getBean("giisNonRenewReasonService");
			GIPIInvoiceService gipiInvoiceService = (GIPIInvoiceService) APPLICATION_CONTEXT.getBean("gipiInvoiceService");
			GICLClaimsService giclClaimsService = (GICLClaimsService) APPLICATION_CONTEXT.getBean("giclClaimsService");
			GIEXItmperilService giexItmperilService = (GIEXItmperilService) APPLICATION_CONTEXT.getBean("giexItmperilService");
			
			if ("showProcessExpiringPoliciesPage".equals(ACTION)){
				log.info("Retrieving Expired Policies Listing...");
				Map<String, Object> params1 = new HashMap<String, Object>();
				params1.put("userId", USER.getUserId());
				params1.put("allUser", "");
				params1.put("mis", "");
				params1.put("exist", "");
				params1 = giexExpiriesVService.preFormGIEXS004(params1);
				String allUser = (String) (params1.get("allUser") == null ? "" : params1.get("allUser"));
				String mis = (String) (params1.get("mis") == null ? "" : params1.get("mis"));
				String exist = (String) (params1.get("exist") == null ? "" : params1.get("exist"));
				
				Map<String, Object> initialVars = giexExpiriesVService.getGiex004InitialVariables();
				
				String allowUndistSw = (String) initialVars.get("vExpiryAllowUndist") ;//giisParametersService.getParamValueV2("EXPIRY_ALLOW_UNDIST");
				request.setAttribute("allUser", allUser);
				request.setAttribute("mis", mis);
				request.setAttribute("exist", exist);
				request.setAttribute("allowUndistSw", allowUndistSw);							
				
				/*HashMap<String, Object> params = new HashMap<String, Object>(); // replaced by andrew - 1.2.2012
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("allUser", allUser);
				params = giexExpiriesVService.getExpiredPolicies(params);
				request.setAttribute("expPolGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));*/
				
				/*Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getExpiredPolicies");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("allUser", allUser);
				params.put("userId", USER.getUserId());
				params = TableGridUtil.getTableGrid(request, params);
				request.setAttribute("expPolGrid", new JSONObject(params));
				
				log.info("expPolGrid ::: " + params);*/

				Map<String, Object> params =  (HashMap<String, Object>) FormInputUtil.getFormInputs(request); //Added by Jerome Bautista 04.22.2016 SR 21993
				params.put("ACTION", "getQueriedExpiredPolicies");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("allUser", allUser);
				String exitSw = request.getParameter("exitSw") == null ? "N" : request.getParameter("exitSw");

				if (exitSw.equals("Y")){
					params.put("userId", USER.getUserId());
				}
				
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				params = TableGridUtil.getTableGrid(request, params);
				request.setAttribute("expPolGrid", new JSONObject(params));
				
				System.out.println("initialVars="+initialVars);
				request.setAttribute("initialVars", QueryParamGenerator.generateQueryParams(initialVars) );
				PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/processExpiringPolicies.jsp";
			}else if ("showQueriedExpiringPoliciesPage".equals(ACTION)){
				HashMap<String, Object> params = (HashMap<String, Object>) FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("allUser", request.getParameter("allUser") == null ? "" : request.getParameter("allUser"));
				params = giexExpiriesVService.getQueriedExpiredPolicies(params);
				request.setAttribute("expPolGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				log.info("expPolGrid ::: " + params);
				PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/processExpiringPolicies.jsp";
			}else if("refreshExpPolListing".equals(ACTION)){
				log.info("Refresh Expired Policies Listing...");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("allUser", request.getParameter("allUser") == null ? "" : request.getParameter("allUser"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				params = giexExpiriesVService.getExpiredPolicies(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshQueriedExpPolListing".equals(ACTION)){
				log.info("Refresh Queried Expired Policies Listing...");
				HashMap<String, Object> params =  (HashMap<String, Object>) FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				params = giexExpiriesVService.getQueriedExpiredPolicies(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("postQueryGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexExpiriesVService.postQueryGIEXS004(params);
				message = (new JSONObject(StringFormatter.escapeHTMLInMap(params))).toString(); //QueryParamGenerator.generateQueryParams(params); changed by robert 09182013
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkPolicyGIEXS004".equals(ACTION)) {
				Map<String, Object> params1 = new HashMap<String, Object>();
				params1.put("userId", USER.getUserId());
				params1.put("allUser", "");
				params1.put("mis", "");
				params1.put("exist", "");
				params1 = giexExpiriesVService.preFormGIEXS004(params1);
				String allUser = (String) (params1.get("allUser") == null ? "" : params1.get("allUser"));
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
			    String allowRenewalOtherUser = giisParametersService.getParamValueV2("ALLOW_RENEWAL_OTHER_USER"); //Added by Jerome Bautista 03.14.2016 SR 21944
			    params.put("allowRenewalOtherUser", allowRenewalOtherUser); //Added by Jerome Bautista 03.14.2016 SR 21944
				params.put("user", USER.getUserId());
				params.put("allUser", allUser);
				params = giexExpiriesVService.checkPolicyGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkRenewFlagGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GIEXS004");
				params = giexExpiriesVService.checkRenewFlagGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("verifyOverrideRbGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params = giexExpiriesVService.verifyOverrideRbGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("initDateFormatGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giisParametersService.initDateFormatGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("initLineCdGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giisParametersService.initLineCdGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("initSublineCdGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giisParametersService.initSublineCdGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showPolicyDetailsPage".equals(ACTION)) {
				request.setAttribute("packPolicyId", request.getParameter("packPolicyId"));
				request.setAttribute("policyId", request.getParameter("policyId"));
				//for unsettled accounts
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiInvoiceService.populateBasicDetails(params);
				request.setAttribute("polDetailsGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				log.info("polDetailsGrid ::: " + params);
				//for claims
				HashMap<String, Object> params1 = new HashMap<String, Object>();
				params1.put("packPolicyId", request.getParameter("packPolicyId"));
				params1.put("policyId", request.getParameter("policyId"));
				params1.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params1 = giclClaimsService.getBasicClaimDtls(params1);
				request.setAttribute("claimDetailsGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params1)));
				log.info("claimDetailsGrid ::: " + params1);
				PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/pop-ups/policyDetails.jsp";
			}else if("getPackDetailsHeader".equals(ACTION)){
				GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("policyId", request.getParameter("policyId"));
				params = gipiPolbasicService.getPackDetailsHeader(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshBasicDetails".equals(ACTION)){
				log.info("Refresh Basic Details...");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiInvoiceService.populateBasicDetails(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshClaimDetails".equals(ACTION)){
				log.info("Refresh Claim Details...");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giclClaimsService.getBasicClaimDtls(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showQueryPoliciesPage".equals(ACTION)) {
				request.setAttribute("allUser", request.getParameter("allUser"));
				PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/pop-ups/queryPolicies.jsp";
			} else if ("deleteItmperilByPolId".equals(ACTION)) {
				giexItmperilService.deleteItmperilByPolId(Integer.parseInt(request.getParameter("policyId")));
			}else if("validateReasonCd".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giisNonRenewReasonService.validateReasonCd(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("processPostButtonGIEXS004".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("user", USER.getUserId());
				params = giexExpiriesVService.processPostButtonGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("processPostOnOverrideGIEXS004".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexExpiriesVService.processPostOnOverrideGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveProcessTagGIEXS004".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("appUser", USER.getUserId());
				params.put("userId", USER.getUserId());
				params = giexExpiriesVService.saveProcessTagGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRenewedPoliciesSummary".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String policyIds = request.getParameter("policyIds")+","; // the ',' is needed in the function on toad.
				params.put("ACTION", ACTION);
				params.put("policyIds", policyIds);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				Map<String, Object> renewedPoliciesSummaryTableGrid = TableGridUtil.getTableGrid(request, params);				
				
				JSONObject json = new JSONObject(renewedPoliciesSummaryTableGrid);				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("renewedPoliciesSummaryTableGrid", json);
					request.setAttribute("refreshAction","getRenewedPoliciesSummary&policyIds="+policyIds+"refresh=1");
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/pop-ups/renewedPoliciesSummary.jsp";
				}
			}else if("getPurgeExtractTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("allUser", USER.getAllUserSw());
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("policyNo", request.getParameter("policyNo"));
				params.put("fromMonth", request.getParameter("fromMonth"));
				params.put("fromYear", request.getParameter("fromYear"));
				params.put("toMonth", request.getParameter("toMonth"));
				params.put("toYear", request.getParameter("toYear"));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("range", request.getParameter("range"));
				params.put("expiryDate", request.getParameter("expiryDate"));// added by pjsantos 10/11/2016, GENQA 5688
				Map<String, Object> giexPurgeExtractTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(giexPurgeExtractTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giexPurgeExtractTableGrid", json);
					PAGE = "/pages/underwriting/renewalProcessing/purgeExtractedPolicies/purgeExtractTable.jsp";
				}
			}else if("showPurgeExTableParams".equals(ACTION)){
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("sublineCd", request.getParameter("sublineCd"));
				request.setAttribute("issCd", request.getParameter("issCd"));
				request.setAttribute("intmNo", request.getParameter("intmNo"));
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("sublineName", request.getParameter("sublineName"));
				request.setAttribute("issName", request.getParameter("issName"));
				request.setAttribute("intmName", request.getParameter("intmName"));
				request.setAttribute("fromMonth", request.getParameter("fromMonth"));
				request.setAttribute("fromYear", request.getParameter("fromYear"));
				request.setAttribute("fromDate", request.getParameter("fromDate"));
				request.setAttribute("toMonth", request.getParameter("toMonth"));
				request.setAttribute("toYear", request.getParameter("toYear"));
				request.setAttribute("toDate", request.getParameter("toDate"));
				request.setAttribute("range", request.getParameter("range"));
				PAGE = "/pages/underwriting/renewalProcessing/purgeExtractedPolicies/popups/purgeExTableParameterPopup.jsp";
			}else if("checkNoOfRecordsToPurge".equals(ACTION)){
				//String misSw = USER.getMisSw().equals("Y") || USER.getMgrSw().equals("Y") ? "Y" : "N";
				// Added by Joanne 12.11.13, to handle null mngSw and misSw 
				String misSwDb = USER.getMisSw()== null ? "" : USER.getMisSw();
				String mgrSw = USER.getMgrSw()== null ? "" : USER.getMgrSw();
				//String misSw = misSwDb.equals("Y") || mgrSw.equals("Y") ? "N" : ""; //marco - - 08.05.2014 - replaced 
				String misSw = misSwDb.equals("Y") || mgrSw.equals("Y") ? "Y" : "N";
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("allUser", USER.getAllUserSw());
				params.put("misSw", misSw);
				params.put("basedOnParam", request.getParameter("basedOnParam"));
				params.put("allExpProc", request.getParameter("allExpProc"));
				params.put("allUnproc", request.getParameter("allUnproc"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("fromMonth", request.getParameter("fromMonth"));
				params.put("fromYear", request.getParameter("fromYear"));
				params.put("toMonth", request.getParameter("toMonth"));
				params.put("toYear", request.getParameter("toYear"));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("rangeType", request.getParameter("rangeType"));
				params.put("range", request.getParameter("range"));
				System.out.println("checkNoOfRecordsToPurge params : " + params);
				params = giexExpiriesVService.checkNoOfRecordsToPurge(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("purgeBasedNotParam".equals(ACTION)){
				//String misSw = USER.getMisSw().equals("Y") || USER.getMgrSw().equals("Y") ? "Y" : "N";
				// Added by Joanne 01.09.14, to handle null mngSw and misSw 
				String misSwDb = USER.getMisSw()== null ? "" : USER.getMisSw();
				String mgrSw = USER.getMgrSw()== null ? "" : USER.getMgrSw();
				//String misSw = misSwDb.equals("Y") || mgrSw.equals("Y") ? "N" : ""; //marco - - 08.05.2014 - replaced 
				String misSw = misSwDb.equals("Y") || mgrSw.equals("Y") ? "Y" : "N";
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params.put("allUser", USER.getAllUserSw());
				params.put("misSw", misSw);
				params.put("allExpProc", request.getParameter("allExpProc"));
				params.put("allUnproc", request.getParameter("allUnproc"));
				System.out.println("purge basedNotParam params: " + params);
				params = giexExpiriesVService.purgeBasedNotParam(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("purge".equals(ACTION)){
				//String misSw = USER.getMisSw().equals("Y") || USER.getMgrSw().equals("Y") ? "Y" : "N";
				// Added by Joanne 01.09.14, to handle null mngSw and misSw 
				String misSwDb = USER.getMisSw()== null ? "" : USER.getMisSw();
				String mgrSw = USER.getMgrSw()== null ? "" : USER.getMgrSw();
				//String misSw = misSwDb.equals("Y") || mgrSw.equals("Y") ? "N" : ""; //marco - - 08.05.2014 - replaced 
				String misSw = misSwDb.equals("Y") || mgrSw.equals("Y") ? "Y" : "N";
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params.put("allUser", USER.getAllUserSw());
				params.put("misSw", misSw);
				params.put("allExpProc", request.getParameter("allExpProc"));
				params.put("allUnproc", request.getParameter("allUnproc"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				if("basedNotTime".equals(request.getParameter("purgeRange"))){
					params = giexExpiriesVService.purgeBasedNotTime(params);
				}else if("basedOnBeforeMonth".equals(request.getParameter("purgeRange"))){
					params.put("fromMonth", request.getParameter("fromMonth"));
					params.put("fromYear", request.getParameter("fromYear"));
					params = giexExpiriesVService.purgeBasedOnBeforeMonth(params);
				}else if("basedOnBeforeDate".equals(request.getParameter("purgeRange"))){
					params.put("fromDate", request.getParameter("fromDate"));
					params = giexExpiriesVService.purgeBasedOnBeforeDate(params);
				}else if("basedExactMonth".equals(request.getParameter("purgeRange"))){
					params.put("fromMonth", request.getParameter("fromMonth"));
					params.put("fromYear", request.getParameter("fromYear"));
					params.put("toMonth", request.getParameter("toMonth"));
					params.put("toYear", request.getParameter("toYear"));
					params = giexExpiriesVService.purgeBasedExactMonth(params);
				}else if("basedExactDate".equals(request.getParameter("purgeRange"))){
					params.put("fromDate", request.getParameter("fromDate"));
					params.put("toDate", request.getParameter("toDate"));
					params = giexExpiriesVService.purgeBasedExactDate(params);
				}
				System.out.println("purge " + request.getParameter("purgeRange") + " params: " + params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLineCd".equals(ACTION)){
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params.put("sublineName", request.getParameter("sublineName") == null ? "" : request.getParameter("sublineName"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("moduleId", "GIEXS003");
				params = giisLineService.validateLineCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateSublineCd".equals(ACTION)){
				GIISSublineFacadeService giisSublineFacadeService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params = giisSublineFacadeService.validatePurgeSublineCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateIssCd".equals(ACTION)){
				GIISISSourceFacadeService giisIssourceFacadeService = (GIISISSourceFacadeService)APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("moduleId", "GIEXS003");
				params = giisIssourceFacadeService.validateIssCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateIntmNo".equals(ACTION)){
				GIISIntermediaryService giisIntermediaryService = (GIISIntermediaryService)APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmNo", request.getParameter("intmNo") == null ? "" : Integer.parseInt(request.getParameter("intmNo")));
				params = giisIntermediaryService.validateIntmNo(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getPolicyIdGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("frRnSeqNo", request.getParameter("frRnSeqNo"));
				params.put("toRnSeqNo", request.getParameter("toRnSeqNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
				String sDate = request.getParameter("startDate");
				String startDate;
				if(sDate.equals("")){
					startDate = "";
				}else{
					Date strtDate = df.parse(request.getParameter("startDate"));
					startDate = df.format(strtDate);
				}	
				
				String eDate = request.getParameter("endDate");
				String endDate;
				if(eDate.equals("")){
					endDate = "";
				}else{
					Date ndDate = df.parse(request.getParameter("endDate"));
					endDate = df.format(ndDate);
				}
				
				params.put("startDate", startDate);
				params.put("endDate", endDate);
				
				Integer renewFlag = request.getParameter("renewFlag") == null ? 0 : Integer.parseInt(request.getParameter("renewFlag"));
				params.put("renewFlag", renewFlag);
				params.put("userId", USER.getUserId());
				params.put("reqRenewalNo", request.getParameter("reqRenewalNo"));
				
				Debug.print("getRenewalNoticePolicyId params:" + params);
				
				List<String> resultParams = (List<String>) giexExpiriesVService.getPolicyIdGiexs006(params);
				
				Debug.print("getPolicyIdGiexs006 resultParams:" + resultParams);
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giexs004ProcessPostButton".equals(ACTION)) {
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("allUser",request.getParameter("allUser"));
				params.put("functionCd","RB");
				params.put("moduleName",request.getParameter("moduleId"));
				params.put("validTag","Y");
				params.put("vOverrideRenewal", request.getParameter("vOverrideRenewal"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCd", request.getParameter("lineCd"));//joanne added parameters
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("claimSw", request.getParameter("claimSw"));
				params.put("balanceSw", request.getParameter("balanceSw"));
				params.put("intmName", request.getParameter("intmName"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("rangeType", request.getParameter("rangeType"));
				params.put("range", request.getParameter("range"));
				params.put("fmDate", request.getParameter("fmDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("fmMon", request.getParameter("fmMon"));
				params.put("toMon", request.getParameter("toMon"));
				params.put("fmYear", request.getParameter("fmYear"));
				params.put("toYear", request.getParameter("toYear"));//joanne end
				params.put("confirmBranchSw", request.getParameter("confirmBranchSw"));
				params.put("confirmFmvSw", request.getParameter("confirmFmvSw")); //benjo 11.24.2016 SR-5621
				params.put("vValidateMcFmv", request.getParameter("vValidateMcFmv")); //benjo 11.24.2016 SR-5621
				
				giexExpiriesVService.giexs004ProcessPostButton(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giexs004ProcessRenewal".equals(ACTION)) {
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("allUser",request.getParameter("allUser"));
				giexExpiriesVService.giexs004ProcessRenewal(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giexs004ProcessPolicies".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("user", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));//joanne, added parameters
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("claimSw", request.getParameter("claimSw"));
				params.put("balanceSw", request.getParameter("balanceSw"));
				params.put("intmName", request.getParameter("intmName"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("rangeType", request.getParameter("rangeType"));
				params.put("range", request.getParameter("range"));
				params.put("fmDate", request.getParameter("fmDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("fmMon", request.getParameter("fmMon"));
				params.put("toMon", request.getParameter("toMon"));
				params.put("fmYear", request.getParameter("fmYear"));
				params.put("toYear", request.getParameter("toYear"));//joanne end

				giexExpiriesVService.giexs004ProcessPolicies(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("showViewRenewal".equals(ACTION)){
				JSONObject json = giexExpiriesVService.showViewRenewal(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("json", json);
					PAGE = "/pages/underwriting/renewalProcessing/viewRenewal/viewRenewal.jsp";
				}
				
			} else if("showRenewalHistory".equals(ACTION)){
				JSONObject json = giexExpiriesVService.showRenewalHistory(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("json", json);
					PAGE = "/pages/underwriting/renewalProcessing/viewRenewal/pop-ups/renewalHistory.jsp";
				}
			}else if ("showAssignExtractedExpiryRecord".equals(ACTION)) {
				if("1".equals(request.getParameter("refresh"))){
					log.info("Assign Extracted Expiry Record to a New user...");
					JSONObject jsonAssignExtractedExpiry = giexExpiriesVService.getExpiryRecord(request, USER);
					message = jsonAssignExtractedExpiry.toString();
					PAGE = "/pages/genericMessage.jsp";	
				}else{
					GIISUserService giisUserService = (GIISUserService) APPLICATION_CONTEXT.getBean("giisUserService");
					request.setAttribute("allowReassignExp", giisParametersService.getParamValueV2("ALLOW_REASSIGN_EXPIRY_ALLUSER"));	//Gzelle 07092015 SR4744 UW-SPECS-2015-065					
					
					GIISUser user = giisUserService.getUserDetails(USER.getUserId());
					request.setAttribute("allSw", user.getAllUserSw());
					request.setAttribute("misSw", user.getMisSw());
					request.setAttribute("mgrSw", user.getMgrSw());
					request.setAttribute("userId", USER.getUserId());
					PAGE = "/pages/underwriting/renewalProcessing/assignExtractedExpiryRecord/assignExtractedExpiryRecord.jsp";
				}
			} else if ("showParameters".equals(ACTION)) {
				log.info("Assign Extracted Expiry Record to a New user...");
				PAGE = "/pages/underwriting/renewalProcessing/assignExtractedExpiryRecord/pop-ups/parameter.jsp";
			} else if("updateExpiryRecord".equals(ACTION)){
				message = giexExpiriesVService.updateExpiryRecord(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("updateExpiriesByBatch".equals(ACTION)){
				message = giexExpiriesVService.updateExpiriesByBatch(request, USER);;
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkExtractUserAccess".equals(ACTION)){
				message = giexExpiriesVService.checkExtractUserAccess(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("checkRecords")){
				message = giexExpiriesVService.checkRecords(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("checkSubline")){
				message = giexExpiriesVService.checkSubline(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
