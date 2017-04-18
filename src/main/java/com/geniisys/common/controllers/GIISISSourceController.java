package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISISSourceController", urlPatterns={"/GIISISSourceController"})
public class GIISISSourceController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISISSourceFacadeService giisIssourceService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
			
			if("showGiiss004".equals(ACTION)){
				JSONObject json = giisIssourceService.showGiiss004(request, USER.getUserId());
				json.append("acctIssCdList", giisIssourceService.getAcctIssCdList());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonIssuingSource", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/issuingSource/issuingSource.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeleteRec".equals(ACTION)){
				giisIssourceService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisIssourceService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss004".equals(ACTION)) {
				giisIssourceService.saveGiiss004(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			//GIIS_ISSOURCE_PLACE
			}else if("showGiiss004Place".equals(ACTION)){
				JSONObject json = giisIssourceService.showGiiss004Place(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonIssourcePlace", json);
					request.setAttribute("issCd", request.getParameter("issCd"));
					request.setAttribute("recList", giisIssourceService.getAllIssuePlaces(request, USER.getUserId()));
					PAGE = "/pages/underwriting/fileMaintenance/general/issuingSource/popup/issuingSourcePlace.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeletePlaceRec".equals(ACTION)){
				giisIssourceService.valDeletePlaceRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddPlaceRec".equals(ACTION)){
				giisIssourceService.valAddPlaceRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss004Place".equals(ACTION)) {
				giisIssourceService.saveGiiss004Place(request, USER.getUserId());
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
