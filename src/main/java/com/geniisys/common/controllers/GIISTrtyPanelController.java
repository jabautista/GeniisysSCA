package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISTrtyPanelService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIISTrtyPanelController", urlPatterns={"/GIISTrtyPanelController"})
public class GIISTrtyPanelController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISTrtyPanelService giisTrtyPanelService = (GIISTrtyPanelService) APPLICATION_CONTEXT.getBean("giisTrtyPanelService");
		
		try {
			if("showGiiss031".equals(ACTION)){
				JSONObject json = giisTrtyPanelService.showGiiss031(request, USER.getUserId());
				JSONObject jsonAllRec = giisTrtyPanelService.showGiiss031AllRec(request, USER.getUserId());
				request.setAttribute("jsonTrty", json);
				request.setAttribute("jsonAllRecList", jsonAllRec);
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/outwardTreatyInformation/proportionalTreatyInfo.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showGiiss031Np".equals(ACTION)){
				JSONObject json = giisTrtyPanelService.showGiiss031(request, USER.getUserId());
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("trtyYy", request.getParameter("trtyYy"));
				request.setAttribute("shareCd", request.getParameter("shareCd"));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonNpTrty", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/outwardTreatyInformation/nonProportionalTreatyInfo.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRec".equals(ACTION)){
				giisTrtyPanelService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss031".equals(ACTION)) {
				giisTrtyPanelService.saveGiiss031(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiiss031Reinsurer".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisTrtyPanelService.validateGiiss031Reinsurer(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGiiss031ParentRi".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisTrtyPanelService.validateGiiss031ParentRi(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("valAddNpRec".equals(ACTION)){
				giisTrtyPanelService.valAddNpRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss031Np".equals(ACTION)) {
				giisTrtyPanelService.saveGiiss031Np(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRec".equals(ACTION)){
				giisTrtyPanelService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
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
