package com.geniisys.giis.controllers;

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
import com.geniisys.giis.service.GIISPerilClassService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name = "GIISPerilsPerPerilClassController", urlPatterns = "/GIISPerilsPerPerilClassController")
public class GIISPerilsPerPerilClassController extends BaseController {

	private static final long serialVersionUID = -3026872586774705638L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISPerilClassService giisPerilClasService = (GIISPerilClassService) APPLICATION_CONTEXT.getBean("giisPerilClassService");
			if ("showPerilClassMaintenance".equals(ACTION)) {
				PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilsPerPerilClass/perilsPerPerilClassMain.jsp";
			} else if ("getPerilsPerClass".equals(ACTION)) {
				JSONObject jsonPerilClass = new JSONObject(giisPerilClasService.getPerilsPerClass(request,USER));
				if ("1".equals(request.getParameter("ajax"))) {
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("jsonPerilClass", jsonPerilClass);
					PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilsPerPerilClass/perilsPerPerilClassMain.jsp";
				} else {
					message = jsonPerilClass.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getPerilsPerClassDetails".equals(ACTION)) {
				JSONObject jsonPerilClassDetails = new JSONObject(giisPerilClasService.getPerilsPerClassDetails(request,USER));
				message = jsonPerilClassDetails.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("savePerilClass".equals(ACTION)){
				giisPerilClasService.savePerilClass(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getAllPerilsPerClassDetails".equals(ACTION)){
				message = giisPerilClasService.getAllPerilsPerClassDetails(request, USER.getUserId());
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
