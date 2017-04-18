package com.geniisys.giri.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReinsurerService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.entity.GIRIBinder;
import com.geniisys.giri.service.GIRIBinderService;
import com.geniisys.giri.service.GIRIDistFrpsService;
import com.geniisys.giri.service.GIRIWFrpsRiService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIRIWFrpsRiController extends BaseController{

	private Logger log = Logger.getLogger(GIRIWFrpsRiController.class);
	private static final long serialVersionUID = 1L;
	
	private PrintServiceLookup printServiceLookup;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIRIBinderService giriBinderService = (GIRIBinderService) APPLICATION_CONTEXT.getBean("giriBinderService");
		try{
			log.info("Initializing: "+this.getClass().getSimpleName());
			GIRIWFrpsRiService giriwFrpsRiService = (GIRIWFrpsRiService) APPLICATION_CONTEXT.getBean("giriWFrpsRiService");
			
			if ("showCreateRiPlacementPage".equals(ACTION)){
				log.info("Getting Create RI Placement...");
				GIRIDistFrpsService giriDistFrpsService = (GIRIDistFrpsService) APPLICATION_CONTEXT.getBean("giriDistFrpsService");
				giriDistFrpsService.getDistFrpsWDistFrpsV(request, APPLICATION_CONTEXT, USER.getUserId());
				PAGE = "/pages/underwriting/reInsurance/createRiPlacement/createRiPlacement.jsp";
			}else if("refreshCreateRiPlacement".equals(ACTION)){
				log.info("Refreshing Create RI Placement...");
				message = giriwFrpsRiService.refreshGiriwFrpsRiGrid(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getWarrDays".equals(ACTION)){
				log.info("Getting Warr days in Create RI Placement...");
				message = giriwFrpsRiService.getWarrDays(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showEnterRIAcceptancePage".equals(ACTION)) {
				log.info("Loading Enter RI Acceptance Page...");
				GIRIDistFrpsService giriFrpsService = (GIRIDistFrpsService) APPLICATION_CONTEXT.getBean("giriDistFrpsService");
				GIISReinsurerService giisReinsurerService = (GIISReinsurerService) APPLICATION_CONTEXT.getBean("giisReinsurerService");
				GIISParameterService giisParametersService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				
				String loadFromMenu = request.getParameter("loadFromUWMenu");
				
				// bonok :: 09.30.2014
				String autoPremVatL = giisParametersService.getParamValueV2("AUTO_COMPUTE_RI_PREM_VAT");
				String compPremVatF = giisParametersService.getParamValueV2("COMPUTE_PREM_VAT_FOREIGN");
				request.setAttribute("autoPremVatL", autoPremVatL);
				request.setAttribute("compPremVatF", compPremVatF);
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				
				params = giriwFrpsRiService.getWfrpRiParams(params);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				request.setAttribute("wFrpsRiGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				log.info("wFrpsRiGrid ::: " + params);
				
				HashMap<String, Object> params2 = new HashMap<String, Object>();
				params2.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params2.put("lineCd", request.getParameter("lineCd"));
				params2.put("frpsYy", "".equals(request.getParameter("frpsYy")) ? "0" : request.getParameter("frpsYy"));
				params2.put("frpsSeqNo", "".equals(request.getParameter("frpsSeqNo")) ? "0" : request.getParameter("frpsSeqNo"));
				params2.put("riSeqNo", "".equals(request.getParameter("riSeqNo")) ? "0" : request.getParameter("riSeqNo"));
				params2.put("riCd", request.getParameter("riCd"));
				params2 = giriFrpsService.getWFrperilParams(params2);
				Debug.print("wFrperilGrid ::: " + params2);
				request.setAttribute("wFrperilGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params2)));
				
				if("".equals(request.getParameter("riCd")) || request.getParameter("riCd") == null) {
					System.out.println("vatrate is null");
				} else {
					String vatRate = giisReinsurerService.getInputVatRate(request.getParameter("riCd"));
					request.setAttribute("inputVatRate", vatRate);
					System.out.println("vatrate retrieved ==> "+vatRate);
					//get_giris002_form_params
				}
				
				request.setAttribute("fromUWMenu", loadFromMenu);
				//PAGE = "/pages/underwriting/reInsurance/enterRIAcceptance/enterRIAcceptance.jsp";
				PAGE = "/pages/underwriting/reInsurance/enterRIAcceptance/enterRiAcceptanceNew.jsp";
			} else if ("refreshWFrpsRiGrid".equals(ACTION)) {
				log.info("Refresh wfrps_ri tablegrid...");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				
				params = giriwFrpsRiService.getWfrpRiParams(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("loadWFrperilGrid".equals(ACTION)) {
				log.info("loading giri_wfrperil tablegrid...");
				//GIRIDistFrpsService giriFrpsService = (GIRIDistFrpsService) APPLICATION_CONTEXT.getBean("giriDistFrpsService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("riSeqNo", request.getParameter("riSeqNo"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("distNo", request.getParameter("distNo") == null ? 0 : request.getParameter("distNo"));
				params.put("distSeqNo", request.getParameter("distSeqNo") == null ? 0 : request.getParameter("distSeqNo"));
				params.put("ACTION", "getGIRIWFrperil");
				params = TableGridUtil.getTableGrid(request, params);
				
				//params = giriFrpsService.getWFrperilParams(params);
				log.info("loadWFrperilGrid variables ::: "+params);
				JSONObject json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params));
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveRIAcceptace".equals(ACTION)) {
				giriwFrpsRiService.saveRiAcceptance(request.getParameter("parameters"), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("createBinders".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", "".equals(request.getParameter("frpsYy")) ? 0 : Integer.parseInt(request.getParameter("frpsYy")) );
				params.put("frpsSeqNo", "".equals(request.getParameter("frpsSeqNo")) ? 0 :
								Integer.parseInt(request.getParameter("frpsSeqNo")));
				params.put("userId", USER.getUserId());
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("parYy", "".equals(request.getParameter("parYy")) ? null : Integer.parseInt(request.getParameter("parYy")) );
				params.put("parSeqNo", "".equals(request.getParameter("parSeqNo")) ? null : Integer.parseInt(request.getParameter("parSeqNo")) );
				params.put("polSeqNo", "".equals(request.getParameter("polSeqNo")) ? null : Integer.parseInt(request.getParameter("polSeqNo")) );
				params.put("renewNo", "".equals(request.getParameter("renewNo")) ? null : Integer.parseInt(request.getParameter("renewNo")) );
				params.put("issueYy", "".equals(request.getParameter("issueYy")) ? null : Integer.parseInt(request.getParameter("issueYy")) );
				params.put("premVatNew", new BigDecimal(request.getParameter("premVatNew")));
				params.put("status", request.getParameter("status"));
				
				message = giriwFrpsRiService.createBinderGiris002(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("computeRiPremAmt".equals(ACTION)){
				message = giriwFrpsRiService.computeRiPremAmt(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("computeRiPremVat1".equals(ACTION)){
				message = giriwFrpsRiService.computeRiPremVat1(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveRiPlacement".equals(ACTION)){
				message = giriwFrpsRiService.saveRiPlacement(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkDelRecRiPlacement".equals(ACTION)){
				message = giriwFrpsRiService.checkDelRecRiPlacement(request.getParameter("preBinderId"));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("openPreviousRiList".equals(ACTION)){
				PAGE = "/pages/underwriting/reInsurance/createRiPlacement/subPages/searchPreviousRi.jsp";
			} else if ("searchPreviousRiModal".equals(ACTION)){
				log.info("Getting Previous RI list...");
				//message = giriwFrpsRiService.getPreviousRiGrid(request);
				//PAGE = "/pages/underwriting/reInsurance/createRiPlacement/subPages/searchPreviousRiAjaxResult.jsp";
				
				//marco - GENQA SR 5256 - 01.04.2016
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiriFrpsRiGrid");
				params.put("distNo", request.getParameter("distNo"));
				
				Map<String, Object> previousRiTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(previousRiTableGrid);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("previousRiTG", json);
					PAGE = "/pages/underwriting/reInsurance/createRiPlacement/subPages/searchPreviousRi.jsp";
				}
			} else if ("adjustPremVat".equals(ACTION)){
				message = giriwFrpsRiService.adjustPremVat(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("loadRecomputeVatPage".equals(ACTION)) {
				
				PAGE = "/pages/underwriting/reInsurance/enterRIAcceptance/subPages/recomputeVatRate.jsp";
			
			} else if ("loadRecomputeRiCommPage".equals(ACTION)) { // Added by Vincent SR-4797				
				PAGE = "/pages/underwriting/reInsurance/enterRIAcceptance/subPages/recomputeRiComm.jsp";
			} else if ("getAllPerilsForCommRecompute".equals(ACTION)) { // Added by Vincent SR-4797
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("riSeqNo", request.getParameter("riSeqNo"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("distNo", request.getParameter("distNo") == null ? 0 : request.getParameter("distNo"));
				params.put("distSeqNo", request.getParameter("distSeqNo") == null ? 0 : request.getParameter("distSeqNo"));
				params.put("ACTION", "getGIRIWFrperilNewCommAll");
				params = TableGridUtil.getTableGrid(request, params);
				
				JSONObject json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params));
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getAdjustPremVatParam".equals(ACTION)) {
				log.info("Getting GIRIS002 adjust prem vat params...");
				message = giriwFrpsRiService.adjustPremVatGIRIS002(request);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showPrintFrpsDialog".equals(ACTION)){
				//LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // bonok :: 10.16.2013 :: SR473 - GENQA
				//List<LOV> printers = helper.getList(LOVHelper.PRINTER_LISTING); // bonok :: 10.16.2013 :: SR473 - GENQA
				@SuppressWarnings("static-access")
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/underwriting/reInsurance/printFrps/printFrps.jsp";
			} else if ("getPrintFrps".equals(ACTION)){
				Map<String, Object> binderParams = new HashMap<String, Object>();
				binderParams.put("distNo", Integer.parseInt(request.getParameter("distNo")));
				//binderParams.put("distNo", 8377);
				
				Debug.print("Dist No: " + binderParams);
				
				List<GIRIBinder> giriBinderDetails = giriBinderService.getBinderDetails(binderParams);
				
				StringFormatter.replaceQuotesInList(giriBinderDetails);
				request.setAttribute("object", new JSONArray(giriBinderDetails));
				PAGE = "/pages/genericObject.jsp";
			} else if("getRiAgreementBond".equals(ACTION)){
				Map<String, Object> binderParams = new HashMap<String, Object>();
				binderParams.put("lineCd", request.getParameter("lineCd"));
				binderParams.put("frpsYy", Integer.parseInt(request.getParameter("frpsYy")));
				binderParams.put("frpsSeqNo", Integer.parseInt(request.getParameter("frpsSeqNo")));
				
				/*binderParams.put("lineCd", "SU");
				binderParams.put("frpsYy", 12);
				binderParams.put("frpsSeqNo", 12);*/
				
				Debug.print("binderParams: " + binderParams);
				
				List<Integer> fnlBinderIdList = giriBinderService.getFnlBinderId(binderParams);
				
				StringFormatter.replaceQuotesInList(fnlBinderIdList);
				request.setAttribute("object", new JSONArray(fnlBinderIdList));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateBinderPrinting".equals(ACTION)) {
				Map<String, Object> params = JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("parameters")));
				message = giriwFrpsRiService.validateBinderPrinting(params);
				System.out.println("validateBinderPrinting::: "+message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateFrpsPosting".equals(ACTION)){
				Map<String, Object> params = JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("parameters")));
				message = giriwFrpsRiService.validateFrpsPosting(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getTsiPremAmt".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("distNo", Integer.parseInt(request.getParameter("distNo")));
				params.put("distSeqNo", Integer.parseInt(request.getParameter("distSeqNo")));
				params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
				
				giriwFrpsRiService.getTsiPremAmt(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSharePercent".equals(ACTION)){
				message = giriwFrpsRiService.validateSharePercent(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("computeRiTsiAmt".equals(ACTION)){
				message = giriwFrpsRiService.computeRiTsiAmt(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(JSONException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = ExceptionHandler.handleException(e, USER);
		//	PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
