/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLMcEvaluationController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jan 13, 2012
	Description: 
*/

package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACFunctionService;
import com.geniisys.gicl.entity.GICLMcEvaluation;
import com.geniisys.gicl.service.GICLMcEvaluationService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLMcEvaluationController", urlPatterns={"/GICLMcEvaluationController"})
public class GICLMcEvaluationController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 6515163305257997272L;
	private static Logger log = Logger.getLogger(GICLMcEvaluationController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLMcEvaluationController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLMcEvaluationService giclMcEvaluationService = (GICLMcEvaluationService) APPLICATION_CONTEXT.getBean("giclMcEvaluationService");
		PAGE = "/pages/genericMessage.jsp";
		try{
			if ("showMcEvaluationReport".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>(); // add parameters if needed - irwin
				params = giclMcEvaluationService.getVariables(params);
				
				request.setAttribute("variablesObj", QueryParamGenerator.generateQueryParams(params));
				PAGE = "/pages/claims/mcEvaluationReport/mcEvaluationReportMain.jsp";
			}else if ("getPolInfo".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("clmYy", Integer.parseInt(request.getParameter("clmYy")));
				params.put("clmSeqNo", Integer.parseInt(request.getParameter("clmSeqNo")));
				params.put("userId", USER.getUserId());
				params = giclMcEvaluationService.getClaimPolicyInfo(params);
				message = (params !=null ? new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString() : "No Evaluation Record Existing.");
			}else if ("getMcEvaluationTGList".equals(ACTION)) {
				giclMcEvaluationService.getMcEvaluationTGList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/subpages/mcEvaluationTGListing.jsp";
				}
			}else if("getMcEvalItemTGList".equals(ACTION)){ //added by robert SR 13692
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("clmYy", request.getParameter("clmYy"));
				params.put("clmSeqNo", request.getParameter("clmSeqNo"));
				params.put("userId", USER.getUserId());
				params.put("ACTION", "getMcEvalItemTGList");
				Map<String, Object> mcEvalItemTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(mcEvalItemTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("mcEvalItemTg", json);
					PAGE = "/pages/claims/mcEvaluationReport/subpages/mcEvalItemTGListing.jsp";
				}
			}else if("showAddNewReportOverlay".equals(ACTION)){
				PAGE = "/pages/claims/mcEvaluationReport/overlay/addReportOverlay.jsp";
			}else if ("saveMCEvaluationReport".equals(ACTION)) {
				giclMcEvaluationService.saveMCEvaluationReport(new JSONObject(request.getParameter("parameters")), USER);
				message = "SUCCESS";
			}else if("updateMcEvaluationReport".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				JSONObject json = new JSONObject(request.getParameter("parameters"));
				params.put("userId", USER.getUserId());
				params.put("json", json);
				giclMcEvaluationService.updateMcEvaluationReport(params);
				message = "SUCCESS";
			}else if ("cancelMcEvalreport".equals(ACTION)) {
				GICLMcEvaluation giclEval = (GICLMcEvaluation) JSONUtil.prepareObjectFromJSON(new JSONObject(request.getParameter("selectedMcEvalObj")), USER.getUserId(), GICLMcEvaluation.class);
				giclMcEvaluationService.cancelMcEvalreport(giclEval, USER.getUserId());
				message = "SUCCESS";
			}else if ("getVehicleInformation".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				log.info("TP_SW is: "+params.get("tpSw"));
				if(params.get("tpSw").equals("Y")){
					request.setAttribute("vehicleInfoObj", new JSONObject( StringFormatter.escapeHTMLInObject( giclMcEvaluationService.getGiclMcTpDtlVehicleInfo(params))));
				}else{
					request.setAttribute("vehicleInfoObj", new JSONObject(StringFormatter.escapeHTMLInMap(giclMcEvaluationService.getGiclMotorCarDtlVehicleInfo(params))));
				}
				PAGE = "/pages/claims/mcEvaluationReport/overlay/vehicleInformation.jsp";
			}else if ("validateBeforePostMap".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
				params.put("evalId", Integer.parseInt(request.getParameter("evalId")));
				params.put("issCd",request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				giclMcEvaluationService.validateBeforePostMap(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if("postEvalReport".equals(ACTION)){
				try {
					Map<String, Object>params = FormInputUtil.getFormInputs(request);
					params.put("userId", USER.getUserId());
					log.info("postEvalReport");
					giclMcEvaluationService.postEvalReport(params);
					message = "SUCCESS";
				} catch(SQLException e){
					if(e.getErrorCode() > 20000){
						message = ExceptionHandler.extractSqlExceptionMessage(e);
						ExceptionHandler.logException(e);
					} else {
						message = ExceptionHandler.handleException(e, USER);
					}
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("createSettlementForReport".equals(ACTION)) {
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				log.info("createSettlementForReport");
				giclMcEvaluationService.createSettlementForReport(params);
				message = "SUCCESS";
			}else if("showOverrideUserMCEval".equals(ACTION)){
				PAGE = "/pages/claims/mcEvaluationReport/overlay/overrideUserMcEval.jsp";
			}else if ("validateOverride".equals(ACTION)) {
				GIISUserFacadeService giisUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params.put("resAmt", new BigDecimal(request.getParameter("resAmt")));
				params.put("giclMcEvaluationService", giclMcEvaluationService);
				message = QueryParamGenerator.generateQueryParams(giisUserService.userOverideMCEval(params));
			}else if("createSettlementForLossExpEvalReport".equals(ACTION)){
				giclMcEvaluationService.createSettlementForLossExpEvalReport(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("popGiclMcEval".equals(ACTION)) {
				Map<String, Object> params  = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId").equals("") ? null : Integer.parseInt(request.getParameter("claimId")));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("clmYy", request.getParameter("clmYy").equals("") ? null : Integer.parseInt(request.getParameter("clmYy")));
				params.put("clmSeqNo", request.getParameter("clmSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("clmSeqNo")));
				params.put("userId",USER.getUserId());
				
				giclMcEvaluationService.popGiclMcEval(params);
				//message = QueryParamGenerator.generateQueryParams(params);
				message = new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
			}else if ("showOverrideRequest".equals(ACTION)) {
				GIACFunctionService giacFunctionService = (GIACFunctionService) APPLICATION_CONTEXT.getBean("giacFunctionService");
				giacFunctionService.getFunctionName(request, USER.getUserId());
				request.setAttribute("canvas", request.getParameter("canvas"));
				PAGE = "/pages/claims/mcEvaluationReport/subpages/overrideRequest.jsp";
			}else if("checkEvalCSLOverrideRequestExist".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId").equals("") ? null : Integer.parseInt(request.getParameter("claimId")));
				params.put("evalId", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("clmLossId", request.getParameter("clmLossId").equals("") ? null : Integer.parseInt(request.getParameter("clmLossId")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				params.put("payeeCd", request.getParameter("payeeCd").equals("") ? null : Integer.parseInt(request.getParameter("payeeCd")));
				giclMcEvaluationService.checkEvalCSLOverrideRequestExist(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("getMcItemPeril".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId").equals("") ? null : Integer.parseInt(request.getParameter("claimId")));
				params.put("itemNo", request.getParameter("itemNo").equals("") ? null : Integer.parseInt(request.getParameter("itemNo")));
				giclMcEvaluationService.getMcItemPeril(params);
				message = new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showMcEvaluationReportInquiry".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>(); // add parameters if needed - irwin
				params = giclMcEvaluationService.getVariables(params);
				
				request.setAttribute("variablesObj", QueryParamGenerator.generateQueryParams(params));
				PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/motorCar/mcEvaluationReport/mcEvaluationMain.jsp";
			}	
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
