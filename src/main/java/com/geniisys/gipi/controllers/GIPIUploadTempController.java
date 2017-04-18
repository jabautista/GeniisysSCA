package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;

@WebServlet(name="GIPIUploadTempController", urlPatterns={"/GIPIUploadTempController"})
public class GIPIUploadTempController extends BaseController {
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("getGIPIUploadTempTableGrid".equals(ACTION)){
				Map<String, Object> tgUploadTemp = new HashMap<String, Object>();
				
				tgUploadTemp.put("uploadNo", Integer.parseInt(request.getParameter("uploadNo") != null ? request.getParameter("uploadNo") : null));
				tgUploadTemp.put("ACTION", "getGIPIUploadTempTG");				
				
				tgUploadTemp = TableGridUtil.getTableGrid2(request, tgUploadTemp);
				
				if("1".equals(request.getParameter("refresh"))){
					message = (new JSONObject(tgUploadTemp)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("tgUploadTemp", new JSONObject(tgUploadTemp));					
					PAGE = "/pages/underwriting/overlay/enrollees/uploadEnrolleesDetailsTableGridListing.jsp";
				}				
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
