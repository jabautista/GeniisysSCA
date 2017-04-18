package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLineSublineCoveragesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISLineSublineCoveragesController", urlPatterns={"/GIISLineSublineCoveragesController"})
public class GIISLineSublineCoveragesController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISLineSublineCoverages.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISLineSublineCoveragesService giisLineSublineCoveragesService = (GIISLineSublineCoveragesService) APPLICATION_CONTEXT.getBean("giisLineSublineCoveragesService"); //09.06.2013 fons
			PAGE = "/pages/genericMessage.jsp";
			if("showPackageLineCoverage".equals(ACTION)){
				JSONObject jsonPkgLineCvrg = giisLineSublineCoveragesService.showPackageLineCoverage(request, USER.getUserId());			
				if("1".equals(request.getParameter("refresh"))){					
					message = jsonPkgLineCvrg.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					JSONObject jsonPkgLineSublineCvrg = giisLineSublineCoveragesService.showPackageLineSublineCoverage(request, USER.getUserId());						
					request.setAttribute("jsonPkgLineCvrg", jsonPkgLineCvrg);					
					request.setAttribute("jsonPkgLineSublineCvrg", jsonPkgLineSublineCvrg);
					PAGE = "/pages/underwriting/fileMaintenance/multiLinePackage/packageLineSublineCoverage/packageLineSublineCoverage.jsp";				
				}			
			}else if("showPackageLineSublineCoverage".equals(ACTION)){
				JSONObject jsonPkgLineSublineCvrg = giisLineSublineCoveragesService.showPackageLineSublineCoverage(request,  USER.getUserId());						
				message = jsonPkgLineSublineCvrg.toString();
				PAGE = "/pages/genericMessage.jsp";
							
			}else if("saveGiiss096".equals(ACTION)){
				log.info("Saving Package Line/Subline Coverage Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisLineSublineCoveragesService.saveGiiss096(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";		
			}else if ("valDeleteRec".equals(ACTION)){
				giisLineSublineCoveragesService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("valAddRec".equals(ACTION)){
				giisLineSublineCoveragesService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}			
	}
}
