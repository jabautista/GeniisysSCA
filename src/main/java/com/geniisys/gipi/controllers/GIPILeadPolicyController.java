package com.geniisys.gipi.controllers;

import java.io.IOException;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWInvoice;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.service.GIPICoInsurerService;
import com.geniisys.gipi.service.GIPIMainCoInsService;
import com.geniisys.gipi.service.GIPIOrigCommInvPerilService;
import com.geniisys.gipi.service.GIPIOrigCommInvoiceService;
import com.geniisys.gipi.service.GIPIOrigInvPerlService;
import com.geniisys.gipi.service.GIPIOrigInvTaxService;
import com.geniisys.gipi.service.GIPIOrigItmPerilService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPILeadPolicyController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPILeadPolicyController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		/*default attributes*/
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
		GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
		GIPICoInsurerService coInsurerService = (GIPICoInsurerService) APPLICATION_CONTEXT.getBean("gipiCoInsurerService");
		/*end of default attributes*/
		
		Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		
		try {
			if("showLeadPolicy".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				String parType = request.getParameter("parType");
				String policyNo = request.getParameter("policyNo");
				System.out.println("Lead Policy: " + parId);
				List<GIPIWItem> gipiWItems = gipiWItemService.getGIPIWItem(parId);
				GIPIPARList par = gipiParService.getGIPIPARDetails(parId);
				Map<String, Object> params = new HashMap<String, Object>();
				params = coInsurerService.getCoInsurerSharePct(parId);
				request.setAttribute("dspRate", params.get("dspRate"));
				request.setAttribute("rate", params.get("saveRate"));
				request.setAttribute("parId", parId);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("parNo", par.getParNo());
				request.setAttribute("assdName", par.getAssdName());
				request.setAttribute("items", gipiWItems);
				request.setAttribute("parType", parType);
				request.setAttribute("policyNo", policyNo);
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicy.jsp";
			}else if("showLeadPolicyPerilListing".equals(ACTION)){
				GIPIOrigItmPerilService gipiOrigItmPerilService = (GIPIOrigItmPerilService) APPLICATION_CONTEXT.getBean("gipiOrigItmPerilService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigItmPerilService.getGipiOrigItmPerilList(params);
				request.setAttribute("leadPolicyPerilTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicyPerilListing.jsp";
			}else if("refreshLeadPolicyPerilListing".equals(ACTION)){
				GIPIOrigItmPerilService gipiOrigItmPerilService = (GIPIOrigItmPerilService) APPLICATION_CONTEXT.getBean("gipiOrigItmPerilService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigItmPerilService.getGipiOrigItmPerilList(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLeadPolicyInvoiceModal".equals(ACTION)){
				GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService");
				
				GIPIPARList par = gipiParService.getGIPIPARDetails(parId);
				Map<String, Object> params = new HashMap<String, Object>();
				params = coInsurerService.getCoInsurerSharePct(parId);
				List<GIPIWInvoice> wInvoice = gipiWInvoiceService.getLeadPolGipiWInvoice(parId);
				request.setAttribute("list", wInvoice);
				StringFormatter.escapeHTMLInList(wInvoice);
				request.setAttribute("gipiWInvoiceList", new JSONArray(wInvoice));
				request.setAttribute("dspRate", params.get("dspRate"));
				request.setAttribute("parNo", par.getParNo());
				request.setAttribute("assdName", par.getAssdName());
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicyInvoicePage.jsp";
			}else if("showLeadPolicyTaxesListing".equals(ACTION)){
				GIPIOrigInvTaxService gipiOrigInvTaxService = (GIPIOrigInvTaxService) APPLICATION_CONTEXT.getBean("gipiOrigInvTaxService");

				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigInvTaxService.getGipiOrigInvTaxList(params);
				request.setAttribute("leadPolicyTaxesTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("dspRate", request.getParameter("dspRate"));
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicyTaxes.jsp";
			}else if("refreshLeadPolicyTaxesListing".equals(ACTION)){
				GIPIOrigInvTaxService gipiOrigInvTaxService = (GIPIOrigInvTaxService) APPLICATION_CONTEXT.getBean("gipiOrigInvTaxService");

				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigInvTaxService.getGipiOrigInvTaxList(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLeadPolicyInvPerlListing".equals(ACTION)){
				GIPIOrigInvPerlService gipiOrigInvPerlService = (GIPIOrigInvPerlService) APPLICATION_CONTEXT.getBean("gipiOrigInvPerlService");
				HashMap<String, Object> params = new HashMap<String, Object>();

				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigInvPerlService.getGipiOrigInvPerl(params);
				request.setAttribute("leadPolicyInvPerlTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("dspRate", request.getParameter("dspRate"));
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicyPerilDist.jsp";
			}else if("refreshLeadPolicyInvPerlListing".equals(ACTION)){
				GIPIOrigInvPerlService gipiOrigInvPerlService = (GIPIOrigInvPerlService) APPLICATION_CONTEXT.getBean("gipiOrigInvPerlService");
				HashMap<String, Object> params = new HashMap<String, Object>();

				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigInvPerlService.getGipiOrigInvPerl(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLeadPolicyIntrmdryListing".equals(ACTION)){
				GIPIOrigCommInvoiceService gipiOrigCommInvoiceService = (GIPIOrigCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiOrigCommInvoiceService");
				HashMap<String, Object> params = new HashMap<String, Object>();

				params.put("parId", parId);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigCommInvoiceService.getGipiOrigCommInvoice(params);
				request.setAttribute("leadPolicyIntrmdryTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				//request.setAttribute("dspRate", request.getParameter("dspRate"));
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicyInvCommIntermediaryListing.jsp";
				
			}else if("refreshLeadPolicyIntrmdryListing".equals(ACTION)){
				GIPIOrigCommInvoiceService gipiOrigCommInvoiceService = (GIPIOrigCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiOrigCommInvoiceService");
				HashMap<String, Object> params = new HashMap<String, Object>();

				params.put("parId", parId);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigCommInvoiceService.getGipiOrigCommInvoice(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLeadPolicyCommInvPerilListing".equals(ACTION)){
				GIPIOrigCommInvPerilService gipiOrigCommInvPerilService = (GIPIOrigCommInvPerilService) APPLICATION_CONTEXT.getBean("gipiOrigCommInvPerilService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigCommInvPerilService.getGipiOrigCommInvPeril(params);
				request.setAttribute("leadPolicyCommInvPerilTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("dspRate", request.getParameter("dspRate"));
				PAGE = "/pages/underwriting/coInsurance/leadPolicy/leadPolicyInvoiceCommission.jsp";
			}else if("refreshLeadPolicyCommInvPerilListing".equals(ACTION)){
				GIPIOrigCommInvPerilService gipiOrigCommInvPerilService = (GIPIOrigCommInvPerilService) APPLICATION_CONTEXT.getBean("gipiOrigCommInvPerilService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiOrigCommInvPerilService.getGipiOrigCommInvPeril(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("limitEntry".equals(ACTION)){	//shan 10.21.2013
				GIPIMainCoInsService gipiMainCoInsService = (GIPIMainCoInsService) APPLICATION_CONTEXT.getBean("gipiMainCoInsService");
				message = gipiMainCoInsService.limitEntryGIPIS154(request);
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch(NullPointerException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Null Pointer Exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";			
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Unhandled exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";			
		} finally {
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
	}
}
