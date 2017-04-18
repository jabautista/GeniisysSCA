package com.geniisys.lov.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;

public class MarketingLOVController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -550839047683746398L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		// common parameters
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("currentPage", Integer.parseInt(request.getParameter("page")));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("findText", request.getParameter("findText"));
		params.put("ACTION", ACTION);
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
			System.out.println("::::::::::::::::::::::::::"+request.getParameter("notIn")+" ::::::::::::::::::");
		}
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		
		try {		
			// IMPORTANT: use the specified action for controller as the id for sqlMap select/procedure			
			// NOTE: format for lov action is : "get<Entity Name>LOV"
			
			if ("getGIISTaxChargesLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("quoteId", (request.getParameter("quoteId").equals("") ? null : Integer.parseInt(request.getParameter("quoteId"))));
				params.put("notIn", (request.getParameter("notIn").equals("") ? null : request.getParameter("notIn")));
			} else if("getUnderwriterForReassignQuoteLOV".equals(ACTION)) { //marco - for reassign Quotation lov
				params.put("keyword", request.getParameter("findText"));
				params.put("lineCd", request.getParameter("lineCd"));	// shan 08.13.2014
				params.put("issCd", request.getParameter("issCd"));	// shan 08.13.2014
				params.put("notIn", request.getParameter("notIn"));	// shan 08.20.2014
			} else if("getGIISVesselLOV".equals(ACTION)){ //added by steven 3.20.2012
				params.put("lineCd", request.getParameter("lineCd"));
			} else if("getQuoteInpsList".equals(ACTION)){
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("quoteId", request.getParameter("quoteId"));
			} else if("getQuoteInspList".equals(ACTION)){
				params.put("assdNo", request.getParameter("assdNo"));
			} else if("getCapacityLOV".equals(ACTION)){ //added by robert 5.14.2012
			} else if("getAviationLOV".equals(ACTION)){ //added by robert 5.16.2012
			} else if("getSectionOrHazardLOV".equals(ACTION)){//added by robert 5.17.2012
				params.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 09.07.2016 SR 5644
				params.put("sublineCd", request.getParameter("sublineCd")); //Added by Jerome 09.07.2016 SR 5644
			} else if("getMarineHullLOV".equals(ACTION)){ //added by robert 5.17.2012
			} else if("getTaxChargesLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("quoteId", Integer.parseInt(request.getParameter("quoteId")));
				params.put("premAmt", Float.parseFloat(request.getParameter("premAmt")));
				params.put("rate", request.getParameter("rate"));
//				params.put("taxCdList", request.getParameter("taxCdList"));
//				params.put("taxCdCount", Integer.parseInt(request.getParameter("taxCdCount")));
//				params.put("keyword", request.getParameter("findText"));
			} else if("getGIIMM002IntmLOV".equals(ACTION)){
				//no specific parameters for this LOV
			} else if("getPerilNameLOV".equals(ACTION)){
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("packLineCd", request.getParameter("packLineCd").equals("") ? null : request.getParameter("packLineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("packSublineCd", request.getParameter("packSublineCd").equals("") ? null : request.getParameter("packSublineCd"));
				params.put("perilType", request.getParameter("perilType").equals("") ? null : request.getParameter("perilType"));
				params.put("notIn", request.getParameter("notIn"));
				params.put("keyword", request.getParameter("findText"));
			} else if("getCgRefCodeLOV2".equals(ACTION)){
				params.put("domain", request.getParameter("domain"));
			} else if("getCgRefCodeLOV3".equals(ACTION)){ //order by rv_low_value christian 03/13/13
				params.put("domain", request.getParameter("domain"));
			} else if("getTariffCodeLOV".equals(ACTION)){
			} else if("getTariffZoneLOV".equals(ACTION)){
			} else if("getFireConstructionLOV".equals(ACTION)){
			} else if("getFireItemTypeLOV".equals(ACTION)){
			} else if("getGeogDescLOV".equals(ACTION)){
				params.put("quoteId", request.getParameter("quoteId"));
			} else if("getVesselDescLOV".equals(ACTION)){
				params.put("quoteId", request.getParameter("quoteId"));
			} else if("getBodyTypeLOV".equals(ACTION)){
			} else if("getCarCompanyLOV".equals(ACTION)){
			} else if("getSublineTypeLOV".equals(ACTION)){
				params.put("sublineCd", request.getParameter("sublineCd"));
			} else if("getMakeLOV2".equals(ACTION)){
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
			} else if("getEngineSeriesLOV2".equals(ACTION)){
				params.put("carCompanyCd", request.getParameter("carCompanyCd"));
				params.put("makeCd", request.getParameter("makeCd"));
			} else if("getMortgageeLOV2".equals(ACTION)){		
				params.put("issCd", request.getParameter("issCd"));
			} else if("getUserGrpLOV".equals(ACTION)){
				//no specific parameters for this LOV
			} else if("getPackQuoteLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("quotationYy", request.getParameter("quotationYy"));
				params.put("quotationNo", request.getParameter("quotationNo"));
				params.put("proposalNo", request.getParameter("proposalNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("userId", USER.getUserId());
			} else if ("getAcctOfList2".equals(ACTION)) {
				params.put("assdNo", (request.getParameter("assdNo").equals("") ? null : Integer.parseInt(request.getParameter("assdNo"))));
				params.put("inAccountOf", request.getParameter("inAccountOf"));
				params.put("search", request.getParameter("search"));
			} else if ("getBankRefNoListingForPackTG".equals(ACTION)) {
				params.put("nbtAcctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				params.put("nbtBranchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
				params.put("keyword", request.getParameter("keyword"));
			} else if ("getGIISAssuredLOVTG".equals(ACTION)) { //added by MarkS 10.12.2016 SR5759 for optimization of in account of LOV
				// No specific parameter for this lov
			}
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(params);
			message = json.toString();
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
