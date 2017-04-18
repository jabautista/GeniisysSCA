package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISInspector;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISInspectorService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIISInspectorController", urlPatterns={"/GIISInspectorController"})
public class GIISInspectorController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISInspectorService giisInspectorService = (GIISInspectorService) APPLICATION_CONTEXT.getBean("giisInspectorService");
		
		try {
			if("showGiiss169".equals(ACTION)){
				JSONObject json = giisInspectorService.showGiiss169(request, USER.getUserId());
				List<GIISInspector> inspNameList = giisInspectorService.getInspNameList();
				StringFormatter.replaceQuotesInList(inspNameList);
				JSONArray jsonInspName = new JSONArray();
				for(GIISInspector i : inspNameList){
					jsonInspName.put(StringFormatter.escapeBackslash(i.getInspName()));
				}
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonInspectorList", json);
					request.setAttribute("inspNameList", jsonInspName);
					PAGE = "/pages/underwriting/fileMaintenance/fire/inspector/inspector.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisInspectorService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisInspectorService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss169".equals(ACTION)) {
				giisInspectorService.saveGiiss169(request, USER.getUserId());
				message = "SUCCESS";
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
