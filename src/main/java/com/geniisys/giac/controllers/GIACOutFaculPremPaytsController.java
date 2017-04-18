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

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISReinsurer;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISReinsurerService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACOutFaculPremPaytsService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACOutFaculPremPaytsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIACOutFaculPremPaytsController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,HttpServletResponse response, GIISUser USER, String ACTION,	HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			GIACOutFaculPremPaytsService giacOutFaculPremPaytsService = (GIACOutFaculPremPaytsService) APPLICATION_CONTEXT.getBean("giacOutFaculPremPaytService");
			LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			
			if ("showOutFaculPremPayts".equals(ACTION)){ //unused,replaced to showOutFaculPremPaytsTableGrid
				GIISReinsurerService giisReinsurerService = (GIISReinsurerService) APPLICATION_CONTEXT.getBean("giisReinsurerService");
				
				String[] param = {"GIAC_OUTFACUL_PREM_PAYTS.TRANSACTION_TYPE"};
				
				List<LOV> tranTypeList = helper.getList(LOVHelper.CG_REF_CODE_LISTING, param);
				System.out.println("SIZE TRAN TYPE LIST: " + tranTypeList.size());
				StringFormatter.replaceQuotesInList(tranTypeList);
				request.setAttribute("tranTypeListJSON", new JSONArray(tranTypeList));
				
				List<GIISReinsurer> reinsurerDtls = giisReinsurerService.getAllGiisReinsurer();
				StringFormatter.replaceQuotesInList(reinsurerDtls);
				request.setAttribute("giisReinsurerJSON", new JSONArray(reinsurerDtls));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("moduleName", "GIACS019");
				params.put("user", USER.getUserId());
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				
				List<Map<String, Object>> outFaculPremPayts = giacOutFaculPremPaytsService.getAllOutFaculPremPayts(params);
				System.out.println("FACUL SIZE: " + outFaculPremPayts.size());
				StringFormatter.replaceQuotesInListOfMap(outFaculPremPayts);
				request.setAttribute("outFaculPremPaytsJSON", new JSONArray(outFaculPremPayts));
				
				PAGE = "/pages/accounting/officialReceipt/riTrans/outwardFaculPremPayts.jsp";
				
			}else if ("showOutFaculPremPaytsTableGrid".equals(ACTION)){	//added by steven 5.16.2012
//				GIISReinsurerService giisReinsurerService = (GIISReinsurerService) APPLICATION_CONTEXT.getBean("giisReinsurerService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				String[] param = {"GIAC_OUTFACUL_PREM_PAYTS.TRANSACTION_TYPE"};
				BigDecimal totalAmt = new BigDecimal(0); 
			
				List<LOV> tranTypeList = helper.getList(LOVHelper.CG_REF_CODE_LISTING, param);
				System.out.println("SIZE TRAN TYPE LIST: " + tranTypeList.size());
				StringFormatter.replaceQuotesInList(tranTypeList);
				request.setAttribute("tranTypeListJSON", new JSONArray(tranTypeList));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getAllOutFaculPremPaytsDtls" /*"getAllOutFaculPremPayts2" */); // SR-19792, 19840 : shan 08.06.2015
				params.put("moduleName", "GIACS019");
				params.put("userId", USER.getUserId());
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				
				Map<String, Object> outFaculPremPayts = TableGridUtil.getTableGrid(request, params);
				JSONObject objOutFaculPremPayts = new JSONObject(outFaculPremPayts);
				JSONArray rows = objOutFaculPremPayts.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					totalAmt = new BigDecimal(rows.getJSONObject(i).getString("totalAmt"));
				}
				request.setAttribute("totalAmt", totalAmt);
				if("1".equals(request.getParameter("refresh"))){
					request.setAttribute("autoGenerateRCM", giacParamService.getParamValueV2("AUTO_GENERATE_RCM")); // added by: Nica 06.10.2013
					request.setAttribute("objOutFaculPremPayts", objOutFaculPremPayts);
					PAGE = "/pages/accounting/officialReceipt/riTrans/outwardFaculPremPaytsTableGrid.jsp";
				}else{
					message = objOutFaculPremPayts.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			}else if ("openSearchBinderModal".equals(ACTION)){	//unused,replaced to openSearchBinderModal2
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd").equals("null") ? "" : request.getParameter("lineCd")); 
				params.put("binderYY", request.getParameter("binderYY").equals("null") ? "" : request.getParameter("binderYY"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo").equals("null") ? "" : request.getParameter("binderSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				params.put("moduleName", request.getParameter("moduleId"));
				params.put("ACTION","getBinderListTableGrid2");
				params.put("currentPage", Integer.parseInt((request.getParameter("page") == null ? "1" : request.getParameter("page"))));
				
				Debug.print("controller params: " + params);
				
				Map<String, Object> outFaculPremPaytsTableGrid = giacOutFaculPremPaytsService.getBinderList2(params);
				//StringFormatter.replaceQuotesInList(outFaculPremPaytsTableGrid);
				request.setAttribute("outFaculPremPaytsTableGrid", new JSONObject(outFaculPremPaytsTableGrid));
				PAGE = "/pages/accounting/officialReceipt/riTrans/pop-ups/searchBinderNoModal.jsp";
			}else if ("openSearchBinderModal2".equals(ACTION)){ //added by steven 5.17.2012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd").equals("null") ? "" : request.getParameter("lineCd")); 
				params.put("binderYY", request.getParameter("binderYY").equals("null") ? "" : request.getParameter("binderYY"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				params.put("moduleName", request.getParameter("moduleId"));
				if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
					params.put("notIn",request.getParameter("notIn"));
				}
				params.put("ACTION","getBinderListTableGrid2");
				
				
				Debug.print("controller params: " + params);
				
				Map<String, Object> binderLov = TableGridUtil.getTableGrid(request, params);
				JSONObject objBinderLov = new JSONObject(binderLov);
				if("1".equals(request.getParameter("ajaxModal"))){
					request.setAttribute("objBinderLov", objBinderLov);
					PAGE = "/pages/accounting/officialReceipt/riTrans/pop-ups/searchBinderNoModal.jsp";
				}else{
					message = objBinderLov.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			}else if ("checkIfBinderExistInList".equals(ACTION)){ //added by steven 5.17.2012
				GIISReinsurerService giisReinsurerService = (GIISReinsurerService) APPLICATION_CONTEXT.getBean("giisReinsurerService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				params.put("moduleName", request.getParameter("moduleId"));
				
				message = giisReinsurerService.checkIfBinderExist(params);
				PAGE =  "/pages/genericMessage.jsp";
			}else if ("refreshOutFaculPremPayts".equals(ACTION)) { //unused,replaced to openSearchBinderModal2
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd").equals("null") ? "" : request.getParameter("lineCd")); 
				params.put("binderYY", request.getParameter("binderYY").equals("null") ? null : request.getParameter("binderYY"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				params.put("moduleName", request.getParameter("moduleId"));
				params.put("currentPage", Integer.parseInt((request.getParameter("page") == null ? "1" : request.getParameter("page"))));
				params.put("filter", request.getParameter("objFilter"));
				Debug.print("controller params: " + params);
				
				Map<String, Object> outFaculPremPaytsTableGrid = giacOutFaculPremPaytsService.getBinderList2(params);
				//StringFormatter.replaceQuotesInList(outFaculPremPaytsTableGrid);
				
				message = new JSONObject(outFaculPremPaytsTableGrid).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateBinderNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd")); 
				params.put("binderYY", request.getParameter("binderYY"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				params.put("moduleName", request.getParameter("moduleId"));
				Debug.print("validate binderNo: " + params);
				List<Map<String, Object>> outFaculPremPayts = giacOutFaculPremPaytsService.validateBinderNo(params);
				StringFormatter.replaceQuotesInList(outFaculPremPayts);
				
				message = new JSONArray(outFaculPremPayts).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showBreakdown".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYY", request.getParameter("binderYY"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo"));
				params.put("disbursementAmt", request.getParameter("disbursementAmt"));
				Debug.print("showBreakDown params: " + params);
				
				Map<String, Object> breakdownDtls = giacOutFaculPremPaytsService.getBreakdownAmts(params);
				Debug.print("output breakdown: " + breakdownDtls);
				request.setAttribute("breakdownDtlsMap", breakdownDtls);
				//request.setAttribute("breakdownDtls", new JSONObject(breakdownDtls));
				
				PAGE = "/pages/accounting/officialReceipt/riTrans/pop-ups/breakdown.jsp";
				
			}else if ("saveOutFaculPremPayts".equals(ACTION)){
				
				Map<String, Object> allParams = new HashMap<String, Object>();
				allParams.put("jsonParameters", request.getParameter("param"));
				allParams.put("gaccTranId", request.getParameter("gaccTranId"));
				allParams.put("userId", USER.getUserId());
				allParams.put("moduleName", "GIACS019");
				allParams.put("fundCd", request.getParameter("fundCd"));
				allParams.put("branchCd", request.getParameter("branchCd"));
				allParams.put("orFlag", request.getParameter("orFlag"));
				allParams.put("tranSource", request.getParameter("tranSource"));
				
				Debug.print("ADDED/DELETED: " + allParams);
				giacOutFaculPremPaytsService.saveOutFaculPremPayts(allParams);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showCurrencyInfo".equals(ACTION)) {
				request.setAttribute("currCd", request.getParameter("currCd"));
				request.setAttribute("currRt", request.getParameter("currRt"));
				request.setAttribute("currAmt", request.getParameter("currAmt"));
				request.setAttribute("currDesc", request.getParameter("currDesc"));
				
				PAGE = "/pages/accounting/officialReceipt/riTrans/pop-ups/currencyInfo.jsp";
			}else if ("printOutFaculPremPayts".equals(ACTION)){
				
				PAGE = "/pages/accounting/officialReceipt/riTrans/pop-ups/printOutFaculPremPayts.jsp";
			}else if ("overideUser".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/OverrideUser.jsp";
			}else if ("getDisbursementAmt".equals(ACTION)){
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYY", request.getParameter("binderYY"));
				params.put("binderId", request.getParameter("binderId"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo"));
				params.put("convertRate", request.getParameter("convertRate"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("allowDef", request.getParameter("alloDef"));
				params.put("gaccTranId", request.getParameter("gaccTranId")); // SR-19631 : shan 08.18.2015
				
				BigDecimal disbursementAmt = giacOutFaculPremPaytsService.getDisbursementAmt(params);
				System.out.println("DisbursementAmount: " + disbursementAmt);
				
				message = disbursementAmt.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getOverrideDisbursementAmt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("transactionType", Integer.parseInt(request.getParameter("tranType")));
				params.put("binderYY", Integer.parseInt(request.getParameter("binderYY")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				params.put("binderId", Integer.parseInt(request.getParameter("binderId")));
				params.put("disbursementAmt", null);
				params.put("message", "");
				Debug.print("OVERRIDE PARAMS: " + params);
				giacOutFaculPremPaytsService.getOverrideDisbursementAmt(params);
				Debug.print("AFTER OVERRIDE PARAMS: " + params);
				
				StringBuilder sb = new StringBuilder();
				sb.append("disbursementAmt=" + params.get("disbursementAmt"));
				sb.append("&message=" +  params.get("message"));
				message = sb.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getRevertDisbursementAmt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("binderId", Integer.parseInt(request.getParameter("binderId")));
				params.put("transactionType", Integer.parseInt(request.getParameter("tranType")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("riCd", Integer.parseInt(request.getParameter("riCd")));
				params.put("disbursementAmt", null);
				params.put("message", "");
				
				Debug.print("Before GET REVERT PARAMS: " + params);
				giacOutFaculPremPaytsService.getRevertDisbursementAmt(params);
				Debug.print("After GET REVERT PARAMS: " + params);
				
				StringBuilder sb = new StringBuilder();
				sb.append("disbursementAmt=" + params.get("disbursementAmt"));
				sb.append("&message=" +  params.get("message"));
				
				message = sb.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getOverrideDetails".equals(ACTION)){ //added by steven 5/29/2012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("moduleName", request.getParameter("moduleName"));
				params.put("tranType", Integer.parseInt(request.getParameter("tranType")));
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("riCd", Integer.parseInt(request.getParameter("riCd")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYY", Integer.parseInt(request.getParameter("binderYY")));
				params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
				params.put("overrideUser", request.getParameter("overrideUser")); // SR-19631 : shan 08.13.2015
				
				JSONObject overrideDetail = new JSONObject(giacOutFaculPremPaytsService.getOverrideDetails(params));
				message = overrideDetail.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateBinderNo2".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranType", request.getParameter("tranType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("lineCd", request.getParameter("lineCd")); 
				params.put("binderYY", request.getParameter("binderYY"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo"));
				params.put("overrideDef", request.getParameter("overrideDef"));
				params.put("userId", USER.getUserId());
				Map<String, Object> outFaculPremPayts = giacOutFaculPremPaytsService.validateBinderNo2(params);

				GIACModulesService giacModuleService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				Map<String, Object> userParams = new HashMap<String, Object>(); 
				userParams.put("user", USER.getUserId());
				userParams.put("moduleName", "GIACS019");
				userParams.put("funcCode", "OD");
				String userAccessFlag = giacModuleService.validateUserFunc3(userParams);
				
				outFaculPremPayts.put("userAccessFlag", userAccessFlag);
				StringFormatter.replaceQuotesInMap(outFaculPremPayts);
				
				message = new JSONObject(outFaculPremPayts).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch (NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
