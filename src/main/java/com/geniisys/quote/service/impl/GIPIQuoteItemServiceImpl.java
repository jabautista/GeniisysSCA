package com.geniisys.quote.service.impl;

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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.quote.dao.GIPIQuoteItemDAO;
import com.geniisys.quote.entity.GIPIDeductibles;
import com.geniisys.quote.entity.GIPIQuoteACItem;
import com.geniisys.quote.entity.GIPIQuoteAVItem;
import com.geniisys.quote.entity.GIPIQuoteCAItem;
import com.geniisys.quote.entity.GIPIQuoteCargo;
import com.geniisys.quote.entity.GIPIQuoteENItem;
import com.geniisys.quote.entity.GIPIQuoteFIItem;
import com.geniisys.quote.entity.GIPIQuoteItem;
import com.geniisys.quote.entity.GIPIQuoteItemMC;
import com.geniisys.quote.entity.GIPIQuoteItmmortgagee;
import com.geniisys.quote.entity.GIPIQuoteItmperil;
import com.geniisys.quote.entity.GIPIQuoteMHItem;
import com.geniisys.quote.entity.GIPIQuoteWc;
import com.geniisys.quote.service.GIPIQuoteItemService;

public class GIPIQuoteItemServiceImpl implements GIPIQuoteItemService{
	
	private GIPIQuoteItemDAO gipiQuoteItemDAO2;

	public GIPIQuoteItemDAO getGipiQuoteItemDAO2() {
		return gipiQuoteItemDAO2;
	}

	public void setGipiQuoteItemDAO2(GIPIQuoteItemDAO gipiQuoteItemDAO2) {
		this.gipiQuoteItemDAO2 = gipiQuoteItemDAO2;
	}

	@Override
	public void saveAllQuotationInformation(HttpServletRequest request,
			String userId) throws SQLException, JSONException, ParseException {
		
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		String lineCd = request.getParameter("lineCd");
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItemRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setItemRows")), userId, GIPIQuoteItem.class));
		params.put("newItemRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("newItemRows")), userId, GIPIQuoteItem.class));
		params.put("delItemRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delItemRows")), userId, GIPIQuoteItem.class));
		params.put("setPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setPerilRows")), userId, GIPIQuoteItmperil.class));
		params.put("delPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delPerilRows")), userId, GIPIQuoteItmperil.class));
		params.put("setMortgageeRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setMortgageeRows")), userId, GIPIQuoteItmmortgagee.class));
		params.put("delMortgageeRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delMortgageeRows")), userId, GIPIQuoteItmmortgagee.class));
		params.put("setWarrantyRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setWarrantyRows")), userId, GIPIQuoteWc.class));
		params.put("setDeductibleRows" , JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setDeductibleRows")), userId, GIPIDeductibles.class));
		params.put("delDeductibleRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delDeductibleRows")), userId, GIPIDeductibles.class));
		
		//item/peril deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		params.put("setItemDeductibleRows" , JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setItemDeductibleRows")), userId, GIPIQuoteDeductibles.class));
		params.put("delItemDeductibleRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delItemDeductibleRows")), userId, GIPIQuoteDeductibles.class));
		params.put("setPerilDeductibleRows" , JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setPerilDeductibleRows")), userId, GIPIQuoteDeductibles.class));
		params.put("delPerilDeductibleRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delPerilDeductibleRows")), userId, GIPIQuoteDeductibles.class));
		
		String delPolicyLevel = request.getParameter("delPolicyLevel");
		Integer quoteId = Integer.parseInt((String)request.getParameter("quoteId"));
		
		params.put("delPolicyLevel", delPolicyLevel);
		params.put("quoteId", quoteId);
		//nieko end
		
		params.put("lineCd", lineCd);
		params.put("addtlInfo", paramsObj.getString("addtlInfo")); //robert 9.28.2012
		params.put("userId", userId);
		params.put("setAIRows", prepareAdditionalInformationJSON(lineCd, request, userId));		
		this.getGipiQuoteItemDAO2().saveAllQuotationInformation(params);
	}
	
	private List<?> prepareAdditionalInformationJSON(String lineCd, HttpServletRequest request, String userId)
			throws JSONException, ParseException {
		List<?> aiList = null;
		JSONObject objParam = new JSONObject(request.getParameter("parameters"));
		
		if(lineCd.equals("AV")){
			aiList = prepareAVAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);
		}else if(lineCd.equals("CA")){
			aiList = prepareCAAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}else if(lineCd.equals("EN")){
			aiList = prepareENAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}else if(lineCd.equals("MH")){
			aiList = prepareMHAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}else if(lineCd.equals("MN")){
			aiList = prepareMNAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}else if(lineCd.equals("AC") || lineCd.equals("PA")){
			aiList = prepareACAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}else if(lineCd.equals("MC")){
			aiList = prepareMCAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}else if(lineCd.equals("FI")){
			aiList = prepareFIAddlInfoJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), userId);	
		}
		return aiList;
	}
	
	private List<GIPIQuoteAVItem> prepareAVAddlInfoJSON(JSONArray rows, String userId)
			throws JSONException {
		List<GIPIQuoteAVItem> avList = new ArrayList<GIPIQuoteAVItem>();
		GIPIQuoteAVItem av = null;
		JSONObject objAV = null;
		
		for(int index=0; index<rows.length(); index++){ // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
			av = new GIPIQuoteAVItem();
			objAV = (rows.getJSONObject(index).isNull("gipiQuoteAVItem")) ? null : rows.getJSONObject(index).getJSONObject("gipiQuoteAVItem");
			
			if (objAV != null) {
				av.setQuoteId(objAV.isNull("quoteId")?0:objAV.getInt("quoteId"));
				av.setItemNo(objAV.isNull("itemNo")?0:objAV.getInt("itemNo"));
				av.setVesselCd(objAV.isNull("vesselCd")?"": StringEscapeUtils.unescapeHtml(objAV.getString("vesselCd")));
				av.setPurpose(objAV.isNull("purpose")?"": StringEscapeUtils.unescapeHtml(objAV.getString("purpose")));
				av.setDeductText(objAV.isNull("deductText")?"": StringEscapeUtils.unescapeHtml(objAV.getString("deductText")));
				av.setPrevUtilHrs(objAV.isNull("prevUtilHrs")?null:objAV.getInt("prevUtilHrs"));
				av.setEstUtilHrs(objAV.isNull("estUtilHrs")?null:objAV.getInt("estUtilHrs"));
				av.setTotalFlyTime(objAV.isNull("totalFlyTime")?null:objAV.getInt("totalFlyTime"));
				av.setQualification(objAV.isNull("qualification")?"": StringEscapeUtils.unescapeHtml(objAV.getString("qualification")));
				av.setGeogLimit(objAV.isNull("geogLimit")?"": StringEscapeUtils.unescapeHtml(objAV.getString("geogLimit")));
				av.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				av.setUserId(userId);
				avList.add(av);
			}
		}
		return avList;
	}
	
	private List<GIPIQuoteCAItem> prepareCAAddlInfoJSON(JSONArray rows, String userId)
			throws JSONException {
		List<GIPIQuoteCAItem> caList = new ArrayList<GIPIQuoteCAItem>();
		GIPIQuoteCAItem ca = null;
		JSONObject objItem = null;
		JSONObject objCA = null;
		
		for(int index = 0; index<rows.length(); index++){  // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
			ca = new GIPIQuoteCAItem();
			objItem = rows.getJSONObject(index);
			objCA = objItem.isNull("gipiQuoteCAItem") ? null : objItem.getJSONObject("gipiQuoteCAItem");
			if(objCA != null){
				ca.setQuoteId(objItem.isNull("quoteId") ? null : objItem.getInt("quoteId"));
				ca.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				ca.setSectionLineCd(objCA.isNull("sectionLineCd") ? null : StringEscapeUtils.unescapeHtml(objCA.getString("sectionLineCd")));
				ca.setSectionSublineCd(objCA.isNull("sectionSublineCd") ? null : StringEscapeUtils.unescapeHtml(objCA.getString("sectionSublineCd")));
				ca.setLocation(objCA.isNull("location") ? null : StringEscapeUtils.unescapeHtml(objCA.getString("location")));
				ca.setSectionOrHazardCd(objCA.isNull("sectionOrHazardCd") ? null : StringEscapeUtils.unescapeHtml(objCA.getString("sectionOrHazardCd")));
				ca.setCapacityCd(objCA.isNull("capacityCd") ? null : Integer.parseInt(objCA.getString("capacityCd")));
				ca.setLimitOfLiability(objCA.isNull("limitOfLiability") ? null : StringEscapeUtils.unescapeHtml(objCA.getString("limitOfLiability")));
				ca.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				ca.setUserId(userId);
				caList.add(ca);
			}
		}
		return caList;
	}
	
	private List<GIPIQuoteENItem> prepareENAddlInfoJSON(JSONArray rows, String userId)
			throws JSONException, ParseException {
		List<GIPIQuoteENItem> enList = new ArrayList<GIPIQuoteENItem>();
		GIPIQuoteENItem en = null;
		JSONObject objItem = null;
		JSONObject enObj = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int index = 0; index<rows.length(); index++){  // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
			en = new GIPIQuoteENItem();
			objItem = rows.getJSONObject(index);
			enObj = objItem.isNull("gipiQuoteENItem") ? null : objItem.getJSONObject("gipiQuoteENItem");
			
			if(enObj != null) {
				en.setQuoteId(enObj.isNull("quoteId")? 0 :enObj.getInt("quoteId"));
				en.setEnggBasicInfonum(enObj.isNull("enggBasicInfonum")? 1 :enObj.getInt("enggBasicInfonum"));
				en.setContractProjBussTitle(enObj.isNull("contractProjBussTitle")?"": StringEscapeUtils.unescapeHtml(enObj.getString("contractProjBussTitle")));
				en.setSiteLocation(enObj.isNull("siteLocation")?"": StringEscapeUtils.unescapeHtml(enObj.getString("siteLocation")));
				en.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				en.setUserId(userId);
				
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
			}
			enList.add(en);
		}
		return enList;
	}
	
	private List<GIPIQuoteMHItem> prepareMHAddlInfoJSON(JSONArray rows, String userId)
			throws JSONException, ParseException {
		List<GIPIQuoteMHItem> mhList = new ArrayList<GIPIQuoteMHItem>();
		GIPIQuoteMHItem mh = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject objItem1 = null;
		for(int index=0; index<rows.length();index++){ // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
			mh = new GIPIQuoteMHItem();
			objItem1 = rows.getJSONObject(index);
			if (!objItem1.isNull("gipiQuoteMHItem")){
				JSONObject objItem = new JSONObject(objItem1.getString("gipiQuoteMHItem"));
				
				mh.setQuoteId(objItem.isNull("quoteId")? 0: objItem.getInt("quoteId"));
				mh.setItemNo(objItem.isNull("itemNo")? 0: objItem.getInt("itemNo"));
				mh.setGeogLimit(objItem.isNull("geogLimit")? "": StringEscapeUtils.unescapeHtml(objItem.getString("geogLimit")));
				mh.setDryPlace(objItem.isNull("dryPlace")? "": StringEscapeUtils.unescapeHtml(objItem.getString("dryPlace")));
				mh.setVesselCd(objItem.isNull("vesselCd")? "": StringEscapeUtils.unescapeHtml(objItem.getString("vesselCd")));
				mh.setDeductText(objItem.isNull("deductText")? "": StringEscapeUtils.unescapeHtml(objItem.getString("deductText")));
				mh.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				mh.setUserId(userId);
				
				if(!(objItem.isNull("dryDate"))){
					mh.setDryDate(df.parse(objItem.getString("dryDate")));
				}
				mhList.add(mh);
			}
		}
		return mhList;
	}
	
	private List<GIPIQuoteCargo> prepareMNAddlInfoJSON(JSONArray rows, String userId)
			throws JSONException, ParseException {
		List<GIPIQuoteCargo> mnList = new ArrayList<GIPIQuoteCargo>();
		GIPIQuoteCargo mn = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject objMN = null;
		JSONObject objItem = null;
		
		for(int index = 0; index<rows.length(); index++){ // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
			mn = new GIPIQuoteCargo();
			objItem = rows.getJSONObject(index);
			
			objMN = objItem.isNull("gipiQuoteMNItem") ? null : objItem.getJSONObject("gipiQuoteMNItem");
			if (objMN != null){
				mn.setQuoteId(objMN.isNull("quoteId")?0:objMN.getInt("quoteId"));
				mn.setItemNo(objMN.isNull("itemNo")?0:objMN.getInt("itemNo"));
				mn.setGeogCd(objMN.isNull("geogCd")||"".equals(objMN.getString("geogCd"))?0:objMN.getInt("geogCd"));
				mn.setVesselCd(objMN.isNull("vesselCd")||"".equals(objMN.getString("vesselCd"))?"":StringEscapeUtils.unescapeHtml(objMN.getString("vesselCd")));
				mn.setCargoClassCd(objMN.isNull("cargoClassCd")||"".equals(objMN.getString("cargoClassCd"))?/*0*/ null :objMN.getInt("cargoClassCd"));
				mn.setCargoType(objMN.isNull("cargoType")||"".equals(objMN.getString("cargoType"))?"":StringEscapeUtils.unescapeHtml(objMN.getString("cargoType")));
				mn.setPackMethod(objMN.isNull("packMethod")?"": StringEscapeUtils.unescapeHtml(objMN.getString("packMethod")));
				mn.setBlAwb(objMN.isNull("blAwb")?"": StringEscapeUtils.unescapeHtml(objMN.getString("blAwb")));
				mn.setTranshipOrigin(objMN.isNull("transhipOrigin")?"": StringEscapeUtils.unescapeHtml(objMN.getString("transhipOrigin")));
				mn.setTranshipDestination(objMN.isNull("transhipDestination")?"": StringEscapeUtils.unescapeHtml(objMN.getString("transhipDestination")));
				mn.setVoyageNo(objMN.isNull("voyageNo")?"": StringEscapeUtils.unescapeHtml(objMN.getString("voyageNo")));
				mn.setLcNo(objMN.isNull("lcNo")?"": StringEscapeUtils.unescapeHtml(objMN.getString("lcNo")));
				mn.setPrintTag(objMN.isNull("printTag")||"".equals(objMN.getString("printTag"))?0:objMN.getInt("printTag"));
				mn.setOrigin(objMN.isNull("origin")?"": StringEscapeUtils.unescapeHtml(objMN.getString("origin")));
				mn.setDestn(objMN.isNull("destn")?"": StringEscapeUtils.unescapeHtml(objMN.getString("destn")));
				mn.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				mn.setUserId(userId);
				
				if(!objMN.isNull("etd")){
					mn.setEtd(df.parse(objMN.getString("etd")));
				}
				if(!objMN.isNull("eta")){
					mn.setEta(df.parse(objMN.getString("eta")));
				}
				mnList.add(mn);
				mn = null;
			}
		}
		return mnList;
	}
	
	private List<GIPIQuoteACItem> prepareACAddlInfoJSON(JSONArray rows, String userId) throws JSONException, ParseException {
		List<GIPIQuoteACItem> acInfoList = new ArrayList<GIPIQuoteACItem>();
		GIPIQuoteACItem ac = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject objAH = null;
		JSONObject objItem = null;		
		
		for(int index=0, length=rows.length(); index < length; index++){ // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
			ac = new GIPIQuoteACItem();
			objItem = rows.getJSONObject(index);
			
			objAH = objItem.isNull("gipiQuoteACItem") ? null : objItem.getJSONObject("gipiQuoteACItem");
			if(objAH != null){
				ac.setQuoteId(objAH.isNull("quoteId")?0:objAH.getInt("quoteId"));
				ac.setItemNo(objAH.isNull("itemNo")?0:objAH.getInt("itemNo"));
				ac.setNoOfPersons(objAH.isNull("noOfPersons")?null:objAH.getInt("noOfPersons"));
				ac.setPositionCd(objAH.isNull("positionCd")?null:objAH.getInt("positionCd"));
				ac.setDestination(objAH.isNull("destination")?"": StringEscapeUtils.unescapeHtml(objAH.getString("destination")));
				ac.setMonthlySalary(objAH.isNull("monthlySalary") || "".equals(objAH.getString("monthlySalary"))?null: new BigDecimal(objAH.getString("monthlySalary").replaceAll(",", "")));
				ac.setSalaryGrade(objAH.isNull("salaryGrade")?"": StringEscapeUtils.unescapeHtml(objAH.getString("salaryGrade")));
				if(!objAH.isNull("dateOfBirth")){
					ac.setDateOfBirth(df.parse(objAH.getString("dateOfBirth")));
				}
				ac.setCivilStatus(objAH.isNull("civilStatus")? "": StringEscapeUtils.unescapeHtml(objAH.getString("civilStatus")));
				ac.setAge(objAH.isNull("age")?null:objAH.getInt("age"));
				ac.setWeight(objAH.isNull("weight")? "": StringEscapeUtils.unescapeHtml(objAH.getString("weight")));
				ac.setHeight(objAH.isNull("height")? "": StringEscapeUtils.unescapeHtml(objAH.getString("height")));
				ac.setSex(objAH.isNull("sex")? "": StringEscapeUtils.unescapeHtml(objAH.getString("sex")));
				ac.setAcClassCd(objAH.isNull("acClassCd")? "" : StringEscapeUtils.unescapeHtml(objAH.getString("acClassCd")));
				ac.setGroupPrintSw(objAH.isNull("groupPrintSw")? "" : StringEscapeUtils.unescapeHtml(objAH.getString("groupPrintSw")));
				ac.setLevelCd(objAH.isNull("levelCd")? "": StringEscapeUtils.unescapeHtml(objAH.getString("levelCd")));
				ac.setParentLevelCd(objAH.isNull("parentLevelCd")? null: objAH.getInt("parentLevelCd"));
				ac.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				ac.setUserId(userId);
				
				acInfoList.add(ac);
				ac = null;
			}
		}
		return acInfoList;
	}
	
	private List<GIPIQuoteItemMC> prepareMCAddlInfoJSON(JSONArray setRows, String userId)
			throws JSONException, ParseException {
		List<GIPIQuoteItemMC> vehicleList = new ArrayList<GIPIQuoteItemMC>();
		GIPIQuoteItemMC vehicle = null;
		JSONObject objItem = null;
		JSONObject objVehicle = null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		for(int i=0, length=setRows.length(); i < length; i++){
			vehicle = new GIPIQuoteItemMC();
			objItem = setRows.getJSONObject(i);
			objVehicle = objItem.isNull("gipiQuoteItemMC") ? null : objItem.getJSONObject("gipiQuoteItemMC");
			
			if(objVehicle != null){ // modified by: Nica 06.11.2012 - added StringEscapeUtils.unescapeHtml
				vehicle.setQuoteId(objItem.isNull("quoteId") ? null : objItem.getInt("quoteId"));
				vehicle.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));vehicle.setAssignee(objVehicle.isNull("assignee") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("assignee")));
				vehicle.setAcquiredFrom(objVehicle.isNull("acquiredFrom") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("acquiredFrom")));
				vehicle.setMotorNo(objVehicle.isNull("motorNo") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("motorNo")));
				vehicle.setOrigin(objVehicle.isNull("origin") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("origin")));
				vehicle.setDestination(objVehicle.isNull("destination") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("destination")));
				vehicle.setTypeOfBodyCd(objVehicle.isNull("typeOfBodyCd") ? null : objVehicle.getInt("typeOfBodyCd"));
				vehicle.setPlateNo(objVehicle.isNull("plateNo") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("plateNo")));
				vehicle.setModelYear(objVehicle.isNull("modelYear") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("modelYear")));
				vehicle.setCarCompanyCd(objVehicle.isNull("carCompanyCd") ? null : objVehicle.getInt("carCompanyCd"));
				vehicle.setMvFileNo(objVehicle.isNull("mvFileNo") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("mvFileNo")));
				vehicle.setNoOfPass(objVehicle.isNull("noOfPass") ? null : objVehicle.getInt("noOfPass"));
				vehicle.setMakeCd(objVehicle.isNull("makeCd") ? null : objVehicle.getInt("makeCd"));
				vehicle.setBasicColorCd(objVehicle.isNull("basicColorCd") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("basicColorCd")));
				vehicle.setColorCd(objVehicle.isNull("colorCd") ? null : objVehicle.getInt("colorCd"));
				vehicle.setSeriesCd(objVehicle.isNull("seriesCd") ? null : objVehicle.getInt("seriesCd"));
				vehicle.setMotType(objVehicle.isNull("motType") || objVehicle.getString("motType").equals("") ? null : objVehicle.getInt("motType"));
				vehicle.setUnladenWt(objVehicle.isNull("unladenWt") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("unladenWt")));
				vehicle.setTowing(objVehicle.isNull("towing") ? null : new BigDecimal(objVehicle.getString("towing").replaceAll(",", "")));
				vehicle.setSerialNo(objVehicle.isNull("serialNo") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("serialNo")));
				vehicle.setSublineTypeCd(objVehicle.isNull("sublineTypeCd") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("sublineTypeCd")));
				vehicle.setCocType(objVehicle.isNull("cocType") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("cocType")));
				vehicle.setCocSerialNo(objVehicle.isNull("cocSerialNo") ? null : objVehicle.getInt("cocSerialNo"));
				vehicle.setCocYy(objVehicle.isNull("cocYy") ? null : objVehicle.getInt("cocYy"));
				vehicle.setCtvTag(objVehicle.isNull("ctvTag") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("ctvTag")));				
				vehicle.setSublineCd(objVehicle.isNull("sublineCd") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("sublineCd")));
				vehicle.setEstValue(objVehicle.isNull("estValue") ? null : new BigDecimal(objVehicle.getString("estValue")));
				vehicle.setTariffZone(objVehicle.isNull("tariffZone") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("tariffZone")));
				vehicle.setCocIssueDate(objVehicle.isNull("cocIssueDate") ? null : sdf.parse(objVehicle.getString("cocIssueDate")));
				vehicle.setCocSeqNo(objVehicle.isNull("cocSeqNo") ? null : objVehicle.getInt("cocSeqNo"));
				vehicle.setCocAtcn(objVehicle.isNull("cocAtcn") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("cocAtcn")));
				vehicle.setMake(objVehicle.isNull("make") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("make")));
				vehicle.setColor(objVehicle.isNull("color") ? null : StringEscapeUtils.unescapeHtml(objVehicle.getString("color")));
				vehicle.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				vehicle.setUserId(userId);
				vehicleList.add(vehicle);
				vehicle = null;				
			}			
		}
		return vehicleList;
	}
	
	private List<GIPIQuoteFIItem> prepareFIAddlInfoJSON(JSONArray setRows, String userId)
			throws JSONException, ParseException {
		
		List<GIPIQuoteFIItem> fireList = new ArrayList<GIPIQuoteFIItem>();
		GIPIQuoteFIItem fire = null;
		JSONObject objItem = null;
		JSONObject objFire = null;		
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=setRows.length(); i < length; i++){
			fire = new GIPIQuoteFIItem();
			objItem = setRows.getJSONObject(i);
			objFire = objItem.isNull("gipiQuoteFIItem") ? null : objItem.getJSONObject("gipiQuoteFIItem");
			
			if(objFire != null){
				fire.setQuoteId(objItem.isNull("quoteId") ? null : objItem.getInt("quoteId"));
				fire.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				fire.setDistrictNo(objFire.isNull("districtNo") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("districtNo")));
				fire.setEqZone(objFire.isNull("eqZone") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("eqZone")));
				fire.setTarfCd(objFire.isNull("tarfCd") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("tarfCd")));
				fire.setBlockNo(objFire.isNull("blockNo") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("blockNo")));
				fire.setFrItemType(objFire.isNull("frItemType") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("frItemType")));
				fire.setLocRisk1(objFire.isNull("locRisk1") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("locRisk1")));
				fire.setLocRisk2(objFire.isNull("locRisk2") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("locRisk2")));
				fire.setLocRisk3(objFire.isNull("locRisk3") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("locRisk3")));
				fire.setTariffZone(objFire.isNull("tariffZone") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("tariffZone")));
				fire.setTyphoonZone(objFire.isNull("typhoonZone") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("typhoonZone")));
				fire.setConstructionCd(objFire.isNull("constructionCd") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("constructionCd")));
				fire.setConstructionRemarks(objFire.isNull("constructionRemarks") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("constructionRemarks")));
				fire.setFront(objFire.isNull("front") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("front")));
				fire.setRight(objFire.isNull("right") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("right")));
				fire.setLeft(objFire.isNull("left") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("left")));
				fire.setRear(objFire.isNull("rear") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("rear")));
				fire.setOccupancyCd(objFire.isNull("occupancyCd") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("occupancyCd")));
				fire.setOccupancyRemarks(objFire.isNull("occupancyRemarks") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("occupancyRemarks")));
				fire.setAssignee(objFire.isNull("assignee") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("assignee")));
				fire.setFloodZone(objFire.isNull("floodZone") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("floodZone")));
				fire.setBlockId(objFire.isNull("blockId") || objFire.getString("blockId").equals("") ? null : objFire.getInt("blockId"));
				fire.setRiskCd(objFire.isNull("riskCd") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("riskCd")));
				fire.setLatitude(objFire.isNull("latitude") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("latitude")));/*Added by MarkS 02/08/2017 SR5918*/
				fire.setLongitude(objFire.isNull("longitude") ? null : StringEscapeUtils.unescapeHtml(objFire.getString("longitude")));/*Added by MarkS 02/08/2017 SR5918*/
				fire.setAppUser(userId); // added Nica 09.27.2012 to set userId / appUser
				fire.setUserId(userId);
				
				if (!objFire.isNull("dateFrom")){
					fire.setDateFrom(df.parse(objFire.getString("dateFrom")));
				}
				if (!objFire.isNull("dateTo")){
					fire.setDateTo(df.parse(objFire.getString("dateTo")));
				}
				
				fireList.add(fire);
				fire = null;
			}
		}
		return fireList;
	}

	@Override
	public Integer getMaxQuoteItemNo(Integer quoteId) throws SQLException {
		return this.getGipiQuoteItemDAO2().getMaxQuoteItemNo(quoteId);
	}

}
