/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLReplaceController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 5, 2012
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gicl.service.GICLMcEvaluationService;
import com.geniisys.gicl.service.GICLReplaceService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet(name="GICLReplaceController", urlPatterns={"/GICLReplaceController"})
public class GICLReplaceController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2131469417386660307L;
	private static Logger log = Logger.getLogger(GICLReplaceController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLReplaceController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLReplaceService giclReplaceService = (GICLReplaceService) APPLICATION_CONTEXT.getBean("giclReplaceService");
		PAGE = "/pages/genericMessage.jsp";
		try{
			if ("getMcEvalReplaceListing".equals(ACTION)) {
				giclReplaceService.getMcEvalReplaceListing(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/replaceDetails.jsp";
				}
			}else if("validateDetField".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("evalMasterId", request.getParameter("evalMasterId").equals("") ? null : Integer.parseInt(request.getParameter("evalMasterId")));
				params.put("evalId", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("baseAmt", request.getParameter("baseAmt").equals("") ? null : new BigDecimal(request.getParameter("baseAmt")));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				params.put("noOfUnits", request.getParameter("noOfUnits").equals("") ? null : Integer.parseInt(request.getParameter("noOfUnits")));
				params.put("partType", request.getParameter("partType"));
				params.put("payeeCd",  request.getParameter("payeeCd").equals("") ? null : Integer.parseInt(request.getParameter("payeeCd")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				params.put("oldLossExpCd", request.getParameter("oldLossExpCd"));

				String field = request.getParameter("field");
				if(field.equals("partType")){
					giclReplaceService.validatePartType(params);
				}else if (field.equals("partDesc")) {
					giclReplaceService.validatePartDesc(params);
				}else if(field.equals("companyType")){
					giclReplaceService.validateCompanyType(params);
				}else if(field.equals("companyDesc")){
					giclReplaceService.validateCompanyDesc(params);
				}else if(field.equals("baseAmt")){
					giclReplaceService.validateBaseAmt(params);
				}else if(field.equals("noOfUnits")){
					giclReplaceService.validateNoOfUnits(params);
				}
				message = QueryParamGenerator.generateQueryParams(params);
			}else if("countPrevPartListLOV".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				message = giclReplaceService.countPrevPartListLOV(params).toString();
			}else if ("checkPartIfExistMaster".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				System.out.println("PARAMS: "+params);
				params.put("evalId", Integer.parseInt((String) params.get("evalId")));
				params.put("evalMasterId", Integer.parseInt((String) params.get("evalMasterId")));
				params.put("payeeCd",request.getParameter("payeeCd").equals("") ? null : Integer.parseInt((String) params.get("payeeCd")));
				giclReplaceService.checkPartIfExistMaster(params);
				System.out.println("after: "+params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("copyMasterPart".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giclReplaceService.copyMasterPart(params);
				System.out.println(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if("getPayeeDetailsMap".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				giclReplaceService.getPayeeDetailsMap(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if("checkVatAndDeductibles".equals(ACTION)){
				Map<String, Object> params  = FormInputUtil.getFormInputs(request);
				params.put("payeeCd", request.getParameter("payeeCd").equals("")? null :Integer.parseInt(request.getParameter("payeeCd")));
				params.put("paytPayeeCd", request.getParameter("paytPayeeCd").equals("")? null : Integer.parseInt(request.getParameter("paytPayeeCd")));
				params.put("payeeCdOld", request.getParameter("payeeCdOld").equals("")? null :Integer.parseInt(request.getParameter("payeeCdOld")));
				params.put("paytPayeeCdOld", request.getParameter("paytPayeeCdOld").equals("")? null : Integer.parseInt(request.getParameter("paytPayeeCdOld")));
				params.put("evalId", Integer.parseInt(request.getParameter("evalId")));
				giclReplaceService.checkVatAndDeductibles(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("getWithVatList".equals(ACTION)) {
				Integer evalMasterId = request.getParameter("evalMasterId").equals("") ? null : Integer.parseInt(request.getParameter("evalMasterId"));
				List<String> withVat = giclReplaceService.getWithVatList(evalMasterId);
				message = withVat.toString();
			}else if("checkUpdateRepDtl".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("evalMasterId", request.getParameter("evalMasterId").equals("") ? null : Integer.parseInt(request.getParameter("evalMasterId")));
				params.put("evalId", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("oldLossExpCd", request.getParameter("oldLossExpCd"));
				giclReplaceService.checkUpdateRepDtl(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("finalCheckVat".equals(ACTION)) {
				Map<String, Object>params  = FormInputUtil.getFormInputs(request);
				message = giclReplaceService.finalCheckVat(params);
			}else if ("finalCheckDed".equals(ACTION)) {
				Map<String, Object>params  = FormInputUtil.getFormInputs(request);
				message = giclReplaceService.finalCheckDed(params);
			}else if ("saveReplaceDetail".equals(ACTION)) {
				GICLMcEvaluationService giclMcEvaluationService = (GICLMcEvaluationService) APPLICATION_CONTEXT.getBean("giclMcEvaluationService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				System.out.println(params);
				params.put("userId", USER.getUserId());
				params.put("partOrigAmt", request.getParameter("partOrigAmt").equals("")? null : new BigDecimal(request.getParameter("partOrigAmt").replace(",", "")));
				params.put("partAmt", request.getParameter("partAmt").equals("")? null : new BigDecimal(request.getParameter("partAmt").replace(",", "")));
				params.put("totalPartAmt", request.getParameter("totalPartAmt").equals("")? null : new BigDecimal(request.getParameter("totalPartAmt").replace(",", "")));
				params.put("baseAmt", request.getParameter("baseAmt").equals("")? null : new BigDecimal(request.getParameter("baseAmt").replace(",", "")));
				params.put("evalMasterId", request.getParameter("evalMasterId").equals("") ? null : Integer.parseInt(request.getParameter("evalMasterId")));
				params.put("evalId", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd", request.getParameter("payeeCd").equals("") ? null : Integer.parseInt(request.getParameter("payeeCd")));
				params.put("origPayeeCd", request.getParameter("origPayeeCd").equals("") ? null : Integer.parseInt(request.getParameter("origPayeeCd")));
				params.put("noOfUnits", request.getParameter("noOfUnits").equals("") ? null : Integer.parseInt(request.getParameter("noOfUnits")));
				params.put("paytPayeeCd", request.getParameter("paytPayeeCd").equals("") ? null : Integer.parseInt(request.getParameter("paytPayeeCd")));
				params.put("replaceId", request.getParameter("replaceId").equals("") ? null : Integer.parseInt(request.getParameter("replaceId")));
				params.put("replacedMasterId", request.getParameter("replacedMasterId").equals("") ? null : Integer.parseInt(request.getParameter("replacedMasterId")));
				giclReplaceService.saveReplaceDetail(params);
				giclReplaceService.updateItemNo(USER.getUserId(), (Integer) params.get("evalId"));
				giclMcEvaluationService.updateEvalDepVatAmt(params);
				message = "SUCCESS";
			}else if("deleteReplaceDetail".equals(ACTION)){
				GICLMcEvaluationService giclMcEvaluationService = (GICLMcEvaluationService) APPLICATION_CONTEXT.getBean("giclMcEvaluationService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				System.out.println(params);
				params.put("userId", USER.getUserId());
				params.put("evalMasterId", request.getParameter("evalMasterId").equals("") ? null : Integer.parseInt(request.getParameter("evalMasterId")));
				params.put("evalId", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd", request.getParameter("payeeCd").equals("") ? null : Integer.parseInt(request.getParameter("payeeCd")));
				params.put("origPayeeCd", request.getParameter("origPayeeCd").equals("") ? null : Integer.parseInt(request.getParameter("origPayeeCd")));
				params.put("paytPayeeCd", request.getParameter("paytPayeeCd").equals("") ? null : Integer.parseInt(request.getParameter("paytPayeeCd")));
				params.put("replaceId", request.getParameter("replaceId").equals("") ? null : Integer.parseInt(request.getParameter("replaceId")));
				params.put("replacedMasterId", request.getParameter("replacedMasterId").equals("") ? null : Integer.parseInt(request.getParameter("replacedMasterId")));
				giclReplaceService.deleteReplaceDetail(params);
				giclReplaceService.updateItemNo(USER.getUserId(), (Integer) params.get("evalId"));
				giclMcEvaluationService.updateEvalDepVatAmt(params);
				message = "SUCCESS";
			}else if("getReplacePayeeListing".equals(ACTION)){
				giclReplaceService.getReplacePayeeListing(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/replaceDetailsChangePayee.jsp";
				}
			}else if ("applyChangePayee".equals(ACTION)) {
				giclReplaceService.applyChangePayee(request.getParameter("strParameters"),USER.getUserId());
				message = "SUCCESS";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}

