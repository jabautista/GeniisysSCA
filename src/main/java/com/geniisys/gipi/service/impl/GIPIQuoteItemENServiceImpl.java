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

import com.geniisys.gipi.dao.GIPIQuoteItemENDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;
import com.geniisys.gipi.entity.GIPIQuotePrincipal;
import com.geniisys.gipi.service.GIPIQuoteItemENService;


/**
 * The Class GIPIQuoteItemENServiceImpl.
 */
public class GIPIQuoteItemENServiceImpl implements GIPIQuoteItemENService {

	/** The gipi quote item endao. */
	private GIPIQuoteItemENDAO gipiQuoteItemENDAO;
	private static Logger log = Logger.getLogger(GIPIQuoteItemENServiceImpl.class);
	
	/**
	 * Gets the gipi quote item endao.
	 * 
	 * @return the gipi quote item endao
	 */
	public GIPIQuoteItemENDAO getGipiQuoteItemENDAO() {
		return gipiQuoteItemENDAO;
	}

	/**
	 * Sets the gipi quote item endao.
	 * 
	 * @param gipiQuoteItemENDAO the new gipi quote item endao
	 */
	public void setGipiQuoteItemENDAO(GIPIQuoteItemENDAO gipiQuoteItemENDAO) {
		this.gipiQuoteItemENDAO = gipiQuoteItemENDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#getGIPIQuoteItemENDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemEN getGIPIQuoteItemENDetails(int quoteId, int itemNo)
			throws SQLException {
		return this.getGipiQuoteItemENDAO().getGIPIQuoteItemENDetails(quoteId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#saveGIPIQuoteItemEN(com.geniisys.gipi.entity.GIPIQuoteItemEN)
	 */
	@Override
	public void saveGIPIQuoteItemEN(GIPIQuoteItemEN quoteItemEN) throws SQLException {
		this.getGipiQuoteItemENDAO().saveGIPIQuoteItemEN(quoteItemEN);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#saveQuoteItemAdditionalInformation(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)
			throws SQLException {
		
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIQuoteItemEN quoteItemEN = null;
		
		String itemNos[]					= request.getParameterValues("aiItemNo");
		String contractProjectBusPartners[]	= request.getParameterValues("title");
		String locations[]					= request.getParameterValues("location");
		String constructionStarts[]			= request.getParameterValues("constFrom");
		String constructionEnds[]			= request.getParameterValues("constTo");
		String maintainanceStarts[]			= request.getParameterValues("maintFrom");
		String maintainanceEnds[]			= request.getParameterValues("maintTo");		
		
		try {
			for(int i = 0; i < contractProjectBusPartners.length; i++){
				quoteItemEN = new GIPIQuoteItemEN();
				quoteItemEN.setQuoteId(quoteId);
				quoteItemEN.setEnggBasicInfoNum(Integer.parseInt(itemNos[i]));	
				quoteItemEN.setContractProjBussTitle(contractProjectBusPartners[i]);
				quoteItemEN.setSiteLocation(locations[i]);
				if(!constructionStarts[i].equals(""))
					quoteItemEN.setConstructStartDate(df.parse(constructionStarts[i]));
				if(!constructionEnds[i].equals(""))
					quoteItemEN.setConstructEndDate(df.parse(constructionEnds[i]));
				if(!maintainanceStarts[i].equals(""))
					quoteItemEN.setMaintainStartDate(df.parse(maintainanceStarts[i]));
				if(!maintainanceEnds[i].equals(""))
					quoteItemEN.setMaintainEndDate(df.parse(maintainanceEnds[i]));				
				this.saveGIPIQuoteItemEN(quoteItemEN);
			}
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#deleteGIPIQuoteEN(int, int)
	 */
	@Override
	public void deleteGIPIQuoteEN(int quoteId, int itemNo) throws SQLException {
		this.gipiQuoteItemENDAO.deleteGIPIQuoteItemEN(quoteId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#getGIPIQuoteItemENs(int)
	 */
	@Override
	public List<GIPIQuoteItemEN> getGIPIQuoteItemENs(int quoteId)
			throws SQLException {
		return this.getGipiQuoteItemENDAO().getGIPIQuoteItemENs(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(
			HttpServletRequest request) {
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemEN> additionalInformationList = new ArrayList<GIPIQuoteItemEN>();
		
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIQuoteItemEN quoteItemEN = null;
		
		String itemNos[]					= request.getParameterValues("aiItemNo");
		String contractProjectBusPartners[]	= request.getParameterValues("title");
		String locations[]					= request.getParameterValues("location");
		String constructionStarts[]			= request.getParameterValues("constFrom");
		String constructionEnds[]			= request.getParameterValues("constTo");
		String maintainanceStarts[]			= request.getParameterValues("maintFrom");
		String maintainanceEnds[]			= request.getParameterValues("maintTo");		
		
		try {
			for(int i = 0; i < contractProjectBusPartners.length; i++){
				quoteItemEN = new GIPIQuoteItemEN();
				quoteItemEN.setQuoteId(quoteId);
				quoteItemEN.setEnggBasicInfoNum(Integer.parseInt(itemNos[i]));	
				quoteItemEN.setContractProjBussTitle(contractProjectBusPartners[i]);
				quoteItemEN.setSiteLocation(locations[i]);
				if(!constructionStarts[i].equals(""))
					quoteItemEN.setConstructStartDate(df.parse(constructionStarts[i]));
				if(!constructionEnds[i].equals(""))
					quoteItemEN.setConstructEndDate(df.parse(constructionEnds[i]));
				if(!maintainanceStarts[i].equals(""))
					quoteItemEN.setMaintainStartDate(df.parse(maintainanceStarts[i]));
				if(!maintainanceEnds[i].equals(""))
					quoteItemEN.setMaintainEndDate(df.parse(maintainanceEnds[i]));				
//				additionalInformationList.add(quoteItemEN);
				additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemEN);
			}
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
//		additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#prepareCasualtyInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemEN> prepareEngineeringInformationJSON(JSONArray rows)
			throws JSONException {
		List<GIPIQuoteItemEN> enList = new ArrayList<GIPIQuoteItemEN>();
		GIPIQuoteItemEN en = null;
		JSONObject objItem = null;
		JSONObject enObj = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int index = 0; index<rows.length(); index++){
			en = new GIPIQuoteItemEN();
			objItem = rows.getJSONObject(index);
			enObj = objItem.isNull("gipiQuoteItemEN") ? null : objItem.getJSONObject("gipiQuoteItemEN");
			
			if(enObj != null) {
				en.setQuoteId(enObj.isNull("quoteId")? 0 :enObj.getInt("quoteId"));
				en.setEnggBasicInfoNum(enObj.isNull("enggBasicInfoNum")? 0 :enObj.getInt("enggBasicInfoNum"));
				en.setContractProjBussTitle(enObj.isNull("contractProjBussTitle")?"":enObj.getString("contractProjBussTitle"));
				String test = enObj.isNull("contractProjBussTitle")?"WALANG LAMAN!!!!":enObj.getString("contractProjBussTitle");
				System.out.println("test====="+test);
				en.setSiteLocation(enObj.isNull("siteLocation")?"":enObj.getString("siteLocation"));
				try{
					if(!enObj.isNull("constructStartDate")){
						en.setConstructStartDate(df.parse(enObj.getString("constructStartDate")));
					}
					if(!enObj.isNull("constructEndDate")){
						en.setConstructEndDate(df.parse(enObj.getString("constructEndDate")));
					}
					if(!enObj.isNull("maintainStartDate")){
						en.setMaintainStartDate(df.parse(enObj.getString("maintainStartDate")));
					}
					if(!enObj.isNull("maintainEndDate")){
						en.setMaintainEndDate(df.parse(enObj.getString("maintainEndDate")));
					}
				}catch(ParseException pe){
					System.out.println("EXCEPTION ON GIPIQuoteItemEN");
				}
			}
			
			enList.add(en);
		}
		return enList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemENService#saveGIPIQuoteItemEN2(com.geniisys.gipi.entity.GIPIQuoteItemEN, java.lang.String)
	 */
	@Override
	public void saveGIPIQuoteItemEN2(GIPIQuoteItemEN quoteItemEN, String parameters) throws SQLException, JSONException, ParseException {
		// TODO Auto-generated method stub
		JSONObject objParameters = new JSONObject(parameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("addModifiedPrincipal", this.prepareAddModifiedPrincipal2(new JSONArray(objParameters.getString("addModifiedPrincipal"))));
		allParams.put("deletedPrincipal", this.prepareDeletedPrincipal(new JSONArray(objParameters.getString("deletedPrincipal"))));
		this.getGipiQuoteItemENDAO().saveGIPIQuoteItemEN(quoteItemEN, allParams);
	}
	
	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public List<GIPIQuotePrincipal> prepareAddModifiedPrincipal(JSONArray setRows) throws JSONException, ParseException{
		GIPIQuotePrincipal gipiQuotePrincipal = null;
		JSONObject json = null;
		List<GIPIQuotePrincipal> setPrincipal = new ArrayList<GIPIQuotePrincipal>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);

			gipiQuotePrincipal = new GIPIQuotePrincipal();						
			gipiQuotePrincipal.setQuoteId(json.isNull("quoteId") ? null : json.getInt("quoteId"));
			gipiQuotePrincipal.setPrincipalCd(json.isNull("principalCd") ? null : json.getInt("principalCd"));
			gipiQuotePrincipal.setSubconSw(json.isNull("subconSw") ? null : json.getString("subconSw"));
			gipiQuotePrincipal.setEnggBasicInfonum(json.isNull("enggBasicInfonum") ? null : json.getInt("enggBasicInfonum"));
			
			setPrincipal.add(gipiQuotePrincipal);
		}	
		return setPrincipal;
	}

	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public List<Map<String, Object>> prepareAddModifiedPrincipal2(JSONArray setRows) throws JSONException, ParseException{
		List<Map<String, Object>> addUpdateItems = new ArrayList<Map<String,Object>>();
		Map<String, Object> addUpdateItem = null;
		for(int index=0; index<setRows.length(); index++) {
			addUpdateItem = new HashMap<String, Object>();
			addUpdateItem.put("quoteId", setRows.getJSONObject(index).isNull("quoteId") ? null : setRows.getJSONObject(index).getInt("quoteId"));
			addUpdateItem.put("principalCd", setRows.getJSONObject(index).isNull("principalCd") ? null : setRows.getJSONObject(index).getInt("principalCd"));
			addUpdateItem.put("origPrincipalCd", setRows.getJSONObject(index).isNull("origPrincipalCd") ? null : setRows.getJSONObject(index).getInt("origPrincipalCd"));
			addUpdateItem.put("enggBasicInfonum", setRows.getJSONObject(index).isNull("enggBasicInfonum") ? null : setRows.getJSONObject(index).getInt("enggBasicInfonum"));
			addUpdateItem.put("subconSw", setRows.getJSONObject(index).isNull("subconSw") ? null : setRows.getJSONObject(index).getString("subconSw"));
			addUpdateItems.add(addUpdateItem);
		}	
		
		return addUpdateItems;
	}
	
	/**
	 * 
	 * @param delRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public List<Map<String, Object>> prepareDeletedPrincipal(JSONArray delRows) throws JSONException, ParseException{
		List<Map<String, Object>> delItems = new ArrayList<Map<String,Object>>();
		Map<String, Object> delItem = null;
		for(int index=0; index<delRows.length(); index++) {
			delItem = new HashMap<String, Object>();
			delItem.put("quoteId", delRows.getJSONObject(index).isNull("quoteId") ? null : delRows.getJSONObject(index).getInt("quoteId"));
			delItem.put("principalCd", delRows.getJSONObject(index).isNull("principalCd") ? null : delRows.getJSONObject(index).getInt("principalCd"));
			
			delItems.add(delItem);
		}	
		
		return delItems;
	}

	@Override
	public List<GIPIQuoteItemEN> getQuoteENDetailsForPackQuotation(
			List<GIPIQuote> enQuoteList) throws SQLException {
		return this.getGipiQuoteItemENDAO().getQuoteENDetailsForPackQuotation(enQuoteList);
	}

	@Override
	public void saveGIPIQuoteENDetailsForPackQuote(Map<String, Object> listParams) throws SQLException {
		this.getGipiQuoteItemENDAO().saveGIPIQuoteENDetailsForPackQuote(listParams);
	}
}
