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
import com.geniisys.gixx.entity.GIXXCargo;
import com.geniisys.gixx.service.GIXXCargoService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXCargoController", urlPatterns="/GIXXCargoController")
public class GIXXCargoController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXCargoController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXCargoService gixxCargoService = (GIXXCargoService) APPLICATION_CONTEXT.getBean("gixxCargoService");
			
			if("getGIXXCargoInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				
				GIXXCargo cargoInfo = gixxCargoService.getGIXXCargoInfo(params);
				request.setAttribute("mnItem", new JSONObject(request.getParameter("mnItem")));
				//request.setAttribute("cargoItemInfo", cargoInfo == null ? new JSONObject() : new JSONObject(cargoInfo)); replaced by: Nica 05.03.2013
				if(cargoInfo != null){
					request.setAttribute("cargoItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(cargoInfo)));
				}else{
					cargoInfo = new GIXXCargo();
					request.setAttribute("cargoItemInfo", new JSONObject(cargoInfo));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/cargoItemAddtlInfoOverlay.jsp";
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
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
