package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.service.GIPIItmperilBeneficiaryService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@SuppressWarnings("serial")
public class GIPIItmperilBeneficiaryController extends BaseController{

	private static Logger log = Logger.getLogger(GIPIItmperilBeneficiaryController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIItmperilBeneficiaryService gipiItmperilBeneficiaryService = (GIPIItmperilBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiItmperilBeneficiaryService");
			
			if("getAccidentItemPerilBeneficiaries".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params = gipiItmperilBeneficiaryService.getItmperilBeneficiaries(params);

				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("itmPerilBeneficiaryList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/accidentItmperilBeneficiaryTable.jsp";
				}
			}
		}catch(NullPointerException e){
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
}
