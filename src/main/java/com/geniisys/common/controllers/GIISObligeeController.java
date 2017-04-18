package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISObligee;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISObligeeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISObligeeController extends BaseController {
	
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIISObligee.class);
	
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIISObligeeService giisObligeeService = (GIISObligeeService) APPLICATION_CONTEXT.getBean("giisObligeeService");
			
			if("showPolicyObligeeOverLay".equals(ACTION)){
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyObligeeOverlay.jsp";
				
			}else if("getObligeeList".equals(ACTION)){
				System.out.println("obligee called");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("keyword", request.getParameter("keyword"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params = giisObligeeService.getObligeeList(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("obligeeList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyObligeeList.jsp";
				}
				
			} else if("getObligeeListMaintenance".equals(ACTION)) { // For retrieving obligee list used for maintenance
				String modId = "GIISS017";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				
				Map<String, Object> obligeeMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(obligeeMaintenance);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					request.setAttribute("appUser", USER.getUserId());
					request.setAttribute("obligeeList", json);
					PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/obligee/obligeeMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				
			} else if("saveObligee".equals(ACTION)) { // for saving all the changes made into the obligees 
				message = giisObligeeService.saveObligee(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
				
			} else if("validateObligeeNoOnDelete".equals(ACTION)) { // for checking if obligee can be deleted or not
				message = giisObligeeService.validateObligeeNoOnDelete(Integer.parseInt(request.getParameter("obligeeNo")));
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(SQLException e){ //marco - 08.18.2014
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}