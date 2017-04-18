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
import com.geniisys.quote.entity.GIPIQuoteAVItem;
import com.geniisys.quote.service.GIPIQuoteAVItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIQuoteAVItemController", urlPatterns={"/GIPIQuoteAVItemController"})
public class GIPIQuoteAVItemController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIQuoteAVItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIQuoteAVItemService gipiQuoteAVItemService = (GIPIQuoteAVItemService) APPLICATION_CONTEXT.getBean("gipiQuoteAVItemService");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		try {
			if ("showAviationAdditionalInformation".equals(ACTION)) {
				Integer quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"));
				request.setAttribute("aircrafts", lovHelper.getList(LOVHelper.AIRCRAFT_LISTING));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", quoteId);
				params.put("itemNo", itemNo);
				GIPIQuoteAVItem aviationAi = (GIPIQuoteAVItem) StringFormatter.replaceQuotesInObject(gipiQuoteAVItemService.getGIPIQuoteAVItemDetails(params));
				if (aviationAi != null){
					aviationAi.setPurpose(StringFormatter.replaceQuotes(aviationAi.getPurpose()));//**
					aviationAi.setQualification(StringFormatter.replaceQuotes(aviationAi.getQualification()));
					aviationAi.setDeductText(StringFormatter.replaceQuotes(aviationAi.getDeductText()));
					aviationAi.setGeogLimit(StringFormatter.replaceQuotes(aviationAi.getGeogLimit()));	
					request.setAttribute("vessel", aviationAi);
				}
				PAGE = "/pages/marketing/quote/subPages/additionalInfo/additionalInfoAV.jsp";
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
