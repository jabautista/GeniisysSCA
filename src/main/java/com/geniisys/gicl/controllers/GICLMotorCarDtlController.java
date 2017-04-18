/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLMotorCarDtlController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 23, 2011
	Description: 
*/


package com.geniisys.gicl.controllers;

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
import com.geniisys.gicl.service.GICLMotorCarDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLMotorCarDtlController", urlPatterns={"/GICLMotorCarDtlController"})
public class GICLMotorCarDtlController extends BaseController{

	private Logger log = Logger.getLogger(GICLMotorCarDtlController.class);
	private static final long serialVersionUID = 6058168252679721808L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLMotorCarDtlService giclMotorCarDtlService = (GICLMotorCarDtlService) APPLICATION_CONTEXT.getBean("giclMotorCarDtlService");
			if (ACTION.equals("getMotorCarItemDtl")) {
				giclMotorCarDtlService.getGICLMotorCarDtlGrid(request, USER, APPLICATION_CONTEXT); // Added APPLICATION_CONTEXT by J. Diago 10.11.2013
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/motorCar/motorCarItemInfo.jsp" : ("2".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/motorCar/subPages/motorCarDriverDetails.jsp" : "/pages/genericObject.jsp"));
			}else if(ACTION.equals("getGiclMcTpDtl")){
				giclMotorCarDtlService.getGiclMcTpDtl(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					request.setAttribute("itemNo", request.getParameter("itemNo"));
					PAGE = "/pages/claims/claimItemInfo/motorCar/subPages/motorCarThirdAdverseParty.jsp";
				}
			}else if ("saveMcTpDtl".equals(ACTION)) {
				giclMotorCarDtlService.saveMcTpDtl(request.getParameter("strParameters"),USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateClmItemNo".equals(ACTION)){
				log.info("Validating item no. ... ");
				message = giclMotorCarDtlService.validateClmItemNo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveClmItemMotorCar".equals(ACTION)) {
				message = giclMotorCarDtlService.saveClmItemMotorCar(request, USER);
				PAGE= "/pages/genericMessage.jsp";
			}else if("getTowAmount".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				message = giclMotorCarDtlService.getTowAmount(params);
				PAGE= "/pages/genericMessage.jsp";
			}else if("showVehicleInfo".equals(ACTION)){
				System.out.println("VEHICLE INFORMATION");
				request.setAttribute("owner", request.getParameter("owner"));
			    giclMotorCarDtlService.getGICLS268MotorCarDetail(request);
				PAGE = "/pages/claims/inquiry/claimListing/perPlateNo/vehicleInformation.jsp";
			}else if("showGICLS260MotorCarItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getGICLS260MotorCarDtl");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/motorCar/motorCarItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
				
			}else if("showGICLS260ThirdAdverseParty".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getGICLS260GiclMcTpDtl");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclMcTPDtl", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/motorCar/thirdAdverseParty.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260ThirdAdvOtherDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeNo", request.getParameter("payeeNo"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInObject(giclMotorCarDtlService.getGICLS260McTpOtherDtls(params)));
				request.setAttribute("mcTpDtl", json);
				PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/motorCar/thirdAdvOtherDtls.jsp";
			}
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
