package com.geniisys.quote.controllers;

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
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.quote.entity.GIPIQuoteInvoice;
import com.geniisys.quote.service.GIPIQuoteInvoiceService;
import com.geniisys.quote.service.GIPIQuoteService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIQuoteInvoiceController", urlPatterns={"/GIPIQuoteInvoiceController"})
public class GIPIQuoteInvoiceController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIQuoteController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("Initializing :"+this.getClass().getSimpleName());
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIQuoteInvoiceService gipiQuoteInvoiceService = (GIPIQuoteInvoiceService)APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceService");
		
		try{
			if("showInvoiceOverlay".equals(ACTION)){
				GIPIQuoteService gipiQuoteService = (GIPIQuoteService) APPLICATION_CONTEXT.getBean("gipiQuoteService");
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIACParameterFacadeService giacParameterFacadeService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("currencyCd", request.getParameter("currencyCd"));
				GIPIQuoteInvoice invoiceInfo = gipiQuoteInvoiceService.getGipiQuoteInvoiceDtls(params);
				params.put("ACTION", "getInvoiceTaxList");
				params.put("quoteInvNo", invoiceInfo.getQuoteInvNo());
				params.put("issCd", invoiceInfo.getIssCd());
				Map<String, Object> invtaxTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(invtaxTableGrid);
				HashMap<String, Object> variables = new HashMap<String, Object>();
				variables.put("evat", giacParameterFacadeService.getParamValueN("EVAT"));
				variables.put("editTag", giisParameterFacadeService.getParamValueV2("EDIT_TAX_TO_ZERO"));
				variables.put("vatTag", gipiQuoteService.getVatTag(Integer.parseInt(request.getParameter("quoteId"))));
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("variables", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(variables)));
					request.setAttribute("invTaxTableGrid", json);
					request.setAttribute("invoiceInfo", new JSONObject(invoiceInfo != null ? StringFormatter.escapeHTMLInObject(invoiceInfo): new GIPIQuoteInvoice()));
					PAGE = "/pages/marketing/quote/subPages/invoice/invoiceOverlay.jsp";
				}
			}else if("saveInvoice".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("quoteInvNo", request.getParameter("quoteInvNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("userId", USER.getUserId());
				message = gipiQuoteInvoiceService.saveInvoice(request.getParameter("parameters"), params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIntmNo".equals(ACTION)){
				GIISIntermediaryService giisIntermediaryService = (GIISIntermediaryService)APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
				params = giisIntermediaryService.validateIntmNo(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkTaxType".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("taxCd", Integer.parseInt(request.getParameter("taxCd")));
				params.put("taxId", Integer.parseInt(request.getParameter("taxId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premAmt", request.getParameter("premAmt"));
				params.put("rate", request.getParameter("rate"));
				params = gipiQuoteInvoiceService.checkTaxType(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("showViewInvoiceOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("currencyCd", request.getParameter("currencyCd"));
				GIPIQuoteInvoice invoiceInfo = gipiQuoteInvoiceService.getGipiQuoteInvoiceDtls(params);
				params.put("ACTION", "getInvoiceTaxList");
				params.put("quoteInvNo", invoiceInfo.getQuoteInvNo());
				params.put("issCd", invoiceInfo.getIssCd());
				Map<String, Object> invtaxTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(invtaxTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("invTaxTableGrid", json);
					request.setAttribute("invoiceInfo", new JSONObject(invoiceInfo != null ? StringFormatter.escapeHTMLInObject(invoiceInfo): new GIPIQuoteInvoice()));
					PAGE = "/pages/marketing/quotation/inquiry/quotationStatus/invoice/viewInvoice.jsp";
				}
			}
		}catch(NullPointerException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
