/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.controllers
	File Name: GIPIReassignParPolicyController.java
	Author: Computer Professional Inc
	Created By: Steven Ramirez
	Created Date: June 14, 2012
	Description: 
*/
package com.geniisys.gipi.controllers;

import java.io.IOException;
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
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIReassignParPolicy;
import com.geniisys.gipi.service.GIPIReassignParPolicyService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIReassignParPolicyController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8509198458486744002L;
	private static Logger log = Logger.getLogger(GIPIReassignParPolicyController.class);

	public static String leftPad(String value, int width) {
        return String.format("%" + width + "s", value).replace(' ', '0');
    }
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIReassignParPolicyService gipiReassignParPolicy = (GIPIReassignParPolicyService) APPLICATION_CONTEXT.getBean("gipiReassignParPolicyService"); 
			if("showReassignParPolicyListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getReassignParPolicyListing");
				params.put("userId", USER.getUserId());
				Map<String, Object> reassignParPolicy = TableGridUtil.getTableGrid(request, params);
				
				System.out.println("USERID " + USER.getUserId());
				JSONObject objReassignParPolicy = new JSONObject(reassignParPolicy);
				JSONArray rows = objReassignParPolicy.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgPackPolFlag", rows.getJSONObject(i).getString("packPolFlag").equals("Y") ? true : false);
					rows.getJSONObject(i).put("parNo", rows.getJSONObject(i).getString("lineCd")+" - "+rows.getJSONObject(i).getString("issCd")+" - "+rows.getJSONObject(i).getString("parYY")+" - "+leftPad(rows.getJSONObject(i).getString("parSeqNo"),6)+" - "+leftPad(rows.getJSONObject(i).getString("quoteSeqNo"),2));
				}
				objReassignParPolicy.remove("rows");
				objReassignParPolicy.put("rows", rows);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("objReassignParPolicy", objReassignParPolicy);
					PAGE = "/pages/underwriting/utilities/reassignment/reassignParPolicy.jsp";
				}else{
					message = objReassignParPolicy.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			}else if("saveReassignParPolicy".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("param"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setReassignParPolicy")), USER.getUserId(), GIPIReassignParPolicy.class));
				gipiReassignParPolicy.saveReassignParPolicy(params);
				message = "SUCCESS";
				PAGE =  "/pages/genericMessage.jsp";
			}else if("checkUser".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				/*params.put("misSw", USER.getMisSw());
				params.put("mgrSw", USER.getMgrSw());
				params.put("allUserSw", USER.getAllUserSw());*/
				
				params.put("ACTION", "getUserSw");
				params.put("userId", USER.getUserId());
				Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
				
				System.out.println("USERID " + USER.getUserId());
				JSONObject json = new JSONObject(map);
				System.out.println("json:  " + json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (SQLException e) {
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
