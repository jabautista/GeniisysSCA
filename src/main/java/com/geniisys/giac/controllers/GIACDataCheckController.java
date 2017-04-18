package com.geniisys.giac.controllers;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACDataCheckService;
import com.mchange.v2.c3p0.DataSources;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACDataCheckController", urlPatterns="/GIACDataCheckController")
public class GIACDataCheckController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACDataCheckService giacDataCheckService = (GIACDataCheckService) APPLICATION_CONTEXT.getBean("giacDataCheckService");
			
			if("showDataChecking".equals(ACTION)) {
				JSONObject jsonEOMCheckingScripts = giacDataCheckService.getEOMCheckingScripts(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonEOMCheckingScripts.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonEOMCheckingScripts", jsonEOMCheckingScripts);
					PAGE = "/pages/accounting/endOfMonth/dataChecking/dataChecking.jsp";					
				}
				
			} else if ("createCSV".equals(ACTION)) {
				Connection connection = null;
				DataSource unpooledDatasource = null;
				DataSource pooledDataSource = null;
				if(SESSION.getAttribute("connection") == null) {
					Map<String, Object> connections = giacDataCheckService.getConnection(APPLICATION_CONTEXT);
					System.out.println("connections : " + connections);
					connection = (Connection) connections.get("connection");
					pooledDataSource = (DataSource) connections.get("pooledDataSource");
					unpooledDatasource = (DataSource) connections.get("unpooledDatasource");
					SESSION.setAttribute("connection", connection);
					SESSION.setAttribute("pooledDataSource", pooledDataSource);
					SESSION.setAttribute("unpooledDatasource", unpooledDatasource);
					System.out.println("database connection created");
				} else {
					connection = (Connection) SESSION.getAttribute("connection");
				}
				String info = giacDataCheckService.createCSV(request, APPLICATION_CONTEXT, connection, (String) APPLICATION_CONTEXT.getBean("uploadPath"));
				request.setAttribute("object", info);
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("closeConnection".equals(ACTION)) {
				Connection connection = (Connection) SESSION.getAttribute("connection");
				DataSource pooledDataSource = (DataSource) SESSION.getAttribute("pooledDataSource");
				DataSource unpooledDatasource = (DataSource) SESSION.getAttribute("unpooledDatasource");
				connection.close();
				DataSources.destroy(pooledDataSource);
				DataSources.destroy(unpooledDatasource);
				SESSION.removeAttribute("connection");
				SESSION.removeAttribute("pooledDataSource");
				SESSION.removeAttribute("unpooledDatasource");
				System.out.println("connection closed");
			} else if ("deleteGeneratedFileFromServer".equals(ACTION)) {
				String realPath = request.getSession().getServletContext().getRealPath("");
				String fileName = request.getParameter("path");
				fileName = fileName.substring(fileName.lastIndexOf("/")+1, fileName.length());
				(new File(realPath + "\\csv\\" + fileName)).delete();
			}else if("patchRecords".equals(ACTION)){ //mikel 06.20.2016; GENQA 5544
				giacDataCheckService.patchRecords(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}
		} catch (SQLException e) { //mikel 07.26.2016; GENQA 5544
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
