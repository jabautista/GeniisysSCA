package com.geniisys.gipi.controllers;

import java.io.IOException;
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
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.service.GIPIVehicleService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIVehicleController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIPIVehicleController.class);
	
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIVehicleService gipiVehicleService = (GIPIVehicleService) APPLICATION_CONTEXT.getBean("gipiVehicleService");
			
			if("showMotorCarsPage".equals(ACTION)){
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/motorCars.jsp";
				
			}else if("getMotorCarsTable".equals(ACTION)){				
				if("1".equals(request.getParameter("refresh"))){
					JSONObject jsonMotorCar = gipiVehicleService.getMotorCars(request);
					message = jsonMotorCar.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/motorCarsTable.jsp";					
				}
			}else if("showQueryMotorcarsPage".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/queryMotorcars.jsp";
			}else if("refreshMotorCarsTable".equals(ACTION)){
				/*
				 * //removed by robert 02.04.2014
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				
				params = gipiVehicleService.getMotorCars(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				 //end robert 02.04.2014
				*/
				
				//added by robert 02.04.2014
				Map<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", "getMotorCars");	
				params = TableGridUtil.getTableGrid(request, params);
				
				message = (new JSONObject(params)).toString();	
				PAGE = "/pages/genericMessage.jsp";
			}else if("getVehicleItemInfo".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));

				GIPIVehicle vehicleInfo = gipiVehicleService.getVehicleInfo(params);
				if(vehicleInfo != null){
					request.setAttribute("vehicleInfo", new JSONObject(StringFormatter.escapeHTMLInObject(vehicleInfo)));
				}else{
					vehicleInfo = new GIPIVehicle();
					request.setAttribute("vehicleInfo", new JSONObject(vehicleInfo));
				}
				request.setAttribute("mcItem", new JSONObject());
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/vehicleItemAddtlInfoOverlay.jsp";
			}else if("getListOfCarriers".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("ACTION", "getCarrierList");
				
				Map<String, Object> carrierList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(carrierList); 
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
				request.setAttribute("carrierList", json);				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/carrierListOverlay.jsp";
				}
			}else if("loadCOCOverlay".equals(ACTION)) {
				log.info("Loading enter COC overlay...");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : 
					Integer.parseInt(request.getParameter("page")));
				params.put("policyId", request.getParameter("policyId") == null ? 0 : 
					Integer.parseInt(request.getParameter("policyId")));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				
				params = gipiVehicleService.getMotorCoCTableGrid(params);
				params.put("currentPage", request.getParameter("page") == null ? 1 : 
					Integer.parseInt(request.getParameter("page")));
				Debug.print(params);
				if("reload".equals(request.getParameter("act"))) {
					JSONObject json = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params));
					message = StringFormatter.replaceTildes(json.toString());
					PAGE = "/pages/genericMessage.jsp";
				} else {
					GIISParameterService paramService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					request.setAttribute("generateCocSerial", paramService.getParamValueV2("GENERATE_COC_SERIAL"));
					request.setAttribute("cocGrid", new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/underwriting/reportsPrinting/policyPrintingAddtl/enterCOCNumber.jsp";
				}
			} else if ("updateVehicleForPrint".equals(ACTION)) {
				System.out.println("Updating vehicle for print.");
				gipiVehicleService.updateVehiclesGIPIS091(request.getParameter("parameters"), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkExistingCOCSerial".equals(ACTION)) {
				//#policyId#, #itemNo#,#cocSerialNo#, #cocType#
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("cocSerialNo", request.getParameter("cocSerialNo"));
				params.put("cocType", request.getParameter("cocType"));
				
				message = gipiVehicleService.checkExistingCOCSerial(params);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp"; 
			}else if("showCTPLPolicyListing".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = gipiVehicleService.getCTPLPolicies(request, USER.getUserId());
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/ctplPolicyListing/ctplPolicyListing.jsp";
				}
			}else if("showPolListingPerMake".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = gipiVehicleService.getPolListingPerMake(request, USER.getUserId());
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/policyListingPerMake/policyListingPerMake.jsp";
				}
			}else if("validateGipis192Make".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(gipiVehicleService.validateGipis192Make(request))));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateGipis192Company".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(gipiVehicleService.validateGipis192Company(request))));
				PAGE = "/pages/genericObject.jsp";
			}else if("showPolListingPerMotorType".equals(ACTION)){
				JSONObject json = gipiVehicleService.showPolListingPerMotorType(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("json", json);
					PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/policyListingPerMotorType/policyListingPerMotorType.jsp";
				}
			//GIPIS193
			}else if("showGIPIS193PolListing".equals(ACTION)){	//shan 10.09.2013
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGipis193VehicleItemListing");
				params.put("plateNo", request.getParameter("plateNo"));
				params.put("credBranch", request.getParameter("credBranch"));
				params.put("dateType", request.getParameter("dateType"));
				params.put("asOfDate", request.getParameter("asOfDate"));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("userId", USER.getUserId());
				
				Map<String, Object> vehicleItemList = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonVehicleItemList = new JSONObject(vehicleItemList);
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonVehicleItemList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("vehicleItemGrid", jsonVehicleItemList);
					PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/policyListingPerPlateNo/policyListingPerPlateNo.jsp";
				}				
			}else if("getGipis193VehicleItemTotals".equals(ACTION)){
				message = gipiVehicleService.getGipis193VehicleItemSum(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
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
