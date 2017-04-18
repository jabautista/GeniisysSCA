package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIPolwcService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


public class GIPIPolwcController extends BaseController{
	
	private static Logger log = Logger.getLogger(GIPIPolwcController.class);
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIPolwcService gipiPolwcService = (GIPIPolwcService) APPLICATION_CONTEXT.getBean("gipiPolwcService");
			
			if("showWarrClauses".equals(ACTION)){
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyWarrClause.jsp";
				
			}else if("getRelatedWcInfo".equals(ACTION)){
				
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiPolwcService.getRelatedWcInfo(params);
				request.setAttribute("gipiRelatedWcTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedWcTable.jsp";
				
			}else if ("refreshRelatedWcInfo".equals(ACTION)){

				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getRelatedWcInfo");
				params.put("policyId", policyId);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiPolwcService.getRelatedWcInfo(params);
				//JSONObject json = new JSONObject(params);
				//added by Gzelle 06.14.2013
				Map<String, Object> wcList =TableGridUtil.getTableGrid(request, params); 
				JSONObject json = new JSONObject(wcList);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					message = StringFormatter.replaceTildes(json.toString());
					PAGE = "/pages/genericMessage.jsp";
				}
				//message = StringFormatter.replaceTildes(json.toString());
				//PAGE = "/pages/genericMessage.jsp";
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
