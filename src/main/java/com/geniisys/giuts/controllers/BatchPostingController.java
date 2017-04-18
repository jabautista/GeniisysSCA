package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

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
import com.geniisys.giuts.service.BatchPostingService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="BatchPostingController", urlPatterns={"/BatchPostingController"})
public class BatchPostingController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3584505388875751710L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIISISSourceFacadeService giisIssourceFacadeService = (GIISISSourceFacadeService) appContext.getBean("giisIssourceFacadeService");
		BatchPostingService batchPostingService = (BatchPostingService) appContext.getBean("batchPostingService");
		try {
			if("showBatchPosting".equals(ACTION)){
				JSONObject jsonBatchPosting = batchPostingService.getParListForBatchPosting(request, USER);
				if("1".equals(request.getParameter("ajax"))){
					PAGE = "/pages/underwriting/utilities/batchPosting/batchPosting.jsp";
				}else{
					message = jsonBatchPosting.toString();
					PAGE = "/pages/genericMessage.jsp";		
				}
			}else if ("showLogForBatchPosting".equals(ACTION)) {
				JSONObject jsonLog = batchPostingService.getPostedLogForBatchPosting(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLog.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					JSONObject jsonErroLog = batchPostingService.getErrorLogForBatchPosting(request, USER); //added USER by kenneth L. 02.10.2014
					message = jsonErroLog.toString();
					PAGE = "/pages/underwriting/utilities/batchPosting/subPages/logForBatchPosting.jsp";
				}
			}else if ("showErroLogForBatchPosting".equals(ACTION)) {
				JSONObject jsonErroLog = batchPostingService.getErrorLogForBatchPosting(request, USER); //added USER by kenneth L. 02.10.2014
				message = jsonErroLog.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showParameterForBatchPosting".equals(ACTION)) {
				String issCd = giisIssourceFacadeService.getIssCdForBatchPosting(USER);
				request.setAttribute("issCd", issCd);
				request.setAttribute("appUser", USER.getUserId());
				PAGE = "/pages/underwriting/utilities/batchPosting/subPages/parameterForBatchPosting.jsp";
			}else if ("getParListByParameter".equals(ACTION)) {
				message = (new JSONObject(batchPostingService.getParListByParameter(request, USER))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("deleteLog".equals(ACTION)) {
				batchPostingService.deleteLog(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkIfBackEndt".equals(ACTION)) {
				message = batchPostingService.checkIfBackEndt(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("batchPost".equals(ACTION)) {
				request.getSession();
				@SuppressWarnings("unchecked")
				Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
				if (null != sessionParameters){
					USER = (GIISUser) sessionParameters.get("USER");
				}
				message = batchPostingService.batchPost(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e){
			System.out.println(e.getErrorCode());
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

