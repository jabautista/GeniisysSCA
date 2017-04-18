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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gixx.entity.GIXXVehicle;
import com.geniisys.gixx.service.GIXXVehicleService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXVehicleController", urlPatterns="/GIXXVehicleController")
public class GIXXVehicleController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXVehicleController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXVehicleService gixxVehicleService = (GIXXVehicleService) APPLICATION_CONTEXT.getBean("gixxVehicleService");
			
			if("getGIXXCargoCarrierTG".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				//params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				//params = gixxVehicleService.getGIXXCargoCarrierTG(params);
				params.put("ACTION", ACTION);
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("carrierList", new JSONObject(((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params))));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/carrierListOverlay.jsp";
				}
			} else if("getGIXXVehicleItemInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				
				GIXXVehicle vehicleInfo = gixxVehicleService.getGIXXVehicleInfo(params);
				/*if(vehicleInfo != null){
					request.setAttribute("vehicleInfo", new JSONObject(vehicleInfo));
				}*/ // replaced by: Nica 05.03.2013
				if(vehicleInfo != null){
					request.setAttribute("vehicleInfo", new JSONObject(StringFormatter.escapeHTMLInObject(vehicleInfo)));
				}else{
					vehicleInfo = new GIXXVehicle();
					request.setAttribute("vehicleInfo", new JSONObject(vehicleInfo));
				}
				
				request.setAttribute("mcItem", new JSONObject(request.getParameter("mcItem")));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/vehicleItemAddtlInfoOverlay.jsp";
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
