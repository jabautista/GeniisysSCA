package com.geniisys.giac.controllers;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACAmlaCoveredTransactionService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name = "GIACAmlaCoveredTransactionController", urlPatterns = { "/GIACAmlaCoveredTransactionController" })
public class GIACAmlaCoveredTransactionController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GIACAmlaCoveredTransactionService giacAmlaCoveredTransactionService = (GIACAmlaCoveredTransactionService) appContext.getBean("giacAmlaCoveredTransactionService");

			if ("showAmlaCoveredTransactionReports".equals(ACTION)) {
				PAGE = "/pages/accounting/generalLedger/report/amlaCoveredTransactionReports.jsp";
			} else if ("deleteAmlaRecord".equals(ACTION)) {
				message = giacAmlaCoveredTransactionService.deleteAmlaRecord(USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("insertAmlaRecord".equals(ACTION)) {
				message = new JSONObject(giacAmlaCoveredTransactionService.insertAmlaRecord(request, USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getAmlaBranch".equals(ACTION)) {
				message = giacAmlaCoveredTransactionService.getAmlaBranch(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteCSVFile".equals(ACTION)) {
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/") + 1, url.length());
			    (new File(realPath + "\\csv\\amla\\" + fileName)).delete();
			    message = fileName;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deletePreForm".equals(ACTION)) {
				String url = request.getParameter("url");
				FileUtils.deleteDirectory(new File(url));
			} else if ("checkIfOpen".equals(ACTION)) {
				try {
					String url = request.getParameter("url");
					FileUtils.deleteDirectory(new File(url));
					message = "Proceed Generation";
				} catch (IOException e) {
					message = "Unable to delete file";
				}
				PAGE = "/pages/genericMessage.jsp";
			} else if ("renameFile".equals(ACTION)) {
				String url = request.getParameter("url");
				String name = request.getParameter("name");
				String reversed = new StringBuilder(name).reverse().toString();
				String newFileName = new StringBuilder(reversed.replace(reversed.substring((reversed.lastIndexOf(".") + 3), 12), "")).reverse().toString();
				(new File(url + name)).renameTo(new File(url + newFileName));
				message = newFileName;
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if (e.getErrorCode() > 20000) {
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
