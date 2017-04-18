package com.geniisys.giex.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXBusinessConservationService;
import com.seer.framework.util.ApplicationContextReader;

public class GIEXBusinessConservationController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2634090308683706969L;
	private static Logger log = Logger.getLogger(GIEXBusinessConservationController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIEXBusinessConservationService giexBusinessConservationService = (GIEXBusinessConservationService) APPLICATION_CONTEXT.getBean("giexBusinessConservationService");
		
		try {
			if ("showBusinessConservationPage".equals(ACTION)) {
				//LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				//List<LOV> printers = helper.getList(LOVHelper.PRINTER_LISTING);			
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);	
				PAGE = "/pages/underwriting/renewalProcessing/businessConservation/businessConservation.jsp";
			}else if("extractPolicies".equals(ACTION)) {
				String intmNo;
				if(request.getParameter("intmNo").equals("ALL")){
					intmNo = "";
				}else{
					intmNo = request.getParameter("intmNo");
				}
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("intmNo", intmNo);
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("delTable", "Y");
				params.put("incPack", request.getParameter("incPack"));
				params.put("credCd", request.getParameter("credCd"));
				params.put("intmType", request.getParameter("intmType"));
				params.put("fromMonth", request.getParameter("fromMonth"));
				params.put("userId", USER.getUserId());
				System.out.println("params=" + params);
				JSONObject result = new JSONObject(giexBusinessConservationService.extractPolicies(params)); //modified by Daniel Marasigan 07.11.2016 SR 22330
				message=result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBusConservationDetails".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("mode", request.getParameter("mode"));
				params.put("userId", USER.getUserId());
				Map<String, Object> giexBusConListTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(giexBusConListTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("lineName", request.getParameter("lineName"));
					request.setAttribute("issName", request.getParameter("issName"));
					request.setAttribute("issCd", request.getParameter("issCd"));
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giexBusConListTableGrid", json);
					PAGE = "/pages/underwriting/renewalProcessing/businessConservation/businessConservationDetails.jsp";
				}
			}else if("getBusConservationPackDetails".equals(ACTION)){
				request.setAttribute("policyNo", request.getParameter("policyNo"));
				request.setAttribute("packPolId", request.getParameter("packPolId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("packPolId", request.getParameter("packPolId"));
				params.put("userId", USER.getUserId());
				Map<String, Object> giexBusConPackListTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(giexBusConPackListTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giexBusConPackListTableGrid", json);
					PAGE = "/pages/underwriting/renewalProcessing/businessConservation/businessConservationPackDetails.jsp";
				}
			}
		} catch (Exception e) {
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
