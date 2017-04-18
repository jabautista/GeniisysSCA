package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.entity.GIACChkReleaseInfo;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACChkDisbursementService;
import com.geniisys.giac.service.GIACChkReleaseInfoService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIACChkDisbursementController", urlPatterns="/GIACChkDisbursementController")
public class GIACChkDisbursementController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACChkDisbursementController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIACChkDisbursementService chkDisbursementService = (GIACChkDisbursementService) APPLICATION_CONTEXT.getBean("giacChkDisbursementService");
			GIACChkReleaseInfoService giacChkReleaseInfoService = (GIACChkReleaseInfoService) APPLICATION_CONTEXT.getBean("giacChkReleaseInfoService");
			
			if("saveCheckDetails".equals(ACTION)){
				message = chkDisbursementService.saveCheckDisbursement(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("showCheckReleaseInformationPage".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIACChkReleaseInfo chkReleaseInfo = giacChkReleaseInfoService.getGIACS002ChkReleaseInfo(params);
				request.setAttribute("chkReleaseInfo", chkReleaseInfo == null ? new JSONObject() : new JSONObject((GIACChkReleaseInfo)StringFormatter.escapeHTMLInObject(chkReleaseInfo)));
				request.setAttribute("checkPrefSuf", request.getParameter("checkPrefSuf"));
				request.setAttribute("checkNo", request.getParameter("checkNo"));
				PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/overlay/checkReleaseInformation.jsp";
			} else if("saveCheckReleaseInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("hidGaccTranId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("hidItemNo")));
				params.put("checkPrefSuf", request.getParameter("txtCheckPrefSuf"));
				params.put("checkNo", Long.parseLong(request.getParameter("txtCheckNo"))); //changed by robert
				params.put("checkReceivedBy", request.getParameter("txtCheckReceivedBy"));
				params.put("checkReleaseDate", request.getParameter("txtCheckReleaseDate"));
				params.put("orDate", request.getParameter("txtORDate"));
				params.put("checkReleasedBy", request.getParameter("txtCheckReleasedBy"));
				params.put("orNo", request.getParameter("txtORNo"));
				params.put("userId", USER.getUserId());
				params.put("lastUpdate", request.getParameter("txtLastUpdate"));
				
				message = giacChkReleaseInfoService.saveGIACS002ChkReleaseInfo(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("spoilCheck".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("bankCd", request.getParameter("bankCd"));
				params.put("bankAcctCd", request.getParameter("bankAcctCd"));
				params.put("checkDateStr", request.getParameter("checkDate"));
				params.put("checkPrefSuf", request.getParameter("checkPrefSuf"));
				params.put("checkNo", Long.parseLong(request.getParameter("checkNo")));
				params.put("checkStat", request.getParameter("checkStat"));
				params.put("checkClass", request.getParameter("checkClass"));
				params.put("currencyCd", Integer.parseInt(request.getParameter("currencyCd")));
				params.put("currencyRt", Float.parseFloat(request.getParameter("currencyRt")));
				params.put("fcurrencyAmt", new BigDecimal(request.getParameter("fcurrencyAmt")));
				params.put("amount", new BigDecimal(request.getParameter("amount")));
				params.put("printDateStr", request.getParameter("printDate"));
				params.put("userId", USER.getUserId());
				params.put("checkDVPrint", request.getParameter("checkDVPrint"));
				params.put("tranFlag", request.getParameter("tranFlag"));
				params.put("dvFlag", request.getParameter("dvFlag"));
				params.put("lastUpdateStr", request.getParameter("lastUpdate"));
				params.put("printTag", "");		
				params.put("printTagMean", "");
				params.put("gibrGfunFundCd", request.getParameter("fundCd"));
				params.put("gibrBranchCd", request.getParameter("branchCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("batchTag", request.getParameter("batchTag"));
				
				params = chkDisbursementService.spoilCheck(params);
				JSONObject json = params == null ? new JSONObject() : new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(params));
				//added tranFlag : shan 10.22.2014
				GIACAccTransService accTransServ = APPLICATION_CONTEXT.getBean(GIACAccTransService.class);
				json.put("tranFlag", accTransServ.getTranFlag(Integer.parseInt(request.getParameter("gaccTranId"))));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getCheckCount".equals(ACTION)){
				Integer gaccTranId = request.getParameter("gaccTranId") == null ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
				message = chkDisbursementService.getCheckCount(gaccTranId).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateCheckNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("checkNo", (request.getParameter("checkNo").equals("") || request.getParameter("checkNo").equals(null)) ? null : Long.parseLong(request.getParameter("checkNo")));
				params.put("checkPrefSuf", (request.getParameter("checkPrefSuf").equals("") || request.getParameter("checkPrefSuf").equals(null)) ? null : request.getParameter("checkPrefSuf"));
				params.put("bankCd", (request.getParameter("bankCd").equals("") || request.getParameter("bankCd").equals(null)) ? null : request.getParameter("bankCd"));
				params.put("bankAcctCd", (request.getParameter("bankAcctCd").equals("") || request.getParameter("bankAcctCd").equals(null)) ? null : request.getParameter("bankAcctCd"));
				System.out.println("params: "+params);
				message = chkDisbursementService.validateCheckNo(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateBankCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("checkNo", (request.getParameter("checkNo").equals("") || request.getParameter("checkNo").equals(null)) ? null : Long.parseLong(request.getParameter("checkNo")));
				params.put("checkPrefSuf", (request.getParameter("checkPrefSuf").equals("") || request.getParameter("checkPrefSuf").equals(null)) ? null : request.getParameter("checkPrefSuf"));
				params.put("bankCd", (request.getParameter("bankCd").equals("") || request.getParameter("bankCd").equals(null)) ? null : request.getParameter("bankCd"));
				params.put("bankAcctCd", (request.getParameter("bankAcctCd").equals("") || request.getParameter("bankAcctCd").equals(null)) ? null : request.getParameter("bankAcctCd"));
				System.out.println("params: "+params);
				message = chkDisbursementService.validateBankCd(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getDBItemNoList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", (request.getParameter("gaccTranId") == null || request.getParameter("gaccTranId").equals("") ? 0 : Integer.parseInt(request.getParameter("gaccTranId"))));
				
				List<String> itemNoList = chkDisbursementService.getDBItemNoList(params);
				System.out.println("retrieved list: "+itemNoList);
				request.setAttribute("object", (List<String>)StringFormatter.escapeHTMLInList(itemNoList));
				PAGE = "/pages/genericObject.jsp";			
			} else if("showGIACS052".equals(ACTION)){				
				Map<String, Object> result = chkDisbursementService.giacs052NewFormInstance(request);
				
				if(request.getParameter("reQuery") != null && request.getParameter("reQuery").equals("Y")){
					message = new JSONObject(result).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("objGIACS052", new JSONObject(result));
					PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
					request.setAttribute("printers", printers);
					Map<String, Object> cmDmParams = StringFormatter.escapeHTMLInMap(chkDisbursementService.setCmDmPrintBtn(request, USER.getUserId()));
					request.setAttribute("setCmDmParams", new JSONObject(cmDmParams).toString()); // added by: Nica 06.13.2013 AC-SPECS-2012-153
					PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/printCheckDV.jsp";	
				}				
			} else if("showGIACS052CheckNo".equals(ACTION)){
				Map<String, Object> result = chkDisbursementService.getGiacs052DefaultCheck(request);
				request.setAttribute("objGIACS052DefaultCheck", new JSONObject(result));
				PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/checkNo.jsp";
			} else if("giacs052ProcessAfterPrinting".equals(ACTION)){
				Map<String, Object> result = chkDisbursementService.giacs052ProcessAfterPrinting(request, USER.getUserId());
				message = new JSONObject(result).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("giacs052UpdateGiac".equals(ACTION)){
				chkDisbursementService.giacs052UpdateGiac(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("giacs052SpoilCheck".equals(ACTION)){
				chkDisbursementService.giacs052SpoilCheck(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("giacs052RestoreCheck".equals(ACTION)){
				chkDisbursementService.giacs052RestoreCheck(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("setCmDmPrintBtn".equals(ACTION)){
				Map<String, Object> cmDmParams = StringFormatter.escapeHTMLInMap(chkDisbursementService.setCmDmPrintBtn(request, USER.getUserId()));
				message = new JSONObject(cmDmParams).toString();
				PAGE = "/pages/genericMessage.jsp";
				//added by MarkS 5.24.2016 SR-5484
			}else if("getCmDmTranIdMemoStat".equals(ACTION)){ 
				JSONArray jsonArray = new JSONArray(chkDisbursementService.getCmDmTranIdMemoStat(request));
				message = jsonArray.toString();
				PAGE = "/pages/genericMessage.jsp";
				//END SR-5484
			}else if("showCheckBatchPrinting".equals(ACTION)){
				GIACParameterFacadeService giacParameterService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				request.setAttribute("editCheckNo", giacParameterService.getParamValueV2("EDIT_CHECK_NO"));
				request.setAttribute("checkDvPrint", giacParameterService.getParamValueV2("CHECK_DV_PRINT"));
				PAGE = "/pages/accounting/generalDisbursements/batchCheckPrinting/checkBatchPrinting.jsp";
			}else if("getCheckBatchList".equals(ACTION)){
				JSONObject json = chkDisbursementService.getCheckBatchList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateCheck".equals(ACTION)){
				request.setAttribute("object", new JSONObject(chkDisbursementService.generateCheck(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("enterCheckDate".equals(ACTION)){
				PAGE = "/pages/accounting/generalDisbursements/batchCheckPrinting/popups/enterCheckDate.jsp";
			}else if("validateSpoilCheck".equals(ACTION)){
				chkDisbursementService.validateSpoilCheck(request);
				PAGE = "/pages/genericObject.jsp";
			}else if("spoilCheckGIACS054".equals(ACTION)){
				chkDisbursementService.spoilCheckGIACS054(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCheckSeqNo".equals(ACTION)){
				request.setAttribute("object", chkDisbursementService.getCheckSeqNo(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateCheckSeqNo".equals(ACTION)){
				chkDisbursementService.validateCheckSeqNo(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("processPrintedChecks".equals(ACTION)){
				chkDisbursementService.processPrintedChecks(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("updatePrintedChecks".equals(ACTION)){
				chkDisbursementService.updatePrintedChecks(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLastCheckNoOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/generalDisbursements/batchCheckPrinting/popups/enterLastPrintedCheck.jsp";
			}else if("getCheckBatchListByParam".equals(ACTION)){
				JSONArray json = chkDisbursementService.getCheckBatchListByParam(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateCheckNo".equals(ACTION)){
				JSONObject res = chkDisbursementService.generateCheckNo(request);
				message = res.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getCheckDvPrint".equals(ACTION)){
				GIACParameterFacadeService giacParameterService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				String checkDvPrint = chkDisbursementService.checkDVPrintColumn(request);
				if (checkDvPrint == null) {
					checkDvPrint = giacParameterService.getParamValueV2("CHECK_DV_PRINT");
				}
				message = checkDvPrint;
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch(SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e) {
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
