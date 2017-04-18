/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.controllers
	File Name: GICL_REPAIR_HDR.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 27, 2012
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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gicl.entity.GICLRepairHdr;
import com.geniisys.gicl.service.GICLRepairHdrService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;
@WebServlet(name="GICLRepairHdrController", urlPatterns={"/GICLRepairHdrController"})
public class GICLRepairHdrController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5055911539056318698L;
	private static Logger log = Logger.getLogger(GICLRepairHdrController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLRepairHdrController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		PAGE = "/pages/genericMessage.jsp";
		GICLRepairHdrService giclRepairHdrService = (GICLRepairHdrService) APPLICATION_CONTEXT.getBean("giclRepairHdrService");
		try{
			if ("getRepairDtl".equals(ACTION)) {
				GICLRepairHdr obj = giclRepairHdrService.getRepairDtl(Integer.parseInt(request.getParameter("evalId")));
				//JSONObject json = new JSONObject(StringFormatter.escapeHTMLInObject( obj == null ?"" : obj));
				//JSONObject json = new JSONObject(obj == null ?"" : StringFormatter.escapeHTMLInObject( obj));
				//System.out.println(obj == null );
				request.setAttribute("giclRepairObj",obj == null ?  new JSONObject() : new JSONObject( StringFormatter.escapeHTMLInObject( obj)));
				//request.setAttribute("giclRepairObj",obj == null ? new JSONObject(new GICLRepairHdr()) :new JSONObject());
				PAGE = "/pages/claims/mcEvaluationReport/overlay/repairDetails.jsp";
			}else if ("getGicls070LpsDetailsList".equals(ACTION)) {
				giclRepairHdrService.getGicls070LpsRepairDetailsList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/repairLpsDtlTGListing.jsp";
				}
			}else if ("getTinsmithAmount".equals(ACTION)) {
				Map<String, Object>params= FormInputUtil.getFormInputs(request);
				message = giclRepairHdrService.getTinsmithAmount(params);
			}else if ("getPaintingsAmount".equals(ACTION)) {
				String lossExpCd = request.getParameter("lossExpCd");
				message = giclRepairHdrService.getPaintingsAmount(lossExpCd);
			}else if ("validateRepairBeforeSave".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("evalMasterId", request.getParameter("evalMasterId"));
				params.put("evalId", request.getParameter("evalId"));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				params.put("payeeCd", request.getParameter("payeeCd"));
				params.put("actualTotalAmt", request.getParameter("actualTotalAmt").equals("")? null : new BigDecimal(request.getParameter("actualTotalAmt")));
				message = giclRepairHdrService.validateBeforeSave(params);
			}else if ("saveRepairDet".equals(ACTION)) {
				giclRepairHdrService.saveRepairDet(request.getParameter("strParameters"), USER);
				message = "SUCCESS";
			}else if ("getGiclRepairOtherDtlList".equals(ACTION)) {
				giclRepairHdrService.getGiclRepairOtherDtlList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/repairOtherLabor.jsp";
				}
			}else if ("validateBeforeSaveOther".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("evalId", Integer.parseInt(request.getParameter("evalId")));
				params.put("payeeCd", Integer.parseInt(request.getParameter("payeeCd")));
				params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
				giclRepairHdrService.validateBeforeSaveOther(params);
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("saveOtherLabor".equals(ACTION)) {
				giclRepairHdrService.saveOtherLabor(request.getParameter("strParameters"), USER);
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
