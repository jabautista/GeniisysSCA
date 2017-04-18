package com.geniisys.giac.controllers;

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
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giac.entity.GIACInwClaimPayts;
import com.geniisys.giac.service.GIACInwClaimPaytsService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACInwClaimPaytsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACInwClaimPaytsController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		PAGE = "/pages/genericMessage.jsp";
		
		Integer gaccTranId = (request.getParameter("gaccTranId") == null || request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null")) ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
		
		// temporary value
		//gaccTranId = 36158;
		
		log.info("Gacc Tran Id: " + gaccTranId);
		
		try {
			if ("showFacultativeClaimPayts".equals(ACTION)) {
				// Services and other variables
				GIACInwClaimPaytsService inwClaimPaytsService = (GIACInwClaimPaytsService) APPLICATION_CONTEXT.getBean("giacInwClaimPaytsService");
				GIACParameterFacadeService paramService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] tranTypeArgs = {"GIAC_INW_CLAIM_PAYTS.TRANSACTION_TYPE"}; 
				
				// objects
				List<GIACInwClaimPayts> inwClaimPaytsList = (List<GIACInwClaimPayts>) StringFormatter.escapeHTMLInList(inwClaimPaytsService.getGIACInwClaimPayts(gaccTranId));
				Integer controlCurrCdParam = paramService.getParamValueN("CURRENCY_CD");
				String controlVIssCd = paramService.getParamValueV2("RI_ISS_CD");
				
				String[] issCdArgs1 = {"1", controlVIssCd, "GIACS018", USER.getUserId()};
				String[] issCdArgs2 = {"2", controlVIssCd, "GIACS018", USER.getUserId()};
				
				log.info("Inw Claim Payts List size: " + inwClaimPaytsList == null ? 0 : inwClaimPaytsList.size());
				
				// set page objects
				request.setAttribute("inwClaimPaytsList" , new JSONArray(inwClaimPaytsList));
				request.setAttribute("transactionTypeList", lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, tranTypeArgs));
				request.setAttribute("currencyList", new JSONArray(lovHelper.getList(LOVHelper.CURRENCY_CODES)));
				request.setAttribute("lineListing1", new JSONArray(lovHelper.getList(LOVHelper.ADVICE_LINE_LISTING)));
				request.setAttribute("lineListing2", new JSONArray(lovHelper.getList(LOVHelper.FACUL_CLAIM_PAYTS_LINE_LISTING2)));
				request.setAttribute("issCdListing1", new JSONArray(lovHelper.getList(LOVHelper.ADVICE_ISS_CD_LISTING_PER_MODULE, issCdArgs1)));
				request.setAttribute("issCdListing2", new JSONArray(lovHelper.getList(LOVHelper.ADVICE_ISS_CD_LISTING_PER_MODULE, issCdArgs2)));
				request.setAttribute("controlCurrCdParam", controlCurrCdParam);
				request.setAttribute("controlVIssCd", controlVIssCd);
				
				PAGE = "/pages/accounting/officialReceipt/riTrans/riTransFacultativeClaimPayts.jsp";
			} else if ("getAdviceYearByIssCdListing".equals(ACTION)) {
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = {request.getParameter("tranType"), request.getParameter("lineCd"), request.getParameter("issCd"), request.getParameter("moduleName"), USER.getUserId()};
				
				request.setAttribute("listValues", lovHelper.getList(LOVHelper.FACUL_CLAIM_PAYTS_ADVICE_YEAR_LISTING, args));
				request.setAttribute("width", (request.getParameter("width") == null) ? "10" : request.getParameter("width"));
				request.setAttribute("tabIndex", (request.getParameter("tabIndex") == null) ? "1" : request.getParameter("tabIndex"));
				request.setAttribute("listId", (request.getParameter("listId") == null) ? "intermediary" : request.getParameter("listId"));
				request.setAttribute("listName", (request.getParameter("listName") == null) ? "intermediary" : request.getParameter("listName"));
				request.setAttribute("className", (request.getParameter("className") == null) ? new String("") : request.getParameter("className"));
				
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/basicDropDownList.jsp";
			} else if ("getAdviceSeqNoListing".equals(ACTION)) {
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String notIn = request.getParameter("notIn").equals("--") ? null : request.getParameter("notIn");	// shan 09.17.2014
				String[] args = {request.getParameter("tranType"), request.getParameter("lineCd"), request.getParameter("issCd"), request.getParameter("adviceYear"), request.getParameter("moduleName"), USER.getUserId(), notIn};
				
				request.setAttribute("listValues", lovHelper.getList(LOVHelper.FACUL_CLAIM_PAYTS_ADVICE_SEQ_NO_LISTING, args));
				request.setAttribute("width", (request.getParameter("width") == null) ? "10" : request.getParameter("width"));
				request.setAttribute("tabIndex", (request.getParameter("tabIndex") == null) ? "1" : request.getParameter("tabIndex"));
				request.setAttribute("listId", (request.getParameter("listId") == null) ? "intermediary" : request.getParameter("listId"));
				request.setAttribute("listName", (request.getParameter("listName") == null) ? "intermediary" : request.getParameter("listName"));
				request.setAttribute("className", (request.getParameter("className") == null) ? new String("") : request.getParameter("className"));
				
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/adviceSeqNoListing.jsp";
			} else if ("getClaimPolicyAndAssured".equals(ACTION)) {
				GIACInwClaimPaytsService inwClaimPaytsService = (GIACInwClaimPaytsService) APPLICATION_CONTEXT.getBean("giacInwClaimPaytsService");
				Integer claimId = request.getParameter("claimId") == null ? 0 : Integer.parseInt(request.getParameter("claimId"));
				
				message = new JSONObject(StringFormatter.escapeHTMLInMap(inwClaimPaytsService.getClaimPolicyAndAssured(claimId))).toString();
			} else if ("getClmLossIdListing".equals(ACTION)) {
				GIACInwClaimPaytsService inwClaimPaytsService = (GIACInwClaimPaytsService) APPLICATION_CONTEXT.getBean("giacInwClaimPaytsService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("tranType", request.getParameter("tranType"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("claimId", request.getParameter("claimId"));
				params.put("adviceId", request.getParameter("adviceId"));
				
				request.setAttribute("listValues", inwClaimPaytsService.getClmLossIdListing(params));
				request.setAttribute("width", (request.getParameter("width") == null) ? "10" : request.getParameter("width"));
				request.setAttribute("tabIndex", (request.getParameter("tabIndex") == null) ? "1" : request.getParameter("tabIndex"));
				request.setAttribute("listId", (request.getParameter("listId") == null) ? "intermediary" : request.getParameter("listId"));
				request.setAttribute("listName", (request.getParameter("listName") == null) ? "intermediary" : request.getParameter("listName"));
				request.setAttribute("className", (request.getParameter("className") == null) ? new String("") : request.getParameter("className"));
				
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/clmLossIdListing.jsp";
			} else if ("validatePayee".equals(ACTION)) {
				GIACInwClaimPaytsService inwClaimPaytsService = (GIACInwClaimPaytsService) APPLICATION_CONTEXT.getBean("giacInwClaimPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				inwClaimPaytsService.validatePayee(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("executeGiacs018PreInsertTrigger".equals(ACTION)) {
				GIACInwClaimPaytsService inwClaimPaytsService = (GIACInwClaimPaytsService) APPLICATION_CONTEXT.getBean("giacInwClaimPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				inwClaimPaytsService.executeGiacs018PreInsertTrigger(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
			} else if ("saveFaculClaimPayts".equals(ACTION)) {
				GIACInwClaimPaytsService inwClaimPaytsService = (GIACInwClaimPaytsService) APPLICATION_CONTEXT.getBean("giacInwClaimPaytsService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("gaccBranchCd", request.getParameter("gaccBranchCd"));
				params.put("gaccFundCd", request.getParameter("gaccFundCd"));
				params.put("tranSource", request.getParameter("tranSource"));
				params.put("orFlag", request.getParameter("orFlag"));
				params.put("varModuleName", request.getParameter("varModuleName"));
				params.put("varGenType", request.getParameter("varGenType"));
				params.put("userId", USER.getUserId());
				
				message = QueryParamGenerator.generateQueryParams(inwClaimPaytsService.saveGIACInwClaimPayts(setRows, delRows, params));
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
