package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLMortgageeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLMortgageeController", urlPatterns="/GICLMortgageeController")
public class GICLMortgageeController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLMortgageeController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLMortgageeService giclMortgageeService = (GICLMortgageeService) APPLICATION_CONTEXT.getBean("giclMortgageeService");
			
			if ("getMortgageeGrid".equals(ACTION)){
				log.info("Getting item mortgagee info...");
				giclMortgageeService.getGiclMortgageeGrid(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/mortgagee/subPages/mortgageeInfoAddtl.jsp" :"/pages/genericObject.jsp");
			}else if ("getMortgageeGrid2".equals(ACTION)){
				log.info("Getting item mortgagee info...");
				giclMortgageeService.getGiclMortgageeGrid(request, USER);
				PAGE = ("1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/mortgageeInfo.jsp");
			}else if("showGICLS260ItemMortgagee".equals(ACTION)){
				log.info("Getting item mortgagee info...");
				giclMortgageeService.getGiclMortgageeGrid(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/inquiry/claimInformation/itemInformation/overlay/itemMortgagee.jsp" : "/pages/genericObject.jsp");
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = ExceptionHandler.handleException(e, USER);
		//	PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
		
	}

}
