package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLCatastrophicEventService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLCatastrophicEventController", urlPatterns={"/GICLCatastrophicEventController"})
public class GICLCatastrophicEventController extends BaseController {

	private static final long serialVersionUID = -3644575886784961631L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLCatastrophicEventService giclCatastrophicEventService = (GICLCatastrophicEventService) APPLICATION_CONTEXT.getBean("giclCatastrophicEventService");
			PAGE = "/pages/genericMessage.jsp";
			
			if("showCatastrophicEventInquiry".equals(ACTION)){		
				JSONObject json = giclCatastrophicEventService.showCatastrophicEventInquiry(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/catastrophicEvent/inquiry/CatastrophicEventInquiry.jsp";	
				}
			} else if("validateGicls057Catastrophy".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giclCatastrophicEventService.validateGicls057Catastrophy(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGicls057Line".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giclCatastrophicEventService.validateGicls057Line(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGicls057Branch".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giclCatastrophicEventService.validateGicls057Branch(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showCatastrophicEventReport".equals(ACTION)){
				request.setAttribute("userParams", new JSONObject(StringFormatter.escapeHTMLInMap(giclCatastrophicEventService.getUserParams(USER.getUserId())))); //benjo 10.23.2015 GENQA-5114 added StringFormatter.escapeHTMLInMap
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/claims/catastrophicEvent/report/catastrophicEventReport.jsp"; 
			} else if("extractOsPdPerCat".equals(ACTION)){
				message = giclCatastrophicEventService.extractOsPdPerCat(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("valExtOsPdClmRecBefPrint".equals(ACTION)){
				message = giclCatastrophicEventService.valExtOsPdClmRecBefPrint(USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGICLS056".equals(ACTION)){
				JSONObject json = giclCatastrophicEventService.getGICLS056CatastrophicEvent(request, USER);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCatastrophicEvent", json);
					PAGE = "/pages/claims/catastrophicEvent/maintenance/catastrophicEventMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showGicls056FireDetails".equals(ACTION)) {
				PAGE = "/pages/claims/catastrophicEvent/maintenance/fireDetails.jsp";
			} else if ("showGicls056Details".equals(ACTION)) {
				JSONObject json = giclCatastrophicEventService.getGICLS056Details(request, USER);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCatastrophicEventDetails", json);
					PAGE = "/pages/claims/catastrophicEvent/maintenance/details.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showGicls056ClaimList".equals(ACTION)) {
				JSONObject json = new JSONObject();
				System.out.println("lineCd : " + request.getParameter("lineCd"));
				System.out.println(request.getParameter("lineCd").toString().equals("FI"));
				if(request.getParameter("lineCd").toString().equals("FI"))
					json = giclCatastrophicEventService.getGICLS056ClaimListFi(request, USER);
				else
					json = giclCatastrophicEventService.getGICLS056ClaimList(request, USER);
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCatastrophicEventClaimList", json);
					PAGE = "/pages/claims/catastrophicEvent/maintenance/claimList.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("gicls056UpdateDetails".equals(ACTION)) {
				giclCatastrophicEventService.gicls056UpdateDetails(request, USER);
			} else if("saveGicls056".equals(ACTION)) {
				giclCatastrophicEventService.saveGicls056(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls056ValDelete".equals(ACTION)){
				message = giclCatastrophicEventService.gicls056ValDelete(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("gicls056UpdateDetailsAll".equals(ACTION)){
				giclCatastrophicEventService.gicls056UpdateDetailsAll(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("gicls056RemoveAll".equals(ACTION)){
				giclCatastrophicEventService.gicls056RemoveAll(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls056ValAddRec".equals(ACTION)){
				giclCatastrophicEventService.gicls056ValAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("gicls056GetClaimNos".equals(ACTION)){
				request.setAttribute("object",giclCatastrophicEventService.gicls056GetClaimNos(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			} else if("gicls056GetClaimNos2".equals(ACTION)){
				if(request.getParameter("lineCd").equals("FI"))
					request.setAttribute("object",giclCatastrophicEventService.gicls056GetClaimNosListFi(request, USER.getUserId()));
				else
					request.setAttribute("object",giclCatastrophicEventService.gicls056GetClaimNosList(request, USER.getUserId()));
				
				PAGE = "/pages/genericObject.jsp";
			} else if("gicls056GetDspAmt".equals(ACTION)) {
				request.setAttribute("object", giclCatastrophicEventService.gicls056GetDspAmt(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
