package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;

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
import com.geniisys.gipi.entity.GIPIAccidentItem;
import com.geniisys.gipi.service.GIPIAccidentItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIAccidentItemController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIAviationItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("doProcessing");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIAccidentItemService gipiAccidentItemService = (GIPIAccidentItemService) APPLICATION_CONTEXT.getBean("gipiAccidentItemService");

			if("getAccidentItemInfo".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIPIAccidentItem accidentItemInfo = gipiAccidentItemService.getAccidentItemInfo(params);
				if(accidentItemInfo != null){
					request.setAttribute("accidentItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(accidentItemInfo)));
				}else{
					accidentItemInfo = new GIPIAccidentItem();
					request.setAttribute("accidentItemInfo", new JSONObject(accidentItemInfo));
				}
				request.setAttribute("acItem", new JSONObject());
				PAGE="/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/accidentItemAddtlInfoOverlay.jsp";
			}else if("showGrpItemsBeneficiaryPage".equals(ACTION)){
				request.setAttribute("enrollee", new JSONObject(request.getParameter("enrollee")));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/accidentGrpItemsBeneficiaryOverlay.jsp";
			}
			
		}catch (NullPointerException e) {
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
