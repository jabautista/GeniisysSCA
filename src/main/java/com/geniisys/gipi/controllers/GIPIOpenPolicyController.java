package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.gipi.entity.GIPIOpenPolicy;
import com.geniisys.gipi.service.GIPIOpenPolicyService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIOpenPolicyController extends BaseController{
	
	/**
	 * 
	 */
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
			
			GIPIOpenPolicyService gipiOpenPolicyService = (GIPIOpenPolicyService) APPLICATION_CONTEXT.getBean("gipiOpenPolicyService");
			
			if("getEndtseq0OpenPolicy".equals(ACTION)){
				
				Integer policyEndSeq0 = Integer.parseInt(request.getParameter("policyEndSeq0"));
				
				GIPIOpenPolicy openPolicy = gipiOpenPolicyService.getEndtseq0OpenPolicy(policyEndSeq0);
				if(openPolicy != null){
					request.setAttribute("openPolicy", new JSONObject(openPolicy));
				}
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openPolicyOverlay.jsp";
			
				
			} else if("viewDeclarationPolicyPerOpenPolicy".equals(ACTION)){
				JSONObject json = gipiOpenPolicyService.getOpenPolicyList(request, USER.getUserId());
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					if(request.getParameter("callingForm").equals("GIPIS199")){
						request.setAttribute("jsonOpList", json);
					}else{
						request.setAttribute("jsonOpList", new JSONObject());
					}					
					PAGE = "/pages/underwriting/policyInquiries/declarationPolicyPerOpenPolicy/declarationPolicyPerOpenPolicy.jsp";
				}
			} else if("showOpenLiabFiMn".equals(ACTION)){
				request.setAttribute("openLiabInfo", gipiOpenPolicyService.getOpenLiabFiMn(request));
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openLiabOverlay.jsp";
			} else if ("getOpenCargos".equals(ACTION)){
				JSONObject json = gipiOpenPolicyService.getOpenCargos(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("openCargoList", json);	
					request.setAttribute("moduleId", request.getParameter("moduleId"));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openCargoTable.jsp";
				}
			} else if ("getOpenPerils".equals(ACTION)){
				JSONObject json = gipiOpenPolicyService.getOpenPerils(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("openPerilList", json);
					request.setAttribute("moduleId", request.getParameter("moduleId"));
					request.setAttribute("withInvoiceTag", request.getParameter("withInvoiceTag"));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openPerilTable.jsp";
				}
			} else if("showOpenLiab".equals(ACTION)) {
				request.setAttribute("openLiabInfo", gipiOpenPolicyService.getOpenLiabFiMn(request));
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("cargoSw", "N");
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openLiabOverlay.jsp";
			}
		}catch (SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";			
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
