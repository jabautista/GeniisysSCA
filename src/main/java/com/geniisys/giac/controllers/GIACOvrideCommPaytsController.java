package com.geniisys.giac.controllers;

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

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACOvrideCommPayts;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACOvrideCommPaytsService;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACOvrideCommPaytsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The log	 */
	private static Logger log = Logger.getLogger(GIACOvrideCommPaytsController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		PAGE = "/pages/genericMessage.jsp";
		log.info("");
		Integer gaccTranId = (request.getParameter("gaccTranId") == null || request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null")) ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
		//Integer gaccTranId = 45591; // temporary
		
		try {
			if ("showOverridingComm".equals(ACTION)) {
				// Service(s)
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] tranTypeArgs = {"GIAC_OVRIDE_COMM_PAYTS.TRANSACTION_TYPE"};
				//String[] issSourceArgs = {"GIACS040", USER.getUserId()}; //remove by steven 11.19.2014
				//String[] dfltBillNoArgs = {"HO"}; //remove by steven 11.19.2014
				BigDecimal controlDrvCommAmt2 = new BigDecimal(0);
				BigDecimal controlDrvInvatAmt = new BigDecimal(0);
				BigDecimal controlDrvWtaxAmt = new BigDecimal(0);
				BigDecimal controlDrvCommAmt3 = new BigDecimal(0);
				
				// Objects
				@SuppressWarnings("unchecked")
				List<GIACOvrideCommPayts> ovrideCommPaytsList = (List<GIACOvrideCommPayts>) StringFormatter.escapeHTMLInList(ovrideCommPaytsService.getGIACOvrideCommPayts(gaccTranId)); //added by robert 05.12.2014
				
				for (GIACOvrideCommPayts ovrideCommPayts : ovrideCommPaytsList) {
					controlDrvCommAmt2 = (ovrideCommPayts.getCommAmt() == null) ? controlDrvCommAmt2 : controlDrvCommAmt2.add(ovrideCommPayts.getCommAmt());
					controlDrvInvatAmt = (ovrideCommPayts.getInputVAT() == null) ? controlDrvInvatAmt : controlDrvInvatAmt.add(ovrideCommPayts.getInputVAT());
					controlDrvWtaxAmt = (ovrideCommPayts.getWtaxAmt() == null) ? controlDrvWtaxAmt : controlDrvWtaxAmt.add(ovrideCommPayts.getWtaxAmt());
					controlDrvCommAmt3 = (ovrideCommPayts.getDrvCommAmt() == null) ? controlDrvCommAmt3 : controlDrvCommAmt3.add(ovrideCommPayts.getDrvCommAmt());
				}
				
				// set page objects
				request.setAttribute("ovrideCommPaytsList", new JSONArray(ovrideCommPaytsList));
				request.setAttribute("transactionTypeList", lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, tranTypeArgs));
				request.setAttribute("controlDrvCommAmt2", controlDrvCommAmt2);
				request.setAttribute("controlDrvInvatAmt", controlDrvInvatAmt);
				request.setAttribute("controlDrvWtaxAmt", controlDrvWtaxAmt);
				request.setAttribute("controlDrvCommAmt3", controlDrvCommAmt3);
				
				/*for (int i = 1; i <= 4; i++) {
					String[] billNoArgs = {Integer.toString(i)};
					request.setAttribute("billNoList"+i, new JSONArray(lovHelper.getList(LOVHelper.OVRIDE_COMM_BILL_NO_LIST_PER_TRAN_TYPE, billNoArgs)));
				}*/ //remove by steven 11.19.2014 changed the process of the bill no LOV
				//request.setAttribute("issueSourceList", lovHelper.getList(LOVHelper.OVRIDE_COMM_ISS_SOURCE_LISTING, issSourceArgs)); //remove by steven 11.19.2014
				//request.setAttribute("dfltBillNoList", new JSONArray(lovHelper.getList(LOVHelper.DFLT_OVRIDE_COMM_BILL_NO_LIST, dfltBillNoArgs))); //remove by steven 11.19.2014
				
				PAGE = "/pages/accounting/officialReceipt/subPages/directTransOverridingComm.jsp";
			} else if ("chckPremPayts".equals(ACTION)) {
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				ovrideCommPaytsService.chckPremPayts(params);
				
				// added to allow tagging if NO_PREM_PAYT = N and user has MC function under GIACS040 : shan 03.09.2015 
				GIPIWCommInvoiceService commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				GIACModulesService giacModuleService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				String noPremPayt = commInvoiceService.getAccountingParameter("NO_PREM_PAYT");
				Map<String, Object> userParams = new HashMap<String, Object>(); 
				userParams.put("user", USER.getUserId());
				userParams.put("moduleName", "GIACS040");
				userParams.put("funcCode", "MC");
				String accessMC = giacModuleService.validateUserFunc3(userParams);
				
				params.put("noPremPayt", noPremPayt);		
				params.put("accessMC", accessMC);
				// 03.09.2015
				
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("chckBalance".equals(ACTION)) {
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				System.out.println("CHCK_BALANCE: " +params.toString());
				ovrideCommPaytsService.chckBalance(params);
				System.out.println("AFTER CHCK_BALANCE: " +params.toString());
				
				// added to allow tagging if NO_PREM_PAYT = N and user has MC function under GIACS040 : shan 03.09.2015 
				GIPIWCommInvoiceService commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				GIACModulesService giacModuleService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				String noPremPayt = commInvoiceService.getAccountingParameter("NO_PREM_PAYT");
				Map<String, Object> userParams = new HashMap<String, Object>(); 
				userParams.put("user", USER.getUserId());
				userParams.put("moduleName", "GIACS040");
				userParams.put("funcCode", "MC");
				String accessMC = giacModuleService.validateUserFunc3(userParams);
				
				params.put("noPremPayt", noPremPayt);		
				params.put("accessMC", accessMC);
				// 03.09.2015
				
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("getIntermediaryListing".equals(ACTION)) {
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = {request.getParameter("issCd"), request.getParameter("premSeqNo")};
				
				request.setAttribute("intmListing", lovHelper.getList(LOVHelper.PARENT_COMM_INV_INTM_LISTING, args));
				request.setAttribute("width", (request.getParameter("width") == null) ? "10" : request.getParameter("width"));
				request.setAttribute("tabIndex", (request.getParameter("tabIndex") == null) ? "1" : request.getParameter("tabIndex"));
				request.setAttribute("listId", (request.getParameter("listId") == null) ? "intermediary" : request.getParameter("listId"));
				request.setAttribute("listName", (request.getParameter("listName") == null) ? "intermediary" : request.getParameter("listName"));
				request.setAttribute("className", (request.getParameter("className") == null) ? new String("") : request.getParameter("className"));
				
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/intermediaryListing.jsp";
			} else if ("getChildIntmListing".equals(ACTION)) {
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = {request.getParameter("issCd"), request.getParameter("premSeqNo"), request.getParameter("intmNo"), request.getParameter("distinct")};
				
				request.setAttribute("intmListing", lovHelper.getList(LOVHelper.PARENT_COMM_INV_CHLD_INTM_LISTING, args));
				request.setAttribute("width", (request.getParameter("width") == null) ? "10" : request.getParameter("width"));
				request.setAttribute("tabIndex", (request.getParameter("tabIndex") == null) ? "1" : request.getParameter("tabIndex"));
				request.setAttribute("listId", (request.getParameter("listId") == null) ? "intermediary" : request.getParameter("listId"));
				request.setAttribute("listName", (request.getParameter("listName") == null) ? "intermediary" : request.getParameter("listName"));
				request.setAttribute("className", (request.getParameter("className") == null) ? new String("") : request.getParameter("className"));
				
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/intermediaryListing.jsp";
			} else if ("validateChildIntmNo".equals(ACTION)) {
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				ovrideCommPaytsService.validateGiacs040ChildIntmNo(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("validateCommAmt".equals(ACTION)) {
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				System.out.println(request.getParameter("currentBill").replaceAll("%23", "#"));
				params.put("currentBill", request.getParameter("currentBill").replaceAll("%23", "#"));
				ovrideCommPaytsService.validateGiacs040CommAmt(params);				
				params.put("commAmt", params.get("commAmt"));			
				params = ovrideCommPaytsService.getInputVAT(params);
				
				System.out.println("==== PARAMS: " + params.toString());
				params.remove("currentBill");
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("validateForeignCurrAmt".equals(ACTION)) {
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				ovrideCommPaytsService.validateGiacs040ForeignCurrAmt(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("saveOverridingCommPayts".equals(ACTION)) {
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				
				String tranId = request.getParameter("gaccTranId");
				String gaccBranchCd = request.getParameter("gaccBranchCd");
				String gaccFundCd = request.getParameter("gaccFundCd");
				String tranSource = request.getParameter("tranSource");
				String orFlag = request.getParameter("orFlag");
				String varModuleName = request.getParameter("varModuleName");
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("gaccTranId", tranId);
				params.put("gaccBranchCd", gaccBranchCd);
				params.put("gaccFundCd", gaccFundCd);
				params.put("tranSource", tranSource);
				params.put("orFlag", orFlag);
				params.put("varModuleName", varModuleName);
				params.put("appUser", USER.getUserId());
				
				message = ovrideCommPaytsService.saveGIACOvrideCommPayts(setRows, delRows, params);
			}else if("getOvrideCommList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("tranType", request.getParameter("tranType"));
				params.put("newBills", request.getParameter("newBills"));
				params.put("deletedBills", request.getParameter("deletedBills"));
				params.put("ACTION", "getOvrideCommList");
				Map<String, Object> ovrideCommTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(ovrideCommTableGrid);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("ovrideCommTG", json);
					PAGE = "/pages/accounting/officialReceipt/pop-ups/searchOvrideCommBillNo.jsp";
				}
			}else if("validateTranRefund".equals(ACTION)){
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				
				message = ovrideCommPaytsService.validateTranRefund(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteRec".equals(ACTION)){
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				ovrideCommPaytsService.valDeleteRec(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getInputVAT".equals(ACTION)){
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("commAmt", request.getParameter("commAmt"));
				
				message = new JSONObject(ovrideCommPaytsService.getInputVAT(params)).toString();
				PAGE = "/pages/genericMessage.jsp";				
			}else if("validateBill".equals(ACTION)){
				GIACOvrideCommPaytsService ovrideCommPaytsService = (GIACOvrideCommPaytsService) APPLICATION_CONTEXT.getBean("giacOvrideCommPaytsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				message = ovrideCommPaytsService.validateBill(params);
				System.out.println("MESSAGE: " + message);
				PAGE = "/pages/genericMessage.jsp";
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
