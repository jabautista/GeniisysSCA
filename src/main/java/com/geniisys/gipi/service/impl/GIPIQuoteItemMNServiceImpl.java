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

import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.controllers.GIPIQuotationMarineCargoController;
import com.geniisys.gipi.dao.GIPIQuoteItemMNDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemMN;
import com.geniisys.gipi.service.GIPIQuoteItemMNService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuoteItemMNServiceImpl.
 */
public class GIPIQuoteItemMNServiceImpl implements GIPIQuoteItemMNService {

	private static Logger log = Logger.getLogger(GIPIQuotationMarineCargoController.class);

	private GIPIQuoteItemMNDAO gipiQuoteItemMNDAO;
	
	/**
	 * Gets the gipi quote item mndao.
	 * 
	 * @return the gipi quote item mndao
	 */
	public GIPIQuoteItemMNDAO getGipiQuoteItemMNDAO() {
		return gipiQuoteItemMNDAO;
	}

	/**
	 * Sets the gipi quote item mndao.
	 * 
	 * @param gipiQuoteItemMNDAO the new gipi quote item mndao
	 */
	public void setGipiQuoteItemMNDAO(GIPIQuoteItemMNDAO gipiQuoteItemMNDAO) {
		this.gipiQuoteItemMNDAO = gipiQuoteItemMNDAO;
	}
	
	/**	
	 * Saves a set of additional information  based on the number of items in the itemsList 
	 * @since March 11,2010
	 * @author rencela
	 * @param httpServletRequest
	 * @param httpServletResponse
	 * @param servletContext
	 */
	public void saveGIPIQuoteItemMNAdditionalInformation(HttpServletRequest request)
		throws SQLException{
		
	}
	
	/* Modified by Grace 10.04.2010
	 * Added use of StringFormatter to handle string input with quotes
	 */
	@Override
	public GIPIQuoteItemMN getGIPIQuoteItemMNDetails(int quoteId, int itemNo)
			throws SQLException {
		return (GIPIQuoteItemMN) StringFormatter.replaceQuotesInObject(this.getGipiQuoteItemMNDAO().getGIPIQuoteItemMNDetails(quoteId, itemNo));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMNService#saveGIPIQuoteItemMN(com.geniisys.gipi.entity.GIPIQuoteItemMN)
	 */
	@Override
	public void saveGIPIQuoteItemMN(GIPIQuoteItemMN quoteItemMN)
			throws SQLException {
		this.getGipiQuoteItemMNDAO().saveGIPIQuoteItemMN(quoteItemMN);
	}

	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request) throws SQLException {
		log.info("Initializing: "+ this.getClass().getSimpleName());
		
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIQuoteItemMN quoteItemMn = null;
		
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		try {
			String itemNos[] 			= request.getParameterValues("aiItemNo");
			String geogCds[] 			= request.getParameterValues("geogCd");
			String vesselCds[]			= request.getParameterValues("vesselCd");
			String cargoClassCds[]		= request.getParameterValues("cargoClassCd");
			String cargoTypes[] 		= request.getParameterValues("cargoType");
			String packMethods[]		= request.getParameterValues("packMethod");
			String blAwbs[]				= request.getParameterValues("blAwb");
			String transhipOrigins[]	= request.getParameterValues("transhipOrigin");
			String transhipDestinations[]=request.getParameterValues("transhipDestination");
			String voyageNos[]			= request.getParameterValues("voyageNo");
			String lcNos[]				= request.getParameterValues("lcNo");
			String etds[]				= request.getParameterValues("etd");
			String etas[]				= request.getParameterValues("eta");
			String printTags[]			= request.getParameterValues("printTag");
			String origin[]				= request.getParameterValues("origin");
			String destinations[]		= request.getParameterValues("destn");
			
			for(int i=0; i<geogCds.length; i++){
				quoteItemMn = new GIPIQuoteItemMN();
				quoteItemMn.setQuoteId(quoteId);
				quoteItemMn.setItemNo(Integer.parseInt(itemNos[i])); 
				quoteItemMn.setGeogCd(Integer.parseInt( (geogCds[i].equals("")) ? "0" : geogCds[i]));
				quoteItemMn.setVesselCd(vesselCds[i]);
				quoteItemMn.setCargoClassCd(Integer.parseInt(cargoClassCds[i].equals("") ? "0" : cargoClassCds[i]));
				quoteItemMn.setCargoType(cargoTypes[i]);
				quoteItemMn.setPackMethod(packMethods[i]);
				quoteItemMn.setBlAwb(blAwbs[i]);
				quoteItemMn.setTranshipOrigin(transhipOrigins[i]);
				quoteItemMn.setTranshipDestination(transhipDestinations[i]);
				quoteItemMn.setVoyageNo(voyageNos[i]);
				quoteItemMn.setLcNo(lcNos[i]);
				
				if(!etds[i].equals("")){
					quoteItemMn.setEtd(df.parse(etds[i]));
				}
				if(!etas[i].equals("")){
					quoteItemMn.setEta(df.parse(etas[i]));
				}
				
				quoteItemMn.setPrintTag(Integer.parseInt(printTags[i].equals("") ? "0" : printTags[i]));				
				quoteItemMn.setOrigin(origin[i]);
				quoteItemMn.setDestn(destinations[i]);
				this.saveGIPIQuoteItemMN(quoteItemMn);
			}			
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMNService#deleteGIPIQuoteMN(int, int)
	 */
	@Override
	public void deleteGIPIQuoteMN(int quoteId, int itemNo) throws SQLException {
		this.gipiQuoteItemMNDAO.deleteGIPIQuoteItemMN(quoteId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMNService#getGIPIQuoteItemMNs(int)
	 */
	@Override
	public List<GIPIQuoteItemMN> getGIPIQuoteItemMNs(int quoteId)
			throws SQLException {
		return this.getGipiQuoteItemMNDAO().getGIPIQuoteItemMNs(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMNService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(
			HttpServletRequest request) {
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemMN> additionalInformationList = new ArrayList<GIPIQuoteItemMN>();
		
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIQuoteItemMN quoteItemMn = null;
		
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		try {
			String itemNos[] 			= request.getParameterValues("aiItemNo");
			String geogCds[] 			= request.getParameterValues("geogCd");
			String vesselCds[]			= request.getParameterValues("vesselCd");
			String cargoClassCds[]		= request.getParameterValues("cargoClassCd");
			String cargoTypes[] 		= request.getParameterValues("cargoType");
			String packMethods[]		= request.getParameterValues("packMethod");
			String blAwbs[]				= request.getParameterValues("blAwb");
			String transhipOrigins[]	= request.getParameterValues("transhipOrigin");
			String transhipDestinations[]=request.getParameterValues("transhipDestination");
			String voyageNos[]			= request.getParameterValues("voyageNo");
			String lcNos[]				= request.getParameterValues("lcNo");
			String etds[]				= request.getParameterValues("etd");
			String etas[]				= request.getParameterValues("eta");
			String printTags[]			= request.getParameterValues("printTag");
			String origin[]				= request.getParameterValues("origin");
			String destinations[]		= request.getParameterValues("destn");
			
			for(int i=0; i<geogCds.length; i++){
				quoteItemMn = new GIPIQuoteItemMN();
				quoteItemMn.setQuoteId(quoteId);
				quoteItemMn.setItemNo(Integer.parseInt(itemNos[i])); 
				quoteItemMn.setGeogCd(Integer.parseInt( (geogCds[i].equals("")) ? "0" : geogCds[i]));
				quoteItemMn.setVesselCd(vesselCds[i]);
				quoteItemMn.setCargoClassCd(Integer.parseInt(cargoClassCds[i].equals("") ? "0" : cargoClassCds[i]));
				quoteItemMn.setCargoType(cargoTypes[i]);
				quoteItemMn.setPackMethod(packMethods[i]);
				quoteItemMn.setBlAwb(blAwbs[i]);
				quoteItemMn.setTranshipOrigin(transhipOrigins[i]);
				quoteItemMn.setTranshipDestination(transhipDestinations[i]);
				quoteItemMn.setVoyageNo(voyageNos[i]);
				quoteItemMn.setLcNo(lcNos[i]);
				
				if(!etds[i].equals("")){
					quoteItemMn.setEtd(df.parse(etds[i]));
				}
				if(!etas[i].equals("")){
					quoteItemMn.setEta(df.parse(etas[i]));
				}
				
				quoteItemMn.setPrintTag(Integer.parseInt(printTags[i].equals("") ? "0" : printTags[i]));				
				quoteItemMn.setOrigin(origin[i]);
				quoteItemMn.setDestn(destinations[i]);
//				additionalInformationList.add(quoteItemMn);
				additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemMn);
			}			
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
//		additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMNService#prepareMarinceCargoInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemMN> prepareMarineCargoInformationJSON(JSONArray rows)
			throws JSONException {
		List<GIPIQuoteItemMN> mnList = new ArrayList<GIPIQuoteItemMN>();
		GIPIQuoteItemMN mn = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject objMN = null;
		JSONObject objItem = null;
		
		for(int index = 0; index<rows.length(); index++){
			mn = new GIPIQuoteItemMN();
			objItem = rows.getJSONObject(index);
			
			objMN = objItem.isNull("gipiQuoteItemMN") ? null : objItem.getJSONObject("gipiQuoteItemMN");
			if (objMN != null){
				mn.setQuoteId(objMN.isNull("quoteId")?0:objMN.getInt("quoteId"));
				mn.setItemNo(objMN.isNull("itemNo")?0:objMN.getInt("itemNo"));
				mn.setGeogCd(objMN.isNull("geogCd")||"".equals(objMN.getString("geogCd"))?0:objMN.getInt("geogCd"));
				mn.setVesselCd(objMN.isNull("vesselCd")||"".equals(objMN.getString("vesselCd"))?"":objMN.getString("vesselCd"));
				mn.setCargoClassCd(objMN.isNull("cargoClassCd")||"".equals(objMN.getString("cargoClassCd"))?0:objMN.getInt("cargoClassCd"));
				mn.setCargoType(objMN.isNull("cargoType")||"".equals(objMN.getString("cargoType"))?"":objMN.getString("cargoType"));
				mn.setPackMethod(objMN.isNull("packMethod")?"":objMN.getString("packMethod"));
				mn.setBlAwb(objMN.isNull("blAwb")?"":objMN.getString("blAwb"));
				mn.setTranshipOrigin(objMN.isNull("transhipOrigin")?"":objMN.getString("transhipOrigin"));
				mn.setTranshipDestination(objMN.isNull("transhipDestination")?"":objMN.getString("transhipDestination"));
				mn.setVoyageNo(objMN.isNull("voyageNo")?"":objMN.getString("voyageNo"));
				mn.setLcNo(objMN.isNull("lcNo")?"":objMN.getString("lcNo"));
				mn.setPrintTag(objMN.isNull("printTag")||"".equals(objMN.getString("printTag"))?0:objMN.getInt("printTag"));
				mn.setOrigin(objMN.isNull("origin")?"":objMN.getString("origin"));
				mn.setDestn(objMN.isNull("destn")?"":objMN.getString("destn"));
				try{
					if(!objMN.isNull("etd")){
						mn.setEtd(df.parse(objMN.getString("etd")));
					}
					if(!objMN.isNull("eta")){
						mn.setEta(df.parse(objMN.getString("eta")));
					}
				}catch (ParseException e) {
					System.out.println("ERROR IN GIPIQuoteItemMNServiceImpl");
				}
				mnList.add(mn);
				mn = null;
			}
		}
		return mnList;
	}
	
	public void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIQuote gipiQuote){
		String[] quoteIdParam = {String.valueOf(gipiQuote.getQuoteId())};
		String[] vCargoClass = {request.getParameter("cargoClassCd")};
		String[] printTagParams = {"GIPI_WCARGO.PRINT_TAG"};
		
		request.setAttribute("geogs", lovHelper.getList(LOVHelper.GEOG_LISTING, quoteIdParam));
		request.setAttribute("quoteVessels", lovHelper.getList(LOVHelper.QUOTE_VESSEL_LISTING, quoteIdParam));
		request.setAttribute("cargoClasses", lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING));
		request.setAttribute("cargoTypes", lovHelper.getList(LOVHelper.CARGO_TYPE_LISTING, vCargoClass));
		request.setAttribute("printTags", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, printTagParams));
	}
}