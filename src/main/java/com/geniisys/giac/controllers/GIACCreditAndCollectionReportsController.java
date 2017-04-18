package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACSoaRepExt;
import com.geniisys.giac.entity.GIACSoaRepExtParam;
import com.geniisys.giac.service.GIACCreditAndCollectionReportsService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIACCreditAndCollectionReportsController", urlPatterns="/GIACCreditAndCollectionReportsController")
public class GIACCreditAndCollectionReportsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACCreditAndCollectionReportsController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			log.info("Initilaizing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIACCreditAndCollectionReportsService giacCreditAndCollectionReportsService = (GIACCreditAndCollectionReportsService) APPLICATION_CONTEXT.getBean("giacCreditAndCollectionReportsService");
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService"); 
			
			if("showSOABookedPolicies".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				GIACSoaRepExtParam params = giacCreditAndCollectionReportsService.getDefualtSOAParams(USER.getUserId());
				request.setAttribute("defaultSOAParams", params != null ? new JSONObject((GIACSoaRepExtParam) StringFormatter.escapeHTMLInObject(params)) : new JSONObject());
				request.setAttribute("varSOAPDC", giisParametersService.getParamValueV2("IMPLEMENTATION_SW"));
				request.setAttribute("printers", printers);
				request.setAttribute("soaRemarks", giacCreditAndCollectionReportsService.getSOARemarks());
				request.setAttribute("paramCollLetClient", giacParamService.getParamValueV2("COLL_LET_CLIENT"));
				request.setAttribute("hideSOANetAssd", giacParamService.getParamValueV2("HIDE_SOA_NET_ASSD") == null ? "N" : giacParamService.getParamValueV2("HIDE_SOA_NET_ASSD")); //Added by Jerome Bautista SR 21424 02.12.2016
				
				PAGE = "/pages/accounting/creditAndCollection/reports/statementOfAccount/statementOfAccount.jsp";
			} else if("getExtractDate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("reportDate", request.getParameter("reportDate") == null ? "" : request.getParameter("reportDate"));
				params.put("userId", USER.getUserId());
				GIACSoaRepExtParam soa = giacCreditAndCollectionReportsService.getExtractDate(params);
				JSONObject json = soa == null ? new JSONObject() : new JSONObject(soa);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractRecords".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = giacCreditAndCollectionReportsService.getSOARepDtls(request, USER.getUserId());
				JSONObject json = params == null ? new JSONObject() : new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("breakdownTaxPayments".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.breakdownTaxPayments(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("setDefaultDates".equals(ACTION)){
				GIACSoaRepExtParam params = giacCreditAndCollectionReportsService.setDefaultDates(request, USER.getUserId());
				JSONObject json = params == null ? new JSONObject() : new JSONObject((GIACSoaRepExtParam) StringFormatter.escapeHTMLInObject(params));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showRemarksOverlay".equals(ACTION)){
				request.setAttribute("soaRemarks", giacCreditAndCollectionReportsService.getSOARemarks());
				PAGE = "/pages/accounting/creditAndCollection/reports/statementOfAccount/overlay/soaRemarksOverlay.jsp";
			} else if("showPrintCollectionLetter".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				Integer intmOrAssdNo = (request.getParameter("intmOrAssdNo") != null && !request.getParameter("intmOrAssdNo").equals("")) ? Integer.parseInt(request.getParameter("intmOrAssdNo")) : null;
				
				if(request.getParameter("viewType").equals("I") || request.getParameter("viewType").equals("L")){
					params.put("intmNo", intmOrAssdNo); //set default value
					params.put("ACTION", "getIntmGSOADtls");
				} else if(request.getParameter("viewType").equals("A")){
					params.put("assdNo", intmOrAssdNo);
					params.put("ACTION", "getAssdGSOADtls");
				}
				params.put("userId", USER.getUserId());
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("soaDtlList", params == null ? new JSONObject() : new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/accounting/creditAndCollection/reports/statementOfAccount/subPages/printCollectionLetter.jsp";
				}
			} else if("getAgingIntmLOV".equals(ACTION) || "getAgingAssdLOV".equals(ACTION)){ //List All button
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				} else {
					request.setAttribute("agingIntmAssdList", params == null ? new JSONObject() : new JSONObject((Map<String, Object>)StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/accounting/creditAndCollection/reports/statementOfAccount/overlay/agingListAllOverlay.jsp";
				}
			} else if("getFilterByAgingList".equals(ACTION)){ 
				// fromButton = printCollectionLetter 	--> Print Collection Letter > Aging
				// fromButton = listAll					--> Print Collection Letter > List All > Aging
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmAssdNo", (request.getParameter("intmAssdNo") != null && !request.getParameter("intmAssdNo").equals("")) ? Integer.parseInt(request.getParameter("intmAssdNo")) : null);
				
				if(request.getParameter("viewType") != null && request.getParameter("viewType").equals("I")){
					params.put("ACTION", "getFilterByAgingIntm");					
				} else if(request.getParameter("viewType") != null && request.getParameter("viewType").equals("A")){
					params.put("ACTION", "getFilterByAgingAssd");
				}
				
				Integer index = null;	// start SR-4050 : shan 06.19.2015
				if(request.getParameter("fromButton") != null && request.getParameter("fromButton").equals("listAll")){
					System.out.println("======== LENGTH: " +request.getParameter("intmAssdList").length());
					Map<String, Object> par = new HashMap<String, Object>();
					par.put("longParam", request.getParameter("intmAssdList"));
					index = giacCreditAndCollectionReportsService.addToCollection(par);
					System.out.println("======= intm_assd_list INDEX: " + index);
					System.out.println("GET_LONG_PARAM: " + giacCreditAndCollectionReportsService.getCollElement(index));
					
					params.put("ACTION", "getListAllAging");
					params.put("viewType", request.getParameter("viewType"));
					params.put("index", index);
					if ((String) request.getParameter("filter") != null ){
						params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) request.getParameter("listFilter"))));
					}
					System.out.println("==PARAMS: " + params.toString());	// end SR-4050 : shan 06.19.2015
				}
				params.put("userId", USER.getUserId());
				params = TableGridUtil.getTableGrid(request, params);
				System.out.println("bago sa if stmt " + request.getParameter("refresh"));
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					System.out.println("toString dapat!"+request.getParameter("refresh"));
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				} else {
					System.out.println("totoong page" +request.getParameter("refresh"));
					request.setAttribute("filterByAgingList", params == null ? new JSONObject() : new JSONObject((Map<String, Object>)StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/accounting/creditAndCollection/reports/statementOfAccount/overlay/filterByAgingOverlay.jsp";
				}
				
				if(request.getParameter("fromButton") != null && request.getParameter("fromButton").equals("listAll")) giacCreditAndCollectionReportsService.deleteCollElement(index);	// SR-4050 : shan 06.19.2015
			} else if("saveCollectionLetterParams".equals(ACTION)){
				List<GIACSoaRepExt> lettersToPrintList = giacCreditAndCollectionReportsService.saveCollectionLetterParams(request, USER.getUserId());
				JSONArray json = new JSONArray(lettersToPrintList);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("fetchReprintCollnLetParams".equals(ACTION)){
				List<GIACSoaRepExt> lettersToReprintList = giacCreditAndCollectionReportsService.fetchParameters(request, USER.getUserId());
				JSONArray json = new JSONArray(lettersToReprintList);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getAssdGSOADtlsAll".equals(ACTION) || "getIntmGSOADtlsAll".equals(ACTION) 				// Print Coll Letter > Select All 
					|| "getFilterByAgingIntmAll".equals(ACTION) || "getFilterByAgingAssdAll".equals(ACTION)  	// Print Coll Letter > Aging 		> Select All
					|| "getAgingIntmLOVAll".equals(ACTION) || "getAgingAssdLOVAll".equals(ACTION) 				// Print Coll Letter > List All 	> Select All
					|| "getListAllAgingSelectAll".equals(ACTION)												// Print Coll Letter > List All > Aging > Select All
					|| "getCollnLetterListAll".equals(ACTION)){ 												// Reprint Coll Letter > Select All
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				 
				Integer intmOrAssdNo =  null;
				if(request.getParameter("intmOrAssdNo") != null && !request.getParameter("intmOrAssdNo").equals("")){
					intmOrAssdNo = Integer.parseInt(request.getParameter("intmOrAssdNo"));
				}
				if(request.getParameter("viewType") != null && request.getParameter("viewType").equals("I")){
					//if (!("getFilterByAgingIntmAll".equals(ACTION) && "getFilterByAgingAssdAll".equals(ACTION)  && "getAgingIntmLOVAll".equals(ACTION) && "getAgingAssdLOVAll".equals(ACTION))) 
					if (!"getListAllAgingSelectAll".equals(ACTION))
						params.put("intmNo", intmOrAssdNo); 
				} else if(request.getParameter("viewType") != null && request.getParameter("viewType").equals("A")){
					//if (!("getFilterByAgingIntmAll".equals(ACTION) && "getFilterByAgingAssdAll".equals(ACTION)  && "getAgingIntmLOVAll".equals(ACTION) && "getAgingAssdLOVAll".equals(ACTION))) 
					if (!"getListAllAgingSelectAll".equals(ACTION))
						params.put("assdNo", intmOrAssdNo);
				}
				params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
				
				if ((String) params.get("filter") != null ){
					params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
				}
				Integer index = null;	// start SR-4050 : shan 06.19.2015
				if ("getListAllAgingSelectAll".equals(ACTION)){
					Map<String, Object> par = new HashMap<String, Object>();
					par.put("longParam", request.getParameter("fromButton").equals("printCollectionLetter") ? intmOrAssdNo : request.getParameter("intmAssdList"));
					index = giacCreditAndCollectionReportsService.addToCollection(par);
					System.out.println("======= intm_assd_list INDEX: " + index);
					System.out.println("GET_LONG_PARAM: " + giacCreditAndCollectionReportsService.getCollElement(index));
					
					params.put("viewType", request.getParameter("viewType"));
					params.put("intmAssdList", request.getParameter("fromButton").equals("printCollectionLetter") ? intmOrAssdNo : request.getParameter("intmAssdList"));
					params.put("index", index);
					if ((String) request.getParameter("filter") != null ){
						params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) request.getParameter("listFilter"))));
					}
					System.out.println("==PARAMS: " + params.toString());	// end SR-4050 : shan 06.19.2015
				}
				
				params.put("userId", USER.getUserId());
				
				List<GIACSoaRepExt> allRecords = giacCreditAndCollectionReportsService.selectAllRecords(params);
				JSONArray json = new JSONArray(allRecords);
				if ("getListAllAgingSelectAll".equals(ACTION)) giacCreditAndCollectionReportsService.deleteCollElement(index);	// SR-4050 : shan 06.19.2015
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("processIntmOrAssd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("viewType", request.getParameter("viewType"));
				message = giacCreditAndCollectionReportsService.processIntmOrAssd(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("processIntmOrAssd2".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("viewType", request.getParameter("viewType"));
				params.put("assdNo", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? Integer.parseInt(request.getParameter("assdNo")) : null);
				params.put("intmNo", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
				params.put("agingId", request.getParameter("agingId")); /*(request.getParameter("agingId") != null && !request.getParameter("agingId").equals("")) ? Integer.parseInt(request.getParameter("agingId")) : null*/
				params.put("userId", USER.getUserId());
				params.put("agingIdList", request.getParameter("agingIdList"));
				params.put("assdNoList", request.getParameter("assdNoList"));
				params.put("intmNoList", request.getParameter("intmNoList"));
				params.put("fromButton", request.getParameter("fromButton"));
				/*List<GIACSoaRepExt> processedList = giacCreditAndCollectionReportsService.processIntmOrAssd2(params);
				JSONArray json = processedList == null ? new JSONArray() : new JSONArray(processedList);
				
				if(processedList != null){
					giacCreditAndCollectionReportsService.checkExistingReport(request.getParameter("reportId"));
				}*/
				
				String isExisting = giacCreditAndCollectionReportsService.processIntmOrAssd2(params);
				if(isExisting.equalsIgnoreCase("Y")){
					giacCreditAndCollectionReportsService.checkExistingReport(request.getParameter("reportId"));
				}
				
				//message = json.toString();
				message = isExisting;
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCollnLetterList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				} else {
					request.setAttribute("collnLetterList", params == null ? new JSONObject() : new JSONObject((Map<String, Object>)StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/accounting/creditAndCollection/reports/statementOfAccount/subPages/reprintCollectionLetter.jsp";
				}
			} else if("checkUserData".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.checkUserDate(USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showAgingOfCollections".equals(ACTION)){		//added by kenneth L. for aging of collections 07.02.2013
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				Map<String, Object> params = giacCreditAndCollectionReportsService.getLastExtractParam(USER.getUserId());
				String fromDate = (String) params.get("fromDate");
				request.setAttribute("extractExist", "Y");
				if(fromDate == "" || fromDate == null){
					request.setAttribute("extractExist", "N");
				}
				request.setAttribute("fromDate", params.get("fromDate"));
				request.setAttribute("toDate", params.get("toDate"));
				request.setAttribute("extractBy", params.get("extractBy"));
				request.setAttribute("issCd", params.get("issCd"));
				request.setAttribute("issName", params.get("issName"));
				PAGE = "/pages/accounting/creditAndCollection/reports/agingOfCollections/agingOfCollections.jsp";
			}else if("extractAgingOfCollections".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.extractAgingOfCollections(USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("inserToAgingExt".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.inserToAgingExt(request, USER);
				PAGE = "/pages/genericMessage.jsp";					//end by kenneth L.
			} else if("showAgingOfPremRec".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/creditAndCollection/reports/agingOfPremRec/agingOfPremRec.jsp";
			} else if("giacs329ValidateDateParams".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.giacs329ValidateDateParams(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractGIACS329".equals(ACTION)){
				JSONObject result = new JSONObject(giacCreditAndCollectionReportsService.extractGIACS329(request, USER));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkExistingReport".equals(ACTION)){
				giacCreditAndCollectionReportsService.checkExistingReport(request.getParameter("reportId"));
			} else if("showBillingStatement".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/creditAndCollection/reports/billingStatement/billingStatement.jsp";
			}else if("showPaidPremiumsPerIntermediary".equals(ACTION)){		//kenneth L. for paid premiums per intermediary 07.10.2013
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/creditAndCollection/reports/paidPremiumsPerIntermediary/paidPremiumsPerIntermediary.jsp";
			} else if("giacs480ValidateDateParams".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.giacs480ValidateDateParams(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractGIACS480".equals(ACTION)){
				JSONObject result = new JSONObject(giacCreditAndCollectionReportsService.extractGIACS480(request, USER));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showTotalCollections".equals(ACTION)){		//added by john dolon 8.7.2013
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/creditAndCollection/reports/totalCollections/totalCollections.jsp";
			} else if("whenNewFormInstanceGIACS329".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.whenNewFormInstanceGIACS329(USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("whenNewFormInstanceGIACS480".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.whenNewFormInstanceGIACS480(USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkUserChildRecords".equals(ACTION)){
				message = giacCreditAndCollectionReportsService.checkUserChildRecords(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getDefaultSOAParams".equals(ACTION)){	// SR-4129 : shan 06.19.2015
				GIACSoaRepExtParam params = giacCreditAndCollectionReportsService.getDefualtSOAParams(USER.getUserId());
				message = (params != null ? new JSONObject((GIACSoaRepExtParam) StringFormatter.escapeHTMLInObject(params)) : new JSONObject()).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
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
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	

}
