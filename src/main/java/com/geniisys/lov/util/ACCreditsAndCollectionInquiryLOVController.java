package com.geniisys.lov.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="ACCreditsAndCollectionInquiryLOVController", urlPatterns={"/ACCreditsAndCollectionInquiryLOVController"})
public class ACCreditsAndCollectionInquiryLOVController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -419448722672930009L;

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
		if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
			params.put("findText", request.getParameter("filterText"));
		}
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
		}
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		params.put("ACTION", ACTION);
		
		
		try {		
			// IMPORTANT: use the specified action for controller as the id for sqlMap select/procedure
			
			// parameters per action
			if("showGiacs211AssuredLov".equals(ACTION)){
				params.put("policyId",request.getParameter("policyId"));
				params.put("intmNo",request.getParameter("intmNo"));
				params.put("packPolicyId",request.getParameter("packPolicyId"));
				params.put("packBillIssCd",request.getParameter("packBillIssCd"));
				params.put("packBillPremSeqNo",request.getParameter("packBillPremSeqNo"));
				params.put("dueDate", request.getParameter("dueDate"));
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("issueDate", request.getParameter("issueDate"));
				params.put("billIssCd", request.getParameter("billIssCd"));
			} else if("getGiisIntmTypeLov".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("packBillIssCd", request.getParameter("packBillIssCd"));
				params.put("packBillPremSeqNo", request.getParameter("packBillPremSeqNo"));
				params.put("dueDate", request.getParameter("dueDate"));
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("issueDate", request.getParameter("issueDate"));		
			} else if("getGiisIntermediaryLov".equals(ACTION)){
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("intmType", request.getParameter("intmType"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("packBillIssCd", request.getParameter("packBillIssCd"));
				params.put("packBillPremSeqNo", request.getParameter("packBillPremSeqNo"));
				params.put("dueDate", request.getParameter("dueDate"));
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("issueDate", request.getParameter("issueDate"));		
			} else if("getGiacs211IssCdLov".equals(ACTION)){
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("intmType", request.getParameter("intmType"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("packBillIssCd", request.getParameter("packBillIssCd"));
				params.put("packBillPremSeqNo", request.getParameter("packBillPremSeqNo"));
				params.put("dueDate", request.getParameter("dueDate"));
				params.put("inceptDate", request.getParameter("inceptDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("issueDate", request.getParameter("issueDate"));		
			}
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params));
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
