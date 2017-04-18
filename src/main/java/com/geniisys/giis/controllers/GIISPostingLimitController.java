package com.geniisys.giis.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giis.service.GIISPostingLimitService;
import com.seer.framework.util.ApplicationContextReader;

public class GIISPostingLimitController extends BaseController {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8779975039062266181L;
	
	private static Logger log = Logger.getLogger(GIISPostingLimitController.class);

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION,
						     HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISPostingLimitService giisPostingLimitService = (GIISPostingLimitService) APPLICATION_CONTEXT.getBean("giisPostingLimitService");
		try {
			if ("getPostingLimits".equals(ACTION)) {
				JSONObject json = giisPostingLimitService.getPostingLimits(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/fileMaintenance/general/postingLimit/postingLimit.jsp";						
				}
			} else if ("savePostingLimits".equals(ACTION)) {
				giisPostingLimitService.savePostingLimits(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showCopyToAnotherUser".equals(ACTION)) {
				PAGE = "/pages/underwriting/fileMaintenance/general/postingLimit/pop-ups/copyToAnotherUser.jsp";		
			} else if ("saveCopyToAnotherUser".equals(ACTION)) {	
				giisPostingLimitService.saveCopyToAnotherUser(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateCopyUser".equals(ACTION)) {
				message = giisPostingLimitService.validateCopyUser(request);
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("validateCopyBranch".equals(ACTION)) {
				message = giisPostingLimitService.validateCopyBranch(request);
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("validateLineName".equals(ACTION)) {
				message = giisPostingLimitService.validateLineName(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
