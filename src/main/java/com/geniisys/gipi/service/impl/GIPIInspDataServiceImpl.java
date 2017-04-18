package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIInspDataDAO;
import com.geniisys.gipi.entity.GIPIInspData;
import com.geniisys.gipi.entity.GIPIInspDataDtl;
import com.geniisys.gipi.entity.GIPIInspDataWc;
import com.geniisys.gipi.entity.GIPIInspReportAttachMedia;
import com.geniisys.gipi.service.GIPIInspDataService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIInspDataServiceImpl implements GIPIInspDataService{

	private GIPIInspDataDAO gipiInspDataDAO;
	private DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
	private Map<String, Object> inspDataMap = new HashMap<String, Object>();

	public GIPIInspDataDAO getGipiInspDataDAO() {
		return gipiInspDataDAO;
	}

	public void setGipiInspDataDAO(GIPIInspDataDAO gipiInspDataDAO) {
		this.gipiInspDataDAO = gipiInspDataDAO;
	}
	
	@SuppressWarnings("deprecation")
	public PaginatedList getGipiInspData1(Map<String, Object> params)
		throws SQLException {
		String searchKeyword = '%'+params.get("keyword").toString().toUpperCase()+'%';
		List<GIPIInspData> inspDataList = this.getGipiInspDataDAO().getGipiInspData1(searchKeyword);
		PaginatedList paginatedList = new PaginatedList(inspDataList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage((Integer) params.get("page"));
		return paginatedList;
	}

	@Override
	public List<GIPIInspData> getInspDataItemInfo(Integer inspNo)
			throws SQLException {
		//List<GIPIInspData> inspDataList = (List<GIPIInspData>) StringFormatter.escapeHTMLInList(this.getGipiInspDataDAO().getInspDataItemInfo(inspNo));
		List<GIPIInspData> inspDataList = (List<GIPIInspData>) this.getGipiInspDataDAO().getInspDataItemInfo(inspNo);
		return inspDataList;
	}
	
	public void saveGipiInspData(String inspDataParams, String user) throws Exception{
		JSONObject objParams = new JSONObject(inspDataParams);
		//inspDataMap.put("deletedInspNo", objParams.getString("deletedInspNo"));
		inspDataMap.put("deletedItems", this.prepareInspDataForDelete(new JSONArray(objParams.getString("deletedItems"))));
		inspDataMap.put("inspDataList", this.prepareInspDataForInsert(new JSONArray(objParams.getString("addedItems"))));
		
		//removed by john 12.3.2015 :: SR#4019
		/*if (!"[]".equals(objParams.getString("insertedWcObjects"))){
			inspDataMap.put("inspDataWc", this.prepareWarrantiesAndClauses(new JSONArray((String) objParams.getString("insertedWcObjects")), "INSERT"));
		} else {
			inspDataMap.put("inspDataWc", null);
		}*/
		if (!"{}".equals(objParams.getString("otherDtls"))){
			inspDataMap.put("otherDetails", this.prepareOtherDetails(new JSONObject((String) objParams.getString("otherDtls"))));
		} else {
			inspDataMap.put("otherDetails", null);
		}
		if (!"{}".equals(objParams.getString("otherDtls"))){
			inspDataMap.put("inspDataListUpdate", this.updateInspDataOtherDtls(new JSONObject((String) objParams.getString("otherDtls"))));
		} else {
			inspDataMap.put("inspDataListUpdate", null);
		}
		/*
		inspDataParams.put("deletedInspNo", inspDataMap.get("deletedInspNo"));
		inspDataParams.put("inspDataList", this.prepareInspDataForInsert(new JSONArray((String) inspDataMap.get("inspDataList"))));
		
		if (!"[]".equals(inspDataMap.get("inspDataWc"))){
			inspDataParams.put("inspDataWc", this.prepareWarrantiesAndClauses(new JSONArray((String) inspDataMap.get("inspDataWc")), "INSERT"));
		}
		if (!"{}".equals(inspDataMap.get("otherDetails"))){
			inspDataParams.put("otherDetails", this.prepareOtherDetails(new JSONObject((String) inspDataMap.get("otherDetails"))));
		}
		if (!"{}".equals(inspDataMap.get("otherDetails"))){
			inspDataParams.put("inspDataListUpdate", this.updateInspDataOtherDtls(new JSONObject((String) inspDataMap.get("otherDetails"))));
		}*/
		//inspDataParams.put("otherDetails", );
		//inspDataParams.put("deletedInspDataWc", this.prepareWarrantiesAndClauses(new JSONArray(inspDataMap.get("deletedInspDataWc")), "DELETE"));
		
		this.getGipiInspDataDAO().saveGipiInspData(inspDataMap, user);
	}
	
	//added by john 12.3.2015 :: SR#4019
	public List<GIPIInspData> prepareInspDataForDelete(JSONArray inspDataObjArray) throws JSONException, ParseException{
		List<GIPIInspData> inspDataList = new ArrayList<GIPIInspData>();
		
		JSONObject tempInspDataObj = null;
		
		for (int i = 0; i < inspDataObjArray.length(); i++){
			GIPIInspData inspData = new GIPIInspData();
			tempInspDataObj = inspDataObjArray.getJSONObject(i);
			
			inspData.setInspNo(tempInspDataObj.isNull("inspNo") || tempInspDataObj.get("inspNo").equals("") ? null : tempInspDataObj.getInt("inspNo"));
			inspData.setItemNo(tempInspDataObj.isNull("itemNo") ? null : tempInspDataObj.getInt("itemNo"));
			
			inspDataList.add(inspData);
		}
		
		return inspDataList;
	}
	
	public List<GIPIInspData> prepareInspDataForInsert(JSONArray inspDataObjArray) throws JSONException, ParseException{
		List<GIPIInspData> inspDataList = new ArrayList<GIPIInspData>();
		JSONObject tempInspDataObj = null;
		
		for (int i = 0; i < inspDataObjArray.length(); i++){
			GIPIInspData inspData = new GIPIInspData();
			tempInspDataObj = inspDataObjArray.getJSONObject(i);
			inspData.setInspNo(tempInspDataObj.isNull("inspNo") ? null : tempInspDataObj.getInt("inspNo"));
			inspData.setItemNo(tempInspDataObj.isNull("itemNo") ? null : tempInspDataObj.getInt("itemNo"));
			inspData.setItemDesc(tempInspDataObj.isNull("itemDesc") ? null : tempInspDataObj.getString("itemDesc"));
			inspData.setBlockId(tempInspDataObj.isNull("blockId") ? null : tempInspDataObj.getString("blockId"));
			inspData.setAssdNo(tempInspDataObj.isNull("assdNo") ? null : tempInspDataObj.getString("assdNo"));
			inspData.setAssdName(tempInspDataObj.isNull("assdName") ? null : tempInspDataObj.getString("assdName"));
			inspData.setLocRisk1(tempInspDataObj.isNull("locRisk1") ? null : tempInspDataObj.getString("locRisk1"));
			inspData.setLocRisk2(tempInspDataObj.isNull("locRisk2") ? null : tempInspDataObj.getString("locRisk2"));
			inspData.setLocRisk3(tempInspDataObj.isNull("locRisk3") ? null : tempInspDataObj.getString("locRisk3"));
			inspData.setOccupancyCd(tempInspDataObj.isNull("occupancyCd") ? null : tempInspDataObj.getString("occupancyCd"));
			inspData.setOccupancyRemarks(tempInspDataObj.isNull("occupancyRemarks") ? null : tempInspDataObj.getString("occupancyRemarks"));
			inspData.setConstructionCd(tempInspDataObj.isNull("constructionCd") ? null : tempInspDataObj.getString("constructionCd"));
			inspData.setConstructionRemarks(tempInspDataObj.isNull("constructionRemarks") ? null : tempInspDataObj.getString("constructionRemarks"));
			inspData.setFront(tempInspDataObj.isNull("front") ? null : tempInspDataObj.getString("front"));
			inspData.setLeft(tempInspDataObj.isNull("left") ? null : tempInspDataObj.getString("left"));
			inspData.setRight(tempInspDataObj.isNull("right") ? null : tempInspDataObj.getString("right"));
			inspData.setRear(tempInspDataObj.isNull("rear") ? null : tempInspDataObj.getString("rear"));
			inspData.setWcCd(tempInspDataObj.isNull("wcCd") ? null : tempInspDataObj.getString("wcCd"));
			inspData.setTarfCd(tempInspDataObj.isNull("tarfCd") ? null : tempInspDataObj.getString("tarfCd"));
			inspData.setTariffZone(tempInspDataObj.isNull("tariffZone") ? null : tempInspDataObj.getString("tariffZone"));
			inspData.setEqZone(tempInspDataObj.isNull("eqZone") ? null : tempInspDataObj.getString("eqZone"));
			inspData.setFloodZone(tempInspDataObj.isNull("floodZone") ? null : tempInspDataObj.getString("floodZone"));
			inspData.setTyphoonZone(tempInspDataObj.isNull("typhoonZone") ? null : tempInspDataObj.getString("typhoonZone"));
			inspData.setPremRate(tempInspDataObj.isNull("premRate") || "".equals(tempInspDataObj.getString("premRate")) ? null :  new BigDecimal(tempInspDataObj.getString("premRate")));
			inspData.setTsiAmt(tempInspDataObj.isNull("tsiAmt") || "".equals(tempInspDataObj.getString("tsiAmt")) ? null :  new BigDecimal(tempInspDataObj.getString("tsiAmt")));
			inspData.setIntmNo(tempInspDataObj.isNull("intmNo") ? null :  tempInspDataObj.getInt("intmNo"));
			inspData.setInspCd(tempInspDataObj.isNull("inspCd") ? null :  tempInspDataObj.getInt("inspCd"));
			inspData.setDateInsp(tempInspDataObj.isNull("dateInsp") ? null : sdf.parse(tempInspDataObj.getString("dateInsp")));
			inspData.setApprovedBy(tempInspDataObj.isNull("approvedBy") ? null : tempInspDataObj.getString("approvedBy"));
			inspData.setDateApproved(tempInspDataObj.isNull("dateApproved") || "".equals(tempInspDataObj.getString("dateApproved")) ? null : sdf.parse(tempInspDataObj.getString("dateApproved")));
			inspData.setParId(tempInspDataObj.isNull("parId") ? null : tempInspDataObj.getString("parId"));
			inspData.setQuoteId(tempInspDataObj.isNull("quoteId") ? null : tempInspDataObj.getString("quoteId"));
			inspData.setItemTitle(tempInspDataObj.isNull("itemTitle") ? null : tempInspDataObj.getString("itemTitle"));
			inspData.setStatus(tempInspDataObj.isNull("status") ? null : tempInspDataObj.getString("status"));
			inspData.setItemGrp(tempInspDataObj.isNull("itemGrp") ? null : tempInspDataObj.getString("itemGrp"));
			inspData.setRemarks(tempInspDataObj.isNull("remarks") ? null : tempInspDataObj.getString("remarks"));
			inspData.setArcExtData(tempInspDataObj.isNull("arcExtData") ? null : tempInspDataObj.getString("arcExtData"));
			/*Added by MarkS 02/09/2017 SR5919 */
			inspData.setLatitude(tempInspDataObj.isNull("latitude") ? null : tempInspDataObj.getString("latitude"));
			inspData.setLongitude(tempInspDataObj.isNull("longitude") ? null : tempInspDataObj.getString("longitude"));
			/* end SR5919*/
			
			inspDataList.add(inspData);
		}
		
		return inspDataList;
	}
	
	public List<GIPIInspDataWc> prepareWarrantiesAndClauses(JSONArray wcObjArray, String tranMode) throws JSONException{
		List<GIPIInspDataWc> wcList = new ArrayList<GIPIInspDataWc>();
		
		JSONObject wcObj = null;
		for (int i = 0; i < wcObjArray.length(); i++){
			GIPIInspDataWc wc = new GIPIInspDataWc();
			wcObj = wcObjArray.getJSONObject(i);
			wc.setInspNo(wcObj.isNull("inspNo") ? null : wcObj.getInt("inspNo"));
			wc.setWcCd(wcObj.isNull("wcCd") ? null : wcObj.getString("wcCd"));
			if ("INSERT".equals(tranMode)){
				wc.setArcExtData(wcObj.isNull("arcExtData") ? null : wcObj.getString("arcExtData"));
			} else {
				wc.setArcExtData(null);
			}
			wcList.add(wc);
		}
		
		return wcList;
	}
	
	public GIPIInspDataDtl prepareOtherDetails(JSONObject otherDtlsObj) throws JSONException {
		GIPIInspDataDtl otherDtls = new GIPIInspDataDtl();
		
		otherDtls.setInspNo(otherDtlsObj.isNull("inspNo") ? null : otherDtlsObj.getInt("inspNo"));
		otherDtls.setFiProRemarks(otherDtlsObj.isNull("fiProRemarks") ? null : otherDtlsObj.getString("fiProRemarks"));
		otherDtls.setFiStationRemarks(otherDtlsObj.isNull("fiStationRemarks") ? null : otherDtlsObj.getString("fiStationRemarks"));
		otherDtls.setSecSysRemarks(otherDtlsObj.isNull("secSysRemarks") ? null : otherDtlsObj.getString("secSysRemarks"));
		otherDtls.setGenSurrRemarks(otherDtlsObj.isNull("genSurrRemarks") ? null : otherDtlsObj.getString("genSurrRemarks"));
		otherDtls.setMaintDtlRemarks(otherDtlsObj.isNull("maintDtlRemarks") ? null : otherDtlsObj.getString("maintDtlRemarks"));
		otherDtls.setElecInstRemarks(otherDtlsObj.isNull("elecInstRemarks") ? null : otherDtlsObj.getString("elecInstRemarks"));
		otherDtls.setHkRemarks(otherDtlsObj.isNull("hkRemarks") ? null : otherDtlsObj.getString("hkRemarks"));
		
		return otherDtls;
	}
	
	public GIPIInspData updateInspDataOtherDtls(JSONObject otherDtlsObj) throws JSONException {
		GIPIInspData newInspData = new GIPIInspData();
		
		newInspData.setInspNo(otherDtlsObj.isNull("inspNo") ? null : otherDtlsObj.getInt("inspNo"));
		newInspData.setItemNo(otherDtlsObj.isNull("itemNo") ? null : otherDtlsObj.getInt("itemNo"));
		newInspData.setRiskGrade(otherDtlsObj.isNull("riskGrade") ? null : otherDtlsObj.getString("riskGrade"));
		newInspData.setPerilOption1(otherDtlsObj.isNull("perilOption1") ? null : otherDtlsObj.getString("perilOption1"));
		newInspData.setPerilOption2(otherDtlsObj.isNull("perilOption2") ? null : otherDtlsObj.getString("perilOption2"));
		newInspData.setPerilOption1BldgRate(otherDtlsObj.isNull("perilOption1BldgRate") || "".equals(otherDtlsObj.getString("perilOption1BldgRate")) ? null : new BigDecimal(otherDtlsObj.getString("perilOption1BldgRate")));
		newInspData.setPerilOption1ContRate(otherDtlsObj.isNull("perilOption1ContRate") || "".equals(otherDtlsObj.getString("perilOption1ContRate")) ? null : new BigDecimal(otherDtlsObj.getString("perilOption1ContRate")));
		newInspData.setPerilOption2BldgRate(otherDtlsObj.isNull("perilOption2BldgRate") || "".equals(otherDtlsObj.getString("perilOption2BldgRate")) ? null : new BigDecimal(otherDtlsObj.getString("perilOption2BldgRate")));
		newInspData.setPerilOption2ContRate(otherDtlsObj.isNull("perilOption2ContRate") || "".equals(otherDtlsObj.getString("perilOption2ContRate")) ? null : new BigDecimal(otherDtlsObj.getString("perilOption2ContRate")));
		
		return newInspData;
	}
	
	public String getBlockId(Map<String, Object> params) throws SQLException{
		return this.getGipiInspDataDAO().getBlockId(params);
	}
	
	public Integer generateInspNo() throws SQLException{
		return this.getGipiInspDataDAO().generateInspNo();
	}
	
	public GIPIInspData getInspOtherDtls(Map<String, Object> otherParams) throws SQLException{
		return this.getGipiInspDataDAO().getInspOtherDtls(otherParams);
	}
	
	/*@SuppressWarnings("unchecked")
	public HashMap<String, Object> getGipiInspData1TableGrid(HashMap<String, Object> params)
		throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		Map<String, Object> filterMap = this.prepareInspDataFilter(params.get("filter") == null ? null : params.get("filter").toString());
		params.put("filter", filterMap);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIInspData> list = this.getGipiInspDataDAO().getGipiInspData1TableGrid(params);
		params.put("rows", new JSONArray((List<GIPIInspData>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}*/ //remove by steven 9.20.2013
	
	@SuppressWarnings("unused")
	private Map<String, Object> prepareInspDataFilter(String filter) throws JSONException {
		Map<String, Object> inspDataMap = new HashMap<String, Object>();
		JSONObject jsonFilter = null;
		if (null == filter){
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		//removed percent signs in else - christian 08.23.2012
		inspDataMap.put("inspName", jsonFilter.isNull("inspName") ? "%%" : jsonFilter.getString("inspName").toUpperCase());
		inspDataMap.put("assdName", jsonFilter.isNull("assdName") ? "%%" : jsonFilter.getString("assdName").toUpperCase());
		inspDataMap.put("inspNo", jsonFilter.isNull("inspNo") ? "%%" : jsonFilter.getString("inspNo"));
		inspDataMap.put("strDateInsp", jsonFilter.isNull("strDateInsp") ? "%%" : jsonFilter.getString("strDateInsp")); //modified by Christian 08.23.2012
		return inspDataMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getQuoteInpsList(HashMap<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("filter", this.prepareQuoteInspListFilter((String) params.get("filter")));
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		// get main list
		List<GIPIInspData> inspList = this.getGipiInspDataDAO().getQuoteInpsList(params);
		params.put("rows", new JSONArray((List<GIPIInspData>)StringFormatter.escapeHTMLInList(inspList)));
		System.out.println("INSPECTIO LIST SIZE: "+inspList.size());
		grid.setNoOfPages(inspList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	private Map<String, Object> prepareQuoteInspListFilter(String filter) throws JSONException{
		Map<String, Object> inspListMap = new HashMap<String, Object>();
		JSONObject jsonFilter = null;
		if (null == filter){
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		inspListMap.put("assdName", jsonFilter.isNull("assdName") ? "%%" : "%"+jsonFilter.getString("assdName")+"%");
		inspListMap.put("inspName", jsonFilter.isNull("inspName") ? "%%" : "%"+jsonFilter.getString("inspName")+"%");
		inspListMap.put("itemDesc", jsonFilter.isNull("itemDesc") ? "%%" : "%"+jsonFilter.getString("itemDesc")+"%");
		inspListMap.put("province", jsonFilter.isNull("province") ? "%%" : "%"+jsonFilter.getString("province")+"%");
		inspListMap.put("city", jsonFilter.isNull("city") ? "%%" : "%"+jsonFilter.getString("city")+"%");
		inspListMap.put("districtDesc", jsonFilter.isNull("districtDesc") ? "%%" : "%"+jsonFilter.getString("districtDesc")+"%");
		inspListMap.put("blockDesc", jsonFilter.isNull("blockDesc") ? "%%" : "%"+jsonFilter.getString("blockDesc")+"%");
		inspListMap.put("locRisk1", jsonFilter.isNull("locRisk1") ? "%%" : "%"+jsonFilter.getString("locRisk1")+"%");
		inspListMap.put("locRisk2", jsonFilter.isNull("locRisk2") ? "%%" : "%"+jsonFilter.getString("locRisk2")+"%");
		inspListMap.put("locRisk3", jsonFilter.isNull("locRisk3") ? "%%" : "%"+jsonFilter.getString("locRisk3")+"%");
		return inspListMap;
	}
	@Override
	public void saveInspectionAttachments(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setAttachRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setAttachRows")), userId, GIPIInspReportAttachMedia.class));
		params.put("delAttachRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delAttachRows")), userId, GIPIInspReportAttachMedia.class));
		
		// get attachments
		List<GIPIInspReportAttachMedia> attachments = (List<GIPIInspReportAttachMedia>) params.get("delAttachRows");
		List<String> files = new ArrayList<String>();
		
		for (GIPIInspReportAttachMedia attachment : attachments) {
			files.add(attachment.getFileName());
		}
		
		this.getGipiInspDataDAO().saveInspectionAttachments(params,userId);
		
		// delete files
		FileUtil.deleteFiles(files);
	}

	@Override
	public String saveInspectionToPAR(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGipiInspDataDAO().saveInspectionToPAR(params);
	}

	@Override
	public JSONObject getGipiInspData1TableGrid2(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipiInspData1TableGrid");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		
		JSONObject json = new JSONObject(map);
		JSONArray rows = json.getJSONArray("rows");
		for (int i = 0; i < rows.length(); i++) {
			rows.getJSONObject(i).put("tbgStatus", rows.getJSONObject(i).getString("status").equals("N") ? false : true);
		}
		json.remove("rows");
		json.put("rows", rows);
		
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}
	
	public void saveWarrAndClauses(HttpServletRequest request, String user) throws Exception{
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		/*JSONObject objInsert = new JSONObject(request.getParameter("paramsInsert"));
		JSONObject objDelete = new JSONObject(request.getParameter("paramsDelete"));*/
		
		inspDataMap.put("inspDataWc", this.prepareWarrantiesAndClauses(new JSONArray((String) objParams.getString("insertedWcObjects")), "INSERT"));
		inspDataMap.put("deletedInspDataWc", this.prepareWarrantiesAndClauses(new JSONArray((String) objParams.getString("deletedWcObjects")), "DELETE"));
		
		this.getGipiInspDataDAO().saveWarrAndClauses(inspDataMap, user);
	}
	
	//added by john 3.21.2016 SR#5470
	public void saveInspectionInformation(HttpServletRequest request, String user)  throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("inspNo", request.getParameter("inspNo"));
		params.put("assdNo", request.getParameter("assdNo"));
		params.put("assdName", request.getParameter("assdName"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("inspCd", request.getParameter("inspCd"));
		params.put("remarks", request.getParameter("remarks"));
		params.put("status", request.getParameter("status"));
		params.put("userId", user);
		this.getGipiInspDataDAO().saveInspectionInformation(params, user);
	}
	
	public JSONObject showInspectionReport(HttpServletRequest request, String user) throws Exception{
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(request.getServletContext());
		LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		request.setAttribute("currentUser", user);
		request.setAttribute("eqZoneList", helper.getList(LOVHelper.EQ_ZONE_LISTING));
		request.setAttribute("typhoonList", helper.getList(LOVHelper.TYPHOON_ZONE_LISTING));
		request.setAttribute("floodList", helper.getList(LOVHelper.FLOOD_ZONE_LISTING));
		request.setAttribute("occupancyList", helper.getList(LOVHelper.FIRE_OCCUPANCY_LISTING));
		request.setAttribute("provinceList", helper.getList(LOVHelper.PROVINCE_LISTING));		
		request.setAttribute("tariffList", helper.getList(LOVHelper.TARIFF_LISTING));
		request.setAttribute("tariffZoneList", helper.getList(LOVHelper.ALL_TARIFF_ZONE_LISTING));
		request.setAttribute("constructionList", helper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
		
		JSONObject inspDataObj = new JSONObject(request.getParameter("inspDataObj"));
		DateFormat formatter = new SimpleDateFormat("E MMM dd HH:mm:ss Z yyyy");
		Calendar calendar = Calendar.getInstance();
		
		if(!inspDataObj.get("dateInsp").equals("")){
			if(!inspDataObj.get("dateInsp").equals(null)){
				String strDateInsp = inspDataObj.get("dateInsp").toString();
				try {
					Date dateInsp = formatter.parse(strDateInsp);
					calendar.setTime(dateInsp);
					String formattedDateInsp = (calendar.get(Calendar.MONTH) + 1) + "-" + calendar.get(Calendar.DATE) + "-" + calendar.get(Calendar.YEAR);
					inspDataObj.put("dateInsp", formattedDateInsp);
		        } catch (ParseException e) {
		        	inspDataObj.put("dateInsp", strDateInsp);
		        }
			}
		}
		
		if(!inspDataObj.get("dateApproved").equals("")){
			if(!inspDataObj.get("dateApproved").equals(null)){
				String strDateApproved = inspDataObj.get("dateApproved").toString();
				try {
					Date dateApproved = formatter.parse(strDateApproved);
					calendar.setTime(dateApproved);
					String formattedDateApproved = (calendar.get(Calendar.MONTH) + 1) + "-" + calendar.get(Calendar.DATE) + "-" + calendar.get(Calendar.YEAR);
					inspDataObj.put("dateApproved", formattedDateApproved);
				} catch (ParseException e) {
		        	inspDataObj.put("dateApproved", strDateApproved);
		        }
			}
		}
		
		return inspDataObj;
	}
	
	public Integer getAttachmentTotalSize(Map<String, Object> params) throws SQLException, IOException {
		Integer attachmentTotalSize = 0;
		
		List<Map<String, Object>> attachments = this.gipiInspDataDAO.getAttachments(params);
		
		for(Map<String, Object> attachment : attachments) {
			try {
				FileInputStream fis = new FileInputStream((String) attachment.get("fileName"));
	        	byte[] file = new byte[fis.available()];
				fis.read(file);
				fis.close();
				attachmentTotalSize += file.length;
			} catch (Exception e) {
				continue;
			}
		}
		
		return attachmentTotalSize;
	}
	
	public String copyAttachments(Map<String, Object> params) throws SQLException, IOException {
		String message = "";
		String lineCd = params.get("lineCd").toString();
		String parId = params.get("parId").toString();
		String parNo = params.get("parNo").toString();
		String inspNo = params.get("inspNo").toString();
		String mediaPathUW = params.get("mediaPathUW").toString().replaceAll("\\\\", "/");
		String mediaPathINSP = params.get("mediaPathINSP").toString().replaceAll("\\\\", "/");
		//String mediaPathINSPRegEx = mediaPathINSP + "/" + inspNo;
		//String parNoReplace = "/" + lineCd + "/" + parNo;
		String fileSrc = "";
		String fileDes = "";
		
		// get attachment list
		List<Map<String, Object>> attachmentList = this.getGipiInspDataDAO().getAttachmentByPar(parId);
		
		for (Map<String, Object> attachment : attachmentList) {
			fileSrc = attachment.get("fileName").toString().replaceAll("\\\\", "/");
			//fileDes = mediaPathUW + fileSrc.replaceAll(mediaPathINSPRegEx, parNoReplace);
			
			String fileName = attachment.get("fileName").toString();
			String realFileName = fileName.substring(fileName.lastIndexOf("/") + 1);
			
			fileDes = mediaPathUW + "/" + lineCd + "/" + parNo + "/" + attachment.get("itemNo").toString() + "/" + realFileName;
			
			// update file path
			Map<String, Object> params2 = new HashMap<String, Object>();
			params2.put("parId", parId);
			params2.put("itemNo", attachment.get("itemNo").toString());
			params2.put("oldFileName", fileSrc);
			params2.put("newFileName", fileDes);
			
			this.getGipiInspDataDAO().updateFileName3(params2);
			
			try {
				File src = new File(fileSrc);
				File des = new File(fileDes);
				
				System.out.println("Copying " + fileSrc + " to " + fileDes + " ...");
				FileUtils.copyFile(src, des); // copy physical file
			} catch (IOException e) {
				continue; // if file source not exists, continue to next file
			}
		}
		
		message = "SUCCESS";
		return message;
	}
}
