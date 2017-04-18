package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISUserService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIISS040Controller", urlPatterns={"/GIISS040Controller"})
public class GIISUserController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9202829731433074558L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISUserService giisUserService = (GIISUserService) APPLICATION_CONTEXT.getBean("giisUserService");
		
		try {
			if("showGiiss040".equals(ACTION)){
				JSONObject json = giisUserService.showGiiss040(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonUserList", json);
					PAGE = "/pages/security/user/userMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisUserService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisUserService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss040".equals(ACTION)) {
				giisUserService.saveGiiss040(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showUserHistory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserHistory");		
				params.put("userId", request.getParameter("userId"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(recList)); 
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonUserHistory", json);
					PAGE = "/pages/security/user/subPages/userHistoryTable.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showUserGroupAccess".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserGrpTrans");		
				params.put("userGrp", request.getParameter("userGrp"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(recList);
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonUserGrpTrans", json);
					PAGE = "/pages/security/user/subPages/userGroupAccess.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getUserGrpDtl".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserGrpDtl");		
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("tranCd", request.getParameter("tranCd"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(recList);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getUserGrpLine".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserGrpLine");		
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("tranCd", request.getParameter("tranCd"));
				params.put("issCd", request.getParameter("issCd"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(recList));
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";								
			} else if("showUserGroupModules".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserGroupModules");
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("tranCd", request.getParameter("tranCd"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(recList); 
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonUserGroupModules", json);
					PAGE = "/pages/security/user/subPages/userGroupModules.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showTransactions".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserTran");		
				params.put("userId", request.getParameter("userId"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(recList));
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonUserTran", json);
					PAGE = "/pages/security/user/subPages/transactions.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getUserIssCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserIssCd");		
				params.put("userId", request.getParameter("userId"));
				params.put("tranCd", request.getParameter("tranCd"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(recList));
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getUserLine".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserLine");		
				params.put("userId", request.getParameter("userId"));
				params.put("tranCd", request.getParameter("tranCd"));
				params.put("issCd", request.getParameter("issCd"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(recList));
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showUserModules".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getUserModules");
				params.put("userId", request.getParameter("userId"));
				params.put("tranCd", request.getParameter("tranCd"));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(recList)); 
				
				if(request.getParameter("refresh") == null) {
					String parameters[] = {"GIIS_MODULES_USER.ACCESS_TAG"};
					LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");				
					request.setAttribute("accessTags", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, parameters));					
					request.setAttribute("jsonUserModules", json);
					PAGE = "/pages/security/user/subPages/userModules.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("saveGiiss040UserModules".equals(ACTION)){
				giisUserService.saveGiiss040UserModules(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkAllUserModule".equals(ACTION)){
				giisUserService.checkAllUserModule(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("uncheckAllUserModule".equals(ACTION)){
				giisUserService.uncheckAllUserModule(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGiiss040Tran".equals(ACTION)){
				giisUserService.saveGiiss040Tran(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if("includeAllIssCodes".equals(ACTION)){
				JSONArray result = giisUserService.includeAllIssCodes(request, USER.getUserId());
				message = result.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if("includeAllLineCodes".equals(ACTION)){
				JSONArray result = giisUserService.includeAllLineCodes(request, USER.getUserId());
				message = result.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecTran1".equals(ACTION)){
				giisUserService.valDeleteRecTran1(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecTran1Line".equals(ACTION)){
				giisUserService.valDeleteRecTran1Line(request);
				message = "SUCCESS";
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
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
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
