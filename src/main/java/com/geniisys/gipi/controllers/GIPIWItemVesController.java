package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemVes;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWItemVesService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWItemVesController extends BaseController {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWItemVesController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		System.out.println("HEAD CONTROLLER userId: "+USER.getUserId());
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader
					.getServletContext(getServletContext());

			GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
			GIPIWItemVesService gipiWItemVesService = (GIPIWItemVesService) APPLICATION_CONTEXT.getBean("gipiWItemVesService");
			LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			//System.out.println(request.getParameter("globalParId"));
			//int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
			//int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
			int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
			// int itemNo = Integer.parseInt(request.getParameter("itemNo"));
			// TODO Auto-generated method stub
			if (parId == 0) {
				message = "PAR No. is empty";
				PAGE = "/pages/genericMessage.jsp";
			} else {
				GIPIPARList gipiPAR = null;
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				request.setAttribute("parDetails", gipiPAR);
				if ("showMarineHullItemInfo".equals(ACTION)) {
					GIPIWPolbas par = gipiWPolbasService.getGipiWPolbas(parId);
					request.setAttribute("wPolBasic", par);
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");

					//String lineCd = par.getLineCd();
					String lineCd = request.getParameter("lineCd"); // andrew - 10.05.2010 - get the line code from request
					String sublineCd = par.getSublineCd();
					String assdNo = par.getAssdNo();
					request.setAttribute("fromDate", sdf.format(par.getInceptDate()));
					request.setAttribute("toDate", sdf.format(par.getExpiryDate()));
					request.setAttribute("distNo", gipiPAR.getDistNo());

					request.setAttribute("parId", parId);
					request.setAttribute("lineCd", lineCd);
					request.setAttribute("sublineCd", sublineCd);
					request.setAttribute("parNo", request.getParameter("globalParNo"));
					request.setAttribute("assdName", request.getParameter("globalAssdName"));
					request.setAttribute("parType", gipiPAR.getParType());
					request.setAttribute("discExists", gipiPAR.getDiscExists());
					request.setAttribute("gipiWInvoiceExist", gipiPAR.getGipiWInvoiceExist());
					request.setAttribute("gipiWInvTaxExist", gipiPAR.getGipiWInvTaxExist());
					
					String[] lineSubLineParams = { par.getLineCd(), par.getSublineCd() };
					request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));
					request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
					
					//getting vessel listings
					String[] vesParams = {par.getSublineCd(), par.getIssCd(), par.getIssueYy().toString(), par.getPolSeqNo().toString(), par.getRenewNo().toString()};
					request.setAttribute("marineHullListing", helper.getList(LOVHelper.MARINE_HULL_LISTING, vesParams));
					
					String[] groupParam = { assdNo };
					request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
					request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
					
					GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					String vPhilPeso = giisParamService.getParamValueV2("PHP");
					request.setAttribute("vPhilPeso", vPhilPeso);

					List<GIPIWItemVes> marineHullItems = gipiWItemVesService.getGipiWItemVes(parId);

					int itemSize = 0;
					itemSize = marineHullItems.size();
					StringBuilder arrayItemNo = new StringBuilder(itemSize);
					for (GIPIWItemVes mh : marineHullItems) {
						arrayItemNo.append(mh.getItemNo() + " ");
					}

					System.out.println("mh size" + marineHullItems.size());
					request.setAttribute("items", marineHullItems);
					request.setAttribute("itemNumbers", arrayItemNo);
					
					
					// System.out.println("vesselCd" + marineHullItems);
					if ("P".equals(gipiPAR.getParType())){
						/* Perils*/
						String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
						request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));

						GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
						String issCdRi = serv.getParamValueV2("ISS_CD_RI");
						request.setAttribute("issCdRi", issCdRi);
						request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
						GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
						String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
						request.setAttribute("pDeductibleExist", pDeductibleExist);
						
						PAGE = "/pages/underwriting/itemInformation.jsp";
					} else if ("E".equals(gipiPAR.getParType())){
						//request.setAttribute("noCorrVessInfo", gipiWItemVesService.checkItemVesAddtlInfo(parId));
						GIPIPolbasicService serv = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
						List<GIPIWPolbas> gipiWPolbasList = new ArrayList<GIPIWPolbas>();
						request.setAttribute("gipiPolbasics", new JSONArray(serv.getEndtPolicy(parId)));
						request.setAttribute("gipiWPolbas", new JSONArray(gipiWPolbasList));
						request.setAttribute("policyNo", request.getParameter("globalEndtPolicyNo"));
						PAGE = "/pages/underwriting/endt/marineHull/endtMarineHullItemInformationMain.jsp";
					}
					
					//for JSON-implementation
					StringFormatter.replaceQuotesInObject(gipiPAR);
					StringFormatter.replaceQuotesInObject(par);
					StringFormatter.replaceQuotesInList(marineHullItems);
					request.setAttribute("jsonGIPIPARList", new JSONObject(gipiPAR));
					request.setAttribute("jsonGIPIWPolbas", new JSONObject(par));
					request.setAttribute("jsonGIPIWItemVes", new JSONArray(marineHullItems));
					
				} else if("getGIPIWItemTableGridMH".equals(ACTION)){					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWItemVesService.newFormInstanceTG(params)));
					message = "SUCCES";
					PAGE = "/pages/underwriting/parTableGrid/marineHull/marineHullItemInformationMain.jsp";
				} else if ("saveGipiParItemVes".equals(ACTION)) {
					List<GIPIWItemVes> marineHullItems = new ArrayList<GIPIWItemVes>();

					GIPIWPolbas par = gipiWPolbasService.getGipiWPolbas(parId);
					String lineCd = par.getLineCd();
					String sublineCd = par.getSublineCd();

					if (request.getParameterValues("itemItemNos") != null) {
						String[] parIds = request
								.getParameterValues("itemParIds");
						String[] itemNos = request
								.getParameterValues("itemItemNos");
						String[] vesselCds = request
								.getParameterValues("vesselCds");
						String[] recFlags = request
								.getParameterValues("itemRecFlags");
						String[] deductTexts = request
								.getParameterValues("deductTexts");
						String[] geogLimits = request
								.getParameterValues("geogLimits");
						String[] dryDates = request
								.getParameterValues("dryDates");
						String[] dryPlaces = request
								.getParameterValues("dryPlaces");

						for (int a = 0; a < itemNos.length; a++) {
							System.out.println(itemNos.length);
							marineHullItems.add(new GIPIWItemVes(parIds[a],
									itemNos[a], vesselCds[a], recFlags[a],
									deductTexts[a], geogLimits[a], dryDates[a],
									dryPlaces[a]));
						}
						Map<String, Object> params = new HashMap<String, Object>();
						params.put("marineHullItems", marineHullItems);
						params.put("parId", parId);

						gipiWItemVesService.saveGIPIParMarineHullItem(params);
						request.setAttribute("message", "Item saved.");
						message = "SUCCESS";
						PAGE = "/pages/genericMessage.jsp";
					}
				} else if ("getEndtGipiWItemVesDetails".equals(ACTION)){
					String lineCd = request.getParameter("lineCd");
		      		String sublineCd = request.getParameter("sublineCd");
		      		String issCd = request.getParameter("issCd");
		      		int issueYy = Integer.parseInt(request.getParameter("issueYy"));
		      		int polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
		      		int renewNo = Integer.parseInt(request.getParameter("renewNo"));
		      		int itemNo = Integer.parseInt(request.getParameter("itemNo"));
		      		BigDecimal annTsiAmt = new BigDecimal(request.getParameter("annTsiAmt") == ""? "0" : request.getParameter("annTsiAmt"));
		      		BigDecimal annPremAmt = new BigDecimal(request.getParameter("annPremAmt") == ""? "0" : request.getParameter("annPremAmt"));
		      		
		      		Map<String, Object> params = new HashMap<String, Object>();
		      		params.put("lineCd", lineCd);
		      		params.put("sublineCd", sublineCd);
		      		params.put("issCd", issCd);
		      		params.put("issueYy", issueYy);
		      		params.put("polSeqNo", polSeqNo);
		      		params.put("renewNo", renewNo);
		      		params.put("itemNo", itemNo);
		      		params.put("annTsiAmt", annTsiAmt);
		      		params.put("annPremAmt", annPremAmt);
		      		
		      		GIPIWItemVes ves = (GIPIWItemVes) gipiWItemVesService.getEndtGipiWItemVesDetails(params);
		      		
		      		//itemTitle, annPremAmt, annTsiAmt, currencyCd, currencyRt, fromDate, toDate, regionCd, recFlag, restrictedCondition
		      		String details = ves.getItemTitle() + "," + ves.getAnnPremAmt() + "," + ves.getAnnTsiAmt() + "," + ves.getCurrencyCd()
		      		 	+ "," + ves.getCurrencyRt() + "," + ves.getFromDate() + "," + ves.getToDate() + "," + ves.getRegionCd() + "," + ves.getRecFlag()
		      		 	+ "," + ves.getRestrictedCondition();
		      		
		      		message = details;
		      		PAGE = "/pages/genericMessage.jsp";
				} else if ("validateVessel".equals(ACTION)){
					String lineCd = request.getParameter("lineCd");
		      		String sublineCd = request.getParameter("sublineCd");
		      		String issCd = request.getParameter("issCd");
		      		int issueYy = Integer.parseInt(request.getParameter("issueYy"));
		      		int polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
		      		int renewNo = Integer.parseInt(request.getParameter("renewNo"));
		      		String vesselName = request.getParameter("vesselName");
		      	
		      		Map<String, Object> params = new HashMap<String, Object>();
		      		params.put("lineCd", lineCd);
		      		params.put("sublineCd", sublineCd);
		      		params.put("issCd", issCd);
		      		params.put("issueYy", issueYy);
		      		params.put("polSeqNo", polSeqNo);
		      		params.put("renewNo", renewNo);
		      		params.put("vesselName", vesselName);
		      		
		      		String validated = (String) gipiWItemVesService.validateVessel(params);
		      		log.info("Validated? - "+validated);
		      		message = validated;
		      		PAGE = "/pages/genericMessage.jsp";
				} else if ("saveEndtMarineHullItemInfoPage".equals(ACTION)){
					GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
					System.out.println("parameters: "+request.getParameter("parameters"));
					JSONObject params 			= new JSONObject(request.getParameter("parameters"));
					Map<String, Object> globals = new HashMap<String, Object>();
					Map<String, Object> vars 	= new HashMap<String, Object>();
					Map<String, Object> pars 	= new HashMap<String, Object>();
					Map<String, Object> others 	= new HashMap<String, Object>();
					Map<String, Object> param 	= new HashMap<String, Object>();
					
					String element = "";
					for(Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();){
						element = e.nextElement();
						//System.out.println("Element: " + element);
						if("var".equals(element.substring(0, 3))){
							vars.put(element, request.getParameter(element));
						}else if("par".equals(element.substring(0, 3))){
							pars.put(element, request.getParameter(element));
						}else if(element.contains("global")){
							globals.put(element, request.getParameter(element));
						}else{
							//System.out.println(element+": "+request.getParameter(element));
							others.put(element, request.getParameter(element));
						}
					}
					
					param.put("itemInsList", gipiWItemService.prepareGIPIWItemListing(new JSONArray(params.getString("setItems"))));
					param.put("itemDelList", gipiWItemService.prepareGIPIWItemListing(new JSONArray(params.getString("delItems"))));
					
					param.put("itemVesInsList", gipiWItemVesService.prepareGIPIWItemVesListing(new JSONArray(params.getString("setItems"))));
					//param.put("itemVesDelList", gipiWItemVesService.prepareGIPIWItemVesListing(new JSONArray(params.getString("delItems"))));
					
					String sublineCd		= request.getParameter("globalSublineCd");
					String[] itemNos		= request.getParameterValues("itemItemNos");				
					//String[] delItemNos		= request.getParameterValues("delItemNos");	
					String varPost 			= request.getParameter("varPost");
					String invoiceSw 		= request.getParameter("invoiceSw");
					String packPolFlag		= request.getParameter("packPolFlag");
					String deleteParDiscounts = request.getParameter("deleteParDiscounts");
					String gipiWItemExist	  = request.getParameter("gipiWItemExist");
					String gipiWItemPerilExist = request.getParameter("gipiWItemPerilExist");
					String gipiWInvoiceExist   = request.getParameter("gipiWInvoiceExist") == "1"? "Y" : "N";
					String gipiWInvTaxExist   = request.getParameter("gipiWInvTaxExist") == "1"? "Y" : "N";
					String lineCd			= request.getParameter("globalLineCd");
					String issCd			= request.getParameter("globalIssCd");
					Integer distNo			= request.getParameter("distNo") == "" ? 0 : Integer.parseInt(request.getParameter("distNo"));
					String aItem			= request.getParameter("aItem");
					String aPeril			= request.getParameter("aPeril");
					String varGroupSw		= request.getParameter("varGroupSw");
					Integer itemWithPerilCount = Integer.parseInt(request.getParameter("itemWithPerilCount"));
					Map<String, Object> updateGIPIWPolbasParams = new HashMap<String, Object>();
					updateGIPIWPolbasParams = this.getUpdateGIPIWPolbasParams(request);
					//String deleteItemNos = request.getParameter("deleteItemNos");
					
					
					
					param.put("parId", parId);
					param.put("sublineCd", sublineCd);
					param.put("varPost", varPost);
					param.put("invoiceSw", invoiceSw);
					param.put("packPolFlag", packPolFlag);
					param.put("deleteParDiscounts", deleteParDiscounts);
					param.put("gipiWItemExist", gipiWItemExist);
					param.put("gipiWItemPerilExist", gipiWItemPerilExist);
					param.put("gipiWInvoiceExist", gipiWInvoiceExist);
					param.put("gipiWInvTaxExist", gipiWInvTaxExist);
					param.put("lineCd", lineCd);
					param.put("issCd", issCd);
					param.put("distNo", distNo);
					param.put("userId", USER.getUserId());
					//param.put("delItemNos", delItemNos);
					param.put("aItem", aItem);
					param.put("aPeril", aPeril);
					param.put("itemWithPerilCount", itemWithPerilCount);
					param.put("varGroupSw", varGroupSw);
					//param.put("deleteItemNos", deleteItemNos);
					
					System.out.println("CONTROLLER userId: "+USER.getUserId());
					
					String delPolDed = request.getParameter("delPolDed");
					param.put("delPolDed", delPolDed);
					
					param.put("itemNos", itemNos);

					if (itemNos != null){
						for (int i = 0; i < itemNos.length; i++) {
							System.out.println("ITEM: "+itemNos[i]);
						}
						Map<String, Object> items = new HashMap<String, Object>();
						Map<String, Object> itemVes = new HashMap<String, Object>();
						//getting GIPIItem details 
						String[] parIds				= request.getParameterValues("itemParIds");
						String[] itemTitles			= request.getParameterValues("itemItemTitles");
						String[] itemGrps			= request.getParameterValues("itemItemGrps");
						String[] itemDescs			= request.getParameterValues("itemItemDescs");
						String[] itemDesc2s			= request.getParameterValues("itemItemDesc2s");
						String[] tsiAmts			= request.getParameterValues("itemTsiAmts");
						String[] premAmts			= request.getParameterValues("itemPremAmts");
						String[] annPremAmts		= request.getParameterValues("itemAnnPremAmts");
						String[] annTsiAmts			= request.getParameterValues("itemAnnTsiAmts");
						String[] recFlags			= request.getParameterValues("itemRecFlags");
						String[] currencyCds		= request.getParameterValues("itemCurrencyCds");
						String[] currencyRts		= request.getParameterValues("itemCurrencyRts");
						String[] groupCds			= request.getParameterValues("itemGroupCds");
						String[] fromDates			= request.getParameterValues("itemFromDates");
						String[] toDates			= request.getParameterValues("itemToDates");
						String[] packLineCds		= request.getParameterValues("itemPackLineCds");
						String[] packSublineCds		= request.getParameterValues("itemPackSublineCds");
						String[] discountSws		= request.getParameterValues("itemDiscountSws");
						String[] coverageCds		= request.getParameterValues("itemCoverageCds");
						String[] otherInfos			= request.getParameterValues("itemOtherInfos");
						String[] surchargeSws		= request.getParameterValues("itemSurchargeSws"); 
						String[] regionCds			= request.getParameterValues("itemRegionCds");
						String[] changedTags		= request.getParameterValues("itemChangedTags");
						String[] prorateFlags		= request.getParameterValues("itemProrateFlags");
						String[] compSws			= request.getParameterValues("itemCompSws");
						String[] shortRtPercents	= request.getParameterValues("itemShortRtPercents");
						String[] packBenCds			= request.getParameterValues("itemPackBenCds");
						String[] paytTermss			= request.getParameterValues("itemPaytTermss");
						String[] riskNos			= request.getParameterValues("itemRiskNos");
						String[] riskItemNos		= request.getParameterValues("itemRiskItemNos");
						
						String[] parIdsVes = request.getParameterValues("itemParIds");
						String[] itemNosVes = request.getParameterValues("itemItemNos");
						String[] vesselCds = request.getParameterValues("vesVesselCd");
						String[] recFlagsVes = request.getParameterValues("itemRecFlags");
						String[] deductTexts = request.getParameterValues("vesDeductText");
						String[] geogLimits = request.getParameterValues("vesGeogLimit");
						String[] dryDates = request.getParameterValues("vesDryDate");
						String[] dryPlaces = request.getParameterValues("vesDryPlace");
						
						SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
						for (int i = 0; i < itemNos.length; i++) {
							GIPIWItem item = new GIPIWItem(
									Integer.parseInt(parIds[i]),
									Integer.parseInt(itemNos[i]),
									itemTitles[i], 
									itemGrps[i] == "" ? null : Integer.parseInt(itemGrps[i]),
									itemDescs[i], 
									itemDesc2s[i],
									tsiAmts[i] == "" ? null :  new BigDecimal(tsiAmts[i]),
									premAmts[i] == "" ? null : new BigDecimal(premAmts[i]),
									annPremAmts[i] == "" ? null : new BigDecimal(annPremAmts[i]),
									annTsiAmts[i] == "" ? null : new BigDecimal(annTsiAmts[i]),
									recFlags[i],						
									Integer.parseInt(currencyCds[i]),
									new BigDecimal(currencyRts[i]), 
									groupCds[i] == "" ? null : Integer.parseInt(groupCds[i])/*groupCd*/,
									(fromDates[i] == null || fromDates[i] == "" ? null :sdf.parse(fromDates[i])),//sdf.parse(fromDates[i]),
									(toDates[i] == null || toDates[i] == "" ? null :sdf.parse(toDates[i])),//sdf.parse(toDates[i]),
									packLineCds == null ? null : packLineCds[i], 
									packSublineCds == null ? null : packSublineCds[i],
									discountSws[i] == null || discountSws[i] == "" ? "" : discountSws[i]/*discountSw*/,
									coverageCds[i] == "" ? null : Integer.parseInt(coverageCds[i]),
									otherInfos == null ? null : otherInfos[i]/*otherInfo*/,
									surchargeSws[i] == null || surchargeSws[i] == "" ? "" : surchargeSws[i]/*surchargeSw*/,
									regionCds[i] == "" ? null : Integer.parseInt(regionCds[i]),
									changedTags == null ? null : changedTags[i]/*changedTag*/,
									prorateFlags == null ? null : prorateFlags[i]/*prorateFlag*/,
									compSws == null ? null : compSws[i]/*compSw*/,
									(shortRtPercents[i] == "" || shortRtPercents[i] == null || shortRtPercents[i].equals("") || shortRtPercents[i].equals(null))? null : new BigDecimal(shortRtPercents[i]), 
									packBenCds[i] == "" ? null : Integer.parseInt(packBenCds[i])/*packBenCd*/,
									paytTermss == null ? null : paytTermss[i], 
									riskNos[i] == "" ? null : Integer.parseInt(riskNos[i]), 
									riskItemNos[i] == "" ? null : Integer.parseInt(riskItemNos[i]));
							
							items.put(itemNos[i], item);
							
							log.info("Vessel Cd: " + vesselCds[i]);
							
							GIPIWItemVes ves = new GIPIWItemVes(
								Integer.parseInt(parIdsVes[i]),
								Integer.parseInt(itemNosVes[i]), 
								vesselCds[i], 
								recFlagsVes[i],
								deductTexts[i], 
								geogLimits[i], 
								dryDates[i],
								dryPlaces[i]);
							itemVes.put(itemNos[i], ves);
						}
						
						param.put("items", items);
						param.put("itemVes", itemVes);
					}
					
					String updateGIPIWPolbas = request.getParameter("updateGIPIWPolbas");
					param.put("updateGIPIWPolbas", updateGIPIWPolbas);
					
					if ("Y".equals(updateGIPIWPolbas)){
						//Map<String, Object> updateGIPIWPolbasParams = new HashMap<String, Object>();
						//updateGIPIWPolbasParams = this.getUpdateGIPIWPolbasParams(request);
						param.put("updateGIPIWPolbasParams", updateGIPIWPolbasParams);
					}
					
					if ("Y".equals(packPolFlag)){
						String packParId = request.getParameter("globalPackParId");
						String packLineCd = request.getParameter("packLineCd");
						String packSublineCd = request.getParameter("packSublineCd");
						param.put("packParId", packParId);
						param.put("packLineCd", packLineCd);
						param.put("packSublineCd", packSublineCd);
						
					}
					
					/******COLLECTING DATA FOR SAVING ITEM DEDUCTIBLES*******/

					String[] insDedItemNos	= request.getParameterValues("insDedItemNo2");
					String[] delDedItemNos	= request.getParameterValues("delDedItemNo2");
					
					param.put("insDedItemNos", insDedItemNos);
					param.put("delDedItemNos", delDedItemNos);
					
					if(insDedItemNos != null){
						//param.put("deductibleInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 2));
						List<GIPIWDeductible> deductibleInsList = new ArrayList<GIPIWDeductible>();
						
						String[] dedItemNos 		= request.getParameterValues("insDedItemNo2");		
						String[] perilCds 		 	= request.getParameterValues("insDedPerilCd2");
						String[] deductibleCds 	 	= request.getParameterValues("insDedDeductibleCd2");
						String[] deductibleAmts  	= request.getParameterValues("insDedAmount2");
						String[] deductibleRts 	 	= request.getParameterValues("insDedRate2");
						String[] deductibleTexts 	= request.getParameterValues("insDedText2");
						String[] aggregateSws 	 	= request.getParameterValues("insDedAggregateSw2");
						String[] ceilingSws 	 	= request.getParameterValues("insDedCeilingSw2");
						
						GIPIWDeductible deductible = null;
						for(int i=0, length=dedItemNos.length; i < length; i++){
							deductible = new GIPIWDeductible();
							deductible.setParId(Integer.parseInt(request.getParameter("globalParId")));
							deductible.setDedLineCd(request.getParameter("globalLineCd"));
							deductible.setDedSublineCd(request.getParameter("globalSublineCd"));
							deductible.setUserId(USER.getUserId());
							deductible.setItemNo(Integer.parseInt(dedItemNos[i]));
							deductible.setPerilCd(Integer.parseInt(perilCds[i]));
							deductible.setDedDeductibleCd(deductibleCds[i]);
							deductible.setDeductibleAmount(new BigDecimal(deductibleAmts[i].isEmpty() ? "0.00" : deductibleAmts[i].replaceAll(",", "")));
							deductible.setDeductibleRate(new BigDecimal(deductibleRts[i].isEmpty() ? "0.00" : deductibleRts[i]));
							deductible.setDeductibleText(deductibleTexts[i]);
							deductible.setAggregateSw(aggregateSws[i]);
							deductible.setCeilingSw(ceilingSws[i]);
							deductibleInsList.add(deductible);
							deductible = null;
						}
						
						param.put("deductibleInsList", deductibleInsList);
					}
					
					if(delDedItemNos != null){
						//param.put("deductibleDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 2));
						
						List<Map<String, Object>> deductibleDelList = new ArrayList<Map<String, Object>>();		
						
						String[] dedItemNos			= request.getParameterValues("delDedItemNo2");			
						String[] deductibleCds 	 	= request.getParameterValues("delDedDeductibleCd2");
						
						for(int i=0, length=dedItemNos.length; i <length; i++){
							Map<String, Object> deductibleMap = new HashMap<String, Object>();
							deductibleMap.put("parId", Integer.parseInt(request.getParameter("globalParId")));
							deductibleMap.put("itemNo", Integer.parseInt(dedItemNos[i]));
							deductibleMap.put("dedDeductibleCd", deductibleCds[i]);
							deductibleDelList.add(deductibleMap);
							deductibleMap = null;
						}
						param.put("deductibleDelList", deductibleDelList);
					}
					
					/******END OF ITEM DEDUCTIBLES DATA COLLECTION***********/
					
					/******COLLECTING DATA FOR SAVING FOR ENDT ITEM PERIL********/
					
					Map<String, Object> allEndtPerilParams = new HashMap<String, Object>();
					
					String[] insItemNos 			= request.getParameterValues("insItemNo");
					String[] insPerilCds 			= request.getParameterValues("insPerilCd");
					String[] insPremiumRates 		= request.getParameterValues("insPremiumRate");
					String[] insTsiAmounts 			= request.getParameterValues("insTsiAmount");
					String[] insAnnTsiAmounts 		= request.getParameterValues("insAnnTsiAmount");
					String[] insPremiumAmounts		= request.getParameterValues("insPremiumAmount");
					String[] insAnnPremiumAmounts	= request.getParameterValues("insAnnPremiumAmount");
					String[] insRemarks				= request.getParameterValues("insRemarks");
					String[] insWcSw				= request.getParameterValues("insWcSw");
					
					Map<String, Object> insParams = new HashMap<String, Object>();
					System.out.println("lineCd: "+lineCd);
					insParams.put("parId", parId);
					insParams.put("lineCd", lineCd);
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
					String[] delPerilItemNos  = request.getParameterValues("delItemNo");
					
					String[] delPerilCds = request.getParameterValues("delPerilCd");
					Map<String, Object> delParams = new HashMap<String, Object>();
					delParams.put("parId", parId);
					delParams.put("lineCd", lineCd);
					delParams.put("itemNos", delPerilItemNos);
					delParams.put("perilCds", delPerilCds);
					
					// other parameters				
					String delDiscounts 			= request.getParameter("delDiscounts");
					String delPercentTsiDeductibles = request.getParameter("delPercentTsiDeductibles");
					String updateEndtTax 			= request.getParameter("updateEndtTax");
					String perilPackPolFlag   		= request.getParameter("globalPackPolFlag");
					Integer packParId     			= Integer.parseInt((request.getParameter("globalPackParId") == null || request.getParameter("globalPackParId") == "" ? "0" : request.getParameter("globalPackParId")));
					String packLineCd				= request.getParameter("packLineCd");
					String perilIssCd 	    		= request.getParameter("globalIssCd");
					String parTsiAmount 			= request.getParameter("parTsiAmount");
					String parAnnTsiAmount 			= request.getParameter("parAnnTsiAmount");
					String parPremiumAmount			= request.getParameter("parPremiumAmount");
					String parAnnPremiumAmount		= request.getParameter("parAnnPremiumAmount");
	
					Map<String, Object> otherParams = new HashMap<String, Object>();
					otherParams.put("delDiscounts", delDiscounts);
					otherParams.put("delPercentTsiDeductibles", delPercentTsiDeductibles);
					otherParams.put("updateEndtTax", updateEndtTax);
					otherParams.put("packPolFlag", perilPackPolFlag);
					otherParams.put("packParId", packParId);
					otherParams.put("packLineCd", packLineCd);
					otherParams.put("issCd", perilIssCd);
					otherParams.put("parTsiAmount", parTsiAmount);
					otherParams.put("parAnnTsiAmount", parAnnTsiAmount);
					otherParams.put("parPremiumAmount", parPremiumAmount);
					otherParams.put("parAnnPremiumAmount", parAnnPremiumAmount);
					otherParams.put("userId", USER.getUserId());
					
					// deductibles
					String[] perilDedItemNos 		 = request.getParameterValues("dedItemNo3");
					String[] perilDedPerilCds 		 = request.getParameterValues("dedPerilCd3");
					String[] perilDedDeductibleCds 	 = request.getParameterValues("dedDeductibleCd3");
					String[] perilDedDeductibleAmts  = request.getParameterValues("dedAmount3");
					String[] perilDedDeductibleRts 	 = request.getParameterValues("dedRate3");
					String[] perilDedDeductibleTexts = request.getParameterValues("dedText3");
					String[] perilDedAggregateSws 	 = request.getParameterValues("dedAggregateSw3");
					String[] perilDedCeilingSws 	 = request.getParameterValues("dedCeilingSw3");
										
					Map<String, Object> perilDedParams = new HashMap<String, Object>();
					perilDedParams.put("itemNos", perilDedItemNos);
					perilDedParams.put("perilCds", perilDedPerilCds);
					perilDedParams.put("deductibleCds",perilDedDeductibleCds);
					perilDedParams.put("deductibleAmounts", perilDedDeductibleAmts);
					perilDedParams.put("deductibleRates", perilDedDeductibleRts);
					perilDedParams.put("deductibleTexts", perilDedDeductibleTexts);
					perilDedParams.put("aggregateSws", perilDedAggregateSws);
					perilDedParams.put("ceilingSws", perilDedCeilingSws);
					perilDedParams.put("parId", parId);
					perilDedParams.put("dedLineCd", lineCd);
					perilDedParams.put("dedSublineCd", sublineCd);
					perilDedParams.put("userId", USER.getUserId());									
					
					// all parameters.
					//Map<String, Object> allEndtPerilParams = new HashMap<String, Object>();
					allEndtPerilParams.put("insItemNos", insItemNos);
					allEndtPerilParams.put("delPerilItemNos", delPerilItemNos);
					allEndtPerilParams.put("insParams", insParams);
					allEndtPerilParams.put("delParams", delParams);
					allEndtPerilParams.put("otherParams", otherParams);
					allEndtPerilParams.put("perilDedParams", perilDedParams);
					
					param.put("allEndtPerilParams", allEndtPerilParams);
					/******END OF ENDT PERIL******/
					
					gipiWItemVesService.saveEndtMarineHullItemInfoPage(param);

					message = "SAVING SUCCESSFUL.";
		      		PAGE = "/pages/genericMessage.jsp";
				} else if ("preInsertMarineHull".equals(ACTION)){
		      		String lineCd = request.getParameter("lineCd");
		      		String sublineCd = request.getParameter("sublineCd");
		      		String issCd = request.getParameter("issCd");
		      		int issueYy = Integer.parseInt(request.getParameter("issueYy"));
		      		int polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
		      		int renewNo = Integer.parseInt(request.getParameter("renewNo"));
		      		int itemNo = Integer.parseInt(request.getParameter("itemNo"));
		      		int currencyCd = Integer.parseInt(request.getParameter("currencyCd"));
		      		
		      		Map<String, Object> params = new HashMap<String, Object>();
		      		params.put("lineCd", lineCd);
		      		params.put("sublineCd", sublineCd);
		      		params.put("issCd", issCd);
		      		params.put("issueYy", issueYy);
		      		params.put("polSeqNo", polSeqNo);
		      		params.put("renewNo", renewNo);
		      		params.put("itemNo", itemNo);
		      		params.put("currencyCd", currencyCd);
		      		
		      		message = gipiWItemVesService.preInsertMarineHull(params);
		      		PAGE = "/pages/genericMessage.jsp";
				} else if ("checkUpdateGipiWPolbasValidity".equals(ACTION)){
					message = gipiWItemVesService.checkUpdateGipiWPolbasValidity(this.getUpdateGIPIWPolbasParams(request));
					PAGE = "/pages/genericMessage.jsp";
				} else if ("checkCreateDistributionValidity".equals(ACTION)){
					message = gipiWItemVesService.checkCreateDistributionValidity(parId);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("checkGiriDistfrpsExist".equals(ACTION)){
					message = gipiWItemVesService.checkGiriDistfrpsExist(parId);
					PAGE = "/pages/genericMessage.jsp";
				} else if("saveEndtMHItems".equals(ACTION)){
					gipiWItemVesService.saveGIPIEndtItemVes(request.getParameter("parameters"), USER);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";					
				} else if("showMHItemInfo".equals(ACTION)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWItemVesService.newFormInstance(params)));
					message = "SUCCESS";
					PAGE = "/pages/underwriting/par/marineHull/marineHullItemInfoMain.jsp";
				} else if("showEndtMarineHullItemInfo".equals(ACTION)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("request", request);
					params.put("response", response);
					params.put("applicationContext", APPLICATION_CONTEXT);
					params.put("USER", USER);
					
					request.setAttribute("formMap", new JSONObject(gipiWItemVesService.gipis081NewFormInstance(params)));
					message = "SUCCESS";
					PAGE = "/pages/underwriting/endt/jsonMarineHull/endtMarineHullItemInfoMain.jsp";					
				} else if("saveMHItemInfo".equals(ACTION)) {
					gipiWItemVesService.saveGIPIWItemVes(request.getParameter("parameters"), USER);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}
			} 
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
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
	
	private Map<String, Object> getUpdateGIPIWPolbasParams(HttpServletRequest request){
		
		int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
		String negateItem = request.getParameter("varNegateItem");
		String prorateFlag = request.getParameter("varProrateFlag");
		String compSw = request.getParameter("varCompSw");
		String endtExpiryDate = request.getParameter("varEndtExpiryDate");
		String effDate = request.getParameter("varEffDate");
		BigDecimal shortRtPercent = request.getParameter("varShortRtPercent") == "" ? null : new BigDecimal(request.getParameter("varShortRtPercent"));
		String expiryDate = request.getParameter("varExpiryDate");
		
		log.info("parId: "+parId);
		log.info("negateItem: "+negateItem);
		log.info("prorateFlag: "+prorateFlag);
		log.info("compSw: "+compSw);
		log.info("endtExpiryDate: "+endtExpiryDate);
		log.info("effDate: "+effDate);
		log.info("shortRtPercent: "+shortRtPercent);
		log.info("expiryDate: "+expiryDate);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("negateItem", negateItem);
		params.put("prorateFlag", prorateFlag);
		params.put("compSw", compSw);
		params.put("endtExpiryDate", endtExpiryDate);
		params.put("effDate", effDate);
		params.put("shortRtPercent", shortRtPercent);
		params.put("expiryDate", expiryDate);
		return params;
	}

}
