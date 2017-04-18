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

import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.dao.GIPIQuoteItemCADAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemCA;
import com.geniisys.gipi.service.GIPIQuoteItemCAService;


/**
 * The Class GIPIQuoteItemCAServiceImpl.
 */
public class GIPIQuoteItemCAServiceImpl implements GIPIQuoteItemCAService {

	/** The gipi quote item cadao. */
	private GIPIQuoteItemCADAO gipiQuoteItemCADAO;
	
	
	/**
	 * Gets the gipi quote item cadao.
	 * 
	 * @return the gipi quote item cadao
	 */
	public GIPIQuoteItemCADAO getGipiQuoteItemCADAO() {
		return gipiQuoteItemCADAO;
	}

	/**
	 * Sets the gipi quote item cadao.
	 * 
	 * @param gipiQuoteItemCADAO the new gipi quote item cadao
	 */
	public void setGipiQuoteItemCADAO(GIPIQuoteItemCADAO gipiQuoteItemCADAO) {
		this.gipiQuoteItemCADAO = gipiQuoteItemCADAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#getGIPIQuoteItemCADetails(int, int)
	 */
	@Override
	public GIPIQuoteItemCA getGIPIQuoteItemCADetails(int quoteId, int itemNo)
			throws SQLException {
		System.out.println("quoteID: " + quoteId + "   ||  itemNo: " + itemNo);
		return this.getGipiQuoteItemCADAO().getGIPIQuoteItemCADetails(quoteId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#saveGIPIQuoteItemCA(com.geniisys.gipi.entity.GIPIQuoteItemCA)
	 */
	@Override
	public void saveGIPIQuoteItemCA(GIPIQuoteItemCA quoteItemCA)
			throws SQLException {
		System.out.println("save additl info...");
		this.getGipiQuoteItemCADAO().saveGIPIQuoteItemCA(quoteItemCA);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#saveQuoteItemAdditionalInformation(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)
			throws SQLException {
		GIPIQuoteItemCA quoteItemCA = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String itemNos[]				= request.getParameterValues("aiItemNo");
		String sectionLineCds[]			= request.getParameterValues("sectionLineCd");
		String sectionLineSublineCds[]	= request.getParameterValues("sectionSublineCd");
		String locations[]				= request.getParameterValues("location");
		String sectionOrHazardCd[]		= request.getParameterValues("sectionOrHazard");
		String capacityCds[]			= request.getParameterValues("capacity");
		String limits[]					= request.getParameterValues("limitOfLiability");
		
		for(int i = 0; i < sectionLineCds.length; i++){
			quoteItemCA = new GIPIQuoteItemCA();
			quoteItemCA.setQuoteId(quoteId);
			quoteItemCA.setItemNo(Integer.parseInt(itemNos[i]));
			quoteItemCA.setSectionLineCd(sectionLineCds[i]);
			quoteItemCA.setSectionSublineCd(sectionLineSublineCds[i]);
			quoteItemCA.setLocation(locations[i]);
			quoteItemCA.setSectionOrHazardCd(sectionOrHazardCd[i]);
			quoteItemCA.setCapacityCd(Integer.parseInt(capacityCds[i].equals("") ? "0" : capacityCds[i]));
			quoteItemCA.setLimitOfLiability(limits[i]);
			this.saveGIPIQuoteItemCA(quoteItemCA);
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#deleteGIPIQuoteCA(int, int)
	 */
	@Override
	public void deleteGIPIQuoteCA(int quoteId, int itemNo) throws SQLException {
		this.gipiQuoteItemCADAO.deleteGIPIQuoteItemCA(quoteId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#getGIPIQuoteItemCAs(int)
	 */
	@Override
	public List<GIPIQuoteItemCA> getGIPIQuoteItemCAs(int quoteId)
			throws SQLException {
		return this.getGipiQuoteItemCADAO().getGIPIQuoteItemCAs(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(
			HttpServletRequest request) {
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemCA> additionalInformationList = new ArrayList<GIPIQuoteItemCA>();
		
		GIPIQuoteItemCA quoteItemCA = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String itemNos[]				= request.getParameterValues("aiItemNo");
		String sectionLineCds[]			= request.getParameterValues("sectionLineCd");
		String sectionLineSublineCds[]	= request.getParameterValues("sectionSublineCd");
		String locations[]				= request.getParameterValues("location");
		String sectionOrHazardCd[]		= request.getParameterValues("sectionOrHazard");
		String capacityCds[]			= request.getParameterValues("capacity");
		String limits[]					= request.getParameterValues("limitOfLiability");
		
		for(int i = 0; i < sectionLineCds.length; i++){
			quoteItemCA = new GIPIQuoteItemCA();
			quoteItemCA.setQuoteId(quoteId);
			quoteItemCA.setItemNo(Integer.parseInt(itemNos[i]));
			quoteItemCA.setSectionLineCd(sectionLineCds[i]);
			quoteItemCA.setSectionSublineCd(sectionLineSublineCds[i]);
			quoteItemCA.setLocation(locations[i]);
			quoteItemCA.setSectionOrHazardCd(sectionOrHazardCd[i]);
			quoteItemCA.setCapacityCd(Integer.parseInt(capacityCds[i].equals("") ? "0" : capacityCds[i]));
			quoteItemCA.setLimitOfLiability(limits[i]);
			additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemCA);
		}
		
		return additionalInformationParams;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemCAService#prepareCasualtyInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemCA> prepareCasualtyInformation(JSONArray rows)
			throws JSONException {
		List<GIPIQuoteItemCA> caList = new ArrayList<GIPIQuoteItemCA>();
		GIPIQuoteItemCA ca = null;
		JSONObject objItem = null;
		JSONObject objCA = null;
		for(int index = 0; index<rows.length(); index++){
			ca = new GIPIQuoteItemCA();
			objItem = rows.getJSONObject(index);
			objCA = objItem.isNull("gipiQuoteItemCA") ? null : objItem.getJSONObject("gipiQuoteItemCA");
			if(objCA != null){
				ca.setQuoteId(objItem.isNull("quoteId") ? null : objItem.getInt("quoteId"));
				ca.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				ca.setSectionLineCd(objCA.isNull("sectionLineCd") ? null : objCA.getString("sectionLineCd"));
				ca.setSectionSublineCd(objCA.isNull("sectionSublineCd") ? null : objCA.getString("sectionSublineCd"));
				ca.setLocation(objCA.isNull("location") ? null : objCA.getString("location"));
				ca.setSectionOrHazardCd(objCA.isNull("sectionOrHazardCd") ? null : objCA.getString("sectionOrHazardCd"));
				ca.setCapacityCd(objCA.isNull("capacityCd") ? null : Integer.parseInt(objCA.getString("capacityCd")));
				ca.setLimitOfLiability(objCA.isNull("limitOfLiability") ? null : objCA.getString("limitOfLiability"));
				caList.add(ca);
			}
		}
		return caList;
	}
	
	public void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIQuote gipiQuote){
		request.setAttribute("positionLov", lovHelper.getList(LOVHelper.POSITION_LISTING));
		request.setAttribute("hazardLov", lovHelper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING));
	}
}