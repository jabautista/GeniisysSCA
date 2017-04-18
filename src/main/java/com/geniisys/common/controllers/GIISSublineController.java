package com.geniisys.common.controllers;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISSublineController", urlPatterns="/GIISSublineController")
public class GIISSublineController extends BaseController {
	private static final long serialVersionUID = 359746053128621099L;
	
	private static Logger log = Logger.getLogger(GIISSublineController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("");
		
		try {
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISSublineFacadeService giisSublineService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
			
			if("getSublineMaintenance".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS002";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("userId", USER.getUserId());
				Map<String, Object> sublineMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(sublineMaintenance);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("sublineMaintenance", json);
					PAGE="/pages/common/subline/sublineMaintenance.jsp";
					System.out.println(json.toString());
				
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getSublineLov".equals(ACTION)) {
				String lineCd = request.getParameter("lineCd");
				HashMap<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", ACTION);
				String modId = "GIISS002";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("lineCd", lineCd);
				Map<String, Object> subline = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(subline);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("sublineMaintenance", json);
					PAGE="/pages/common/subline/sublineMaintenanceInfo.jsp";
					System.out.println("lov "+json.toString());
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveSubline".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("appUser", USER.getUserId());
				params.put("lineCd", lineCd);
				params.put("sublineTime", request.getParameter("sublineTime").toString());
				System.out.println(params);
				message = giisSublineService.saveSubline(request.getParameter("param"),  params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteSubline".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				System.out.println(request.getParameter("validating subline to delete"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("sublineCd",request.getParameter("param"));
				message = giisSublineService.validateDeleteSubline(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAddSubline".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				System.out.println("validating subline to add");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("sublineCd",request.getParameter("param"));
				message = giisSublineService.validateAddSubline(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAcctSublineCd".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("acctSublineCd",request.getParameter("acctSublineCd"));
				System.out.println(params);
				message = giisSublineService.validateAcctSublineCd(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateOpenSw".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				System.out.println(params);
				message = giisSublineService.validateOpenSw(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateOpenFlag".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				System.out.println(params);
				message = giisSublineService.validateOpenFlag(params);
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
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			log.error(e);
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
		
	}
	
}

