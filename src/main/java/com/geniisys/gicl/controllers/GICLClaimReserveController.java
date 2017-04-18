/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Jan 12, 2012
 ***************************************************/
package com.geniisys.gicl.controllers;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.entity.GICLClaimReserve;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.entity.GICLClmResHist;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLAccidentDtlService;
import com.geniisys.gicl.service.GICLCasualtyDtlService;
import com.geniisys.gicl.service.GICLClaimReserveService;
import com.geniisys.gicl.service.GICLClaimsService;
import com.geniisys.gicl.service.GICLClmResHistService;
import com.geniisys.gicl.service.GICLItemPerilService;
import com.geniisys.gicl.service.GICLReserveDsService;
import com.geniisys.gicl.service.GICLReserveRidsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GICLClaimReserveController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLClaimReserveController.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing claim reserve controller: action=" + ACTION);
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLClaimReserveService giclClaimReserveService = (GICLClaimReserveService) APPLICATION_CONTEXT.getBean("giclClaimReserveService");
		GICLClmResHistService giclClmResHistService = (GICLClmResHistService) APPLICATION_CONTEXT.getBean("giclClmResHistService");
		GICLReserveDsService giclReserveDsService = (GICLReserveDsService) APPLICATION_CONTEXT.getBean("giclReserveDsService");
		GICLReserveRidsService giclReserveRidsService = (GICLReserveRidsService) APPLICATION_CONTEXT.getBean("giclReserveRidsService");
		GICLClaimsService giclClaimsService = (GICLClaimsService) APPLICATION_CONTEXT.getBean("giclClaimsService");
		GICLItemPerilService giclItemPerilService = (GICLItemPerilService) APPLICATION_CONTEXT.getBean("giclItemPerilService");
		
		try{
			if("showGICLS024ClaimReserve".equals(ACTION)){
				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid4");
				params.put("claimId", claimId);
				Map<String, Object> itemInfoGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(itemInfoGrid);
				GICLClaims claims = giclClaimsService.getRelatedClaimsGICLS024(claimId);
				request.setAttribute("giclItemPerilList", json);
				request.setAttribute("objGICLClaims", new JSONObject((GICLClaims)StringFormatter.replaceQuotesInObject(claims)));
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
				if(claims.getLineCd().equals("SU")){
					GICLItemPeril itemPerilSU = giclItemPerilService.getGICLS024ItemPeril(claimId);
					System.out.println("ROBERRRRRRRRRRRRRRRRRRRRRT "+itemPerilSU);
					System.out.println(itemPerilSU.equals(null));
					System.out.println(itemPerilSU.equals(""));
					System.out.println("ROBERRRRRRRRRRRRRRRRRRRRRT "+itemPerilSU);
					request.setAttribute("objItemtemPerilSU", new JSONObject((GICLItemPeril)StringFormatter.replaceQuotesInObject(itemPerilSU)));
				}
				String grouped = "FALSE";
				String lineCodeAC = giisParametersService.getParamValueV2("LINE_CODE_AC");
				String lineCodeCA = giisParametersService.getParamValueV2("LINE_CODE_CA");
				if(claims.getLineCd().equals(lineCodeAC) || claims.getLineCd().equals(lineCodeCA)){
					Integer groupItemNo= giclItemPerilService.checkIfGroupGICLS024(claimId);
					if(groupItemNo != 0){
						grouped = "TRUE";
					}
				}
				request.setAttribute("grouped", grouped);
				request.setAttribute("vars", new JSONObject(StringFormatter.escapeHTMLInMap(this.gicls024PrepareOtherVars(APPLICATION_CONTEXT, USER.getUserId()))));
				request.setAttribute("lineCd", claims.getLineCd());
				request.setAttribute("bkngDateExist", giclClaimReserveService.chckBkngDteExist(claimId));
				request.setAttribute("orCnt", giclClaimReserveService.gicls024OverrideCount(claimId));
				PAGE = "/pages/claims/reserveSetup/claimReserve1/claimReserve.jsp";
			}else if("refreshClaimReserveListing".equals(ACTION)){ 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid4");
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				message = (new JSONObject(params)).toString();			
				PAGE = "/pages/genericMessage.jsp";
			}else if("getClmResHistListing".equals(ACTION) || "showResHistOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				if("getClmResHistListing".equals(ACTION)){
					params.put("ACTION", "getGiclClmResHistGrid4");
				}else{
					params.put("ACTION", "getResHistTranIdNull");
				}
				params.put("claimId", request.getParameter("claimId").equals("") ? 0 : Integer.parseInt(request.getParameter("claimId")));
				params.put("itemNo", request.getParameter("itemNo").equals("") ? 0 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("perilCd", request.getParameter("perilCd").equals("") ? 0 : Integer.parseInt(request.getParameter("perilCd")));
				Map<String, Object> perilInfoTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(perilInfoTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if ("showResHistOverlay".equals(ACTION)){
					request.setAttribute("resHistTableGrid", json);
					PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/reserveHistoryOverlay.jsp";
				}
			}else if("showDistDtlsOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmResHistId", request.getParameter("clmResHistId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("ACTION", "getGiclReserveDsGrid3");
				//params.put("pageSize", 3);
				Map<String, Object> reserveDSTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(reserveDSTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("reserveDsTG", json);
					PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/distributionDtlsOverlay.jsp";
				}
			}else if("showPaymentHistOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("ACTION", "getPaymentHistoryGrid");
				params.put("pageSize", 3);
				Map<String, Object> jsonPaymentHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(jsonPaymentHistoryTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonPaymentHistoryTableGrid", json);
					PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/paymentHistOverlay.jsp";
				}				
			}else if("showXolDeducOverlay".equals(ACTION)){
					PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/xolDeducOverlay.jsp";
			} else if("gicls024ChckLossRsrv".equals(ACTION)) {
				message = giclClaimReserveService.gicls024ChckLossRsrv(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshReserveRidsTG".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmResHistId", request.getParameter("clmResHistId"));
				params.put("clmDistNo", request.getParameter("clmDistNo")); 
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));				
				params.put("ACTION", "getResRidsGrid");
				params.put("pageSize", 3);
				Map<String, Object> reserveRIDSTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(reserveRIDSTableGrid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICL024ClaimReserve".equals(ACTION)){
//				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				Map<String, Object> values = giclClaimReserveService.getClaimReserveInitValues(request);
				GICLClaims claims = (GICLClaims) values.get("claims");
				request.setAttribute("claims", claims);
				
				GICLClaimReserve reserve = null;
				if(values.containsKey("R")){
					reserve = (GICLClaimReserve)values.get("claimReserve");
				}
				
				GICLClmResHist giclClmResHist = null;
				if(values.containsKey("giclClmResHist")){
					giclClmResHist = (GICLClmResHist)values.get("giclClmResHist");
				}
				
				if(giclClmResHist!=null){
					request.setAttribute("objGICLClmResHist", new JSONObject((GICLClmResHist)StringFormatter.replaceQuotesInObject(giclClmResHist)));
				}else{
					request.setAttribute("objGICLClmResHist", null);
				}
				
				request.setAttribute("objGICLClaimReserve", reserve != null ? new JSONObject((GICLClaimReserve)StringFormatter.replaceQuotesInObject(reserve)): null);
				request.setAttribute("objGICLClaims", new JSONObject((GICLClaims)StringFormatter.replaceQuotesInObject(claims)));
				request.setAttribute("vars", new JSONObject(StringFormatter.escapeHTMLInMap(this.gicls024PrepareOtherVars(APPLICATION_CONTEXT, USER.getUserId()))));
				PAGE = "/pages/claims/reserveSetup/claimReserve/claimReserve.jsp";
			}else if("getDistributionDetails".equals(ACTION)){
				PAGE = "/pages/claims/reserveSetup/claimReserve/subPages/distributionDetails.jsp";
			}else if("getReserveDs".equals(ACTION)){ 
				giclReserveDsService.getGiclReserveDsGrid2(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/claimReserve/subPages/reserveDsTableGridListing.jsp";
			}else if("getReserveRids".equals(ACTION)){ 
				giclReserveRidsService.getReserveRidsGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/claimReserve/subPages/reserveRidsTableGridListing.jsp";
			}else if("showClaimReserveItemInfoGrid".equals(ACTION)){
				giclItemPerilService.getGiclItemPerilGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/claimReserve/subPages/itemInformationTableGridListing.jsp";
			}else if("getClmResHistGrid".equals(ACTION)){
				giclClmResHistService.getGiclClmResHistGrid3(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/claimReserve/subPages/claimResHistTableGridListing2.jsp";
			}else if("getItemPerilGrid".equals(ACTION)){ 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid4");
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				Map<String, Object> attrMap = (HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params);
				String json = new JSONObject(attrMap).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giclItemPerilList", json);
					PAGE = "/pages/claims/reserveSetup/claimReserve/subPages/itemInformationTableGridListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getClaimReserve".equals(ACTION)){
				giclClmResHistService.getGiclClmResHistGridByItem(request, USER);
				GICLClaimReserve reserve = giclClaimReserveService.getClaimReserve(request);
				GICLClmResHist resHist = giclClmResHistService.getLatestClmResHist(request, USER);
				request.setAttribute("objLastGICLClmResHist", resHist != null ? new JSONObject((GICLClmResHist) StringFormatter.replaceQuotesInObject(resHist)): /*null*/ new JSONObject()); // replaced by: Nica 06.14.2012 - to prevent JSON.parse error
				/*remove later*/request.setAttribute("objGICLClaimReserve", reserve != null ? new JSONObject((GICLClaimReserve) StringFormatter.replaceQuotesInObject(reserve)): /*null*/ new JSONObject());
				PAGE = "/pages/claims/reserveSetup/claimReserve/subPages/claimReserveSubpage.jsp";
			} else if("showUpdateStatusOverlay".equals(ACTION)){ // andrew 04.10.2012
				PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/updateStatus.jsp"; //modified by robert 12.12.12
			} else if("showConfirmationOverlay".equals(ACTION)){ // andrew 04.10.2012
				PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/confirmationOverlay.jsp"; //modified by robert 04.03.2013
			} else if("showDistributionDateOverlay".equals(ACTION)){ // roy 04.12.2012
				PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/distributionDateOverlay.jsp"; //modified by robert 12.12.12
			} else if("showReserveHistoryOverlay".equals(ACTION)){ // roy 04.12.2012
				PAGE = "/pages/claims/reserveSetup/claimReserve/subPages/reserveHistoryOverlay.jsp";
			} else if("getPreValidationParams".equals(ACTION)) { // andrew 04.11.2012
				JSONObject json = giclClaimReserveService.getPreValidationParams(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("updateStatus".equals(ACTION)){
				giclClaimReserveService.updateStatus(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showAvailmentsOverlay".equals(ACTION)){ //udel 4.11.2012
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				String lineCodeAc = giisParameterService.getParamValueV2("LINE_CODE_AC");
				String lineCodeCa = giisParameterService.getParamValueV2("LINE_CODE_CA");
				Map<String, Integer> groupedItemParams = new HashMap<String, Integer>();
				groupedItemParams.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				groupedItemParams.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				groupedItemParams.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				String lineCd = request.getParameter("lineCd");
				boolean showGroupedItemNo;
				
				if (lineCodeAc.equals(lineCd) || lineCodeCa.equals(lineCd)){
					if (0 == Integer.parseInt(request.getParameter("groupedItemNo"))){
						showGroupedItemNo = false;
					} else {
						showGroupedItemNo = true;
						if (lineCodeAc.equals(lineCd)){
							GICLAccidentDtlService giclAccidentDtlService = (GICLAccidentDtlService) APPLICATION_CONTEXT.getBean("giclAccidentDtlService");
							request.setAttribute("groupedItemTitle", giclAccidentDtlService.getGroupedItemTitle(groupedItemParams));
						} else if (lineCodeCa.equals(lineCd)){
							GICLCasualtyDtlService giclCasualtyDtlService = (GICLCasualtyDtlService) APPLICATION_CONTEXT.getBean("giclCasualtyDtlService");
							request.setAttribute("groupedItemTitle", giclCasualtyDtlService.getCasualtyGroupedItemTitle(groupedItemParams));
						}
					}
				} else {
					showGroupedItemNo = false;
				}
				request.setAttribute("showGroupedItemNo", showGroupedItemNo);
				PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/availments.jsp"; //modified by robert 12.12.12
			
			} else if ("getAvailmentsTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
				params.put("noOfDays", Integer.parseInt(request.getParameter("noOfDays").equals("") ? "0" : request.getParameter("noOfDays").equals("null")?"0":request.getParameter("noOfDays")));
				params.put("ACTION", ACTION);
				params.put("moduleId", request.getParameter("moduleId") == null ? "GICLS024" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				
				Map<String, Object> availmentsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonAvailmentsTableGrid = new JSONObject(availmentsTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonAvailmentsTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonAvailmentsTableGridList", jsonAvailmentsTableGrid);
					Map<String, Object> availmentTotals = giclClaimReserveService.getAvailmentTotals(params);
					request.setAttribute("sumLossReserve", availmentTotals.get("sumLossReserve"));
					request.setAttribute("sumPaidAmt", availmentTotals.get("sumPaidAmt"));
					request.setAttribute("sumNoOfUnits", availmentTotals.get("sumNoOfUnits"));
					PAGE = "/pages/claims/reserveSetup/claimReserve1/subPages/availmentsTableGridListing.jsp"; //modified by robert 12.12.12
				}
			} else if("checkUWDist".equals(ACTION)) { //darwin
				message = giclClaimReserveService.checkUWDist(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("redistributeReserve".equals(ACTION)) {
				message = giclClaimReserveService.redistributeReserve(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			
			} else if ("showPaymentHistoryOverlay".equals(ACTION)){ // Udel 4.13.2012
				PAGE = "/pages/claims/reserveSetup/claimReserve/subPages/paymentHistory.jsp";
			
			} else if ("getPaymentHistoryTableGrid".equals(ACTION)){ // Udel 4.13.2012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("ACTION", "getPaymentHistoryGrid");
				params.put("moduleId", request.getParameter("moduleId") == null ? "GICLS024" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> paymentHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonPaymentHistoryTableGrid = new JSONObject(paymentHistoryTableGrid);
				JSONArray rows = jsonPaymentHistoryTableGrid.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgCancelTag", (rows.getJSONObject(i).getString("cancelTag").equals("Y") ? true : false));
				}
				jsonPaymentHistoryTableGrid.remove("rows");
				jsonPaymentHistoryTableGrid.put("rows", rows);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPaymentHistoryTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonPaymentHistoryTableGridList", jsonPaymentHistoryTableGrid);
					PAGE = "/pages/claims/reserveSetup/claimReserve/subPages/paymentHistoryTableGridListing.jsp";
				}
			
			} else if ("setPaytHistoryRemarks".equals(ACTION)){ // Udel 4.13.2012
				giclClmResHistService.setPaytHistoryRemarks(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			
			} else if ("checkPaytHistory".equals(ACTION)){
				GICLClmResHist reserveHistoryRec = new GICLClmResHist(Integer.parseInt(request.getParameter("claimId")),
						Integer.parseInt(request.getParameter("itemNo")), Integer.parseInt(request.getParameter("perilCd")), Integer.parseInt(request.getParameter("groupedItemNo")));
				if (giclClmResHistService.isPaytHistoryExists(reserveHistoryRec)){
					message = "EXISTS";
				} else {
					message = "NOT_EXISTS";
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveReserveDs".equals(ACTION)){
				message = giclReserveDsService.saveReserveDs(request, USER);
				giclReserveDsService.getGiclReserveDsGrid2(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/claimReserve/subPages/reserveDsTableGridListing.jsp";
			}else if("saveReserveRids".equals(ACTION)){
				message = giclReserveDsService.saveReserveDs(request, USER);
				giclReserveRidsService.getReserveRidsGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/claimReserve/subPages/reserveRidsTableGridListing.jsp";
			}else if ("checkLossRsrv".equals(ACTION)) {
				message = giclClaimReserveService.checkLossRsrv(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("gicls024OverrideExpense".equals(ACTION)) {
				message = giclClaimReserveService.gicls024OverrideExpense(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("createOverrideRequest".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("userId", USER.getUserId());
				params.put("ovrRemarks", request.getParameter("ovrRemarks"));
				giclClaimReserveService.createOverrideRequest(params);
				message="SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveReserveRemarks".equals(ACTION)){
				log.info("Save Reserve Remarks");
				giclClmResHistService.updateClaimResHistRemarks(request, USER);
				giclClmResHistService.getGiclClmResHistGridByItem(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveClaimReserve".equals(ACTION)){
				message = giclClaimReserveService.saveClaimReserve(request, USER.getUserId());
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateExistingDistGICLS024".equals(ACTION)){
				Map<String, Object> params = giclClaimReserveService.validateExistingDistGICLS024(request);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params));
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("showGICLS260ClaimReserve".equals(ACTION)){
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid5");
				params.put("claimId", request.getParameter("claimId"));
				
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonClaimReserveItemPeril", json);
					PAGE = "/pages/claims/inquiry/claimInformation/claimReserve/claimReserve.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260ClaimReserveOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String action1 = request.getParameter("action1");
				params.put("ACTION", action1);
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
				params.put("clmResHistId", request.getParameter("clmResHistId"));
				params.put("userId", USER.getUserId());
				params.put("pageSize", 5);
				
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				
				if("1".equals(request.getParameter("ajax"))){
					if(action1.equals("getGiclReserveDsGrid3")){
						request.setAttribute("jsonReserveDS", json);
						PAGE = "/pages/claims/inquiry/claimInformation/claimReserve/overlay/reserveDistDetails.jsp";
					}else if(action1.equals("getPaymentHistoryGrid")){
						request.setAttribute("jsonPaymentHistory", json);
						PAGE = "/pages/claims/inquiry/claimInformation/claimReserve/overlay/paymentHistory.jsp";
					}else if(action1.equals("getResHistTranIdNull")){
						request.setAttribute("jsonReserveHistory", json);
						PAGE = "/pages/claims/inquiry/claimInformation/claimReserve/overlay/reserveHistory.jsp";
					}
					request.setAttribute("itemNo", request.getParameter("itemNo"));
					request.setAttribute("perilCd", request.getParameter("perilCd"));
					request.setAttribute("groupedItemNo", request.getParameter("groupedItemNo"));
					request.setAttribute("clmResHistId", request.getParameter("clmResHistId"));
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showCLMBatchRedistribution".equals(ACTION)){ // J. Diago 09.02.2013
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", (request.getParameter("lineCd") != null && !request.getParameter("lineCd").equals("")) ? request.getParameter("lineCd") : null);
				params.put("sublineCd", (request.getParameter("sublineCd") != null && !request.getParameter("sublineCd").equals("")) ? request.getParameter("sublineCd") : null);
				params.put("issCd", (request.getParameter("issCd") != null && !request.getParameter("issCd").equals("")) ? request.getParameter("issCd") : null);
				params.put("userId", USER.getUserId());
				
				String andAmount = (request.getParameter("andAmount") == null || request.getParameter("andAmount") == "") ? "" : "AND " + request.getParameter("andAmount");
				params.put("andAmount", andAmount);
				
				String andDate = (request.getParameter("andDate") == null || request.getParameter("andDate") == "") ? "" : "AND " + request.getParameter("andDate");
				params.put("andDate", andDate);
				
				String newAction = (request.getParameter("currentView") != null && !request.getParameter("currentView").equals("") && request.getParameter("currentView").equals("R")) ? "getReserveListing" : "getLossExpenseListing";
				params.put("ACTION", newAction);
				params = TableGridUtil.getTableGrid(request, params);
				request.setAttribute("batchRedistList", params != null ? new JSONObject(params) : new JSONObject());
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("currentView", request.getParameter("currentView"));
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else {
					if(request.getParameter("currentView").equals("R")){
						PAGE = "/pages/claims/batchClaimRedist/batchRedistReserve.jsp";
					} else {
						PAGE = "/pages/claims/batchClaimRedist/batchRedistLossExpense.jsp";
					}
				}
			}else if("redistributeReserveGICLS038".equals(ACTION)){ // J. Diago 09.03.2013
				log.info("Redistributing Reserve GICLS038...");
				message = giclClaimReserveService.redistributeReserveGICLS038(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("redistributeLossExpenseGICLS038".equals(ACTION)){ // J. Diago 09.03.2013
				log.info("Redistributing Loss/Expense GICLS038...");
				message = giclClaimReserveService.redistributeLossExpenseGICLS038(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showReasonTextOverlay".equals(ACTION)){ // J. Diago 09.03.2013
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows"))));
				params = TableGridUtil.getTableGridCustomTable(params);
				request.setAttribute("reasonTxtList", params != null ? new JSONObject(params) : new JSONObject());
				String path = request.getSession().getServletContext().getRealPath("");
				String destination = path + "/GICLS038_LOGS\\";
				File destinationFolder = new File(destination);
				
				if(!destinationFolder.exists())
					destinationFolder.mkdirs();
				
				SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyHHmmss");
				String fileName = path + "\\GICLS038_LOGS\\GICLS038_" + USER.getUserId() + "_" + sdf.format(new Date()) + ".txt";
				File file = new File(fileName);
				
				if(!file.exists())
					file.createNewFile();
				
				PrintWriter pw = new PrintWriter(fileName, "UTF-8");
				
				for (int count = 0; count < JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows"))).size(); count++) {
					pw.println(JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows"))).get(count));
					pw.println();
				}
				
				pw.close();
				
				BufferedReader reader = new BufferedReader(new FileReader(fileName));
				String line = "", oldText = "";
				
				while((line = reader.readLine()) != null){
					oldText += line + "";
				}
				reader.close();
				
				String newText = oldText.replaceAll("\\{pMessage=", "");
				String toWrite = newText.replaceAll("\\}", System.getProperty("line.separator"));
				
				FileWriter writer = new FileWriter(fileName);
				writer.write(toWrite);
				writer.close();
				
				request.setAttribute("savePath", request.getHeader("Referer") + "GICLS038_LOGS/" + "GICLS038_" + USER.getUserId() + "_" + sdf.format(new Date()) + ".txt");
				request.setAttribute("destination", destination.replaceAll("\\\\", "/"));
				request.setAttribute("fileName", "GICLS038_" + USER.getUserId() + "_" + sdf.format(new Date()) + ".txt");
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/claims/batchClaimRedist/reasonText.jsp";
			}else if("showRedistParamOverlay".equals(ACTION)){ // J. Diago 09.04.2013
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("currentView", request.getParameter("currentView"));
				PAGE = "/pages/claims/batchClaimRedist/batchRedisParamOverlay.jsp";
			}else if ("deleteCopiedFile".equals(ACTION)){ // J. Diago 02.12.2014
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/")+1, url.length());
				log.info("Deleting copiedFile " + fileName + "...");
				(new File(realPath + "\\GICLS038_LOGS\\" + fileName)).delete();
			} else if ("createOverrideBasicInfo".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				params.put("ovrRemarks", request.getParameter("ovrRemarks"));
				giclClaimReserveService.createOverrideBasicInfo(params);
				message="SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			System.out.println("ERROR CD: "+e.getErrorCode());
			if(e.getErrorCode() > 20000){
				System.out.println("here");
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("" + e.getMessage());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			System.out.println("ACTION : " + ACTION);
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private Map<String, Object> gicls024PrepareOtherVars(ApplicationContext appContext, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) appContext.getBean("giisParameterFacadeService");
		GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) appContext.getBean("giacParameterFacadeService");
		GIACModulesService giacModuleService = (GIACModulesService) appContext.getBean("giacModulesService");
		params.put("validatePayt", giisParamService.getParamValueV2("VALIDATE RESERVE PAYMENT"));
		params.put("branchCode", giacParamService.getParamValueV2("BRANCH_CD"));
		params.put("bookParam", giacParamService.getParamValueV2("RESERVE_BOOKING"));
		params.put("validateReserveLimits", giisParamService.getParamValueV2("VALIDATE_RESERVE_LIMITS")); 
		Map<String, Object> userParams = new HashMap<String, Object>(); 
		userParams.put("user", userId);
		userParams.put("moduleName", "GICLS024");
		userParams.put("funcCode", "RO");
		params.put("userOverride", giacModuleService.validateUserFunc3(userParams));
		
		return params;
	}
}