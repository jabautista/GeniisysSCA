package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
import com.geniisys.gipi.service.GIPIBeneficiaryService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIBeneficiaryController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIBeneficiaryController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("doProcessing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIBeneficiaryService gipiBeneficiaryService = (GIPIBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiBeneficiaryService");
			if("getAccidentBeneficiaries".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params = gipiBeneficiaryService.getGipiBeneficiaries(params);

				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("accidentItemBeneficiaryList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/accidentItemBeneficiaryTable.jsp";
				}
			}else if("getGIPIBeneficiary".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("benNo", Integer.parseInt(request.getParameter("beneficiaryNo")));
				
				message = (new JSONObject(gipiBeneficiaryService.getGIPIBeneficiary(params))).toString();
				PAGE = "/pages/genericMessage.jsp";
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
