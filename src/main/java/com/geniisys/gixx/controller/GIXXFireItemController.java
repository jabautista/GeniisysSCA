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
import com.geniisys.gixx.entity.GIXXFireItem;
import com.geniisys.gixx.service.GIXXFireItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXFireItemController", urlPatterns="/GIXXFireItemController")
public class GIXXFireItemController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXFireItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXFireItemService gixxFireItemService = (GIXXFireItemService) APPLICATION_CONTEXT.getBean("gixxFireItemService");
			
			if("getGIXXFireItemInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", request.getParameter("extractId"));
				params.put("itemNo", request.getParameter("itemNo"));
				
				GIXXFireItem fireItemInfo = gixxFireItemService.getGIXXFireItemInfo(params);
				/*if(fireItemInfo != null ){
					request.setAttribute("fireItemInfo", new JSONObject(fireItemInfo));					
				}*/// replaced by: Nica 05.03.2013
				if(fireItemInfo != null){
					request.setAttribute("fireItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(fireItemInfo)));
				}else{
					fireItemInfo = new GIXXFireItem();
					request.setAttribute("fireItemInfo", new JSONObject(fireItemInfo));
				}
				request.setAttribute("fiItem", new JSONObject(request.getParameter("fiItem")));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/fireItemAddtlInfoOverlay.jsp";				
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
