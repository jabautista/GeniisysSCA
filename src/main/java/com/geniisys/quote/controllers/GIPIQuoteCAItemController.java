package com.geniisys.quote.controllers;

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
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.quote.entity.GIPIQuoteCAItem;
import com.geniisys.quote.service.GIPIQuoteCAItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIQuoteCAItemController", urlPatterns={"/GIPIQuoteCAItemController"})
public class GIPIQuoteCAItemController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIQuoteCAItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIQuoteCAItemService gipiQuoteCAItemService = (GIPIQuoteCAItemService) APPLICATION_CONTEXT.getBean("gipiQuoteCAItemService");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");

		try {
			if ("showCasualtyAdditionalInformation".equals(ACTION)) {
				Integer quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"));
				request.setAttribute("positionLov", lovHelper.getList(LOVHelper.POSITION_LISTING));
				request.setAttribute("hazardLov", lovHelper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", quoteId);
				params.put("itemNo", itemNo);
				GIPIQuoteCAItem casualtyAi = (GIPIQuoteCAItem) StringFormatter.replaceQuotesInObject(gipiQuoteCAItemService.getGIPIQuoteCAItemDetails(params));
				if (casualtyAi != null){
					request.setAttribute("casualty", casualtyAi);
				}
				PAGE = "/pages/marketing/quote/subPages/additionalInfo/additionalInfoCA.jsp";
			}
		} catch (SQLException e) {
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
