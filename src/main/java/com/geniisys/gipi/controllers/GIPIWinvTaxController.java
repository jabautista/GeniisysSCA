/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.entity.GIISTaxCharges;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISTaxChargesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.entity.GIPIWInvoice;
import com.geniisys.gipi.entity.GIPIWinvTax;
import com.geniisys.gipi.service.GIPIWEndtTextService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWinvTaxFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWinvTaxController.
 */
public class GIPIWinvTaxController extends BaseController {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6053256358005122209L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWinvTaxController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		log.info("");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWinvTaxFacadeService gipiWinvTaxService = (GIPIWinvTaxFacadeService) APPLICATION_CONTEXT.getBean("gipiWinvTaxFacadeService"); // +env
			GIPIWInvoiceFacadeService gipiWinvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService");
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			
			
			int itemGrp = Integer.parseInt((request.getParameter("tiItemGrp") == null) ? "1" : request.getParameter("tiItemGrp"));
		
			
			Integer parId = Integer.parseInt((request.getParameter("parId") == null || request.getParameter("parId") == "" ? "0" : request.getParameter("parId").toString()));
			
			String paramName = ((request.getParameter("paramName")==null) ? "COMPUTE_OLD_DOC_STAMPS": request.getParameter("paramName"));
		//	String paramName1 = ((request.getParameter("paramName1")==null) ? "OTHER_CHARGES_CODE": request.getParameter("paramName1"));
			String lineCd = (request.getParameter("lineCd")== null ? "line" : request.getParameter("lineCd"));
			String issCd = (request.getParameter("issCd") == null? "issue" : request.getParameter("issCd"));
			String itemGrp2 = (request.getParameter("itemGrp") == null? "1" : request.getParameter("itemGrp")); //added by steven 07.22.2014
			
			System.out.println("winvtax" + parId + lineCd + issCd);
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			
			GIPIPARList gipiParList = new GIPIPARList(); 
			
			gipiParList.setParId(parId);
			gipiParList.setLineCd(lineCd);
			gipiParList.setIssCd(issCd);
			System.out.println("taxes"+issCd + lineCd + parId);
			String[] arguments={lineCd, issCd, parId.toString(),itemGrp2}; //added by steven 07.22.2014
			if("showBillPremiumsPage".equals(ACTION)){
				System.out.println("pages"+issCd + lineCd + parId);
				GIACParameterFacadeService giacParamService = APPLICATION_CONTEXT.getBean(GIACParameterFacadeService.class);
				GIISTaxChargesService giisTaxChargesService = (GIISTaxChargesService) APPLICATION_CONTEXT.getBean("giisTaxChargesService");	//Gzelle 10272014
				
				request=this.getWinvTax(request, gipiWinvTaxService, parId, itemGrp);
				request=this.getDistinctWinvoice(request, gipiWinvoiceService, parId);
				request=this.getComputeOldDocStamps(request, giisParametersService, paramName);
				request=this.getOtherChargesCode(request, giisParametersService);
				List<LOV> taxCharges = lovHelper.getList(LOVHelper.POLICY_TAX_LISTING, arguments);
				System.out.println("WINVTAX SIZE: " + taxCharges.size());
				request.setAttribute("taxCharges", taxCharges);
				StringFormatter.replaceQuotesInList(taxCharges);
				
				
				
				System.out.println("taxChargesJSON:  "+new JSONArray(taxCharges));
				request.setAttribute("taxChargesJSON", new JSONArray(taxCharges));
				request.setAttribute("parDetails", gipiParList);
				request.setAttribute("docStampVal", giacParamService.getParamValueN("DOC_STAMPS"));
				//added by Gzelle 10272014 based on UW-SPECS-2014-093 - GIPIS026 GIPIS017B BILL PREMIUMS
				request.setAttribute("allowTaxGreaterThanPremium", giisParametersService.getParamValueV2("ALLOW_TAX_GREATER_THAN_PREMIUM"));
				List<GIISTaxCharges> giisTaxCharges = giisTaxChargesService.getGiisTaxCharges(request);
				request.setAttribute("giisTaxCharges", new JSONArray((List<GIISTaxCharges>) StringFormatter.escapeHTMLInListOfMap(giisTaxCharges)));
				GIPIWEndtTextService gipiWEndtTextService = (GIPIWEndtTextService) APPLICATION_CONTEXT.getBean(GIPIWEndtTextService.class);
				GIPIWEndtText endtText = gipiWEndtTextService.getGIPIWEndttext(parId);
				if (endtText != null){
					request.setAttribute("CheckUpdateTaxEndtCancellation",gipiWEndtTextService.CheckUpdateTaxEndtCancellation()); 
					request.setAttribute("endtTax" , (endtText.getEndtTax() == null ? "" : endtText.getEndtTax()));
				}else{
					request.setAttribute("endtTax" , "");
				}
				
				PAGE ="/pages/underwriting/subPages/invoiceTax.jsp";
				
			} else if("refreshTaxList".equals(ACTION)){
				int takeupSeqNo= Integer.parseInt((request.getParameter("takeupSeqNo") == null) ? "1" : request.getParameter("takeupSeqNo"));
				System.out.println("change takeupSeq" + takeupSeqNo);
				PAGE ="/pages/underwriting/subPages/invoiceTax.jsp";
				
				
				request=this.getWinvTax(request, gipiWinvTaxService, parId, itemGrp);
			
				List<LOV> taxCharges=lovHelper.getList(LOVHelper.POLICY_TAX_LISTING, arguments);
				request.setAttribute("taxCharges", taxCharges);
			} else if("getTaxList".equals(ACTION)){ //added by steven 07.22.2014
				List<LOV> taxCharges = lovHelper.getList(LOVHelper.POLICY_TAX_LISTING, arguments);
				message = new JSONArray(taxCharges).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
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
	
	/**
	 * Gets the winv tax.
	 * 
	 * @param request the request
	 * @param gipiWinvTaxService the gipi winv tax service
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @return the winv tax
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getWinvTax(HttpServletRequest request, 
			GIPIWinvTaxFacadeService gipiWinvTaxService, int parId, int itemGrp)	throws SQLException {
		List<GIPIWinvTax> gipiWinvTax = gipiWinvTaxService.getGIPIWinvTax2(parId);
		StringFormatter.replaceQuotesInList(gipiWinvTax);
		request.setAttribute("gipiWinvTaxJSON", new JSONArray(gipiWinvTax));
				//	System.out.println(gipiWInvoice.getProperty());
		return request;
	}
	
	/**
	 * Gets the distinct winvoice.
	 * 
	 * @param request the request
	 * @param gipiWinvoiceService the gipi winvoice service
	 * @param parId the par id
	 * @return the distinct winvoice
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getDistinctWinvoice(HttpServletRequest request, 
			GIPIWInvoiceFacadeService gipiWinvoiceService, int parId)	throws SQLException {
		List<GIPIWInvoice> itemGrpGipiWinvoice = gipiWinvoiceService.getItemGrpWinvoice(parId);
		List<GIPIWInvoice> takeupGipiWinvoice = gipiWinvoiceService.getTakeupWinvoice(parId);
		
		request.setAttribute("itemGrpGipiWinvoice", itemGrpGipiWinvoice);
		request.setAttribute("takeupGipiWinvoice", takeupGipiWinvoice);			
		return request;
	}

	/**
	 * Gets the compute old doc stamps.
	 * 
	 * @param request the request
	 * @param giisParametersService the giis parameters service
	 * @param paramName the param name
	 * @return the compute old doc stamps
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getComputeOldDocStamps(HttpServletRequest request,
				GIISParameterFacadeService giisParametersService, String paramName) throws SQLException{
		
		GIISParameter giisParameters = giisParametersService.getParamValueV(paramName);
//		String oldDocStamps = giisParametersService.getParamValueV(paramName);
			
			request.setAttribute("giisParameters", giisParameters);
		return request;
	}
	
	private HttpServletRequest getOtherChargesCode(HttpServletRequest request,
				GIISParameterFacadeService giisParametersService) throws SQLException{
		
		Integer paramValueN = giisParametersService.getParamValueN("OTHER_CHARGES_CODE");
		request.setAttribute("paramValueN", paramValueN);
		System.out.println("parameter" +paramValueN);
		return request;
	}


}