/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.dao.GIPIQuoteItemFIDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemFI;
import com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService;


/**
 * The Class GIPIQuoteItemFIFacadeServiceImpl.
 */
public class GIPIQuoteItemFIFacadeServiceImpl implements GIPIQuoteItemFIFacadeService{

	/** The gipi quote item fidao. */
	GIPIQuoteItemFIDAO gipiQuoteItemFIDAO;
	private static Logger log = Logger.getLogger(GIPIQuoteItemFIFacadeServiceImpl.class);
	/**
	 * Gets the gipi quote item fidao.
	 * 
	 * @return the gipi quote item fidao
	 */
	public GIPIQuoteItemFIDAO getGipiQuoteItemFIDAO() {
		return gipiQuoteItemFIDAO;
	}

	/**
	 * Sets the gipi quote item fidao.
	 * 
	 * @param gipiQuoteItemFIDAO the new gipi quote item fidao
	 */
	public void setGipiQuoteItemFIDAO(GIPIQuoteItemFIDAO gipiQuoteItemFIDAO) {
		this.gipiQuoteItemFIDAO = gipiQuoteItemFIDAO;
	}


	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#getGIPIQuoteItemFI(int, int)
	 */
	@Override
	public GIPIQuoteItemFI getGIPIQuoteItemFI(int quoteId, int itemNo)
			throws SQLException {
		return this.gipiQuoteItemFIDAO.getGIPIQuoteItemFI(quoteId, itemNo);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#deleteGIPIQuoteItemFI(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemFI(int quoteId, int itemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#saveGIPIQuoteItemFI(com.geniisys.gipi.entity.GIPIQuoteItemFI)
	 */
	@Override
	public void saveGIPIQuoteItemFI(GIPIQuoteItemFI quoteItemFI)
			throws SQLException {
		this.gipiQuoteItemFIDAO.saveGIPIQuoteItemFI(quoteItemFI);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#saveQuoteItemAdditionalInformation(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)
			throws SQLException {
		GIPIQuoteItemFI quoteItemFI = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
	
		String quoteId = request.getParameter("quoteId");
		String itemNos[] 		= request.getParameterValues("aiItemNo");
		String assignees[]		= request.getParameterValues("assignee");
		String frItemTypes[]	= request.getParameterValues("fireItemType");
		String blockIds[]		= request.getParameterValues("block");
		String districts[]		= request.getParameterValues("district");
		String provinceDesc[]	= request.getParameterValues("province"); //**
		String blockNos[]		= request.getParameterValues("blockNo");
		String riskCds[]		= request.getParameterValues("eqZone");
		String eqZones[]		= request.getParameterValues("eqZone");
		String typhoonZones[]	= request.getParameterValues("typhoonZone");
		String floodZones[]		= request.getParameterValues("floodZone");
		String tariffCds[]		= request.getParameterValues("tariffCode");
		String tariffZones[]	= request.getParameterValues("tariffZone");
		String constructionCds[]= request.getParameterValues("construction");
		String constructionRemarks[] = request.getParameterValues("constructionRemarks");
		String userIds[]		= request.getParameterValues("userId");
		String boundaryFronts[]	= request.getParameterValues("boundaryFront");
		String boundaryRights[]	= request.getParameterValues("boundaryRight");
		String boundaryLefts[]	= request.getParameterValues("boundaryLeft");
		String boundaryRears[]	= request.getParameterValues("boundaryRear");
		String locRisk1[]		= request.getParameterValues("locRisk1");
		String locRisk2[]		= request.getParameterValues("locRisk2");
		String locRisk3[]		= request.getParameterValues("locRisk3");
		String occupancies[]	= request.getParameterValues("occupancy");
		String occupancyRemarks[]=request.getParameterValues("occupancyRemarks");
		String dateFroms[]		= request.getParameterValues("date");
		String dateTos[]		= request.getParameterValues("date1");
		/*
		for(int i = 0 ; i <provinceDesc.length ; i++){
			System.out.println("province "+ provinceDesc[i]);
			//System.out.println("city "+);
		}*/
		
		try{
			for(int i = 0; i < itemNos.length ; i++){
				quoteItemFI = new GIPIQuoteItemFI();
				quoteItemFI.setQuoteId(Integer.parseInt(quoteId)); // same for all items 
				quoteItemFI.setItemNo(Integer.parseInt(itemNos[i].equals("") ? "0" : itemNos[i]));
				quoteItemFI.setProvinceDesc(provinceDesc[i]);
				quoteItemFI.setAssignee(assignees[i]);
				quoteItemFI.setFrItemType(frItemTypes[i]);
				quoteItemFI.setBlockId(Integer.parseInt(blockIds[i].equals("") ? "" : blockIds[i]));
				quoteItemFI.setDistrictNo(districts[i]);
				quoteItemFI.setBlockNo(blockNos[i].equals("") ? "" : blockNos[i]);
				quoteItemFI.setRiskCd(riskCds[i]);
				quoteItemFI.setEqZone(eqZones[i]);
				quoteItemFI.setTyphoonZone(typhoonZones[i]);
				quoteItemFI.setFloodZone(floodZones[i]);
				quoteItemFI.setTariffCd(tariffCds[i]);
				quoteItemFI.setTariffZone(tariffZones[i]);
				quoteItemFI.setConstructionCd(constructionCds[i]);
				quoteItemFI.setConstructionRemarks(constructionRemarks[i]);
				quoteItemFI.setUserId(userIds[i]); 
				quoteItemFI.setLastUpdate(new Date());
				quoteItemFI.setFront(boundaryFronts[i]);
				quoteItemFI.setRight(boundaryRights[i]);
				quoteItemFI.setLeft(boundaryLefts[i]);
				quoteItemFI.setRear(boundaryRears[i]);
				quoteItemFI.setLocRisk1(locRisk1[i]);
				quoteItemFI.setLocRisk2(locRisk2[i]);
				quoteItemFI.setLocRisk3(locRisk3[i]);
				quoteItemFI.setOccupancyCd(occupancies[i]);
				quoteItemFI.setOccupancyRemarks(occupancyRemarks[i]);
				if(!dateFroms[i].equals(""))
					quoteItemFI.setDateFrom(df.parse(dateFroms[i]));
				if(!dateTos[i].equals(""))
					quoteItemFI.setDateTo(df.parse(dateTos[i]));
				this.saveGIPIQuoteItemFI(quoteItemFI);
			}
		}/*catch(SQLException s){
			s.printStackTrace();
		}*/catch(ParseException p){
			p.printStackTrace();
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#deleteGIPIQuoteFI(int, int)
	 */
	@Override
	public void deleteGIPIQuoteFI(int quoteId, int itemNo) throws SQLException {
		this.gipiQuoteItemFIDAO.deleteGIPIQuoteItemFI(quoteId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#getGIPIQuoteItemFIs(int)
	 */
	@Override
	public List<GIPIQuoteItemFI> getGIPIQuoteItemFIs(int quoteId)
			throws SQLException {
		return this.getGipiQuoteItemFIDAO().getGIPIQuoteItemFIs(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(
			HttpServletRequest request) {
		System.out.println("PREPARING FI ADDITIONAL INFO");
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemFI> additionalInformationList = new ArrayList<GIPIQuoteItemFI>();
		
		GIPIQuoteItemFI quoteItemFI = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
	
		String quoteId = request.getParameter("quoteId");
		String itemNos[] 		= request.getParameterValues("aiItemNo");
		String assignees[]		= request.getParameterValues("assignee");
		String frItemTypes[]	= request.getParameterValues("fireItemType");
		String blockIds[]		= request.getParameterValues("blockId");
		String districts[]		= request.getParameterValues("district");
		String provinceDesc[]	= request.getParameterValues("province"); //**
		String blockNos[]		= request.getParameterValues("blockNo");
		String riskCds[]		= request.getParameterValues("eqZone");
		String eqZones[]		= request.getParameterValues("eqZone");
		String typhoonZones[]	= request.getParameterValues("typhoonZone");
		String floodZones[]		= request.getParameterValues("floodZone");
		String tariffCds[]		= request.getParameterValues("tariffCode");
		String tariffZones[]	= request.getParameterValues("tariffZone");
		String constructionCds[]= request.getParameterValues("construction");
		String constructionRemarks[] = request.getParameterValues("constructionRemarks");
		String userIds[]		= request.getParameterValues("userId");
		String boundaryFronts[]	= request.getParameterValues("boundaryFront");
		String boundaryRights[]	= request.getParameterValues("boundaryRight");
		String boundaryLefts[]	= request.getParameterValues("boundaryLeft");
		String boundaryRears[]	= request.getParameterValues("boundaryRear");
		String locRisk1[]		= request.getParameterValues("locRisk1");
		String locRisk2[]		= request.getParameterValues("locRisk2");
		String locRisk3[]		= request.getParameterValues("locRisk3");
		String occupancies[]	= request.getParameterValues("occupancy");
		String occupancyRemarks[]=request.getParameterValues("occupancyRemarks");
		String dateFroms[]		= request.getParameterValues("date");
		String dateTos[]		= request.getParameterValues("date1");
		
		try{
			for(int i = 0; i < itemNos.length ; i++){
				quoteItemFI = new GIPIQuoteItemFI();
				quoteItemFI.setQuoteId(Integer.parseInt(quoteId)); // same for all items 
				quoteItemFI.setItemNo(Integer.parseInt(itemNos[i].equals("") ? "0" : itemNos[i]));
				quoteItemFI.setProvinceDesc(provinceDesc[i]);
				quoteItemFI.setAssignee(assignees[i]);
				quoteItemFI.setFrItemType(frItemTypes[i]);
				quoteItemFI.setBlockId(Integer.parseInt(blockIds[i].equals("") ? "" : blockIds[i]));
				quoteItemFI.setDistrictNo(districts[i]);
				quoteItemFI.setBlockNo(blockNos[i].equals("") ? "" : blockNos[i]);
				quoteItemFI.setRiskCd(riskCds[i]);
				quoteItemFI.setEqZone(eqZones[i]);
				quoteItemFI.setTyphoonZone(typhoonZones[i]);
				quoteItemFI.setFloodZone(floodZones[i]);
				quoteItemFI.setTariffCd(tariffCds[i]);
				quoteItemFI.setTariffZone(tariffZones[i]);
				quoteItemFI.setConstructionCd(constructionCds[i]);
				quoteItemFI.setConstructionRemarks(constructionRemarks[i]);
				quoteItemFI.setUserId(userIds[i]); 
				quoteItemFI.setLastUpdate(new Date());
				quoteItemFI.setFront(boundaryFronts[i]);
				quoteItemFI.setRight(boundaryRights[i]);
				quoteItemFI.setLeft(boundaryLefts[i]);
				quoteItemFI.setRear(boundaryRears[i]);
				quoteItemFI.setLocRisk1(locRisk1[i]);
				quoteItemFI.setLocRisk2(locRisk2[i]);
				quoteItemFI.setLocRisk3(locRisk3[i]);
				quoteItemFI.setOccupancyCd(occupancies[i]);
				quoteItemFI.setOccupancyRemarks(occupancyRemarks[i]);
				if(!dateFroms[i].equals(""))
					quoteItemFI.setDateFrom(df.parse(dateFroms[i]));
				if(!dateTos[i].equals(""))
					quoteItemFI.setDateTo(df.parse(dateTos[i]));
				quoteItemFI.showAllValuesInConsole();
				additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemFI);
//				additionalInformationList.add(quoteItemFI);
			}
		}catch(ParseException p){
			p.printStackTrace();
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
//		additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService#prepareFireInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemFI> prepareFireInformationJSON(JSONArray setRows)
			throws JSONException {
		
		List<GIPIQuoteItemFI> fireList = new ArrayList<GIPIQuoteItemFI>();
		GIPIQuoteItemFI fire = null;
		JSONObject objItem = null;
		JSONObject objFire = null;		
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=setRows.length(); i < length; i++){
			fire = new GIPIQuoteItemFI();
			objItem = setRows.getJSONObject(i);
			System.out.println("gipiQuoteItemFi &&&&&&&&&&&&&&&");
			objFire = objItem.isNull("gipiQuoteItemFI") ? null : objItem.getJSONObject("gipiQuoteItemFI");
			
			if(objFire != null){
				fire.setQuoteId(objItem.isNull("quoteId") ? null : objItem.getInt("quoteId"));
				System.out.println("----------------->" +fire.getQuoteId());
				fire.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				fire.setDistrictNo(objFire.isNull("districtNo") ? null : objFire.getString("districtNo"));
				fire.setEqZone(objFire.isNull("eqZone") ? null : objFire.getString("eqZone"));
				fire.setTariffCd(objFire.isNull("tarfCd") ? null : objFire.getString("tarfCd"));
				fire.setBlockNo(objFire.isNull("blockNo") ? null : objFire.getString("blockNo"));
				fire.setFrItemType(objFire.isNull("frItemType") ? null : objFire.getString("frItemType"));
//				fire.setLocRisk1(objFire.isNull("locRisk1") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("locRisk1")));
//				fire.setLocRisk2(objFire.isNull("locRisk2") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("locRisk2")));
//				fire.setLocRisk3(objFire.isNull("locRisk3") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("locRisk3")));
				fire.setLocRisk1(objFire.isNull("locRisk1") ? null : objFire.getString("locRisk1"));
				fire.setLocRisk2(objFire.isNull("locRisk2") ? null : objFire.getString("locRisk2"));
				fire.setLocRisk3(objFire.isNull("locRisk3") ? null : objFire.getString("locRisk3"));
				fire.setTariffZone(objFire.isNull("tariffZone") ? null : objFire.getString("tariffZone"));
				fire.setTyphoonZone(objFire.isNull("typhoonZone") ? null : objFire.getString("typhoonZone"));
				fire.setConstructionCd(objFire.isNull("constructionCd") ? null : objFire.getString("constructionCd"));
				fire.setConstructionRemarks(objFire.isNull("constructionRemarks") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("constructionRemarks")));
//				fire.setFront(objFire.isNull("front") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("front")));
//				fire.setRight(objFire.isNull("right") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("right")));
//				fire.setLeft(objFire.isNull("left") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("left")));
//				fire.setRear(objFire.isNull("rear") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("rear")));
				fire.setFront(objFire.isNull("front") ? null : objFire.getString("front"));
				fire.setRight(objFire.isNull("right") ? null : objFire.getString("right"));
				fire.setLeft(objFire.isNull("left") ? null : objFire.getString("left"));
				fire.setRear(objFire.isNull("rear") ? null : objFire.getString("rear"));
				fire.setOccupancyCd(objFire.isNull("occupancyCd") ? null : objFire.getString("occupancyCd"));
				fire.setOccupancyRemarks(objFire.isNull("occupancyRemarks") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("occupancyRemarks")));
//				fire.setAssignee(objFire.isNull("assignee") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("assignee")));
				fire.setAssignee(objFire.isNull("assignee") ? null : objFire.getString("assignee"));
				fire.setFloodZone(objFire.isNull("floodZone") ? null : objFire.getString("floodZone"));
				fire.setBlockId(objFire.isNull("blockId") || objFire.getString("blockId").equals("") ? null : objFire.getInt("blockId"));
				fire.setRiskCd(objFire.isNull("riskCd") ? null : objFire.getString("riskCd"));
				
				fire.setFloodZoneDesc(JSONUtil.getString(setRows, i, "floodZoneDesc"));
				fire.setTyphoonZoneDesc(JSONUtil.getString(setRows, i, "typhoonZoneDesc"));
				fire.setEqDesc(JSONUtil.getString(setRows, i, "eqZoneDesc"));
				
				fire.showAllValuesInConsole();
				try {
					if (!objFire.isNull("dateFrom")){
						fire.setDateFrom(df.parse(objFire.getString("dateFrom")));
					}
					if (!objFire.isNull("dateTo")){
						fire.setDateTo(df.parse(objFire.getString("dateTo")));
					}
				} catch (ParseException e){
					System.out.println("EXCEPTION ON GIPIQuoteItemFI");
				}
				
				fireList.add(fire);
				fire = null;
			}
		}
		
/*		List<GIPIQuoteItemFI> fiList = new ArrayList<GIPIQuoteItemFI>();
		GIPIQuoteItemFI fi = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int index = 0; index<rows.length(); index++){
			fi = new GIPIQuoteItemFI();
			fi.setQuoteId(rows.getJSONObject(index).isNull("quoteId")?0:rows.getJSONObject(index).getInt("quoteId"));
			fi.setItemNo(rows.getJSONObject(index).isNull("itemNo")?0:rows.getJSONObject(index).getInt("itemNo"));
			fi.setProvinceDesc(rows.getJSONObject(index).isNull("provinceDesc")?"":rows.getJSONObject(index).getString("provinceDesc"));
			fi.setAssignee(rows.getJSONObject(index).isNull("assignee")?"":rows.getJSONObject(index).getString("assignee"));
			fi.setFrItemType(rows.getJSONObject(index).isNull("frItemType")?"":rows.getJSONObject(index).getString("frItemType"));
			fi.setBlockId(rows.getJSONObject(index).isNull("bloackId")?0:rows.getJSONObject(index).getInt("blockId"));
			fi.setDistrictNo(rows.getJSONObject(index).isNull("districtNo")?"":rows.getJSONObject(index).getString("districtNo"));
			fi.setBlockNo(rows.getJSONObject(index).isNull("blockNo")?"":rows.getJSONObject(index).getString("blockNo"));
			fi.setRiskCd(rows.getJSONObject(index).isNull("riskCd")?"":rows.getJSONObject(index).getString("riskCd"));
			fi.setEqZone(rows.getJSONObject(index).isNull("eqZone")?"":rows.getJSONObject(index).getString("eqZone"));
			fi.setTyphoonZone(rows.getJSONObject(index).isNull("provinceDesc")?"":rows.getJSONObject(index).getString("provinceDesc"));
			fi.setFloodZone(rows.getJSONObject(index).isNull("floodZone")?"":rows.getJSONObject(index).getString("floodZone"));
			fi.setTariffCd(rows.getJSONObject(index).isNull("tariffCd")?"":rows.getJSONObject(index).getString("tariffCd"));
			fi.setTariffZone(rows.getJSONObject(index).isNull("tariffZone")?"":rows.getJSONObject(index).getString("tariffZone"));
			fi.setConstructionCd(rows.getJSONObject(index).isNull("constructionCd")?"":rows.getJSONObject(index).getString("constructionCd"));
			fi.setConstructionRemarks(rows.getJSONObject(index).isNull("constructionRemarks")?"":rows.getJSONObject(index).getString("constructionRemarks"));
			fi.setUserId(rows.getJSONObject(index).isNull("userId")?"":rows.getJSONObject(index).getString("userId"));//**
			fi.setLastUpdate(new Date());
			fi.setFront(rows.getJSONObject(index).isNull("front")?"":rows.getJSONObject(index).getString("front"));
			fi.setRight(rows.getJSONObject(index).isNull("right")?"":rows.getJSONObject(index).getString("right"));
			fi.setLeft(rows.getJSONObject(index).isNull("left")?"":rows.getJSONObject(index).getString("left"));
			fi.setRear(rows.getJSONObject(index).isNull("rear")?"":rows.getJSONObject(index).getString("rear"));
			fi.setLocRisk1(rows.getJSONObject(index).isNull("locRisk1")?"":rows.getJSONObject(index).getString("locRisk1"));
			fi.setLocRisk2(rows.getJSONObject(index).isNull("locRisk2")?"":rows.getJSONObject(index).getString("locRisk2"));
			fi.setLocRisk3(rows.getJSONObject(index).isNull("locRisk3")?"":rows.getJSONObject(index).getString("locRisk3"));
			fi.setOccupancyCd(rows.getJSONObject(index).isNull("occupancyCd")?"":rows.getJSONObject(index).getString("occupancyCd"));
			//fi.setOccupancyDesc(rows.getJSONObject(index).isNull("occupancyDesc")?"":rows.getJSONObject(index).getString("occupancDesc"));
			fi.setOccupancyRemarks(rows.getJSONObject(index).isNull("occupancyRemarks")?"":rows.getJSONObject(index).getString("occupancyRemarks"));
			try{
				if(rows.getJSONObject(index).isNull("dateFrom")){
					fi.setDateFrom(df.parse(rows.getJSONObject(index).getString("dateFrom")));
				}
				if(rows.getJSONObject(index).isNull("dateTo")){
					fi.setDateTo(df.parse(rows.getJSONObject(index).getString("dateTo")));
				}
			}catch (ParseException e) {
				System.out.println("ERROR IN GIPIQuoteItemFIFacadeServiceImpl");
			}
			fiList.add(fi);
		}*/
	
		return fireList;
	}
	
	public void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIQuote gipiQuote){
		String[] lineSubLineParams = {gipiQuote.getLineCd(), gipiQuote.getSublineCd()};

		request.setAttribute("eqZoneList", lovHelper.getList(LOVHelper.EQ_ZONE_LISTING));
		request.setAttribute("typhoonList", lovHelper.getList(LOVHelper.TYPHOON_ZONE_LISTING));
		request.setAttribute("itemTypeList", lovHelper.getList(LOVHelper.FIRE_ITEM_TYPE_LISTING));
		request.setAttribute("floodList", lovHelper.getList(LOVHelper.FLOOD_ZONE_LISTING));
		request.setAttribute("tariffZoneList", lovHelper.getList(LOVHelper.TARIFF_ZONE_LISTING, lineSubLineParams));
		request.setAttribute("tariffList", lovHelper.getList(LOVHelper.TARIFF_LISTING));
		request.setAttribute("constructionList", lovHelper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
	}
	
}
