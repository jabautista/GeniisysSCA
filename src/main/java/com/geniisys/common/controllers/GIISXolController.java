/**
	Project: Geniisys
	Package: com.geniisys.common.controllers
	File Name: GIISXolController.java
	Author: Computer Professionals Inc.
	Created By: Halley
	Created Date: November 16, 2012
	Description: Controller for Distribution Share Maintenance - XOL Table
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISXol;
import com.geniisys.common.service.GIISXolMaintService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;

public class GIISXolController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -892484394081132270L;
	private static Logger log = Logger.getLogger(GIISXol.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISXolMaintService giisXolMaintService = (GIISXolMaintService) APPLICATION_CONTEXT.getBean("giisXolMaintService");
			
			if("getXolList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("appUser", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				
				Map<String, Object> xolListObj = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(xolListObj);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("lineListingObj", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/distributionShare/subPages/xolTableGrid.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveXol".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("xolYy", request.getParameter("xolYy"));
				params.put("xolSeqNo", request.getParameter("xolSeqNo"));
				params.put("appUser", USER.getUserId());
				message = giisXolMaintService.saveXol(request.getParameter("param"), params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateAddXol".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("xolYy", request.getParameter("xolYy"));
				params.put("xolSeqNo", request.getParameter("xolSeqNo"));
				params.put("xolTrtyName", request.getParameter("xolTrtyName"));
				params.put("remarks", request.getParameter("remarks"));
				message = giisXolMaintService.validateAddXol(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateUpdateXol".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("xolYy", request.getParameter("xolYy"));
				params.put("xolSeqNo", request.getParameter("xolSeqNo"));
				params.put("xolTrtyName", request.getParameter("xolTrtyName"));
				params.put("remarks", request.getParameter("remarks"));
				message = giisXolMaintService.validateUpdateXol(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateDeleteXol".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("xolId", request.getParameter("xolId"));
				message = giisXolMaintService.validateDeleteXol(params);
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
