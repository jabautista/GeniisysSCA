package com.geniisys.giis.controllers;

import java.io.IOException;
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
import com.geniisys.giis.service.GIISMortgageeService;
import com.seer.framework.util.ApplicationContextReader;

import common.Logger;

@WebServlet(name="GIISMortgageeController", urlPatterns={"/GIISMortgageeController"})
public class GIISMortgageeController extends BaseController {

	private static final long serialVersionUID = -4444130444204953615L;
	private static Logger log = Logger.getLogger(GIISMortgageeController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			log.info("do processing");
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISMortgageeService giisMortgageeService = (GIISMortgageeService) APPLICATION_CONTEXT.getBean("giisMortgageeService");
			if("showSourceMortgageeMaintenance".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String modId = "GIISS105";
				params.put("ACTION", "getGIIS105SourceList");
				params.put("pageSize", 6);
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> sourceListing = TableGridUtil.getTableGrid(request,params);
				JSONObject json = new JSONObject(sourceListing);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("sourceListing", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/mortgagee/mortgageeMain.jsp";			
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showMortgageeMaintenance".equals(ACTION)){
				JSONObject json = giisMortgageeService.showMortgageeMaintenance(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("validateAddMortgageeCd".equals(ACTION)) {
				log.info("validating mortgagee code...");
				message = giisMortgageeService.validateAddMortgageeCd(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("validateAddMortgageeName".equals(ACTION)) {
				log.info("validating mortgagee name...");
				message = giisMortgageeService.validateAddMortgageeName(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("validateDeleteMortgagee".equals(ACTION)) {
				log.info("validating mortgagee...");
				message = giisMortgageeService.validateDeleteMortgagee(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("saveMortgagee".equals(ACTION)) {
				message = giisMortgageeService.saveMortgagee(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
