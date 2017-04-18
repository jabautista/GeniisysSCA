package com.geniisys.giri.controllers;

import java.io.IOException;
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
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXExpiryService;
import com.geniisys.giri.service.GIRIGenerateRIReportsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIRIGenerateRIReportsController", urlPatterns="/GIRIGenerateRIReportsController")
public class GIRIGenerateRIReportsController extends BaseController{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6628046441096284232L;
	private Logger log = Logger.getLogger(GIRIGenerateRIReportsController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIRIGenerateRIReportsService giriGenerateRiReportsService = (GIRIGenerateRIReportsService) APPLICATION_CONTEXT.getBean("giriGenerateRIReportsService");
			GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
			GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
			
			message = "SUCCESS";
			String moduleId = "GIRIS051";
			
			if("showGenerateRIReportsPage".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String tab = request.getParameter("tabAction");
				System.out.println("TAB: " + tab);
				
				if ("binderTab".equals(tab)){
					Integer defaultCurr = giriGenerateRiReportsService.getDefaultCurrency();
					GIEXExpiryService giexExpiryService = (GIEXExpiryService) APPLICATION_CONTEXT.getBean("giexExpiryService");
					String allow = giexExpiryService.getGiispLineCdGiexs006("ALLOW_SET_PERIL_AMT_FOR_PRINT");
					request.setAttribute("allowSetPerilAmtForPrnt", allow);
					request.setAttribute("defaultCurrency", defaultCurr);
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/generateRIReports.jsp";
				}else if("outstandingTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/outstandingTab.jsp";
				}else if("assumedTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/assumedTab.jsp";
				}else if("expiryListTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/expiryListTab.jsp";
				}else if("expiryPPWTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/expiryPPWTab.jsp";
				}else if("facultativeRITab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/facultativeRiTab.jsp";
				}else if("outwardRITab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/outwardRITab.jsp";
				}else if("treatyTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/treatyTab.jsp";
				}else if("riListingTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/riListingTab.jsp";
				}else if("renewalTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/renewalTab.jsp";
				}else if("reciprocityTab".equals(tab)){
					PAGE = "/pages/underwriting/reInsurance/reportsPrinting/tabs/reciprocityTab.jsp";
				}

				request.setAttribute("printers", printers);
			}else if("showRISignatoryPopup".equals(ACTION)){
				PAGE = "/pages/underwriting/reInsurance/reportsPrinting/pop-ups/reInsurerSignatory.jsp";
				message = "SUCCESS";
			}else if("validateBinderLineCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("moduleId", moduleId);
				String exists = giisLineService.validateLineCdGiris051(params);
				StringFormatter.escapeHTMLInMap(params);
				params.put("exists", exists);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateBndRnwl".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				params.put("valid", "");
				params.put("oldFnlBinderId", Integer.parseInt("0"));
				params.put("fnlBinderId", Integer.parseInt("0"));
				params.put("return", Integer.parseInt("0"));
				params = giriGenerateRiReportsService.validateBndRnwl(params);
				StringFormatter.escapeHTMLInMap(params);
				log.info(params.toString());
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkRiBinderRecord".equals(ACTION)){
				Map<String, Object> params = giriGenerateRiReportsService.checkRiReportsBinderRecord(request);				
				StringFormatter.escapeHTMLInMap(params);
				log.info(params.toString());
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkRiBinderReplaced".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				int link = giriGenerateRiReportsService.checkBinderReplaced(params);
				log.info("link: " + link);
				request.setAttribute("object", link);
				PAGE = "/pages/genericObject.jsp";
			}else if("checkRiBinderNegated".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				int count = giriGenerateRiReportsService.checkBinderNegated(params);
				log.info("count: " + count);
				request.setAttribute("object", count);
				PAGE = "/pages/genericObject.jsp";
			}else if ("getReportVersion".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("version", reportsService.getReportVersion(request.getParameter("reportId")));
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getGIRIR121FnlBinderId".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("version", reportsService.getReportVersion("GIRIR121"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				params = giriGenerateRiReportsService.getGIRIR121FnlBinderId(params);
				System.out.println(params.toString());
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateGIRIBinder".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("appUser", USER.getUserId()); //added by robert 03.06.2015 
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				params.put("reversed", request.getParameter("reversed"));
				params.put("replaced", request.getParameter("replaced"));
				params.put("negated", request.getParameter("negated"));
				params.put("attention", request.getParameter("attention"));
				params.put("remarks", request.getParameter("remarks"));
				params.put("bndrRemarks1", request.getParameter("bndrRemarks1"));
				params.put("bndrRemarks2", request.getParameter("bndrRemarks2"));
				params.put("bndrRemarks3", request.getParameter("bndrRemarks3"));
				params = giriGenerateRiReportsService.updateGIRIBinder(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateGIRIGroupBinder".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				params.put("reversed", request.getParameter("reversed"));
				params.put("replaced", request.getParameter("replaced"));
				params.put("remarks", request.getParameter("remarks"));
				params.put("bndrRemarks1", request.getParameter("bndrRemarks1"));
				params.put("bndrRemarks2", request.getParameter("bndrRemarks2"));
				params.put("bndrRemarks3", request.getParameter("bndrRemarks3"));
				params = giriGenerateRiReportsService.updateGIRIGroupBinder(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getGIRIBinderPerilDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("appUser", USER.getUserId());
				params.put("moduleId", "GIRIS051");
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				System.out.println(params.toString());
				
				Map<String, Object> functionOverrideRec = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(functionOverrideRec);
				System.out.println(json.toString());
				
				request.setAttribute("perilDtlsTG", json);
				message = json.toString();
				PAGE = "/pages/underwriting/reInsurance/reportsPrinting/pop-ups/perilDtls.jsp";
			}else if("addBinderPerilPrintHist".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("perils", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("perils"))));
				params.put("userId", USER.getUserId());
				giriGenerateRiReportsService.insertBinderPerilPrintHist(params);
				System.out.println(params.toString());
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateRIReportsLineName".equals(ACTION)){
				String lineCd = giisLineService.getLineCd(request.getParameter("lineName"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				System.out.println(lineCd);
				
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateRIReportsReinsurerName".equals(ACTION)){
				Integer riCd = giriGenerateRiReportsService.getReinsurerCd(request.getParameter("riName"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("riCd", riCd);
				System.out.println(riCd);
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkORA2010Sw".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				GIEXExpiryService giexExpiryService = (GIEXExpiryService) APPLICATION_CONTEXT.getBean("giexExpiryService");
				params.put("ora2010",giexExpiryService.getGiispLineCdGiexs006("ORA2010_SW"));
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("showOARPrintWindow".equals(ACTION)){
				request.setAttribute("serverDate", new java.text.SimpleDateFormat("MM-dd-yyyy").format(new java.util.Date()));
				PAGE = "/pages/underwriting/reInsurance/reportsPrinting/pop-ups/oarPrint.jsp";
			}else if("checkOARPrintDate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("printChk", giriGenerateRiReportsService.checkOARPrintDate(request));
				System.out.println("printChk: " + params.toString());
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateOARPrintDate".equals(ACTION)){
				giriGenerateRiReportsService.updateOARPrintDate(request);
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateRIReportsRiSname".equals(ACTION)){
				Map<String, Object> params = giriGenerateRiReportsService.validateRiSname(request);
				System.out.println(params.toString());
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("extractInwTran".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", giriGenerateRiReportsService.getExtractInwTran(request, USER));
				System.out.println("extractInwTran params: "+params.toString());
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("deleteGiixInwTran".equals(ACTION)){
				giriGenerateRiReportsService.deleteGiixInwTran(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateRiTypeDesc".equals(ACTION)){
				message = giriGenerateRiReportsService.validateRiTypeDesc(request.getParameter("riTypeDesc"));
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getReciprocityInitialValues".equals(ACTION)){
				/*Map<String, Object> params = giriGenerateRiReportsService.getReciprocityDetails1(USER);
				Map<String, Object> params2 = giriGenerateRiReportsService.getReciprocityDetails2(USER);
				params.put("riCd", params2.get("riCd"));
				params.put("riSname", params2.get("riSname"));*/
				Map<String, Object> params = giriGenerateRiReportsService.getReciprocityInitialValues(USER);
				System.out.println(params.toString());
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getReciprocityRiCd".equals(ACTION)){
				Integer riCd = giriGenerateRiReportsService.getReciprocityRiCd(request, USER);
				message = riCd == null ? null : riCd.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractReciprocity".equals(ACTION)){
				Map<String, Object> params = giriGenerateRiReportsService.extractReciprocity(request);
				System.out.println(params.toString());
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getExtractedReciprocity".equals(ACTION)){
				Integer riCd = giriGenerateRiReportsService.getExtractedReciprocity(request, USER);
				message = riCd == null ? null : riCd.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateFacAmts".equals(ACTION)){
				message = giriGenerateRiReportsService.updateFacAmts(request, USER);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIRIS051LinePPW".equals(ACTION)){
				message = giisLineService.validateGIRIS051LinePPW(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	
}
