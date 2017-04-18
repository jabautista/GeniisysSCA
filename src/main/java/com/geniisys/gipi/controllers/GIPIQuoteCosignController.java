package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuoteCosign;
import com.geniisys.gipi.service.GIPIQuoteCosignService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIQuoteCosignController extends BaseController{

	private Logger log = Logger.getLogger(GIPIQuoteCosignController.class);
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing: "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			if ("loadCosignorsListingTable".equals(ACTION)){
				log.info("Getting cosignors listing...");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIPIQuoteCosignService cosignService = (GIPIQuoteCosignService) APPLICATION_CONTEXT.getBean("gipiQuoteCosignService");
				
				int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
				String assdNo = (request.getParameter("assuredNo") == null) ? "0" : request.getParameter("assuredNo");
				String[] args = {assdNo};
				request.setAttribute("cosignNames", lovHelper.getList(LOVHelper.COSIGNORS_LISTING, args));
				
				request.setAttribute("cosignsJSON", new JSONArray((List<GIPIQuoteCosign>) StringFormatter.replaceQuotesInList(cosignService.getGIPIQuoteCosigns(quoteId))));
				PAGE = "/pages/marketing/quotation/subPages/cosignorsListing.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		//	log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
