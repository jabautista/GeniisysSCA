/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
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
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWFireItm;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIWFireItmService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.geniisys.gipi.util.GIPIWDeductiblesUtil;
import com.geniisys.gipi.util.GIPIWItemPerilUtil;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWFireItmController.
 */
public class GIPIWFireItmController extends BaseController{	
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWFireItmController.class);
	
	/* (non-Javadoc
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/* default attributes */	
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());			
			
			if("showFireItemInfo".equals(ACTION)){
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWFireItmService.newFormInstance(params)));				
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/par/fire/fireItemInformationMain.jsp";
			} else if("getGIPIWItemTableGridFI".equals(ACTION)){				
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWFireItmService.newFormInstanceTG(params)));				
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/parTableGrid/fire/fireItemInformationMain.jsp";							
			} else if("showEndtFireItemInfo".equals(ACTION)){
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWFireItmService.gipis039NewFormInstance(params)));
				
				//Added by Apollo Cruz 01.06.2014
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap = gipiWFireItmService.getFireParameters();
				
				request.setAttribute("paramRiskTag", resultMap.get("riskTag").toString());
				request.setAttribute("paramConstruction", resultMap.get("construction").toString());
				request.setAttribute("paramOccupancy", resultMap.get("occupancy").toString());
				request.setAttribute("paramRiskNo", resultMap.get("riskNo").toString());
				request.setAttribute("paramItemType", resultMap.get("itemType").toString());
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/endt/jsonFire/endtFireItemInformationMain.jsp";
			}else if("saveParFIItems".equals(ACTION)){
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService");
				gipiWFireItmService.saveGIPIWFireItm(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showBlock".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] blockParams = {request.getParameter("regionCd"), request.getParameter("provinceCd"), request.getParameter("cityCd"), request.getParameter("districtNo")};
				request.setAttribute("blockListing",lovHelper.getList(LOVHelper.BLOCK_LISTING, blockParams));
				request.setAttribute("column", request.getParameter("column"));
				PAGE = "/pages/underwriting/overlay/block.jsp";
			}else if("showCity".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] cityParams = {request.getParameter("regionCd"), request.getParameter("provinceCd")};
				request.setAttribute("cityListing", lovHelper.getList(LOVHelper.CITY_BY_PROVINCE_LISTING, cityParams));
				request.setAttribute("column", request.getParameter("column"));
				PAGE = "/pages/underwriting/overlay/city.jsp";
			}else if("showRisks".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] riskParams = {request.getParameter("blockId")};
				request.setAttribute("riskListing", lovHelper.getList(LOVHelper.RISK_LISTING, riskParams));
				PAGE = "/pages/underwriting/overlay/risks.jsp";
			}else if("showOccupancy".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				request.setAttribute("occupancyListing", lovHelper.getList(LOVHelper.FIRE_OCCUPANCY_LISTING));
				PAGE = "/pages/underwriting/overlay/occupancy.jsp";			
			}else if("showFireEndtItemInfo".equals(ACTION)){
				int parId = Integer.parseInt(request.getParameter("globalParId"));
				GIPIPARList gipiPAR = null;
				if (parId != 0)	{
					GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
					gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
					gipiPAR.setParId(parId);
					request.setAttribute("parDetails", gipiPAR);
					System.out.println("discExists: "+gipiPAR.getDiscExists());
				}
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);
				
				String lineCd = par.getLineCd();
				String sublineCd = par.getSublineCd();
				String assdNo = par.getAssdNo() == null ? new String("") : par.getAssdNo();
				System.out.println("Assured No: " + par.getAssdNo());
				request.setAttribute("wPolBasic", par);
				request.setAttribute("parId", parId);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("sublineCd", sublineCd);
				request.setAttribute("parNo", request.getParameter("globalParNo"));
				request.setAttribute("assdName", request.getParameter("globalAssdName"));
				
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				String parType = request.getParameter("globalParType");
				Map<String, Object> params = new HashMap<String, Object>();
				
				String renewNo = par.getRenewNo() == null ? new String("") : par.getRenewNo();
				
				// load the basic variable values
				params.put("parId", parId);
				params.put("parType", parType);
				params.put("assdNo", ("".equals(assdNo.trim())) ? null : new Integer(assdNo));
				params.put("gipiParIssCd", gipiPAR.getIssCd());
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("issCd", par.getIssCd());
				params.put("issueYy", par.getIssueYy());
				params.put("polSeqNo", par.getPolSeqNo() == null ? null : par.getPolSeqNo().toString());
				params.put("renewNo", ("".equals(renewNo.trim())) ? null : new Integer(renewNo));
				params.put("effDate", par.getEffDate());
				params.put("expiryDate", par.getExpiryDate());
				
				log.info("Load the Basic Variable values:");
				log.info("Par Id : " + params.get("parId"));
				log.info("Par Type : " + params.get("parType"));
				log.info("Assd No : " + params.get("assdNo"));
				log.info("Gipi Par Iss Cd : " + params.get("gipiParIssCd"));
				log.info("Line Cd: " + params.get("lineCd"));
				log.info("subline Cd : " + params.get("sublineCd"));
				log.info("Iss Cd : " + params.get("issCd"));
				log.info("Issue Yy : " + params.get("issueYy"));
				log.info("Pol Seq NO : " + params.get("polSeqNo"));
				log.info("Renew No : " + params.get("renewNo"));
				log.info("Eff Date : " + params.get("effDate"));
				log.info("Expiry Date : " + params.get("expiryDate"));
				
				System.out.println("Assd No: " + params.get("assdNo"));
				
				params = gipiWFireItmService.getGIPIS039BasicVarValues(params);
				
				// change ampersand sign
				String[] fields = {"newEndtAddress1", "newEndtAddress2", "newEndtAddress3",
									"mailingAddress1", "mailingAddress2", "mailingAddress3"};
				
				log.info("Changing ampersand signs...");
				for (int i = 0; i < fields.length; i++) {
					String val = (String)params.get(fields[i]);
					
					if (val != null) {
						params.put(fields[i], val.replaceAll("&", "&amp;"));
					}
					
					log.info(fields[i] + ": " + val);
				}
				
				log.info("Iss Cd RI : " + params.get("issCdRi"));
				log.info("Param by iss cd : " + params.get("paramByIssCd"));
				log.info("Deductible exist : " + params.get("deductibleExist"));
				log.info("Display risk : " + params.get("displayRisk"));
				log.info("Allow update curr rate : " + params.get("allowUpdateCurrRate"));
				log.info("Buildings : " + params.get("buildings"));
				log.info("New Endt Address 1 : " + params.get("newEndtAddress1"));
				log.info("New Endt Address 2 : " + params.get("newEndtAddress2"));
				log.info("New Endt Address 3 : " + params.get("newEndtAddress3"));
				log.info("Mailing Address 1 : " + params.get("mailingAddress1"));
				log.info("Mailing Address 2 : " + params.get("mailingAddress2"));
				log.info("Mailing Address 3 : " + params.get("mailingAddress3"));
				log.info("wfireItmList Size : " + params.get("wfireItmList") == null ? "0" : ((List<GIPIWFireItm>)params.get("wfireItmList")).size());
				
				// start
				
				request.setAttribute("fromDate",df.format(par.getInceptDate()));
				request.setAttribute("toDate", df.format(par.getExpiryDate()));
				
				List<GIPIWFireItm> fireItems = (List<GIPIWFireItm>)params.get("wfireItmList");
				int itemSize = fireItems == null ? 0 : fireItems.size();
				
				if(par.getAddress1() != null | par.getAddress2() != null | par.getAddress3() != null){					
					request.setAttribute("mailAddr1", par.getAddress1());
					request.setAttribute("mailAddr2", par.getAddress2());
					request.setAttribute("mailAddr3", par.getAddress3());
				} else{
					request.setAttribute("mailAddr1", params.get("mailingAddress1"));
					request.setAttribute("mailAddr2", params.get("mailingAddress2"));
					request.setAttribute("mailAddr3", params.get("mailingAddress3"));
				}
				
				StringBuilder arrayItemNo = new StringBuilder(itemSize);
				StringBuilder arrayRiskNo = new StringBuilder(itemSize);
				StringBuilder arrayRiskItemNo = new StringBuilder(itemSize);
				for(GIPIWFireItm f : fireItems){					
					arrayItemNo.append(f.getItemNo() + " ");
					arrayRiskNo.append((f.getRiskNo() == null ? "*" : f.getRiskNo()) + " ");
					arrayRiskItemNo.append((f.getRiskItemNo() == null ? "0" : f.getRiskItemNo()) + " ");					
				}
				
				request.setAttribute("items", fireItems);
				request.setAttribute("itemNumbers", arrayItemNo);
				request.setAttribute("riskNumbers", arrayRiskNo);
				request.setAttribute("riskItemNumbers", arrayRiskItemNo);
				
				String[] lineSubLineParams = {par.getLineCd(), par.getSublineCd()};
				
				request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));								
				request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
				
				String[] groupParam = {assdNo};	
				request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
				request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
				
				request.setAttribute("eqZoneList", helper.getList(LOVHelper.EQ_ZONE_LISTING));
				request.setAttribute("typhoonList", helper.getList(LOVHelper.TYPHOON_ZONE_LISTING));
				request.setAttribute("itemTypeList", helper.getList(LOVHelper.FIRE_ITEM_TYPE_LISTING));
				request.setAttribute("floodList", helper.getList(LOVHelper.FLOOD_ZONE_LISTING));
				request.setAttribute("regionList", helper.getList(LOVHelper.REGION_LISTING));
				request.setAttribute("tariffZoneList", helper.getList(LOVHelper.TARIFF_ZONE_LISTING, lineSubLineParams));
				request.setAttribute("tariffList", helper.getList(LOVHelper.TARIFF_LISTING));
				String[] perilTariffParam = {"FI"}; 
				List<LOV> perilTariffList = helper.getList(LOVHelper.PERIL_TARIFF_LISTING, perilTariffParam);
				System.out.println("PERIL TARIFF LIST: "+perilTariffList.size());
				request.setAttribute("perilTariffList", perilTariffList);
				request.setAttribute("itemsWPerilGroupedListing", new JSONArray (gipiWItemService.getGIPIWItem(parId)));
				
				//List<List<LOV>> cityList = new ArrayList<List<LOV>>();
				//List<Object[]> districtList = new ArrayList<Object[]>();
				//List<Object[]> blockList = new ArrayList<Object[]>();
				//List<LOV> riskList = helper.getList(LOVHelper.ALL_RISKS_LISTING); commented by: nica
				
				request.setAttribute("provinceList", helper.getList(LOVHelper.PROVINCE_LISTING));
				//request.setAttribute("cityList", helper.getList(LOVHelper.ALL_CITY_LISTING));
				//request.setAttribute("districtList", helper.getList(LOVHelper.ALL_DISTRICT_LISTING));
				//request.setAttribute("blockList",helper.getList(LOVHelper.ALL_BLOCK_LISTING));
				//request.setAttribute("riskList", helper.getList(LOVHelper.ALL_RISKS_LISTING));
				
				//added by: nica for sorting of LOV
				// province list into JSON object
				List<LOV> provinces = helper.getList(LOVHelper.PROVINCE_LISTING);
				StringFormatter.replaceQuotesInList(provinces);
				request.setAttribute("objProvinceListing", new JSONArray(provinces));
				
				// city list into JSON object
				List<LOV> cities = helper.getList(LOVHelper.ALL_CITY_LISTING);
				StringFormatter.replaceQuotesInList(cities);
				request.setAttribute("objCityListing", new JSONArray(cities));
				
				// district list into JSON object
				List<LOV> districts = helper.getList(LOVHelper.ALL_DISTRICT_LISTING);
				StringFormatter.replaceQuotesInList(districts);
				request.setAttribute("objDistrictListing", new JSONArray(districts));

				// block list into JSON object
				List<LOV> blocks = helper.getList(LOVHelper.ALL_BLOCK_LISTING);
				StringFormatter.replaceQuotesInList(blocks);
				request.setAttribute("objBlockListing", new JSONArray(blocks));
				
				// risk list into JSON object
				List<LOV> risks = helper.getList(LOVHelper.ALL_RISKS_LISTING);
				StringFormatter.replaceQuotesInList(risks);
				request.setAttribute("objRiskListing", new JSONArray(risks));
				
				String issCdRi = (String)params.get("issCdRi");
				request.setAttribute("issCdRi", issCdRi);
				request.setAttribute("paramName", params.get("paramByIssCd"));
				String pDeductibleExist = (String) params.get("deductibleExist"); 
				request.setAttribute("pDeductibleExist", pDeductibleExist);
				
				request.setAttribute("constructionList", helper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
				request.setAttribute("occupancyList", helper.getList(LOVHelper.FIRE_OCCUPANCY_LISTING));
				
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap = gipiWFireItmService.getFireParameters();
				if("SUCCESS".equals(resultMap.get("result").toString())){					
					message = resultMap.toString();
				}
				request.setAttribute("paramRiskTag", resultMap.get("riskTag").toString());
				request.setAttribute("paramConstruction", resultMap.get("construction").toString());
				request.setAttribute("paramOccupancy", resultMap.get("occupancy").toString());
				request.setAttribute("paramRiskNo", resultMap.get("riskNo").toString());
				request.setAttribute("paramItemType", resultMap.get("itemType").toString());
				
				/* Perils*/
				String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
				request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
									
				//for endt par
				PAGE = "/pages/underwriting/itemInformation.jsp";
				
				if (parType != null) {
					if ("E".equals(parType)) {
						String pDisplayRisk = (String)params.get("displayRisk");
						String pAllowUpdateCurrRate = (String)params.get("allowUpdateCurrRate");
						String pFireItemTypeBldg = (String)params.get("buildings");
						String policyNo =lineCd + " - " + sublineCd + " - " + par.getIssCd() + " - " + par.getIssueYy().toString() + " - " + 
						((par.getPolSeqNo() == null) ? "" : par.getPolSeqNo().toString()) + " - " + par.getRenewNo();

						request.setAttribute("pDisplayRisk", pDisplayRisk);
						request.setAttribute("pAllowUpdateCurrRate", pAllowUpdateCurrRate);
						request.setAttribute("pFireItemTypeBldg", pFireItemTypeBldg);
						request.setAttribute("policyNo", policyNo);
						request.setAttribute("parType", parType);
						request.setAttribute("address1", par.getAddress1());
						request.setAttribute("address2", par.getAddress2());
						request.setAttribute("address3", par.getAddress3());
						request.setAttribute("polbasicAddress1", params.get("newEndtAddress1"));
						request.setAttribute("polbasicAddress2", params.get("newEndtAddress2"));
						request.setAttribute("polbasicAddress3", params.get("newEndtAddress3"));
						request.setAttribute("assdMailAddress1", params.get("mailingAddress1"));
						request.setAttribute("assdMailAddress2", params.get("mailingAddress2"));
						request.setAttribute("assdMailAddress3", params.get("mailingAddress3"));
						
						PAGE = "/pages/underwriting/endt/fire/endtFireItemInformationMain.jsp";
					}
				}
				
//				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
//				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
//				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
//				String parType = request.getParameter("globalParType");
//				
//				Map<String, Object> mailingAddress = new HashMap<String, Object>();
//				mailingAddress = gipiWFireItmService.getAssuredMailingAddress(Integer.parseInt(par.getAssdNo()));
//									
//				request.setAttribute("fromDate", df.format(par.getInceptDate()));
//				request.setAttribute("toDate", df.format(par.getExpiryDate()));
//				
//				List<GIPIWFireItm> fireItems = gipiWFireItmService.getGIPIWFireItems(parId);
//				int itemSize = 0;
//				itemSize = fireItems.size();
//				//request.setAttribute("maxRiskItemNo", itemService.getMaxRiskItemNo(parId, 1));
//				
//				if(par.getAddress1() != null | par.getAddress2() != null | par.getAddress3() != null){					
//					request.setAttribute("mailAddr1", par.getAddress1());
//					request.setAttribute("mailAddr2", par.getAddress2());
//					request.setAttribute("mailAddr3", par.getAddress3());
//				} else{
//					request.setAttribute("mailAddr1", mailingAddress.get("mailAddr1"));
//					request.setAttribute("mailAddr2", mailingAddress.get("mailAddr2"));
//					request.setAttribute("mailAddr3", mailingAddress.get("mailAddr3"));
//				}				
//				
//				StringBuilder arrayItemNo = new StringBuilder(itemSize);
//				StringBuilder arrayRiskNo = new StringBuilder(itemSize);
//				StringBuilder arrayRiskItemNo = new StringBuilder(itemSize);
//				for(GIPIWFireItm f : fireItems){					
//					arrayItemNo.append(f.getItemNo() + " ");
//					arrayRiskNo.append((f.getRiskNo() == null ? "*" : f.getRiskNo()) + " ");
//					arrayRiskItemNo.append((f.getRiskItemNo() == null ? "0" : f.getRiskItemNo()) + " ");					
//				}
//				
//				request.setAttribute("items", fireItems);
//				request.setAttribute("itemNumbers", arrayItemNo);
//				request.setAttribute("riskNumbers", arrayRiskNo);
//				request.setAttribute("riskItemNumbers", arrayRiskItemNo);
//				
//				String[] lineSubLineParams = {par.getLineCd(), par.getSublineCd()};
//				
//				request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));								
//				request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
//				
//				String[] groupParam = {assdNo};	
//				request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
//				request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
//				
//				request.setAttribute("eqZoneList", helper.getList(LOVHelper.EQ_ZONE_LISTING));
//				request.setAttribute("typhoonList", helper.getList(LOVHelper.TYPHOON_ZONE_LISTING));
//				request.setAttribute("itemTypeList", helper.getList(LOVHelper.FIRE_ITEM_TYPE_LISTING));
//				request.setAttribute("floodList", helper.getList(LOVHelper.FLOOD_ZONE_LISTING));
//				request.setAttribute("regionList", helper.getList(LOVHelper.REGION_LISTING));
//				request.setAttribute("tariffZoneList", helper.getList(LOVHelper.TARIFF_ZONE_LISTING, lineSubLineParams));
//				request.setAttribute("tariffList", helper.getList(LOVHelper.TARIFF_LISTING));
//				
//				List<LOV> provinceList = helper.getList(LOVHelper.PROVINCE_LISTING);
//				List<List<LOV>> cityList = new ArrayList<List<LOV>>();
//				List<Object[]> districtList = new ArrayList<Object[]>();
//				List<Object[]> blockList = new ArrayList<Object[]>();
//				List<LOV> riskList = helper.getList(LOVHelper.ALL_RISKS_LISTING);
//				Object[] provinces = provinceList.toArray(); // Array of provinces
//				Object[] cities; // Array of cities
//				Object[] districts; // Array of districts
//				Object[] blocks; // Array of blocks
//				
//				log.info("Getting LOVs");
//				for (int i = 0; i < provinces.length; i++) {
//					//city
//					String[] cityArgs = {((GIISProvince)provinces[i]).getProvinceDesc()};
//					List<LOV> citySublist = helper.getList(LOVHelper.CITY_LISTING,cityArgs);
//					cityList.add(citySublist);
//					cities = citySublist.toArray();
//					
//					//district
//					
//					if (cities.length == 0) {
//						GIISCity city = new GIISCity();
//						city.setCity("");
//						cities = new GIISCity[1];
//						cities[0] = city;
//					} 
//					
//					for (int j = 0; j < cities.length; j++) {
//						String province = ((GIISProvince)provinces[i]).getProvinceDesc();
//						String city = ((GIISCity)cities[j]).getCity();
//						String[] districtArgs = {province, city};
//						//log.info("City " + i + " : " + districtArgs[1]);
//						List<LOV> districtSublist = helper.getList(LOVHelper.DISTRICT_LISTING,districtArgs);
//						districts = districtSublist.toArray();
//						
//						if (districts.length == 0) {
//							GIISBlock block = new GIISBlock();
//							block.setCity(city);
//							block.setProvince(province);
//							block.setDistrictNo("");
//							districts = new GIISBlock[1];
//							districts[0] = block;
//						} 
//						
//						for (int x = 0; x < districts.length; x++) {
//							String district = ((GIISBlock)districts[x]).getDistrictNo();
//							String[] blockArgs = {province, city, district};
//							((GIISBlock)districts[x]).setCity(city);
//							((GIISBlock)districts[x]).setProvince(province);
//							
//							blocks = helper.getList(LOVHelper.BLOCK_LISTING,blockArgs).toArray();
//							
//							//block
//							
//							if (blocks.length == 0 ) {
//								GIISBlock block = new GIISBlock();
//								block.setDistrictNo("");
//								blocks = new GIISBlock[1];
//								blocks[0] = block;
//							}
//							
//							log.info("Blocks size : " + blocks.length);
//							
//							for (int y = 0; y < blocks.length; y++) {
//								log.info("Block is " + blocks[y] == null ? "null" : "not null");
//								log.info("blocks class : " + blocks[y].getClass().toString());
//								((GIISBlock)blocks[y]).setCity(city);
//								((GIISBlock)blocks[y]).setProvince(province);
//								((GIISBlock)blocks[y]).setDistrictNo(district);
//							}
//					
//							blockList.add(blocks);
//						}
//						
//						districtList.add(districts);
//					}
//				}
//				
//				log.info("District LOV Size : " + districtList.size());
//				log.info("Risk LOV Size : " + riskList.size());
//				
//				request.setAttribute("provinceList", provinceList);
//				request.setAttribute("cityLOVList", cityList);
//				request.setAttribute("districtLOVList", districtList);
//				request.setAttribute("blockLOVList", blockList);
//				request.setAttribute("riskLOVList", riskList);
//				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
//				String issCdRi = serv.getParamValueV2("ISS_CD_RI");
//				request.setAttribute("issCdRi", issCdRi);
//				request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
//				GIPIWDeductibleFacadeService gipiWdeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
//				String pDeductibleExist = gipiWdeductibleService.isExistGipiWdeductible(parId, lineCd, sublineCd); 
//				request.setAttribute("pDeductibleExist", pDeductibleExist);
//				
//				/*
//				String[] districtArgs = {"*", "*"};
//				String[] blockArgs = {"*", "*", "*"};
//				
//				request.setAttribute("cityList", helper.getList(LOVHelper.CITY_LISTING));
//				request.setAttribute("districtList", helper.getList(LOVHelper.DISTRICT_LISTING, districtArgs));				
//				request.setAttribute("blockList", helper.getList(LOVHelper.BLOCK_LISTING, blockArgs));
//				request.setAttribute("riskList", helper.getList(LOVHelper.RISK_LISTING));
//				*/
//				
//				
//				request.setAttribute("constructionList", helper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
//				request.setAttribute("occupancyList", helper.getList(LOVHelper.FIRE_OCCUPANCY_LISTING));
//				
//				Map<String, Object> resultMap = new HashMap<String, Object>();
//				resultMap = gipiWFireItmService.getFireParameters();
//				if("SUCCESS".equals(resultMap.get("result").toString())){					
//					message = resultMap.toString();
//				}
//				request.setAttribute("paramRiskTag", resultMap.get("riskTag").toString());
//				request.setAttribute("paramConstruction", resultMap.get("construction").toString());
//				request.setAttribute("paramOccupancy", resultMap.get("occupancy").toString());
//				request.setAttribute("paramRiskNo", resultMap.get("riskNo").toString());
//				request.setAttribute("paramItemType", resultMap.get("itemType").toString());
//				
//				/* Perils*/
//				String[] perilParam = {"" /*packLineCd*/, lineCd, "" /*packSublineCd*/, sublineCd, Integer.toString(parId)};					
//				request.setAttribute("perilListing", helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam));
//									
//				//for endt par
//				PAGE = "/pages/underwriting/itemInformation.jsp";
//				
//				log.info("Par type: " + parType);
//				if (parType != null) {
//					if ("E".equals(parType)) {
//						GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
//						GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
//						
//						String pDisplayRisk = giisParamService.getParamValueV2("DISPLAY_RISK");
//						String pAllowUpdateCurrRate = giisParamService.getParamValueV2("ALLOW_UPDATE_CURR_RATE");
//						String pFireItemTypeBldg = giisParamService.getParamValueV2("BUILDINGS");
//						String policyNo =lineCd + " - " + sublineCd + " - " + par.getIssCd() + " - " + par.getIssueYy().toString() + " - " + 
//						((par.getPolSeqNo() == null) ? "" : par.getPolSeqNo().toString()) + " - " + par.getRenewNo();
//
//						Map<String, Object> params = new HashMap<String, Object>();
//						
//						//get addresses from gipi_polbasic
//						params.put("lineCd", par.getLineCd());
//						params.put("sublineCd", par.getSublineCd());
//						params.put("issCd", par.getIssCd());
//						params.put("issueYy", par.getIssueYy());
//						params.put("polSeqNo", par.getPolSeqNo());
//						params.put("renewNo", par.getRenewNo());
//						params.put("effDate", par.getEffDate());
//						params.put("expiryDate", par.getExpiryDate());
//						params = gipiPolbasicService.getAddressForNewEndtItem(params);
//						
//						request.setAttribute("pDisplayRisk", pDisplayRisk);
//						request.setAttribute("pAllowUpdateCurrRate", pAllowUpdateCurrRate);
//						request.setAttribute("pFireItemTypeBldg", pFireItemTypeBldg);
//						request.setAttribute("policyNo", policyNo);
//						request.setAttribute("parType", parType);
//						request.setAttribute("address1", par.getAddress1());
//						request.setAttribute("address2", par.getAddress2());
//						request.setAttribute("address3", par.getAddress3());
//						request.setAttribute("polbasicAddress1", params.get("address1"));
//						request.setAttribute("polbasicAddress2", params.get("address2"));
//						request.setAttribute("polbasicAddress3", params.get("address3"));
//						request.setAttribute("assdMailAddress1", mailingAddress.get("mailAddr1"));
//						request.setAttribute("assdMailAddress2", mailingAddress.get("mailAddr2"));
//						request.setAttribute("assdMailAddress3", mailingAddress.get("mailAddr3"));
//						
//						PAGE = "/pages/underwriting/endtItemInformation.jsp";
//					}
//				}
			} else if("saveGipiParFireItem".equals(ACTION)){				
				
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
				GIPIParMortgageeFacadeService gipiParMortgageeService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService"); // +env
				
				Map<String, Object> param = new HashMap<String, Object>();
				
				int parId = Integer.parseInt(request.getParameter("globalParId"));
				
				//item info
				//Map<String, Object> insItemMap = GIPIWItemUtil.prepareGipiWItemForInsertUpdate(request);
				Map<String, Object> delItemMap = GIPIWItemUtil.prepareGipiWItemForDelete(request);
				List<GIPIWFireItm> fireItemMap = prepareGIPIWFireItm(request);
				Map<String, Object> globals = new HashMap<String, Object>();
				Map<String, Object> vars = new HashMap<String, Object>();
				Map<String, Object> pars = new HashMap<String, Object>();
				Map<String, Object> others = new HashMap<String, Object>();
				JSONObject params = new JSONObject(request.getParameter("parameters"));
				// item deductibles
				String[] insDedItemNos	= request.getParameterValues("insDedItemNo2");
				String[] delDedItemNos	= request.getParameterValues("delDedItemNo2");
				
				//mortgagee
				//String[] insMortgItemNos = request.getParameterValues("insMortgItemNos");
				//String[] delMortgItemNos = request.getParameterValues("delMortgageeItemNos");
				
				//item perils
				//String[] insItemPerilItemNos = request.getParameterValues("perilItemNos");
				//String[] delItemPerilItemNos = request.getParameterValues("delPerilItemNos");
				
				//peril deductibles
				String[] insPerilDedItemNos	= request.getParameterValues("insDedItemNo3");
				String[] delPerilDedItemNos	= request.getParameterValues("delDedItemNo3");
				
				String element = "";
				for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();){
					element = e.nextElement();
					if("var".equals(element.substring(0, 3))){
						vars.put(element, request.getParameter(element));
					}else if("par".equals(element.substring(0, 3))){
						pars.put(element, request.getParameter(element));
					}else if(element.contains("global")){
						globals.put(element, request.getParameter(element));
					}else{
						others.put(element, request.getParameter(element));
					}
				
				}
				
				param.put("delItemMap", delItemMap);
				param.put("fireItemMap", fireItemMap);
				param.put("globals", globals);
				param.put("vars", vars);
				param.put("pars", pars);
				param.put("others", others);
				param.put("parId", parId);
				param.put("userId", USER.getUserId());
				System.out.println("UserId:" + USER.getUserId());
				param.put("gipiParList", GIPIPARUtil.prepareGIPIParList(request));
				param.put("itemList", GIPIWItemUtil.prepareGIPIWItems(request));
				param.put("fireItemList", prepareGIPIWFireItm(request));
				
				//item deductible
				if(insDedItemNos != null){
					param.put("deductibleInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 2));
				}
				if(delDedItemNos != null){
					param.put("deductibleDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 2));
				}
				
				//mortgagee
				/*
				if(insMortgItemNos != null){
					param.put("mortgageeInsList", GIPIWMortgageeUtil.prepareInsGipiWMortgageeList(request, USER));
				}
				if(delMortgItemNos != null){
					param.put("mortgageeDelList", GIPIWMortgageeUtil.prepareDelGipiWMortgageeList(request));
				}
				*/
				
				GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
				param.put("perilInsList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("setPerils"))));
				param.put("perilDelList", gipiWItemPerilService.prepareGIPIWItemPerilsListing(new JSONArray(params.getString("delPerils"))));
				
				GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
				param.put("wcInsList", gipiWPolWCService.prepareGIPIWPolWCForInsert(new JSONArray(params.getString("setWCs"))));
				
				param.put("mortgageeInsList", gipiParMortgageeService.prepareGIPIWMortgageeForInsert(new JSONArray(params.getString("setMortgagees"))));
				param.put("mortgageeDelList", gipiParMortgageeService.prepareGIPIWMortgageeForDelete(new JSONArray(params.getString("delMortgagees"))));
				
				//item perils
				/*if(insItemPerilItemNos != null){
					param.put("itemPerilInsList", GIPIWItemPerilUtil.prepareInsItemPerilList(request));
				}
				if(delItemPerilItemNos != null){
					param.put("itemPerilDelList", GIPIWItemPerilUtil.prepareDelGipiWDeductiblesList(request));
				}*/
				
				//peril deductible
				if(insPerilDedItemNos != null){
					param.put("perilDedInsList", GIPIWDeductiblesUtil.prepareInsGipiWDeductiblesList(request, USER, 3));
				}
				if(delPerilDedItemNos != null){
					param.put("perilDedDelList", GIPIWDeductiblesUtil.prepareDelGipiWDeductiblesList(request, 3));
				}
				
				//add peril variables to map
				param = GIPIWItemPerilUtil.loadPerilVariablesToMap(request, param);
				
				
				/*if(request.getParameterValues("itemItemNos") != null && !(request.getParameterValues("frItemTypes").toString().isEmpty())){
					
					String[] parIds					= request.getParameterValues("itemParIds");
					String[] itemNos 				= request.getParameterValues("itemItemNos");
					String[] districtNos			= request.getParameterValues("districtNos");
					String[] eqZones				= request.getParameterValues("eqZones");
					String[] tarfCds				= request.getParameterValues("tarfCds");
					String[] blockNos				= request.getParameterValues("blockNos");
					String[] frItemTypes			= request.getParameterValues("frItemTypes");
					String[] locRisk1s				= request.getParameterValues("locRisk1s");
					String[] locRisk2s				= request.getParameterValues("locRisk2s");
					String[] locRisk3s				= request.getParameterValues("locRisk3s");
					String[] tariffZones			= request.getParameterValues("tariffZones");
					String[] typhoonZones			= request.getParameterValues("typhoonZones");
					String[] constructionCds		= request.getParameterValues("constructionCds");
					String[] constructionRemarkss	= request.getParameterValues("constructionRemarkss");
					String[] fronts					= request.getParameterValues("fronts");
					String[] rights					= request.getParameterValues("rights");
					String[] lefts					= request.getParameterValues("lefts");
					String[] rears					= request.getParameterValues("rears");
					String[] occupancyCds			= request.getParameterValues("occupancyCds");
					String[] occupancyRemarkss		= request.getParameterValues("occupancyRemarkss");
					String[] assignees				= request.getParameterValues("assignees");
					String[] floodZones				= request.getParameterValues("floodZones");
					String[] blockIds				= request.getParameterValues("blockIds");
					String[] riskCds				= request.getParameterValues("riskCds");
					
					Map<String, Object> fireItems = new HashMap<String, Object>();
					fireItems.put("parIds", parIds);
					fireItems.put("itemNos", itemNos);
					fireItems.put("districtNos", districtNos);
					fireItems.put("eqZones", eqZones);
					fireItems.put("tarfCds", tarfCds);
					fireItems.put("blockNos", blockNos);
					fireItems.put("frItemTypes", frItemTypes);
					fireItems.put("locRisk1s", locRisk1s);
					fireItems.put("locRisk2s", locRisk2s);
					fireItems.put("locRisk3s", locRisk3s);
					fireItems.put("tariffZones", tariffZones);
					fireItems.put("typhoonZones", typhoonZones);
					fireItems.put("constructionCds", constructionCds);
					fireItems.put("constructionRemarkss", constructionRemarkss);
					fireItems.put("fronts", fronts);
					fireItems.put("rights", rights);
					fireItems.put("lefts", lefts);
					fireItems.put("rears", rears);
					fireItems.put("occupancyCds", occupancyCds);
					fireItems.put("occupancyRemarkss", occupancyRemarkss);
					fireItems.put("assignees", assignees);
					fireItems.put("floodZones", floodZones);
					fireItems.put("blockIds", blockIds);
					fireItems.put("riskCds",riskCds );
					
					gipiWFireItmService.setGIPIWFireItem(fireItems);
					request.setAttribute("message", "Item saved.");*/
					if(gipiWFireItmService.saveFireItem(param)){
						message = "SUCCESS";	
					}else{
						message = "FAILED";
					}
					
					PAGE = "/pages/genericMessage.jsp";
				//}				
			} else if("filterCityByProvince".equals(ACTION)){
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				String[] args = {(request.getParameter("province")==null || request.getParameter("province").equals("")) ? "0" : request.getParameter("province")};
				log.info("Province : " + request.getParameter("province"));
				String width = request.getParameter("elementWidth");
				request.setAttribute("cityList", helper.getList(LOVHelper.CITY_LISTING,args)== null ? "" : helper.getList(LOVHelper.CITY_LISTING,args));
				request.setAttribute("width", width);
				PAGE = "/pages/underwriting/dynamicDropDown/cityByProvince.jsp";
			} else if("filterDistrictByProvinceByCity".equals(ACTION)){
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				String[] args = {request.getParameter("province"), request.getParameter("city")};
				log.info("Province : " + request.getParameter("province"));
				log.info("City : " + request.getParameter("city"));
				String width = request.getParameter("elementWidth");	
				request.setAttribute("districtList", helper.getList(LOVHelper.DISTRICT_LISTING,args)== null ? "" : helper.getList(LOVHelper.DISTRICT_LISTING,args));
				request.setAttribute("width", width);
				PAGE = "/pages/underwriting/dynamicDropDown/districtByProvinceByCity.jsp";
			} else if("filterBlock".equals(ACTION)){
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				String[] args = {request.getParameter("province"), request.getParameter("city"), request.getParameter("district")};
				log.info("Province : " + request.getParameter("province"));
				log.info("City : " + request.getParameter("city"));
				log.info("District : " + request.getParameter("district"));
				String width = request.getParameter("elementWidth");							
				request.setAttribute("blockList", helper.getList(LOVHelper.BLOCK_LISTING,args)== null ? "" : helper.getList(LOVHelper.BLOCK_LISTING,args));
				request.setAttribute("width", width);
				PAGE = "/pages/underwriting/dynamicDropDown/block.jsp";
			} else if("filterRisk".equals(ACTION)){
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				String[] args = {(request.getParameter("block")==null || request.getParameter("block").equals("")) ? "0" : request.getParameter("block")};
				log.info("Filter risk - block : " + request.getParameter("block"));
				log.info("Block : " + request.getParameter("block"));
				String width = request.getParameter("elementWidth");				
				request.setAttribute("riskList", helper.getList(LOVHelper.RISK_LISTING,args)== null ? "" : helper.getList(LOVHelper.RISK_LISTING,args));
				request.setAttribute("width", width);
				PAGE = "/pages/underwriting/dynamicDropDown/risks.jsp";
			} else if("getFireParameters".equals(ACTION)){
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
				Map<String, Object> resultMap = new HashMap<String, Object>();
				resultMap = gipiWFireItmService.getFireParameters();
				if("SUCCESS".equals(resultMap.get("result").toString())){					
					message = resultMap.toString();
				} else{					
					message = "SQL Exception Occurred";
				}							
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getFireTariff".equals(ACTION)){
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
				int parId = Integer.parseInt(request.getParameter("globalParId"));
				int itemNo = Integer.parseInt((request.getParameter("itemNo") == null || request.getParameter("itemNo") == "" ? "0" : request.getParameter("itemNo")));
				
				BigDecimal tariffRate = null;
				tariffRate = gipiWFireItmService.getFireTariff(parId, itemNo);
				
				message = "SUCCESS--" + tariffRate.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkAdditionalInfo".equals(ACTION)) {
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
				int parId = Integer.parseInt(request.getParameter("globalParId"));
				message = gipiWFireItmService.checkAddtlInfo(parId);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("gipis039B540WhenValidateItem".equals(ACTION)){
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService"); // +env
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("backEndt", request.getParameter("backEndt"));
				gipiWFireItmService.gipis03B9540WhenValidateItem(params);
				StringFormatter.replaceQuotesInMap(params);
				StringFormatter.replaceQuotesInListOfMap(params.get("endtItem"));
				System.out.println("WHEN VALIDATE ITEM PARAMS : " + params);
				message = new JSONObject(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getTariffZoneOccupancyValue".equals(ACTION)) {
				GIPIWFireItmService gipiWFireItmService = (GIPIWFireItmService) APPLICATION_CONTEXT.getBean("gipiWFireItmService");
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("tarfCd", request.getParameter("tarfCd"));
				
				params = gipiWFireItmService.getTariffZoneOccupancyValue(params);
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
	
	private List<GIPIWFireItm> prepareGIPIWFireItm(HttpServletRequest request){
		List<GIPIWFireItm> fireItemList = new ArrayList<GIPIWFireItm>();
		
		if(request.getParameterValues("itemItemNos") != null && !(request.getParameterValues("addlInfoFRItemTypes").toString().isEmpty())){
			String[] parIds					= request.getParameterValues("itemParIds");
			String[] itemNos 				= request.getParameterValues("itemItemNos");
			String[] districtNos			= request.getParameterValues("addlInfoDistrictNos");
			String[] eqZones				= request.getParameterValues("addlInfoEQZones");
			String[] tarfCds				= request.getParameterValues("addlInfoTarfCds");
			String[] blockNos				= request.getParameterValues("addlInfoBlockNos");
			String[] frItemTypes			= request.getParameterValues("addlInfoFRItemTypes");
			String[] locRisk1s				= request.getParameterValues("addlInfoLocRisk1s");
			String[] locRisk2s				= request.getParameterValues("addlInfoLocRisk2s");
			String[] locRisk3s				= request.getParameterValues("addlInfoLocRisk3s");
			String[] tariffZones			= request.getParameterValues("addlInfoTariffZones");
			String[] typhoonZones			= request.getParameterValues("addlInfoTyphoonZones");
			String[] constructionCds		= request.getParameterValues("addlInfoConstructionCds");
			String[] constructionRemarkss	= request.getParameterValues("addlInfoConstructionRemarkss");
			String[] fronts					= request.getParameterValues("addlInfoFronts");
			String[] rights					= request.getParameterValues("addlInfoRights");
			String[] lefts					= request.getParameterValues("addlInfoLefts");
			String[] rears					= request.getParameterValues("addlInfoRears");
			String[] occupancyCds			= request.getParameterValues("addlInfoOccupancyCds");
			String[] occupancyRemarkss		= request.getParameterValues("addlInfoOccupancyRemarkss");
			String[] assignees				= request.getParameterValues("addlInfoAssignees");
			String[] floodZones				= request.getParameterValues("addlInfoFloodZones");
			String[] blockIds				= request.getParameterValues("addlInfoBlockIds");
			String[] riskCds				= request.getParameterValues("addlInfoRiskCds");
			String[] regionCds				= request.getParameterValues("addlInfoRegionCds");
			
			for(int i=0, length= itemNos.length; i<length; i++){
				GIPIWFireItm fireItem = new GIPIWFireItm();
				
				  fireItem.setParId(Integer.parseInt(parIds[i]));
				  fireItem.setItemNo(Integer.parseInt(itemNos[i]));
				  fireItem.setDistrictNo(districtNos[i]);
				  fireItem.setEqZone(eqZones[i]);
				  fireItem.setTarfCd(tarfCds[i]);
				  fireItem.setBlockNo(blockNos[i]);
				  fireItem.setFrItemType(frItemTypes[i]);
				  fireItem.setLocRisk1(locRisk1s[i]);
				  fireItem.setLocRisk2(locRisk2s[i]);
				  fireItem.setLocRisk3(locRisk3s[i]);
				  fireItem.setTariffZone(tariffZones[i]);
				  fireItem.setTyphoonZone(typhoonZones[i]);
				  fireItem.setConstructionCd(constructionCds[i]);
				  fireItem.setConstructionRemarks(constructionRemarkss[i]);
				  fireItem.setFront(fronts[i]);
				  fireItem.setRight(rights[i]);
				  fireItem.setLeft(lefts[i]);
				  fireItem.setRear(rears[i]);
				  fireItem.setOccupancyCd(occupancyCds[i]);
				  fireItem.setOccupancyRemarks(occupancyRemarkss[i]);
				  fireItem.setAssignee(assignees[i]);
				  fireItem.setFloodZone(floodZones[i]);
				  fireItem.setBlockId(blockIds[i]);
				  fireItem.setRiskCd(riskCds[i]);
				  fireItem.setRegionCd(regionCds[i]);
				  fireItemList.add(fireItem);
			}
		}
		return fireItemList;
	}
}
