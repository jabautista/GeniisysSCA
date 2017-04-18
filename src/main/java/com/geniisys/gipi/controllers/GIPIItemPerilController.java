package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIItemPerilService;
import com.geniisys.gipi.service.GIPIItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIItemPerilController extends BaseController{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIItemPerilService gipiItemPerilService = (GIPIItemPerilService) APPLICATION_CONTEXT.getBean("gipiItemPerilService");
			GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
			
			if("getItemPerils".equals(ACTION)){
				String perilViewType = request.getParameter("perilViewType");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("ACTION", "getItemPerils");
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				System.out.println("peril view type : "+perilViewType+
						" policy Id : "+Integer.parseInt(request.getParameter("policyId"))+
						" item no : "+Integer.parseInt(request.getParameter("itemNo"))
				);
				
				gipiItemPerilService.getItemPerils(params);
				Map<String, Object> itemList =TableGridUtil.getTableGrid(request, params); 
				JSONObject json = new JSONObject(itemList);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					//JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					
					JSONObject itemPerilList = new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params));
					request.setAttribute("itemPerilList", itemPerilList);
					
					if("riPeril".equals(perilViewType)){
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilRiTableGrid.jsp";
						System.out.println("ri peril");
					}else{
						if("fiPeril".equals(perilViewType)){
							PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilFiTableGrid.jsp";
							System.out.println("fi peril");
						}else if("mnPeril".equals(perilViewType)){
							PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilMnTableGrid.jsp";
							System.out.println("mn peril");
						}else{
							System.out.println("other peril");
							PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilOtherTableGrid.jsp";
						}
					}
				}
				
			} else if ("getGIPIS175Items".equals(ACTION)){
				JSONObject jsonItems = gipiItemService.getGIPIS175Items(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonItems.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonItems", jsonItems);
					PAGE = "/pages/underwriting/reInsurance/updateInwardRIComm/updateInwardRIComm.jsp";
				}	
			} else if ("getGIPIS175Perils".equals(ACTION)){
				JSONObject jsonPerils = gipiItemPerilService.getGIPIS175Perils(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPerils.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonPerils", jsonPerils);
					PAGE = "/pages/underwriting/reInsurance/updateInwardRIComm/updateInwardRIComm.jsp";
				}
			}
			
			
		}catch (NullPointerException e) {
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
