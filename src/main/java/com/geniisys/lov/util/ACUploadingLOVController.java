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

@WebServlet (name="ACUploadingLOVController", urlPatterns={"/ACUploadingLOVController"}) 
public class ACUploadingLOVController extends BaseController{

	private static final long serialVersionUID = -8298986715901211141L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
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
			if("uploadingGetDocCd".equals(ACTION)) {
				params.put("branchCd", request.getParameter("branchCd"));
			} else if("uploadingGetBranchCdLOV".equals(ACTION)) {
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
			} else if("uploadingGetLineCdLOV".equals(ACTION)) {
				//no specific parameter
			} else if("uploadingGetDeptCdLOV".equals(ACTION)) {
				params.put("branchCd", request.getParameter("branchCd"));
			} else if("uploadingGetPayeeClassCdLOV".equals(ACTION)) {
				//no specific parameter
			} else if("uploadingGetPayeeCdLOV".equals(ACTION)) {
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
			} else if("uploadingGetCurrencyCdLOV".equals(ACTION)) {
				//no specific parameter
			} else if("getGiacs603BankCdLOV".equals(ACTION)) {
				params.put("search", request.getParameter("search"));
			} else if("getGiacs603BankAcctLOV".equals(ACTION)){
				params.put("search", request.getParameter("search"));
				params.put("bankCd", request.getParameter("bankCd"));
			} else if("getGIACS607DocumentCdLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607DVBranchCdLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("docCd", request.getParameter("docCd"));
				params.put("oucId", request.getParameter("oucId"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607LineCdLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607OucCdLOV".equals(ACTION)){
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607PayeeClassCdLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607PayeeCdLOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607CurrencyCdLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607JVBranchCdLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607JVTranTypeLOV".equals(ACTION)){
				params.put("jvTranTag", request.getParameter("jvTranTag"));
				params.put("rowNum", request.getParameter("rowNum"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607CollnBankLOV".equals(ACTION)){
				params.put("rowNum", request.getParameter("rowNum"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607CollnDcbBankLOV".equals(ACTION)){
				params.put("rowNum", request.getParameter("rowNum"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}else if("getGIACS607CollnDcbBankAcctLOV".equals(ACTION)){
				params.put("dcbBankCd", request.getParameter("dcbBankCd"));
				params.put("rowNum", request.getParameter("rowNum"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			//Deo: GIACS609 conversion start
			} else if("getGiacs609BankLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609CurrencyLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609DcbBankLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609DcbBankAcctLOV".equals(ACTION)){
				params.put("dcbBankCd", request.getParameter("dcbBankCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609ORLOV".equals(ACTION)){
				params.put("orDate", request.getParameter("orDate"));
			} else if("getGiacs609BranchLOV".equals(ACTION)){
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("docCd", request.getParameter("docCd"));
				params.put("deptId", request.getParameter("deptId"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609JVTranTypeLOV".equals(ACTION)){
				params.put("jvTranTag", request.getParameter("jvTranTag"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609JVLOV".equals(ACTION)){
				params.put("tranDate", request.getParameter("tranDate"));
			} else if("getGiacs609PaytRqstLOV".equals(ACTION)){
				params.put("documentCd", request.getParameter("documentCd"));
			} else if("getGiacs609DocumentLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609LineLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609DeptLOV".equals(ACTION)){
				params.put("branchCd", request.getParameter("branchCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("geGiacs609PayeeClassLOV".equals(ACTION)){
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			} else if("getGiacs609PayeeLOV".equals(ACTION)){
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				if (request.getParameter("findText") == null && request.getParameter("searchString") != null){
					params.put("findText", request.getParameter("searchString"));
				}
			}
			//Deo: GIACS609 conversion ends
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params)); //escapeHTMLInMap added by shan : 03.06.2014
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
