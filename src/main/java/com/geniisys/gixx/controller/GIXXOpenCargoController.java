package com.geniisys.gixx.controller;

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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXOpenCargoController", urlPatterns="/GIXXOpenCargoController")
public class GIXXOpenCargoController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXOpenCargoController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			if("getGIXXOpenCargoList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("geogCd", Integer.parseInt(request.getParameter("geogCd")));
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("openCargoList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));			
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/openCargoTable.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
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
