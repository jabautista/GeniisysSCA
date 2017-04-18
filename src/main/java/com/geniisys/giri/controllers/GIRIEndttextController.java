package com.geniisys.giri.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.giri.service.GIRIEndttextService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIRIEndttextController", urlPatterns={"/GIRIEndttextController"})
public class GIRIEndttextController extends BaseController{	

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(GIRIEndttextController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
			try{
				ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
				GIRIEndttextService giriEndttextService = (GIRIEndttextService) APPLICATION_CONTEXT.getBean("giriEndttextService");
				
				if("showGenBinderNonAffEndtPage".equals(ACTION)){
					Integer policyId = Integer.parseInt(request.getParameter("policyId") == null || "".equals(request.getParameter("policyId"))? "0" : request.getParameter("policyId"));
					HashMap<String, Object> params = new HashMap<String, Object>();
					params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
					params.put("policyId", policyId);
					params = giriEndttextService.getRiDtlsList(params);
					log.info(params);
					request.setAttribute("riDtlsGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/reInsurance/genBinderNonAffEndt/genBinderNonAffEndt.jsp";
				}else if("refreshRiDtlsListing".equals(ACTION)){
					Integer policyId = Integer.parseInt(request.getParameter("policyId") == null || "".equals(request.getParameter("policyId"))? "0" : request.getParameter("policyId"));
					HashMap<String, Object> params = new HashMap<String, Object>();
					params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
					params.put("policyId", policyId);
					params.put("sortColumn", request.getParameter("sortColumn"));
					params.put("ascDescFlg", request.getParameter("ascDescFlg"));
					params = giriEndttextService.getRiDtlsList(params);
					JSONObject json = new JSONObject(params);
					message = StringFormatter.replaceTildes(json.toString());
					log.info(message);
					PAGE = "/pages/genericMessage.jsp";
				}else if("getRiDtlsGIUTS024".equals(ACTION)){
					Map<String, Object> params = FormInputUtil.getFormInputs(request);
					params =giriEndttextService.getRiDtlsGIUTS024(params);
					message = QueryParamGenerator.generateQueryParams(params);
					log.info(message);
					PAGE = "/pages/genericMessage.jsp";
				}else if ("updateCreateEndtTextBinder".equals(ACTION)){
					log.info("updateCreateEndtTextBinder...");
					DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
					Map<String, Object> params =  FormInputUtil.getFormInputs(request);
					Date effDate = df.parse(request.getParameter("effDate"));
					Date expiryDate = df.parse(request.getParameter("expiryDate"));
					Date dspBinderDate =df.parse(request.getParameter("dspBinderDate"));
					System.out.println(effDate+"::::::::::::::::::::::::"+expiryDate+"::::::::::::::::::::::::"+dspBinderDate);
					params.put("userId", USER.getUserId());
					params.put("effDate", effDate);
					params.put("expiryDate", expiryDate);
					params.put("dspBinderDate", dspBinderDate);
					giriEndttextService.updateCreateEndtTextBinder(params);
					log.info(message);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("deleteRiDtlsGIUTS024".equals(ACTION)) {
					Map<String, Object> params =  FormInputUtil.getFormInputs(request);
					giriEndttextService.deleteRiDtlsGIUTS024(params);
					log.info(message);
					PAGE = "/pages/genericMessage.jsp";
				}else if ("saveEndtTextBinder".equals(ACTION)){
					giriEndttextService.saveEndtTextBinder(request, USER.getUserId());
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}else if("showPrintDialog".equals(ACTION)) {
					PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
					request.setAttribute("printers", printers);	
					request.setAttribute("printers", printers);
					request.setAttribute("reportId", request.getParameter("reportId"));
					PAGE = "/pages/underwriting/reInsurance/genBinderNonAffEndt/printDialog.jsp";
				}
			} catch(SQLException e){
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";	
			} catch(Exception e){
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			} finally{
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			}		
			
	}

}
