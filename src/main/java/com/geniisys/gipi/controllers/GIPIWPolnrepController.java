/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.geniisys.gipi.service.GIPIWPolnrepFacadeService;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIWPolnrepController.
 */
public class GIPIWPolnrepController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -2941736913591707231L;
	private static Logger log = Logger.getLogger(GIPIWPolnrepController.class);

	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWPolnrepFacadeService gipiWPolnrep = (GIPIWPolnrepFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolnrepFacadeService");
						
			int parId 			= Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			String lineCd 		= request.getParameter("globalLineCd") == null ? "" : request.getParameter("globalLineCd");
			String sublineCd 	= request.getParameter("globalSublineCd") == null ? "" : request.getParameter("globalSublineCd");
			String issCd 		= request.getParameter("globalIssCd") == null ? "" : request.getParameter("globalIssCd");
			String polFlag 	 	= request.getParameter("polFlag") == null ? "" : request.getParameter("polFlag");
			
			if("showWRenewalPage".equalsIgnoreCase(ACTION)){
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				//List<GIPIWPolnrep> wpolnreps = gipiWPolnrep.getWPolnrep(parId); //marco - 07.12.2013 - replaced method to consider endorsements when retrieving expiry date
				List<GIPIWPolnrep> wpolnreps = gipiWPolnrep.getWPolnrep2(parId);
				String incrRepl = giisParametersService.getParamValueV2("INCREMENT_REPLACEMENT");
				
				request.setAttribute("wpolnreps", wpolnreps);
				request.setAttribute("issCd", issCd);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("sublineCd", sublineCd);
				request.setAttribute("incrRepl", incrRepl); // added by Nica 09.07.2011 -  to consider parameter (increment_replacement) in disabling samePolicyNo checkbox
				
				PAGE = "/pages/underwriting/pop-ups/renewalReplacementDetail.jsp";
			} else if ("saveWPolnrep".equalsIgnoreCase(ACTION)) {
				String[] oldPolicyIds 	= request.getParameterValues("oldPolicyId");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("oldPolicyIds", oldPolicyIds);
				params.put("parId", parId);
				params.put("polFlag", polFlag);
				params.put("userId", USER.getUserId());
				
				gipiWPolnrep.saveWPolnrep(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkPolnrep".equalsIgnoreCase(ACTION)) {
				GIPIWPolnrep wpolnrep = new GIPIWPolnrep();
				
				wpolnrep.setParId(parId);
				wpolnrep.setLineCd(lineCd);
				wpolnrep.setSublineCd(sublineCd);
				wpolnrep.setIssCd(request.getParameter("wpolnrepIssCd").toUpperCase());
				wpolnrep.setIssueYy(Integer.parseInt(request.getParameter("wpolnrepIssueYy")));
				wpolnrep.setPolSeqNo(Integer.parseInt(request.getParameter("wpolnrepPolSeqNo")));
				wpolnrep.setRenewNo(Integer.parseInt(request.getParameter("wpolnrepRenewNo")));
								
				String result = gipiWPolnrep.checkPolicyForRenewal(wpolnrep, polFlag);
				
				message = result;
				System.out.println("checkPolnrep result: "+message);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
