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
import com.geniisys.giac.service.GIACOtherCollnsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACOtherCollnsController", urlPatterns="/GIACOtherCollnsController")
public class GIACOtherCollnsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIACOtherCollnsService otherCollnsService = (GIACOtherCollnsService) appContext.getBean("giacOtherCollnsService");
		try {
			if("getGIACOtherCollns".equals(ACTION)){
				JSONObject jsonOtherCollns = otherCollnsService.getGIACOtherCollns(request);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonOtherCollns", jsonOtherCollns);
					PAGE = "/pages/accounting/officialReceipt/otherTrans/otherCollections.jsp";
				}else{
					message = jsonOtherCollns.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("setOtherCollnsDtls".equals(ACTION)){
				message = otherCollnsService.setOtherCollnsDtls(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if(ACTION.equals("validateOldTranNoGIACS015")){ 
				message = otherCollnsService.validateOldTranNoGIACS015(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if(ACTION.equals("validateOldItemNoGIACS015")){ 
				message = otherCollnsService.validateOldItemNoGIACS015(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if(ACTION.equals("validateItemNoGIACS015")){ 
				message = otherCollnsService.validateItemNoGIACS015(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if(ACTION.equals("validateDeleteGiacs015")){ 
				message = otherCollnsService.validateDeleteGiacs015(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkSLCode".equals(ACTION)) { //added by John Daniel SR-5056
				message = otherCollnsService.checkSLCode(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
