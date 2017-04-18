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
import com.geniisys.gixx.entity.GIXXOpenLiab;
import com.geniisys.gixx.service.GIXXOpenLiabService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXOpenLiabController", urlPatterns="/GIXXOpenLiabController")
public class GIXXOpenLiabController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXOpenLiabController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXOpenLiabService gixxOpenLiabService = (GIXXOpenLiabService) APPLICATION_CONTEXT.getBean("gixxOpenLiabService");
			
			if("getGIXXOpenLiabInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", request.getParameter("renewNo"));
				
				GIXXOpenLiab openLiabInfo = gixxOpenLiabService.getGIXXOpenLiabInfo(params);
				if(openLiabInfo != null){
					request.setAttribute("openLiabInfo", new JSONObject(StringFormatter.escapeHTMLInObject(openLiabInfo)));
					System.out.println("currencyDesc: " + openLiabInfo.getCurrencyDesc() +"\tcurrencyRt: " + openLiabInfo.getCurrencyRt() + "\tcurrencyCd: " + openLiabInfo.getCurrencyCd());
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openLiabOverlay.jsp";  // wala pang page!
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
