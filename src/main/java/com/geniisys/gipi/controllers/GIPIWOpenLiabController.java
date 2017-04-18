/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIWOpenLiab;
import com.geniisys.gipi.service.GIPIWOpenLiabService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWOpenLiabController.
 */
public class GIPIWOpenLiabController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6291959978219216453L;
	private static Logger log = Logger.getLogger(GIPIWOpenLiabController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWOpenLiabService openLiabService = (GIPIWOpenLiabService) APPLICATION_CONTEXT.getBean("gipiWOpenLiabService");
			
			int parId 	     = Integer.parseInt((request.getParameter("globalParId") == null || request.getParameter("globalParId") == "") ? "0" : request.getParameter("globalParId"));
			int geogCd 		 = Integer.parseInt((request.getParameter("geogCd") == null || request.getParameter("geogCd") == "") ? "0" : request.getParameter("geogCd"));
			
			if("showLimitsOfLiabilityPage".equals(ACTION)){
				String lineCd 	 = (request.getParameter("globalLineCd") == null) ? "" : request.getParameter("globalLineCd");
				String sublineCd = (request.getParameter("globalSublineCd") == null) ? "" : request.getParameter("globalSublineCd");
				int mode		 = Integer.parseInt(request.getParameter("mode"));
				int assdNo		 = Integer.parseInt((request.getParameter("globalAssdNo") == null) ? "0" : request.getParameter("globalAssdNo"));
				String assdName	 = (request.getParameter("globalAssdName") == null ? "" : request.getParameter("globalAssdName"));
				String parNo	 = (request.getParameter("globalParNo") == null ? "" : request.getParameter("globalParNo"));
				System.out.println("PAR NO!!!!!!!!!!!!!!!!!!! ----------" + parNo);
				PAGE = "/pages/underwriting/limitsOfLiability.jsp";
				//GIPIWOpenLiab openLiab = openLiabService.getWOpenLiab(parId);
				GIPIWOpenLiab openLiab = openLiabService.getWOpenLiab(parId, lineCd);
				
				LOVHelper lovHelper   = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> currencies  = lovHelper.getList(LOVHelper.CURRENCY_CODES);
				List<LOV> geographies = lovHelper.getList(LOVHelper.ALL_GEOG_LISTING);
				String[] args 		= {lineCd, sublineCd};
				List<LOV> perils 	= lovHelper.getList(LOVHelper.ENDT_PERIL_LISTING, args);
				StringFormatter.replaceQuotesInList(perils);
				/*DecimalFormat decFormat = new DecimalFormat("#.#########");
				float cRate = 0;
				for(int i=0; i<currencies.size();i++) {
					cRate = currencies.get(i).getValueFloat();
					currencies.get(i).setValueFloat(Float.parseFloat(decFormat.format(cRate)));
					System.out.println("check money " + i + ": " + currencies.get(i).getValueFloat() + " "
							+ currencies.get(i).getCode() + " " + currencies.get(i).getDesc() + " " + currencies.get(i).getShortName());
				}*/
				request.setAttribute("openLiab", openLiab);
				request.setAttribute("currencies", currencies);
				request.setAttribute("geographies", geographies);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("mode", mode);
				request.setAttribute("perils", perils);
				/*
				if (1 == mode){
					List<LOV> classes = lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING);
					request.setAttribute("classes", classes);
				}*/
			} else if ("showCargoClass".equals(ACTION)){
				LOVHelper lovHelper   = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> classes = lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING);
				StringFormatter.replaceQuotesInList(classes);
				request.setAttribute("classes", new JSONArray(classes));
				PAGE = "/pages/underwriting/pop-ups/cargoClassList.jsp";
			} else if("saveLimitOfLiability".equals(ACTION)){
				// set gipiWOpenLiab parameters
				int delGeogCd = Integer.parseInt((request.getParameter("delGeogCd") == null || request.getParameter("delGeogCd") == "" ? "0" : request.getParameter("delGeogCd")));
				
				Map<String, Object> delWOpenLiab = new HashMap<String, Object>();
				delWOpenLiab.put("parId", parId);
				delWOpenLiab.put("geogCd", delGeogCd);
				
				int currencyCd 				= Integer.parseInt(request.getParameter("currencyCd"));	
				BigDecimal currencyRate 	= (request.getParameter("inputCurrencyRate").isEmpty() ? null : new BigDecimal(request.getParameter("inputCurrencyRate")));
				BigDecimal limitOfLiability = (request.getParameter("inputLimit").isEmpty() ? null : new BigDecimal(request.getParameter("inputLimit").replaceAll(",", "")));
				String voyLimit				= request.getParameter("inputVoyLimit");
				String withInvoiceTag		= request.getParameter("withInvoiceTag");
				
				System.out.println("Controller - limitofliab: " + limitOfLiability);
					
				Map<String, Object> insWOpenLiab = new HashMap<String, Object>();
				
				insWOpenLiab.put("parId", parId);
				insWOpenLiab.put("geogCd", geogCd);
				insWOpenLiab.put("currencyCd", currencyCd);
				insWOpenLiab.put("currencyRate", currencyRate);
				insWOpenLiab.put("limitOfLiability", limitOfLiability);
				insWOpenLiab.put("voyLimit", voyLimit);
				insWOpenLiab.put("withInvoiceTag", withInvoiceTag);
				insWOpenLiab.put("userId", USER.getUserId());
						
				// set gipiWOpenCargo parameters
				String[] insCargoClassCds = request.getParameterValues("insCargoClassCd");
				String[] delCargoClassCds = request.getParameterValues("delCargoClassCd");
				
				Map<String, Object> delWOpenCargo = new HashMap<String, Object>();
				delWOpenCargo.put("cargoClassCds", delCargoClassCds);
				delWOpenCargo.put("parId", parId);
				delWOpenCargo.put("geogCd", geogCd);
							
				Map<String, Object> insWOpenCargo = new HashMap<String, Object>();
				insWOpenCargo.put("cargoClassCds", insCargoClassCds);
				insWOpenCargo.put("parId", parId);
				insWOpenCargo.put("geogCd", geogCd);
				insWOpenCargo.put("userId", USER.getUserId());
				
				// set gipiWOpenPeril parameters
				String[] delPerilCds  = request.getParameterValues("delPerilCd");
				String lineCd 		  = (request.getParameter("globalLineCd") == null) ? "" : request.getParameter("globalLineCd");
				String[] perilCds 	  = request.getParameterValues("insPerilCd");
				String[] premiumRates = request.getParameterValues("insPremiumRate");
				String[] remarks 	  = request.getParameterValues("insRemarks");
				
				Map<String, Object> delWOpenPeril = new HashMap<String, Object>();
				delWOpenPeril.put("parId", parId);
				delWOpenPeril.put("geogCd", geogCd);
				delWOpenPeril.put("lineCd", lineCd);
				delWOpenPeril.put("perilCds", delPerilCds);
				System.out.println("servlet premium rate" + premiumRates);
				
				Map<String, Object> insWOpenPeril = new HashMap<String, Object>();
				insWOpenPeril.put("parId", parId);
				insWOpenPeril.put("geogCd", geogCd);
				insWOpenPeril.put("lineCd", lineCd);
				insWOpenPeril.put("perilCds", perilCds);
				insWOpenPeril.put("premiumRates", premiumRates);
				insWOpenPeril.put("remarks", remarks);
				insWOpenPeril.put("userId", USER.getUserId());
				
				// set getRecFlag Parameters 
				Map<String, Object> checkParams = new HashMap<String, Object>();
				String parType   = request.getParameter("globalParType");
				String sublineCd = request.getParameter("globalSublineCd");
				String issCd  	 = request.getParameter("globalIssCd");
				Integer issueYy  = request.getParameter("globalIssueYy") == "" ? null : Integer.parseInt(request.getParameter("globalIssueYy"));
				Integer polSeqNo = request.getParameter("globalPolSeqNo") == "" ? null : Integer.parseInt(request.getParameter("globalPolSeqNo"));
				
				//checkParams.put("mode", mode);
				checkParams.put("parId", parId);
				checkParams.put("parType", parType);
				checkParams.put("geogCd", geogCd);
				checkParams.put("lineCd", lineCd);
				checkParams.put("sublineCd", sublineCd);
				checkParams.put("issCd", issCd);
				checkParams.put("issueYy", issueYy);
				checkParams.put("polSeqNo", polSeqNo);
				checkParams.put("limitOfLiability", limitOfLiability);
				
				// all Parameters
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("delWOpenLiab", delWOpenLiab);
				params.put("insWOpenLiab", insWOpenLiab);
				params.put("delWOpenCargo", delWOpenCargo);
				params.put("insWOpenCargo", insWOpenCargo);
				params.put("delWOpenPeril", delWOpenPeril);
				params.put("insWOpenPeril", insWOpenPeril);
				params.put("checkParams", checkParams);
				
				openLiabService.saveLimitOfLiability(params);
				
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			} else if ("deleteLimitOfLiability".equals(ACTION)){
				openLiabService.deleteWOpenLiab(parId, geogCd);
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			} else if ("showEndtLimitsOfLiabilityPage".equals(ACTION)){
				LOVHelper lovHelper   = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> currencies  = lovHelper.getList(LOVHelper.CURRENCY_CODES);
				List<LOV> geographies = lovHelper.getList(LOVHelper.ALL_GEOG_LISTING);
				
				GIPIWOpenLiab openLiab = openLiabService.getWOpenLiab(parId, "");
				HashMap<String, Object> vars = openLiabService.getEndtLolVars(parId);
				
				request.setAttribute("vars", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(vars)));
				request.setAttribute("parType", "E");
				request.setAttribute("openLiab", openLiab);
				request.setAttribute("currencies", currencies);
				request.setAttribute("geographies", geographies);
				PAGE = "/pages/underwriting/endt/jsonMarineCargo/limitsOfLiability/endtLimitsOfLiability.jsp";
			}  else if ("getDefaultCurrency".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = openLiabService.getDefaultCurrency(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("saveEndtLimitsOfLiability".equals(ACTION)){
				openLiabService.saveEndtLimitOfLiability(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkRiskNote".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = openLiabService.checkRiskNote(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if("showEndtLimitsOfLiabilityDataEntry".equals(ACTION)){
				// For GIPIS173: Endorsement - Limits of Liabilities Data Entry 
				 
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> currencies = lovHelper.getList(LOVHelper.CURRENCY_CODES);
				List<LOV> geographies = lovHelper.getList(LOVHelper.ALL_GEOG_LISTING);
				
				GIPIWOpenLiab openLiab = openLiabService.getWOpenLiab(parId, "");
				HashMap<String, Object> vars = openLiabService.getEndtLolVars(parId);
				
				request.setAttribute("vars", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(vars)));
				request.setAttribute("parType", "E");
				request.setAttribute("openLiab", openLiab);
				request.setAttribute("currencies", currencies);
				request.setAttribute("geographies", geographies);
				PAGE = "/pages/underwriting/endt/basicInfo1/endtLimitsOfLiabilityDataEntry.jsp";
			} else if("getDefaultCurrencyGIPIS173".equals(ACTION)){
				// For GIPIS173
				Map<String, Object> params = new HashMap<String, Object>();
				params = openLiabService.getDefaultCurrencyGIPIS173(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if("saveEndtLolGIPIS173".equals(ACTION)){
				// For GIPIS173
				
				message = openLiabService.saveEndtLolGIPIS173(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("getRecFlagGIPIS173".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = openLiabService.getRecFlagGIPIS173(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
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
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}
}