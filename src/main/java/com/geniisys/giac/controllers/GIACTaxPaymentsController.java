package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACTaxPaymentsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIACTaxPaymentsController", urlPatterns={"/GIACTaxPaymentsController"})
public class GIACTaxPaymentsController extends BaseController{
	
	private static final long serialVersionUID = 1L;

	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GIACTaxPaymentsService giacTaxPaymentsService = (GIACTaxPaymentsService) appContext.getBean("giacTaxPaymentsService");
			
			if("showTaxPayments".equals(ACTION)){
				Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				JSONObject json = giacTaxPaymentsService.showTaxPayments(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					String[] args = {"GIAC_TAX_PAYMENTS.TRANSACTION_TYPE"};
					String[] argsFundCd = {"GIACS021", USER.getUserId()};
					
					LOVHelper lovHelper = (LOVHelper) appContext.getBean("lovHelper");
					List<LOV> transactionType = lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, args);
					List<LOV> fundCd = lovHelper.getList(LOVHelper.GIBR_GFUN_FUND_LISTING, argsFundCd);
					List<Integer> itemList = giacTaxPaymentsService.getGIACS021Items(gaccTranId);
					Map<String, Object> formVariables = giacTaxPaymentsService.getGIACS021Variables(gaccTranId);
					
					request.setAttribute("tranTypes", transactionType);
					request.setAttribute("fundList", fundCd);
					request.setAttribute("formVariables", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(formVariables)));
					request.setAttribute("itemList", itemList);
					request.setAttribute("taxPaymentsJSON", json);
					PAGE = "/pages/accounting/officialReceipt/otherTrans/taxPayments.jsp";
				}
			}else if("saveTaxPayments".equals(ACTION)){
				giacTaxPaymentsService.saveTaxPayments(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
