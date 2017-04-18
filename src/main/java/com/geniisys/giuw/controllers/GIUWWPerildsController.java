package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giuw.service.GIUWWPerildsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIUWWPerildsController extends BaseController {

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIUWWPerildsService giuwwPerildsService = (GIUWWPerildsService) APPLICATION_CONTEXT.getBean("giuwwPerildsService");
		
		try{
			if("showGIUWWPerildsTableListing".equals(ACTION)){
				Integer policyId = request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId"));
				Integer distNo = request.getParameter("distNo") == null ? null : Integer.parseInt(request.getParameter("distNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giuwwPerildsService.getGiuwWperildsForDistFinal(params);
				 
				request.setAttribute("objGIUWWPerilds", new JSONObject((Map<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/giuwwPerildsTableListing.jsp";
			}else if("refreshGIUWWPerildsTableListing".equals(ACTION)){
				Integer policyId = request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId"));
				Integer distNo = request.getParameter("distNo") == null ? null : Integer.parseInt(request.getParameter("distNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giuwwPerildsService.getGiuwWperildsForDistFinal(params);
					
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (NumberFormatException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}

