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
import com.geniisys.common.service.GIISLossTaxesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIISLossTaxesController", urlPatterns={"/GIISLossTaxesController"})
public class GIISLossTaxesController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISLossTaxesService giisLossTaxesService = (GIISLossTaxesService) APPLICATION_CONTEXT.getBean("giisLossTaxesService");
		
		try {
			if("showGicls106".equals(ACTION)){
				JSONObject json = giisLossTaxesService.showGicls106(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonLossExpTax", json);
					PAGE = "/pages/claims/tableMaintenance/lossExpenseTax/lossExpenseTax.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				//message = giisAirTypeService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				//giisAirTypeService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls106".equals(ACTION)) {
				giisLossTaxesService.saveGicls106(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGicls106Tax".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLossTaxesService.validateGicls106Tax(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGicls106Branch".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLossTaxesService.validateGicls106Branch(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showTaxRateHistory".equals(ACTION)){
				JSONObject jsonTaxRateHistory = giisLossTaxesService.showTaxRateHistory(request, USER.getUserId());
				request.setAttribute("lossTaxId", request.getParameter("lossTaxId"));
				request.setAttribute("taxCd", request.getParameter("taxCd"));
				request.setAttribute("taxDesc", request.getParameter("taxDesc"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonTaxRateHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonTaxRateHistory", jsonTaxRateHistory);
					PAGE = "/pages/claims/tableMaintenance/lossExpenseTax/subPages/taxRateHistory.jsp";					
				}
			} else if("showCopyTax".equals(ACTION)){
				JSONObject jsonCopyTax = giisLossTaxesService.showCopyTax(request, USER.getUserId());
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				request.setAttribute("objIssCd", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				request.setAttribute("taxType", request.getParameter("taxType"));
				request.setAttribute("taxCd", request.getParameter("taxCd"));
				request.setAttribute("taxName", request.getParameter("taxName"));
				request.setAttribute("taxRate", request.getParameter("taxRate"));
				request.setAttribute("startDate", request.getParameter("startDate"));
				request.setAttribute("endDate", request.getParameter("endDate"));
				request.setAttribute("glAcctId", request.getParameter("glAcctId"));
				request.setAttribute("slTypeCd", request.getParameter("slTypeCd"));
				request.setAttribute("remarks", request.getParameter("remarks"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCopyTax.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCopyTax", jsonCopyTax);
					PAGE = "/pages/claims/tableMaintenance/lossExpenseTax/subPages/copyTax.jsp";					
				}
			} else if ("copyTaxToIssuingSource".equals(ACTION)) {
				giisLossTaxesService.copyTaxToIssuingSource(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGicls106LossTaxes".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLossTaxesService.validateGicls106LossTaxes(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showLineLossExp".equals(ACTION)){
				JSONObject jsonLineLossExp = giisLossTaxesService.showLineLossExp(request, USER.getUserId());
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lossTaxId", request.getParameter("lossTaxId"));
				params.put("issCd", request.getParameter("issCd"));
				request.setAttribute("objectParams", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				if("1".equals(request.getParameter("refresh"))){	
					message = jsonLineLossExp.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLineLossExp", jsonLineLossExp);
					PAGE = "/pages/claims/tableMaintenance/lossExpenseTax/subPages/lineLossExp.jsp";					
				}
			} else if ("saveLineLossExp".equals(ACTION)) {
				giisLossTaxesService.saveLineLossExp(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valLineLossExp".equals(ACTION)){
				message = giisLossTaxesService.valLineLossExp(request);
				PAGE = "/pages/genericMessage.jsp";				
			} else if("validateGicls106Line".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLossTaxesService.validateGicls106Line(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGicls106LossExp".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLossTaxesService.validateGicls106LossExp(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showLineLossExpHistory".equals(ACTION)){
				JSONObject jsonLineLossExpHistory = giisLossTaxesService.showLineLossExpHistory(request, USER.getUserId());
				request.setAttribute("lossTaxId", request.getParameter("lossTaxId"));
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("lossExpCd", request.getParameter("lossExpCd"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLineLossExpHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLineLossExpHistory", jsonLineLossExpHistory);
					PAGE = "/pages/claims/tableMaintenance/lossExpenseTax/subPages/lineLossExpHistory.jsp";	
				}
			} else if("showCopyTaxLine".equals(ACTION)){
				JSONObject jsonCopyTax = giisLossTaxesService.showCopyTax(request, USER.getUserId());
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				request.setAttribute("objIssCd", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				request.setAttribute("taxType", request.getParameter("taxType"));
				request.setAttribute("taxCd", request.getParameter("taxCd"));
				request.setAttribute("taxName", request.getParameter("taxName"));
				request.setAttribute("taxRate", request.getParameter("taxRate"));
				request.setAttribute("startDate", request.getParameter("startDate"));
				request.setAttribute("endDate", request.getParameter("endDate"));
				request.setAttribute("glAcctId", request.getParameter("glAcctId"));
				request.setAttribute("slTypeCd", request.getParameter("slTypeCd"));
				request.setAttribute("remarks", request.getParameter("remarks"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCopyTax.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCopyTax", jsonCopyTax);
					PAGE = "/pages/claims/tableMaintenance/lossExpenseTax/subPages/copyTaxLine.jsp";					
				}
			} else if ("copyTaxToIssuingSourceAndTaxLine".equals(ACTION)) {
				giisLossTaxesService.copyTaxToIssuingSourceAndTaxLine(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkCopyTaxLineBtn".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLossTaxesService.checkCopyTaxLineBtn(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
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
