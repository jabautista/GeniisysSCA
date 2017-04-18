/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISPerilService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIISPerilController.
 */
public class GIISPerilController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIISPerilController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISPerilService giisPerilService = (GIISPerilService) APPLICATION_CONTEXT.getBean("giisPerilService");
			
			if ("checkIfPerilExists".equals(ACTION)){
				String nbtSublineCd = request.getParameter("nbtSublineCd");
				String lineCd = request.getParameter("lineCd");
				message = giisPerilService.checkIfPerilExists(nbtSublineCd, lineCd);
				System.out.println("Peril exists? "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getDefaultPerils".equals(ACTION)){
				String nbtSublineCd = request.getParameter("nbtSublineCd");
				String lineCd = request.getParameter("parLineCd");
				String packLineCd = request.getParameter("packLineCd");
				String packSublineCd = request.getParameter("packSublineCd");
						
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("nbtSublineCd", nbtSublineCd);
				params.put("packLineCd", packLineCd); 
				params.put("packSublineCd", packSublineCd);
				//List<GIISPeril> defaultPerils = giisPerilService.getDefaultPerils(params);
				//request.setAttribute("defaultPerils", defaultPerils);
				//PAGE = "/pages/genericMessage.jsp";
				
				JSONArray defaultPerils = new JSONArray(giisPerilService.getDefaultPerils(params));
				request.setAttribute("object", defaultPerils);
				PAGE = "/pages/genericObject.jsp";
				//PAGE = "/pages/underwriting/subPages/defaultPerils.jsp";
			}else if ("getDefaultRate".equals(ACTION)){
				String perilCd = request.getParameter("perilCd");
				String lineCd = request.getParameter("lineCd");
				message = giisPerilService.getDefaultRate(perilCd, lineCd);
				System.out.println("Default Rate "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getDefPerilAmts".equals(ACTION)) {
				message = giisPerilService.getDefPerilAmts(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("chkIfTariffPerilExsts".equals(ACTION)) {
				message = giisPerilService.chkIfTariffPerilExsts(request);
				PAGE = "/pages/genericMessage.jsp";			
			} else if ("chkPerilZoneType".equals(ACTION)) {	//Gzelle 05252015 SR4347
				message = giisPerilService.chkPerilZoneType(request);
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
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
