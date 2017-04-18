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
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIWGrpItemsBeneficiaryService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIWGrpItemsBeneficiaryController", urlPatterns={"/GIPIWGrpItemsBeneficiaryController"})
public class GIPIWGrpItemsBeneficiaryController extends BaseController {
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService = (GIPIWGrpItemsBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWGrpItemsBeneficiaryService");
			
			if("getGrpItemsBeneficiaryTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				Integer groupedItemNo = Integer.parseInt(request.getParameter("groupedItemNo") != null ? request.getParameter("groupedItemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				tgParams.put("groupedItemNo", groupedItemNo);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgGroupedItemsBen = TableGridUtil.getTableGrid(request, tgParams);
				
				if("1".equals(request.getParameter("refresh"))){
					message = (new JSONObject(tgGroupedItemsBen)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					tgGroupedItemsBen.put("gipiWGrpItemBeneficiary", tgGroupedItemsBen.get("rows"));
					request.setAttribute("groupedItemsBenificiary", new JSONObject(tgGroupedItemsBen));					
					PAGE = "/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGrpItemsBenTableGridListing.jsp";
				}				
			}else if("showGrpItemsBenOverlay".equals(ACTION)){
				Integer parId = Integer.parseInt(request.getParameter("parId"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				Integer groupedItemNo = Integer.parseInt(request.getParameter("groupedItemNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("groupedItemNo", groupedItemNo);
				
				Map<String, Object> beneficiaryTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(beneficiaryTG);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("beneficiaryTGJson", json);
					PAGE = "/pages/underwriting/endt/jsonAccident/overlay/beneficiaryOverlay.jsp";
				}
			}else if("saveBeneficiary".equals(ACTION)){
				gipiWGrpItemsBeneficiaryService.saveBeneficiaries(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateBenNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = gipiWGrpItemsBeneficiaryService.validateBenNo(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateBenNo2".equals(ACTION)){ //added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)
				Map<String, Object> params = new HashMap<String, Object>();
				params = gipiWGrpItemsBeneficiaryService.validateBenNo2(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
				//END SR21720
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
