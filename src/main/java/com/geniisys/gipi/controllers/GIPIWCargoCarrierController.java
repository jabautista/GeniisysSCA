package com.geniisys.gipi.controllers;

import java.io.IOException;
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

@WebServlet(name="GIPIWCargoCarrierController", urlPatterns={"/GIPIWCargoCarrierController"})
public class GIPIWCargoCarrierController extends BaseController {
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("getGIPIWCargoCarrierTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgCargoCarriers = TableGridUtil.getTableGrid2(request, tgParams);				
				request.setAttribute("tgCargoCarriers", new JSONObject(tgCargoCarriers));
				
				PAGE = "/pages/underwriting/parTableGrid/marineCargo/subPages/cargoCarrier/cargoCarriersTableGridListing.jsp";
			}else if("refreshCargoCarrierTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				
				params.put("ACTION", "getGIPIWCargoCarrierTableGrid");		
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));				
				//params.put("pageSize", 5);
				
				params = TableGridUtil.getTableGrid2(request, params);
				
				message = (new JSONObject(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
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