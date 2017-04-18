/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIQuoteItemAVDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemAV;
import com.geniisys.gipi.service.GIPIQuoteItemAVService;


/**
 * The Class GIPIQuoteItemAVServiceImpl.
 */
public class GIPIQuoteItemAVServiceImpl implements GIPIQuoteItemAVService {

	/** The gipi quote item avdao. */
	private GIPIQuoteItemAVDAO gipiQuoteItemAVDAO;
	
	/**
	 * Gets the gipi quote item avdao.
	 * 
	 * @return the gipi quote item avdao
	 */
	public GIPIQuoteItemAVDAO getGipiQuoteItemAVDAO() {
		return gipiQuoteItemAVDAO;
	}

	/**
	 * Sets the gipi quote item avdao.
	 * 
	 * @param gipiQuoteItemAVDAO the new gipi quote item avdao
	 */
	public void setGipiQuoteItemAVDAO(GIPIQuoteItemAVDAO gipiQuoteItemAVDAO) {
		this.gipiQuoteItemAVDAO = gipiQuoteItemAVDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemAVService#getGIPIQuoteItemAVDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemAV getGIPIQuoteItemAVDetails(int quoteId, int itemNo)
			throws SQLException {
		return this.getGipiQuoteItemAVDAO().getGIPIQuoteItemAVDetails(quoteId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemAVService#saveGIPIQuoteItemAV(com.geniisys.gipi.entity.GIPIQuoteItemAV)
	 */
	@Override
	public void saveGIPIQuoteItemAV(GIPIQuoteItemAV quoteItemAV)
			throws SQLException {
		this.getGipiQuoteItemAVDAO().saveGIPIQuoteItemAV(quoteItemAV);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemAVService#saveQuoteItemAdditionalInformation(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)
			throws SQLException {
		GIPIQuoteItemAV quoteItemAV = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String itemNos[]		= request.getParameterValues("aiItemNo");
		String vesselCds[]		= request.getParameterValues("vessel");
		String purposes[]		= request.getParameterValues("purpose");
		String deductText[]		= request.getParameterValues("deductText");
		String prevUtilHrs[]	= request.getParameterValues("prevUtilHrs");
		String estUtilHrs[]		= request.getParameterValues("estUtilHrs");
		String totalFlyTimes[]	= request.getParameterValues("totalFlyTime");
		String qualifications[]	= request.getParameterValues("qualification");
		String geogLimits[]		= request.getParameterValues("geogLimit");
		
		for(int i=0; i<vesselCds.length; i++){
			quoteItemAV = new GIPIQuoteItemAV();
			quoteItemAV.setQuoteId(quoteId);
			quoteItemAV.setItemNo(Integer.parseInt(itemNos[i]));
			quoteItemAV.setVesselCd(vesselCds[i]);
			quoteItemAV.setRecFlag(null);
			quoteItemAV.setFixedWing(null);
			quoteItemAV.setRotor(null);
			quoteItemAV.setPurpose(purposes[i]);
			quoteItemAV.setDeductText(deductText[i]);
			quoteItemAV.setPrevUtilHrs(Integer.parseInt(prevUtilHrs[i].equals("") ? "0" : prevUtilHrs[i]));
			quoteItemAV.setEstUtilHrs(Integer.parseInt(estUtilHrs[i].equals("") ? "0" : estUtilHrs[i]));
			quoteItemAV.setTotalFlyTime(Integer.parseInt(totalFlyTimes[i].equals("") ? "0" : totalFlyTimes[i]));
			quoteItemAV.setQualification(qualifications[i]);
			quoteItemAV.setGeogLimit(geogLimits[i]);
			this.saveGIPIQuoteItemAV(quoteItemAV);
		}
	}

	@Override
	public void deleteGIPIQuoteAV(int quoteId, int itemNo) throws SQLException {
		this.gipiQuoteItemAVDAO.deleteGIPIQuoteItemAV(quoteId, itemNo);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemAVService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request){
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
		List<GIPIQuoteItemAV> additionalInformationList = new ArrayList<GIPIQuoteItemAV>();
		
		GIPIQuoteItemAV quoteItemAV = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String itemNos[]		= request.getParameterValues("aiItemNo");
		String vesselCds[]		= request.getParameterValues("vessel");
		String purposes[]		= request.getParameterValues("purpose");
		String deductText[]		= request.getParameterValues("deductText");
		String prevUtilHrs[]	= request.getParameterValues("prevUtilHrs");
		String estUtilHrs[]		= request.getParameterValues("estUtilHrs");
		String totalFlyTimes[]	= request.getParameterValues("totalFlyTime");
		String qualifications[]	= request.getParameterValues("qualification");
		String geogLimits[]		= request.getParameterValues("geogLimit");
		
		for(int i=0; i<vesselCds.length; i++){
			quoteItemAV = new GIPIQuoteItemAV();
			quoteItemAV.setQuoteId(quoteId);
			quoteItemAV.setItemNo(Integer.parseInt(itemNos[i]));
			quoteItemAV.setVesselCd(vesselCds[i]);
			quoteItemAV.setRecFlag(null);
			quoteItemAV.setFixedWing(null);
			quoteItemAV.setRotor(null);
			quoteItemAV.setPurpose(purposes[i]);
			quoteItemAV.setDeductText(deductText[i]);
			quoteItemAV.setPrevUtilHrs(Integer.parseInt(prevUtilHrs[i].equals("") ? "0" : prevUtilHrs[i]));
			quoteItemAV.setEstUtilHrs(Integer.parseInt(estUtilHrs[i].equals("") ? "0" : estUtilHrs[i]));
			quoteItemAV.setTotalFlyTime(Integer.parseInt(totalFlyTimes[i].equals("") ? "0" : totalFlyTimes[i]));
			quoteItemAV.setQualification(qualifications[i]);
			quoteItemAV.setGeogLimit(geogLimits[i]);
			additionalInformationList.add(quoteItemAV);
			additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemAV);
		}
		
//		additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemAVService#prepareAviationInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemAV> prepareAviationInformationJSON(JSONArray rows)
			throws JSONException {
		List<GIPIQuoteItemAV> avList = new ArrayList<GIPIQuoteItemAV>();
		GIPIQuoteItemAV av = null;
		JSONObject objAV = null;
		
		for(int index=0; index<rows.length(); index++){
			av = new GIPIQuoteItemAV();
			objAV = (rows.getJSONObject(index).isNull("gipiQuoteItemAV")) ? null : rows.getJSONObject(index).getJSONObject("gipiQuoteItemAV");
			
			if (objAV != null) {
				av.setQuoteId(objAV.isNull("quoteId")?0:objAV.getInt("quoteId"));
				av.setItemNo(objAV.isNull("itemNo")?0:objAV.getInt("itemNo"));
				av.setVesselCd(objAV.isNull("vesselCd")?"":objAV.getString("vesselCd"));
	//			av.setRecFlag(objAV.isNull("recFlag")?"":objAV.getString("recFlag"));
	//			av.setFixedWing(objAV.isNull("fixedWing")?"":objAV.getString("fixedWing"));
	//			av.setRotor(objAV.isNull("rotor")?"":objAV.getString("rotor"));
				av.setPurpose(objAV.isNull("purpose")?"":objAV.getString("purpose"));
				av.setDeductText(objAV.isNull("deductText")?"":objAV.getString("deductText"));
				av.setPrevUtilHrs(objAV.isNull("prevUtilHrs")?0:objAV.getInt("prevUtilHrs"));
				av.setEstUtilHrs(objAV.isNull("estUtilHrs")?0:objAV.getInt("estUtilHrs"));
				av.setTotalFlyTime(objAV.isNull("totalFlyTime")?0:objAV.getInt("totalFlyTime")); //angelo 04.30.11 - fixed typo 
				av.setQualification(objAV.isNull("qualification")?"":objAV.getString("qualification"));
				av.setGeogLimit(objAV.isNull("geogLimit")?"":objAV.getString("geogLimit"));
				avList.add(av);
			}
		}
		return avList;
	}
}
