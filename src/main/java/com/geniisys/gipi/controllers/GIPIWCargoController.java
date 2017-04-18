package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIWCargo;
import com.geniisys.gipi.entity.GIPIWCargoCarrier;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWCargoCarrierService;
import com.geniisys.gipi.service.GIPIWCargoService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWCargoController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWCargoController.class);	
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/* default attributes */
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			System.out.println("ACTION : " + ACTION);
			if("showMarineCargoItemInfo".equals(ACTION)){
				GIPIWCargoService gipiWCargoService = (GIPIWCargoService) APPLICATION_CONTEXT.getBean("gipiWCargoService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWCargoService.newFormInstance(params)));
				message = "SUCCESS";
				PAGE = "/pages/underwriting/par/marineCargo/marineCargoItemInformationMain.jsp";
			} else if("getGIPIWItemTableGridMN".equals(ACTION)){
				GIPIWCargoService gipiWCargoService = (GIPIWCargoService) APPLICATION_CONTEXT.getBean("gipiWCargoService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWCargoService.newFormInstanceTG(params)));
				message = "SUCCESS";
				PAGE = "/pages/underwriting/parTableGrid/marineCargo/marineCargoItemInformationMain.jsp";
			} else if("showEndtMarineCargoItemInfo".equals(ACTION)){
				GIPIWCargoService gipiWCargoService = (GIPIWCargoService) APPLICATION_CONTEXT.getBean("gipiWCargoService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWCargoService.gipis068NewFormInstance(params)));
				message = "SUCCESS";			
				PAGE = "/pages/underwriting/endt/jsonMarineCargo/endtMarineCargoItemInformationMain.jsp";			
			}else if("showMarineCargoEndtItemInfo".equals(ACTION)){
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				
				int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
				GIPIPARList gipiPAR = null;
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				request.setAttribute("parDetails", gipiPAR);
				
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				GIPIWCargoService gipiWCargoService = (GIPIWCargoService) APPLICATION_CONTEXT.getBean("gipiWCargoService");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIPIWCargoCarrierService gipiWCargoCarrierService = (GIPIWCargoCarrierService)  APPLICATION_CONTEXT.getBean("gipiWCargoCarrierService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
				//String lineCd = par.getLineCd();
				String lineCd = request.getParameter("lineCd"); // andrew - 10.05.2010 - get the line code from request
				String sublineCd = par.getSublineCd();
				String assdNo = par.getAssdNo();
				
				request.setAttribute("fromDate", df.format(par.getInceptDate()));
				request.setAttribute("toDate", df.format(par.getExpiryDate()));
				
				request.setAttribute("parId", parId);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("sublineCd", sublineCd);
				request.setAttribute("parNo", request.getParameter("globalParNo"));
				request.setAttribute("assdName", request.getParameter("globalAssdName"));
				
				String[] lineSubLineParams = {par.getLineCd(), par.getSublineCd()};
				request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));	
				request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
				
				String[] groupParam = {assdNo};	
				request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
				request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
				
				String[] parIdParams = {Integer.toString(parId)}; 
				request.setAttribute("geogListing", helper.getList(LOVHelper.GEOG_LISTING1, parIdParams));
				request.setAttribute("vesselListing", helper.getList(LOVHelper.VESSEL_LISTING2, parIdParams));
				request.setAttribute("cargoClassListing", helper.getList(LOVHelper.CARGO_CLASS_LISTING));
				request.setAttribute("cargoTypeListing", helper.getList(LOVHelper.CARGO_TYPE_LISTING));
				String[] paramsPrint = {"GIPI_WCARGO.PRINT_TAG"}; 
				request.setAttribute("printTagListing", helper.getList(LOVHelper.CG_REF_CODE_LISTING,paramsPrint));
				request.setAttribute("invoiceListing", helper.getList(LOVHelper.CURRENCY_CODES2));
				request.setAttribute("vesselCarrierListing", helper.getList(LOVHelper.VESSEL_CARRIER_LISTING,parIdParams));
				
				/* Perils*/
				String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
				request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
				request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiWItemService.getGIPIWItem(parId)));
				
				List<GIPIWCargo> cargoItems = gipiWCargoService.getGipiWCargo(parId);
				List<GIPIWCargoCarrier> cargoCarrierItems = gipiWCargoCarrierService.getGipiWCargoCarrier(parId);
				
				int itemSize = 0;
				itemSize = cargoItems.size();
				StringBuilder arrayItemNo = new StringBuilder(itemSize);
				for (GIPIWCargo cargo: cargoItems){
					arrayItemNo.append(cargo.getItemNo() + " ");
				}
				
				request.setAttribute("items", cargoItems);
				request.setAttribute("gipiWCargoCarrier", cargoCarrierItems);
				request.setAttribute("itemNumbers", arrayItemNo);
				
				String multiVesselCd = giisParametersService.getParamValueV2("VESSEL_CD_MULTI");
				request.setAttribute("multiVesselCd", multiVesselCd);
				if (multiVesselCd == null) {
					message = "Parameter for VESSEL_CD_MULTI not found in giis_parameters.";
				} else {
					message = "SUCCESS";
				}
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				String issCdRi = serv.getParamValueV2("ISS_CD_RI");
				request.setAttribute("issCdRi", issCdRi);
				request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
				
				PAGE = "/pages/underwriting/itemInformation.jsp";
				
				String parType = request.getParameter("globalParType"); // added by andrew 08.06.2010 - f]or endt par
				if ("E".equals(parType)){
					GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
					String policyNo = request.getParameter("globalEndtPolicyNo");
					
					// Geography Listing
					List<LOV> endtGeogListing = helper.getList(LOVHelper.ENDT_GEOG_LISTING, parIdParams);
					StringFormatter.replaceQuotesInList(endtGeogListing);
					request.setAttribute("endtGeogListing", new JSONArray(endtGeogListing));						
					
					// Carrier Listing
					String[] params = {String.valueOf(parId)};
					List<LOV> carrierListing = helper.getList(LOVHelper.VESSEL_CARRIER_LISTING2, params);
					StringFormatter.replaceQuotesInList(carrierListing);
					request.setAttribute("endtCarriers", new JSONArray(carrierListing));

					// Cargo Class Listing
					List<LOV> cargoClassListing = helper.getList(LOVHelper.CARGO_CLASS_LISTING);
					StringFormatter.replaceQuotesInList(cargoClassListing);
					request.setAttribute("cargoClassListing", new JSONArray(cargoClassListing));
					
					// Cargo Type Listing
					List<LOV> cargoTypeListing = helper.getList(LOVHelper.CARGO_TYPE_LISTING);
					StringFormatter.replaceQuotesInList(cargoTypeListing);
					request.setAttribute("cargoTypeListing", new JSONArray(cargoTypeListing));			
					
					request.setAttribute("parType", parType);
					request.setAttribute("policyNo", policyNo);
					
					// Cargo Carrier
					StringFormatter.replaceQuotesInList(cargoCarrierItems);
					request.setAttribute("objCargoCarriers", new JSONArray(cargoCarrierItems));
					
					// Item Records											
					request.setAttribute("items2", new JSONArray(cargoItems));
					
					// Posted policies
					List<GIPIPolbasic> gipiPolbasics = gipiPolbasicService.getEndtPolicy(parId);
					request.setAttribute("gipiPolbasics2", new JSONArray(gipiPolbasics));
					
					List<GIPIWPolbas> gipiWPolbasList = new ArrayList<GIPIWPolbas>();						
					gipiWPolbasList.add(par);
					request.setAttribute("gipiWPolbas", new JSONArray(gipiWPolbasList));
					
					Map<String, Object> newInstanceParams = new HashMap<String, Object>();
					newInstanceParams.put("parId", parId);
					loadNewFormInstanceVariablesToRequest(request, gipiWCargoService.gipis068NewFormInstance(newInstanceParams));
					
					PAGE = "/pages/underwriting/endt/marineCargo/endtMarineCargoItemInformationMain.jsp";					
				}
			}else if("showCargoClass".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				request.setAttribute("cargoClassListing", lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING));
				PAGE = "/pages/underwriting/overlay/cargoClass.jsp";
			}else if("saveParMNItems".equals(ACTION)){
				GIPIWCargoService gipiWCargoService = (GIPIWCargoService) APPLICATION_CONTEXT.getBean("gipiWCargoService");
				gipiWCargoService.saveGIPIWCargo(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveEndtMarineCargoItems".equals(ACTION)){
				GIPIWCargoService gipiWCargoService = (GIPIWCargoService)  APPLICATION_CONTEXT.getBean("gipiWCargoService");
				gipiWCargoService.saveGIPIEndtMarineCargoItem(request.getParameter("parameters"));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showAddDeleteItem".equals(ACTION)){
				request.setAttribute("itemNos", request.getParameter("itemNos"));
				request.setAttribute("choice", request.getParameter("choice"));
				PAGE = "/pages/underwriting/endt/common/subPages/endtItemInfoAddDeleteItem.jsp";
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
		
	}

	@SuppressWarnings("unused")
	private List<GIPIWCargoCarrier> prepareCarrierItems(
			HttpServletRequest request, GIISUser USER) throws ParseException {
		List<GIPIWCargoCarrier> carrierItems = new ArrayList<GIPIWCargoCarrier>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if (request.getParameterValues("cItemNos") != null && !(request.getParameterValues("cCds").toString().isEmpty())){
			String[] cparIds				= request.getParameterValues("cParIds");
			String[] cItemNos				= request.getParameterValues("cItemNos");
			String[] cCds					= request.getParameterValues("cCds");
			String[] cVesselLimitOfLiab		= request.getParameterValues("cVesselLimitOfLiab");
			String[] cEtas					= request.getParameterValues("cEtas");
			String[] cEtds					= request.getParameterValues("cEtds");
			String[] cOrigins				= request.getParameterValues("cOrigins");
			String[] cDestns				= request.getParameterValues("cDestns");
			String[] cDeleteSws				= request.getParameterValues("cDeleteSws");
			String[] cVoyLimits				= request.getParameterValues("cVoyLimits");
			
			if (request.getParameterValues("cCds") != null) {
				for (int a = 0; a < cCds.length; a++) {
					carrierItems.add(new GIPIWCargoCarrier(cparIds[a],cItemNos[a],cCds[a],
						(cVesselLimitOfLiab[a] == null || cVesselLimitOfLiab[a] == "" ? null : new BigDecimal(cVesselLimitOfLiab[a].replaceAll(",", ""))),
						(cEtas[a] == null || cEtas[a] == "" ? null : sdf.parse(cEtas[a])),	
						(cEtds[a] == null || cEtds[a] == "" ? null : sdf.parse(cEtds[a])),
						cOrigins[a],cDestns[a],cDeleteSws[a],cVoyLimits[a],USER.getUserId()));
					
				}
			}
		}
		return carrierItems;
	}

	/**
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@SuppressWarnings("unused")
	private List<GIPIWCargo> prepareMarineCargoItems(HttpServletRequest request) throws ParseException {
		List<GIPIWCargo> marineCargoItems = new ArrayList<GIPIWCargo>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(request.getParameterValues("itemItemNos") != null && !(request.getParameterValues("vesselCds").toString().isEmpty())){
			String[] parIds				= request.getParameterValues("itemParIds");
			String[] itemNos			= request.getParameterValues("itemItemNos");
			String[] packMethods		= request.getParameterValues("packMethods");
			String[] blAwbs 			= request.getParameterValues("blAwbs");
			String[] transhipOrigins 	= request.getParameterValues("transhipOrigins");
			String[] transhipDestinations = request.getParameterValues("transhipDestinations");  
			String[] voyageNos			= request.getParameterValues("voyageNos");
			String[] lcNos	 			= request.getParameterValues("lcNos");
			String[] etds 				= request.getParameterValues("etds");  
			String[] etas 				= request.getParameterValues("etas");
			String[] origins 			= request.getParameterValues("origins");
			String[] destns 			= request.getParameterValues("destns");  
			String[] invCurrRts 		= request.getParameterValues("invCurrRts");
			String[] invoiceValues 		= request.getParameterValues("invoiceValues");
			String[] markupRates 		= request.getParameterValues("markupRates");  
			String[] recFlagWCargos 	= request.getParameterValues("recFlagWCargos");
			String[] cpiRecNos 			= request.getParameterValues("cpiRecNos");
			String[] cpiBranchCds 		= request.getParameterValues("cpiBranchCds");
			String[] deductTexts 		= request.getParameterValues("deductTexts");
			String[] geogCds 			= request.getParameterValues("geogCds");
			String[] vesselCds 			= request.getParameterValues("vesselCds");
			String[] cargoClassCds 		= request.getParameterValues("cargoClassCds");
			String[] cargoTypes 		= request.getParameterValues("cargoTypes");
			String[] printTags 			= request.getParameterValues("printTags");
			String[] invCurrCds 		= request.getParameterValues("invCurrCds");
			String[] deleteWVess 		= request.getParameterValues("deleteWVess");
			
			if (request.getParameterValues("vesselCds") != null) {
				for (int a = 0; a < vesselCds.length; a++) {
					marineCargoItems.add(new GIPIWCargo(parIds[a],itemNos[a],printTags[a],
						vesselCds[a],geogCds[a],cargoClassCds[a],voyageNos[a],blAwbs[a],
						origins[a],destns[a],
						(etds[a] == null || etds[a] == "" ? null : sdf.parse(etds[a])),
						(etas[a] == null || etas[a] == "" ? null : sdf.parse(etas[a])),
						cargoTypes[a],deductTexts[a],
						packMethods[a],transhipOrigins[a],transhipDestinations[a],lcNos[a],
						(invoiceValues[a] == null || invoiceValues[a] == "" ? null : new BigDecimal(invoiceValues[a].replaceAll(",", ""))),
						invCurrCds[a],
						(invCurrRts[a] == null || invCurrRts[a] == "" ? null : invCurrRts[a].replaceAll(",", "")),
						(markupRates[a] == null || markupRates[a] == "" ? null : markupRates[a].replaceAll(",", "")),
						(recFlagWCargos[a] == null || recFlagWCargos[a] == "" ? "A" : recFlagWCargos[a]),
						cpiRecNos[a],cpiBranchCds[a],deleteWVess[a]));
				}
			}
		}
		return marineCargoItems;
	}

	// andrew - 09.17.2010 - added for saving of policy deductibles details
	/**
	 * 
	 */
	@SuppressWarnings("unused")
	private Map<String, Object> prepareGIPIWDeductibleMap(HttpServletRequest request, HttpServletResponse response, String dedLevel, int parId, String lineCd, String sublineCd, String userId) {
		String[] insItemNos 		 = request.getParameterValues("insDedItemNo"+dedLevel);
		String[] insPerilCds 		 = request.getParameterValues("insDedPerilCd"+dedLevel);
		String[] insDeductibleCds 	 = request.getParameterValues("insDedDeductibleCd"+dedLevel);
		String[] insDeductibleAmts   = request.getParameterValues("insDedAmount"+dedLevel);
		String[] insDeductibleRts 	 = request.getParameterValues("insDedRate"+dedLevel);
		String[] insDeductibleTexts  = request.getParameterValues("insDedText"+dedLevel);
		String[] insAggregateSws 	 = request.getParameterValues("insDedAggregateSw"+dedLevel);
		String[] insCeilingSws 	 	 = request.getParameterValues("insDedCeilingSw"+dedLevel);

		Map<String, Object> insParams = new HashMap<String, Object>();
		insParams.put("itemNos", insItemNos);
		insParams.put("perilCds", insPerilCds);
		insParams.put("deductibleCds", insDeductibleCds);
		insParams.put("deductibleAmounts", insDeductibleAmts);
		insParams.put("deductibleRates", insDeductibleRts);
		insParams.put("deductibleTexts", insDeductibleTexts);
		insParams.put("aggregateSws", insAggregateSws);
		insParams.put("ceilingSws", insCeilingSws);
		
		String[] delItemNos 		 = request.getParameterValues("delDedItemNo"+dedLevel);
		String[] delPerilCds 		 = request.getParameterValues("delDedPerilCd"+dedLevel);
		String[] delDeductibleCds 	 = request.getParameterValues("delDedDeductibleCd"+dedLevel);
		
		Map<String, Object> delParams = new HashMap<String, Object>();
		delParams.put("itemNos", delItemNos);
		delParams.put("perilCds", delPerilCds);
		delParams.put("deductibleCds", delDeductibleCds);	
		
		Map<String, Object> deductibleParams = new HashMap<String, Object>();
		deductibleParams.put("insParams", insParams);
		deductibleParams.put("delParams", delParams);
		deductibleParams.put("parId", parId);
		deductibleParams.put("dedLineCd", lineCd);
		deductibleParams.put("dedSublineCd", sublineCd);
		deductibleParams.put("userId", userId);
		
		return deductibleParams;
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("unused")
	private Map<String, Object> prepareEndtItemPerils(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> gipiWItemPeril = new HashMap<String, Object>();
		String[] insItemNos				= request.getParameterValues("insItemNo");
		String[] insPerilCds 			= request.getParameterValues("insPerilCd");
		String[] insPremiumRates 		= request.getParameterValues("insPremiumRate");
		String[] insTsiAmounts 			= request.getParameterValues("insTsiAmount");
		String[] insAnnTsiAmounts 		= request.getParameterValues("insAnnTsiAmount");
		String[] insPremiumAmounts		= request.getParameterValues("insPremiumAmount");
		String[] insAnnPremiumAmounts	= request.getParameterValues("insAnnPremiumAmount");
		String[] insRemarks				= request.getParameterValues("insRemarks");
		String[] insWcSw				= request.getParameterValues("insWcSw");
		
		Map<String, Object> insParams = new HashMap<String, Object>();
		//insParams.put("parId", parId);
		//insParams.put("lineCd", lineCd);
		insParams.put("itemNos", insItemNos);
		insParams.put("perilCds", insPerilCds);
		insParams.put("premiumRates", insPremiumRates);
		insParams.put("tsiAmounts", insTsiAmounts);
		insParams.put("annTsiAmounts", insAnnTsiAmounts);
		insParams.put("premiumAmounts", insPremiumAmounts);
		insParams.put("annPremiumAmounts", insAnnPremiumAmounts);
		insParams.put("remarks", insRemarks);
		insParams.put("wcSws", insWcSw);
		
		// peril/s to be deleted.
		String[] delItemNos  = request.getParameterValues("delItemNo");
		String[] delPerilCds = request.getParameterValues("delPerilCd");
		
		Map<String, Object> delParams = new HashMap<String, Object>();
		//delParams.put("parId", parId);
		//delParams.put("lineCd", lineCd);
		delParams.put("itemNos", delItemNos);
		delParams.put("perilCds", delPerilCds);
		
		// other parameters				
		String delDiscounts 			= request.getParameter("delDiscounts");
		String delPercentTsiDeductibles = request.getParameter("delPercentTsiDeductibles");
		String updateEndtTax 			= request.getParameter("updateEndtTax");
		String packPolFlag   			= request.getParameter("globalPackPolFlag");
		Integer packParId     			= Integer.parseInt((request.getParameter("globalPackParId") == null || request.getParameter("globalPackParId") == "" ? "0" : request.getParameter("globalPackParId")));
		String packLineCd				= request.getParameter("packLineCd");
		String issCd 	    			= request.getParameter("globalIssCd");
		String parTsiAmount 			= request.getParameter("parTsiAmount");
		String parAnnTsiAmount 			= request.getParameter("parAnnTsiAmount");
		String parPremiumAmount			= request.getParameter("parPremiumAmount");
		String parAnnPremiumAmount		= request.getParameter("parAnnPremiumAmount");

		Map<String, Object> otherParams = new HashMap<String, Object>();
		otherParams.put("delDiscounts", delDiscounts);
		otherParams.put("delPercentTsiDeductibles", delPercentTsiDeductibles);
		otherParams.put("updateEndtTax", updateEndtTax);
		otherParams.put("packPolFlag", packPolFlag);
		otherParams.put("packParId", packParId);
		otherParams.put("packLineCd", packLineCd);
		otherParams.put("issCd", issCd);
		otherParams.put("parTsiAmount", parTsiAmount);
		otherParams.put("parAnnTsiAmount", parAnnTsiAmount);
		otherParams.put("parPremiumAmount", parPremiumAmount);
		otherParams.put("parAnnPremiumAmount", parAnnPremiumAmount);
		
		gipiWItemPeril.put("insParams", insParams);
		gipiWItemPeril.put("delParams", delParams);
		gipiWItemPeril.put("otherParams", otherParams);
		
		return gipiWItemPeril; 
	}
	
	/**
	 * 
	 * @param request
	 * @param newFormInstance
	 */
	@SuppressWarnings("unchecked")
	private void loadNewFormInstanceVariablesToRequest(HttpServletRequest request, Map<String, Object> newFormInstance){
		Set mapSet = newFormInstance.entrySet();
		Iterator mapIterator = mapSet.iterator();
		
		while(mapIterator.hasNext()){
			Map.Entry<String, Object> entry = (Map.Entry<String, Object>) mapIterator.next();
			
			if(!("parId".equals(entry.getKey()))){
				request.setAttribute(entry.getKey().toString(), entry.getValue());
			}
			//System.out.println(entry.getKey() + "=" + entry.getValue());
		}
	}
}
