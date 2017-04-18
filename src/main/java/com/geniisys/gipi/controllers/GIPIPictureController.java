package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIPIPictureController", urlPatterns={"/GIPIPictureController"})
public class GIPIPictureController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9012753744605918842L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			if("showAttachmentList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "selectGIPIPicture");
				params.put("policyId", request.getParameter("policyId"));
				params.put("itemNo", request.getParameter("itemNo"));
				Map<String, Object> picturesTableGrid = TableGridUtil.getTableGrid(request, params);
				
				/*JSONArray list = (JSONArray) picturesTableGrid.get("rows"); 
				List<String> files = new ArrayList<String>();
				for(int i=0; i<list.length(); i++){
					//files.add(StringFormatter.unescapeHTML2(list.getJSONObject(i).getString("fileName")));//added by steven 07.30.2014
					files.add(StringFormatter.unescapeHTML(list.getJSONObject(i).getString("fileName"))); //marco - 05.21.2015 - GENQA SR 4444 - replaced line above
				}				
				FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);*/ // SR-24028,23982 JET MAR-24-2017
				
				JSONObject json = new JSONObject(picturesTableGrid);
				request.setAttribute("picturesTableGrid", json);
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/attachment.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}

}
