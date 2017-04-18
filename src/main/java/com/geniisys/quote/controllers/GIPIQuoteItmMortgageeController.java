package com.geniisys.quote.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.quote.entity.GIPIQuoteItmperil;
import com.geniisys.quote.service.GIPIQuoteItmmortgageeService;
import com.geniisys.quote.service.GIPIQuoteItmperilService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIQuoteItmMortgageeController", urlPatterns={"/GIPIQuoteItmMortgageeController"})
public class GIPIQuoteItmMortgageeController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIQuoteController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("Initializing :"+this.getClass().getSimpleName());
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIQuoteItmmortgageeService gipiQuoteItmmortgageeService = (GIPIQuoteItmmortgageeService)APPLICATION_CONTEXT.getBean("gipiQuoteItmmortgageeService");
		
		try{
			if("getMortgageeList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getDetailMortgageeList");
				params.put("quoteId",request.getParameter("quoteId").equals("") ? 0 : Integer.parseInt(request.getParameter("quoteId")));
				params.put("itemNo", request.getParameter("itemNo").equals("") ? 0 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("notIn", request.getParameter("notIn"));
				params.put("issCd", request.getParameter("issCd"));/*
				request.getParameter("quoteId").equals("") ? 0 : Integer.parseInt(request.getParameter("quoteId")));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));*/
				Map<String, Object> mortgageeItems = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));
				JSONObject json = new JSONObject(mortgageeItems);	
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("mortgageeList", json);
					PAGE = "/pages/marketing/quote/subPages/mortgagee/mortgagee.jsp";
				}
				//PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/marketing/quote/subPages/mortgagee/mortgagee.jsp" : "/pages/genericObject.jsp");
			} 
		}catch(NullPointerException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
