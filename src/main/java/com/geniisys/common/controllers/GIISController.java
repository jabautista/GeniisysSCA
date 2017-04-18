/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.Geniisys;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISCurrencyService;
import com.geniisys.common.service.GeniisysService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.LocaleHelper;
import com.geniisys.giac.service.GIACFunctionService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISController.
 */
public class GIISController extends BaseController{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 5116912672529377302L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request, 
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env
		/*default attributes*/
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try {
			GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
			if("setLocale".equals(ACTION)){
				LocaleHelper helper = LocaleHelper.getInstance();
				helper.setLocale(request.getParameter("code"));
				SESSION.setAttribute("locale", helper.getLocale());
				PAGE = "/pages/login.jsp";
				
			} else if("getLineListing".equals(ACTION)) {
				log.info("Getting Line of Business Listing for All Users.");
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				//String[] moduleId = {request.getParameter("moduleId")};
				//List<LOV> list = helper.getList(LOVHelper.LINE_LISTING, moduleId); //replace by: nica 02.17.2011
				String[] params = {request.getParameter("moduleId"), USER.getUserId()};
				List<LOV> list = helper.getList(LOVHelper.LINE_LISTING, params);
				StringFormatter.replaceQuotesInList(list); // andrew - to handle quotes in list
				request.setAttribute("lineListing", list);
				System.out.println("riSwitch line listing:"+request.getParameter("riSwitch"));
				request.setAttribute("riSwitch", request.getParameter("riSwitch"));
				PAGE = "/pages/marketing/quotation/lineListing.jsp";
				
			}else if("getLineListingForPackagePar".equals(ACTION)){
				log.info("Getting Line of Business Listing for All Users.");
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // nica 11.03.2010
				String[] params = {request.getParameter("moduleId"), USER.getUserId()};
				List<LOV> list = helper.getList(LOVHelper.LINE_LISTING_FOR_PACK_PAR, params);
				request.setAttribute("lineListing", list);
				request.setAttribute("riSwitch", request.getParameter("riSwitch"));
				PAGE = "/pages/marketing/quotation/lineListing.jsp";
			} else if ("showOverlayEditor".equals(ACTION)){
				request.setAttribute("textId", request.getParameter("textId"));
				request.setAttribute("initialValue", request.getParameter("initialValue"));
				request.setAttribute("charLimit", request.getParameter("charLimit"));
				request.setAttribute("readonly", request.getParameter("readonly"));
				PAGE = "/pages/common/subPages/overlayEditor.jsp";
			} else if("getAllLineListing".equals(ACTION)) {
				log.info("Getting Line of Business Listing for All Users.");
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); 
				String[] params = {request.getParameter("moduleId"), request.getParameter("polIssCd")};
				List<LOV> list = helper.getList(LOVHelper.ALL_LINE_LISTING, params);
				StringFormatter.replaceQuotesInList(list); 
				request.setAttribute("lineListing", list);
				request.setAttribute("riSwitch", request.getParameter("riSwitch"));
				PAGE = "/pages/marketing/quotation/lineListing.jsp";
			} else if("showGenericPrintDialog".equals(ACTION)){
				/*LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> printers = helper.getList(LOVHelper.PRINTER_LISTING);
				request.setAttribute("printers", printers);*/			
				// installed printers muna ang gamitin - andrew - 02.27.2012
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				request.setAttribute("showFileOption", request.getParameter("showFileOption"));
				PAGE = "/pages/genericPrintDialog.jsp";
			} else if("showClaimListingPrintDialog".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				request.setAttribute("cBoxTitle", request.getParameter("cBoxTitle"));
				PAGE = "/pages/claimListingPrintDialog.jsp";
			} else if("showOverrideRequest".equals(ACTION)){
				GIACFunctionService giacFunctionService = (GIACFunctionService) APPLICATION_CONTEXT.getBean("giacFunctionService");
				giacFunctionService.getFunctionName(request, USER.getUserId());				
				PAGE = "/pages/genericOverrideRequest.jsp";
			} else if ("showCurrency".equals(ACTION)){
				PAGE = "/pages/underwriting/fileMaintenance/general/currency/currency.jsp";
			} else if ("showCurrencyList".equals(ACTION)){
				/*JSONObject json = giisCurrencyService.showCurrencyList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					PAGE = "/pages/underwriting/fileMaintenance/general/currency/currency.jsp";
				}*/
			} else if("showAboutGeniisys".equals(ACTION)){
				request.setAttribute("description", getServletContext().getInitParameter("geniisysDescription"));
				GeniisysService geniisysService = (GeniisysService) APPLICATION_CONTEXT.getBean("geniisysService");
				Geniisys geniisys = geniisysService.getGeniisysDetails(request);
				request.setAttribute("geniisys", geniisys);
				PAGE = "/pages/aboutGeniisys.jsp";
			} else if("showColorTheme".equals(ACTION)){
				PAGE = "/pages/colorTheme.jsp";
			} else if("showKeyboardShortcuts".equals(ACTION)){
				PAGE = "/pages/keyboardShortcuts.jsp";
			} else if("validateDeleteCurrency".equals(ACTION)){
				log.info("validating currency...");
				message = giisCurrencyService.validateDeleteCurrency(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			} else if("validateMainCurrencyCd".equals(ACTION)){
				log.info("validating currency cd...");
				message = giisCurrencyService.validateMainCurrencyCd(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			} else if("validateShortName".equals(ACTION)){
				log.info("validating currency short name...");
				message = giisCurrencyService.validateShortName(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			} else if("validateCurrencyDesc".equals(ACTION)){
				log.info("validating currency description...");
				message = giisCurrencyService.validateCurrencyDesc(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			} else if("saveCurrency".equals(ACTION)){
				log.info("saving currency maintenance...");
				message = giisCurrencyService.saveCurrency(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("deletePrintedReport".equals(ACTION)){
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/")+1, url.length());
				log.info("Deleting printed report " + fileName + "...");
				(new File(realPath + "\\reports\\" + fileName)).delete();
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}