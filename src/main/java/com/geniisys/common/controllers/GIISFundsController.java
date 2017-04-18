package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISFundsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;

public class GIISFundsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIISFundsController.class);

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISFundsService giisFundsService = (GIISFundsService) APPLICATION_CONTEXT.getBean("giisFundsService");
		try {
			if ("showCloseDCBFundCdLOV".equals(ACTION)) {
				PAGE = "/pages/accounting/dcb/pop-ups/showFundCdLOV.jsp";
			} else if ("getCloseDCBFundCdListing".equals(ACTION)) {
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = giisFundsService.getFundCdLOVList(pageNo, keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/dcb/pop-ups/searchFundCdLOVAjaxResult.jsp";
				
			} else if("showGiacs302".equals(ACTION)){
				JSONObject json = giisFundsService.showGiacs302(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIISFund", json);
					PAGE = "/pages/accounting/maintenance/company/company.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giisFundsService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisFundsService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs302".equals(ACTION)) {
				giisFundsService.saveGiacs302(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
