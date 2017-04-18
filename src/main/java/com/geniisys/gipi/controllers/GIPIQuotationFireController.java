/**
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemFI;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService;
import com.geniisys.lov.util.LOVUtil;
import com.seer.framework.util.ApplicationContextReader;

/**
 * The Class GIPIQuotationFireController.
 */
public class GIPIQuotationFireController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 8035004799679949423L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationFireController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env

		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/

			/* Services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteItemFIFacadeService gipiQuoteItemFIService = (GIPIQuoteItemFIFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFIFacadeService"); //  + env
			LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env

			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}

			if ("showFireAdditionalInformationPage".equalsIgnoreCase(ACTION)){
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));

				GIPIQuoteItemFI gipiQuoteItemFI = gipiQuoteItemFIService.getGIPIQuoteItemFI(quoteId, itemNo);

				if(gipiQuoteItemFI!=null){
					gipiQuoteItemFI.setLocRisk1(gipiQuoteItemFI.getLocRisk1() == "" ? "1" : gipiQuoteItemFI.getLocRisk1());
					gipiQuoteItemFI.setLocRisk2(gipiQuoteItemFI.getLocRisk2() == "" ? "1" : gipiQuoteItemFI.getLocRisk2());
					gipiQuoteItemFI.setLocRisk3(gipiQuoteItemFI.getLocRisk3() == "" ? "1" : gipiQuoteItemFI.getLocRisk3());
				}
					/*String[] args = {gipiQuoteItemFI.getProvinceDesc()};
					String[] districtArgs = {gipiQuoteItemFI.getProvinceDesc(), gipiQuoteItemFI.getCity()};
					String[] blockArgs = {gipiQuoteItemFI.getProvinceDesc(), gipiQuoteItemFI.getCity(), gipiQuoteItemFI.getDistrictNo()};
					String[] riskArgs= {String.valueOf(gipiQuoteItemFI.getBlockId())};
					
					request.setAttribute("cityList", helper.getList(LOVHelper.CITY_LISTING, args));
					request.setAttribute("districtList", helper.getList(LOVHelper.DISTRICT_LISTING,districtArgs));
					request.setAttribute("blockList", helper.getList(LOVHelper.BLOCK_LISTING, blockArgs));
					request.setAttribute("risk", helper.getList(LOVHelper.RISK_LISTING, riskArgs));*/
					
				

				String[] tariffArgs = {gipiQuote.getLineCd(), gipiQuote.getSublineCd()};
				System.out.println(gipiQuote.getAddress1());
				System.out.println(gipiQuote.getAddress2());
				System.out.println(gipiQuote.getAddress3());
				//sets attributes for fire additional information page
				request.setAttribute("gipiQuoteItemFI", gipiQuoteItemFI);
				
				if(gipiQuoteItemFI!=null){
					System.out.println(gipiQuote.getAddress1());
					System.out.println(gipiQuote.getAddress2());
					System.out.println(gipiQuote.getAddress3());
					
					System.out.println(gipiQuoteItemFI.getBlockId());
					System.out.println(gipiQuoteItemFI.getBlockNo());
				}
				
				//default loc if quote has address
					request.setAttribute("defaultLoc1", gipiQuote.getAddress1() == "" ? "" : gipiQuote.getAddress1());
					request.setAttribute("defaultLoc2", gipiQuote.getAddress1() == "" ? "" : gipiQuote.getAddress2());
					request.setAttribute("defaultLoc3", gipiQuote.getAddress1() == "" ? "" : gipiQuote.getAddress3());
				
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("eqZoneList", helper.getList(LOVHelper.EQ_ZONE_LISTING));
				request.setAttribute("typhoonList", helper.getList(LOVHelper.TYPHOON_ZONE_LISTING));
				request.setAttribute("floodList", helper.getList(LOVHelper.FLOOD_ZONE_LISTING));
				request.setAttribute("tariffZoneList", helper.getList(LOVHelper.TARIFF_ZONE_LISTING, tariffArgs));
				request.setAttribute("occupancyList", helper.getList(LOVHelper.FIRE_OCCUPANCY_LISTING));
				request.setAttribute("provinceList", helper.getList(LOVHelper.PROVINCE_LISTING));		
				request.setAttribute("tariffList", helper.getList(LOVHelper.TARIFF_LISTING));
				request.setAttribute("constructionList", helper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
				request.setAttribute("itemTypeList", helper.getList(LOVHelper.FIRE_ITEM_TYPE_LISTING));
				
				// load all city, district, block list, risk
				request.setAttribute("cityList", helper.getList(LOVHelper.ALL_CITY_LISTING)== null ? "" : helper.getList(LOVHelper.ALL_CITY_LISTING));
				request.setAttribute("districtList", helper.getList(LOVHelper.ALL_DISTRICT_LISTING)== null ? "" : helper.getList(LOVHelper.ALL_DISTRICT_LISTING));
				request.setAttribute("blockList", helper.getList(LOVHelper.ALL_BLOCK_LISTING)== null ? "" : helper.getList(LOVHelper.ALL_BLOCK_LISTING));
				request.setAttribute("riskList", helper.getList(LOVHelper.ALL_RISKS_LISTING) == null ? "" : helper.getList(LOVHelper.ALL_RISKS_LISTING) );
				// end
				request.setAttribute("quoteId", quoteId);
				request.setAttribute("userId", USER.getUserId());

				request.setAttribute("inceptDate", request.getParameter("inceptDate"));
				request.setAttribute("expiryDate", request.getParameter("expiryDate"));

				PAGE = "/pages/marketing/quotation/pop-ups/fireAdditionalInformation.jsp";
			}else if("showProvince".equals(ACTION)){
				request.setAttribute("provinceListing", helper.getList(LOVHelper.PROVINCE_LISTING));
				request.setAttribute("aiItemNo", request.getParameter("aiItemNo"));
				PAGE = "/pages/marketing/quotation/pop-ups/firePopUps/province.jsp";
			}else if("showProvince2".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
				params.put("ACTION", ACTION);
				LOVUtil.getLOV(params);
			}else if("showCity".equals(ACTION)){
				String[] cityParams = {request.getParameter("regionCd"), request.getParameter("provinceCd")};
				request.setAttribute("aiItemNo", request.getParameter("aiItemNo"));
				request.setAttribute("cityListing", helper.getList(LOVHelper.CITY_BY_PROVINCE_LISTING, cityParams));
				PAGE = "/pages/marketing/quotation/pop-ups/firePopUps/city.jsp";
			}else if("showBlock".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] blockParams = {request.getParameter("regionCd"), request.getParameter("provinceCd"), request.getParameter("cityCd"), request.getParameter("districtNo")};
				request.setAttribute("blockListing",lovHelper.getList(LOVHelper.BLOCK_LISTING, blockParams));
				request.setAttribute("column", request.getParameter("column"));
				request.setAttribute("aiItemNo", request.getParameter("aiItemNo"));
				PAGE = "/pages/marketing/quotation/pop-ups/firePopUps/block.jsp";
				//some codes below are not used anymore.
			} else if ("filterCityByProvince".equals(ACTION)) {
				String[] args = {(request.getParameter("province")==null || request.getParameter("province").equals("")) ? "0" : request.getParameter("province")};
				
				String itemNo = request.getParameter("fireItemNo");
				request.setAttribute("aiItemNo", itemNo);
				//List<LOV> cityList = (List<LOV>) (helper.getList(LOVHelper.CITY_LISTING,args)== null ? "" : helper.getList(LOVHelper.CITY_LISTING,args));						
				request.setAttribute("cityList", helper.getList(LOVHelper.CITY_LISTING,args)== null ? "" : helper.getList(LOVHelper.CITY_LISTING,args));
				PAGE = "/pages/marketing/quotation/dynamicDropdown/cityByProvince.jsp";

			} else if ("filterDistrictByProvinceByCity".equals(ACTION)) {
				String[] args = {request.getParameter("province"), request.getParameter("city")};
				//List<LOV> districtList = (List<LOV>) (helper.getList(LOVHelper.DISTRICT_LISTING,args)== null ? "" : helper.getList(LOVHelper.DISTRICT_LISTING,args));	
				
				String itemNo = request.getParameter("fireItemNo");
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("districtList", helper.getList(LOVHelper.DISTRICT_LISTING,args)== null ? "" : helper.getList(LOVHelper.DISTRICT_LISTING,args));
				PAGE =  "/pages/marketing/quotation/dynamicDropdown/districtByProvinceByCity.jsp";

			} else if ("filterBlock".equals(ACTION)) {
				String[] args = {request.getParameter("province"), request.getParameter("city"), request.getParameter("district")};
				//List<LOV> blockList = (List<LOV>) (helper.getList(LOVHelper.BLOCK_LISTING,args)== null ? "" : helper.getList(LOVHelper.BLOCK_LISTING,args));			
				
				String itemNo = request.getParameter("fireItemNo");
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("blockList", helper.getList(LOVHelper.BLOCK_LISTING,args)== null ? "" : helper.getList(LOVHelper.BLOCK_LISTING,args));
				PAGE = "/pages/marketing/quotation/dynamicDropdown/block.jsp";

			} else if ("filterRisk".equals(ACTION)) {
				String[] args = {(request.getParameter("block")==null || request.getParameter("block").equals("")) ? "0" : request.getParameter("block")};
				List<LOV> riskList = (List<LOV>) (helper.getList(LOVHelper.RISK_LISTING,args)== null ? "" : helper.getList(LOVHelper.RISK_LISTING,args));				
				
				if(riskList == null){
					System.out.println("riskList is NULL ---------- " );
				} else{
					System.out.println("riskList is NOT NULL ~~~~~~ LENGTH:" + riskList.size());
				}
				
				String itemNo = request.getParameter("fireItemNo");
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("riskList",  riskList); //helper.getList(LOVHelper.RISK_LISTING,args)== null ? "" : helper.getList(LOVHelper.RISK_LISTING,args));
				PAGE = "/pages/marketing/quotation/dynamicDropdown/risks.jsp";

			}else if ("searchBlock".equals(ACTION)) {
				
				PAGE = "/pages/marketing/quotation/pop-ups/searchBlock.jsp";
				
			}
		} catch (SQLException e) {
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

	/** REMOVE WHEN ALL ADDITIONAL INFORMATION HAS BEEN MOVED TO MAINDIV
	 * Sets the gipi quote item fi.
	 * 
	 * @param request the request
	 * @return the gIPI quote item fi
	 * @throws ParseException the parse exception
	 */
	/*
	private GIPIQuoteItemFI setGIPIQuoteItemFI(HttpServletRequest request) throws ParseException{
		log.info("Parsing request params to GIPIQuoteItemFI...");
		GIPIQuoteItemFI quoteItemFI = new GIPIQuoteItemFI();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		String quoteId = request.getParameter("quoteId");
		quoteItemFI.setQuoteId(Integer.parseInt(quoteId));
		quoteItemFI.setItemNo(Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo")));
		quoteItemFI.setAssignee(request.getParameter("assignee"));
		quoteItemFI.setFrItemType(request.getParameter("fireItemType"));
		quoteItemFI.setBlockId(Integer.parseInt(request.getParameter("block").equals("") ? "0" : request.getParameter("block")));
		quoteItemFI.setDistrictNo(request.getParameter("district"));
		quoteItemFI.setBlockNo(request.getParameter("blockNo"));
		quoteItemFI.setRiskCd(request.getParameter("risk"));
		quoteItemFI.setEqZone(request.getParameter("eqZone"));
		quoteItemFI.setTyphoonZone(request.getParameter("typhoonZone"));
		quoteItemFI.setFloodZone(request.getParameter("floodZone"));
		quoteItemFI.setTariffCd(request.getParameter("tariffCode"));
		quoteItemFI.setTariffZone(request.getParameter("tariffZone"));
		quoteItemFI.setConstructionCd(request.getParameter("construction"));
		quoteItemFI.setConstructionRemarks(request.getParameter("constructionRemarks"));
		quoteItemFI.setUserId(request.getParameter("userId"));
		quoteItemFI.setLastUpdate(new Date());
		quoteItemFI.setFront(request.getParameter("boundaryFront"));
		quoteItemFI.setRight(request.getParameter("boundaryRight"));
		quoteItemFI.setLeft(request.getParameter("boundaryLeft"));
		quoteItemFI.setRear(request.getParameter("boundaryRear"));
		quoteItemFI.setLocRisk1(request.getParameter("locRisk1"));
		quoteItemFI.setLocRisk2(request.getParameter("locRisk2"));
		quoteItemFI.setLocRisk3(request.getParameter("locRisk3"));
		quoteItemFI.setOccupancyCd(request.getParameter("occupancy"));
		quoteItemFI.setOccupancyRemarks(request.getParameter("occupancyRemarks"));
		quoteItemFI.setDateFrom(df.parse(request.getParameter("date")));
		quoteItemFI.setDateTo(df.parse(request.getParameter("date1")));
		quoteItemFI.setCity(request.getParameter("city"));
		return quoteItemFI;		
	}*/

}
