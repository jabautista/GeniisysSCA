package com.geniisys.gixx.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gixx.entity.GIXXItemVes;
import com.geniisys.gixx.service.GIXXItemVesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXItemVesController", urlPatterns="/GIXXItemVesController")
public class GIXXItemVesController extends BaseController {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXItemVesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXItemVesService gixxItemVesService = (GIXXItemVesService) APPLICATION_CONTEXT.getBean("gixxItemVesService");
			
			if("getGIXXItemVesInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIXXItemVes gixxItemVesInfo = gixxItemVesService.getGIXXItemVesInfo(params);
				/*if(gixxItemVesInfo != null){
					request.setAttribute("gipiItemVes", new JSONObject(gixxItemVesInfo));
				}*/ // replaced by: Nica 05.03.2013
				if(gixxItemVesInfo != null){
					request.setAttribute("gipiItemVes", new JSONObject(StringFormatter.escapeHTMLInObject(gixxItemVesInfo)));
				}else{
					gixxItemVesInfo = new GIXXItemVes();
					request.setAttribute("gipiItemVes", new JSONObject(gixxItemVesInfo));
				}
				request.setAttribute("mhItem", new JSONObject(request.getParameter("mhItem")));
				PAGE="/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/itemVesAddtlInfoOverlay.jsp";
			}
			
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
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
