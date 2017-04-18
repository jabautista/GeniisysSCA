/**
	Project: Geniisys
	Package: com.geniisys.giis.controllers
	File Name: GIISPerilDepreciationController.java
	Author: Computer Professional Inc
	Created By: Chris
	Created Date: Oct 16, 2012
	Description: 
*/

/**
 * 	Modified By: Kenneth L.
 * 	Date: 11.06.2012
 */

package com.geniisys.giex.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXPerilDepreciationService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXPerilDepreciationController", urlPatterns={"/GIEXPerilDepreciationController"})
public class GIEXPerilDepreciationController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6805566179420599595L;
	private static Logger log = Logger.getLogger(GIEXPerilDepreciationController.class);

	public void doProcessing(HttpServletRequest request,
		HttpServletResponse response, GIISUser USER, String ACTION,
		HttpSession SESSION) throws ServletException, IOException {
			log.info("do processing");
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXPerilDepreciationService giexPerilDepreciationService = (GIEXPerilDepreciationService) APPLICATION_CONTEXT.getBean("giexPerilDepreciationService");
			
			try {
				if("showPerilDepreciationMaintenance".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", ACTION);
					String modId = "GIISS208";
					params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
					params.put("appUser", USER.getUserId());
					params.put("userId", USER.getUserId());
					Map<String, Object> lineListTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(lineListTableGrid);
					if("1".equals(request.getParameter("ajax"))){
						request.setAttribute("jsonLineList", json);
						PAGE = "/pages/underwriting/fileMaintenance/general/perilDepreciation/perilDepreciationMaintenanceMain.jsp";					
					}else{
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";				
						}
				} else if ("getGiiss208PerilDepreciationList".equals(ACTION)) {
					message = giexPerilDepreciationService.getPerilList(request).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if("savePerilDepreciation".equals(ACTION)){
					message = giexPerilDepreciationService.savePerilDep(request, USER.getUserId());
					PAGE = "/pages/genericMessage.jsp";
				}else if("validateAddPerilCd".equals(ACTION)){
					message = giexPerilDepreciationService.validateAddPerilCd(request);
					PAGE = "/pages/genericMessage.jsp";
				}
				} catch (Exception e) {
					message = ExceptionHandler.handleException(e, USER);
				}finally{
					request.setAttribute("message", message);
					this.doDispatch(request, response, PAGE);
			}
		}
	}