package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.service.GICLAdvsPlaService;
import com.geniisys.gicl.service.GICLClaimsService;
import com.geniisys.gicl.service.GICLClmResHistService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLAdvsPlaController", urlPatterns="/GICLAdvsPlaController")
public class GICLAdvsPlaController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLAdvsPlaController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLAdvsPlaService giclAdvsPlaService = (GICLAdvsPlaService) APPLICATION_CONTEXT.getBean("giclAdvsPlaService");
		Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId"))? "0" : request.getParameter("claimId"));
		
		message = "SUCCESS";
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("showPrelimLossAdvice".equals(ACTION)){
				log.info("Getting Preliminary Loss Advice page...");
				GICLClaimsService giclClaimsService = (GICLClaimsService) APPLICATION_CONTEXT.getBean("giclClaimsService");
				GICLClmResHistService giclClmResHistService = (GICLClmResHistService) APPLICATION_CONTEXT.getBean("giclClmResHistService");
				request.setAttribute("objGICLClaims", new JSONObject((GICLClaims) StringFormatter.escapeHTMLInObject(giclClaimsService.getClaimsBasicInfoDtls(claimId)))); //editted by steven 11/29/2012 from:replaceQuotesInObject    to:escapeHTMLInObject
				giclClmResHistService.getGiclClmResHistGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/preliminaryLossAdvice/pla.jsp";
			}else if("showPLADetails".equals(ACTION)){
				log.info("Getting PLA Details...");
				giclAdvsPlaService.getGiclAdvsPlaGrid(request, USER);
				HashMap<String, Object> hashMap = new HashMap<String, Object>();
				hashMap = giclAdvsPlaService.getAllPlaDetails(request, USER);
				request.setAttribute("plaDetails", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(hashMap)));
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/preliminaryLossAdvice/subPages/plaDetails.jsp";
			}else if("cancelPLA".equals(ACTION)){
				log.info("Cancelling PLA...");
				message = giclAdvsPlaService.cancelPLA(request, USER);
			}else if("generatePLA".equals(ACTION)){
				log.info("Generating PLA...");
				message = giclAdvsPlaService.generatePLA(request, USER);
			}else if("updatePrintSwPla".equals(ACTION)){
				log.info("Updating print_sw on PLA...");
				giclAdvsPlaService.updatePrintSwPla(request, USER);
			}else if("updatePrintSwPla2".equals(ACTION)){
				log.info("Updating print_sw on PLA...");
				giclAdvsPlaService.updatePrintSwPla2(request, USER);
			}else if("savePreliminaryLossAdv".equals(ACTION)){
				log.info("Saving PLA...");
				message = giclAdvsPlaService.savePreliminaryLossAdv(request, USER);
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//}catch(ParseException e) {
		//	message = ExceptionHandler.handleException(e, USER);
		//	PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
