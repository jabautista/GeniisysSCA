/**
 * 
 */
package com.geniisys.common.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISPackageBenefitService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 *
 */
@WebServlet(name="GIISPackageBenefitController", urlPatterns="/GIISPackageBenefitController") 
public class GIISPackageBenefitController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6452122333851408163L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISPackageBenefitService giisPackageBenefitService = (GIISPackageBenefitService) APPLICATION_CONTEXT.getBean("giisPackageBenefitService");
		try{
			if("showGiiss120".equals(ACTION)){
				JSONObject json = giisPackageBenefitService.showGiiss120(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIISPackageBenefit", json);
					PAGE = "/pages/underwriting/fileMaintenance/personalAccident/packageBenefit/packageBenefit.jsp";
				}	
			}else if("showAllGiiss120".equals(ACTION)){
				JSONObject json = giisPackageBenefitService.showAllGiiss120(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisPackageBenefitService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("valDeleteRec".equals(ACTION)){
				giisPackageBenefitService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("saveGiiss120".equals(ACTION)) {
				giisPackageBenefitService.saveGiiss120(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("computeTotalAmount".equals(ACTION)){
				BigDecimal total = new BigDecimal(request.getParameter("total"));
				BigDecimal val1 = new BigDecimal(request.getParameter("val1"));
				BigDecimal val2 = new BigDecimal(request.getParameter("val2"));
				String mode = request.getParameter("mode");
				if (mode.equals("add")) {
					total = total.add(val1);
				} else  if(mode.equals("update")) {
					total = total.add((val1.subtract(val2)));
				} else  if(mode.equals("delete")) {
					total = total.subtract(val1);
				}
				message = total.toString();
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
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}

