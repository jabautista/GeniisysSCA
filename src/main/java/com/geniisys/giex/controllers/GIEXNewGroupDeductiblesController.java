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
import com.geniisys.giex.service.GIEXNewGroupDeductiblesService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXNewGroupDeductiblesController", urlPatterns={"/GIEXNewGroupDeductiblesController"})
public class GIEXNewGroupDeductiblesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIEXNewGroupDeductiblesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXNewGroupDeductiblesService giexNewGroupDeductiblesService = (GIEXNewGroupDeductiblesService) APPLICATION_CONTEXT.getBean("giexNewGroupDeductiblesService");
			
			if ("populateDeductiblesGIEXS007".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				Map<String, Object> deductibles = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(deductibles);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("deductibles", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/pop-ups/editDeductibles.jsp";
				}
			} else if("saveGIEXNewGroupDeductibles".equals(ACTION)){
				giexNewGroupDeductiblesService.saveGIEXNewGroupDeductibles(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteModNewGroupDeductibles".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				giexNewGroupDeductiblesService.deleteModNewGroupDeductibles(params);
			} else if("validateIfDeductibleExists".equals(ACTION)){
				Integer result = giexNewGroupDeductiblesService.validateIfDeductibleExists(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("countTsiDed".equals(ACTION)){
				String policyId = request.getParameter("policyId");
				message = giexNewGroupDeductiblesService.countTsiDed(policyId).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDeductibleCurrency".equals(ACTION)){
				String policyId = request.getParameter("policyId");
				message = giexNewGroupDeductiblesService.getDeductibleCurrency(policyId).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	

}
