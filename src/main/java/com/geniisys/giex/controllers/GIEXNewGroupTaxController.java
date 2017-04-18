package com.geniisys.giex.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXNewGroupTaxService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXNewGroupTaxController", urlPatterns={"/GIEXNewGroupTaxController"})
public class GIEXNewGroupTaxController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIEXNewGroupTaxController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXNewGroupTaxService giexNewGroupTaxService = (GIEXNewGroupTaxService) APPLICATION_CONTEXT.getBean("giexNewGroupTaxService");
			
			if ("getGIEXS007B880Info".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				Map<String, Object> taxChargesTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(taxChargesTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("taxChargesTableGrid", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/pop-ups/editTaxCharges.jsp";
				}
			} else if("saveGIEXNewGroupTax".equals(ACTION)){
				giexNewGroupTaxService.saveGIEXNewGroupTax(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteModNewGroupTax".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				giexNewGroupTaxService.deleteModNewGroupTax(params);
			}else if("computeNewTaxAmt".equals(ACTION)){
				message = giexNewGroupTaxService.computeNewTaxAmt(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
		
	}

}
