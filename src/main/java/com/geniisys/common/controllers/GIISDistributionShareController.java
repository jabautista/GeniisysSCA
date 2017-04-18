/**
	Project: Geniisys
	Package: com.geniisys.common.controllers
	File Name: GIISDistributionShareController.java
	Author: Computer Professionals Inc.
	Created By: Halley
	Created Date: October 15, 2012
	Description: Controller for Distribution Share Maintenance
*/

package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISDistShare;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISDistShareMaintService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISDistributionShareController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9192316275141272277L;
	private static Logger log = Logger.getLogger(GIISDistShare.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISDistShareMaintService giisDistShareMaintService = (GIISDistShareMaintService) APPLICATION_CONTEXT.getBean("giisDistShareMaintService");
			
			if("getGIIS060LineListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("appUser", USER.getUserId());
				
				Map<String, Object> lineListingObj = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(lineListingObj);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("lineListingObj", json);
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("appUser", USER.getUserId());
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/distributionShareMain.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getDistShareMaintenance".equals(ACTION)) {
				HashMap<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", ACTION);
				params.put("appUser", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("shareType", request.getParameter("shareType"));
				
				Map<String, Object> distShareObj = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(distShareObj);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("lineListingObj", json);
					request.setAttribute("appUser", USER.getUserId());
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/subPages/distributionShareTableGrid.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}				
			} else if ("saveDistShare".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("appUser", USER.getUserId());
				System.out.println(request.getParameter("param"));
				message = giisDistShareMaintService.saveDistShare(request.getParameter("param"), params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteDistShare".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("shareCd", request.getParameter("shareCd"));
				message = giisDistShareMaintService.valDeleteDistShare(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddDistShare".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("shareCd", request.getParameter("shareCd"));
				params.put("trtyName", request.getParameter("trtyName"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("exists", "");
				params.put("msg", "");
				params = giisDistShareMaintService.valAddDistShare(params);
				StringFormatter.escapeHTMLInMap(params);
				JSONObject object = new JSONObject(params);
				request.setAttribute("params", object);
				message = object.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateUpdateDistShare".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("shareCd", request.getParameter("shareCd"));
				params.put("trtyName", request.getParameter("trtyName"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("exists", "");
				params.put("msg", "");
				params = giisDistShareMaintService.validateUpdateDistShare(params);
				StringFormatter.escapeHTMLInMap(params);
				JSONObject object = new JSONObject(params);
				request.setAttribute("params", object);
				message = object.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showProportionalTreatyInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = (Map<String, Object>) giisDistShareMaintService.showProportionalTreatyInfo(request);
				StringFormatter.escapeHTMLInMap(params);
				JSONObject object = new JSONObject(params);
				request.setAttribute("obj", object);
				
				JSONObject json = giisDistShareMaintService.showGiiss031(request, USER.getUserId(), params);
				JSONObject jsonAllRec = giisDistShareMaintService.showGiiss031AllRec(request, USER.getUserId(), params);
				request.setAttribute("jsonTrty", json);
				request.setAttribute("jsonAllRecList", jsonAllRec);
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/outwardTreatyInformation/proportionalTreatyInfo.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("giiss031UpdateTreaty".equals(ACTION)) {
				giisDistShareMaintService.giiss031UpdateTreaty(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateAcctTrtyType".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisDistShareMaintService.validateAcctTrtyType(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateProfComm".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisDistShareMaintService.validateProfComm(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showNonProportionalTreatyInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = (Map<String, Object>) giisDistShareMaintService.showNonProportionalTreatyInfo(request);
				StringFormatter.escapeHTMLInMap(params);
				JSONObject object = new JSONObject(params);
				request.setAttribute("obj", object);
				
				JSONObject json = giisDistShareMaintService.showNonProTrtyInfo(request, USER.getUserId(), params);
				request.setAttribute("jsonNonPropTrty", json);
				
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/outwardTreatyInformation/nonProportionalTreatyInfo.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveGiiss031".equals(ACTION)) {
				giisDistShareMaintService.saveGiiss031(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateGiiss031TrtyName".equals(ACTION)){
				giisDistShareMaintService.validateGiiss031TrtyName(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("validateGiiss031OldTrtySeq".equals(ACTION)){
				giisDistShareMaintService.validateGiiss031OldTrtySeq(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("valDeleteParentRec".equals(ACTION)){
				giisDistShareMaintService.valDeleteParentRec(request);
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
