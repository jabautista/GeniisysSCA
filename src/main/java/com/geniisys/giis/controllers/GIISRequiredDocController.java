package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISRequiredDocService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;
@WebServlet(name="GIISRequiredDocController", urlPatterns={"/GIISRequiredDocController"})

public class GIISRequiredDocController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 486451696915181623L;
	private static Logger log = Logger.getLogger(GIISRequiredDocController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GIISRequiredDocController.class.getSimpleName());
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIISRequiredDocService giisRequiredDocService = (GIISRequiredDocService) appContext.getBean("GIISRequiredDocService");
		PAGE = "/pages/genericMessage.jsp";
		try{
			if ("showGIIS035RequiredPolicyDocumentMaintenance".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getLineListingWithPackPolFlagN");
				String modId = "GIISS035";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> lineListing = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(lineListing);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("requiredPolicyDocumentMaintenance", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/requiredPolicyDocument.jsp";
					System.out.println(json.toString());
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getSublineLOV".equals(ACTION)) {  // Kris 05.23.2013: original action getSublineLov changed to getSublineLOV
				String lineCd = request.getParameter("lineCd");
				HashMap<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", "getSublineLOVGiiss035"); // Kris 05.28.2013: replaced ACTION with the xml select id getSublineLOVGiiss035
				String modId = "GIISS035";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("lineCd", lineCd);
				Map<String, Object> sublineListing = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(sublineListing);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("requiredPolicyDocumentMaintenance", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/subPages/sublineListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getGiisRequiredDocList".equals(ACTION)) {
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				System.out.println("giis_required_doc");
				System.out.println("line_cd: "+lineCd);
				System.out.println("subline_cd: "+sublineCd);
				HashMap<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", ACTION);
				String modId = "GIISS035";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				Map<String, Object> requiredDocListing = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(requiredDocListing);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("requiredPolicyDocumentMaintenance", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/subPages/requiredDocumentsMaintenance.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("saveGIISRequiredDoc".equals(ACTION)){
				giisRequiredDocService.saveGIISRequiredDoc(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getCurrenDocCdList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				
				List<String> docCdList = giisRequiredDocService.getCurrenDocCdList(params);
				System.out.println("retrieved list: "+docCdList);
				request.setAttribute("object", (List<String>)StringFormatter.escapeHTMLInList(docCdList));
				PAGE = "/pages/genericObject.jsp";						
			} else if("showGiiss035".equals(ACTION)){
				JSONObject json = giisRequiredDocService.showGiiss035(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRequiredDocs", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/requiredDocument.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				message = giisRequiredDocService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisRequiredDocService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss035".equals(ACTION)) {
				giisRequiredDocService.saveGiiss035(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiiss035Line".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisRequiredDocService.validateGiiss035Line(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGiiss035Subline".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisRequiredDocService.validateGiiss035Subline(request))));
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
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

