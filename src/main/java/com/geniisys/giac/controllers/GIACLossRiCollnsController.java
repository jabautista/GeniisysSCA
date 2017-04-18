package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACLossRiCollnsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACLossRiCollnsController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACLossRiCollnsController.class);
	
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
			
			if ("showRiTransLossesRecovFromRi".equals(ACTION)){
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
				
				JSONArray giacLossRiCollnsJSON = new JSONArray(giacLossRiCollnsService.getGIACLossRiCollns(gaccTranId));
				String[] rvDomain = {"GIAC_LOSS_RECOVERIES.TRANSACTION_TYPE"};
				String[] rvDomain2 = {"GIIS_DIST_SHARE.SHARE_TYPE"};
				String[] shareType2 = {"2"};
				String[] shareType3 = {"3"};
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING, rvDomain));
				request.setAttribute("shareTypeList", helper.getList(LOVHelper.CG_REF_CODE_LISTING2, rvDomain2));
				request.setAttribute("reinsurer12List", helper.getList(LOVHelper.REINSURER_LISTING3, shareType2));
				request.setAttribute("reinsurer13List", helper.getList(LOVHelper.REINSURER_LISTING3, shareType3));
				request.setAttribute("reinsurer22List", helper.getList(LOVHelper.REINSURER_LISTING4, shareType2));
				request.setAttribute("reinsurer23List", helper.getList(LOVHelper.REINSURER_LISTING4, shareType3));
				
				request.setAttribute("giacLossRiCollnsJSON", giacLossRiCollnsJSON);
				
				PAGE = "/pages/accounting/officialReceipt/riTrans/lossesRecov.jsp";
			}else if ("showRiTransLossesRecovFromRiTableGrid".equals(ACTION)){ //added by: steven 3.26.2012
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACLossRiCollns2");
				params.put("gaccTranId", gaccTranId);
				
				String[] rvDomain = {"GIAC_LOSS_RECOVERIES.TRANSACTION_TYPE"};
				String[] rvDomain2 = {"GIIS_DIST_SHARE.SHARE_TYPE"};
				String[] shareType2 = {"2"};
				String[] shareType3 = {"3"};
				String[] shareType4 = {"4"}; //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING, rvDomain));
				request.setAttribute("shareTypeList", helper.getList(LOVHelper.CG_REF_CODE_LISTING2, rvDomain2));
				request.setAttribute("reinsurer12List", helper.getList(LOVHelper.REINSURER_LISTING3, shareType2));
				request.setAttribute("reinsurer13List", helper.getList(LOVHelper.REINSURER_LISTING3, shareType3));
				request.setAttribute("reinsurer22List", helper.getList(LOVHelper.REINSURER_LISTING4, shareType2));
				request.setAttribute("reinsurer23List", helper.getList(LOVHelper.REINSURER_LISTING4, shareType3));
				request.setAttribute("reinsurer14List", helper.getList(LOVHelper.REINSURER_LISTING3, shareType4)); //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
				request.setAttribute("reinsurer24List", helper.getList(LOVHelper.REINSURER_LISTING4, shareType4)); //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
				
				Map<String, Object> giacLossRecov = TableGridUtil.getTableGrid(request, params);
				JSONObject objgiacLossRecov = new JSONObject(giacLossRecov);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("objgiacLossRecov", objgiacLossRecov);
					PAGE = "/pages/accounting/officialReceipt/riTrans/lossesRecovTableGrid.jsp";
				}else{
					message = objgiacLossRecov.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			}else if ("openSearchLossAdvice".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchLossAdvice.jsp";
			}else if ("searchLossAdviceModal".equals(ACTION)){
				log.info("Getting Loss Advice Listing records.");
				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("transactionType",request.getParameter("transactionType"));
				params.put("shareType",  	 request.getParameter("shareType"));
				params.put("a180RiCd", 		 request.getParameter("a180RiCd"));
				params.put("e150LineCd", 	 request.getParameter("e150LineCd"));
				params.put("e150LaYy", 		 request.getParameter("e150LaYy"));
				params.put("e150FlaSeqNo", 	 request.getParameter("e150FlaSeqNo"));
				params.put("userId", 	     USER.getAppUser());  //added by robert 03.18.2013
				log.info("Parameters: "+params);
				
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				params.put("currentPage", page);
				params.put("filter", request.getParameter("objFilter"));
				params = giacLossRiCollnsService.getLossAdviceListTableGrid(params);
				request.setAttribute("lossAdviceTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchLossAdviceAjaxResult.jsp";
			}else if ("validateFLA".equals(ACTION)){
				log.info("Validate FLA.");
				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("transactionType",request.getParameter("transactionType"));
				params.put("shareType",  	 request.getParameter("shareType"));
				params.put("a180RiCd", 		 request.getParameter("a180RiCd"));
				params.put("e150LineCd", 	 request.getParameter("e150LineCd"));
				params.put("e150LaYy", 		 request.getParameter("e150LaYy"));
				params.put("e150FlaSeqNo", 	 request.getParameter("e150FlaSeqNo"));
				params.put("userId", 	 	 USER.getAppUser()); //added by robert 03.182013
				
				//shan 07.24.2013; SR-13688 changed from JSONObject to JSONArray to handle FLA with different payee types
				JSONArray fla = new JSONArray(giacLossRiCollnsService.validateFLA(params));  
				message = fla.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateCurrencyCode".equals(ACTION)){
				log.info("Validate currency code.");
				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("collectionAmt", new BigDecimal(request.getParameter("collectionAmt")));
				params.put("currencyCd", Integer.parseInt(request.getParameter("currencyCd")));
				params = giacLossRiCollnsService.validateCurrencyCode(params);
				JSONObject currJSON = new JSONObject(params);
				message = currJSON.toString(); 
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveLossesRecov".equals(ACTION)){
				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giacLossRiCollnsService.prepareParametersGIACLossRiCollns(request, USER, gaccTranId, gaccBranchCd, gaccFundCd);
				message = giacLossRiCollnsService.saveLossesRecov(params);
				PAGE = "/pages/genericMessage.jsp";
//			}else if ("saveLossesRecovTableGrid".equals(ACTION)){//added by steven 4.16.2012
//				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
//				JSONObject objParams = new JSONObject(request.getParameter("param"));
//				giacLossRiCollnsService.saveGIACLossRiCollns(objParams,USER);
//				message = "SUCCESS";
//				PAGE = "/pages/genericMessage.jsp";
			}else if ("refreshLossAdviceListing".equals(ACTION)){
				log.info("Refreshing Loss Advice Listing records.");
				GIACLossRiCollnsService giacLossRiCollnsService = (GIACLossRiCollnsService) APPLICATION_CONTEXT.getBean("giacLossRiCollnsService");
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("transactionType",request.getParameter("transactionType"));
				params.put("shareType",  	 request.getParameter("shareType"));
				params.put("a180RiCd", 		 request.getParameter("a180RiCd"));
				params.put("e150LineCd", 	 request.getParameter("e150LineCd"));
				params.put("e150LaYy", 		 request.getParameter("e150LaYy"));
				params.put("e150FlaSeqNo", 	 request.getParameter("e150FlaSeqNo"));
				log.info("Parameters: "+params);
				
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				params.put("currentPage", page);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				params = giacLossRiCollnsService.getLossAdviceListTableGrid(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
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
