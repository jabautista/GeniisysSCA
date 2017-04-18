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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWOpenPeril;
import com.geniisys.gipi.service.GIPIWOpenPerilService;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIWOpenPerilController.
 */
public class GIPIWOpenPerilController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6291959978219216453L;
	private static Logger log = Logger.getLogger(GIPIWOpenPerilController.class);
	
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
			GIPIWOpenPerilService openPerilService = (GIPIWOpenPerilService) APPLICATION_CONTEXT.getBean("gipiWOpenPerilService");
			
			int parId 	  = Integer.parseInt((request.getParameter("globalParId") == null || request.getParameter("globalParId") == "") ? "0" : request.getParameter("globalParId"));
			int geogCd 	  = Integer.parseInt((request.getParameter("geogCd") == null || request.getParameter("geogCd") == "") ? "0" : request.getParameter("geogCd"));
			String lineCd = (request.getParameter("globalLineCd") == null) ? "" : request.getParameter("globalLineCd");
			String sublineCd = (request.getParameter("globalSublineCd") == "") ? null : request.getParameter("globalSublineCd");
		
			if("getOpenPeril".equals(ACTION)){
				PAGE = "/pages/underwriting/subPages/openPeril.jsp";
				List<GIPIWOpenPeril> openPerils = openPerilService.getWOpenPeril(parId, geogCd, lineCd);
				
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args 		= {lineCd, sublineCd};
				List<LOV> perils 	= lovHelper.getList(LOVHelper.ENDT_PERIL_LISTING, args);
				
				request.setAttribute("openPerils", openPerils);
				request.setAttribute("perils", perils);
			} else if ("saveWOpenPeril".equals(ACTION)){
				String[] perilCds 	  = request.getParameterValues("perilCd");
				String[] premiumRates = request.getParameterValues("premiumRate");
				String[] remarks 	  = request.getParameterValues("remarks");
				System.out.println(premiumRates);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("geogCd", geogCd);
				params.put("lineCd", lineCd);
				params.put("perilCds", perilCds);
				params.put("premiumRates", premiumRates);
				params.put("remarks", remarks);
				params.put("userId", USER.getUserId());
				
				openPerilService.saveWOpenPeril(params);
				
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			} else if ("checkWOpenPeril".equals(ACTION)){
				int perilCd = Integer.parseInt(request.getParameter("perilCd") == null || request.getParameter("perilCd") == "" ? "0" : request.getParameter("perilCd"));
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("parId", parId);
				params.put("geogCd", geogCd);
				params.put("lineCd", lineCd);
				params.put("perilCd", perilCd);
								
				message = openPerilService.checkWOpenPeril(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getEndtOpenPeril".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIPIWOpenPerilTG");
				params.put("parId", parId);
				params.put("geogCd", geogCd);
				params.put("lineCd", lineCd);
				Map<String, Object> openPerilTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(openPerilTG);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("openPerilTG", json);
					PAGE = "/pages/underwriting/endt/jsonMarineCargo/limitsOfLiability/endtOpenPeril.jsp";
				}
			} else if("getEndtLolOpenPeril".equals(ACTION)){ // for GIPIS173
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIPIWOpenPerilTG");
				params.put("parId", parId);
				params.put("geogCd", geogCd);
				params.put("lineCd", lineCd);
				Map<String, Object> openPerilTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(openPerilTG);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("openPerilTG", json);
					PAGE = "/pages/underwriting/endt/basicInfo1/subPages/endtLimitsOfLiabilityOpenPeril.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}
	
}
