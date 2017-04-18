package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACSlTypeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACSlTypeController", urlPatterns={"/GIACSlTypeController"})
public class GIACSlTypeController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2234016833393501273L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACSlTypeService giacSlTypeService = (GIACSlTypeService) APPLICATION_CONTEXT.getBean("giacSlTypeService");
		
		try {
			if("showGiacs308".equals(ACTION)){
				JSONObject json = giacSlTypeService.showGiacs308(request);
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String[] params = {"GIAC_SL_TYPES.SL_TAG"};
					List<LOV> slTagLOV = lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params);
					request.setAttribute("slTagLOV", slTagLOV);
					request.setAttribute("jsonSlTypeList", json);					
					PAGE = "/pages/accounting/maintenance/subsidiaryLedgerType/subsidiaryLedgerType.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteSlType".equals(ACTION)){
				giacSlTypeService.valDeleteSlType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddSlType".equals(ACTION)){
				giacSlTypeService.valAddSlType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs308".equals(ACTION)) {
				giacSlTypeService.saveGiacs308(request, USER.getUserId());
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
