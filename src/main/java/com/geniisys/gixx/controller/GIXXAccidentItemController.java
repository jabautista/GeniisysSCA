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
import com.geniisys.gixx.entity.GIXXAccidentItem;
import com.geniisys.gixx.service.GIXXAccidentItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXAccidentItemController", urlPatterns="/GIXXAccidentItemController")
public class GIXXAccidentItemController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXAccidentItemController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXAccidentItemService gixxAccidentItemService = (GIXXAccidentItemService) APPLICATION_CONTEXT.getBean("gixxAccidentItemService");
			
			if("getGIXXAccidentItem".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIXXAccidentItem accidentItem = gixxAccidentItemService.getGIXXAccidentItem(params);
				/*if(accidentItem != null){
					request.setAttribute("accidentItemInfo", new JSONObject(accidentItem));
				}*/ // replaced by: Nica 05.03.2013
				if(accidentItem != null){
					request.setAttribute("accidentItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(accidentItem)));
				}else{
					accidentItem = new GIXXAccidentItem();
					request.setAttribute("accidentItemInfo", new JSONObject(accidentItem));
				}
				request.setAttribute("acItem", new JSONObject(request.getParameter("acItem")));
				PAGE="/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/accidentItemAddtlInfoOverlay.jsp";				
			}
			
		} catch (SQLException e){
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
