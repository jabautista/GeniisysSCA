package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.exceptions.DistributionException;
import com.geniisys.gipi.exceptions.PostingParException;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.service.GIUWPolDistService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIUWPolDistController extends BaseController{

	private Logger log = Logger.getLogger(GIUWPolDistController.class);
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			GIUWPolDistService distService = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");
			 
			if ("showPreliminaryOneRiskDist".equals(ACTION)){
				log.info("Getting Preliminary One-Risk Distribution...");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				distService.showPreliminaryOneRiskDist(request, gipiParListService);
				PAGE = "/pages/underwriting/preliminaryOneRiskDist.jsp";
			}else if("showPreliminaryPerilDist".equals(ACTION)){
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIPackPARListService gipiPackParService;
				Integer packParId = Integer.parseInt("".equals(request.getParameter("globalPackParId")) ? "0" : request.getParameter("globalPackParId"));
				String isPack = packParId == 0 ? "N" : "Y";
				
				if ("Y".equals(isPack)) {
					gipiPackParService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
					List<GIPIPARList> gipiPolParList = (List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, null));
					GIPIPackPARList gipiPackParList = gipiPackParService.getGIPIPackParDetails(packParId);
					request.setAttribute("parPolicyList", new JSONArray(gipiPolParList));
					request.setAttribute("packParNo", gipiPackParList.getParNo());
					request.setAttribute("packAssdName", gipiPackParList.getAssdName());
				}
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("isPack", isPack);
				params.put("packParId", packParId);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", distService.giuws003NewFormInstance(params));
				request.setAttribute("isPack", isPack);
				message = "SUCCESS";
				PAGE = "/pages/underwriting/preliminaryPerilDist.jsp";
			}else if("getDistListing".equals(ACTION)){
				log.info("Getting lov listing...");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				Integer parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				String nbtLineCd = request.getParameter("nbtLineCd");
				String lineCd = request.getParameter("lineCd");
				
				String[] treaty = {parId.toString(), lineCd};
				String[] share = {nbtLineCd, lineCd}; 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distTreatyListingJSON", new JSONArray ((List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.DIST_TREATY_LISTING, treaty)))); 	
				params.put("distShareListingJSON", new JSONArray ((List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.DIST_SHARE_LISTING, share))));		
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDistTrtyShareListing".equals(ACTION)){
				log.info("Getting Treaty and Share lov listing...");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String issCd = request.getParameter("issCd");
				String issueYy = request.getParameter("issueYy");
				String polSeqNo = request.getParameter("polSeqNo");
				String renewNo = request.getParameter("renewNo");
				
				String[] treaty = {lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo};
				String[] share = {lineCd}; 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distTreatyListingJSON", new JSONArray ((List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.DIST_TREATY_LISTING2, treaty))));	
				params.put("distShareListingJSON", new JSONArray ((List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.DIST_SHARE_LISTING2, share))));		
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("checkDistFlag".equals(ACTION)){
				log.info("Checking dist flag...");
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) || request.getParameter("distNo") == null ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) || request.getParameter("distSeqNo") == null ? "0" : request.getParameter("distSeqNo"));
				String count = distService.checkDistFlag(distNo, distSeqNo);
				message = count;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkDistFlagGiuws003".equals(ACTION)) {
				log.info("Checking dist flag...");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				distService.checkDistFlagGiuws003(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("compareGipiItemItmperil".equals(ACTION)){
				log.info("Compare gipi_item_itmperil...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
				params =  distService.compareGipiItemItmperil(params);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("compareGipiItemItmperil2".equals(ACTION)){
				log.info("Compare gipi_item_itmperil...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
				params =  distService.compareGipiItemItmperil2(params);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("createItems".equals(ACTION)){
				log.info("Creating items...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("polFlag", request.getParameter("polFlag"));
				params.put("parType", request.getParameter("parType"));
				params.put("userId", USER.getUserId());
				params.put("label", request.getParameter("label"));		//added by Gzelle 06132014
				System.out.println("CREATE ITEMS PARAMS: " + params);
				params =  distService.createItems(params);
				params.put("newItems", new JSONObject((GIUWPolDist) StringFormatter.replaceQuotesInObject(params.get("newItems"))));
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDist".equals(ACTION)){
				log.info("Posting distribution...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("moduleId", "GIUWS004");
				params.put("userId", USER.getUserId());
				params.put("currentFormName", "GIUWS004");
				params.put("overrideSwitch", "Y"); // added by: Nica 05.25.2012 - to temporarily insert records to distribution table for retrieval
				params =  distService.postDist(params, request.getParameter("parameters"), USER);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("savePrelimOneRiskDist".equals(ACTION)){
				log.info("Saving Preliminary One-Risk Distribution...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = distService.savePrelimOneRiskDist(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showSetUpGroupsForPrelimDist".equals(ACTION)){
				log.info("Getting SetUp Group For Preliminary Distribution...");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIPackPARListService gipiPackParService;
				Integer parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				Integer packParId = Integer.parseInt("".equals(request.getParameter("globalPackParId")) ? "0" : request.getParameter("globalPackParId"));
				String isPack = packParId == 0 ? "N" : "Y";
				
				if ("Y".equals(isPack)) {
					gipiPackParService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
					List<GIPIPARList> gipiPolParList = (List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, null)) ;
					GIPIPackPARList gipiPackParList = gipiPackParService.getGIPIPackParDetails(packParId);
					request.setAttribute("parPolicyList", new JSONArray(gipiPolParList));
					request.setAttribute("packParNo", gipiPackParList.getParNo());
					request.setAttribute("packAssdName", gipiPackParList.getAssdName());
				}
				
				request.setAttribute("isPack", isPack);
				request.setAttribute("forSetUpGroupsDist", "Y");
				request.setAttribute("GIUWPolDistJSON", new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(("Y".equals(isPack) ? distService.getPackGIUWPolDist(packParId) : distService.getGIUWPolDist2(parId)))));
				PAGE = "/pages/underwriting/setUpGroupsForPrelimDist.jsp";
			}else if("createItems2".equals(ACTION)){
				log.info("Creating items...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("polFlag", request.getParameter("polFlag"));
				params.put("parType", request.getParameter("parType"));
				params.put("itemGrp", request.getParameter("itemGrp"));
				params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
				params.put("label", request.getParameter("label"));
				params.put("userId", USER.getUserId());
				params =  distService.createItems2(params);
				params.put("newItems", new JSONObject((GIUWPolDist) StringFormatter.escapeHTMLInObject(params.get("newItems"))));
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveSetupGroupDist".equals(ACTION)){
				message = distService.saveSetupGroupDist(request.getParameter("parameters"), USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getVPolFlag".equals(ACTION)) {
				GIPIWPolbasService wpolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				String polFlag = request.getParameter("polFlag") == null ? null : request.getParameter("polFlag");
				Integer parId = request.getParameter("parId") == null ? null : Integer.parseInt(request.getParameter("parId"));
				parId = wpolbasService.getWpolbasParIdByPolFlag(polFlag, parId);
				
				if (parId == null) {
					message = "1";
				} else {
					message = "2";
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if("createItemsGiuws003".equals(ACTION)){
				log.info("Creating items...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("polFlag", request.getParameter("polFlag"));
				params.put("parType", request.getParameter("parType"));
				params.put("userId", USER.getUserId());
				params =  distService.createItemsGiuws003(params);
				params.put("newItems", new JSONObject((GIUWPolDist) StringFormatter.escapeHTMLInObject(params.get("newItems"))));
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws003".equals(ACTION)){
				log.info("Posting distribution...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("moduleId", "GIUWS003");
				params.put("userId", USER.getUserId());
				params.put("currentFormName", "GIUWS003");
				params =  distService.postDistGiuws003(params, request.getParameter("parameters"), USER);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("savePrelimPerilDist".equals(ACTION)){
				log.info("Saving Preliminary Peril Distribution...");
				String isPack = (request.getParameter("isPack") == null) ? "N" : request.getParameter("isPack").toString();
				Map<String, Object> params = new HashMap<String, Object>();
				params = distService.savePrelimPerilDist(request.getParameter("parameters"), USER, isPack);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkDistMenu".equals(ACTION)){
				message = new JSONObject(distService.checkDistMenu(request, USER, APPLICATION_CONTEXT)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPreliminaryOneRiskDistTsiPrem".equals(ACTION)){
				log.info("Getting Preliminary One-Risk Distribution by Tsi/Prem...");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				
				System.out.println("parId: " + request.getParameter("globalParId") + "packParId: " + request.getParameter("globalPackParId"));
				
				Integer initialParSelected = Integer.parseInt((request.getParameter("initialParSelected") == "" || request.getParameter("initialParSelected") == null) ? "0" : request.getParameter("initialParSelected"));
				Integer parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				Integer packParId = Integer.parseInt("".equals(request.getParameter("globalPackParId")) ? "0" : request.getParameter("globalPackParId"));
				String isPack = packParId == 0 ? "N" : "Y";
				
				List<GIPIPARList> gipiPolParList = (List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, null)) ;
				request.setAttribute("parPolicyList", new JSONArray(gipiPolParList));
				System.out.println("ISPACK: " + isPack);
				request.setAttribute("isPack", isPack);
				
				if ("Y".equals(isPack) && initialParSelected == 0){
					parId = gipiPolParList.get(0).getParId();
					System.out.println("NEW PAR ID!!!!" + parId);
				}else {					
					if (packParId != 0) {
						parId = initialParSelected;
					}
				}
				request.setAttribute("parId", initialParSelected == 0 ? parId : initialParSelected);
				request.setAttribute("forDist", "Y");
				request.setAttribute("GIUWPolDistJSON", new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getGIUWPolDist(parId, "GIUWS005"))));
				PAGE = "/pages/underwriting/preliminaryOneRiskDistByTsiPrem.jsp";
			}else if("showPreliminaryPerilDistByTsiPrem".equals(ACTION)){
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				
				System.out.println("parId: " + request.getParameter("globalParId") + "packParId: " + request.getParameter("globalPackParId"));
				
				Integer initialParSelected = Integer.parseInt((request.getParameter("initialParSelected") == "" || request.getParameter("initialParSelected") == null) ? "0" : request.getParameter("initialParSelected"));
				Integer parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				Integer packParId = Integer.parseInt("".equals(request.getParameter("globalPackParId")) ? "0" : request.getParameter("globalPackParId"));
				String isPack = packParId == 0 ? "N" : "Y";
				
				List<GIPIPARList> gipiPolParList = (List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, null)) ;
				request.setAttribute("parPolicyList", new JSONArray(gipiPolParList));
				System.out.println("ISPACK: " + isPack);
				request.setAttribute("isPack", isPack);
				
				if ("Y".equals(isPack) && initialParSelected == 0){
					parId = gipiPolParList.get(0).getParId();
					System.out.println("NEW PAR ID!!!!" + parId);
				}else {					
					if (packParId != 0) {
						parId = initialParSelected;
					}
				}
				request.setAttribute("parId", initialParSelected == 0 ? parId : initialParSelected);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				params.put("newParId", parId);
				params.put("moduleId", "GIUWS006");
				request.setAttribute("formMap", distService.giuws003NewFormInstance(params));
				message = "SUCCESS";
				PAGE = "/pages/underwriting/preliminaryPerilDistByTsiPrem.jsp";
			}else if("savePrelimPerilDistByTsiPrem".equals(ACTION)){
				log.info("Saving Preliminary Peril Distribution by TSI/Prem...");
				message = new JSONObject(distService.savePrelimPerilDistByTsiPrem(request.getParameter("parameters"), USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("createItemsGiuws006".equals(ACTION)){
				log.info("Creating items...");
				message = new JSONObject(distService.createItemsGiuws006(request, USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("savePrelimOneRiskDistByTsiPrem".equals(ACTION)){
				log.info("Saving Preliminary One-Risk Distribution By Tsi/Prem...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = distService.savePrelimOneRiskDistByTsiPrem(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if("createItemsGiuws005".equals(ACTION)){
				log.info("Creating items...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("polFlag", request.getParameter("polFlag"));
				params.put("parType", request.getParameter("parType"));
				params.put("userId", USER.getUserId());
				params =  distService.createItemsGiuws005(params);
				params.put("newItems", new JSONObject((GIUWPolDist) StringFormatter.replaceQuotesInObject(params.get("newItems"))));
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws006".equals(ACTION)){
				log.info("Posting distribution...");
				message = new JSONObject(distService.postDistGiuws006(request, request.getParameter("parameters"), USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws005".equals(ACTION)){
				log.info("Posting distribution...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("moduleId", "GIUWS005");
				params.put("userId", USER.getUserId());
				params.put("currentFormName", "GIUWS005");
				params =  distService.postDistGiuw005(params, request.getParameter("parameters"), USER);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("loadDistByGroupsGIUWS013JSON".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", request.getParameter("parId"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("distNo", request.getParameter("distNo"));
				log.info("LOADING PAR_ID: " + Integer.parseInt(request.getParameter("parId")) + " Policy_id: " + request.getParameter("policyId"));
				message = new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getGIUWPolDistGiuws013(params))).toString();
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws013".equals(ACTION)){
				log.info("Posting distribution...");
				Integer policyId = Integer.parseInt("".equals(request.getParameter("policyId")) ? "0" : request.getParameter("policyId"));
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("effDate", sdf.parse(request.getParameter("effDate")));
				params.put("endtSeqNo", "".equals(request.getParameter("endtSeqNo")) ? "0" : Integer.parseInt(request.getParameter("endtSeqNo")));
				params.put("batchId", "".equals(request.getParameter("batchId")) ? "0" : Integer.parseInt(request.getParameter("batchId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", "".equals(request.getParameter("issueYy")) ? "0" : Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", "".equals(request.getParameter("polSeqNo")) ? "0" : Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", "".equals(request.getParameter("renewNo")) ? "0" : Integer.parseInt(request.getParameter("renewNo")));
				params.put("userId", USER.getUserId());
				distService.postDistGiuws013(params);
				//message = "SUCCESS";
				message = params.get("faculSw").toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGIUWPolDistForPerilDistribution".equals(ACTION)){
				Integer parId = new Integer(request.getParameter("parId") == null ? "0" : (request.getParameter("parId").toString().isEmpty() ? "0" : request.getParameter("parId")));
				Integer distNo = new Integer(request.getParameter("distNo") == null ? "0" : (request.getParameter("distNo").toString().isEmpty() ? "0" : request.getParameter("distNo")));
				log.info("Loading dist by Par Id " + parId + " and Dist No. " + distNo);
				message = new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getGIUWPolDistForPerilDistribution(parId, distNo))).toString();
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveOneRiskDistGiuws013".equals(ACTION)){
				log.info("Saving One-Risk Distribution...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = distService.saveOneRiskDistGiuws013(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveDistributionByPeril".equals(ACTION)){
				log.info("Saving Distribution by Peril...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = distService.saveDistributionByPeril(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("loadPostedDistGIUTS002JSON".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", request.getParameter("parId"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("distNo", request.getParameter("distNo"));
				log.info("LOADING PAR_ID: " + Integer.parseInt(request.getParameter("parId")) + " Policy_id: " + request.getParameter("policyId"));
				message = new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getGIUWPolDistGiuts002(params))).toString();
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("negDistGIUTS002".equals(ACTION)) {
				log.info("Distribution Negation");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId") == null ? "" : request.getParameter("policyId"));
				params.put("distNo", request.getParameter("distNo") == null ? "" : request.getParameter("distNo"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("tempDistNo", "");
				params.put("msg", "");
				params.put("curFormName", "GIUTS002");
				params.put("parId", request.getParameter("parId") == null ? "" : request.getParameter("parId"));
				params.put("workflowMsgr", "");
				params.put("userId", USER.getUserId());
				params = distService.negDistGiuts002(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				String workflowMsgr = (String) (params.get("workflowMsgr") == null ? "" : params.get("workflowMsgr"));
				message = msg +","+ workflowMsgr;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkExistingClaimGiuts002".equals(ACTION)) {
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				Date effDate = request.getParameter("effDate").equals("") ? null : sdf.parse(request.getParameter("effDate"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy") == null ? "" : request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo") == null ? "" : request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo") == null ? "" : request.getParameter("renewNo"));
				params.put("effDate", effDate);
				params.put("endtSeqNo", request.getParameter("endtSeqNo") == null ? "" : request.getParameter("endtSeqNo"));
				params.put("msg", "");
				params = distService.checkExistingClaimGiuts002(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message = msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("loadDistributionByTsiPremGroup".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("distNo", request.getParameter("distNo"));
				params.put("parType", request.getParameter("parType"));
				params.put("polFlag", request.getParameter("polFlag"));
				message = new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getGIUWPolDistGiuws016(params))).toString();
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("loadDistByTsiPremPeril".equals(ACTION)){
				message = new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getDistByTsiPremPeril(request, USER))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws012".equals(ACTION)){
				log.info("Posting distribution...");
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				Integer policyId = Integer.parseInt("".equals(request.getParameter("policyId")) ? "0" : request.getParameter("policyId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", "".equals(request.getParameter("issueYy")) ? null : Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", "".equals(request.getParameter("polSeqNo")) ? null : Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", "".equals(request.getParameter("renewNo")) ? null : Integer.parseInt(request.getParameter("renewNo")));
				params.put("endtSeqNo", "".equals(request.getParameter("endtSeqNo")) ? null : Integer.parseInt(request.getParameter("endtSeqNo")));
				params.put("effDate", sdf.parse(request.getParameter("effDate")));
				params.put("batchId", "".equals(request.getParameter("batchId")) ? null : Integer.parseInt(request.getParameter("batchId")));
				params.put("parType", request.getParameter("parType"));
				params = distService.postDistGiuws012(params);
				
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				paramsOut.put("msgAlert", params.get("msgAlert"));
				paramsOut.put("workflowMsgr", params.get("workflowMsgr"));
				paramsOut.put("vFaculSw", params.get("vFaculSw"));
				JSONObject result = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveDistByTsiPremPeril".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = distService.saveDistByTsiPremPeril(request.getParameter("parameters"), USER);
				if (params.get("workflowMsg") != null){
					Runtime rt=Runtime.getRuntime();
					rt.exec((String) params.get("workflowMsg"));
				}
				message = new JSONObject(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveDistrByTSIPremGroup".equals(ACTION)){
				distService.saveDistrByTSIPremGroup(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws016".equals(ACTION)){
				log.info("Posting distribution...");
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				Integer policyId = Integer.parseInt("".equals(request.getParameter("policyId")) ? "0" : request.getParameter("policyId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("parType", request.getParameter("parType"));
				params.put("polFlag", request.getParameter("polFlag"));
				params.put("issueYy", "".equals(request.getParameter("issueYy")) ? null : Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", "".equals(request.getParameter("polSeqNo")) ? null : Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", "".equals(request.getParameter("renewNo")) ? null : Integer.parseInt(request.getParameter("renewNo")));
				params.put("distSeqNo", "".equals(request.getParameter("distSeqNo")) ? null : Integer.parseInt(request.getParameter("distSeqNo")));
				params.put("effDate", sdf.parse(request.getParameter("effDate")));
				params.put("batchId", "".equals(request.getParameter("batchId")) ? null : Integer.parseInt(request.getParameter("batchId")));
				params = distService.postDistGiuws016(params);
				
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				paramsOut.put("msgAlert", params.get("msgAlert"));
				paramsOut.put("workflowMsgr", params.get("workflowMsgr"));
				paramsOut.put("vFaculSw", params.get("vFaculSw"));
				JSONObject result = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getDistFlagAndBatchId".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Map<String, Object> params = distService.getDistFlagAndBatchId(policyId, distNo);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGIUWPolDistForRedistribution".equals(ACTION)){
				Integer parId = new Integer(request.getParameter("parId") == null ? "0" : (request.getParameter("parId").toString().isEmpty() ? "0" : request.getParameter("parId")));
				Integer distNo = new Integer(request.getParameter("distNo") == null ? "0" : (request.getParameter("distNo").toString().isEmpty() ? "0" : request.getParameter("distNo")));
				log.info("Loading dist by Par Id " + parId + " and Dist No. " + distNo);
				message = new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(distService.getGIUWPolDistForRedistribution(parId, distNo))).toString();
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("negateDistributionGiuts021".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer tempDistNo = new Integer((request.getParameter("tempDistNo") == null) ? "0" : (request.getParameter("tempDistNo").isEmpty() ? "0" : request.getParameter("tempDistNo")));
				Integer negDistNo = new Integer((request.getParameter("negDistNo") == null) ? "0" : (request.getParameter("negDistNo").isEmpty() ? "0" : request.getParameter("negDistNo")));
				String renewFlag = request.getParameter("renewFlag");
				String redistributionDate = request.getParameter("redistributionDate");
				String expiryDate = request.getParameter("expiryDate");
				String effDate = request.getParameter("effDate");
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String forSaving = request.getParameter("forSaving");
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("userId", USER.getUserId());
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				params.put("tempDistNo", tempDistNo);
				params.put("negDistNo", negDistNo);
				params.put("renewFlag", renewFlag);
				params.put("redistributionDate", redistributionDate);
				params.put("expiryDate", expiryDate);
				params.put("effDate", effDate);
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("forSaving", forSaving);
				
				distService.negateDistributionGiuts021(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveRedistribution".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				
				distService.saveRedistribution(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("endRedistributionTransaction".equals(ACTION)) {
				distService.endRedistributionTransaction();
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDistListing2".equals(ACTION)){
				log.info("Getting lov listing...");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				Integer parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				String nbtLineCd = request.getParameter("nbtLineCd");
				String lineCd = request.getParameter("lineCd");
				
				String[] treaty = {parId.toString(), lineCd};
				String[] share = {nbtLineCd, lineCd}; 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distTreatyListingJSON", new JSONArray ((List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.DIST_TREATY_LISTING3, treaty))));	
				params.put("distShareListingJSON", new JSONArray ((List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.DIST_SHARE_LISTING, share))));		
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateExistingDist".equals(ACTION)){
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				request.setAttribute("object", new JSONObject(distService.validateExistingDist(params)));
				PAGE = "/pages/genericObject.jsp";
			}else if("adjustPerilDistTables".equals(ACTION)){  //added action for Adjusting Distribution edgar 04/28/2014
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				request.setAttribute("object", new JSONObject(distService.adjustPerilDistTables(params)));
				PAGE = "/pages/genericObject.jsp";
			}else if("recomputePerilDistPrem".equals(ACTION)){  //added action for recomputing Distribution Premium amounts edgar 04/29/2014
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer (request.getParameter("parId"));
				String isPack = request.getParameter("isPack");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params.put("isPack", isPack);
				Map<String, Object> paramsOut = distService.recomputePerilDistPrem(params);
				//request.setAttribute("object", new JSONObject(distService.recomputePerilDistPrem(params)));
				//PAGE = "/pages/genericObject.jsp";
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("compareWitemPerilToDs".equals(ACTION)){  //added action for comparing Distribution tables and Itemperil table edgar 05/05/2014
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				Map<String, Object> paramsOut = distService.compareWitemPerilToDs(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPerilType".equals(ACTION)){  //added action for getting peril type for comparison edgar 05/05/2014
				String lineCd = request.getParameter("lineCd");
				Integer perilCd = new Integer(request.getParameter("perilCd"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("perilCd", perilCd);
				Map<String, Object> paramsOut = distService.getPerilType(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getTreatyExpiry".equals(ACTION)){  //added action for getting expiry date of share for comparison edgar 05/06/2014
				String lineCd = request.getParameter("lineCd");
				Integer shareCd = new Integer(request.getParameter("shareCd"));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("shareCd", shareCd);
				params.put("parId", parId);
				Map<String, Object> paramsOut = distService.getTreatyExpiry(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("unpostDist".equals(ACTION)){  //added action for unposting of GIUWS003 distribution edgar 05/06/2014
				Integer distNo = new Integer(request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("updateDistNo", distNo);
				distService.unpostDist(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("recomputeAfterCompare".equals(ACTION)){  //added action for recompute and adjust before posting edgar 05/07/2014
				Integer distNo = new Integer(request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				Map<String, Object> paramsOut = distService.recomputeAfterCompare(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getTakeUpTerm".equals(ACTION)){  //added action for getting takeup term edgar 05/08/2014
				Integer parId = new Integer(request.getParameter("parId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				Map<String, Object> paramsOut = distService.getTakeUpTerm(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateGIUWS017DistSpct1".equals(ACTION)) {
				distService.updateGIUWS017DistSpct1(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPolicyTakeUp".equals(ACTION)){
				Integer policyId = new Integer(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				Map<String, Object> paramsOut = distService.getPolicyTakeUp(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("comparePolItmperilToDs".equals(ACTION)){
				Integer policyId = new Integer(request.getParameter("policyId"));
				Integer distNo = new Integer(request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				params.put("distNo", distNo);
				Map<String, Object> paramsOut = distService.comparePolItmperilToDs(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("compareWitemPerilToDsGIUWS004".equals(ACTION)){  //added action for comparing Distribution tables and Itemperil table for One Risk edgar 05/05/2014
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				Map<String, Object> paramsOut = distService.compareWitemPerilToDsGIUWS004(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("adjustDistPremGIUWS004".equals(ACTION)){  //added action for recomputing Distribution Premium amounts on GIUWS004, GIUWS013 edgar 05/12/2014
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params = distService.adjustDistPremGIUWS004(params);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("adjustAllWTablesGIUWS004".equals(ACTION)){ //Adjust all working distribution tables for GIUWS004, GIUWS013 edgar 05/12/2014
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params = distService.adjustAllWTablesGIUWS004(params);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDistScpt1Val".equals(ACTION)){//Determines if distSpct1 is equal or not to distSpct edgar 05/13/2014
				Integer distNo = new Integer(request.getParameter("distNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				Map<String, Object> paramsOut = distService.getDistScpt1Val(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateDistSpct1ToNull".equals(ACTION)){  //added action for updating distSpct1 to null on GIUWS004, GIUWS013 edgar 05/12/2014
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params = distService.updateDistSpct1ToNull(params);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteReinsertGIUWS004".equals(ACTION)){  //added action for updating distSpct1 to null on GIUWS004, GIUWS013 edgar 05/12/2014
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				params = distService.deleteReinsertGIUWS004(params);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("compareDelRinsrtWdistTable".equals(ACTION)){
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				distService.compareDelRinsrtWdistTable(distNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			}else if("updateAutoDistGIUWS005".equals(ACTION)){
				distService.updateAutoDistGIUWS005(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("compareWdistTables".equals(ACTION)){  
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				message = distService.compareWdistTable(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getWpolbasGIUWS005".equals(ACTION)){  
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				message = new JSONObject(distService.getWpolbasGIUWS005(parId)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("compareDelRinsrtWdistTableGIUWS004".equals(ACTION)){
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				distService.compareDelRinsrtWdistTableGIUWS004(distNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("cmpareDelRinsrtWdistTbl1GIUWS004".equals(ACTION)){
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				distService.cmpareDelRinsrtWdistTbl1GIUWS004(distNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			}else if ("postDistGiuws004Final".equals(ACTION)){
				log.info("Posting distribution...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("moduleId", "GIUWS004");
				params.put("userId", USER.getUserId());
				params.put("currentFormName", "GIUWS004");
				params.put("overrideSwitch", "Y"); // added by: Nica 05.25.2012 - to temporarily insert records to distribution table for retrieval
				params =  distService.postDistGiuws004Final(params, request.getParameter("parameters"), USER);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkBinderExist".equals(ACTION)){
				Integer policyId = Integer.parseInt("".equals(request.getParameter("policyId")) || request.getParameter("policyId") == null ? "0" : request.getParameter("policyId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) || request.getParameter("distNo") == null ? "0" : request.getParameter("distNo"));
				String count = distService.checkBinderExist(policyId, distNo);
				message = count;
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkNullDistPremGIUWS006".equals(ACTION)){  
				message = new JSONObject(distService.checkNullDistPremGIUWS006(request)).toString();
				System.out.println("********* "+message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("populateWitemPerilDtl".equals(ACTION)){  
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				distService.populateWitemPerilDtl(distNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkSumInsuredPremGIUWS006".equals(ACTION)){  
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				message = distService.checkSumInsuredPremGIUWS006(distNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateB4PostGIUWS006".equals(ACTION)){  
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", distNo);
				params.put("parId", parId);
				message = distService.validateB4PostGIUWS006(params);
				PAGE = "/pages/genericObject.jsp";
			}else if ("postDistGiuws003Final".equals(ACTION)){//edgar 06/10/2014
				log.info("Posting distribution...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("moduleId", "GIUWS003");
				params.put("userId", USER.getUserId());
				params.put("currentFormName", "GIUWS003");
				params =  distService.postDistGiuws003Final(params, request.getParameter("parameters"), USER);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("postDistGiuws006Final".equals(ACTION)){
				log.info("Posting distribution...");
				message = new JSONObject(distService.postDistGiuws006Final(request, request.getParameter("parameters"), USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateRenumItemNos".equals(ACTION)){
				distService.validateRenumItemNos(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("postDistGiuws005Final".equals(ACTION)){
				log.info("Posting distribution final...");
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
				Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("distSeqNo", distSeqNo);
				params.put("moduleId", "GIUWS005");
				params.put("userId", USER.getUserId());
				params.put("currentFormName", "GIUWS005");
				params =  distService.postDistGiuw005Final(params, request.getParameter("parameters"), USER);
				JSONObject result = new JSONObject(params);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("preSaveOuterDist".equals(ACTION)){
				distService.preSaveOuterDist(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}else if("checkPostedBinder".equals(ACTION)){  //added action for checking Posted binders edgar 06/20/2014
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
				String vProcess = request.getParameter("vProcess");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("distNo", distNo);
				params.put("vProcess", vProcess);
				Map<String, Object> paramsOut = distService.checkPostedBinder(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkItemPerilAmountAndShare".equals(ACTION)){
				distService.checkItemPerilAmountAndShare(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkIfDiffPerilGroupShare".equals(ACTION)){
				Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) || request.getParameter("distNo") == null ? "0" : request.getParameter("distNo"));
				String isDiff = distService.checkIfDiffPerilGroupShare(distNo);
				message = isDiff;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateFaculPremPaytGIUTS002".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("distNo", request.getParameter("distNo") == null ? "" : request.getParameter("distNo"));
				params.put("distSeqNo", request.getParameter("distSeqNo") == null ? "" : request.getParameter("distSeqNo"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo") == null ? "" : request.getParameter("endtSeqNo"));
				params.put("msg", "");
				params = distService.validateFaculPremPaytGIUTS002(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message = msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("preValidationNegDist".equals(ACTION)){
				distService.preValidationNegDist(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			}else if ("validateTakeupGiuts021".equals(ACTION)){//edgar 09/26/2014
				distService.validateTakeupGiuts021(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			}
			
		} catch(DistributionException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(SQLException e){
			//message = ExceptionHandler.handleException(e, USER); replace by: Nica 10.24.2012 to handle customize error messages
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (PostingParException e) {		
			//message = ExceptionHandler.handleException(e, USER);   andrew 12.3.2012 - return only the exception message
			message = e.getMessage();
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
