/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
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
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISQuoteInvSeq;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteInvoice;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteInvTaxFacadeService;
import com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuotationInvoiceController.
 */
public class GIPIQuotationInvoiceController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -3533181057593847314L;
	
	/** The log. */
	private Logger log = Logger.getLogger(GIPIQuotationInvoiceController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			/* Services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if("showQuoteInvoicePage".equals(ACTION)){
				GIPIQuoteInvoiceFacadeService gipiQuoteInvoiceService = (GIPIQuoteInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceFacadeService"); // + env
				//GIISTaxPerilService giisTaxPerilService = (GIISTaxPerilService) APPLICATION_CONTEXT.getBean("giisTaxPerilService"); // + env

				GIISQuoteInvSeq invSeq = gipiQuoteInvoiceService.getGIPIQuoteInvSeq(gipiQuote.getIssCd(), USER.getUserId());
				invSeq.setQuoteInvNo(invSeq.getQuoteInvNo()+1);

				Integer currentSequence = 1;
				
				try{
					System.out.println("0001");
					currentSequence = gipiQuoteInvoiceService.getCurrentInvoiceSequence(gipiQuote.getIssCd(), USER.getUserId());
					System.out.println("0002");
				}catch (SQLException e) {
					System.out.println("0003-sqlException");
					currentSequence = 1;
					log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				}catch (Exception e) {
					System.out.println("0003-exception");
					currentSequence = 1;
					log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				}
				
				//request.setAttribute("invoiceSequence", new JSONObject(invSeq.getQuoteInvNo()));
				request.setAttribute("invoiceSequence", currentSequence);
				
				List<GIPIQuoteInvoice> invoiceList = gipiQuoteInvoiceService.getGIPIQuoteInvoices(quoteId, gipiQuote.getIssCd(), gipiQuote.getLineCd());
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				invoiceList = (List<GIPIQuoteInvoice>) StringFormatter.replaceQuotesInList(invoiceList);
				// LOV's
				List<LOV> intermediaryList = helper.getList(LOVHelper.INTM_LISTING);
				request.setAttribute("intermediaryLov", new JSONArray((List<LOV>)StringFormatter.replaceQuotesInList(intermediaryList)));
				
				String[] args = {gipiQuote.getLineCd(),gipiQuote.getIssCd(),String.valueOf(quoteId)};
				List<LOV> taxList = helper.getList(LOVHelper.TAX_LISTING,args);

				request.setAttribute("invoiceTaxLov", new JSONArray((List<LOV>)StringFormatter.replaceQuotesInList(taxList)));
				request.setAttribute("invoiceTaxLovEL", (List<GIPIQuoteInvoice>)StringFormatter.replaceQuotesInList(taxList));
				request.setAttribute("invoiceList", new JSONArray((List<GIPIQuoteInvoice>)StringFormatter.replaceQuotesInList(invoiceList)));
				
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/quoteInvoiceInformation.jsp";
				System.out.println("DEV: page - " + PAGE);
				message = "SUCCESS";
			}else if ("saveInvoice".equalsIgnoreCase(ACTION)){  // DEPRECATE THIS
				GIPIQuoteInvoiceFacadeService gipiQuoteInvoiceService = (GIPIQuoteInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceFacadeService"); // + env
				
				String[] taxCodes	= request.getParameterValues("taxCode");
				String[] taxDescs	= request.getParameterValues("taxDesc");
				String[] taxAmts	= request.getParameterValues("taxAmount");
				String[] taxIds		= request.getParameterValues("taxId");
				String[] rates		= request.getParameterValues("rateInv");
				
				String invNo = request.getParameter("invNo");
				
				int invInt				= Integer.parseInt((invNo.replaceAll(" ", "").substring(invNo.indexOf("-")) == null) ? "0" : (invNo.replaceAll(" ", "").substring(invNo.indexOf("-"))));
				int currCd				= Integer.parseInt(request.getParameter("currencyCd"));
				String currDesc			= request.getParameter("currencyDesc");
				BigDecimal currRate		= new BigDecimal(request.getParameter("rate").replaceAll(",", ""));
				BigDecimal premAmt		= new BigDecimal(request.getParameter("premAmt").replaceAll(",", ""));
				Integer intmNo			= Integer.parseInt((request.getParameter("intm") == null || request.getParameter("intm").equals("")) ? "0" : request.getParameter("intm"));
				String intmName			= request.getParameter("intmText");
				BigDecimal totalTaxAmt	= new BigDecimal(request.getParameter("totalTaxAmt").replaceAll(",", ""));
				BigDecimal amtDue		= new BigDecimal(request.getParameter("amtDue").replaceAll(",", ""));
				
				//map for GIPIQuoteInvTax for saving
				
				Map <String, Object> parameters = new HashMap<String, Object>();
				parameters.put("taxCodes",	taxCodes);		parameters.put("taxDescs", taxDescs);
				parameters.put("taxAmts",	taxAmts);		parameters.put("taxIds", taxIds);
				parameters.put("rates",		rates);			parameters.put("quoteId", quoteId);
				parameters.put("invInt",	invInt);		parameters.put("invNo", invNo);
				parameters.put("currCd",	currCd);		parameters.put("currDesc", currDesc);
				parameters.put("currRate",	currRate);		parameters.put("premAmt", premAmt);
				parameters.put("intmNo",	intmNo);		parameters.put("intmName", intmName);
				parameters.put("totalTaxAmt", totalTaxAmt);	parameters.put("amtDue", amtDue);
				parameters.put("issCd",		gipiQuote.getIssCd());
				
				gipiQuoteInvoiceService.saveGIPIQuoteInvoice(parameters);
				log.info("Saving Invoice partially...");
				
				List<GIPIQuoteInvoice> newInvoice = gipiQuoteInvoiceService.getGIPIQuoteInvoice(quoteId);
				
				String quoteInvNo = request.getParameter("invNo");
				
				int quoteInvInt = Integer.valueOf(newInvoice.get(0).getQuoteInvNo());
				String fixedTaxAllocation 	= null;
				String taxAllocation 		= null;
				Integer itemGrp =  0;
				GIPIQuoteInvTaxFacadeService gipiQuoteInvTaxService = (GIPIQuoteInvTaxFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvTaxFacadeService"); // + env
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("lineCd",	gipiQuote.getLineCd());	params.put("fixedTaxAllocation", fixedTaxAllocation);
				params.put("invNo",		quoteInvNo);			params.put("issCd",		newInvoice.get(0).getIssCd());
				params.put("quoteInvInt", quoteInvInt);			params.put("taxCodes",	taxCodes);
				params.put("taxIds",	taxIds);				params.put("taxAmts",	taxAmts);
				params.put("rates",		rates);					params.put("taxAllocation", taxAllocation);
				params.put("itemGrp",	itemGrp);
				
				gipiQuoteInvTaxService.saveGIPIQuoteInvTax(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showQuoteInvoiceForPackQuotation".equals(ACTION)){
				GIPIQuoteInvoiceFacadeService gipiQuoteInvoiceService = (GIPIQuoteInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceFacadeService");
				Integer packQuoteId = request.getParameter("packQuoteId").equals("") ? null : Integer.parseInt(request.getParameter("packQuoteId"));
				
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> intermediaryList = helper.getList(LOVHelper.INTM_LISTING);
				List<GIPIQuoteInvoice> packInvoiceList = gipiQuoteInvoiceService.getGIPIQuoteInvoiceForPackQuotation(packQuoteId);
				StringFormatter.escapeHTMLInList(packInvoiceList);
				request.setAttribute("objPackQuoteInvoiceList", new JSONArray(packInvoiceList));
				request.setAttribute("intermediaryLov", new JSONArray((List<LOV>)StringFormatter.replaceQuotesInList(intermediaryList)));
				PAGE = "/pages/marketing/quotation-pack/quotationInformation-pack/subPages/quotationInvoiceInformation.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}