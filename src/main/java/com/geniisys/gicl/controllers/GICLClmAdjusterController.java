package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.entity.GICLClmAdjuster;
import com.geniisys.gicl.service.GICLClmAdjHistService;
import com.geniisys.gicl.service.GICLClmAdjusterService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLClmAdjusterController", urlPatterns={"/GICLClmAdjusterController"})
public class GICLClmAdjusterController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GICLClmAdjusterService adjusterService = (GICLClmAdjusterService) APPLICATION_CONTEXT.getBean("giclClmAdjusterService");
			Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId"))? "0" : request.getParameter("claimId"));
			
			if ("showAdjusterListing".equals(ACTION)){
				GICLClmAdjHistService adjHistService = (GICLClmAdjHistService) APPLICATION_CONTEXT.getBean("giclClmAdjHistService");
				adjusterService.getClmAdjusterListing(request, USER);
				List<GICLClmAdjuster> clmAdjusterList = adjusterService.getClmAdjusterList(claimId);
				StringFormatter.escapeHTMLInListOfMap(clmAdjusterList); //replaced escapeHTMLInList with escapeHTMLInListOfMap - christian 04/06/2013
				request.setAttribute("clmAdjusterList", new JSONArray(clmAdjusterList));
				request.setAttribute("giclClmAdjHistExist", adjHistService.getGiclClmAdjHistExist(claimId.toString()));
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/adjuster.jsp";
			}else if("checkBeforeDelete".equals(ACTION)){
				message = adjusterService.checkBeforeDeleteAdj(request, USER);
			}else if("saveClmAdjuster".equals(ACTION)){
				message = adjusterService.saveClmAdjuster(request, USER);
			}else if("getLossExpAdjusterList".equals(ACTION)){
				List<GICLClmAdjuster> adjList = adjusterService.getLossExpAdjusterList(claimId);
				StringFormatter.escapeHTMLInList(adjList);
				request.setAttribute("object", new JSONArray(adjList));
				PAGE = "/pages/genericObject.jsp";
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
