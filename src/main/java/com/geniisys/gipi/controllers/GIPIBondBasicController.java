package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.service.GIPIBondBasicService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIPIBondBasicController", urlPatterns={"/GIPIBondBasicController"})
public class GIPIBondBasicController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIBondBasicService gipiBondBasicService = (GIPIBondBasicService) APPLICATION_CONTEXT.getBean("gipiBondBasicService");
			
			if ("showBondPolicyData".equals(ACTION)){
				gipiBondBasicService.getBondPolicyData(request, USER);
				PAGE = "/pages/claims/claimBasicInformation/subPages/bondPolicyData.jsp";
			}else if("showGipiCosigntry".equals(ACTION)){
				gipiBondBasicService.getGipiCosigntry(Integer.parseInt(request.getParameter("policyId")), request);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/bondPolicyData.jsp";
			}
			
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
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
