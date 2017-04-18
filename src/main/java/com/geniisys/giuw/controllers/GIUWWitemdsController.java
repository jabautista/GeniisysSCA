package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giuw.service.GIUWWitemdsService;
import com.geniisys.giuw.service.GIUWWpolicydsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIUWWitemdsController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIUWWitemdsService giuwWitemdsServ = (GIUWWitemdsService) APPLICATION_CONTEXT.getBean("giuwWitemdsService");
		
		try{
			if("showGIUWWitemdsTableListing".equals(ACTION)){
				GIUWWpolicydsService giuwWpolicyds = (GIUWWpolicydsService) APPLICATION_CONTEXT.getBean("giuwWpolicydsService");
				Integer policyId = request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId"));
				Integer distNo = request.getParameter("distNo") == null ? null : Integer.parseInt(request.getParameter("distNo"));
				String isExistGiuwWpolicyds = giuwWpolicyds.isExistGIUWWpolicyds(distNo);
				request.setAttribute("isExistGiuwWpolicyds", isExistGiuwWpolicyds);
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giuwWitemdsServ.getGiuwWitemdsForDistrFinal(params);
				request.setAttribute("objGiuwWitemds", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));	
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/giuwWitemdsListing.jsp";
			}else if("refreshGIUWWitemdsTableListing".equals(ACTION)){
				Integer policyId = request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId"));
				Integer distNo = request.getParameter("distNo") == null ? null : Integer.parseInt(request.getParameter("distNo"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giuwWitemdsServ.getGiuwWitemdsForDistrFinal(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIUWWitemdsDistGrps".equals(ACTION)){ // added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
				Integer policyId = request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId"));
				Integer distNo = request.getParameter("distNo") == null ? null : Integer.parseInt(request.getParameter("distNo"));
				Integer fromPage = request.getParameter("from") == null ? null : Integer.parseInt(request.getParameter("from"));
				Integer toPage = request.getParameter("to") == null ? null : Integer.parseInt(request.getParameter("to"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("from", fromPage);
				params.put("to", toPage);
				List<Map<String, Object>> giuwDistGrps = giuwWitemdsServ.getGiuwWitemdsOthPgeDistGrps(params);
				JSONArray json = new JSONArray (giuwDistGrps);
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
