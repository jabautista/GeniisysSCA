package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACBranch;
import com.geniisys.giac.entity.GIACDCBUser;
import com.geniisys.giac.service.GIACApdcPaytDtlService;
import com.geniisys.giac.service.GIACApdcPaytService;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACDCBUserService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACPdcPremCollnService;
import com.geniisys.giac.service.GIACPdcReplaceService;
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACAcknowledgmentReceiptsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACAcknowledgmentReceiptsController.class);
	
	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		log.info("Initializing " + this.getClass().getSimpleName());
		
		try{
			GIACApdcPaytService giacApdcPaytService = (GIACApdcPaytService) APPLICATION_CONTEXT.getBean("giacApdcPaytService");
			GIACApdcPaytDtlService giacApdcPaytDtlService = (GIACApdcPaytDtlService) APPLICATION_CONTEXT.getBean("giacApdcPaytDtlService");
			GIACPdcPremCollnService pdcPremCollnService = (GIACPdcPremCollnService) APPLICATION_CONTEXT.getBean("giacPdcPremCollnService");
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			
			if("getApdcPaytList".equals(ACTION)){
				JSONObject json = giacApdcPaytService.getGIACApdcPaytListing(request, USER.getUserId());
				if(request.getParameter("refresh")!= null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("apdcTableGrid", json);					
					PAGE = "/pages/accounting/PDCPayment/acknowledgmentReceiptListing.jsp";
				}
			} else if ("showGIACApdcPayt".equals(ACTION)){
				giacApdcPaytService.showGIACApdcPayt(request, APPLICATION_CONTEXT, USER.getUserId());
				PAGE = "/pages/accounting/PDCPayment/acknowledgmentReceiptMain.jsp";
			} else if ("showAcknowledgmentReceipt".equals(ACTION)){
				GIACBranchService branchDetailService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				GIACBranch branchDetails = branchDetailService.getBranchDetails2(
						(request.getParameter("branchCd")==null || "".equals(request.getParameter("branchCd")) ? "HO" : request.getParameter("branchCd")));
				System.out.println("showAcknowledgmentReceipt for Branch "+branchDetails.getBranchName());
				Map<String, Object> popApdcMap = new HashMap<String, Object>();
				
				request.setAttribute("branchDetails", branchDetails);
				request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
				String[] checkClass = {"GIAC_CHK_DISBURSEMENT.CHECK_CLASS"};
				request.setAttribute("checkClass", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, checkClass)); // andrew - 10.21.2011
				popApdcMap.put("fundCd", branchDetails.getGfunFundCd());
				popApdcMap.put("branchCd", branchDetails.getBranchCd());
				popApdcMap.put("apdcFlag", "N");
				giacApdcPaytService.popApdc(popApdcMap);
				
				request.setAttribute("docPrefSuf", popApdcMap.get("docPrefSuf"));
				request.setAttribute("apdcFlag", popApdcMap.get("apdcFlag"));
				request.setAttribute("dspStatus", popApdcMap.get("dspStatus"));
				request.setAttribute("defaultCurrency", popApdcMap.get("defaultCurrency"));
				request.setAttribute("premTaxPriority", popApdcMap.get("premTaxPriority"));
				
				// andrew
				Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				if(!request.getParameter("apdcId").equals("")){
					Integer apdcId = Integer.parseInt(request.getParameter("apdcId"));
					request.setAttribute("giacApdcPayt", new JSONObject(StringFormatter.replaceQuotesInObject(giacApdcPaytService.getGIACApdcPayt(apdcId))));
				} else {
					request.setAttribute("giacApdcPayt", "{}");
				}
				
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("apdcId", request.getParameter("apdcId"));
				grid.put("currentPage", page);				
				grid = giacApdcPaytDtlService.getApdcPaytDtlTableGrid(grid);
				System.out.println("getApdcPaytDtlTableGrid ::::::::::::::::::" + grid);
				request.setAttribute("postDatedChecksTableGrid", new JSONObject(StringFormatter.replaceQuotesInMap(grid)));
				
				String[] transType = {"GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE"};
				request.setAttribute("tranTypeLOV", lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, transType));
				
				PAGE = "/pages/accounting/PDCPayment/acknowledgmentReceiptMain.jsp";
			} else if ("openAPDCPayorModal".equals(ACTION)){
				
				PAGE = "/pages/accounting/PDCPayment/pop-ups/searchAPDCPayor.jsp";
			} else if ("getAPDCPayorListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("page", Integer.parseInt(request.getParameter("pageNo")) - 1);
				params.put("keyword", request.getParameter("keyword"));
				
				PaginatedList searchResult = giacApdcPaytService.getApdcPaytListing(params);
				
				request.setAttribute("apdcPaytListing", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				PAGE = "/pages/accounting/PDCPayment/pop-ups/searchAPDCPayorAjaxResult.jsp";
			} else if ("getPostDatedChecks".equals(ACTION)){
				Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("apdcId", request.getParameter("apdcId"));
				grid.put("currentPage", page);				
				grid = giacApdcPaytDtlService.getApdcPaytDtlTableGrid(grid);	
				System.out.println("getPostDatedChecks ::::::::::::::::::" + grid);
				request.setAttribute("postDatedChecksTableGrid", new JSONObject(StringFormatter.replaceQuotesInMap(grid)));
				PAGE = "/pages/accounting/PDCPayment/subPages/postDatedChecks.jsp";
			} else if ("refreshPostDatedChecksTable".equals(ACTION)){
				/*Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("apdcId", request.getParameter("apdcId"));
				grid.put("currentPage", page);
				grid.put("filter", request.getParameter("objFilter"));
				
				System.out.println("filter testing : " + grid.get("filter").toString());
				
				grid = giacApdcPaytDtlService.getApdcPaytDtlTableGrid(grid);*/
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("apdcId", request.getParameter("apdcId"));
				grid.put("ACTION", "getApdcPaytDtlTableGrid");
				grid = TableGridUtil.getTableGrid(request, grid);
				JSONObject json = new JSONObject(grid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getPostDatedChecksDtls".equals(ACTION)){
				Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("pdcId", request.getParameter("pdcId"));
				grid.put("currentPage", page);
				
				grid = pdcPremCollnService.getPostDatedCheckDtls(grid);
				System.out.println("angelo testing : " + grid.toString());
				
				request.setAttribute("postDatedChecksObjTableGrid", new JSONObject(StringFormatter.replaceQuotesInMap(grid)));
				PAGE = "/pages/accounting/PDCPayment/subPages/postDatedChecksDtls.jsp";
			} else if ("refreshPostDatedChecksDetailsTable".equals(ACTION)){
				Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("pdcId", request.getParameter("pdcId"));
				grid.put("currentPage", page);
				grid.put("filter", request.getParameter("objFilter"));
				
				grid = pdcPremCollnService.getPostDatedCheckDtls(grid);
				
				JSONObject json = new JSONObject(grid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getPdcPostQueryDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				Integer premSeqNo = request.getParameter("premSeqNo") == "" ? 0 : Integer.parseInt(request.getParameter("premSeqNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", premSeqNo);
				
				giacApdcPaytDtlService.gpdcPremPostQuery(params);
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("checkIfGeneratedOR".equals(ACTION)){
				message = giacApdcPaytDtlService.checkGeneratedOR(Integer.parseInt(request.getParameter("apdcId")));
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getTableGridLOVs".equals(ACTION)){
				String[] checkClass = {"GIAC_CHK_DISBURSEMENT.CHECK_CLASS"};
				String[] checkStatus = {"GIAC_APDC_PAYT_DTL.CHECK_FLAG"};
				String[] transType = {"GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE"};
				Map<String, Object> lovs = new HashMap<String, Object>();
				lovs.put("checkClassLOV", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, checkClass));
				lovs.put("bankListingLOV", lovHelper.getList(LOVHelper.BANK_LISTING));
				lovs.put("currencyListingLOV", lovHelper.getList(LOVHelper.CURRENCY_CODES));
				lovs.put("transactionTypeLOV", lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, transType));
				lovs.put("paymentModeLOV", lovHelper.getList(LOVHelper.PAY_MODE_LISTING));
				lovs.put("checkStatusLOV", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, checkStatus));
				
				request.setAttribute("object", new JSONObject(lovs));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("generatePdcId".equals(ACTION)){
				message = giacApdcPaytDtlService.generatePdcId().toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGiacs090Variables".equals(ACTION)){
				GIACParameterFacadeService giacParameters = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISParameterFacadeService giisParameters = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				Map<String, Object> giacs090VarMap = new HashMap<String, Object>();
				giacs090VarMap.put("staleCheckVar", giacParameters.getParamValueN("STALE_CHECK"));
				giacs090VarMap.put("staleMgrCheckVar", giacParameters.getParamValueN("STALE_MGR_CHK"));
				giacs090VarMap.put("staleDaysVar", giacParameters.getParamValueN("STALE_DAYS"));
				giacs090VarMap.put("implementationSw", giisParameters.getParamValueV2("IMPLEMENTATION_SW"));
				
				request.setAttribute("object", new JSONObject(giacs090VarMap));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("validatePremSeqNo".equals(ACTION)){
				Map<String, Object> premSeqNoValidationMap = new HashMap<String, Object>();
				premSeqNoValidationMap.put("issCd", request.getParameter("issCd"));
				premSeqNoValidationMap.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				premSeqNoValidationMap.put("pdcId", Integer.parseInt(request.getParameter("pdcId")));
				premSeqNoValidationMap.put("tranType", Integer.parseInt(request.getParameter("tranType")));
				
				pdcPremCollnService.validatePremSeqNo(premSeqNoValidationMap);
				
				request.setAttribute("object", new JSONObject(premSeqNoValidationMap));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("showInstNoList".equals(ACTION)){
				request.setAttribute("issCd", request.getParameter("issCd"));
				request.setAttribute("premSeqNo", request.getParameter("premSeqNo"));
				
				PAGE = "/pages/accounting/PDCPayment/pop-ups/instNoListing.jsp";
			} else if ("reloadInstNoList".equals(ACTION)){
				GIPIInstallmentService gipiInstService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				Integer pageNo = Integer.parseInt(request.getParameter("page")) - 1;
				params.put("pageNo", pageNo.toString());
				
				PaginatedList gipiInstListing = gipiInstService.getInstNoList(params);
				
				request.setAttribute("gipiInstListing", gipiInstListing);
				request.setAttribute("issCd", params.get("issCd"));
				request.setAttribute("premSeqNo", params.get("premSeqNo"));
				request.setAttribute("pageNo", request.getParameter("page"));
				request.setAttribute("noOfPages", gipiInstListing.getNoOfPages());
				
				PAGE = "/pages/accounting/PDCPayment/pop-ups/instNoListingAjaxResult.jsp";
			} else if ("getPdcPremDtls".equals(ACTION)){
				Map<String, Object> pdcPremDtlsMap = new HashMap<String, Object>();
				pdcPremDtlsMap.put("issCd", request.getParameter("issCd"));
				pdcPremDtlsMap.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				pdcPremDtlsMap.put("instNo", Integer.parseInt(request.getParameter("instNo")));
				
				pdcPremCollnService.getPdcPremCollnDtls(pdcPremDtlsMap);
				
				request.setAttribute("object", new JSONObject(pdcPremDtlsMap));
				PAGE = "/pages/genericObject.jsp";
			} else if ("saveAcknowledgmentReceipt".equals(ACTION)){
				Map<String, Object> ackReceiptParams = new HashMap<String, Object>();
				/*
				ackReceiptParams.put("apdcPaytObj", request.getParameter("apdcPaytObj"));
				ackReceiptParams.put("apdcPaytDtlObj", request.getParameter("apdcPaytDtlObj"));
				ackReceiptParams.put("insertedPremCollnObj", request.getParameter("insertedPremCollnObj"));
				ackReceiptParams.put("updatedPremCollnObj", request.getParameter("updatedPremCollnObj"));
				ackReceiptParams.put("deletedApdcId", request.getParameter("deletedApdcId"));
				ackReceiptParams.put("deletedApdcPaytDtlObj", request.getParameter("deletedApdcPaytDtlObj"));
				ackReceiptParams.put("deletedPremCollnObj", request.getParameter("deletedPremCollnObj"));
				ackReceiptParams.put("pdcReplaceObj", request.getParameter("pdcReplaceObj"));*/
				
				ackReceiptParams.put("parameters", request.getParameter("parameters"));
				
				System.out.println("tester : " + request.getParameter("premCollnObj"));
				
				giacApdcPaytService.saveAcknowledgmentReceipt(ackReceiptParams);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("openReplacePDCModal".equals(ACTION)){
				DateFormat fmt = new SimpleDateFormat("dd-MMM-yyyy");
				DateFormat df = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy");
				String dateString = request.getParameter("replaceDate");
				System.out.println(dateString);
				request.setAttribute("pdcId", request.getParameter("pdcId"));
				request.setAttribute("itemNo", request.getParameter("itemNo"));
				request.setAttribute("bank", request.getParameter("bank"));
				request.setAttribute("checkNo", request.getParameter("checkNo"));
				request.setAttribute("amount", request.getParameter("amount"));
				request.setAttribute("replaceDate", "null".equals(dateString) ? "" : fmt.format(df.parse(request.getParameter("replaceDate"))));
				
				PAGE = "/pages/accounting/PDCPayment/pop-ups/replacePDC.jsp";
			} else if ("getPdcRepDtls".equals(ACTION)){
				GIACPdcReplaceService pdcReplaceService = (GIACPdcReplaceService) APPLICATION_CONTEXT.getBean("giacPdcReplaceService");
				Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("pdcId", request.getParameter("pdcId"));
				grid.put("currentPage", page);
				
				grid = pdcReplaceService.getPdcRepDtls(grid);
				
				request.setAttribute("object", new JSONObject(grid));
				PAGE = "/pages/genericObject.jsp";
			} else if ("refreshReplacePdcTable".equals(ACTION)){
				GIACPdcReplaceService pdcReplaceService = (GIACPdcReplaceService) APPLICATION_CONTEXT.getBean("giacPdcReplaceService");
				Integer page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("pdcId", request.getParameter("pdcId"));
				grid.put("itemNo", request.getParameter("itemNo"));
				grid.put("currentPage", page);
				grid.put("filter", request.getParameter("objFilter"));
				
				grid = pdcReplaceService.getPdcRepDtls(grid);
				
				JSONObject json = new JSONObject(grid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCashierCd".equals(ACTION)){
				GIACDCBUserService cashierDtlService = (GIACDCBUserService) APPLICATION_CONTEXT.getBean("giacDCBUserService");
				GIACDCBUser cashierDetail = cashierDtlService.getDCBCashierCd(request.getParameter("fundCd"), request.getParameter("branchCd"), USER.getUserId());
				Integer cashierCd = cashierDetail.getCashierCd();
				
				message = cashierCd.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("generateApdcId".equals(ACTION)){
				Integer apdcId = giacApdcPaytService.generateApdcId();
				//Integer apdcId = 11111; //temporary...
				
				message = apdcId.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showSpecificUpdate".equals(ACTION)){
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService"); //benjo 11.08.2016 SR-5802
				request.setAttribute("apdcSw", giacParamService.getParamValueV2("APDC_SW")); //benjo 11.08.2016 SR-5802
				PAGE = "/pages/accounting/PDCPayment/pop-ups/pdcPremCollnUpdate.jsp";
			} else if ("fetchPdcPremUpdateValues".equals(ACTION)){
				Map<String, Object> pdcPremUpdateMap = new HashMap<String, Object>();
				pdcPremUpdateMap.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				pdcPremUpdateMap.put("issCd", request.getParameter("issCd"));
				pdcPremCollnService.fetchPremCollnUpdateValues(pdcPremUpdateMap);
				
				request.setAttribute("object", new JSONObject(pdcPremUpdateMap));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("getParticulars".equals(ACTION)){
				int param = Integer.parseInt(request.getParameter("fetchParam"));
				Map<String, Object> params = new HashMap<String, Object>();
				
				if (param == 1){
					params.put("apdcId", Integer.parseInt(request.getParameter("apdcId")));
					params.put("pdcId", Integer.parseInt(request.getParameter("pdcId")));
					params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
					
					message = pdcPremCollnService.getParticulars(params);
				} else if (param == 2){
					params.put("apdcId", Integer.parseInt(request.getParameter("apdcId")));
					params.put("currParticulars", request.getParameter("currParticulars"));

					System.out.println(request.getParameter("currParticulars"));
					
					message = pdcPremCollnService.getParticulars2(params);
				}
				
				PAGE = "/pages/genericMessage.jsp";
			} else if("getBreakdownAmounts".equals(ACTION)){
				JSONObject json =  giacApdcPaytService.getBreakdownAmounts(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("delApdcPayt".equals(ACTION)){
				giacApdcPaytService.delGIACApdcPayt(Integer.parseInt(request.getParameter("apdcId")));
			} else if("cancelApdcPayt".equals(ACTION)){
				giacApdcPaytService.cancelGIACApdcPayt(Integer.parseInt(request.getParameter("apdcId")), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGIACApdcPayt".equals(ACTION)){
				giacApdcPaytService.saveGIACApdcPayt(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showAPDCPrintDialog".equals(ACTION)){
				String apdcNo = request.getParameter("apdcNo");				
				String newApdcNo = "";
							
				if (!("".equals(apdcNo))){
					newApdcNo = apdcNo;
				} else {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("branchCd", request.getParameter("branchCd"));
					params.put("fundCd", request.getParameter("fundCd"));
					newApdcNo = String.format("%010d", giacApdcPaytService.getDocSeqNo(params));
				}
				
				request.setAttribute("apdcNo", newApdcNo);
				request.setAttribute("apdcId", request.getParameter("apdcId"));
				request.setAttribute("cicPrintTag", request.getParameter("cicPrintTag"));
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/PDCPayment/pop-ups/printAcknowledgmentReceipt.jsp";
			} else if ("valDelApdc".equals(ACTION)){
				giacApdcPaytService.valDelApdc(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("showPolicyEntry".equals(ACTION)){ //benjo 11.08.2016 SR-5802
				PAGE = "/pages/accounting/PDCPayment/pop-ups/pdcPolicyEntry.jsp";
			}
		} catch (SQLException e){
			if(e.getErrorCode() > 20000){ //added by jdiago 08012014 : for custom error messages
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
