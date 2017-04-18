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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWFireItmDAO;
import com.geniisys.gipi.entity.GIPIWFireItm;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWFireItmService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIWFireItmServiceImpl.
 */
public class GIPIWFireItmServiceImpl implements GIPIWFireItmService {

	/** The gipi w fire item dao. */
	private GIPIWFireItmDAO gipiWFireItemDAO;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWItemService gipiWItemService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIParMortgageeFacadeService gipiWMortgageeService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;
	
	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}

	public void setGipiWPolWCService(
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}

	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}

	/**
	 * Gets the gipi w fire item dao.
	 * 
	 * @return the gipi w fire item dao
	 */
	public GIPIWFireItmDAO getGipiWFireItemDAO() {
		return gipiWFireItemDAO;
	}

	public GIPIWPolbasService getGipiWPolbasService() {
		return gipiWPolbasService;
	}

	public void setGipiWPolbasService(GIPIWPolbasService gipiWPolbasService) {
		this.gipiWPolbasService = gipiWPolbasService;
	}

	public GIPIWItemService getGipiWItemService() {
		return gipiWItemService;
	}

	public void setGipiWItemService(GIPIWItemService gipiWItemService) {
		this.gipiWItemService = gipiWItemService;
	}

	public GIPIWPerilDiscountService getGipiWPerilDiscountService() {
		return gipiWPerilDiscountService;
	}

	public void setGipiWPerilDiscountService(
			GIPIWPerilDiscountService gipiWPerilDiscountService) {
		this.gipiWPerilDiscountService = gipiWPerilDiscountService;
	}

	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}

	public void setGipiWDeductibleService(
			GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}

	public GIPIParMortgageeFacadeService getGipiWMortgageeService() {
		return gipiWMortgageeService;
	}


	public void setGipiWMortgageeService(GIPIParMortgageeFacadeService gipiWMortgageeService) {
		this.gipiWMortgageeService = gipiWMortgageeService;
	}

	/**
	 * Sets the gipi w fire item dao.
	 * 
	 * @param gipiWFireItemDAO the new gipi w fire item dao
	 */
	public void setGipiWFireItemDAO(GIPIWFireItmDAO gipiWFireItemDAO) {
		this.gipiWFireItemDAO = gipiWFireItemDAO;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#getGIPIWFireItems(int)
	 */
	@Override
	public List<GIPIWFireItm> getGIPIWFireItems(int parId) throws SQLException {		
		return this.getGipiWFireItemDAO().getGIPIWFireItems(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#delGIPIWFireItem(java.util.List)
	 */
	@Override
	public void delGIPIWFireItem(List<GIPIWFireItm> wFireItem)
			throws SQLException {
		// 		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#delGIPIWFireItem(java.util.Map)
	 */
	@Override
	public void delGIPIWFireItem(Map<String, Object> params)
			throws SQLException {
		//		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#setGIPIWFireItem(java.util.List)
	 */
	@Override
	public void setGIPIWFireItem(List<GIPIWFireItm> wFireItem)
			throws SQLException {
		// 		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#setGIPIWFireItem(java.util.Map)
	 */
	@Override
	public void setGIPIWFireItem(Map<String, Object> params)
			throws SQLException {
		String[] parIds					= (String[]) params.get("parIds");
		String[] itemNos 				= (String[]) params.get("itemNos");
		String[] districtNos			= (String[]) params.get("districtNos");
		String[] eqZones				= (String[]) params.get("eqZones");
		String[] tarfCds				= (String[]) params.get("tarfCds");
		String[] blockNos				= (String[]) params.get("blockNos");
		String[] frItemTypes			= (String[]) params.get("frItemTypes");
		String[] locRisk1s				= (String[]) params.get("locRisk1s");
		String[] locRisk2s				= (String[]) params.get("locRisk2s");
		String[] locRisk3s				= (String[]) params.get("locRisk3s");
		String[] tariffZones			= (String[]) params.get("tariffZones");
		String[] typhoonZones			= (String[]) params.get("typhoonZones");
		String[] constructionCds		= (String[]) params.get("constructionCds");
		String[] constructionRemarkss	= (String[]) params.get("constructionRemarkss");
		String[] fronts					= (String[]) params.get("fronts");
		String[] rights					= (String[]) params.get("rights");
		String[] lefts					= (String[]) params.get("lefts");
		String[] rears					= (String[]) params.get("rears");
		String[] occupancyCds			= (String[]) params.get("occupancyCds");
		String[] occupancyRemarkss		= (String[]) params.get("occupancyRemarkss");
		String[] assignees				= (String[]) params.get("assignees");
		String[] floodZones				= (String[]) params.get("floodZones");
		String[] blockIds				= (String[]) params.get("blockIds");
		String[] riskCds				= (String[]) params.get("riskCds");		
		
		if(frItemTypes != null){
			List<GIPIWFireItm> fireItems = new ArrayList<GIPIWFireItm>();
			for(int i=0; i < frItemTypes.length; i++){
				fireItems.add(new GIPIWFireItm(Integer.parseInt(parIds[i]), Integer.parseInt(itemNos[i]), districtNos[i], eqZones[i],
									tarfCds[i], blockNos[i], frItemTypes[i], locRisk1s[i],
									locRisk2s[i], locRisk3s[i], tariffZones[i], typhoonZones[i],
									constructionCds[i], constructionRemarkss[i], fronts[i], rights[i],
									lefts[i], rears[i], occupancyCds[i], occupancyRemarkss[i],
									assignees[i], floodZones[i], blockIds[i], riskCds[i]));
			}
			this.getGipiWFireItemDAO().setGIPIWFireItem(fireItems);
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#getAssuredMailingAddress(int)
	 */
	@Override
	public Map<String, Object> getAssuredMailingAddress(int assdNo)
			throws SQLException {		
		return this.getGipiWFireItemDAO().getAssuredMailingAddress(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#getFireParameters()
	 */
	@Override
	public Map<String, Object> getFireParameters() throws SQLException {		
		return this.getGipiWFireItemDAO().getFireAdditionalParams();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#getFireTariff(int, int)
	 */
	@Override
	public BigDecimal getFireTariff(int parId, int itemNo) throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("tariffRate", new BigDecimal(0));
		
		BigDecimal tariffRate = null;
		tariffRate = this.getGipiWFireItemDAO().getFireTariff(params);
		
		return tariffRate;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#checkAddtlInfo(int)
	 */
	@Override
	public String checkAddtlInfo(int parId) throws SQLException {
		return this.getGipiWFireItemDAO().checkAddtlInfo(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWFireItmService#getGIPIS039BasicVarValues(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIPIS039BasicVarValues(
			Map<String, Object> params) throws SQLException {
		return this.getGipiWFireItemDAO().getGIPIS039BasicVarValues(params);
	}

	@Override
	public boolean saveFireItem(Map<String, Object> params) throws SQLException {
		return this.getGipiWFireItemDAO().saveFireItem(params);
	}

	@Override
	public Map<String, Object> newFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		//int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId")); // andrew - 07.08.2011
		int parId = Integer.parseInt(request.getParameter("parId"));
		
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWFireItemDAO().gipis003NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("itemFires", new JSONArray(this.getGipiWItemService().getParItemFI(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		formMap.put("objGIPIWMortgagee", new JSONArray(this.getGipiWMortgageeService().getGIPIWMortgagee(parId)));
		
		return formMap;
	}
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIWPolbas gipiWPolbas) throws JSONException {
		String[] lineSubLineParams = {gipiWPolbas.getLineCd(), StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		System.out.println("LINE: " + gipiWPolbas.getLineCd());
		System.out.println("SUBLINE: " + gipiWPolbas.getSublineCd());
		String[] groupParam = {gipiWPolbas.getAssdNo()};	
		String[] perilParam = {"" /*packLineCd*/, gipiWPolbas.getLineCd(), "" /*packSublineCd*/, StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), Integer.toString(gipiWPolbas.getParId())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] mortgParam = {String.valueOf(gipiWPolbas.getParId()), gipiWPolbas.getIssCd()};
		
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));								
		request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
		request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));
		//request.setAttribute("eqZoneList", lovHelper.getList(LOVHelper.EQ_ZONE_LISTING));
		//request.setAttribute("typhoonList", lovHelper.getList(LOVHelper.TYPHOON_ZONE_LISTING));
		request.setAttribute("itemTypeList", lovHelper.getList(LOVHelper.FIRE_ITEM_TYPE_LISTING));
		//request.setAttribute("floodList", lovHelper.getList(LOVHelper.FLOOD_ZONE_LISTING));
		request.setAttribute("regionList", lovHelper.getList(LOVHelper.REGION_LISTING));
		request.setAttribute("tariffZoneList", lovHelper.getList(LOVHelper.TARIFF_ZONE_LISTING, lineSubLineParams));
		request.setAttribute("tariffList", lovHelper.getList(LOVHelper.TARIFF_LISTING));
		//request.setAttribute("provinceList", lovHelper.getList(LOVHelper.PROVINCE_LISTING));
		//request.setAttribute("cityList", lovHelper.getList(LOVHelper.ALL_CITY_LISTING));
		//request.setAttribute("districtList", lovHelper.getList(LOVHelper.ALL_DISTRICT_LISTING));
		//request.setAttribute("blockList",lovHelper.getList(LOVHelper.ALL_BLOCK_LISTING));		
		//request.setAttribute("riskList", lovHelper.getList(LOVHelper.ALL_RISKS_LISTING));
		request.setAttribute("constructionList", lovHelper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
		//request.setAttribute("occupancyList", lovHelper.getList(LOVHelper.FIRE_OCCUPANCY_LISTING));
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));
		
		request.setAttribute("mortgageeListing", lovHelper.getList(LOVHelper.MORTGAGEE_LISTING_POLICY, mortgParam)); // mortgagee
	}
	
	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varVFireItemTypeBldg", newInstanceMap.get("varFireItemTypeBldg"));
		objVar.put("varVPar", JSONObject.NULL);		
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varOldCoverageCd", JSONObject.NULL);
		objVar.put("varOldCoverageDesc", JSONObject.NULL);
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varVCurrCd", JSONObject.NULL);
		objVar.put("varVSublineHtp", JSONObject.NULL);
		objVar.put("varVTyphoon", JSONObject.NULL);		
		objVar.put("varVIncept", JSONObject.NULL);
		objVar.put("varVExpiry", JSONObject.NULL);
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varNewSw", "Y");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varVRiskNo", JSONObject.NULL);
		objVar.put("varVCopyItemTag", false);
		
		return objVar;
	}
	
	private JSONObject createObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		
		objPar.put("paramParam1", newInstanceMap.get("parParam1"));
		objPar.put("paramParam2", newInstanceMap.get("parParam2"));
		objPar.put("paramParam3", newInstanceMap.get("parParam3"));
		objPar.put("paramParam4", newInstanceMap.get("parParam4"));
		objPar.put("paramParam5", newInstanceMap.get("parParam5"));
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency"));
		objPar.put("paramDefaultRegion", JSONObject.NULL);
		objPar.put("paramDfltCoverage", "");
		objPar.put("paramPreCommitSw", "Y");
		objPar.put("paramIsPack", newInstanceMap.get("isPack"));
		objPar.put("paramOra2010Sw", newInstanceMap.get("paramOra2010Sw"));
		
		return objPar;
	}	
	
	private JSONObject createObjectMiscVariables(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objMiscVar = new JSONObject();
		
		objMiscVar.put("miscDeletePolicyDeductibles", "N");
		objMiscVar.put("miscDeletePerilDiscById", "N");
		objMiscVar.put("miscDeleteItemDiscById", "N");
		objMiscVar.put("miscDeletePolbasDiscById", "N");
		objMiscVar.put("miscCopyPeril", "N");
		objMiscVar.put("miscNbtInvoiceSw", "N");
		objMiscVar.put("miscCopy", "N");
		objMiscVar.put("miscDisplayRisk", newInstanceMap.get("displayRisk"));
		objMiscVar.put("miscLocRisk1", newInstanceMap.get("locRisk1") == null ? JSONObject.NULL : newInstanceMap.get("locRisk1"));
		objMiscVar.put("miscLocRisk2", newInstanceMap.get("locRisk2") == null ? JSONObject.NULL : newInstanceMap.get("locRisk2"));
		objMiscVar.put("miscLocRisk3", newInstanceMap.get("locRisk3") == null ? JSONObject.NULL : newInstanceMap.get("locRisk3"));		
		
		return objMiscVar;
	}

	@Override
	public void saveGIPIWFireItm(String param, GIISUser USER)
			throws SQLException, JSONException, ParseException {		
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("fireItems", this.prepareGIPIWFireItmForInsertUpdate(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setMortgagees", this.getGipiWMortgageeService().prepareGIPIWMortgageeForInsert(new JSONArray(objParams.getString("setMortgagees"))));
		params.put("delMortgagees", this.getGipiWMortgageeService().prepareGIPIWMortgageeForDelete(new JSONArray(objParams.getString("delMortgagees"))));
		params.put("setDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParams.getString("setDeductRows"))));
		params.put("delDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParams.getString("delDeductRows"))));
		params.put("setPerils", this.getGipiWItemPerilService().prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("setPerils"))));
		params.put("delPerils", this.getGipiWItemPerilService().prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("delPerils"))));
				
		if(objParams.getString("parType").equals("E")){
			params.put("setWCs", this.getGipiWPolWCService().prepareDefaultGIPIWPolWC(new JSONArray(objParams.getString("setWCs"))));
		} else {
			params.put("setWCs", this.getGipiWPolWCService().prepareGIPIWPolWCForInsert(new JSONArray(objParams.getString("setWCs"))));
		}
		
		params.put("vars", new JSONObject(objParams.getString("vars")));
		params.put("pars", new JSONObject(objParams.getString("pars")));
		params.put("misc", new JSONObject(objParams.getString("misc")));
		
		params.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));
		
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("parType", objParams.getString("parType")); // andrew - 05.01.2011 - for endt
		
		params.put("userId", USER.getUserId());
		
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		this.getGipiWFireItemDAO().saveGIPIWFireItm(params);
	}	
	
	private List<GIPIWFireItm> prepareGIPIWFireItmForInsertUpdate(JSONArray setRows) throws JSONException {
		List<GIPIWFireItm> fireList = new ArrayList<GIPIWFireItm>();
		GIPIWFireItm fire = null;
		JSONObject objItem = null;
		JSONObject objFire = null;		
		
		for(int i=0, length=setRows.length(); i < length; i++){
			fire = new GIPIWFireItm();
			objItem = setRows.getJSONObject(i);
			objFire = objItem.isNull("gipiWFireItm") ? null : objItem.getJSONObject("gipiWFireItm");
			
			if(objFire != null){
				fire.setParId(objItem.isNull("parId") ? null : objItem.getInt("parId"));
				fire.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				fire.setDistrictNo(objFire.isNull("districtNo") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("districtNo")));
				fire.setEqZone(objFire.isNull("eqZone") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("eqZone")));
				fire.setTarfCd(objFire.isNull("tarfCd") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("tarfCd")));
				fire.setBlockNo(objFire.isNull("blockNo") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("blockNo")));
				fire.setFrItemType(objFire.isNull("frItemType") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("frItemType")));
				fire.setLocRisk1(objFire.isNull("locRisk1") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("locRisk1")));
				fire.setLocRisk2(objFire.isNull("locRisk2") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("locRisk2")));
				fire.setLocRisk3(objFire.isNull("locRisk3") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("locRisk3")));
				fire.setTariffZone(objFire.isNull("tariffZone") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("tariffZone")));
				fire.setTyphoonZone(objFire.isNull("typhoonZone") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("typhoonZone")));
				fire.setConstructionCd(objFire.isNull("constructionCd") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("constructionCd")));
				fire.setConstructionRemarks(objFire.isNull("constructionRemarks") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("constructionRemarks")));
				fire.setFront(objFire.isNull("front") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("front")));
				fire.setRight(objFire.isNull("right") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("right")));
				fire.setLeft(objFire.isNull("left") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("left")));
				fire.setRear(objFire.isNull("rear") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("rear")));
				fire.setOccupancyCd(objFire.isNull("occupancyCd") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("occupancyCd")));
				fire.setOccupancyRemarks(objFire.isNull("occupancyRemarks") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("occupancyRemarks")));
				fire.setOccupancyDesc(objFire.isNull("occupancyDesc")  ? null : StringFormatter.unescapeHtmlJava(objFire.getString("occupancyDesc"))); // added MARCh 7, 2012 - irwin
				fire.setAssignee(objFire.isNull("assignee") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("assignee")));
				fire.setFloodZone(objFire.isNull("floodZone") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("floodZone")));
				fire.setBlockId(objFire.isNull("blockId") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("blockId")));
				fire.setRiskCd(objFire.isNull("riskCd") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("riskCd")));
				fire.setLatitude(objFire.isNull("latitude") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("latitude"))); //Jerome 11.14.2016 SR 5749
				fire.setLongitude(objFire.isNull("longitude") ? null : StringFormatter.unescapeHtmlJava(objFire.getString("longitude"))); //Jerome 11.14.2016 SR 5749
				
				fireList.add(fire);
				fire = null;
			}
		}
		
		return fireList;
	}
	
	public Map<String, Object> gipis039NewFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();

		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); //benjo 01.10.2017 SR-5749

		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);

		newInstanceMap.put("parId", gipiWPolbas.getParId());
		this.getGipiWFireItemDAO().gipis039NewFormInstance(newInstanceMap);

		loadListingToRequest(request, lovHelper, gipiWPolbas);

		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("requireLatLong", giisParametersService.getParamValueV2("REQUIRE_LAT_LONG")); //benjo 01.10.2017 SR-5749
		request.setAttribute("isPack", request.getParameter("isPack"));
		request.setAttribute("parType", "E");
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyFI(parId)))); // andrew - 07102015 - 18164
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		formMap.put("vars", this.gipis039CreateObjectVariable(newInstanceMap));
		formMap.put("pars", this.gipis039CreateObjectParameter(newInstanceMap));
		formMap.put("misc", this.gipis039CreateObjectMiscVariables(newInstanceMap));
		formMap.put("itemFires", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemFI(parId)))); //apollo cruz 05.29.2015 - added escapeHTMLInJSONArray sr#19286 
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		formMap.put("objGIPIWMortgagee", new JSONArray(this.getGipiWMortgageeService().getGIPIWMortgagee(parId)));
		GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
		try {//monmon
			formMap.put("itemAnnTsiPrem", new JSONArray(gipiItemService.getItemAnnTsiPrem(parId)));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return formMap;
	}
	
	private JSONObject gipis039CreateObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();		  	  
		objVar.put("varFireItemTypeBldg", newInstanceMap.get("fireItemTypeBldg"));
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varOldCoverageCd", JSONObject.NULL);
		objVar.put("varOldCoverageDesc", JSONObject.NULL);
		objVar.put("varCount", JSONObject.NULL);
		objVar.put("varPackPolFlag", JSONObject.NULL);
		objVar.put("varItemTag", JSONObject.NULL);
		objVar.put("varSwitchRecFlag", JSONObject.NULL);
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varGroupSw", "N");
		objVar.put("varTyphoon", JSONObject.NULL);
		objVar.put("varOccupancy", JSONObject.NULL);
		objVar.put("varConstruction", JSONObject.NULL);
		objVar.put("varEffDate", JSONObject.NULL);
		objVar.put("varEndtExpiryDate", JSONObject.NULL);
		objVar.put("varShortRtPercent", JSONObject.NULL);
		objVar.put("varProvPremTag", JSONObject.NULL);
		objVar.put("varProvPremPct", JSONObject.NULL);
		objVar.put("varProrateFlag", JSONObject.NULL);
		objVar.put("varCompSw", JSONObject.NULL);
		objVar.put("varCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varNewSw", "Y");
		objVar.put("varNewSw2", "Y");
		objVar.put("varDiscExist", "N");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varEndtTaxSw", newInstanceMap.get("endtTaxSw"));
		objVar.put("varWithPerilSw", JSONObject.NULL);
		objVar.put("varExpiryDate", JSONObject.NULL);							
		objVar.put("varNegateItem", "N");		
		objVar.put("varRiskNo", JSONObject.NULL);
		objVar.put("varCopyItemTag", false);
		
		return objVar;
	}
	
	private JSONObject gipis039CreateObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency"));
		objPar.put("paramAddDeleteSw", JSONObject.NULL);
		objPar.put("paramPolFlagSw", "N");		
		
		return objPar;
	}
	
	private JSONObject gipis039CreateObjectMiscVariables(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objMiscVar = new JSONObject();
		
		objMiscVar.put("miscDeletePolicyDeductibles", "N");
		objMiscVar.put("miscDeletePerilDiscById", "N");
		objMiscVar.put("miscDeleteItemDiscById", "N");
		objMiscVar.put("miscDeletePolbasDiscById", "N");
		objMiscVar.put("miscCopyPeril", "N");
		objMiscVar.put("miscNbtInvoiceSw", "N");
		objMiscVar.put("miscCopy", "N");
		//shan 07.15.2013; SR-13585: added replaceQuotes function
		objMiscVar.put("miscLocRisk1", newInstanceMap.get("locRisk1") == null ? JSONObject.NULL : StringFormatter.replaceQuotes(newInstanceMap.get("locRisk1").toString()));
		objMiscVar.put("miscLocRisk2", newInstanceMap.get("locRisk2") == null ? JSONObject.NULL : StringFormatter.replaceQuotes(newInstanceMap.get("locRisk2").toString()));
		objMiscVar.put("miscLocRisk3", newInstanceMap.get("locRisk3") == null ? JSONObject.NULL : StringFormatter.replaceQuotes(newInstanceMap.get("locRisk3").toString()));
		
		objMiscVar.put("miscDisplayRisk", newInstanceMap.get("displayRisk"));		
		objMiscVar.put("miscAllowUpdateCurrRate", newInstanceMap.get("allowUpdateCurrRate"));
		objMiscVar.put("miscFireItemType", newInstanceMap.get("fireItemType"));
		objMiscVar.put("miscSublineHtp", newInstanceMap.get("sublineHtp"));
		
		return objMiscVar;
	}

	@Override
	public void gipis03B9540WhenValidateItem(Map<String, Object> params)
			throws SQLException {
		this.getGipiWFireItemDAO().gipis03B9540WhenValidateItem(params);
	}

	@Override
	public Map<String, Object> newFormInstanceTG(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		
		//int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId")); // andrew - 07.08.2011
		int parId = Integer.parseInt(request.getParameter("parId"));
		
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWFireItemDAO().gipis003NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("requireLatLong", giisParametersService.getParamValueV2("REQUIRE_LAT_LONG")); //benjo 01.10.2017 SR-5749
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));
		newInstanceMap.put("paramOra2010Sw", giisParametersService.getParamValueV2("ORA2010_SW")); // added by: Nica 10.15.2012
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridFI");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		//Map<String, Object> itemFireTableGrid = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemFireTableGrid = TableGridUtil.getTableGrid3(request, tgParams); //replaced by: Mark C. 04162015 SR4302
		//itemFireTableGrid.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemFI(parId)));
		itemFireTableGrid.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemFI(parId)))); //replaced by: Mark C. 04162015 SR4302
		itemFireTableGrid.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemFireTableGrid.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		itemFireTableGrid.put("gipiWMortgagee", new JSONArray(this.getGipiWMortgageeService().getGIPIWMortgagee(parId)));
		request.setAttribute("itemTableGrid", new JSONObject(itemFireTableGrid));	

		return formMap;
	}

	@Override
	public Map<String, Object> getTariffZoneOccupancyValue(Map<String, Object> params) throws SQLException {
		return getGipiWFireItemDAO().getTariffZoneOccupancyValue(params);
	}
	
}
