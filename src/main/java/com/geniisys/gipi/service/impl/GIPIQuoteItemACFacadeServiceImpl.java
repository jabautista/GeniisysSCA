/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIQuoteItemACDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemAC;
import com.geniisys.gipi.service.GIPIQuoteItemACFacadeService;

/**
 * The Class GIPIQuoteItemACFacadeServiceImpl.
 */
public class GIPIQuoteItemACFacadeServiceImpl implements GIPIQuoteItemACFacadeService {

	/** The gipi quote item acdao. */
	private GIPIQuoteItemACDAO gipiQuoteItemACDAO;
	private static Logger log = Logger.getLogger(GIPIQuoteItemACFacadeServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemACFacadeService#getGIPIQuoteItemAc(int, int)
	 */
	@Override
	public GIPIQuoteItemAC getGIPIQuoteItemAc(int quoteId, int itemNo)
			throws SQLException {
		return this.gipiQuoteItemACDAO.getGIPIQuoteItemAc(quoteId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemACFacadeService#saveGIPIquoteItemAC(com.geniisys.gipi.entity.GIPIQuoteItemAC)
	 */
	@Override
	public void saveGIPIquoteItemAC(GIPIQuoteItemAC quoteItemAC)
			throws SQLException {
		this.gipiQuoteItemACDAO.saveGIPIquoteItemAC(quoteItemAC);	
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemACFacadeService#deleteGIPIQuoteItemAC(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemAC(int quoteId, int itemNo)
			throws SQLException {
		this.gipiQuoteItemACDAO.deleteGIPIQuoteItemAC(quoteId, itemNo);
		
	}

	/**
	 * Gets the gipi quote item acdao.
	 * 
	 * @return the gipi quote item acdao
	 */
	public GIPIQuoteItemACDAO getGipiQuoteItemACDAO() {
		return gipiQuoteItemACDAO;
	}

	/**
	 * Sets the gipi quote item acdao.
	 * 
	 * @param gipiQuoteItemACDAO the new gipi quote item acdao
	 */
	public void setGipiQuoteItemACDAO(GIPIQuoteItemACDAO gipiQuoteItemACDAO) {
		this.gipiQuoteItemACDAO = gipiQuoteItemACDAO;
	}

	/**
	 * Saves all of the additional information of Accident Line Quote Item
	 * @param request
	 */
	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request)
			throws SQLException {

		GIPIQuoteItemAC quoteItemAC = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");		
		
		String itemNos[]		= request.getParameterValues("aiItemNo");
		String noOfPersons[]	= request.getParameterValues("noOfPerson");
		String positions[]		= request.getParameterValues("position");
		String destinations[]	= request.getParameterValues("destination");
		String salary[]			= request.getParameterValues("salary");
		String salaryGrade[]	= request.getParameterValues("salaryGrade");
		String dobs[]  			= request.getParameterValues("dob");
		String civilStatii[]	= request.getParameterValues("civilStatus");
		String ages[]			= request.getParameterValues("age");
		String weights[]		= request.getParameterValues("weight");
		String heights[]		= request.getParameterValues("height");
		String sexes[]			= request.getParameterValues("sex");
		
		try {
			for(int i = 0; i < itemNos.length; i++){
				quoteItemAC = new GIPIQuoteItemAC();
				quoteItemAC.setQuoteId(quoteId);
				quoteItemAC.setItemNo(Integer.parseInt(itemNos[i]));
				quoteItemAC.setNoOfPerson((noOfPersons[i].equals("") ? "" : noOfPersons[i]));
				quoteItemAC.setPositionCd((positions[i].equals("") ? "" : positions[i]));
				quoteItemAC.setDestination(destinations[i]);
				{	String salTemp = salary[i].replaceAll(",", "");
					quoteItemAC.setMonthlySalary(new BigDecimal(salTemp.equals("")? "0" : salTemp));
				}   // bracket added to shorten salTemp's boundary
				
				quoteItemAC.setSalaryGrade(salaryGrade[i]);
				
				if(!dobs[i].equals(""))
					quoteItemAC.setDateOfBirth(sdf.parse(dobs[i]));
				
				quoteItemAC.setCivilStatus(civilStatii[i]);
				quoteItemAC.setAge((ages[i].equals("") ? "" : ages[i]));
				quoteItemAC.setWeight(weights[i]);
				quoteItemAC.setHeight(heights[i]);
				quoteItemAC.setSex(sexes[i]);
				this.saveGIPIquoteItemAC(quoteItemAC);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	@Override
	public List<GIPIQuoteItemAC> getGIPIQuoteItemACs(int quoteId)
			throws SQLException {
		return this.gipiQuoteItemACDAO.getGIPIQuoteItemACs(quoteId);
	}
	
	public Map<String, Object> prepareAdditionalInformationParams(HttpServletRequest request){
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemAC> additionalInformationList = new ArrayList<GIPIQuoteItemAC>();
		
		GIPIQuoteItemAC quoteItemAC = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");		
		
		String itemNos[]		= request.getParameterValues("aiItemNo");
		String noOfPersons[]	= request.getParameterValues("noOfPerson");
		String positions[]		= request.getParameterValues("position");
		String destinations[]	= request.getParameterValues("destination");
		String salary[]			= request.getParameterValues("salary");
		String salaryGrade[]	= request.getParameterValues("salaryGrade");
		String dobs[]  			= request.getParameterValues("dob");
		String civilStatii[]	= request.getParameterValues("civilStatus");
		String ages[]			= request.getParameterValues("age");
		String weights[]		= request.getParameterValues("weight");
		String heights[]		= request.getParameterValues("height");
		String sexes[]			= request.getParameterValues("sex");
		try {
			for(int i = 0; i < itemNos.length; i++){
				quoteItemAC = new GIPIQuoteItemAC();
				quoteItemAC.setQuoteId(quoteId);
				quoteItemAC.setItemNo(Integer.parseInt(itemNos[i]));
				quoteItemAC.setNoOfPerson((noOfPersons[i].equals("") ? "" : noOfPersons[i]));
				quoteItemAC.setPositionCd((positions[i].equals("") ? "" : positions[i]));
				quoteItemAC.setDestination(destinations[i]);
				{	String salTemp = salary[i].replaceAll(",", "");
					quoteItemAC.setMonthlySalary(new BigDecimal(salTemp.equals("")? "0" : salTemp));
				}   // bracket added to shorten salTemp's boundary
				
				quoteItemAC.setSalaryGrade(salaryGrade[i]);
				
				if(!dobs[i].equals(""))
					quoteItemAC.setDateOfBirth(sdf.parse(dobs[i]));
				
				quoteItemAC.setCivilStatus(civilStatii[i]);
				quoteItemAC.setAge((ages[i].equals("") ? "" : ages[i]));
				quoteItemAC.setWeight(weights[i]);
				quoteItemAC.setHeight(heights[i]);
				quoteItemAC.setSex(sexes[i]);
				additionalInformationParams.put("additionalInformation" + itemNos[i], quoteItemAC);
				//additionalInformationList.add(quoteItemAC);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
		//additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemACFacadeService#prepareAccidentInformationJSON(org.json.JSONArray, java.util.Map)
	 */
	@Override
	public List<GIPIQuoteItemAC> prepareAccidentInformationJSON(JSONArray rows) throws JSONException {
		List<GIPIQuoteItemAC> acInfoList = new ArrayList<GIPIQuoteItemAC>();
		GIPIQuoteItemAC ac = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject objAH = null;
		JSONObject objItem = null;		
		
		for(int index=0, length=rows.length(); index < length; index++){
			ac = new GIPIQuoteItemAC();
			objItem = rows.getJSONObject(index);
			
			objAH = objItem.isNull("gipiQuoteItemAC") ? null : objItem.getJSONObject("gipiQuoteItemAC");
			if(objAH != null){
				System.out.println("NO OF PERSON: "+objAH.getInt("itemNo")+" / "+objAH.getString("noOfPerson").replaceAll(",", ""));
				ac.setQuoteId(objAH.isNull("quoteId")?0:objAH.getInt("quoteId"));
				ac.setItemNo(objAH.isNull("itemNo")?0:objAH.getInt("itemNo"));
				ac.setNoOfPerson(objAH.isNull("noOfPerson")?"":objAH.getString("noOfPerson").replaceAll(",", ""));
				ac.setPositionCd(objAH.isNull("positionCd")?"":objAH.getString("positionCd"));
				ac.setDestination(objAH.isNull("destination")?"":StringEscapeUtils.unescapeHtml(objAH.getString("destination")));
				ac.setMonthlySalary(objAH.isNull("monthlySalary") || "".equals(objAH.getString("monthlySalary"))?null: new BigDecimal(objAH.getString("monthlySalary").replaceAll(",", "")));
				ac.setSalaryGrade(objAH.isNull("salaryGrade")?"":objAH.getString("salaryGrade"));
				try{
					if(!objAH.isNull("dateOfBirth")){
						ac.setDateOfBirth(df.parse(objAH.getString("dateOfBirth")));
					}else{
						System.out.println("NULL DATE OF BIRTH IN GIPIQuoteItemFacadeServiceImpl");
					}
				}catch (ParseException e) {
					System.out.println("PARSE EXCEPTION IN GIPIQuoteItemACFacadeServiceImpl");
				}
				ac.setCivilStatus(objAH.isNull("civilStatus")?"":objAH.getString("civilStatus"));
				ac.setAge(objAH.isNull("age")?"":objAH.getString("age"));
				ac.setWeight(objAH.isNull("weight")?"":StringEscapeUtils.unescapeHtml(objAH.getString("weight")));
				ac.setHeight(objAH.isNull("height")?"":StringEscapeUtils.unescapeHtml(objAH.getString("height")));
				ac.setSex(objAH.isNull("sex")?"":objAH.getString("sex"));
				ac.setAcClassCd(objAH.isNull("acClassCd")?"":objAH.getString("acClassCd"));
				ac.setGroupPrintSw(objAH.isNull("groupPrintSw")?"":objAH.getString("groupPrintSw"));
				ac.setLevelCd(objAH.isNull("levelCd")?"":objAH.getString("levelCd"));
				ac.setParentLevelCd(objAH.isNull("parentLevelCd")?"":objAH.getString("parentLevelCd"));
				acInfoList.add(ac);
				ac = null;
			}
		}
		
		return acInfoList;
	}
	
}
