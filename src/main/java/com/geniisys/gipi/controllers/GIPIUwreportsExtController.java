package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIUWReportsParam;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWReportsExtService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIUwreportsExtController", urlPatterns={"/GIPIUwreportsExtController"})
public class GIPIUwreportsExtController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIUwreportsExtController.class);
	
	private PrintServiceLookup printServiceLookup;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIWReportsExtService gipiWReportsExtService = (GIPIWReportsExtService)APPLICATION_CONTEXT.getBean("gipiWReportsExtService");
		
		try{
			if("showProductionReportsPage".equals(ACTION)){
				GIPIUWReportsParam lastExtractInfo;
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				Integer prodReport = giisParameterFacadeService.getParamValueN("PROD_REPORT_EXTRACT");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				if("showPolicyEndorsementTab".equals(request.getParameter("tabAction"))){
					params.put("tab", 1);
					request.setAttribute("allowEdstReport", giisParameterFacadeService.getParamValueV2("ALLOW_EDST_REPORT")); //marco - 05.23.2013
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/uwReports.jsp";
				}else if("showDistributionTab".equals(request.getParameter("tabAction"))){
					params.put("tab", 2);
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/distributionTab.jsp";
				}else if("showOutwardRiTab".equals(request.getParameter("tabAction"))){
					params.put("tab", 3);
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/outwardRiTab.jsp";
				}else if("perPeril".equals(request.getParameter("tabAction"))){
					params.put("tab", 4);
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/perPerilTab.jsp";
				}else if("perAssd".equals(request.getParameter("tabAction"))){
					params.put("tab", 5);
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/perAssdTab.jsp";
				}else if("showInwardRiTab".equals(request.getParameter("tabAction"))){
					params.put("tab", 8);
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/inwardRiTab.jsp";
				}else if("showUndistributedTab".equals(request.getParameter("tabAction"))){
					params.put("tab", 6);
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/undistributedTab.jsp";
				}else if("showPolicyRegisterTab".equals(request.getParameter("tabAction"))){
					params.put("tab", 1);
					request.setAttribute("paramDate", gipiWReportsExtService.getParamDate(USER.getUserId()));
					PAGE = "/pages/underwriting/reportsPrinting/productionReports/tabs/policyRegisterTab.jsp";
				}
				lastExtractInfo = gipiWReportsExtService.getLastExtractParams(params);
				request.setAttribute("lastExtractInfo", new JSONObject(lastExtractInfo != null ? StringFormatter.escapeHTMLInObject(lastExtractInfo): new GIPIUWReportsParam()));
				request.setAttribute("prodReport", prodReport);
				request.setAttribute("printers", printers);
			}else if("showEdstOverlay".equals(ACTION)){
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService)APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("incCancelledSpoiledRecs", giisParameterFacadeService.getParamValueV2("INCLUDE_CANCELLED_SPOILED_RECORDS"));
				PAGE = "/pages/underwriting/reportsPrinting/productionReports/popups/edst.jsp";
			}else if("checkUwReports".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("dateParam", Integer.parseInt(request.getParameter("dateParam")));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("branchParam", Integer.parseInt(request.getParameter("branchParam")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				if("edst".equals(request.getParameter("tabCheck"))){
					params.put("edstScope", Integer.parseInt(request.getParameter("edstScope")));
					message = gipiWReportsExtService.checkUwReportsEdst(params);
				}else if("nonEdst".equals(request.getParameter("tabCheck"))){
					params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReports(params);
				}else if("dist".equals(request.getParameter("tabCheck"))){
					params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReportsDist(params);
				}else if("outward".equals(request.getParameter("tabCheck"))){
					params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReportsOutward(params);
				}else if("perPeril".equals(request.getParameter("tabCheck"))){
					params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReportsPerPeril(params);
				}else if("perAssd".equals(request.getParameter("tabCheck"))){
					params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReportsPerAssd(params);
				}else if("inward".equals(request.getParameter("tabCheck"))){
					params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReportsInward(params);
				}else if("policyRegister".equals(request.getParameter("tabCheck"))){
					params.put("specialPolParam", request.getParameter("specialPolParam"));
					message = gipiWReportsExtService.checkUwReportsPolicy(params);
				}
				System.out.println("checkUwReports " + request.getParameter("tabCheck") + " params: " + params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractUwReports".equals(ACTION)){
				log.info("Extracting UWReports: " + request.getParameter("tabExtract") + " tab...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("dateParam", Integer.parseInt(request.getParameter("dateParam")));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("userId", USER.getUserId());
				params.put("branchParam", Integer.parseInt(request.getParameter("branchParam")));
				params.put("specialPolParam", request.getParameter("specialPolParam"));
				params.put("scopeParam", Integer.parseInt(request.getParameter("scopeParam")));
				if("polEndt".equals(request.getParameter("tabExtract"))){
					params.put("edstCtr", request.getParameter("edstCtr"));
					params.put("edstScope", Integer.parseInt(request.getParameter("edstScope")));
					params.put("edstCtpPol", request.getParameter("edstCtpPol"));
					params.put("nonAffect", "N"/*"Y"*/); //benjo 07.03.2015 GENQA-AFPGEN-IMPLEM-SR-4419
					params.put("reinstateTag", request.getParameter("reinstateTag"));
					params.put("withdist", request.getParameter("withdist"));
					message = gipiWReportsExtService.extractUWReports(params);
				}else if("dist".equals(request.getParameter("tabExtract"))){
					message = gipiWReportsExtService.extractUWReportsDist(params);
				}else if("outward".equals(request.getParameter("tabExtract"))){
					message = gipiWReportsExtService.extractUWReportsOutward(params);
				}else if("perPeril".equals(request.getParameter("tabExtract"))){
					message = gipiWReportsExtService.extractUWReportsPerPeril(params);
				}else if("perAssd".equals(request.getParameter("tabExtract"))){
					params.put("assdNo", request.getParameter("assdNo"));
					params.put("intmNo", request.getParameter("intmNo"));
					params.put("intmType", request.getParameter("intmType"));
					message = gipiWReportsExtService.extractUWReportsPerAssd(params);
				}else if("inward".equals(request.getParameter("tabExtract"))){
					params.put("riCd", request.getParameter("riCd"));
					message = gipiWReportsExtService.extractUWReportsInward(params);
				}else if("policyRegister".equals(request.getParameter("tabExtract"))){
					params.put("nonAffect", request.getParameter("nonAffect"));
					message = gipiWReportsExtService.extractUWReportsPolicy(params);
					request.setAttribute("paramDate", gipiWReportsExtService.getParamDate(USER.getUserId()));
				}
				System.out.println("Extracting UWReports params: " + params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePrint".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("printTab", request.getParameter("printTab"));
				params.put("userId", USER.getUserId());
				params.put("branchParam", Integer.parseInt(request.getParameter("branchParam")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				if("polEndt".equals(request.getParameter("printTab"))){
					params.put("edstCtr", request.getParameter("edstCtr"));
					message = gipiWReportsExtService.validatePrintPolEndt(params);
				}else if("dist".equals(request.getParameter("printTab"))){
					params.put("scope", request.getParameter("scope"));
					request.setAttribute("noRecords", gipiWReportsExtService.countNoShareCd(params));
					message = gipiWReportsExtService.validatePrint(params);
							
					// kris 2.13.2013
					params.put("noRecords", gipiWReportsExtService.countNoShareCd(params));
					params.put("extUserId", gipiWReportsExtService.validatePrint(params));
					StringFormatter.escapeHTMLInMap(params);
					request.setAttribute("object", new JSONObject(params));
					//PAGE = "/pages/genericObject.jsp";
					System.out.println("noRecords: "+gipiWReportsExtService.countNoShareCd(params)
							+"\nMessage: "+message);
				}else if("perAssd".equals(request.getParameter("printTab"))){
					params.put("scope", request.getParameter("scope"));
					params.put("assdNo", request.getParameter("assdNo"));
					params.put("intmNo", request.getParameter("intmNo"));
					params.put("intmType", request.getParameter("intmType"));
					message = gipiWReportsExtService.validatePrintAssd(params);
				}else if("perPeril".equals(request.getParameter("printTab"))){
					params.put("scope", request.getParameter("scope"));
					message = gipiWReportsExtService.validatePrint(params);
				}else if("inwardRI".equals(request.getParameter("printTab"))){
					params.put("scope", request.getParameter("scope"));
					params.put("riCd", request.getParameter("riCd"));
					message = gipiWReportsExtService.validatePrintOutwardInwardRI(params);
				}else if("outwardRI".equals(request.getParameter("printTab"))){
					params.put("scope", request.getParameter("scope"));
					message = gipiWReportsExtService.validatePrintOutwardInwardRI(params);
				}
				//PAGE = "/pages/genericMessage.jsp";
				
				if("dist".equals(request.getParameter("printTab"))){
					PAGE = "/pages/genericObject.jsp";
				}else {
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("validateIssCd".equals(ACTION)){
				GIISISSourceFacadeService giisIssourceFacadeService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("moduleId", "GIPIS901A");
				params = giisIssourceFacadeService.validateIssCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateLineCd".equals(ACTION)){
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params.put("sublineName", request.getParameter("sublineName") == null ? "" : request.getParameter("sublineName"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("moduleId", "GIPIS901A");
				params = giisLineService.validateLineCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateSublineCd".equals(ACTION)){
				GIISSublineFacadeService giisSublineFacadeService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params = giisSublineFacadeService.validatePurgeSublineCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateAssdNo".equals(ACTION)){
				GIISAssuredFacadeService giisAssuredFacadeService = (GIISAssuredFacadeService)APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
				params = giisAssuredFacadeService.validateAssdNo(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateIntmType".equals(ACTION)){
				GIISIntermediaryService giisIntermediaryService = (GIISIntermediaryService)APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmType", request.getParameter("intmType"));
				params = giisIntermediaryService.validateIntmType(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateIntmNo".equals(ACTION)){
				GIISIntermediaryService giisIntermediaryService = (GIISIntermediaryService)APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
				params = giisIntermediaryService.validateIntmNo(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateCedant".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("riCd", Integer.parseInt(request.getParameter("cedantCd")));
				params = gipiWReportsExtService.validateCedant(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if ("showGIPIS191RiskCategory".equals(ACTION)){
				@SuppressWarnings("static-access")
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);				
				GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				request.setAttribute("params", new JSONObject(gipiPolbasicService.getGIPIS191Params(USER.getUserId())));				
				PAGE = "/pages/underwriting/reportsPrinting/riskCategory/riskCategory.jsp";
			}else if ("gipis191ExtractRiskCategory".equals(ACTION)){
				GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				request.setAttribute("object", gipiPolbasicService.gipis191ExtractRiskCategory(request, USER.getUserId()));
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
