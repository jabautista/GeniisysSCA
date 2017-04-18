/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.controllers
	File Name: GICLEvalDepDtlController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 10, 2012
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gicl.service.GICLEvalDepDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;
@WebServlet(name="GICLEvalDepDtlController", urlPatterns={"/GICLEvalDepDtlController"})
public class GICLEvalDepDtlController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2181234060456304997L;
	private static Logger log = Logger.getLogger(GICLEvalDepDtlController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLEvalDepDtlController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLEvalDepDtlService giclEvalDepDtlService = (GICLEvalDepDtlService) APPLICATION_CONTEXT.getBean("giclEvalDepDtlService");
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("getDepreciationDtl".equals(ACTION)) {
				Map<String, Object> map = giclEvalDepDtlService.getDepPayeeDtls(Integer.parseInt(request.getParameter("evalId")));
				@SuppressWarnings("unchecked")
				Map<String, Object> initialMap = (Map<String, Object>) map.get("initialDepPayeeDetails"); 
				@SuppressWarnings("unchecked")
				Map<String, Object> payeeMap = (Map<String, Object>) map.get("depPayeeDetails");
				JSONObject initialPayeeObj = new JSONObject(initialMap == null? initialMap : StringFormatter.escapeHTMLInMap(initialMap) );
				JSONObject payeeObj = new JSONObject(payeeMap == null ? payeeMap : StringFormatter.escapeHTMLInMap(payeeMap));
				request.setAttribute("initialPayeeObj",initialPayeeObj);
				request.setAttribute("depPayeeObj", payeeObj); 
				PAGE = "/pages/claims/mcEvaluationReport/overlay/depreciationDetails.jsp";
			}else if("getEvalDepList".equals(ACTION)) {
				giclEvalDepDtlService.getEvalDepList(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/depreciationTGListing.jsp";
				}
			}else if("checkDepVat".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("evalId", Integer.parseInt(request.getParameter("evalId")));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				giclEvalDepDtlService.checkDepVat(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveDepreciationDtls".equals(ACTION)){
				giclEvalDepDtlService.saveDepreciationDtls(request.getParameter("strParameters"), USER.getUserId());
				message = "SUCCESS";
			}else if ("applyDepreciation".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				message =giclEvalDepDtlService.applyDepreciation(params);
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
