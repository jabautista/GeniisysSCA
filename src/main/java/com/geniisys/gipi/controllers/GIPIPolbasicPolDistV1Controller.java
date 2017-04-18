package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.CGRefCodesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIPolbasicPolDistV1Service;
import com.geniisys.giuw.service.GIUWPolDistService;
import com.geniisys.giuw.service.GIUWWPerildsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIPolbasicPolDistV1Controller extends BaseController {

	private static final long serialVersionUID = 1L;
	public static String userId = "";
		
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIPolbasicPolDistV1Service polDistService = (GIPIPolbasicPolDistV1Service) APPLICATION_CONTEXT.getBean("gipiPolbasicPolDistV1Service");
		
		try{
			GIPIPolbasicPolDistV1Controller.userId = USER.getUserId();
			if("showSetupGroupDistribution".equals(ACTION)){
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/setUpDistrForDistItem.jsp";
			}else if("showPolbasicPolDistV1Listing".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GIUWS010");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = polDistService.getGIPIPolbasicPolDistV1List(params);
				request.setAttribute("gipiPolbasicPolDistV1TableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("refreshAction", "refreshSetupGroupDistribution");
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp";
			}else if("showPolbasicPolDistV1ListingForPerilDist".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = polDistService.getGIPIPolbasicPolDistV1ListForPerilDist(params);
				request.setAttribute("gipiPolbasicPolDistV1TableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("refreshAction", "refreshSetupGroupDistributionForPerilDist");
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp";
			}else if("refreshSetupGroupDistribution".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GIUWS010");
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = polDistService.getGIPIPolbasicPolDistV1List(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshSetupGroupDistributionForPerilDist".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = polDistService.getGIPIPolbasicPolDistV1ListForPerilDist(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showSetUpGroupsForDistPeril".equals(ACTION)){
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/setUpGrpForDistPeril.jsp";
			}else if("showDistributionByGroup".equals(ACTION)){
				request.setAttribute("loadRecords", request.getParameter("loadRecords"));
				PAGE = "/pages/underwriting/distribution/distByGroup/distributionByGroup.jsp";
			}else if("showDistributionByPeril".equals(ACTION)){
				request.setAttribute("loadRecords", request.getParameter("loadRecords"));
				PAGE = "/pages/underwriting/distribution/distByPeril/distributionByPeril.jsp";
			}else if("showNegPostedDist".equals(ACTION)){
				PAGE = "/pages/underwriting/distribution/negPostedDist/negPostedDist.jsp";
			}else if("showPolbasicPolOneRiskDistV1Listing".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = polDistService.getGIPIPolbasicPolDistV1ListOneRiskDist(params);
				request.setAttribute("gipiPolbasicPolDistV1TableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("refreshAction", "refreshSetupGroupDistributionOneRiskDist");
				PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp";
			}else if("refreshSetupGroupDistributionOneRiskDist".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = polDistService.getGIPIPolbasicPolDistV1ListOneRiskDist(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIPIPolbasicPolDistV1ListForNegPostDist".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("userId", USER.getUserId());
				Map<String, Object> polDistV1ListForNegPostDistItemsTableGrid = TableGridUtil.getTableGrid(request, params);				
				
				JSONObject json = new JSONObject(polDistV1ListForNegPostDistItemsTableGrid);				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("gipiPolbasicPolDistV1TableGrid", json);
					request.setAttribute("refreshAction","getGIPIPolbasicPolDistV1ListForNegPostDist&refresh=1");
					PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp";
				}
			}else if("showDistrByTsiPremGroup".equals(ACTION)){
				if("Y".equals(request.getParameter("loadRec"))){
					JSONObject objParams = new JSONObject(request.getParameter("params"));
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getGIUWS016Rec");
					params.put("moduleId", "GIUWS016");
					params.put("userId", USER.getUserId());
					params.put("lineCd", objParams.get("lineCd"));
					params.put("sublineCd", objParams.get("sublineCd"));
					params.put("issCd", objParams.get("issCd"));
					params.put("issueYy", objParams.get("issueYy"));
					params.put("polSeqNo", objParams.get("polSeqNo"));
					params.put("renewNo", objParams.get("renewNo"));
					params.put("distNo", objParams.get("distNo"));
					Map<String, Object> map = TableGridUtil.getTableGrid(request, params);				
					JSONObject json = new JSONObject(map);	
					request.setAttribute("polRec", json);
				}
				request.setAttribute("loadRec", request.getParameter("loadRec"));
				PAGE = "/pages/underwriting/distribution/distByTSIPrem/distrByTsiPremGroup.jsp";;
			}else if("getGIPIPolbasicPolDistV1TSIPremGrp".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("moduleId", "GIUWS016");
				params.put("userId", USER.getUserId());
				
				Map<String, Object> gipiPolbasicPolDistV1TableGrid = TableGridUtil.getTableGrid(request, params);				
				
				JSONObject json = new JSONObject(gipiPolbasicPolDistV1TableGrid);				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("gipiPolbasicPolDistV1TableGrid", json);
					request.setAttribute("refreshAction", "getGIPIPolbasicPolDistV1TSIPremGrp&refresh=1");
					PAGE = "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp";
				}
			}else if("showDistByTsiPremPeril".equals(ACTION)){
				if("Y".equals(request.getParameter("loadRec"))){
					JSONObject objParams = new JSONObject(request.getParameter("params"));
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getGIUWS017Rec");
					params.put("moduleId", "GIUWS017");
					params.put("userId", USER.getUserId());
					params.put("lineCd", objParams.get("lineCd"));
					params.put("sublineCd", objParams.get("sublineCd"));
					params.put("issCd", objParams.get("issCd"));
					params.put("issueYy", objParams.get("issueYy"));
					params.put("polSeqNo", objParams.get("polSeqNo"));
					params.put("renewNo", objParams.get("renewNo"));
					params.put("distNo", objParams.get("distNo"));
					System.out.println("steven:::" + params);
					Map<String, Object> map = TableGridUtil.getTableGrid(request, params);				
					JSONObject json = new JSONObject(map);	
					request.setAttribute("polRec", json);
				}
				request.setAttribute("loadRec", request.getParameter("loadRec"));
				PAGE = "/pages/underwriting/distribution/distByTsiPremPeril/distByTsiPremPeril.jsp";
			}else if("showV1ListDistByTsiPremPeril".equals(ACTION)){
				polDistService.getV1ListDistByTsiPremPeril(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp" : "/pages/genericObject.jsp");
			}else if("getGiuws012Currency".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer distSeqNo = new Integer((request.getParameter("distSeqNo") == null) ? "0" : (request.getParameter("distSeqNo").isEmpty() ? "0" : request.getParameter("distSeqNo")));
				Map<String, Object> params = polDistService.getGiuws012Currency(policyId, distNo, distSeqNo);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("postQueryGiuws012".equals(ACTION)) {
				// services
				GIUWPolDistService distService = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");
				CGRefCodesService cgRefCodesService = (CGRefCodesService) APPLICATION_CONTEXT.getBean("cgRefCodesService");
				GIUWWPerildsService giuwwPerildsService = (GIUWWPerildsService) APPLICATION_CONTEXT.getBean("giuwwPerildsService");
				
				// parameters
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				String meaning = (request.getParameter("meaning") == null) ? null : (request.getParameter("meaning").isEmpty() ? null : request.getParameter("meaning"));;
				String domain = (request.getParameter("domain") == null) ? null : (request.getParameter("domain").isEmpty() ? null : request.getParameter("domain"));;
				
				// get dist flag and batch id
				Map<String, Object> params = distService.getDistFlagAndBatchId(policyId, distNo);
				
				// checkCarRefCodes
				params.put("pValue", params.get("distFlag"));
				params.put("pMeaning", meaning);
				params.put("pDomain", domain);
				cgRefCodesService.checkCharRefCodes(params);
				
				// check if giuwWperilds exists
				params.put("isExistGiuwWPerilds", giuwwPerildsService.isExistGiuwWPerildsGIUWS012(distNo));
				
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPopuMissDistRec".equals(ACTION)){
				PAGE = "/pages/underwriting/distribution/createMissingDistRecord/createMissingDistRecord.jsp";
			}else if("showV1ListPopuMissDistRec".equals(ACTION)){
				polDistService.getV1PopMissingDistRec(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/underwriting/distribution/setupGroupsForDistribution/gipiPolbasicPolDistV1Listing.jsp" : "/pages/genericObject.jsp");
			}else if("createMissingDistRec".equals(ACTION)){
				message = polDistService.createMissingDistRec(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
