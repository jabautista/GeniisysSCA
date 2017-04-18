package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIItemVes;
import com.geniisys.gipi.service.GIPIItemVesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIItemVesController extends BaseController{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIPIItemVesController.class);
	
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			log.info("");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIItemVesService	gipiItemVesService = (GIPIItemVesService) APPLICATION_CONTEXT.getBean("gipiItemVesService");
			
			if("showMarineHullsPage".equals(ACTION)){
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/marineHulls.jsp";
			}else if("getMarineHullsTable".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				
				params = gipiItemVesService.getMarineHulls(params);
				JSONObject marineHullsObject = new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params));
				request.setAttribute("marineHullsTableGrid",marineHullsObject );
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/marineHullsTable.jsp";
				
			}else if("refreshMarineHullsTable".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				
				params = gipiItemVesService.getMarineHulls(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getItemVesInfo".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIPIItemVes	gipiItemVes = gipiItemVesService.getItemVesInfo(params);
				if(gipiItemVes != null){
					request.setAttribute("gipiItemVes", new JSONObject(StringFormatter.escapeHTMLInObject(gipiItemVes)));
				}else{
					gipiItemVes = new GIPIItemVes();
					request.setAttribute("gipiItemVes", new JSONObject(gipiItemVes));
				}
				PAGE="/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/itemVesAddtlInfoOverlay.jsp";
				
			}
			
		}catch (NullPointerException e) {
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
