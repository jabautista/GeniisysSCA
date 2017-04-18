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
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXItmperilGroupedService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXItmperilGroupedController", urlPatterns={"/GIEXItmperilGroupedController"})
public class GIEXItmperilGroupedController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIEXItmperilGroupedController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXItmperilGroupedService	giexItmperilGroupedService = (GIEXItmperilGroupedService) APPLICATION_CONTEXT.getBean("giexItmperilGroupedService");
			
			if ("getGIEXS007B480GrpInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				Map<String, Object> b480GrpDtls = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(b480GrpDtls);
				request.setAttribute("perilCdExist", json.getString("total"));
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("b480GrpDtls", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/subPages/itmPerilGrpInfo.jsp";
				}
			}else if ("getGIEXS007B490GrpInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo")); //Added by Jerome Bautista 11.27.2015 SR 21016
				Map<String, Object> b490GrpDtls = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(b490GrpDtls);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("b490GrpDtls", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/subPages/editItmPerilGrp.jsp";
				}
			}else if("deletePerilGrpGIEXS007".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexItmperilGroupedService.deletePerilGrpGIEXS007(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("createPerilGrpGIEXS007".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexItmperilGroupedService.createPerilGrpGIEXS007(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGIEXItmperilGrouped".equals(ACTION)){
				giexItmperilGroupedService.saveGIEXItmperilGrouped(request, USER.getUserId());
				message = "SUCCESS";
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
