package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPILoadHistService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPILoadHistController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWCargoController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/* default attributes */			
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			if("saveCreateToPar".equals(ACTION)) {
				GIPILoadHistService gipiLoadHistService = (GIPILoadHistService) APPLICATION_CONTEXT.getBean("gipiLoadHistService");
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
				String uploadNo = request.getParameter("uploadNo");
				String lineCd = request.getParameter("lineCd");
				String issCd  = request.getParameter("issCd");
				String userId = USER.getUserId();
				message = gipiLoadHistService.createToPar(uploadNo, parId, itemNo, "", lineCd, issCd, userId);
			}else if("refreshUploadEnrolleeTable".equals(ACTION)){
				Map<String, Object> tgLoadHist = new HashMap<String, Object>();
				
				tgLoadHist.put("ACTION", "getGIPILoadHistTG");				
				
				tgLoadHist = TableGridUtil.getTableGrid(request, tgLoadHist);
				
				message = (new JSONObject(tgLoadHist)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCreatedPar".equals(ACTION)) { //created by christian 04/29/2013
				GIPILoadHistService gipiLoadHistService = (GIPILoadHistService) APPLICATION_CONTEXT.getBean("gipiLoadHistService");
				message = new JSONArray ((List<Map<String, Object>>)StringFormatter.escapeHTMLInListOfMap(gipiLoadHistService.getUploadedEnrollees(request))).toString();
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
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
	}

}
