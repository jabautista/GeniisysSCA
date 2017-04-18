package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACPdcReplaceService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACPdcReplaceController", urlPatterns="/GIACPdcReplaceController")
public class GIACPdcReplaceController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 343207393809716826L;

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
				
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		try {
			if("getGIACPdcReplaceListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("pdcId", request.getParameter("pdcId"));
				params = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(params);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper lovHelper = (LOVHelper) appContext.getBean("lovHelper");
					request.setAttribute("payMode", lovHelper.getList(LOVHelper.PAY_MODE_LISTING));
					request.setAttribute("pdcReplaceTableGrid", json);					
					PAGE = "/pages/accounting/PDCPayment/subPages/replacePdc.jsp";
				}				
			} else if ("saveGIACPdcReplace".equals(ACTION)) {
				GIACPdcReplaceService pdcReplaceService = (GIACPdcReplaceService) appContext.getBean("giacPdcReplaceService");
				pdcReplaceService.saveGIACPdcReplace(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}
}
