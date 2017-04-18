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
import com.geniisys.gixx.entity.GIXXCasualtyItem;
import com.geniisys.gixx.service.GIXXCasualtyItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXCasualtyItemController", urlPatterns="/GIXXCasualtyItemController")
public class GIXXCasualtyItemController extends BaseController{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXCasualtyItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXCasualtyItemService gixxCasualtyItemService = (GIXXCasualtyItemService) APPLICATION_CONTEXT.getBean("gixxCasualtyItemService");
			
			if("getGIXXCasualtyItemInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", request.getParameter("extractId") == null ? -1 : Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", request.getParameter("itemNo") == null ? -1 : Integer.parseInt(request.getParameter("itemNo")));
				GIXXCasualtyItem casualtyItem = gixxCasualtyItemService.getGIXXCasualtyItemInfo(params);
				/*if(casualtyItem != null){
					request.setAttribute("gipiCasualtyItemInfo", new JSONObject(casualtyItem));
				}*/ // replaced by: Nica 05.03.2013
				if(casualtyItem != null){
					request.setAttribute("gipiCasualtyItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(casualtyItem)));
				}else{
					casualtyItem = new GIXXCasualtyItem();
					request.setAttribute("gipiCasualtyItemInfo", new JSONObject(casualtyItem));
				}
				request.setAttribute("caItem", new JSONObject(request.getParameter("caItem")));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/casualtyItemAddtlInfoOverlay.jsp"; 
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
