/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.controllers
	File Name: GICLEvalVatController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 12, 2012
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
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
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gicl.service.GICLEvalVatService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet(name="GICLEvalVatController", urlPatterns={"/GICLEvalVatController"})
public class GICLEvalVatController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6311411685848094204L;
	private static Logger log = Logger.getLogger(GICLEvalVatController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLEvalDepDtlController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLEvalVatService giclEvalVatService = (GICLEvalVatService) APPLICATION_CONTEXT.getBean("giclEvalVatService");
		PAGE = "/pages/genericMessage.jsp";
		try{
			if ("getMcEvalVatListing".equals(ACTION)) {
				giclEvalVatService.getMcEvalVatListing(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/vatDetails.jsp";
				}
			}else if ("validateEvalCom".equals(ACTION)) {
				Map<String, Object>params =  new HashMap<String, Object>();
				params.put("evalId", Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd", Integer.parseInt(request.getParameter("payeeCd")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				giclEvalVatService.validateEvalCom(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("validateEvalPartLabor".equals(ACTION)) {
				Map<String, Object>params =  new HashMap<String, Object>();
				params.put("evalId", Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd", Integer.parseInt(request.getParameter("payeeCd")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				params.put("applyTo", request.getParameter("applyTo"));
				giclEvalVatService.validateEvalPartLabor(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if("validateLessDepreciation".equals(ACTION)){
				Map<String, Object>params =  new HashMap<String, Object>();
				params.put("evalId",request.getParameter("evalId").equals("") ? null: Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd",request.getParameter("payeeCd").equals("") ? null: Integer.parseInt(request.getParameter("payeeCd")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				params.put("applyTo", request.getParameter("applyTo"));
				params.put("lessDep", request.getParameter("lessDep"));
				giclEvalVatService.validateLessDepreciation(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("validateLessDeductibles".equals(ACTION)) {
				Map<String, Object>params =  new HashMap<String, Object>();
				params.put("evalId",request.getParameter("evalId").equals("") ? null: Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd",request.getParameter("payeeCd").equals("") ? null: Integer.parseInt(request.getParameter("payeeCd")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				params.put("applyTo", request.getParameter("applyTo"));
				params.put("lessDed", request.getParameter("lessDed"));
				giclEvalVatService.validateLessDeductibles(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if("checkEnableCreateVat".equals(ACTION)){
				message = giclEvalVatService.checkEnableCreateVat(Integer.parseInt(request.getParameter("evalId")));
			}else if ("saveVatDetail".equals(ACTION)) {
				giclEvalVatService.saveVatDetail(request.getParameter("strParameters"), USER.getUserId());
				message = "SUCCESS";
			}else if("createVatDetails".equals(ACTION)){
				BigDecimal totalVat = giclEvalVatService.createVatDetails(request.getParameter("strParameters"), USER.getUserId());
				message = "SUCCESS,"+ totalVat.toString();
			}else if("checkEvalVatExist".equals(ACTION)){ //benjo 03.08.2017 SR-5945
				message = giclEvalVatService.checkGiclEvalVatExist(request, USER).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
