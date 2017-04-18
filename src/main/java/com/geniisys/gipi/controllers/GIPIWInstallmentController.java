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
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWInstallment;
import com.geniisys.gipi.service.GIPIWInstallmentFacadeService;

import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWInstallmentController.
 */
public class GIPIWInstallmentController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6053256358005122209L;
	private static Logger log = Logger.getLogger(GIPIWInstallmentController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("");
		try{ ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
			GIPIWInstallmentFacadeService gipiWInstallmentService = (GIPIWInstallmentFacadeService) APPLICATION_CONTEXT.getBean("gipiWInstallmentFacadeService"); // +env
			int parId = Integer.parseInt((request.getParameter("parId") == null ? "0" : request.getParameter("parId")));
			int itemGrp = Integer.parseInt((request.getParameter("itemGrp") == null) ? "1" : request.getParameter("itemGrp"));
			Integer takeupSeqNo= Integer.parseInt((request.getParameter("takeupSeqNo") == null) ? "0" : request.getParameter("takeupSeqNo"));
			//String lineCd = (request.getParameter("lineCd")== null ? "" : request.getParameter("lineCd"));
			//String dueDate = request.getParameter("dueDate");
			//Integer version = 1;
			
			GIPIPARList gipiParList = new GIPIPARList(); 
			gipiParList.setParId(parId);
			
			if("showPaymentSchedule".equals(ACTION)){
				System.out.println("INSTALLMENT" +takeupSeqNo);
				List<GIPIWInstallment> gipiWInstallment =  gipiWInstallmentService.getGIPIWInstallment(parId, itemGrp, takeupSeqNo);
				StringFormatter.replaceQuotesInList(gipiWInstallment);
				request.setAttribute("gipiWInstallmentJSON", new JSONArray(gipiWInstallment));
				PAGE="/pages/underwriting/pop-ups/installment.jsp";
				request=this.getWinstallment(request, gipiWInstallmentService, parId, itemGrp, takeupSeqNo);
			}else if ("showAllPaymentSchedule".equals(ACTION)){
				System.out.println("INSTALLMENT2" +takeupSeqNo);
				List<GIPIWInstallment> gipiWInstallment = gipiWInstallmentService.getAllGIPIWInstallment(parId);
				StringFormatter.replaceQuotesInList(gipiWInstallment);
				request.setAttribute("gipiWInstallmentJSON", new JSONArray(gipiWInstallment));
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
	 * Gets the winstallment.
	 * 
	 * @param request the request
	 * @param gipiWInstallmentService the gipi w installment service
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @param takeupSeqNo the takeup seq no
	 * @return the winstallment
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getWinstallment(HttpServletRequest request, 
			GIPIWInstallmentFacadeService gipiWInstallmentService, int parId, int itemGrp, int takeupSeqNo)	throws SQLException {
		
		List<GIPIWInstallment> gipiWInstallment = gipiWInstallmentService.getGIPIWInstallment(parId, itemGrp, takeupSeqNo);
		request.setAttribute("gipiWInstallment", gipiWInstallment);
		return request;
	}



	

}
