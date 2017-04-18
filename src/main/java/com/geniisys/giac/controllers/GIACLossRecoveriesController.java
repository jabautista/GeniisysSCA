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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.service.GIACLossRecoveriesService;
import com.geniisys.gicl.entity.GICLRecoveryPayor;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIACLossRecoveriesController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACLossRecoveriesController.class);
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing..."+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			String strGaccTranId = request.getParameter("globalGaccTranId") == null ? "0" : request.getParameter("globalGaccTranId");
			Integer gaccTranId= strGaccTranId.trim().equals("") ? 0 : Integer.parseInt(strGaccTranId);
			String gaccBranchCd = request.getParameter("globalGaccBranchCd") == null ? "" :request.getParameter("globalGaccBranchCd");
			String gaccFundCd = request.getParameter("globalGaccFundCd") == null ? "" :request.getParameter("globalGaccFundCd");

			log.info("Tran ID   : " + gaccTranId);
			log.info("Branch Cd : " + gaccBranchCd);
			log.info("Fund Cd   : " + gaccFundCd);
			log.info("USER ID   : " + USER.getUserId());
			
			if ("showDirectTransLossRecoveries".equals(ACTION)){
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				
				JSONArray giacLossRecoveriesJSON = new JSONArray(giacLossRecoveriesService.getGIACLossRecoveries(gaccTranId));
				String[] rvDomain = {"GIAC_LOSS_RECOVERIES.TRANSACTION_TYPE"};
				
				request.setAttribute("tranFlag", giacLossRecoveriesService.getTranFlag(gaccTranId));
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING, rvDomain));
				request.setAttribute("payeeListJSON", new JSONArray((List<GICLRecoveryPayor>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.RECOVERY_PAYOR_LISTING))));
				request.setAttribute("giacLossRecoveriesJSON", giacLossRecoveriesJSON);
		
				PAGE = "/pages/accounting/officialReceipt/directTrans/lossRecoveries.jsp";
			}else if ("openSearchRecoveryNoLossRec".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchRecoveryNo.jsp";
			}else if ("searchRecoveryNoModal".equals(ACTION)){
				log.info("Getting Recovery No. Listing records.");
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("keyword", keyword);
				params.put("userId", USER.getUserId()); //added by steven 1/26/2013 for user access.
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("recYear", request.getParameter("recYear"));
				params.put("recSeqNo", request.getParameter("recSeqNo"));
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giacLossRecoveriesService.getRecoveryNoList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				JSONArray searchResultJSON = new JSONArray(searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchRecoveryNoAjaxResult.jsp";
			}else if ("getSumCollnAmt".equals(ACTION)){
				log.info("Getting sum collection amount.");
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("collectionAmt", new BigDecimal(request.getParameter("collectionAmt")));
				params.put("recoveryId", Integer.parseInt(request.getParameter("recoveryId")));
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("payorClassCd", request.getParameter("payorClassCd"));
				params.put("payorCd", Integer.parseInt(request.getParameter("payorCd")));
				params = (HashMap<String, Object>) giacLossRecoveriesService.getSumCollnAmtLossRec(params);
				message = (String) params.get("sumCollnAmt");
				if (params.get("vMsgAlert") != null){
					message = (String) params.get("vMsgAlert");
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getCurrency".equals(ACTION)){
				log.info("Getting currency info.");
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("collectionAmt", new BigDecimal(request.getParameter("collectionAmt")));
				params.put("recoveryId", Integer.parseInt(request.getParameter("recoveryId")));
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("dspLossDate", request.getParameter("dspLossDate"));
				params = giacLossRecoveriesService.getCurrency(params);
				JSONObject currJSON = new JSONObject(params);
				message = currJSON.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateCurrencyCode".equals(ACTION)){
				log.info("Validate currency code.");
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("collectionAmt", new BigDecimal(request.getParameter("collectionAmt")));
				params.put("currencyCd", Integer.parseInt(request.getParameter("currencyCd")));
				params.put("dspLossDate", request.getParameter("dspLossDate"));
				params = giacLossRecoveriesService.validateCurrencyCode(params);
				JSONObject currJSON = new JSONObject(params);
				message = currJSON.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateDelete".equals(ACTION)){
				log.info("Validate currency code.");
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				message = giacLossRecoveriesService.validateDeleteLossRec(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveLossRec".equals(ACTION)){
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("gaccBranchCd", gaccBranchCd);
				params.put("gaccFundCd", gaccFundCd);
				params.put("userId", USER.getUserId());
				params.put("setRows", giacLossRecoveriesService.prepareGIACLossRecoveriesJSON(new JSONArray(request.getParameter("setRows")), USER.getUserId()));
				params.put("delRows", giacLossRecoveriesService.prepareGIACLossRecoveriesJSON(new JSONArray(request.getParameter("delRows")), USER.getUserId()));
				
				message = giacLossRecoveriesService.saveLossRec(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getManualRecoveryList".equals(ACTION)){
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("recYear", request.getParameter("recYear"));
				params.put("recSeqNo", request.getParameter("recSeqNo"));
				params.put("payorCd", request.getParameter("payorCd"));
				params.put("payorClassCd", request.getParameter("payorClassCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				Debug.print("Parameters: "+params);
				
				List<String> resultParams = (List<String>) giacLossRecoveriesService.getManualRecoveryList(params);
				Debug.print("Result: "+resultParams);
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPayorNameExist".equals(ACTION)){
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("recYear", request.getParameter("recYear"));
				params.put("recSeqNo", request.getParameter("recSeqNo"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("userId", USER.getUserId());
				Debug.print("Result: "+params);
				
				List<String> resultParams = giacLossRecoveriesService.checkPayorNameExist(params);
				Debug.print("Result: "+resultParams);
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkCollectionAmt".equals(ACTION)){
				GIACLossRecoveriesService giacLossRecoveriesService = (GIACLossRecoveriesService) APPLICATION_CONTEXT.getBean("giacLossRecoveriesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				message = giacLossRecoveriesService.checkCollectionAmt(params);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (SQLException e) {
			/*message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";*/
			if(e.getErrorCode() > 20000){ //marco - 04.20.2013 - for raise_application_error message
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = "Null Pointer Exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
