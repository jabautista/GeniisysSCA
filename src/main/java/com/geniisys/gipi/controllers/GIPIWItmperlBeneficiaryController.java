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

@WebServlet(name="GIPIWItmperlBeneficiaryController", urlPatterns={"/GIPIWItmperlBeneficiaryController"})
public class GIPIWItmperlBeneficiaryController extends BaseController {
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("getItmperlBeneficiaryTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				Integer groupedItemNo = Integer.parseInt(request.getParameter("groupedItemNo") != null ? request.getParameter("groupedItemNo") : null);
				Integer beneficiaryNo = Integer.parseInt(request.getParameter("beneficiaryNo") != null ? request.getParameter("beneficiaryNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				tgParams.put("groupedItemNo", groupedItemNo);
				tgParams.put("beneficiaryNo", beneficiaryNo);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgItmperlBens = TableGridUtil.getTableGrid2(request, tgParams);
				
				if("1".equals(request.getParameter("refresh"))){
					message = (new JSONObject(tgItmperlBens)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					tgItmperlBens.put("gipiWItmperlBeneficiary", tgItmperlBens.get("rows"));
					request.setAttribute("itmperlBeneficiaries", new JSONObject(tgItmperlBens));					
					PAGE = "/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGrpItemBenPerilsTableGridListing.jsp";
				}
			}else if("getGrpPerilTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("beneficiaryNo", Integer.parseInt(request.getParameter("beneficiaryNo")));
				
				Map<String, Object> grpPerilTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(grpPerilTableGrid);
				
				message = json.toString();
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
