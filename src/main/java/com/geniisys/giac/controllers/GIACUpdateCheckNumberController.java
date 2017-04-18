package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACUpdateCheckNumberService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACUpdateCheckNumberController", urlPatterns={"/GIACUpdateCheckNumberController"})
public class GIACUpdateCheckNumberController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7480832762804091780L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACUpdateCheckNumberService giacUpdateCheckNumberService = (GIACUpdateCheckNumberService) APPLICATION_CONTEXT.getBean("giacUpdateCheckNumberService");
		
		try{
			if("showUpdateCheckNumberPage".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gibrGfunFundCd", request.getParameter("gibrGfunFundCd"));
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("filter", request.getParameter("objFilter"));
				params.put("ACTION", "getGIACS049DvListing");
				
				Map<String, Object> dvListing = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(dvListing);
				
				if ("1".equals(request.getParameter("refresh"))){
					request.setAttribute("chkNoTableGrid", json);
					PAGE = "/pages/accounting/generalDisbursements/utilities/updateCheckNumber/updateCheckNumber.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}	
			}else if("validateCheckPrefSuf".equals(ACTION)){
				giacUpdateCheckNumberService.validateCheckPrefSuf(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateCheckNo".equals(ACTION)){
				request.setAttribute("object", giacUpdateCheckNumberService.validateCheckNo(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateCheckNumber".equals(ACTION)){
				message = giacUpdateCheckNumberService.updateCheckNumber(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCheckNoHistory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("filter", request.getParameter("objFilter"));
				params.put("ACTION", "getGIACS049CheckNoHistory");
				
				Map <String, Object> historyListing = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(historyListing);
				
				if ("1".equals(request.getParameter("refresh"))){
					request.setAttribute("historyTableGrid", json);
					PAGE = "/pages/accounting/generalDisbursements/utilities/updateCheckNumber/popup/checkNumberHistory.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		}catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
