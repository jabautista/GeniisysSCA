package com.geniisys.giri.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.service.GIRIDistFrpsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIRIDistFrpsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(GIRIWFrpsRiController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIRIDistFrpsService giriFrpsService = (GIRIDistFrpsService) APPLICATION_CONTEXT.getBean("giriDistFrpsService");
		try{
			if ("showFrpsListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("lineName", request.getParameter("lineName"));
				
				HashMap<String, Object>params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("lineCd", lineCd);
				params.put("moduleId", "GIRIS006");
				params.put("filter", request.getParameter("objFilter"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giriFrpsService.getGIRIFrpsList(params);
				request.setAttribute("giriFrpsListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/underwriting/reInsurance/frpsListing/frpsTableGridListing.jsp";
			}else if("refreshFrpsListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("lineCd", lineCd);
				
				HashMap<String, Object>params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("lineCd", lineCd);
				params.put("moduleId", "GIRIS006");
				params.put("filter", request.getParameter("objFilter"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giriFrpsService.getGIRIFrpsList(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateDistFrpsGiuts004".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("distNo", request.getParameter("distNo"));
				params = giriFrpsService.updateDistFrpsGiuts004(params);
			}
		}catch(SQLException e){
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
