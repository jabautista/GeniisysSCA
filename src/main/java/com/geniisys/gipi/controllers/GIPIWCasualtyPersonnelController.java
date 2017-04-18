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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIWCasualtyPersonnelService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIWCasualtyPersonnelController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWCasualtyPersonnelController.class); 
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			if("getCasualtyPersonnelDetails".equals(ACTION)){
				GIPIWCasualtyPersonnelService casPerService = (GIPIWCasualtyPersonnelService) APPLICATION_CONTEXT.getBean("gipiWCasualtyPersonnelService");
				
				request.setAttribute("object", new JSONObject(casPerService.getCasualtyPersonnelDetails(request)));
				
				PAGE = "/pages/genericObject.jsp";
			}else if("getGIPIWCasualtyPersonnelTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);				
				
				Map<String, Object> tgCasualtyPersonnel = TableGridUtil.getTableGrid(request, tgParams);
				request.setAttribute("tgCasualtyPersonnel", new JSONObject(tgCasualtyPersonnel));
				
				PAGE = "/pages/underwriting/parTableGrid/casualty/subPages/casualtyPersonnel/casualtyPersonnelTableGridListing.jsp";
			}else if("refreshCasualtyPersonnelTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				
				params.put("ACTION", "getGIPIWCasualtyPersonnelTableGrid");		
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));				
				//params.put("pageSize", 5);
				
				params = TableGridUtil.getTableGrid(request, params);
				
				message = (new JSONObject(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
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
