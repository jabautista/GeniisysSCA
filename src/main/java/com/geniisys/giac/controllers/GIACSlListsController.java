package com.geniisys.giac.controllers;

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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.service.GIACDCBUserService;
import com.geniisys.giac.service.GIACSlListsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACSlListsController extends BaseController {
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACSlListsController.class);

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACSlListsService giacSlListsService = (GIACSlListsService) APPLICATION_CONTEXT.getBean("giacSlListsService");
		
		PAGE = "/pages/genericMessage.jsp";
		
		Integer gaccTranId = request.getParameter("gaccTranId") == null ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
		
		log.info("Gacc Tran Id: " + gaccTranId);
		
		try {
			if ("showSlListsDetails".equals(ACTION)) {
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/showSlListsDetails.jsp";
			} else if ("getSlListingByWhtaxId".equals(ACTION)) {
				String keyword = request.getParameter("keyword");
				Integer whtaxId = request.getParameter("whtaxId") == null ? 0 : (request.getParameter("whtaxId").isEmpty() ? 0 : Integer.parseInt(request.getParameter("whtaxId")));
				
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
				
				searchResult = giacSlListsService.getSlListingByWhtaxId(pageNo, keyword, whtaxId);
				
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchSlListsAjaxResult.jsp";
			}else if("showGiacs309".equals(ACTION)){
				JSONObject json = giacSlListsService.showGiacs309(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("sapIntegrationSw", giacSlListsService.getSapIntegrationSw());
					request.setAttribute("jsonSlLists", json);
					PAGE = "/pages/accounting/maintenance/subsidiaryLedger/subsidiaryLedger.jsp";
				} else {
					System.out.println("****** JSON: "+json.toString());
					message = json.toString();
					//System.out.println("****** AFTER: "+message);
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRec".equals(ACTION)){
				giacSlListsService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs309".equals(ACTION)) {
				giacSlListsService.saveGiacs309(request, USER.getUserId());
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
