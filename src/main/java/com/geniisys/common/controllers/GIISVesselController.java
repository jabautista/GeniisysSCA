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
import com.geniisys.common.service.GIISVesselService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIISVesselController", urlPatterns={"/GIISVesselController"})
public class GIISVesselController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISVesselService giisVesselService = (GIISVesselService) APPLICATION_CONTEXT.getBean("giisVesselService");
		
		try {
			if("showGIISS049".equals(ACTION)){
				JSONObject json = giisVesselService.showGiiss049(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonAircraft", json);
					PAGE = "/pages/underwriting/fileMaintenance/aviation/aircraft/aircraft.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				message = giisVesselService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisVesselService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss049".equals(ACTION)) {
				giisVesselService.saveGiiss049(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateAirTypeCd".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisVesselService.validateAirTypeCd(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showGiiss050".equals(ACTION)){
				JSONObject json = giisVesselService.showGiiss050(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonInlandVehicleList", json);
					PAGE = "/pages/underwriting/fileMaintenance/marineCargo/inlandVehicle/inlandVehicle.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRecGiiss050".equals(ACTION)){
				giisVesselService.valDeleteRecGiiss050(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRecGiiss050".equals(ACTION)){
				giisVesselService.valAddRecGiiss050(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss050".equals(ACTION)) {
				giisVesselService.saveGiiss050(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			/* GIISS039 : Vessel Maintenance */	
			} else if("showGiiss039".equals(ACTION)){
				JSONObject json = giisVesselService.showGiiss039(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonVesselList", json);
					PAGE = "/pages/underwriting/fileMaintenance/marineCargo/vessel/vessel.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeleteRecGiiss039".equals(ACTION)){
				giisVesselService.valDeleteRecGiiss039(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRecGiiss039".equals(ACTION)){
				giisVesselService.valAddRecGiiss039(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss039".equals(ACTION)) {
				giisVesselService.saveGiiss039(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			/* end GIISS039 : Vessel Maintenance */	
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
