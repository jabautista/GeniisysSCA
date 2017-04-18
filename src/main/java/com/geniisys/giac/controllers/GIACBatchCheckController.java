package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.giac.service.GIACBatchCheckService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACBatchCheckController", urlPatterns="/GIACBatchCheckController")
public class GIACBatchCheckController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1132644944621847997L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION,
								HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACBatchCheckService giacBatchCheckService = (GIACBatchCheckService) APPLICATION_CONTEXT.getBean("giacBatchCheckService"); 
			
			if ("showBatchChecking".equals(ACTION)) {
				JSONObject json = giacBatchCheckService.getNet(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/batchChecking/batchCheckingExtract.jsp";					
				}
			}else if ("getPrevExtractParams".equals(ACTION)) {
				message = (new JSONObject(giacBatchCheckService.getPrevExtractParams(request, USER))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getMainTable".equals(ACTION)) {
				JSONObject json = giacBatchCheckService.getMainTable(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("table", request.getParameter("table"));
					request.setAttribute("dateTag", request.getParameter("dateTag"));
					request.setAttribute("main", json.toString());
					PAGE = "/pages/accounting/endOfMonth/batchChecking/subPages/batchCheckingTable.jsp";					
				}	
			}else if ("getNet".equals(ACTION)) {
				JSONObject json = giacBatchCheckService.getNet(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/batchChecking/batchCheckingExtract.jsp";					
				}
			}else if ("getDetail".equals(ACTION)) {
				JSONObject json = giacBatchCheckService.getDetail(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("table", request.getParameter("table"));
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("baseAmt", request.getParameter("baseAmt"));
					PAGE = "/pages/accounting/endOfMonth/batchChecking/subPages/batchCheckingDetail.jsp";					
				}
			}else if ("extractBatchChecking".equals(ACTION)) {
				message = giacBatchCheckService.extractBatchChecking(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getTotalNet".equals(ACTION)) {
				message = (new JSONObject(giacBatchCheckService.getTotalNet(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getTotal".equals(ACTION)) {
				message = (new JSONObject(giacBatchCheckService.getTotal(request, USER.getUserId()))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getTotalDetail".equals(ACTION)) {
				message = (new JSONObject(giacBatchCheckService.getTotalDetail(request, USER.getUserId()))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkRecords".equals(ACTION)){
				giacBatchCheckService.checkRecords(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkDetails".equals(ACTION)){
				giacBatchCheckService.checkDetails(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000 && e.getCause().toString().contains("Geniisys Exception")){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";			
		}catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
