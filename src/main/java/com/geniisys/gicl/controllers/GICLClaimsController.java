package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISBlockService;
import com.geniisys.common.service.GIISCityService;
import com.geniisys.common.service.GIISClmStatService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISLossCtgryService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISPayeesService;
import com.geniisys.common.service.GIISProvinceService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.service.GICLCatDtlService;
import com.geniisys.gicl.service.GICLClaimLossExpenseService;
import com.geniisys.gicl.service.GICLClaimsService;
import com.geniisys.gicl.service.GICLClmAdjHistService;
import com.geniisys.gicl.service.GICLClmStatHistService;
import com.geniisys.gicl.service.GICLProcessorHistService;
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.geniisys.gipi.service.GIPIVehicleService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GICLClaimsController extends BaseController {

	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(GICLClaimsController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";

			GICLClaimsService giclClaimsService = (GICLClaimsService) APPLICATION_CONTEXT.getBean("giclClaimsService");
			Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId"))? "0" : request.getParameter("claimId"));
			if ("showClaims".equals(ACTION)) {
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyClaims.jsp";

			}else if("validateLineCd".equals(ACTION)){ //christian 09.07.2012
				System.out.println("validatLineCd");
				message = giclClaimsService.validateLineCd(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePolIssCd".equals(ACTION)){ //christian 09.07.2012
				String userId = USER.getUserId();
				message = giclClaimsService.validatePolIssCd(request, userId);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSublineCd".equals(ACTION)){ //christian 09.07.2012
				message = giclClaimsService.validateSublineCd(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("printClaimsDocs".equals(ACTION)) { 
				GICLClaims giclClaims = giclClaimsService.getClaimInfo(claimId);
				//request.setAttribute("objGICLClaims", new JSONObject(giclClaims)); bonok :: 09.11.2012
				request.setAttribute("objGICLClaims", new JSONObject(StringFormatter.escapeHTMLInObject(giclClaims))); // bonok :: 09.11.2012
				PAGE = "/pages/claims/claimReportsPrintDocs/printClaimsDocuments.jsp";
			} else if ("getRelatedClaims".equals(ACTION)) {
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("currentPage",request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giclClaimsService.getRelatedClaims(params);
				request.setAttribute("giclRelatedClaimsTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedClaimsTable.jsp";
			} else if ("refreshRelatedClaims".equals(ACTION)) {
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getRelatedClaims");
				params.put("policyId", policyId);
				params.put("currentPage",request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giclClaimsService.getRelatedClaims(params);
				Map<String, Object> clmList = TableGridUtil.getTableGrid(request, params);
				//added by Gzelle 06.15.2013
				JSONObject json = new JSONObject(clmList);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					message = StringFormatter.replaceTildes(json.toString());
					PAGE = "/pages/genericMessage.jsp";
				}
				//message = StringFormatter.replaceTildes(json.toString());
			} else if ("getClaimTableGridListing".equals(ACTION)) {
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("lineName", request.getParameter("lineName")); // added by andrew - 02.24.2012
				Map<String, Object> tableGridParams = new HashMap<String, Object>();
				tableGridParams.put("currentPage",request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				tableGridParams.put("filter", request.getParameter("objFilter"));
				tableGridParams.put("sortColumn", request.getParameter("sortColumn")); //added by christian - 06.26.2012
				tableGridParams.put("ascDescFlg", request.getParameter("ascDescFlg"));
				tableGridParams.put("lineCd", request.getParameter("lineCd"));
				tableGridParams.put("userId", USER.getUserId());
				tableGridParams.put("allUserSw", USER.getAllUserSw());
				tableGridParams.put("moduleId", "GICLS002"); //added by vondanix - 09.30.2015
				//System.out.println("filter: " + tableGridParams.get("filter"));
				System.out.println("tableGridParams " + tableGridParams);
				tableGridParams = giclClaimsService.getClaimsTableGridListing(tableGridParams); 
				request.setAttribute("user", USER.getUserId());
				//added by Christian 04.27.2012
				String ora2010SW = giisParametersService.getParamValueV2("ORA2010_SW");
				String lineCodeAC = giisParametersService.getParamValueV2("LINE_CODE_AC");
				String lineCodeMC = giisParametersService.getParamValueV2("LINE_CODE_MC");
				request.setAttribute("ora2010SW", ora2010SW);
				request.setAttribute("lineCodeAC", lineCodeAC);
				request.setAttribute("lineCodeMC", lineCodeMC);
				System.out.println("ORA2010SW: " + ora2010SW + " Line AC: " + lineCodeAC + " Line MC: " + lineCodeMC);
				if("1".equals(request.getParameter("refresh"))){
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(tableGridParams)).toString();
				} else {
					request.setAttribute("claimsListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(tableGridParams)));
					PAGE = "/pages/claims/claimListing.jsp";
				}
			} else if("showLossRecoveryListing".equals(ACTION)){		
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getLossRecoveryTableGridListing");	
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GICLS052");
				params.put("lineCd", request.getParameter("lineCd"));
				Map<String, Object> lossRecoveryListTableGrid = TableGridUtil.getTableGrid(request, params);	
				JSONObject json = new JSONObject(lossRecoveryListTableGrid);				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("lossRecoveryListTableGrid", json);
					PAGE = "/pages/claims/lossRecoveryListing.jsp";
				}
			} else if ("showClaimBasicInfo".equals(ACTION)) {
				GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");

				Map<String, Object> userParams = userService.getUserLevel(USER.getUserId());
				request.setAttribute("accessErrorMessage", userParams.get("message"));
				request.setAttribute("userLevel", userParams.get("userLevel"));
				if (Integer.parseInt(userParams.get("userLevel").toString()) != 0) {
					giclClaimsService.getBasicParametersDetails(paramService, giacParamService, request, USER);
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("functionName", "OVERDUE_PREMIUM_OVERRIDE");
					params.put("moduleId", "GICLS010"); 
					//params.put("moduleId", "GICLS025");changed to GICLS025 //Naka set sa GICLS025, not sure why, ibabalik ko siya sa GICLS010 -- 9.7.2012
					params.put("userId", USER.getUserId());
					String overdueFlag = giacUserFunctionsService.checkOverdueUser(params);
					request.setAttribute("overdueFlag", overdueFlag);
					GICLClaims basic = claimId == 0 ? null :giclClaimsService.getClaimsBasicInfoDtls(claimId);
					if( claimId != 0){
						Map<String, Object> reqDocs = giclClaimsService.checkClaimReqDocs(claimId);
						request.setAttribute("hasDocs", reqDocs.get("hasDocs"));
						request.setAttribute("hasCompletedDates", reqDocs.get("hasCompletedDates"));
					}
					
					request.setAttribute("claimId", claimId == 0 ? "" :claimId);
					request.setAttribute("basicInfoJSON", new JSONObject(basic != null ? StringFormatter.escapeHTMLInObject(basic) :new GICLClaims()));
					request.setAttribute("checkClaimStatusMsg", basic != null ? giclClaimsService.checkClaimStatus(basic.getLineCode(), basic.getSublineCd(), basic.getIssCd(), basic.getClaimYy(), basic.getClaimSequenceNo()) :"");
				}
				PAGE = "/pages/claims/claimBasicInformation/claimBasicInformation.jsp";
			} else if ("initializeMenu".equals(ACTION)) {
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(giclClaimsService.initializeClaimsMenu(params))).toString();
			} else if ("getBasicInfoPopupListing".equals(ACTION)) {
				String lovSelected = request.getParameter("lovSelected");
				System.out.println("LOV SELECTED: " + lovSelected);
				Map<String, Object> params = new HashMap<String, Object>();
				params = this.determineService(request, response, params,lovSelected);
				Debug.print("popup Listing params: " + params);

				request.setAttribute("claimsListTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("refreshAction", "refreshBasicInfoPopupListing");
				PAGE = "/pages/claims/claimBasicInformation/subPages/basicInfoPopupListing.jsp";
			} else if ("refreshBasicInfoPopupListing".equals(ACTION)) {
				String lovSelected = request.getParameter("lovSelected");
				Map<String, Object> params = new HashMap<String, Object>();
				params = this.determineService(request, response, params, lovSelected);
				Debug.print("popup Listing params: " + params);

				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
			} else if ("getUnpaidPremiumDtls".equals(ACTION)) {
				GIPIInstallmentService installmentService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				message = installmentService.getUnpaidPremiumDtls(request);
			}else if ("enableMenus".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("param", request.getParameter("param"));
				message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(giclClaimsService.enableMenus(params))).toString();
				Debug.print("enableMenu: " + message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getClmDesc".equals(ACTION)){
				GIISClmStatService clmstatService = (GIISClmStatService) APPLICATION_CONTEXT.getBean("giisClmStatService");
				message = clmstatService.getClmStatDesc(request.getParameter("clmStatCd"));
			}else if ("updateClaimsBasicInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("clmStatCd", request.getParameter("clmStatCd"));
				params.put("clmControl", request.getParameter("clmControl"));
				params.put("clmCoop", request.getParameter("clmCoop"));
				params.put("unpaidPremium", request.getParameter("unpaidPremium"));
				params.put("updUserFlag", request.getParameter("updUserFlag"));
				
				giclClaimsService.updateClaimsBasicInfo(params);
				Debug.print("updateClaimsBasicInfo PARAMS:" + params);
			}else if ("getProcessorHistory".equals(ACTION)){
				GICLProcessorHistService procHistService = (GICLProcessorHistService) APPLICATION_CONTEXT.getBean("giclProcessorHistService");
				procHistService.getProcessorHist(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/processorHistory.jsp";
			}else if ("getStatHist".equals(ACTION)){
				GICLClmStatHistService statHistService = (GICLClmStatHistService) APPLICATION_CONTEXT.getBean("giclClmStatHistService");
				statHistService.getClmStatHistory(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/claimStatHistory.jsp";
			}else if ("getBasicIntmDtls".equals(ACTION)){
				giclClaimsService.getBasicIntmDtls(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/intermediary.jsp";
			}else if ("showRecoveryAmounts".equals(ACTION)){
				giclClaimsService.getRecoveryAmounts(request, USER);
				PAGE = "/pages/claims/claimBasicInformation/subPages/recoveryAmounts.jsp";
			}else if ("checkClaimPlateNo".equals(ACTION)) {
				System.out.println("controller loss date: "+request.getParameter("dspLossDate"));
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("plateNo", request.getParameter("plateNo"));
				params.put("dspLossDate", request.getParameter("dspLossDate"));
				params.put("claimNo", "");
				params.put("result", "");
				params = giclClaimsService.checkClaimPlateNo(params);
				System.out.println(params.get("result"));
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if ("checkClaimMotorNo".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("motorNo", request.getParameter("motorNo"));
				params.put("dspLossDate", request.getParameter("dspLossDate"));
				params.put("claimNo", "");
				params.put("result", "");
				params = giclClaimsService.checkClaimMotorNo(params);
				System.out.println(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if ("checkClaimSerialNo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("serialNo", request.getParameter("serialNo"));
				params.put("dspLossDate", request.getParameter("dspLossDate"));
				params.put("claimNo", "");
				params.put("result", "");
				params = giclClaimsService.checkClaimSerialNo(params);
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateClmPolicyNo".equals(ACTION)){
				message = giclClaimsService.validateClmPolicyNo(request, USER);
			}else if("chkItemForTotalLoss".equals(ACTION)){
				message = giclClaimsService.chkItemForTotalLoss(request, USER);
			}else if("checkExistingClaims".equals(ACTION)){
				message = giclClaimsService.checkExistingClaims(request, USER);
			}else if("checkTotalLossSettlement".equals(ACTION)){
				message = giclClaimsService.checkTotalLossSettlement(request, USER);
			}else if("validatePlateMotorSerialNo".equals(ACTION)){
				message = giclClaimsService.validatePlateMotorSerialNo(request, USER);
			}else if("checkLossDateTime".equals(ACTION)){
				message = giclClaimsService.checkLossDateTime(request, USER);
			}else if("getSublineTime".equals(ACTION)){
				message = giclClaimsService.getSublineTime(request, USER);
			}else if("validateLossDatePlateNo".equals(ACTION)){
				message = giclClaimsService.validateLossDatePlateNo(request, USER);
			}else if("validateLossTime".equals(ACTION)){
				message = giclClaimsService.validateLossTime(request, USER);
			}else if("claimCheck".equals(ACTION)){
				message = giclClaimsService.claimCheck(request, USER);
			}else if("validateCatastrophicCode".equals(ACTION)){
				message = giclClaimsService.validateCatastrophicCode(request, USER);
			}else if("getCheckLocationDtl".equals(ACTION)){
				message = giclClaimsService.getCheckLocationDtl(request, USER);
			}else if("saveGICLS010".equals(ACTION)){
				//added getting of menuLineCd by cherrie | 01242014
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(request.getParameter("lineCd")));
				message = giclClaimsService.saveGICLS010(request, USER);
			}else if("checkPrivAdjExist".equals(ACTION)){
				message = giclClaimsService.checkPrivAdjExist(request, USER);
			}else if("getDateCancelled".equals(ACTION)){
				GICLClmAdjHistService adjHistService = (GICLClmAdjHistService) APPLICATION_CONTEXT.getBean("giclClmAdjHistService");
				message = adjHistService.getDateCancelled(request, USER);
			}else if("showSettlingSurveyAgent".equals(ACTION)){
				PAGE = "/pages/claims/claimBasicInformation/subPages/settlingSurvey.jsp";
			}else if("refreshClaims".equals(ACTION)){
				giclClaimsService.refreshClaims(request, USER);
			}else if("showClmListingPerPolicy".equals(ACTION)){
				giclClaimsService.getClaimsPerPolicy(request, USER);
				PAGE = "/pages/claims/inquiry/claimListing/perPolicy/perPolicy.jsp";
			}else if("getClaimsPerPolicyDetails".equals(ACTION)){
				giclClaimsService.getClaimsPerPolicyDetails(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/inquiry/claimListing/perPolicy/perPolicyDetails.jsp";
			}else if("showUpdateLossRecoveryTagListing".equals(ACTION)){
				giclClaimsService.getUpdateLossRecoveryTagListing(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					request.setAttribute("itemNo", request.getParameter("itemNo"));
					PAGE = "/pages/claims/updateLossRecoveryTag/updateLossRecoveryTagListing.jsp";
				}
			}else if("showClmPolicyNoLOV".equals(ACTION)){
				giclClaimsService.getClaimsPerPolicy(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/inquiry/claimListing/perPolicy/perPolicyLOV.jsp";
			}else if("updateLossTagRecovery".equals(ACTION)){
				giclClaimsService.updateLossTagRecovery(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLossExpenseHistory".equals(ACTION)){
				GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GICLClaimLossExpenseService giclClmLossExpServ = (GICLClaimLossExpenseService) APPLICATION_CONTEXT.getBean("giclClaimLossExpenseService");
				GIISPayeesService payeesService = (GIISPayeesService) APPLICATION_CONTEXT.getBean("giisPayeesService");
				String mortgClassCd = giacParamService.getParamValueV2("MORTGAGEE_CLASS_CD");
				
				request.setAttribute("defaultDistDate", new java.text.SimpleDateFormat("MM-dd-yyyy").format(new java.util.Date()));
				request.setAttribute("maxClmLossId", giclClmLossExpServ.getNextClmLossIdValue(claimId));
				request.setAttribute("showClaimStat", "Y");
				request.setAttribute("mortgClassCd", mortgClassCd);
				request.setAttribute("mortgClassDesc", payeesService.getPayeeClassDesc(mortgClassCd));
				request.setAttribute("depreciationCd", paramService.getParamValueV2("MC_DEPRECIATION_CD"));
				request.setAttribute("motorLineName", paramService.getParamValueV2("LINE_CODE_MC"));
				request.setAttribute("mcTowing", paramService.getParamValueV2("MC_TOWING_CD"));
				request.setAttribute("riPayeeClass", giacParamService.getParamValueV2("RI_PAYEE_CLASS"));
				request.setAttribute("assdClassCd", giacParamService.getParamValueV2("ASSD_CLASS_CD"));
				request.setAttribute("adjpClassCd", giacParamService.getParamValueV2("ADJP_CLASS_CD"));
				request.setAttribute("enableUpdateSettlementHist", paramService.getParamValueV2("ENABLE_UPDATE_SETTLEMENT_HIST"));
				request.setAttribute("checkPLA", giacParamService.getParamValueV2("CHECK_PLA"));
				request.setAttribute("enableLeBaseAmt", paramService.getParamValueV2("ENABLE_LE_BASE_AMT"));
				request.setAttribute("fromClaimMenu", request.getParameter("fromClaimMenu"));
				request.setAttribute("intmClassCd", giacParamService.getParamValueV2("INTM_CLASS_CD"));
				PAGE = "/pages/claims/lossExpenseHistory/lossExpenseHistMain.jsp";
			}else if("getClaimDetails".equals(ACTION)){
				JSONObject jsonGiclClaims = new JSONObject(giclClaimsService.getClaimsBasicInfoDtls(claimId) != null ? giclClaimsService.getClaimsBasicInfoDtls(claimId) : new GICLClaims()); //marco - 01.24.2013 - added nvl
				request.setAttribute("object", jsonGiclClaims == null ? "[]" : jsonGiclClaims);
				PAGE = "/pages/genericObject.jsp";
			}else if("checkUnpaidPremiums".equals(ACTION)){
				JSONObject json = new JSONObject(giclClaimsService.checkUnpaidPremiums(request, USER));
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("checkUnpaidPremiums2".equals(ACTION)){
				JSONObject json = new JSONObject(giclClaimsService.checkUnpaidPremiums2(request, USER));
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("validateRenewNoGIACS007".equals(ACTION)){
				message = giclClaimsService.validateRenewNoGIACS007(request, USER);
			}else if("showBatchClaimClosing".equals(ACTION)){ //zxc								
				request.setAttribute("statusControl", request.getParameter("statusControl"));
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/claims/batchClaimClosing/batchClaimClosing.jsp";
			} else if("refreshClaimClosingList".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClaimClosingTableGridListing");	
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GICLS039");
				params.put("clmLineCd", request.getParameter("clmLineCd"));
				params.put("clmSublineCd", request.getParameter("clmSublineCd"));
				params.put("clmIssCd", request.getParameter("clmIssCd"));
				params.put("clmYy", request.getParameter("clmYy"));
				params.put("clmSeqNo", request.getParameter("clmSeqNo"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("polIssueYy", request.getParameter("polIssueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("polRenewNo", request.getParameter("polRenewNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("remarks", request.getParameter("remarks")); //benjo 08.05.2015 UCPBGEN-SR-19632
				params.put("searchBy", request.getParameter("searchBy"));
				params.put("asOfDate", request.getParameter("asOfDate"));
				params.put("fromDate", request.getParameter("fromDate"));				
				params.put("toDate", request.getParameter("toDate"));
				params.put("statusControl", request.getParameter("statusControl"));
				Map<String, Object> claimClosingListTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(claimClosingListTableGrid);
				message = json.toString();				
				PAGE = "/pages/genericMessage.jsp";
			} else if("showQueryClaimsPage".equals(ACTION)){
				PAGE = "/pages/claims/batchClaimClosing/queryClaims.jsp";
			}else if("checkUserFunction".equals(ACTION)){ //zxc
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("functionCd", request.getParameter("functionCd"));
				System.out.println("checkUserFunction params:" + params);
				JSONObject json = new JSONObject(giclClaimsService.checkUserFunction(params));
				System.out.println("json:  " + json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("saveBatchClaimClosing".equals(ACTION)){ //zxc
				JSONObject objParams = new JSONObject(request.getParameter("parameter"));
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addModifiedClaims")), USER.getUserId(), GICLClaims.class));
				giclClaimsService.saveBatchClaimCLosing(params);
				
				message = "Saving successful.";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkClaimToOpen".equals(ACTION)){ //zxc
				System.out.println("checkClaimToOpen claimId: " + claimId);
				request.setAttribute("object", giclClaimsService.checkClaimToOpen(claimId));
				PAGE = "/pages/genericObject.jsp";
			}else if("openClaims".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("parameter"));
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addModifiedUnidentifiedCollns")), USER.getUserId(), GICLClaims.class));
				JSONObject json = new JSONObject(giclClaimsService.openClaims(params));
				System.out.println("json:  " + json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("reOpenClaims".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("parameter"));
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addModifiedUnidentifiedCollns")), USER.getUserId(), GICLClaims.class));
				giclClaimsService.reOpenClaimsGICLS039(params);

				PAGE = "/pages/genericMessage.jsp";
			}else if("confirmUserGICLS039".equals(ACTION)){
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("type", request.getParameter("type"));
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("clmYy", Integer.parseInt(request.getParameter("clmYy")));
				params.put("claimSequenceNo", Integer.parseInt(request.getParameter("clmSeqNo")));
				params.put("catastrophicCd", request.getParameter("catastrophicCd"));
				params.put("selectType", request.getParameter("selectType"));
				params.put("statusControl", Integer.parseInt(request.getParameter("statusControl")));
				params.put("catPaytResFlag", "");
				/*params.put("catDesc", "");
				params.put("alertMessage", "");*/
				JSONObject json = new JSONObject(giclClaimsService.confirmUserGICLS039(params));
				System.out.println("json:  " + json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("denyWithdrawCancelClaims".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("parameter"));

				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addModifiedUnidentifiedCollns")), USER.getUserId(), GICLClaims.class));
				params.put("statusControl", request.getParameter("statusControl"));

				message  = giclClaimsService.denyWithdrawCancelClaims(params);

				PAGE = "/pages/genericMessage.jsp";
			}else if("closeClaims".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("parameter"));

				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addModifiedUnidentifiedCollns")), USER.getUserId(), GICLClaims.class));
				params.put("closedStatus", "CD");//request.getParameter("closedStatus"));
				
				message  = giclClaimsService.closeClaims(params);

				PAGE = "/pages/genericMessage.jsp";
			}else if("checkClaimClosing".equals(ACTION)){
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("prntdFla", request.getParameter("prntdFla"));
				params.put("chkTag", request.getParameter("chkTag"));
				JSONObject json = new JSONObject(giclClaimsService.checkClaimClosing(params));
				System.out.println("json:  " + json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("validateFlaGICLS039".equals(ACTION)){
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				JSONObject json = new JSONObject(giclClaimsService.validateFlaGICLS039(params));
				System.out.println("json:  " + json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("showClmHistory".equals(ACTION)){ //added by cherrie 12.13.2012 - for GICLS254
				//giclClaimsService.showClaimsHistory(request, USER);
				PAGE = "/pages/claims/inquiry/claimHistory/claimHistoryMain.jsp";
			}else if("getClaimItemResDtls".equals(ACTION)){ //added by cherrie 12.18.2012 - for GICLS254 modified by adpascual
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClaimItemResDtls");
				params.put("claimId", request.getParameter("claimId"));
				
				JSONObject itemResObj = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("refresh"))){
					message = itemResObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("claimItemResDetailTableGrid", itemResObj);
					PAGE = "/pages/claims/inquiry/claimHistory/subpages/clmItemReserveDetail.jsp";
				}

				
			}else if("getClmItemHistDtls".equals(ACTION)){ //added by cherrie 12.18.2012 - for GICLS254 modified by adpascual
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClmItemHistDtls");
				params.put("claimId", request.getParameter("claimId"));
				
				if(request.getParameter("claimId") != null) {
					params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
					params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
					params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				}			
				
				JSONObject itemHistObj = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("refresh"))){
					message = itemHistObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("claimItemHistDetailTableGrid", itemHistObj);
					PAGE = "/pages/claims/inquiry/claimHistory/subpages/clmItemHistDetail.jsp";
				}
			}else if("getLossExpDisplay".equals(ACTION)){ //added by cherrie 12.18.2012 - for GICLS254
				//giclClaimsService.getLossExp(request, USER);
				PAGE = "/pages/claims/inquiry/claimHistory/claimHistoryMain.jsp";
			}else if("getClaimInformationTableGrid".equals(ACTION)){
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", lineCd);
				params.put("moduleId", "GICLS260");
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId")); //added claimId by robert SR 21694 03.28.16
				//params.put("lineName", request.getParameter("lineName"));
				
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("ora2010Sw", giisParametersService.getParamValueV2("ORA2010_SW"));
					request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
					request.setAttribute("lineCd", lineCd);
					//modified by MarkS 7.20.2016 SR5573
					System.out.println("triggered");
					if(json.getJSONArray("rows").length()<=0){
						//request.setAttribute("lineName", giisLineService.getGiisLineName2(lineCd));
						request.setAttribute("lineName", request.getParameter("lineName"));
					} else {
						request.setAttribute("lineName", json.getJSONArray("rows").getJSONObject(0).get("lineName")); //modified by gab 05.23.2016 SR  21694
					}
					//end SR5570
					request.setAttribute("jsonClaimInfoTableGrid", json);
					PAGE = "/pages/claims/inquiry/claimInformation/claimInformationListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getClaimInformationTableGrid2".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String issCd = request.getParameter("issCd");
				String issueYy = request.getParameter("issueYy");
				String polSeqNo = request.getParameter("polSeqNo");
				String renewNo = request.getParameter("renewNo");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClaimInformationTableGrid");
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("policyIssueCode", issCd);
				params.put("issueYy", issueYy);
				params.put("policySequenceNo", polSeqNo);
				params.put("renewNo", renewNo);
				params.put("moduleId", "GICLS260");
				params.put("userId", USER.getUserId());
				
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonClaimInfoTableGrid", json);
					PAGE = "/pages/claims/inquiry/claimInformation/claimInformationListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}	
			}else if("showClaimInformationMain".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				JSONObject json = new JSONObject(giclClaimsService.getGICLS260BasicInfoDetails(params));
				JSONObject var = new JSONObject(giclClaimsService.initializeGICLS260Variables(params));
				request.setAttribute("jsonGICLClaims", json);
				request.setAttribute("variables", var);
				request.setAttribute("callingForm", request.getParameter("callingForm"));
				request.setAttribute("callingForm2", request.getParameter("callingForm2"));
				PAGE = "/pages/claims/inquiry/claimInformation/claimInformationMain.jsp";
			}else if("showGICLS260TableGridPopup".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String action1 = request.getParameter("action1");
				params.put("ACTION", action1);
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("userId", USER.getUserId());
				
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				
				if("1".equals(request.getParameter("ajax"))){
					if(action1.equals("getProcessorHistTableGridListing")){
						request.setAttribute("jsonProcessorHist", json);
						PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/processorHistory.jsp";
					}else if(action1.equals("getStatHistTableGridListing")){
						request.setAttribute("jsonClaimStatHistory", json);
						PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/claimStatusHistory.jsp";
					}else if(action1.equals("getClmAdjusterListing")){
						request.setAttribute("jsonAdjuster", json);
						PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/adjuster.jsp";
					}else if(action1.equals("getBasicIntmDtls")){
						request.setAttribute("jsonClaimIntermediary", json);
						PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/intermediary.jsp";
					}else if(action1.equals("getGiclMortgageeGrid")){
						request.setAttribute("jsonClaimMortgagee", json);
						PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/mortgagee.jsp";
					}
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getGicls260RecoveryAmts".equals(ACTION)){
				giclClaimsService.getRecoveryAmounts(request, USER);
				PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/recoveryAmounts.jsp";
			}else if("showGicls260SurveySettlingAgent".equals(ACTION)){
				giclClaimsService.getRecoveryAmounts(request, USER);
				PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/surveySettlingAgent.jsp";
			}else if("showGICLS260OtherLinesItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getOtherLinesDtlGicls260");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/otherLines/otherLinesItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showClaimDistribution".equals(ACTION)){ // GICLS255 - Claims Distribution added by adpascual 06.2013
				PAGE = "/pages/claims/inquiry/claimDistribution/claimDistributionMain.jsp";
			}else if("getItemReserveInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClmReserveInfo");
				params.put("claimId", request.getParameter("claimId"));
				JSONObject resInfoObj = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("refresh"))){
					message = resInfoObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("itemReserveInfoTableGrid", resInfoObj);
					PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimReserveDist.jsp";
				}
			}else if("getReserveDs".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getReserveDs");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmResHistId", request.getParameter("clmResHistId"));
				System.out.println("params:::" + params);
				JSONObject resDsObj = new JSONObject(TableGridUtil.getTableGrid(request, params));
				System.out.println("result ::"+ resDsObj);
				// TODO - For debugging
				if("1".equals(request.getParameter("refresh"))){
					message = resDsObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("reserveDsInfoTableGrid", resDsObj);
					PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimReserveDist.jsp";
				}
				//temporary
				//request.setAttribute("reserveDsInfoTableGrid", resDsObj);
				//PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimReserveDist.jsp";
			}else if("getReserveDsRI".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getReserveDsRI");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmResHistId", request.getParameter("clmResHistId"));
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));
				params.put("clmDistNo", request.getParameter("clmDistNo"));
				System.out.println("params:::" + params);
				JSONObject resDsRI = new JSONObject(TableGridUtil.getTableGrid(request, params));
				System.out.println("result ::"+ resDsRI);
				if("1".equals(request.getParameter("refresh"))){
					message = resDsRI.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("reserveDsRIInfoTableGrid", resDsRI);
					PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimReserveDist.jsp";
				}
			} else if("getClmLossExpInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClmLossExpInfo");
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				JSONObject lossExpObj = new JSONObject(TableGridUtil.getTableGrid(request, params));
				//request.setAttribute("lossExpInfoTableGrid", lossExpObj);
				//PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimLossExpDist.jsp";
				if("1".equals(request.getParameter("refresh"))){
					message = lossExpObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					//System.out.println(lossExpObj);
					request.setAttribute("lossExpInfoTableGrid", lossExpObj);
					PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimLossExpDist.jsp";
				}
			}else if("getLossExpDisListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getLossExpDisListing");
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				JSONObject lossExpDisList = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("refresh"))){
					message = lossExpDisList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					System.out.println(lossExpDisList);
					request.setAttribute("lossExpDisList", lossExpDisList);
					PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimLossExpDist.jsp";
				}
			} else if("getLossExpRiDisListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getLossExpRiDisListing");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));
				params.put("clmDistNo", request.getParameter("clmDistNo"));
				JSONObject lossExpRiDisList = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("refresh"))){
					message = lossExpRiDisList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					System.out.println(lossExpRiDisList);
					request.setAttribute("lossExpRiDisList", lossExpRiDisList);
					PAGE = "/pages/claims/inquiry/claimDistribution/subpages/claimLossExpDist.jsp";
				}
			} else if("showReOpenRecovery".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "showReOpenRecovery");
				params.put("claimId", request.getParameter("claimId"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));	//Gzelle 09172015 SR3292
				JSONObject reOpenRecovery = new JSONObject(TableGridUtil.getTableGrid(request, params));
				request.setAttribute("reOpenRecovery", reOpenRecovery);
				PAGE = "/pages/claims/reOpenRecovery/reOpenRecovery.jsp";
				if("1".equals(request.getParameter("refresh"))){
					message = reOpenRecovery.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					System.out.println(reOpenRecovery);
					request.setAttribute("reOpenRecovery", reOpenRecovery);
					PAGE = "/pages/claims/reOpenRecovery/reOpenRecovery.jsp";
				}
			} else if("gicls125ReopenRecovery".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giclClaimsService.gicls125ReopenRecovery(request, USER))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGiacParameterStatus".equals(ACTION)){
				giclClaimsService.validateGiacParameterStatus(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGICLS010Line".equals(ACTION)){
				message = giclClaimsService.validateGICLS010Line(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGICLS273".equals(ACTION)){
				JSONObject json = giclClaimsService.showGicls273(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/claims/inquiry/exGratiaClaimsInquiry/exGratiaClaimsInquiry.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}	
			} else if("showGICLS273PaymentDetails".equals(ACTION)){
				JSONObject json = giclClaimsService.showGicls273PaymentDetails(request, USER.getUserId());
				request.setAttribute("searchBy", request.getParameter("searchBy"));
				request.setAttribute("asOfDate", request.getParameter("asOfDate"));
				request.setAttribute("fromDate", request.getParameter("fromDate"));
				request.setAttribute("toDate", request.getParameter("toDate"));
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/claims/inquiry/exGratiaClaimsInquiry/subPages/paymentDetails.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}				
			}  else if("checkSharePercentage".equals(ACTION)){ //added by carlo SR-5900 01-06-2017
				message = giclClaimsService.checkSharePercentage(request);
				PAGE = "/pages/genericMessage.jsp";	
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){  //to handle customize ORACLE Error.
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			}else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

	public Map<String, Object> determineService(HttpServletRequest request,
			HttpServletResponse response, Map<String, Object> params,
			String lovSelected) throws SQLException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader
				.getServletContext(getServletContext());

		params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("moduleId", "GICLS010");
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
		params.put("claimId", request.getParameter("claimId"));
		if ("clmProcessorLov".equals(lovSelected)) {
			GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
			params = userService.getUserByIssCd(params);
			Debug.print("PROC PARAMS: " + params);
		} else if ("clmCatLov".equals(lovSelected)) {
			GICLCatDtlService catService = (GICLCatDtlService) APPLICATION_CONTEXT.getBean("giclCatDtlService");
			params = catService.getCatDtls(params);
		} else if ("clmLossCatLov".equals(lovSelected)) {
			GIISLossCtgryService lossCatService = (GIISLossCtgryService) APPLICATION_CONTEXT.getBean("giisLossCtgryService");
			params = lossCatService.getLossDtls(params);
			Debug.print("clmLossCatLov params: " + params);
		} else if ("clmProvinceLov".equals(lovSelected)) {
			GIISProvinceService provinceService = (GIISProvinceService) APPLICATION_CONTEXT.getBean("giisProvinceService");
			params = provinceService.getProvinceDtls(params);
		} else if ("clmCityLov".equals(lovSelected)) {
			GIISCityService cityService = (GIISCityService) APPLICATION_CONTEXT.getBean("giisCityService");
			params = cityService.getCityDtls(params);
		} else if ("clmStatLov".equals(lovSelected)) {
			GIISClmStatService clmstatService = (GIISClmStatService) APPLICATION_CONTEXT.getBean("giisClmStatService");
			params = clmstatService.getClmStatDtls(params);
		} else if ("clmAssuredLov".equals(lovSelected)) {
			GICLClaimsService giclClaimsService = (GICLClaimsService) APPLICATION_CONTEXT.getBean("giclClaimsService");
			params = giclClaimsService.getClmAssuredDtls(params);
		} else if ("clmPlateNoLov".equals(lovSelected)) {
			GIPIVehicleService gipiVehicleService = (GIPIVehicleService) APPLICATION_CONTEXT.getBean("gipiVehicleService");
			params = gipiVehicleService.getPlateDtl(params);
		} else if ("clmMotorNoLov".equals(lovSelected)) {
			GIPIVehicleService gipiVehicleService = (GIPIVehicleService) APPLICATION_CONTEXT.getBean("gipiVehicleService");
			params = gipiVehicleService.getMotorDtl(params);
		} else if ("clmSerialNoLov".equals(lovSelected)) {
			GIPIVehicleService gipiVehicleService = (GIPIVehicleService) APPLICATION_CONTEXT.getBean("gipiVehicleService");
			params = gipiVehicleService.getSerialDtl(params);
		} else if ("clmDistrictLov".equals(lovSelected)) {
			GIISBlockService districtService = (GIISBlockService) APPLICATION_CONTEXT.getBean("giisBlockService");
			params = districtService.getDistrictLovGICLS010(params);
		} else if ("clmBlockLov".equals(lovSelected)) {
			GIISBlockService districtService = (GIISBlockService) APPLICATION_CONTEXT.getBean("giisBlockService");
			params = districtService.getBlockLovGICLS010(params);
		} else if ("clmPayee".equals(lovSelected)){
			GIISPayeesService payeesService = (GIISPayeesService) APPLICATION_CONTEXT.getBean("giisPayeesService");
			params = payeesService.getPayeeByAdjusterListing(params);
		} else if ("clmPayee2".equals(lovSelected)){
			GIISPayeesService payeesService = (GIISPayeesService) APPLICATION_CONTEXT.getBean("giisPayeesService");
			params = payeesService.getPayeeByAdjusterListing2(params);
		} 	
		return params;
	}

}
