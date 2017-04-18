package com.geniisys.common.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISBlockService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISBlockController", urlPatterns={"/GIISBlockController"})
public class GIISBlockController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISBlockService giisBlockService = (GIISBlockService) APPLICATION_CONTEXT.getBean("giisBlockService");
		
		try {
			if("showGiiss007".equals(ACTION)){
				JSONObject jsonProvinceList = giisBlockService.getGiiss007Province(request, USER.getUserId());
				JSONObject jsonCityList = giisBlockService.getGiiss007City(request, USER.getUserId());	
				JSONObject jsonDistrictList = giisBlockService.getGiiss007District(request, USER.getUserId());	
				JSONObject jsonBlockList = giisBlockService.getGiiss007Block(request, USER.getUserId());
				request.setAttribute("jsonProvinceList", jsonProvinceList);
				request.setAttribute("jsonCityList", jsonCityList);
				request.setAttribute("jsonDistrictList", jsonDistrictList);
				request.setAttribute("jsonBlockList", jsonBlockList);
				PAGE = "/pages/underwriting/fileMaintenance/fire/block/block.jsp";			
			} else if("getGiiss007Province".equals(ACTION)){
				JSONObject jsonProvinceList = giisBlockService.getGiiss007Province(request, USER.getUserId());
				message = jsonProvinceList.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss007City".equals(ACTION)){
				JSONObject jsonCityList = giisBlockService.getGiiss007City(request, USER.getUserId());
				message = jsonCityList.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss007District".equals(ACTION)){
				JSONObject jsonDistrictList = giisBlockService.getGiiss007District(request, USER.getUserId());
				message = jsonDistrictList.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss007Block".equals(ACTION)){
				JSONObject jsonBlockList = giisBlockService.getGiiss007Block(request, USER.getUserId());
				message = jsonBlockList.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss007RisksDetails".equals(ACTION)){				
				JSONObject jsonRisksDetails = giisBlockService.getGiiss007RisksDetails(request);				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRisksDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{			
					request.setAttribute("blockId", request.getParameter("blockId"));
					request.setAttribute("jsonRisksDetails", jsonRisksDetails);	
					PAGE = "/pages/underwriting/fileMaintenance/fire/block/risks/risksDetails.jsp";
				}	
			} else if("getGiiss007AllRisksDetails".equals(ACTION)){				
				JSONObject json = giisBlockService.getGiiss007AllRisksDetails(request);				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecRisk".equals(ACTION)){
				giisBlockService.valDeleteRecRisk(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("valAddRecRisk".equals(ACTION)){
				giisBlockService.valAddRecRisk(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveRiskDetails".equals(ACTION)) {
				giisBlockService.saveRiskDetails(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRecBlock".equals(ACTION)){
				giisBlockService.valAddRecBlock(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAddRecDistrict".equals(ACTION)){
				giisBlockService.valAddRecDistrict(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valDeleteRecBlock".equals(ACTION)){
				giisBlockService.valDeleteRecBlock(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss007".equals(ACTION)) {
				giisBlockService.saveGiiss007(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecProvince".equals(ACTION)){
				giisBlockService.valDeleteRecProvince(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecCity".equals(ACTION)){
				giisBlockService.valDeleteRecCity(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecDistrict".equals(ACTION)){
				giisBlockService.valDeleteRecDistrict(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
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
