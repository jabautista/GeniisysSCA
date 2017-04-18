package com.geniisys.gipi.controllers;

import java.io.File;
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
import com.geniisys.gipi.service.GIPIRefNoHistService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIPIRefNoHistController", urlPatterns={"/GIPIRefNoHistController"})
public class GIPIRefNoHistController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GIPIRefNoHistService gipiRefNoHistService = (GIPIRefNoHistService) appContext.getBean("gipiRefNoHistService");
			
			if("showGenerateBankRefNo".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/generateNumber/generateBankRefNo/generateBankRefNo.jsp";
			}else if("showRefNoHistOverlay".equals(ACTION)){
				JSONObject json = gipiRefNoHistService.getRefNoHistListByUser(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("refNoHistJSON", json);
					PAGE = "/pages/underwriting/utilities/generateNumber/generateBankRefNo/popups/refNoHistOverlay.jsp";
				}
			}else if("generateBankRefNo".equals(ACTION)){
				request.setAttribute("object", gipiRefNoHistService.generateBankRefNo(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			}else if("generateCSV".equals(ACTION)){
				message = gipiRefNoHistService.generateCSV(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteCSVFile".equals(ACTION)){
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/")+1, url.length());
				(new File(realPath + "\\csv\\" + fileName)).delete();
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
