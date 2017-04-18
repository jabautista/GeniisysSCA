package com.geniisys.gipi.pack.controllers;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.controllers.GIPIPARListController;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.gipi.pack.service.GIPIPackWPolBasService;
import com.geniisys.giri.entity.GIRIPackWInPolbas;
import com.geniisys.giri.pack.service.GIRIPackWInPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIPackPARListController extends BaseController {
	
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPARListController.class);
	
	public static String progess = "";
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION)  {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPackPARListService gipiPackParService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
		GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		
		try{
			if("showPackParListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				System.out.println("Menu Line Cd: " + giisLineService.getMenuLineCd(lineCd));
				PAGE = "/pages/underwriting/packPar/packParListing.jsp";
			}else if("showPackParList".equals(ACTION)){
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				String directParOpenAccess = giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS");
				System.out.println("Ora2010Sw: " + ora2010Sw);
				System.out.println("Direct Par Open Access: " + directParOpenAccess);
				request.setAttribute("ora2010Sw", ora2010Sw);
				request.setAttribute("directParOpenAccess", directParOpenAccess);
				request.setAttribute("user", new JSONObject(USER));
				if("E".equals(request.getParameter("parType"))){
					System.out.println("Show Par Listing for Endorsement Package PAR...");
					PAGE = "/pages/underwriting/packPar/subPages/endtPackParListingTable.jsp";
				}else{
					System.out.println("Show Par Listing for Package PAR...");
					PAGE = "/pages/underwriting/packPar/subPages/packParListingTable.jsp";
				}
			}else if("showEndtPackParListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				System.out.println("Menu Line Cd: " + giisLineService.getMenuLineCd(lineCd));
				PAGE = "/pages/underwriting/packPar/endtPackParListing.jsp";
				
			}else if("filterPackParListing".equals(ACTION)){
				String keyword = request.getParameter("keyword");
				String lineCd = request.getParameter("lineCd");
				String userId = USER.getAllUserSw().equals("Y") ? USER.getUserId() : "";
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo")) && !"".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				JSONArrayList searchResult;
				
				searchResult = gipiPackParService.getGipiPackParList(lineCd, pageNo, keyword, userId);
				JSONObject obj = new JSONObject(searchResult);
				message = StringFormatter.replaceTildes(obj.toString());
				
				//PaginatedList packParList = gipiPackParService.getGipiPackParList(lineCd, pageNo, keyword);
				//request.setAttribute("searchResult", packParList);
				//request.setAttribute("pageNo", pageNo);
				//request.setAttribute("noOfPages", packParList.getNoOfPages());
					
				//PAGE = "/pages/underwriting/packPar/subPages/packParListingTable.jsp";
				PAGE = "/pages/genericMessage.jsp";
			
			}else if("filterEndtPackParListing".equals(ACTION)){
				String keyword = request.getParameter("keyword");
				String lineCd = request.getParameter("lineCd");
				String userId = USER.getAllUserSw().equals("Y") ? USER.getUserId() : "";
				Integer pageNo = 0;
				
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo")) && !"".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				JSONArrayList searchResult;
				
				searchResult = gipiPackParService.getGipiEndtPackParList(lineCd, pageNo, keyword, userId);
				JSONObject obj = new JSONObject(searchResult);
				message = StringFormatter.replaceTildes(obj.toString());
				//request.setAttribute("searchResult", packEndtParList);
				//request.setAttribute("pageNo", pageNo);
				//request.setAttribute("noOfPages", packEndtParList.getNoOfPages());
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				System.out.println("Ora2010Sw: " + ora2010Sw);
				request.setAttribute("ora2010Sw", ora2010Sw);
				
				//PAGE = "/pages/underwriting/packPar/subPages/endtPackParListingTable.jsp";
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("checkRIBeforeDeleteCancel".equals(ACTION)){
				Integer packParId = Integer.parseInt(request.getParameter("packParId"));
				Map<String, Object> checkResult = new HashMap<String, Object>();
				checkResult = gipiPackParService.checkRITablesBeforeDeletion(packParId);
				String isExist = (String) checkResult.get("exist");
				System.out.println("Checking RI Tables..");
				if("".equals(isExist) || isExist == null){
					message = "Y";
				}else{
					message = isExist;
				}
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("deletePackPAR".equals(ACTION)){
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				String parNo = request.getParameter("parNo");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packParId", packParId);
				params.put("userId", USER.getUserId());
				gipiPackParService.deletePackPar(params);
				System.out.println("Deleted Package par_id = " + packParId);
				message = "PAR No. " + parNo + " has been deleted.";
				PAGE = "/pages/genericMessage.jsp";
			
			}else if("cancelPackPAR".equals(ACTION)){
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				String parStatus = request.getParameter("parStatus");
				String parNo = request.getParameter("parNo");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packParId", packParId);
				params.put("parStatus", parStatus);
				params.put("userId", USER.getUserId());
				gipiPackParService.cancelPackPar(params);
				System.out.println("Canceled Package par_id = " + packParId);
				message = "PAR No. " + parNo + " has been canceled.";
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("updatePackParRemarks".equals(ACTION)){
				JSONObject rows = new JSONObject(request.getParameter("updatedRows"));
				JSONArray updatedRows = new JSONArray(rows.getString("setRows"));
				gipiPackParService.updatePackParRemarks(updatedRows);
				message= "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("showPackPARCreationPage".equals(ACTION)){
				GIISUserFacadeService userFacade = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				String riSwitch = request.getParameter("riSwitch");
				String defaultIssCd = issServ.getDefaultIssCd(riSwitch, USER.getUserId());
				request.setAttribute("defaultIssCd", defaultIssCd);
				System.out.println("defaul issCd: "+defaultIssCd);
				Calendar cal = Calendar.getInstance();
				int year 	 = cal.get(Calendar.YEAR);
				request.setAttribute("year", year);
				//String userId = USER.getUserId();
				//System.out.println("userId: "+userId+year);
				String [] params = {"", "GIPIS050A", USER.getUserId(), riSwitch};
				String lineCd = request.getParameter("vlineCd");
				String issCd  = request.getParameter("vissCd");
				System.out.println("issCd: " + issCd);
				System.out.println("getIssCds lineCd: "+lineCd);
				System.out.println(riSwitch);
				if ("Y".equals(riSwitch)) {
					String[] parameters =  {issServ.getDefaultIssCd(riSwitch, USER.getUserId()), "GIPIS050A", USER.getUserId(), riSwitch};
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.RI_SOURCE_LISTING));
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.PACK_PAR_LINE_LISTING, parameters));
				} else {
					String[] parameters =  {issCd, "GIPIS050A", USER.getUserId(), riSwitch};
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.PACK_PAR_ISS_SOURCE_LISTING, params));
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.PACK_PAR_LINE_LISTING, parameters));
				}
				request.setAttribute("userOverrideAuthority", userFacade.giacValidateUser(USER.getUserId(), "OV", "GIPIS050A"));
				request.setAttribute("selectedLineCd", request.getParameter("lineCd")); // added by: Nica 08.18.2012
				
				//System.out.println("USER AUTHORIZED: "+userFacade.giacValidateUser(USER.getUserId(), "OV", "GIPIS050A"));
				PAGE ="/pages/underwriting/packPARCreation.jsp";
			
			}else if("showEndtPackParCreationPage".equals(ACTION)){
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				String riSwitch = request.getParameter("riSwitch");
				request.setAttribute("defaultIssCd", issServ.getDefaultIssCd(riSwitch, USER.getUserId()));
				Calendar cal = Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				request.setAttribute("year", year);
				String [] params = {"", "GIPIS056A", USER.getUserId(),riSwitch};
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("userId", USER.getUserId());
				paramMap.put("moduleId", "GIPIS056A");
				
				List<GIISLine> packLineIssue = giisLineService.getCheckedPackLineIssourceList(paramMap);
				StringFormatter.replaceQuotesInList(packLineIssue);
				
				request.setAttribute("validPackLineIssueSourceList", new JSONArray(packLineIssue));
				if ("Y".equals(riSwitch)) {
					String[] parameters = {issServ.getDefaultIssCd(riSwitch, USER.getUserId()), "GIPIS056A", USER.getUserId(), riSwitch};
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.RI_SOURCE_LISTING));
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.PACK_PAR_LINE_LISTING, parameters));
				} else {
					String[] parameters = {request.getParameter("vissCd"), "GIPIS056A", USER.getUserId(), riSwitch};
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.PACK_PAR_ISS_SOURCE_LISTING, params));
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.PACK_PAR_LINE_LISTING, parameters));
				}
				
				request.setAttribute("selectedLineCd", request.getParameter("lineCd")); // added by: Nica 08.18.2012
				PAGE ="/pages/underwriting/packPar/packParCreation/endtPackParCreation.jsp";
			}
			else if("savePackPar".equals(ACTION)) { // EDITED BY IRWIN TABISORA. MARCH 2011. ADDED LINE/SUBLINE AND VARIOUS FUNCTIONS
				GIPIPackPARList preparedPackPar = preparePackParList(request, response, USER);
				String parType = request.getParameter("parType");
				GIPIPackPARList savePackPar = null;
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("appUser", USER.getUserId());
				params.put("preparedPackPar", preparedPackPar);
				params.put("parameters", request.getParameter("parameters"));
				
				if(parType.equals("P")){
					params.put("fromPackQuotation", request.getParameter("fromPackQuotation")); //for From quotation option
					params.put("alreadySaved", request.getParameter("alreadySaved"));
					if(request.getParameter("packQuoteId") != null && !request.getParameter("packQuoteId").trim().equals("")) params.put("packQuoteId", request.getParameter("packQuoteId")); // andrew - 08.10.2011 - added condition, packQuoteId must be inserted as null if not created from package quotation 
					savePackPar = gipiPackParService.saveGIPIPackPar(params); //  added extra parameters for line/subline - irwin
				}else{// for endt
					savePackPar = gipiPackParService.saveGIPIPackPar(preparedPackPar); //gipiPackParService.createParListWPack(preparePackParList(request, response, USER)); - para sa select quotation
				}
				
				request.setAttribute("parSeqNo", savePackPar.getParSeqNo());
				request.setAttribute("packParId", savePackPar.getPackParId());
				System.out.println(savePackPar.getParSeqNo());
				savePackPar = (GIPIPackPARList) StringFormatter.replaceQuotesInObject(savePackPar);
				JSONObject jsonGIPIPackPARList = new JSONObject(savePackPar);
				JSONObject jsonGIPIPackWPolbas = null;
				request.setAttribute("jsonGIPIPackPARList", jsonGIPIPackPARList);
				request.setAttribute("jsonGIPIPackWPolbas", jsonGIPIPackWPolbas == null ? "[]" : jsonGIPIPackWPolbas);
				System.out.println("packParId=" +jsonGIPIPackPARList.getString("packParId"));
				PAGE= "/pages/underwriting/packPar/subPages/packParParameters.jsp";
				
			} else if("getIssCds".equals(ACTION)){
				String parType = request.getParameter("parType");
				String moduleId = parType == "P" ? "GIPIS050A" : "GIPIS056A";
				String[] params = {request.getParameter("lineCd"),moduleId};
				
				List<LOV> issCds = lovHelper.getList(LOVHelper.PACK_PAR_ISS_SOURCE_LISTING, params);
				JSONArray objIssCds = new JSONArray(issCds);
				System.out.println("JSON: " + objIssCds.toString());
				message= objIssCds.toString();
				PAGE = "/pages/genericMessage.jsp";
				
			} else if("getPackParSeqNo".equals(ACTION)){
				String parSeqNo = request.getParameter("globalParSeqNo");
			
				message = parSeqNo;
				//request.setAttribute("message", parSeqNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if("updateStatusFromQuote".equals(ACTION)){
				log.info("Deleting Package PAR from record...");
				int quoteId = Integer.parseInt(request.getParameter("globalQuoteId"));
				gipiPackParService.updatePackStatusFromQuote(quoteId, 99);
				message = "Deleting successful.";
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("checkPackParQuote".equals(ACTION)) {
					Integer packParId  = Integer.parseInt(request.getParameter("globalPackParId"));
					String quoteOrInfo = (gipiPackParService.checkPackParQuote(packParId) == null)? "": gipiPackParService.checkPackParQuote(packParId);
					System.out.println("answer: "+quoteOrInfo);
					message = ""+quoteOrInfo;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
			} else if ("checkIfLineSublineExist".equals(ACTION)){
				String packLineCd 		= (request.getParameter("packLineCd") == null) ? "" : request.getParameter("packLineCd");
				Integer packParId  = Integer.parseInt(request.getParameter("packParId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packParId", packParId);
				params.put("packLineCd", packLineCd);
				
				message = "SUCCESS,"+gipiPackParService.checkIfLineSublineExist(params);			
				PAGE = "/pages/genericMessage.jsp";
			} else if ("createParListWPack".equals(ACTION)) {
				GIPIPackPARListController.progess = "Initializing...";
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", Integer.parseInt(request.getParameter("quoteId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("assdNo", request.getParameter("assNo"));
				params.put("userId", USER.getUserId());
				params.put("message", "");
				gipiPackParService.createParListWPack(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkParListWPackCreationProgress".equals(ACTION)) {
				message = GIPIPackPARListController.progess;
				System.out.println("Message: " + message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPackParListTableGrid".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				String directParOpenAccess = giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				request.setAttribute("riSwitch", request.getParameter("riSwitch")); // added by : Nica 05.15.2012
				request.setAttribute("ora2010Sw", ora2010Sw);
				request.setAttribute("directParOpenAccess", directParOpenAccess);
				request.setAttribute("user", new JSONObject(USER));
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("riSwitch", request.getParameter("riSwitch"));
				System.out.println("riSwitch: "+request.getParameter("riSwitch"));
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("parType", "P");
				params.put("moduleId", "GIPIS001A");
				params = gipiPackParService.getGipiPackParListing(params);
				request.setAttribute("gipiPackParListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				
				PAGE = "/pages/underwriting/packPar/packParTableGridListing.jsp";
			}else if("refreshPackParListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("parType", "P");
				params.put("moduleId", "GIPIS001A");
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = gipiPackParService.getGipiPackParListing(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("showEndtPackParListTableGrid".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				request.setAttribute("riSwitch", request.getParameter("riSwitch")); // added by: Nica 05.15.2012
				request.setAttribute("ora2010Sw", ora2010Sw);
				request.setAttribute("user", new JSONObject(USER));
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("parType", "E");
				params.put("moduleId", "GIPIS058A");
				params = gipiPackParService.getGipiPackParListing(params);
				request.setAttribute("gipiEndtPackParListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				
				PAGE = "/pages/underwriting/packPar/endtPackParTableGridListing.jsp";
			}else if("refreshEndtPackParListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("parType", "E");
				params.put("moduleId", "GIPIS058A");
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = gipiPackParService.getGipiPackParListing(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("setPackParParameters".equals(ACTION)){
				GIPIPackWPolBasService gipiPackWPolBasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService");
				Integer packParId = Integer.parseInt(request.getParameter("packParId"));
				log.info("setPackParParameters for - "+packParId);
				GIPIPackPARList gipiPackParList = gipiPackParService.getGIPIPackParDetails(packParId);
				GIPIPackWPolBas gipiPackWPolBas = null;
				GIRIPackWInPolbas giriPackWInPolbas = null;
				
				// added condition for reinsurance -- irwin 6.6.2012
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				String defaultRIIssCd = issServ.getDefaultIssCd("Y", USER.getUserId());
				
				//JSONObject jsonGipiPackParList = new JSONObject(StringFormatter.escapeHTMLInObject(gipiPackParList)); //added by steven 12/17/2012 to escape \n,JSON.parse doesn't accept strings containing new lines
				JSONObject jsonGipiPackParList = new JSONObject(gipiPackParList); //added by steven 10/17/2013
				JSONObject jsonGipiPackWPolbas = null;
				JSONObject jsonGiriPackWInPolbas = null;
				if(defaultRIIssCd.equals(gipiPackParList.getIssCd())){
					log.info("Reinsurance");
					GIRIPackWInPolbasService giriPackWInPolbasService = (GIRIPackWInPolbasService) APPLICATION_CONTEXT.getBean("giriPackWInPolbasService");
					giriPackWInPolbas = giriPackWInPolbasService.getGiriPackWInPolbas(gipiPackParList.getPackParId());
					gipiPackWPolBas = gipiPackWPolBasService.getGIPIPackWPolBas(packParId);
					
					jsonGiriPackWInPolbas = new JSONObject(StringFormatter.escapeHTMLInObject(giriPackWInPolbas));
					jsonGipiPackWPolbas = new JSONObject(gipiPackWPolBas);
					
					request.setAttribute("jsonGiriPackWInPolbas", jsonGiriPackWInPolbas);
				}else{
					log.info("Not Reinsurance");
					gipiPackWPolBas = gipiPackWPolBasService.getGIPIPackWPolBas(packParId);
					//if( jsonGipiPackParList.getInt("parStatus") > 2){ comment out by andrew 09.02.2011
						jsonGipiPackWPolbas = new JSONObject(gipiPackWPolBas);
					//}
				}
				
				System.out.println("Pack Par Id : " + gipiPackParList.getPackParId());
				System.out.println(jsonGipiPackParList.toString());
				StringFormatter.escapeHTMLInObject(jsonGipiPackParList); //changed from replaceQuotesInObject to escapeHTMLInObject
				StringFormatter.escapeHTMLInObject(jsonGipiPackWPolbas); //changed from replaceQuotesInObject to escapeHTMLInObject
				request.setAttribute("packParId", packParId);
				request.setAttribute("jsonGIPIPackPARList", jsonGipiPackParList);
				request.setAttribute("jsonGIPIPackWPolbas", jsonGipiPackWPolbas == null ? "[]" : jsonGipiPackWPolbas);
				
				String enablePackPost = gipiPackParService.getPackSharePercentage(packParId);
				request.setAttribute("enablePackPost", enablePackPost);
				
				PAGE= "/pages/underwriting/packPar/subPages/packParParameters.jsp";
			}else if("showRIPackParCreationPage".equals(ACTION)){
				GIISUserFacadeService userserv = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				
				String defaultRIIssCd = issServ.getDefaultIssCd("Y", USER.getUserId());
				System.out.println("Default Isscd: "+defaultRIIssCd);
				request.setAttribute("mode", request.getParameter("mode"));
				request.setAttribute("parType", request.getParameter("parType"));
				request.setAttribute("defaultIssCd", defaultRIIssCd);
				request.setAttribute("automaticParAssignmentFlag", giisParametersService.getParamValueV2("AUTOMATIC_PAR_ASSIGNMENT_FLAG"));
				Calendar cal=Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				request.setAttribute("year", year%100);
				
				if(request.getParameter("mode").equals("1")){
					
				}else{ // Create new riPackPar
					log.info("CREATE RI PACK PAR");
					String[] params = {defaultRIIssCd,"GIRIS005A", USER.getUserId()};
					request.setAttribute("defaultIssCd", defaultRIIssCd);
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.PACK_PAR_LINE_LISTING, params));
				}
				PAGE = "/pages/underwriting/reInsurance/enterPackInitialAcceptance/enterPackInitialAcceptance.jsp";
			}else if ("saveRIPackPar".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				String mode = request.getParameter("mode");
				params.put("automaticParAssignmentFlag", request.getParameter("automaticParAssignmentFlag"));
				params.put("parameters", request.getParameter("parameters"));
				params.put("mode", request.getParameter("mode"));
				params.put("parType", request.getParameter("parType"));
				
				params = gipiPackParService.saveRIPackPar(params, USER.getUserId());
				
				
			//	if(mode.equals("0")){
					JSONObject jsonGIPIPackPARList = new JSONObject(StringFormatter.escapeHTMLInObject(params.get("gipiPackPARList")));
					JSONObject jsonGIRIPackWInPolBas = new JSONObject(StringFormatter.escapeHTMLInObject(params.get("giriPackWInPolbas")));
					request.setAttribute("parSeqNo",jsonGIPIPackPARList.getString("parSeqNo"));
					request.setAttribute("packParId", jsonGIPIPackPARList.getString("packParId"));
					request.setAttribute("packAcceptNo", jsonGIRIPackWInPolBas.getString("packAcceptNo"));
					request.setAttribute("jsonGIPIPackPARList", jsonGIPIPackPARList);
					//request.setAttribute("jsonGIPIPackWPolbas", jsonGIRIPackWInPolBas == null ? "[]" : jsonGIRIPackWInPolBas); replaced by: Nica 04.27.2013
					request.setAttribute("jsonGiriPackWInPolbas", jsonGIRIPackWInPolBas == null ? "[]" : jsonGIRIPackWInPolBas);
					
					GIPIPackWPolBasService gipiPackWPolBasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService");
					GIPIPackWPolBas gipiPackWPolBas = gipiPackWPolBasService.getGIPIPackWPolBas(jsonGIPIPackPARList.getInt("packParId"));
					if(gipiPackWPolBas == null){gipiPackWPolBas = new GIPIPackWPolBas();}
					request.setAttribute("jsonGIPIPackWPolbas", new JSONObject(StringFormatter.escapeHTMLInObject(gipiPackWPolBas)));
					PAGE= "/pages/underwriting/packPar/subPages/packParParameters.jsp";
				//}else{
					
			//	}
					
			}else if("checkGipis095PackPeril".equals(ACTION)){
				message = gipiPackParService.checkGipis095PackPeril(request);
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch (NumberFormatException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {			
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}
	
	private GIPIPackPARList preparePackParList(HttpServletRequest request, HttpServletResponse response, GIISUser USER){ // return type dati is Map
		GIPIPackPARList packPar = new GIPIPackPARList();
		//Map<String, Object> params = new HashMap<String, Object>();
		
		String lineCd    = request.getParameter("vlineCd");
		String issCd     = request.getParameter("vissCd");
		int parYy 		 = (Integer.parseInt(request.getParameter("year"))%100);//to just get the last two digits of the year
		int quoteSeqNo 	 = Integer.parseInt(request.getParameter("quoteSeqNo"));
		int assdNo 		 = Integer.parseInt((request.getParameter("assuredNo")=="")? "0" : request.getParameter("assuredNo"));
		String remarks   = request.getParameter("remarks");
		int packParId    = Integer.parseInt((request.getParameter("packParId") == null) ? "0" : request.getParameter("packParId"));
		int parSeqNo     = Integer.parseInt((request.getParameter("parSeqNo") == "") ? "0" : request.getParameter("parSeqNo"));
		String parType   = request.getParameter("parType");
		Integer quoteId  = ("".equals(request.getParameter("quoteId")) || request.getParameter("quoteId") == null)? null : Integer.parseInt((request.getParameter("quoteId")));
	//	String underwriter = USER.getUserId();
		
		if(assdNo != 0){
			packPar.setAssdNo(assdNo);
		}
		packPar.setIssCd(issCd); 
		packPar.setLineCd(lineCd); 
		packPar.setParYy(parYy); 
		packPar.setQuoteSeqNo(quoteSeqNo); 
		packPar.setParSeqNo(parSeqNo); 
		packPar.setRemarks(remarks); 
		packPar.setPackParId(packParId); 
		packPar.setParType(parType); 
		packPar.setQuoteId(quoteId); 
		packPar.setUnderwriter(USER.getUserId()); 
		
		/*params.put("assdNo", assdNo);
		params.put("issCd", issCd);
		params.put("lineCd", lineCd);
		params.put("parYy", parYy);
		params.put("quoteSeqNo", quoteSeqNo);
		params.put("parSeqNo", parSeqNo);
		params.put("remarks", remarks);
		params.put("packParId", packParId);
		params.put("issparType", parType);
		params.put("quoteId", quoteId);
		params.put("userId", USER.getUserId());*/
	//System.out.println("user" + USER.getUserId());
		return packPar;
		
		
	}

}
