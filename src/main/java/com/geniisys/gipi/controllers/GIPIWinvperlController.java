/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
//import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWinvperl;
import com.geniisys.gipi.service.GIPIWinvperlFacadeService;

import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIWinvperlController.
 */
public class GIPIWinvperlController extends BaseController {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6053256358005122209L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWinvperlController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWinvperlFacadeService gipiWinvperlService = (GIPIWinvperlFacadeService) APPLICATION_CONTEXT.getBean("gipiWinvperlFacadeService"); // +env
			
	
			
			//int parId = Integer.parseInt((request.getParameter("parId") == null ? "0" : request.getParameter("parId").toString()));
			int itemGrp = Integer.parseInt((request.getParameter("itemGrp") == null) ? "1" : request.getParameter("itemGrp"));
		    Integer parId = Integer.parseInt((request.getParameter("parId") == null ? "0" : request.getParameter("parId")));
		    String lineCd = (request.getParameter("lineCd")== null ? "line" : request.getParameter("lineCd"));
		
			System.out.println("perils" +  parId + lineCd);
			
			GIPIPARList gipiParList = new GIPIPARList(); 
			
			if("showBillPremiumsPage".equals(ACTION)){
				
				gipiParList.setParId(parId);
			    gipiParList.setLineCd(lineCd);
			
				PAGE ="/pages/underwriting/subPages/invoicePeril.jsp";
				request=this.getWinvperl(request, gipiWinvperlService, parId, itemGrp, lineCd);
				request=this.getDistinctWinvperl(request, gipiWinvperlService, parId);
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
	
	/**
	 * Gets the winvperl.
	 * 
	 * @param request the request
	 * @param gipiWinvperlService the gipi winvperl service
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @param lineCd the line cd
	 * @return the winvperl
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getWinvperl(HttpServletRequest request, 
			GIPIWinvperlFacadeService gipiWinvperlService, int parId, int itemGrp, String lineCd)	throws SQLException {
		List<GIPIWinvperl> gipiWinvperl = gipiWinvperlService.getGIPIWinvperl(parId, itemGrp, lineCd);
		request.setAttribute("gipiWinvperl", gipiWinvperl);
		
	System.out.println("hello perils!");
		//	System.out.println(gipiWInvoice.getProperty());
	System.out.println(parId+ lineCd+ itemGrp);
		return request;
	}
	
	/**
	 * Gets the distinct winvperl.
	 * 
	 * @param request the request
	 * @param gipiWinvperlService the gipi winvperl service
	 * @param parId the par id
	 * @return the distinct winvperl
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getDistinctWinvperl(HttpServletRequest request, 
			GIPIWinvperlFacadeService gipiWinvperlService, int parId)	throws SQLException {
		List<GIPIWinvperl> itemGrpGipiWinvperl = gipiWinvperlService.getItemGrpWinvperl(parId);
		List<GIPIWinvperl> takeupGipiWinvperl = gipiWinvperlService.getTakeupWinvperl(parId);
		
		request.setAttribute("itemGrpGipiWinvperl", itemGrpGipiWinvperl);
		request.setAttribute("takeupGipiWinvperl", takeupGipiWinvperl);			
		return request;
	}
		
}


