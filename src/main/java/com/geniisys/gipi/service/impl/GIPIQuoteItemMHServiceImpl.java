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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIQuoteItemMHDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemMH;
import com.geniisys.gipi.service.GIPIQuoteItemMHService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuoteItemMHServiceImpl.
 */
public class GIPIQuoteItemMHServiceImpl implements GIPIQuoteItemMHService {

	/** The gipi quote item mhdao. */
	private GIPIQuoteItemMHDAO gipiQuoteItemMHDAO;
	private static Logger log = Logger.getLogger(GIPIQuoteItemMHServiceImpl.class);
	/**
	 * Gets the gipi quote item mhdao.
	 * 
	 * @return the gipi quote item mhdao
	 */
	public GIPIQuoteItemMHDAO getGipiQuoteItemMHDAO() {
		return gipiQuoteItemMHDAO;
	}

	/**
	 * Sets the gipi quote item mhdao.
	 * 
	 * @param gipiQuoteItemMHDAO the new gipi quote item mhdao
	 */
	public void setGipiQuoteItemMHDAO(GIPIQuoteItemMHDAO gipiQuoteItemMHDAO) {
		this.gipiQuoteItemMHDAO = gipiQuoteItemMHDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMHService#getGIPIQuoteItemMHDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemMH getGIPIQuoteItemMHDetails(int quoteId, int itemNo)
			throws SQLException {
		return (GIPIQuoteItemMH) StringFormatter.replaceQuotesInObject(this.getGipiQuoteItemMHDAO().getGIPIQuoteItemMHDetails(quoteId, itemNo));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMHService#saveGIPIQuoteItemMH(com.geniisys.gipi.entity.GIPIQuoteItemMH)
	 */
	@Override
	public void saveGIPIQuoteItemMH(GIPIQuoteItemMH quoteItemMH)
			throws SQLException {
		this.getGipiQuoteItemMHDAO().saveGIPIQuoteItemMH(quoteItemMH);
	}

	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)
			throws SQLException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIQuoteItemMH quoteItemMh = new GIPIQuoteItemMH();
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String geogLimits[] 	= request.getParameterValues("geogLimit");
		String itemNos	 [] 	= request.getParameterValues("aiItemNo");
		String drydoclplc[] 	= request.getParameterValues("drydockPlace");
		String dryDockDat[] 	= request.getParameterValues("drydockDate");
		String vesselCds [] 	= request.getParameterValues("vesselCd");
		String regOwners [] 	= request.getParameterValues("registeredOwner");
		String grossTons [] 	= request.getParameterValues("grossTonnage");
		String netTons	 [] 	= request.getParameterValues("netTonnage");
		String deadWt	 []		= request.getParameterValues("deadweightTonnage");
		String vesselDpt [] 	= request.getParameterValues("vesselDepth");
		String vesselLen [] 	= request.getParameterValues("vesselLength");
		String vesselBrd [] 	= request.getParameterValues("vesselBreadth");
		String vesselONam[] 	= request.getParameterValues("vesselOldName");
		String vessTypeCd[] 	= request.getParameterValues("vesselType");
		String propType  []		= request.getParameterValues("propellerType");
		String regPlace  [] 	= request.getParameterValues("place");
		String yearBuilt [] 	= request.getParameterValues("yearBuilt");
		String noOfCrew  [] 	= request.getParameterValues("noOfCrew");
		String nationalit[] 	= request.getParameterValues("nationality");
		try {
			if(itemNos!=null)
			for(int i = 0 ; i < itemNos.length; i++){
				quoteItemMh.setQuoteId(quoteId);
				quoteItemMh.setItemNo(Integer.parseInt(itemNos[i]));
				quoteItemMh.setGeogLimit(geogLimits[i]);
				quoteItemMh.setDryPlace(drydoclplc[i]);
				quoteItemMh.setVesselCd(vesselCds[i]);
				quoteItemMh.setRegOwner(regOwners[i]);
				quoteItemMh.setGrossTon(grossTons[i]);
				quoteItemMh.setDeductText(geogLimits[i]);
				quoteItemMh.setVesselOldName(vesselONam[i]);
				quoteItemMh.setVesTypeCd(vessTypeCd[i]);
				quoteItemMh.setRegPlace(regPlace[i]);
				quoteItemMh.setYearBuilt(yearBuilt[i]);
				quoteItemMh.setCrewNat(nationalit[i]);
				
				if(!noOfCrew[i].equals(""))		
					quoteItemMh.setNoCrew(Integer.parseInt(request.getParameter("noOfCrew")));
				if(!dryDockDat[i].equals(""))	
					quoteItemMh.setDryDate(df.parse(dryDockDat[i]));
				if(!netTons[i].equals(""))		
					quoteItemMh.setNetTon(Double.parseDouble(netTons[i]));
				if(!deadWt[i].equals(""))		
					quoteItemMh.setDeadWeight(Integer.parseInt(deadWt[i]));
				if(!vesselDpt[i].equals(""))	
					quoteItemMh.setVesselDepth(Double.parseDouble(vesselDpt[i]));
				if(!vesselLen[i].equals(""))	
					quoteItemMh.setVesselLength(Double.parseDouble(vesselLen[i]));
				if(!vesselBrd[i].equals(""))	
					quoteItemMh.setVesselBreadth(Double.parseDouble(vesselBrd[i]));
				if(!propType[i].equals(""))		
					quoteItemMh.setPropelSw(propType[i]);
				this.saveGIPIQuoteItemMH(quoteItemMh);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMHService#deleteGIPIQuoteMH(int, int)
	 */
	@Override
	public void deleteGIPIQuoteMH(int quoteId, int itemNo) throws SQLException {
		this.gipiQuoteItemMHDAO.getGIPIQuoteItemMHDetails(quoteId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMHService#getGIPIQuoteItemMHs(int)
	 */
	@Override
	public List<GIPIQuoteItemMH> getGIPIQuoteItemMHs(int quoteId)
			throws SQLException {
		return this.getGipiQuoteItemMHDAO().getGIPIQuoteItemMHs(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMHService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request) {
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemMH> additionalInformationList = new ArrayList<GIPIQuoteItemMH>();
		
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIQuoteItemMH quoteItemMh = new GIPIQuoteItemMH();
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String geogLimits[] 	= request.getParameterValues("geogLimit");
		String itemNos	 [] 	= request.getParameterValues("aiItemNo");
		String drydoclplc[] 	= request.getParameterValues("drydockPlace");
		String dryDockDat[] 	= request.getParameterValues("drydockDate");
		String vesselCds [] 	= request.getParameterValues("vesselCd");
		String regOwners [] 	= request.getParameterValues("registeredOwner");
		String grossTons [] 	= request.getParameterValues("grossTonnage");
		String netTons	 [] 	= request.getParameterValues("netTonnage");
		String deadWt	 []		= request.getParameterValues("deadweightTonnage");
		String vesselDpt [] 	= request.getParameterValues("vesselDepth");
		String vesselLen [] 	= request.getParameterValues("vesselLength");
		String vesselBrd [] 	= request.getParameterValues("vesselBreadth");
		String vesselONam[] 	= request.getParameterValues("vesselOldName");
		String vessTypeCd[] 	= request.getParameterValues("vesselType");
		String propType  []		= request.getParameterValues("propellerType");
		String regPlace  [] 	= request.getParameterValues("place");
		String yearBuilt [] 	= request.getParameterValues("yearBuilt");
		String noOfCrew  [] 	= request.getParameterValues("noOfCrew");
		String nationalit[] 	= request.getParameterValues("nationality");
		try {
			if(itemNos!=null)
			for(int i = 0 ; i < itemNos.length; i++){
				quoteItemMh.setQuoteId(quoteId);
				quoteItemMh.setItemNo(Integer.parseInt(itemNos[i]));
				quoteItemMh.setGeogLimit(geogLimits[i]);
				quoteItemMh.setDryPlace(drydoclplc[i]);
				quoteItemMh.setVesselCd(vesselCds[i]);
				quoteItemMh.setRegOwner(regOwners[i]);
				quoteItemMh.setGrossTon(grossTons[i]);
				quoteItemMh.setDeductText(geogLimits[i]);
				quoteItemMh.setVesselOldName(vesselONam[i]);
				quoteItemMh.setVesTypeCd(vessTypeCd[i]);
				quoteItemMh.setRegPlace(regPlace[i]);
				quoteItemMh.setYearBuilt(yearBuilt[i]);
				quoteItemMh.setCrewNat(nationalit[i]);
				
				if(!noOfCrew[i].equals(""))		
					quoteItemMh.setNoCrew(Integer.parseInt(request.getParameter("noOfCrew")));
				if(!dryDockDat[i].equals(""))	
					quoteItemMh.setDryDate(df.parse(dryDockDat[i]));
				if(!netTons[i].equals(""))		
					quoteItemMh.setNetTon(Double.parseDouble(netTons[i]));
				if(!deadWt[i].equals(""))		
					quoteItemMh.setDeadWeight(Integer.parseInt(deadWt[i]));
				if(!vesselDpt[i].equals(""))	
					quoteItemMh.setVesselDepth(Double.parseDouble(vesselDpt[i]));
				if(!vesselLen[i].equals(""))	
					quoteItemMh.setVesselLength(Double.parseDouble(vesselLen[i]));
				if(!vesselBrd[i].equals(""))	
					quoteItemMh.setVesselBreadth(Double.parseDouble(vesselBrd[i]));
				if(!propType[i].equals(""))		
					quoteItemMh.setPropelSw(propType[i]);
//				additionalInformationList.add(quoteItemMh);
				additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemMh);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
//		additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}

	/*
	 quoteItemMh.setQuoteId(quoteId);
				quoteItemMh.setItemNo(Integer.parseInt(itemNos[i]));
				quoteItemMh.setGeogLimit(geogLimits[i]);
				quoteItemMh.setDryPlace(drydoclplc[i]);
				quoteItemMh.setVesselCd(vesselCds[i]);
				quoteItemMh.setRegOwner(regOwners[i]);
				quoteItemMh.setGrossTon(grossTons[i]);
				quoteItemMh.setDeductText(geogLimits[i]);
				quoteItemMh.setVesselOldName(vesselONam[i]);
				quoteItemMh.setVesTypeCd(vessTypeCd[i]);
				quoteItemMh.setRegPlace(regPlace[i]);
				quoteItemMh.setYearBuilt(yearBuilt[i]);
				quoteItemMh.setCrewNat(nationalit[i]);
				if(!noOfCrew[i].equals(""))		quoteItemMh.setNoCrew(Integer.parseInt(request.getParameter("noOfCrew")));
				if(!dryDockDat[i].equals(""))	quoteItemMh.setDryDate(df.parse(dryDockDat[i]));
				if(!netTons[i].equals(""))		quoteItemMh.setNetTon(Double.parseDouble(netTons[i]));
				if(!deadWt[i].equals(""))		quoteItemMh.setDeadWeight(Integer.parseInt(deadWt[i]));
				if(!vesselDpt[i].equals(""))	quoteItemMh.setVesselDepth(Double.parseDouble(vesselDpt[i]));
				if(!vesselLen[i].equals(""))	quoteItemMh.setVesselLength(Double.parseDouble(vesselLen[i]));
				if(!vesselBrd[i].equals(""))	quoteItemMh.setVesselBreadth(Double.parseDouble(vesselBrd[i]));
				if(!propType[i].equals(""))		quoteItemMh.setPropelSw(propType[i]);	 */
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMHService#prepareMarineHullInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemMH> prepareMarineHullInformationJSON(JSONArray rows)
			throws JSONException {
		List<GIPIQuoteItemMH> mhList = new ArrayList<GIPIQuoteItemMH>();
		GIPIQuoteItemMH mh = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject objItem1 = null;
		for(int index=0; index<rows.length();index++){
			mh = new GIPIQuoteItemMH();
			objItem1 = rows.getJSONObject(index);
			System.out.println("prepareMarineHullInformationJSON :::: " + objItem1.getString("gipiQuoteItemMH"));
			if (!objItem1.isNull("gipiQuoteItemMH")){
				JSONObject objItem = new JSONObject(objItem1.getString("gipiQuoteItemMH"));
				
				mh.setQuoteId(objItem.isNull("quoteId")? 0: objItem.getInt("quoteId"));
				mh.setItemNo(objItem.isNull("itemNo")? 0: objItem.getInt("itemNo"));
				mh.setGeogLimit(objItem.isNull("geogLimit")? "": objItem.getString("geogLimit"));
				mh.setDryPlace(objItem.isNull("dryPlace")? "": objItem.getString("dryPlace"));
				mh.setVesselCd(objItem.isNull("vesselCd")? "": objItem.getString("vesselCd"));
				mh.setRegOwner(objItem.isNull("regOwner")? "": objItem.getString("regOwner"));
				mh.setGrossTon(objItem.isNull("grossTon")? "": objItem.getString("grossTon"));
				mh.setDeductText(objItem.isNull("deductText")? "": objItem.getString("deductText"));
				mh.setVesselOldName(objItem.isNull("vesselOldName")? "": objItem.getString("vesselOldName"));
				mh.setVesTypeCd(objItem.isNull("vesTypeCd")? "": objItem.getString("vesTypeCd"));
				mh.setRegPlace(objItem.isNull("regPlace")? "": objItem.getString("regPlace"));
				mh.setYearBuilt(objItem.isNull("yearBuilt")? "": objItem.getString("yearBuilt"));
				mh.setCrewNat(objItem.isNull("crewNat")? "": objItem.getString("crewNat"));
				mh.setNoCrew(objItem.isNull("noCrew")? 0: objItem.getInt("noCrew"));
				mh.setNetTon(objItem.isNull("netTon")? 0: objItem.getDouble("netTon"));
				mh.setDeadWeight(objItem.isNull("deadWeight")? 0: objItem.getInt("deadWeight"));
				mh.setVesselDepth(objItem.isNull("vesselDepth")? 0: objItem.getDouble("vesselDepth"));
				mh.setVesselLength(objItem.isNull("vesselLength")? 0: objItem.getDouble("vesselLength"));
				mh.setVesselBreadth(objItem.isNull("vesselBreadth")? 0: objItem.getDouble("vesselBreadth"));
				mh.setPropelSw(objItem.isNull("propelSw")? "": objItem.getString("propelSw"));
				try{
					if(!(objItem.isNull("dryDate"))){
						mh.setDryDate(df.parse(objItem.getString("dryDate")));
					}
				}catch (ParseException e) {
					System.out.println("ERROR IN GIPIQuoteItemMHServiceImpl");
				}
				mhList.add(mh);
			}
		}
		return mhList;
	}
	
	
	public List<GIPIQuoteItemMH> prepareMarineHullInformation(JSONArray rows)throws JSONException {
		List<GIPIQuoteItemMH> mhList = new ArrayList<GIPIQuoteItemMH>();
		GIPIQuoteItemMH mh = null;
		JSONObject objItem = null;
		JSONObject objMH = null;	
		System.out.println("MH LENGTH: " + rows.length());
		for(int i=0, length=rows.length(); i < length; i++){
			mh = new GIPIQuoteItemMH();
			objItem = rows.getJSONObject(i);
			System.out.println("gipiQuoteItemMH &&&&&&&&&&&&&&&");
			objMH = objItem.isNull("gipiQuoteItemMH") ? null : objItem.getJSONObject("gipiQuoteItemMH");
			System.out.println("QUOTEID" + objItem.getInt("quoteId") + " itemNO:" + objItem.getInt("itemNo"));
			mh.setQuoteId(objMH.isNull("quoteId") ? null : objMH.getInt("quoteId"));
			mh.setItemNo(objMH.isNull("itemNo") ? null : objMH.getInt("itemNo"));
			mh.setGeogLimit(objMH.isNull("geogLimit") ? null : objMH.getString("geogLimit"));
			mh.setDryPlace(objMH.isNull("dryPlace") ? null : objMH.getString("dryPlace"));
			mh.setVesselCd(objMH.isNull("vesselCd") ? null : objMH.getString("vesselCd"));
			mh.setRegOwner(objMH.isNull("regOwner") ? null : objMH.getString("regOwner"));
			mh.setDeductText(objMH.isNull("geogLimit") ? null : objMH.getString("geogLimit"));
			mh.setVesselOldName(objMH.isNull("vesselOldName") ? null : objMH.getString("vesselOldName"));
			mh.setVesTypeCd(objMH.isNull("vesTypeCd") ? null : objMH.getString("vesTypeCd"));
			mh.setRegPlace(objMH.isNull("regPlace") ? null : objMH.getString("regPlace"));
			mh.setYearBuilt(objMH.isNull("yearBuilt") ? null : objMH.getString("yearBuilt"));
			mh.setCrewNat(objMH.isNull("crewNat") ? null : objMH.getString("crewNat"));
			mh.setNoCrew(objMH.isNull("noCrew") ? null : objMH.getInt("noCrew"));
			mh.setNetTon(objMH.isNull("netTon") ? null : objMH.getDouble("netTon"));
			mh.setDeadWeight(objMH.isNull("deadWeight") ? null : objMH.getInt("deadWeight"));
			mh.setVesselDepth(objMH.isNull("vesselDepth") ? null : objMH.getDouble("vesselDepth"));
			mh.setVesselLength(objMH.isNull("vesselLength") ? null : objMH.getDouble("vesselLength"));
			mh.setVesselBreadth(objMH.isNull("vesselBreadth") ? null : objMH.getDouble("vesselBreadth"));
			mh.setPropelSw(objMH.isNull("propelSw") ? null : objMH.getString("propelSw"));
			System.out.println("QUOTEID IN SERVICE" + mh.getQuoteId() + " itemNo: " + mh.getItemNo());
			mhList.add(mh);
			System.out.println("SIZE OBJECT"+ mhList.size());
			mh = null;
		}
		return mhList;
	}	
	
}
