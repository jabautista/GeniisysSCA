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
import com.geniisys.quote.service.GIPIQuoteItmperilService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIQuoteItmPerilController", urlPatterns={"/GIPIQuoteItmPerilController"})
public class GIPIQuoteItmPerilController extends BaseController{

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
		GIPIQuoteItmperilService gipiQuoteItmperilService = (GIPIQuoteItmperilService)APPLICATION_CONTEXT.getBean("gipiQuoteItmperilService");
		
		try{
			if("getPerilInfoListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("quoteId", request.getParameter("quoteId").equals("") ? 0 : Integer.parseInt(request.getParameter("quoteId")));
				params.put("itemNo", request.getParameter("itemNo").equals("") ? 0 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("packLineCd", request.getParameter("packLineCd"));
				Map<String, Object> perilInfoTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(perilInfoTableGrid);
				List<GIPIQuoteItmperil> itmPerilList = gipiQuoteItmperilService.getItmperils(params);
				request.setAttribute("itemPerilList", new JSONArray((List<GIPIQuoteItmperil>) StringFormatter.replaceQuotesInListOfMap(StringFormatter.escapeHTMLInList(itmPerilList))));
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("perilInfoTableGrid", json);
					PAGE = "/pages/marketing/quote/subPages/peril/perilInformation.jsp";
				}
			}else if("savePerilInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				message = gipiQuoteItmperilService.savePerilInfo(request.getParameter("parameters"), params);
				PAGE = "/pages/genericMessage.jsp";
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
