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

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISParameterController", urlPatterns={"/GIISParameterController"})
public class GIISParameterController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
		GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
		
		try {
			if("showGiiss085".equals(ACTION)){	
					PAGE = "/pages/underwriting/fileMaintenance/system/systemParameter/systemParameter.jsp";
			} else if ("getGiiss085Rec".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisParameterService.getGiiss085Rec(request, USER.getUserId());	
				JSONObject json = new JSONObject(params);
				message = json.toString();	
				PAGE = "/pages/genericMessage.jsp";														
			} else if ("saveGiiss085".equals(ACTION)) {
				giisParameterService.saveGiiss085(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiiss061".equals(ACTION)){
				JSONObject json = giisParameterService.showGiiss061(request, USER.getUserId());
				if(request.getParameter("refresh") != null) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					String defaultDateFormat = giisParameterFacadeService.getParamValueV("FORMAT_MASK").getParamValueV();
					request.setAttribute("dateFormatMask", (defaultDateFormat!=null && !defaultDateFormat.equals("")) ? defaultDateFormat : "MM-DD-RRRR" );
					request.setAttribute("jsonProgramParameterList", json);
					PAGE = "/pages/underwriting/fileMaintenance/system/programParameter/programParameter.jsp";
				}
			} else if("valAddRec".equals(ACTION)){
				giisParameterService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGiiss061".equals(ACTION)){
				giisParameterService.saveGiiss061(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("valDeleteRec".equals(ACTION)){
				giisParameterService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGisms011".equals(ACTION)) {		
				JSONObject jsonNetworkNumberList = giisParameterService.getGisms011NumberList(request, USER.getUserId());				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("assdNameFormat", giacParamService.getParamValueV2("ASSD_NAME_FORMAT"));
					request.setAttribute("intmNameFormat", giacParamService.getParamValueV2("INTM_NAME_FORMAT"));
					request.setAttribute("paramValueV", giisParameterService.getParamValueV2("GLOBE_NUMBER"));
					request.setAttribute("jsonNetworkNumberList", jsonNetworkNumberList);
					PAGE = "/pages/sms/tableMaintenance/smsParameter/smsParameter.jsp";
				} else {					
					message = jsonNetworkNumberList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getParamValueV".equals(ACTION)){
				String  paramValueV = giisParameterService.getParamValueV2(request.getParameter("paramName"));
				if(paramValueV != null){
					message = paramValueV.toString();
				}else{
					message = "";
				}
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAssdNameFormat".equals(ACTION)){
				giisParameterService.valAssdNameFormat(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valIntmNameFormat".equals(ACTION)){
				giisParameterService.valIntmNameFormat(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valGisms011AddRec".equals(ACTION)){
				giisParameterService.valGisms011AddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGisms011".equals(ACTION)) {
				giisParameterService.saveGisms011(request, USER.getUserId());
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
