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
@WebServlet(name="AcCashReceiptsTransactionsLOVController", urlPatterns={"/AcCashReceiptsTransactionsLOVController"})

public class AcCashReceiptsTransactionsLOVController extends BaseController {
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
			// NOTE: format for lov action is : "get<Entity Name>LOV"			
			// parameters per action
			if("getGIACS035BankCdLOV".equals(ACTION)){ // dren 07.16.2015 : SR 0017729 - Added LOV for GIACS035 - Start
				params.put("search", request.getParameter("search"));
			}else if("getGIACS035BankAcctCdLOV".equals(ACTION)){ 
				params.put("search", request.getParameter("search"));
				params.put("bankCd", request.getParameter("bankCd"));
			}else if("getGIACS035PayModeLOV".equals(ACTION)){ 
				params.put("search", request.getParameter("search"));
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("dspDcbDate", request.getParameter("dspDcbDate"));
				params.put("dcbNo", request.getParameter("dcbNo"));
			}else if("getGIACS035CurrencyLOV".equals(ACTION)){ 
				params.put("search", request.getParameter("search"));
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("dspDcbDate", request.getParameter("dspDcbDate"));
				params.put("payMode", request.getParameter("payMode"));		
				params.put("dcbNo", request.getParameter("dcbNo"));
			} // dren 07.16.2015 : SR 0017729 - Added LOV for GIACS035 - End	
			else if("getGIACS007BranchCdLOV".equals(ACTION)){ // SR-20000 : shan 08.24.2015
				params.put("searchString", request.getParameter("searchString"));
			} else if ("getGiacs091FundLOV".equals(ACTION)) { // added by apollo cruz 09.16.2015 sr#20107
				//no params
			} else if("getGiacs091BranchLOV".equals(ACTION)){ // added by apollo cruz 09.16.2015 sr#20107
				params.put("search", request.getParameter("search"));
				params.put("fundCd", request.getParameter("fundCd"));
			} else if("getBillNoLOV".equals(ACTION)){ // added by Kenneth 12.02.2015 sr#20856
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", request.getParameter("tranType"));
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
