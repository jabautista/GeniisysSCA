package com.geniisys.gipi.pack.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.gipi.pack.entity.GIPIPackWPolnrep;
import com.geniisys.gipi.pack.service.GIPIPackWPolnrepService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIPackWPolnrepController extends BaseController{

	/**
	 *  The Class GIPIPackWPolnrepController
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIPackWPolnrepController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIPackWPolnrepService gipiPackWPolnrepService = (GIPIPackWPolnrepService) APPLICATION_CONTEXT.getBean("gipiPackWPolnrepService");
			Integer packParId = Integer.parseInt((request.getParameter("packParId") == null) ? "0" : request.getParameter("packParId"));
			String lineCd 		= request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd");
			String sublineCd 	= request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd");
			String issCd 		= request.getParameter("issCd") == null ? "" : request.getParameter("issCd");
			String polFlag 	 	= request.getParameter("polFlag") == null ? "" : request.getParameter("polFlag");
			
			if("showPackRenewalPage".equals(ACTION)){
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				List<GIPIPackWPolnrep> gipiPackWPolnReps = gipiPackWPolnrepService.getGipiPackPolnrep(packParId);
				String incrRepl = giisParametersService.getParamValueV2("INCREMENT_REPLACEMENT");
				
				request.setAttribute("wpolnreps", gipiPackWPolnReps);
				request.setAttribute("issCd", issCd);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("sublineCd", sublineCd);
				request.setAttribute("isPack", "Y");
				request.setAttribute("incrRepl", incrRepl);
				
				PAGE = "/pages/underwriting/pop-ups/renewalReplacementDetail.jsp";
			}else if("checkPackPolnrep".equals(ACTION)){
				GIPIPackWPolnrep packWPolnrep = new GIPIPackWPolnrep();
				packWPolnrep.setParId(packParId);
				packWPolnrep.setLineCd(lineCd);
				packWPolnrep.setSublineCd(sublineCd);
				packWPolnrep.setIssCd(request.getParameter("wpolnrepIssCd").toUpperCase());
				packWPolnrep.setIssueYy(Integer.parseInt(request.getParameter("wpolnrepIssueYy")));
				packWPolnrep.setPolSeqNo(Integer.parseInt(request.getParameter("wpolnrepPolSeqNo")));
				packWPolnrep.setRenewNo(Integer.parseInt(request.getParameter("wpolnrepRenewNo")));
				
				String result = gipiPackWPolnrepService.checkPackPolicyForRenewal(packWPolnrep, polFlag);
				System.out.println("checkPackPolnrep: "+result);
				message = result;
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = "SQL Exception occured...<br/>" + e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e) {
			message = "Unhandled exception occured...<br/>" + e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
