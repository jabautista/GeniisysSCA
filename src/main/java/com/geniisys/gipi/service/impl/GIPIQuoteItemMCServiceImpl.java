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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.dao.GIPIQuoteItemMCDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemMC;
import com.geniisys.gipi.service.GIPIQuoteItemMCService;


/**
 * The Class GIPIQuoteItemMCServiceImpl.
 */
public class GIPIQuoteItemMCServiceImpl implements GIPIQuoteItemMCService {

	/** The gipi quote item mcdao. */
	private GIPIQuoteItemMCDAO gipiQuoteItemMCDAO;
	private static Logger log = Logger.getLogger(GIPIQuoteItemMCServiceImpl.class);
	
	/**
	 * Gets the gipi quote item mcdao.
	 * 
	 * @return the gipi quote item mcdao
	 */
	public GIPIQuoteItemMCDAO getGipiQuoteItemMCDAO() {
		return gipiQuoteItemMCDAO;
	}

	/**
	 * Sets the gipi quote item mcdao.
	 * 
	 * @param gipiQuoteItemMCDAO the new gipi quote item mcdao
	 */
	public void setGipiQuoteItemMCDAO(GIPIQuoteItemMCDAO gipiQuoteItemMCDAO) {
		this.gipiQuoteItemMCDAO = gipiQuoteItemMCDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#getGIPIQuoteItemMC(int, int)
	 */
	@Override
	public GIPIQuoteItemMC getGIPIQuoteItemMC(int quoteId, int itemNo)
			throws SQLException {
		return this.gipiQuoteItemMCDAO.getGIPIQuoteItemMC(quoteId, itemNo);
	}

	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#saveGIPIQuoteItemMC(com.geniisys.gipi.entity.GIPIQuoteItemMC)
	 */
	@Override
	public void saveGIPIQuoteItemMC(GIPIQuoteItemMC quoteItemMC)
			throws SQLException {
		//this.deleteGIPIQuoteItemMC(quoteItemMC.getQuoteId(), quoteItemMC.getItemNo());
		this.getGipiQuoteItemMCDAO().saveGIPIQuoteItemMC(quoteItemMC);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#deleteGIPIQuoteItemMC(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemMC(int quoteId, int itemNo)
			throws SQLException {
		this.getGipiQuoteItemMCDAO().deleteGIPIQuoteItemMC(quoteId, itemNo);
	}
	
	public void deleteGipiQuoteItemAddInfoMc(int quoteId)throws SQLException{
		this.getGipiQuoteItemMCDAO().deleteGipiQuoteItemAddInfoMc(quoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#getGIPIQuoteItemMCs(int)
	 */
	@Override
	public List<GIPIQuoteItemMC> getGIPIQuoteItemMCs(int quoteId) throws SQLException {
		return this.getGipiQuoteItemMCDAO().getGIPIQuoteItemMCs(quoteId);
	}

	public List<String> getAllSerialMc() throws SQLException{
		return this.getGipiQuoteItemMCDAO().getAllSerialMc();
	}
	
	public List<String> getAllMotorMc() throws SQLException{
		return this.getGipiQuoteItemMCDAO().getAllMotorMc();
	}
	
	public List<String> getAllPlateMc() throws SQLException{
		return this.getGipiQuoteItemMCDAO().getAllPlateMc();
	}
	
	public List<String> getAllCocMc() throws SQLException{
		return this.getGipiQuoteItemMCDAO().getAllCocMc();
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#saveQuoteItemAdditionalInformation(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public void saveQuoteItemAdditionalInformation(HttpServletRequest request, String subLineCd, String userId)
			throws SQLException {
		
		GIPIQuoteItemMC gipiQuoteItemMC = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String itemNos[]		= request.getParameterValues("aiItemNo");		
		String plateNos[]		= request.getParameterValues("plateNo");
		String motorNos[]		= request.getParameterValues("motorNo");		
		String serialNos[] 		= request.getParameterValues("serialNo");	//HIDDEN
		String sublineTypeCds[] = request.getParameterValues("sublineType");	//HIDDEN*
		String motorTypes[] 	= request.getParameterValues("motorType");
		String carCompanies[]	= request.getParameterValues("carCompany");		
		String cocYys[]			= request.getParameterValues("cocYy");		//HIDDEN
		String cocSerialNos[]	= request.getParameterValues("cocSerialNo");	//HIDDEN
		String cocTypes[]		= request.getParameterValues("cocType");		//HIDDEN
		String repairLimits[]	= request.getParameterValues("repairLimit");	//HIDDEN	
		String modelYears[]		= request.getParameterValues("modelYear");
		String towLimits[]		= request.getParameterValues("towLimit");
		String noOfPassengers[]	= request.getParameterValues("noOfPass");	//HIDDEN	
		String mvFilesNos[]		= request.getParameterValues("mvFileNo");		
		String acquirees[]		= request.getParameterValues("acquiredFrom");
		String assignees[]		= request.getParameterValues("assignee");		
		String ctvTags[]		= request.getParameterValues("ctvTag");			//HIDDEN
		String bodyTypeCds[]	= request.getParameterValues("typeOfBody");		
		String unladenWts[]		= request.getParameterValues("unladenWt");	//HIDDEN*
		String makeCds[]		= request.getParameterValues("makeCd");			
		String engineSeries[]	= request.getParameterValues("engineSeries");
		String basicColors[]	= request.getParameterValues("basicColor");		
		String colorCds[]		= request.getParameterValues("colorCd");
		String origins[]		= request.getParameterValues("origin");			
		String destinations[]	= request.getParameterValues("destination");
		String deductibles[]	= request.getParameterValues("deductibles");	//HIDDEN
		
		try {
			for (int i = 0; i < plateNos.length; i++){
				gipiQuoteItemMC = new GIPIQuoteItemMC();				
				gipiQuoteItemMC.setQuoteId(quoteId);
				gipiQuoteItemMC.setItemNo(Integer.parseInt(itemNos[i]));
				gipiQuoteItemMC.setPlateNo(plateNos[i]);
				gipiQuoteItemMC.setMotorNo(motorNos[i]);
				gipiQuoteItemMC.setSerialNo(serialNos[i]);
				gipiQuoteItemMC.setSublineTypeCd(sublineTypeCds[i]);
				
				{ 	int motType = Integer.parseInt(motorTypes[i].equals("") ? "0" : motorTypes[i]);
					if(motType!=0)
						gipiQuoteItemMC.setMotType(motType);
					int carCompCd = Integer.parseInt(carCompanies[i].equals("")? "0": carCompanies[i]);
					if(carCompCd!=0)
						gipiQuoteItemMC.setCarCompanyCd(carCompCd);
				}
				gipiQuoteItemMC.setCocYy(Integer.parseInt(cocYys[i].equals("")? "0": cocYys[i]));
				gipiQuoteItemMC.setCocSeqNo(null);
				gipiQuoteItemMC.setCocSerialNo(Integer.parseInt(cocSerialNos[i].equals("")? "0": cocSerialNos[i]));
				gipiQuoteItemMC.setCocType(cocTypes[i]);
				gipiQuoteItemMC.setRepairLim(new BigDecimal(repairLimits[i].equals("") ? "0": repairLimits[i].replaceAll(",", "")));
				gipiQuoteItemMC.setBasicColorCd(basicColors[i]);
				gipiQuoteItemMC.setModelYear(modelYears[i]);
				gipiQuoteItemMC.setMake(makeCds[i]);
				gipiQuoteItemMC.setEstValue(new BigDecimal(0)); //**
				gipiQuoteItemMC.setTowing(new BigDecimal(towLimits[i].equals("") ? "0.00" : towLimits[i].replaceAll(",", "")));
				gipiQuoteItemMC.setAssignee(assignees[i]);
				gipiQuoteItemMC.setNoOfPass(Integer.parseInt(noOfPassengers[i].equals("")? "0" : noOfPassengers[i]));
				gipiQuoteItemMC.setCocIssueDate(null);
				gipiQuoteItemMC.setMvFileNo(mvFilesNos[i]);
				gipiQuoteItemMC.setAcquiredFrom(acquirees[i]);
				gipiQuoteItemMC.setCtvTag(ctvTags[i].equals("Y")? "Y" : "N");
				gipiQuoteItemMC.setTypeOfBodyCd(Integer.parseInt(bodyTypeCds[i].equals("")? "0": bodyTypeCds[i]));
				gipiQuoteItemMC.setUnladenWt(unladenWts[i]);
				gipiQuoteItemMC.setMakeCd(Integer.parseInt(makeCds[i].equals("")? "0": makeCds[i]));
				gipiQuoteItemMC.setSeriesCd(Integer.parseInt(engineSeries[i].equals("") ? "0" : engineSeries[i]));
				gipiQuoteItemMC.setColorCd(Integer.parseInt(colorCds[i].equals("")? "0": colorCds[i]));
				gipiQuoteItemMC.setOrigin(origins[i]);
				gipiQuoteItemMC.setDestination(destinations[i]);
				gipiQuoteItemMC.setUserId(userId);
				gipiQuoteItemMC.setLastUpdate(new Date());
				gipiQuoteItemMC.setSublineCd(subLineCd);
				gipiQuoteItemMC.setDeductibleAmt(new BigDecimal(deductibles[i].equals("")? "0": deductibles[i])); // handle numberformat in javascript
				this.saveGIPIQuoteItemMC(gipiQuoteItemMC);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#getDefaultTow(java.lang.String)
	 */
	@Override
	public int getDefaultTow(String subline) throws SQLException {
		return this.getGipiQuoteItemMCDAO().getDefaultTow(subline);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#prepareAdditionalInformationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> prepareAdditionalInformationParams(
			HttpServletRequest request, GIPIQuote gipiQuote) {
		
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
//		List<GIPIQuoteItemMC> additionalInformationList = new ArrayList<GIPIQuoteItemMC>();
		
		GIPIQuoteItemMC gipiQuoteItemMC = null;
		int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
		
		String itemNos[]		= request.getParameterValues("aiItemNo");
		String plateNos[]		= request.getParameterValues("plateNo");
		String motorNos[]		= request.getParameterValues("motorNo");
		String serialNos[] 		= request.getParameterValues("serialNo");
		String sublineTypeCds[] = request.getParameterValues("sublineType");
		String motorTypes[] 	= request.getParameterValues("motorType");
		String carCompanies[]	= request.getParameterValues("carCompany");
		String cocYys[]			= request.getParameterValues("cocYy");
		String cocSerialNos[]	= request.getParameterValues("cocSerialNo");
		String cocTypes[]		= request.getParameterValues("cocType");
		String repairLimits[]	= request.getParameterValues("repairLimit");	
		String modelYears[]		= request.getParameterValues("modelYear");
		String towLimits[]		= request.getParameterValues("towLimit");
		String noOfPassengers[]	= request.getParameterValues("noOfPass");
		String mvFilesNos[]		= request.getParameterValues("mvFileNo");	
		String acquirees[]		= request.getParameterValues("acquiredFrom");
		String assignees[]		= request.getParameterValues("assignee");
		String ctvTags[]		= request.getParameterValues("ctvTag");
		String bodyTypeCds[]	= request.getParameterValues("typeOfBody");	
		String unladenWts[]		= request.getParameterValues("unladenWt");
		String makeCds[]		= request.getParameterValues("makeCd");	
		String engineSeries[]	= request.getParameterValues("engineSeries");
		String basicColors[]	= request.getParameterValues("basicColor");
		String colorCds[]		= request.getParameterValues("colorCd");
		String origins[]		= request.getParameterValues("origin");	
		String destinations[]	= request.getParameterValues("destination");
		String deductibles[]	= request.getParameterValues("deductibles");
		
		try {
			for (int i = 0; i < plateNos.length; i++){
				gipiQuoteItemMC = new GIPIQuoteItemMC();				
				gipiQuoteItemMC.setQuoteId(quoteId);
				gipiQuoteItemMC.setItemNo(Integer.parseInt(itemNos[i]));
				gipiQuoteItemMC.setPlateNo(plateNos[i]);
				gipiQuoteItemMC.setMotorNo(motorNos[i]);
				gipiQuoteItemMC.setSerialNo(serialNos[i]);
				gipiQuoteItemMC.setSublineTypeCd(sublineTypeCds[i]);
				
				{ 	int motType = Integer.parseInt(motorTypes[i].equals("") ? "0" : motorTypes[i]);
					if(motType!=0)
						gipiQuoteItemMC.setMotType(motType);
					int carCompCd = Integer.parseInt(carCompanies[i].equals("")? "0": carCompanies[i]);
					if(carCompCd!=0)
						gipiQuoteItemMC.setCarCompanyCd(carCompCd);
				}
				gipiQuoteItemMC.setCocYy(Integer.parseInt(cocYys[i].equals("")? "0": cocYys[i]));
				gipiQuoteItemMC.setCocSeqNo(null);
				gipiQuoteItemMC.setCocSerialNo(Integer.parseInt(cocSerialNos[i].equals("")? "0": cocSerialNos[i]));
				gipiQuoteItemMC.setCocType(cocTypes[i]);
				gipiQuoteItemMC.setRepairLim(new BigDecimal(repairLimits[i].equals("") ? "0": repairLimits[i].replaceAll(",", "")));
				gipiQuoteItemMC.setBasicColorCd(basicColors[i]);
				gipiQuoteItemMC.setModelYear(modelYears[i]);
				gipiQuoteItemMC.setMake(makeCds[i]);
				gipiQuoteItemMC.setEstValue(new BigDecimal(0));
				gipiQuoteItemMC.setTowing(new BigDecimal(towLimits[i].equals("") ? "0.00" : towLimits[i].replaceAll(",", "")));
				gipiQuoteItemMC.setAssignee(assignees[i]);
				gipiQuoteItemMC.setNoOfPass(Integer.parseInt(noOfPassengers[i].equals("")? "0" : noOfPassengers[i]));
				gipiQuoteItemMC.setCocIssueDate(null);
				gipiQuoteItemMC.setMvFileNo(mvFilesNos[i]);
				gipiQuoteItemMC.setAcquiredFrom(acquirees[i]);
				gipiQuoteItemMC.setCtvTag(ctvTags[i].equals("Y")? "Y" : "N");
				gipiQuoteItemMC.setTypeOfBodyCd(Integer.parseInt(bodyTypeCds[i].equals("")? "0": bodyTypeCds[i]));
				gipiQuoteItemMC.setUnladenWt(unladenWts[i]);
				gipiQuoteItemMC.setMakeCd(Integer.parseInt(makeCds[i].equals("")? "0": makeCds[i]));
				gipiQuoteItemMC.setSeriesCd(Integer.parseInt(engineSeries[i].equals("") ? "0" : engineSeries[i]));
				gipiQuoteItemMC.setColorCd(Integer.parseInt(colorCds[i].equals("")? "0": colorCds[i]));
				gipiQuoteItemMC.setOrigin(origins[i]);
				gipiQuoteItemMC.setDestination(destinations[i]);
				gipiQuoteItemMC.setUserId(gipiQuote.getUserId());
				gipiQuoteItemMC.setLastUpdate(new Date());
				gipiQuoteItemMC.setSublineCd(gipiQuote.getSublineCd());
				gipiQuoteItemMC.setDeductibleAmt(new BigDecimal(deductibles[i].equals("")? "0": deductibles[i])); // handle numberformat in javascript
//				additionalInformationList.add(gipiQuoteItemMC);
				additionalInformationParams.put("additionalInformation" + itemNos[i], gipiQuoteItemMC);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
//		additionalInformationParams.put("additionalInformationList", additionalInformationList);
		return additionalInformationParams;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemMCService#prepareMarineCargoInformation(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteItemMC> prepareMotorCarInformation(JSONArray setRows)
			throws JSONException, ParseException {
		List<GIPIQuoteItemMC> vehicleList = new ArrayList<GIPIQuoteItemMC>();
		GIPIQuoteItemMC vehicle = null;
		JSONObject objItem = null;
		JSONObject objVehicle = null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		System.out.println("adfkjasdf;adsf'jadsf;j-------------------a"+setRows.length() );
		for(int i=0, length=setRows.length(); i < length; i++){
			vehicle = new GIPIQuoteItemMC();
			objItem = setRows.getJSONObject(i);
			objVehicle = objItem.isNull("gipiQuoteItemMC") ? null : objItem.getJSONObject("gipiQuoteItemMC");
			
			if(objVehicle != null){
				vehicle.setQuoteId(objItem.isNull("quoteId") ? null : objItem.getInt("quoteId"));
				vehicle.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
//				vehicle.setAssignee(objVehicle.isNull("assignee") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("assignee")));
//				vehicle.setAcquiredFrom(objVehicle.isNull("acquiredFrom") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("acquiredFrom")));
//				vehicle.setMotorNo(objVehicle.isNull("motorNo") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("motorNo")));
//				vehicle.setOrigin(objVehicle.isNull("origin") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("origin")));
//				vehicle.setDestination(objVehicle.isNull("destination") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("destination")));
				vehicle.setAssignee(objVehicle.isNull("assignee") ? null : objVehicle.getString("assignee"));
				vehicle.setAcquiredFrom(objVehicle.isNull("acquiredFrom") ? null : objVehicle.getString("acquiredFrom"));
				vehicle.setMotorNo(objVehicle.isNull("motorNo") ? null : objVehicle.getString("motorNo"));
				vehicle.setOrigin(objVehicle.isNull("origin") ? null : objVehicle.getString("origin"));
				vehicle.setDestination(objVehicle.isNull("destination") ? null : objVehicle.getString("destination"));
				vehicle.setTypeOfBodyCd(objVehicle.isNull("typeOfBodyCd") ? null : objVehicle.getInt("typeOfBodyCd"));
				vehicle.setPlateNo(objVehicle.isNull("plateNo") ? null : objVehicle.getString("plateNo"));
				vehicle.setModelYear(objVehicle.isNull("modelYear") ? null : objVehicle.getString("modelYear"));
				vehicle.setCarCompanyCd(objVehicle.isNull("carCompanyCd") ? null : objVehicle.getInt("carCompanyCd"));
				vehicle.setMvFileNo(objVehicle.isNull("mvFileNo") ? null : objVehicle.getString("mvFileNo"));
				vehicle.setNoOfPass(objVehicle.isNull("noOfPass") ? null : objVehicle.getInt("noOfPass"));
				vehicle.setMakeCd(objVehicle.isNull("makeCd") ? null : objVehicle.getInt("makeCd"));
				vehicle.setBasicColorCd(objVehicle.isNull("basicColorCd") ? null : objVehicle.getString("basicColorCd"));
				vehicle.setColorCd(objVehicle.isNull("colorCd") ? null : objVehicle.getInt("colorCd"));
				vehicle.setSeriesCd(objVehicle.isNull("seriesCd") ? null : objVehicle.getInt("seriesCd"));
				vehicle.setMotType(objVehicle.isNull("motType") || objVehicle.getString("motType").equals("") ? null : objVehicle.getInt("motType"));
				vehicle.setUnladenWt(objVehicle.isNull("unladenWt") ? null : objVehicle.getString("unladenWt"));
				vehicle.setTowing(objVehicle.isNull("towing") ? null : new BigDecimal(objVehicle.getString("towing").replaceAll(",", "")));
				vehicle.setSerialNo(objVehicle.isNull("serialNo") ? null : objVehicle.getString("serialNo"));
				vehicle.setSublineTypeCd(objVehicle.isNull("sublineTypeCd") ? null : objVehicle.getString("sublineTypeCd"));
				vehicle.setCocType(objVehicle.isNull("cocType") ? null : objVehicle.getString("cocType"));
				vehicle.setCocSerialNo(objVehicle.isNull("cocSerialNo") ? null : objVehicle.getInt("cocSerialNo"));
				vehicle.setCocYy(objVehicle.isNull("cocYy") ? null : objVehicle.getInt("cocYy"));
				vehicle.setCtvTag(objVehicle.isNull("ctvTag") ? null : objVehicle.getString("ctvTag"));
				vehicle.setRepairLim(objVehicle.isNull("repairLim") ? null : new BigDecimal(objVehicle.getString("repairLim").replaceAll(",", "")));
				
				//vehicle.setMotorCoverage(objVehicle.isNull("motorCoverage") ? null : objVehicle.getString("motorCoverage"));
				vehicle.setSublineCd(objVehicle.isNull("sublineCd") ? null : objVehicle.getString("sublineCd"));
				//vehicle.setCocSerialSw(objVehicle.isNull("cocSerialSw") ? null : objVehicle.getString("cocSerialSw"));
			
				vehicle.setEstValue(objVehicle.isNull("estValue") ? null : new BigDecimal(objVehicle.getString("estValue")));
				vehicle.setTariffZone(objVehicle.isNull("tariffZone") ? null : objVehicle.getString("tariffZone"));
				vehicle.setCocIssueDate(objVehicle.isNull("cocIssueDate") ? null : sdf.parse(objVehicle.getString("cocIssueDate")));
				vehicle.setCocSeqNo(objVehicle.isNull("cocSeqNo") ? null : objVehicle.getInt("cocSeqNo"));
				vehicle.setCocAtcn(objVehicle.isNull("cocAtcn") ? null : objVehicle.getString("cocAtcn"));
				vehicle.setMake(objVehicle.isNull("make") ? null : objVehicle.getString("make"));
				vehicle.setColor(objVehicle.isNull("color") ? null : objVehicle.getString("color"));
				
				vehicleList.add(vehicle);
				vehicle = null;				
			}			
		}
		
		return vehicleList;
		
/*		List<GIPIQuoteItemMC> mcList = new ArrayList<GIPIQuoteItemMC>();
		GIPIQuoteItemMC mc = null;
		for(int index = 0; index<rows.length();index++){
			mc = new GIPIQuoteItemMC();
			mc.setQuoteId(rows.getJSONObject(index).isNull("quoteId")?0:rows.getJSONObject(index).getInt("quoteId"));
			mc.setItemNo(rows.getJSONObject(index).isNull("itemNo")?0:rows.getJSONObject(index).getInt("itemNo"));
			mc.setPlateNo(rows.getJSONObject(index).isNull("plateNo")?"":rows.getJSONObject(index).getString("plateNo"));
			mc.setMotorNo(rows.getJSONObject(index).isNull("motorNo")?"":rows.getJSONObject(index).getString("motorNo"));
			mc.setSerialNo(rows.getJSONObject(index).isNull("serialNo")?"":rows.getJSONObject(index).getString("serialNo"));
			mc.setSublineCd(rows.getJSONObject(index).isNull("sublineCd")?"":rows.getJSONObject(index).getString("sublineCd"));
			mc.setSublineTypeCd(rows.getJSONObject(index).isNull("sublineTypeCd")?"":rows.getJSONObject(index).getString("sublineTypeCd"));
			mc.setMotType(rows.getJSONObject(index).isNull("motType")?0:rows.getJSONObject(index).getInt("motType"));
			mc.setCarCompanyCd(rows.getJSONObject(index).isNull("carCompCd")?0:rows.getJSONObject(index).getInt("carCompCd"));
			mc.setCocYy(rows.getJSONObject(index).isNull("cocYy")?0:rows.getJSONObject(index).getInt("cocYy"));
			mc.setCocSeqNo(rows.getJSONObject(index).isNull("cocSeqNo")?0:rows.getJSONObject(index).getInt("cocSeqNo"));
			mc.setCocSerialNo(rows.getJSONObject(index).isNull("cocSerialNo")?0:rows.getJSONObject(index).getInt("cocSerialNo"));
			mc.setCocType(rows.getJSONObject(index).isNull("cocType")?"":rows.getJSONObject(index).getString("cocType"));
			mc.setCocIssueDate(null);
			mc.setRepairLim(rows.getJSONObject(index).isNull("repairLim")?new BigDecimal(0):new BigDecimal(rows.getJSONObject(index).getDouble("repairLim")));
			mc.setBasicColorCd(rows.getJSONObject(index).isNull("basicColorCd")?"":rows.getJSONObject(index).getString("basicColorCd"));
			mc.setModelYear(rows.getJSONObject(index).isNull("modelYear")?"":rows.getJSONObject(index).getString("modelYear"));
			mc.setMake(rows.getJSONObject(index).isNull("make")?"":rows.getJSONObject(index).getString("make"));
			mc.setMakeCd(rows.getJSONObject(index).isNull("makeCd")?0:rows.getJSONObject(index).getInt("makeCd"));
			mc.setEstValue(rows.getJSONObject(index).isNull("estValue")? new BigDecimal(0): new BigDecimal(rows.getJSONObject(index).getDouble("estValue")));
			mc.setTowing(rows.getJSONObject(index).isNull("towing")? new BigDecimal(0): new BigDecimal(rows.getJSONObject(index).getString("towing")));
			mc.setAssignee(rows.getJSONObject(index).isNull("assignee")?"":rows.getJSONObject(index).getString("assignee"));
			mc.setNoOfPass(rows.getJSONObject(index).isNull("noOfPass")?0:rows.getJSONObject(index).getInt("noOfPass"));
			mc.setMvFileNo(rows.getJSONObject(index).isNull("mvFileNo")?"":rows.getJSONObject(index).getString("mvFileNo"));
			mc.setAcquiredFrom(rows.getJSONObject(index).isNull("acquiredFrom")?"":rows.getJSONObject(index).getString("acquiredFrom"));
			mc.setCtvTag(rows.getJSONObject(index).isNull("ctvTag")?"":rows.getJSONObject(index).getString("ctvTag"));
			mc.setTypeOfBodyCd(rows.getJSONObject(index).isNull("typeOfBodyCd")?0:rows.getJSONObject(index).getInt("typeOfBodyCd"));
			mc.setUnladenWt(rows.getJSONObject(index).isNull("unladenWt")?"":rows.getJSONObject(index).getString("unladenWt"));
			mc.setSeriesCd(rows.getJSONObject(index).isNull("seriesCd")?0:rows.getJSONObject(index).getInt("seriesCd"));
			mc.setColorCd(rows.getJSONObject(index).isNull("colorCd")?0:rows.getJSONObject(index).getInt("colorCd"));
			mc.setOrigin(rows.getJSONObject(index).isNull("origin")?"":rows.getJSONObject(index).getString("origin"));
			mc.setDestination(rows.getJSONObject(index).isNull("destination")?"":rows.getJSONObject(index).getString("destination"));
			mc.setUserId(rows.getJSONObject(index).isNull("userId")?"":rows.getJSONObject(index).getString("userId"));
			mc.setLastUpdate(new Date());
			mc.setDeductibleAmt(rows.getJSONObject(index).isNull("deductibleAmt")? new BigDecimal(0):new BigDecimal(rows.getJSONObject(index).getString("deductibleAmt")));
			mcList.add(mc);
		}
		return mcList;*/
	}

	@Override
	public void loadListingToRequest(HttpServletRequest request,
			LOVHelper lovHelper, GIPIQuote gipiQuote) {
		//String[] covs = {null, null};
		//String[] groupParam = {Integer.toString(gipiQuote.getAssdNo())};
		String[] motorTypeParam = {gipiQuote.getSublineCd()};
		String[] cgRefCodes = {"GIPI_VEHICLE.MOTOR_COVERAGE"};
		
		//request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		//request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, covs));
		//request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		//request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));		
		request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));
		//request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));
		//request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_LISTING_BY_SUBLINE1, motorTypeParam));
		request.setAttribute("basicColors", lovHelper.getList(LOVHelper.MC_BASIC_COLOR_LISTING));
		request.setAttribute("colors", lovHelper.getList(LOVHelper.MC_ALL_COLOR));
		//request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_LISTING_BY_SUBLINE, motorTypeParam));
		request.setAttribute("motorTypes", lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING, motorTypeParam));
		request.setAttribute("sublineTypes", lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING, motorTypeParam));
		request.setAttribute("motorCoverages", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, cgRefCodes));		
		request.setAttribute("accessoryListing", lovHelper.getList(LOVHelper.ACCESSORY_LISTING)); // accessory		
	}

}
