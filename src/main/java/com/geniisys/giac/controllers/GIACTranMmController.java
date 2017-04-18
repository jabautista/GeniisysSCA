package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACDCBUserService;
import com.geniisys.giac.service.GIACTranMmService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACTranMmController", urlPatterns={"/GIACTranMmController"})
public class GIACTranMmController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACTranMmService giacTranMmService = (GIACTranMmService) APPLICATION_CONTEXT.getBean("giacTranMmService");
		
		try {
			if("checkBookingDate".equals(ACTION)){
				message = giacTranMmService.checkBookingDate(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getClosedTag".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("dvDate", request.getParameter("dvDate") == null ? null : new SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("dvDate")));
				
				message = giacTranMmService.getClosedTag(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGiacs038".equals(ACTION)){
				JSONObject json = giacTranMmService.showGiacs038(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonTranMmList", json);
					PAGE = "/pages/accounting/maintenance/transactionMonth/transactionMonth.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("saveGiacs038".equals(ACTION)) {
				giacTranMmService.saveGiacs038(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkFunctionGiacs038".equals(ACTION)){
				message = giacTranMmService.checkFunctionGiacs038(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGenTranMmGiacs038".equals(ACTION)){
				request.setAttribute("gfundFundCd", request.getParameter("gfunFundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("nextTranYr", giacTranMmService.getNextTranYrGiacs038(request, USER.getUserId()));
				PAGE = "/pages/accounting/maintenance/transactionMonth/popup/generateTranMonths.jsp";
			}else if("checkTranYrGiacs038".equals(ACTION)){
				Integer tranYr = giacTranMmService.checkTranYrGiacs038(request);
				JSONObject json = new JSONObject();
				json.put("tranYrExist", tranYr == null ? "N" : "Y");			
				json.put("nextTranYr", giacTranMmService.getNextTranYrGiacs038(request, USER.getUserId()));	
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateTranMmGiacs038".equals(ACTION)){
				message = giacTranMmService.generateTranMmGiacs038(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";				
			}else if("showGiacs038HistoryPage".equals(ACTION)){
				JSONObject jsonStatHist = giacTranMmService.getTranMmStatHistGiacs038(request, USER.getUserId());
				JSONObject jsonClmStatHist = giacTranMmService.getClmTranMmStatHistGiacs038(request, USER.getUserId());

				request.setAttribute("fundCd", request.getParameter("gfunFundCd"));
				request.setAttribute("branchCd", request.getParameter("branchCd"));
				request.setAttribute("tranYr", request.getParameter("tranYr"));
				request.setAttribute("tranMm", request.getParameter("tranMm"));
				request.setAttribute("jsonStatHist", jsonStatHist);
				request.setAttribute("jsonClmStatHist", jsonClmStatHist);
				PAGE = "/pages/accounting/maintenance/transactionMonth/popup/tranMmHistory.jsp";
			}else if("getTranMmStatHist".equals(ACTION)){
				message = giacTranMmService.getTranMmStatHistGiacs038(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getClmTranMmStatHist".equals(ACTION)){
				message = giacTranMmService.getClmTranMmStatHistGiacs038(request, USER.getUserId()).toString();
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
