/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.util;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;


/**
 * The Class GIPIPARUtil.
 */
public class GIPIPARUtil {

	/**
	 * Gets the pAR info.
	 * 
	 * @param request the request
	 * @return the pAR info
	 */
	public static Map<String, Object> getPARInfo(final HttpServletRequest request) {
	
		Map<String, Object> parInfo = new HashMap<String, Object>();
		parInfo.put("parId", request.getParameter("globalParId"));
		parInfo.put("assignSw", request.getParameter("globalAssignSw"));
		parInfo.put("parStatus", request.getParameter("globalParStatus"));
		parInfo.put("parSeqNo", request.getParameter("globalParSeqNo"));
		parInfo.put("assdNo", request.getParameter("globalAssdNo"));
		parInfo.put("assdName", request.getParameter("globalAssdName"));
		parInfo.put("parYy", request.getParameter("globalParYy"));
		parInfo.put("parType", request.getParameter("globalParType"));
		parInfo.put("remarks", request.getParameter("globalRemarks"));
		parInfo.put("underwriter", request.getParameter("globalUnderwriter"));
		parInfo.put("quoteId", request.getParameter("globalQuoteId"));
		parInfo.put("parNo", request.getParameter("globalParNo"));
		parInfo.put("packParId", request.getParameter("globalPackParId"));
		parInfo.put("packParNo", request.getParameter("globalPackParNo"));
		parInfo.put("lineCd", request.getParameter("globalLineCd"));
		parInfo.put("sublineCd", request.getParameter("globalSublineCd"));
		parInfo.put("issCd", request.getParameter("globalIssCd"));
		parInfo.put("quoteSeqNo", request.getParameter("globalQuoteSeqNo"));
		parInfo.put("sublineName", request.getParameter("globalSublineName"));
		parInfo.put("packPolFlag", request.getParameter("globalPackPolFlag"));
		parInfo.put("renewNo", request.getParameter("globalRenewNo"));
		parInfo.put("parSeqNoC", request.getParameter("globalParSeqNoC"));
		parInfo.put("address1", request.getParameter("globalAddress1"));
		parInfo.put("address2", request.getParameter("globalAddress2"));
		parInfo.put("address3", request.getParameter("globalAddress3"));
		return parInfo;

	}
	
	/**
	 * Sets the par info.
	 * 
	 * @param request the request
	 * @param parInfo the par info
	 * @return the http servlet request
	 */
	public static HttpServletRequest setPARInfo(final HttpServletRequest request, final Map<String, Object> parInfo) {
	
		HttpServletRequest req = request;
		req.setAttribute("parId", (String) parInfo.get("parId"));
		req.setAttribute("assignSw", (String) parInfo.get("assignSw"));
		req.setAttribute("parStatus", (String) parInfo.get("parStatus"));
		req.setAttribute("parSeqNo", (String) parInfo.get("parSeqNo"));
		req.setAttribute("assdNo", (String) parInfo.get("assdNo"));
		req.setAttribute("assdName", (String) parInfo.get("assdName"));
		req.setAttribute("parYy", (String) parInfo.get("parYy"));
		req.setAttribute("parType", (String) parInfo.get("parType"));
		req.setAttribute("remarks", (String) parInfo.get("remarks"));
		req.setAttribute("underwriter", (String) parInfo.get("underwriter"));
		req.setAttribute("quoteId", (String) parInfo.get("quoteId"));
		req.setAttribute("parNo", (String) parInfo.get("parNo"));
		req.setAttribute("packParId", (String) parInfo.get("packParId"));
		req.setAttribute("packParNo", (String) parInfo.get("packParNo"));
		req.setAttribute("lineCd", (String) parInfo.get("lineCd"));
		req.setAttribute("sublineCd", (String) parInfo.get("sublineCd"));
		req.setAttribute("issCd", (String) parInfo.get("issCd"));
		req.setAttribute("quoteSeqNo", (String) parInfo.get("quoteSeqNo"));
		req.setAttribute("sublineName", (String) parInfo.get("sublineName"));
		req.setAttribute("packPolFlag", (String) parInfo.get("packPolFlag"));
		req.setAttribute("renewNo", (String) parInfo.get("renewNo"));
		req.setAttribute("parSeqNoC", (String) parInfo.get("parSeqNoC"));
		req.setAttribute("address1", (String) parInfo.get("address1"));
		req.setAttribute("address2", (String) parInfo.get("address2"));
		req.setAttribute("address3", (String) parInfo.get("address3"));
		return req;
		
	}
	
	/**
	 * Sets the par info from saved par.
	 * 
	 * @param request the request
	 * @param par the par
	 * @return the http servlet request
	 */
	public static HttpServletRequest setPARInfoFromSavedPAR(final HttpServletRequest request, final GIPIPARList par) {
	
		HttpServletRequest req = request;
		req.setAttribute("parId", par.getParId());
		req.setAttribute("assignSw", par.getAssignSw());
		req.setAttribute("parStatus", par.getParStatus());
		req.setAttribute("parSeqNo", par.getParSeqNo());
		req.setAttribute("assdNo", par.getAssdNo());
		req.setAttribute("assdName", par.getAssdName());
		req.setAttribute("parYy", par.getParYy());
		req.setAttribute("parType", par.getParType());
		req.setAttribute("remarks", par.getRemarks());
		req.setAttribute("underwriter", par.getUnderwriter());
		req.setAttribute("quoteId", par.getQuoteId());
		req.setAttribute("parNo", par.getParNo());
		req.setAttribute("packParId", par.getPackParId());
		req.setAttribute("packParNo", par.getPackParNo());
		req.setAttribute("lineCd", par.getLineCd());
		req.setAttribute("lineName", par.getLineName());
		req.setAttribute("issCd", par.getIssCd());
		req.setAttribute("quoteSeqNo", par.getQuoteSeqNo());
		req.setAttribute("sublineCd", par.getSublineCd());
		req.setAttribute("opFlag", par.getOpFlag());
		req.setAttribute("sublineName", par.getSublineName());
		req.setAttribute("packPolFlag", par.getPackPolFlag());
		req.setAttribute("renewNo", par.getRenewNo());
		req.setAttribute("parSeqNoC", par.getParSeqNoC());
		req.setAttribute("polFlag", par.getPolFlag());
		req.setAttribute("issueYy", par.getIssueYy());
		req.setAttribute("polSeqNo", par.getPolSeqNo());
		req.setAttribute("endtPolicyId", par.getEndtPolicyId());
		req.setAttribute("endtPolicyNo", par.getEndtPolicyNo());
		req.setAttribute("inceptDate", par.getInceptDate());
		req.setAttribute("expiryDate", par.getExpiryDate());
		req.setAttribute("effDate", par.getEffDate());
		req.setAttribute("endtExpiryDate", par.getEndtExpiryDate());
		req.setAttribute("shorRtPercent", par.getShortRtPercent());
		req.setAttribute("compSw", par.getCompSw());
		req.setAttribute("provPremPct", par.getProvPremPct());
		req.setAttribute("provPremTag", par.getProvPremTag());
		req.setAttribute("prorateFlag", par.getProrateFlag());
		req.setAttribute("withTariffSw", par.getWithTariffSw());
		req.setAttribute("ctplCd", par.getCtplCd());
		req.setAttribute("lineMotor", par.getLineMotor());
		req.setAttribute("lineFire", par.getLineFire());
		req.setAttribute("backEndt", par.getBackEndt());
		req.setAttribute("address1", par.getAddress1());
		req.setAttribute("address2", par.getAddress2());
		req.setAttribute("address3", par.getAddress3());
		req.setAttribute("endtTax", par.getEndtTax());
		req.setAttribute("gipiInvoiceExist", par.getGipiWInvoiceExist());
		return req;
	}
	
	/**
	 * Sets the pack par info from saved pack par.
	 * 
	 * @param request the request
	 * @param par the par
	 * @return the http servlet request
	 */
	public static HttpServletRequest setPackPARInfoFromSavedPAR(final HttpServletRequest request, final GIPIPackPARList par) {
		/**
		 * Temporarily commented out non-existing attributes on GIPIPackPARList
		 * emman 11.24.2010
		 */
		HttpServletRequest req = request;
		req.setAttribute("parId", par.getParId());
		req.setAttribute("assignSw", par.getAssignSw());
		req.setAttribute("parStatus", par.getParStatus());
		req.setAttribute("parSeqNo", par.getParSeqNo());
		req.setAttribute("assdNo", par.getAssdNo());
		req.setAttribute("assdName", par.getAssdName());
		req.setAttribute("parYy", par.getParYy());
		req.setAttribute("parType", par.getParType());
		req.setAttribute("remarks", par.getRemarks());
		req.setAttribute("underwriter", par.getUnderwriter());
		req.setAttribute("quoteId", par.getQuoteId());
		req.setAttribute("parNo", par.getParNo());
		req.setAttribute("packParId", par.getPackParId());
		//req.setAttribute("packParNo", par.getPackParNo());
		req.setAttribute("lineCd", par.getLineCd());
		//req.setAttribute("lineName", par.getLineName());
		req.setAttribute("issCd", par.getIssCd());
		req.setAttribute("quoteSeqNo", par.getQuoteSeqNo());
		req.setAttribute("sublineCd", par.getSublineCd());
		/*req.setAttribute("opFlag", par.getOpFlag());
		req.setAttribute("sublineName", par.getSublineName());
		req.setAttribute("packPolFlag", par.getPackPolFlag());
		req.setAttribute("renewNo", par.getRenewNo());
		req.setAttribute("parSeqNoC", par.getParSeqNoC());
		req.setAttribute("polFlag", par.getPolFlag());
		req.setAttribute("issueYy", par.getIssueYy());
		req.setAttribute("polSeqNo", par.getPolSeqNo());
		req.setAttribute("endtPolicyId", par.getEndtPolicyId());
		req.setAttribute("endtPolicyNo", par.getEndtPolicyNo());
		req.setAttribute("inceptDate", par.getInceptDate());
		req.setAttribute("expiryDate", par.getExpiryDate());
		req.setAttribute("effDate", par.getEffDate());
		req.setAttribute("endtExpiryDate", par.getEndtExpiryDate());
		req.setAttribute("shorRtPercent", par.getShortRtPercent());
		req.setAttribute("compSw", par.getCompSw());
		req.setAttribute("provPremPct", par.getProvPremPct());
		req.setAttribute("provPremTag", par.getProvPremTag());
		req.setAttribute("prorateFlag", par.getProrateFlag());
		req.setAttribute("withTariffSw", par.getWithTariffSw());
		req.setAttribute("ctplCd", par.getCtplCd());
		req.setAttribute("lineMotor", par.getLineMotor());
		req.setAttribute("lineFire", par.getLineFire());
		req.setAttribute("backEndt", par.getBackEndt());*/
		req.setAttribute("address1", par.getAddress1());
		req.setAttribute("address2", par.getAddress2());
		req.setAttribute("address3", par.getAddress3());
		//req.setAttribute("endtTax", par.getEndtTax());
		return req;
	}
	
	public static GIPIPARList prepareGIPIParList(final HttpServletRequest request){
		GIPIPARList par = new GIPIPARList();
		
		int parId = Integer.parseInt(request.getParameter("globalParId"));
		int parStatus = Integer.parseInt(request.getParameter("globalParStatus")); 
		int parSeqNo = Integer.parseInt(request.getParameter("globalParSeqNo"));
		int assdNo = Integer.parseInt(request.getParameter("globalAssdNo"));
		int parYy = Integer.parseInt(request.getParameter("globalParYy"));
		int quoteId = Integer.parseInt(request.getParameter("globalQuoteId") != null ? 
				(!(request.getParameter("globalQuoteId").isEmpty()) ? request.getParameter("globalQuoteId") : "0") : "0");
		int packParId = Integer.parseInt(request.getParameter("globalPackParId"));
		int quoteSeqNo = Integer.parseInt(request.getParameter("globalQuoteSeqNo") != null ? 
				(!(request.getParameter("globalQuoteSeqNo").isEmpty()) ? request.getParameter("globalQuoteSeqNo") : "0") : "0");
		int renewNo = Integer.parseInt(request.getParameter("globalRenewNo") != null ? request.getParameter("globalRenewNo") : "0");
			
		par.setParId(parId);
		par.setAssignSw(request.getParameter("globalAssignSw"));
		par.setParStatus(parStatus);
		par.setParSeqNo(parSeqNo);
		par.setAssdNo(assdNo);
		par.setAssdName(request.getParameter("globalAssdName"));
		par.setParYy(parYy);
		par.setParType(request.getParameter("globalParType"));
		par.setRemarks(request.getParameter("globalRemarks"));
		par.setUnderwriter(request.getParameter("globalUnderwriter"));
		par.setQuoteId(quoteId);
		par.setParNo(request.getParameter("globalParNo"));
		par.setPackParId(packParId);
		par.setPackParNo(request.getParameter("globalPackParNo"));
		par.setLineCd(request.getParameter("globalLineCd"));
		par.setSublineCd(request.getParameter("globalSublineCd"));
		par.setIssCd(request.getParameter("globalIssCd"));
		par.setQuoteSeqNo(quoteSeqNo);
		par.setSublineName(request.getParameter("globalSublineName"));
		par.setPackPolFlag(request.getParameter("globalPackPolFlag"));
		par.setRenewNo(renewNo);
		par.setParSeqNoC(request.getParameter("globalParSeqNoC"));
		par.setAddress1(request.getParameter("globalAddress1"));
		par.setAddress2(request.getParameter("globalAddress2"));
		par.setAddress3(request.getParameter("globalAddress3"));
		
		return par;
	}
	
	public static String composeParNo(GIPIPARList gipiParList){
		StringBuilder parNo = new StringBuilder();
		
		parNo.append(gipiParList.getLineCd());
		parNo.append(" - ");
		parNo.append(gipiParList.getIssCd());
		parNo.append(" - ");
		parNo.append(String.format("%02d", gipiParList.getParYy()));
		parNo.append(" - ");
		parNo.append(String.format("%06d", gipiParList.getParSeqNo()));
		parNo.append(" - ");
		parNo.append(String.format("%02d", gipiParList.getQuoteSeqNo()));
		
		return parNo.toString();
	}
}
