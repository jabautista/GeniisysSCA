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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWCargoDAO;
import com.geniisys.gipi.entity.GIPIWCargo;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWCargoCarrierService;
import com.geniisys.gipi.service.GIPIWCargoService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.service.GIPIWVesAccumulationService;
import com.geniisys.gipi.service.GIPIWVesAirService;
import com.geniisys.gipi.util.DateFormatter;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;
import common.Logger;

public class GIPIWCargoServiceImpl implements GIPIWCargoService{

	private GIPIWCargoDAO gipiWCargoDAO;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWItemService gipiWItemService;	
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWCargoCarrierService gipiWCargoCarrierService;
	private GIPIWVesAirService gipiWVesAirService;
	private GIPIWVesAccumulationService gipiWVesAccumulationService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;
		
	private static Logger log = Logger.getLogger(GIPIWCargoCarrierServiceImpl.class);
	
	public void setGipiWCargoDAO(GIPIWCargoDAO gipiWCargoDAO) {
		this.gipiWCargoDAO = gipiWCargoDAO;
	}

	public GIPIWCargoDAO getGipiWCargoDAO() {
		return gipiWCargoDAO;
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

	public GIPIWVesAirService getGipiWVesAirService() {
		return gipiWVesAirService;
	}

	public void setGipiWVesAirService(GIPIWVesAirService gipiWVesAirService) {
		this.gipiWVesAirService = gipiWVesAirService;
	}
	
	public void setGipiWDeductibleService(GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}

	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}

	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}

	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	public void setGipiWCargoCarrierService(GIPIWCargoCarrierService gipiWCargoCarrierService) {
		this.gipiWCargoCarrierService = gipiWCargoCarrierService;
	}

	public GIPIWCargoCarrierService getGipiWCargoCarrierService() {
		return gipiWCargoCarrierService;
	}	

	public GIPIWVesAccumulationService getGipiWVesAccumulationService() {
		return gipiWVesAccumulationService;
	}

	public void setGipiWVesAccumulationService(
			GIPIWVesAccumulationService gipiWVesAccumulationService) {
		this.gipiWVesAccumulationService = gipiWVesAccumulationService;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCargo> getGipiWCargo(Integer parId) throws SQLException {
		return (List<GIPIWCargo>) StringFormatter.replaceQuotesInList(gipiWCargoDAO.getGipiWCargo(parId));
	}

	@Override
	public void saveGIPIParMarineCargo(Map<String, Object> params)
			throws SQLException {
		this.gipiWCargoDAO.saveGIPIParMarineCargo(params);
	}
	
	public void saveGIPIEndtMarineCargo(Map<String, Object> params) throws SQLException, JSONException, ParseException {
		JSONArray setRows = (JSONArray) params.get("setRows");
		JSONArray delRows = (JSONArray) params.get("delRows");
		//GIPIWDeductibleFacadeService gipiWDeductibleService = new GIPIWDeductibleFacadeServiceImpl(); 

		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setItems", this.prepareGIPIWItemForInsert(setRows));
		allParams.put("delItems", this.prepareGIPIWItemForDelete(delRows));
		allParams.put("itemDeductibles", this.getGipiWDeductibleService().prepareGIPIWDeductible(params));
		this.getGipiWCargoDAO().saveGIPIEndtMarineCargo(allParams);
	}
	
	public List<GIPIWItem> prepareGIPIWItemForInsert(JSONArray setRows) throws JSONException, ParseException {
		GIPIWItem item = null;
		GIPIWCargo cargo = null;
		JSONObject json = null;
		List<GIPIWItem> setItems = new ArrayList<GIPIWItem>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		for(int index=0; index<setRows.length(); index++) {
			json = setRows.getJSONObject(index);
			
			item = new GIPIWItem();						
			item.setParId(json.isNull("parId") ? null : json.getInt("parId"));
			item.setItemNo(json.isNull("itemNo") ? null : json.getInt("itemNo"));
			item.setItemTitle(json.isNull("itemTitle") ? null : json.getString("itemTitle"));
			item.setItemDesc(json.isNull("itemDesc") ? null : json.getString("itemDesc"));
			item.setItemDesc2(json.isNull("itemDesc2") ? null : json.getString("itemDesc2"));			
			item.setAnnPremAmt(json.isNull("annPremAmt") ? null : new BigDecimal(json.getString("annPremAmt")));
			item.setAnnTsiAmt(json.isNull("annTsiAmt") ? null : new BigDecimal(json.getString("annTsiAmt")));
			item.setCurrencyCd(json.isNull("currencyCd") ? null : json.getInt("currencyCd"));
			item.setCurrencyRt(json.isNull("currencyRt") ? null : new BigDecimal(json.getString("currencyRt")));
			item.setGroupCd(json.isNull("groupCd") ? null : json.getInt("groupCd"));
			item.setRegionCd(json.isNull("regionCd") ? null : json.getInt("regionCd"));
			item.setOtherInfo(json.isNull("otherInfo") ? null : json.getString("otherInfo"));
			item.setRecFlag(json.isNull("recFlag") ? null : json.getString("recFlag"));
			
			cargo = new GIPIWCargo();			
			cargo.setParId(json.isNull("parId") ? null : json.getString("parId"));
			cargo.setItemNo(json.isNull("itemNo") ? null : json.getString("itemNo"));
			cargo.setGeogCd(json.isNull("geogCd") ? null : json.getString("geogCd"));
			cargo.setVesselCd(json.isNull("vesselCd") ? null : json.getString("vesselCd"));
			cargo.setCargoClassCd(json.isNull("cargoClassCd") ? null : json.getString("cargoClassCd"));
			cargo.setCargoType(json.isNull("cargoType") ? null : json.getString("cargoType"));
			cargo.setPackMethod(json.isNull("packMethod") ? null : json.getString("packMethod"));
			cargo.setBlAwb(json.isNull("blAwb") ? null : json.getString("blAwb"));
			cargo.setTranshipOrigin(json.isNull("transhipOrigin") ? null : json.getString("transhipOrigin"));
			cargo.setTranshipDestination(json.isNull("transhipDestination") ? null : json.getString("transhipDestination"));
			cargo.setDeductText(json.isNull("deductText") ? null : json.getString("deductText"));
			cargo.setVoyageNo(json.isNull("voyageNo") ? null : json.getString("voyageNo"));
			cargo.setLcNo(json.isNull("lcNo") ? null : json.getString("lcNo"));
			cargo.setEtd(json.isNull("etd") ? null : df.parse(json.getString("etd")));
			cargo.setEta(json.isNull("eta") ? null : df.parse(json.getString("eta")));
			cargo.setPrintTag(json.isNull("printTag") ? null : json.getString("printTag"));
			cargo.setOrigin(json.isNull("origin") ? null : json.getString("origin"));
			cargo.setDestn(json.isNull("destn") ? null : json.getString("destn"));
			cargo.setInvCurrCd(json.isNull("invCurrCd") ? null : json.getString("invCurrCd"));
			cargo.setInvCurrRt(json.isNull("invCurrRt") ? null : json.getString("invCurrRt"));
			cargo.setInvoiceValue(json.isNull("invoiceValue") ? null : new BigDecimal(json.getString("invoiceValue")));
			cargo.setMarkupRate(json.isNull("markupRate") ? null : json.getString("markupRate"));
			cargo.setRecFlagWCargo(json.isNull("recFlagWCargo") ? null : json.getString("recFlagWCargo"));
			
			item.setGipiWCargo(cargo);
			setItems.add(item);
		}	
		return setItems;
	}
	
	public List<Map<String, Object>> prepareGIPIWItemForDelete(JSONArray delRows) throws JSONException{
		List<Map<String, Object>> delItems = new ArrayList<Map<String,Object>>();
		Map<String, Object> delItem = null;
		for(int index=0; index<delRows.length(); index++) {
			delItem = new HashMap<String, Object>();
			delItem.put("parId", delRows.getJSONObject(index).isNull("parId") ? null : delRows.getJSONObject(index).getInt("parId"));
			delItem.put("itemNo", delRows.getJSONObject(index).isNull("itemNo") ? null : delRows.getJSONObject(index).getInt("itemNo"));
			
			delItems.add(delItem);
		}
		return delItems;
	}

	@Override
	public boolean saveMarineCargoItem(Map<String, Object> param)
			throws SQLException {
		return this.gipiWCargoDAO.saveMarineCargoItem(param);
	}
	
	public boolean saveGIPIEndtMarineCargoItem(String parameters) throws JSONException, ParseException, SQLException {
		JSONObject objParameters = new JSONObject(parameters);
		
		log.info("Saving endt marine cargo item information...");
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("miscVariables", new JSONObject(objParameters.getString("miscVariables")));
		allParams.put("formVariables", new JSONObject(objParameters.getString("formVariables")));
		allParams.put("setItems", this.prepareGIPIWItemForInsert(new JSONArray(objParameters.getString("setItemRows"))));
		allParams.put("delItems", this.prepareGIPIWItemForDelete(new JSONArray(objParameters.getString("delItemRows"))));
		allParams.put("setItemPerils", this.getGipiWItemPerilService().prepareEndtItemPerilForInsert(new JSONArray(objParameters.getString("setItemPerils"))));
		allParams.put("delItemPerils", this.getGipiWItemPerilService().prepareEndtItemPerilForDelete(new JSONArray(objParameters.getString("delItemPerils"))));
		allParams.put("setDeductibles", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParameters.getString("setDeductibles"))));
		allParams.put("delDeductibles", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParameters.getString("delDeductibles"))));
		allParams.put("setPerilWCs", this.getGipiWItemPerilService().preparePerilWCs(new JSONArray(objParameters.getString("setPerilWCs"))));
		allParams.put("setCargoCarriers", this.getGipiWCargoCarrierService().prepareGIPIWCargoCarrierForInsert(new JSONArray(objParameters.getString("setCargoCarriers"))));
		allParams.put("delCargoCarriers", this.getGipiWCargoCarrierService().prepareGIPIWCargoCarrierForDelete(new JSONArray(objParameters.getString("delCargoCarriers"))));
		
		this.getGipiWCargoDAO().saveGIPIEndtMarineCargo(allParams);
		log.info("Endt marine cargo item information saved.");
		
		return true;
	}

	

	@Override
	public Map<String, Object> gipis068NewFormInstance(Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWCargoDAO().gipis006NewFormInstance(newInstanceMap);
		
		request.setAttribute("parType", "E");
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package		
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyMN(parId)))); // andrew - 07152015 - SR 19806
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("itemCargos", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMN(parId))));  // andrew - 07152015 - SR 19806
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		formMap.put("gipiWCargoCarrier", new JSONArray(this.getGipiWCargoCarrierService().getGipiWCargoCarrier(parId)));
		formMap.put("gipiWVesAir", new JSONArray(this.getGipiWVesAirService().getWVesAir(parId)));
		formMap.put("gipiWVesAccumulation", new JSONArray(this.getGipiWVesAccumulationService().getGIPIWVesAccumulation(parId)));
		GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
		try {//monmon
			formMap.put("itemAnnTsiPrem", new JSONArray(gipiItemService.getItemAnnTsiPrem(parId)));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return formMap;		
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
		newInstanceMap = this.getGipiWCargoDAO().gipis006NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("itemCargos", new JSONArray(this.getGipiWItemService().getParItemMN(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		formMap.put("gipiWCargoCarrier", new JSONArray(this.getGipiWCargoCarrierService().getGipiWCargoCarrier(parId)));
		formMap.put("gipiWVesAir", new JSONArray(this.getGipiWVesAirService().getWVesAir(parId)));
		formMap.put("gipiWVesAccumulation", new JSONArray(this.getGipiWVesAccumulationService().getGIPIWVesAccumulation(parId)));
		
		return formMap;
	}
	
	/**
	 * 
	 * @param request
	 * @param lovHelper
	 * @param gipiWPolbas
	 */
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIWPolbas gipiWPolbas){
		String parType = (String) request.getAttribute("parType");
		String[] lineSubLineParams = {gipiWPolbas.getLineCd(), StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] groupParam = {gipiWPolbas.getAssdNo()};
		String[] parIdParam = {String.valueOf(gipiWPolbas.getParId())};
		String[] printParam = {"GIPI_WCARGO.PRINT_TAG"};
		String[] perilParam = {"" /*packLineCd*/, gipiWPolbas.getLineCd(), "" /*packSublineCd*/, StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), Integer.toString(gipiWPolbas.getParId())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));								
		request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
		request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));
		request.setAttribute("geogListing", lovHelper.getList(parType != null && parType.equals("E") ? LOVHelper.ENDT_GEOG_LISTING : LOVHelper.GEOG_LISTING1, parIdParam));
		request.setAttribute("vesselListing", lovHelper.getList(parType != null && parType.equals("E") ? LOVHelper.VESSEL_CARRIER_LISTING2 : LOVHelper.VESSEL_LISTING2, parIdParam));
		request.setAttribute("cargoClassListing", lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING));
		request.setAttribute("cargoTypeListing", lovHelper.getList(LOVHelper.CARGO_TYPE_LISTING));
		request.setAttribute("printTagListing", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING,printParam));
		request.setAttribute("invoiceListing", lovHelper.getList(LOVHelper.CURRENCY_CODES2));
		request.setAttribute("vesselCarrierListing", lovHelper.getList(LOVHelper.VESSEL_CARRIER_LISTING,parIdParam));
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));//belle
	}
	
	/**
	 * 
	 * @param newInstanceMap
	 * @return
	 * @throws JSONException
	 */
	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varVRecCount", JSONObject.NULL);
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varInsertDeleteSw", JSONObject.NULL);
		objVar.put("varVPar", JSONObject.NULL);
		//objVar.put("varPost", "Y"); belle 03282011 for confirmation to m'grace
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varVOldGeogCd", JSONObject.NULL);
		objVar.put("varVOldGeogClass", JSONObject.NULL);
		objVar.put("varVOldGeogDesc", JSONObject.NULL);
		objVar.put("varVDateFormat", JSONObject.NULL);
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varSwitchDelete", "N");
		objVar.put("varSwitchInsert", "N");
		objVar.put("varDefaultSw", "N");
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varVCurrCd", JSONObject.NULL);
		objVar.put("varVMultiCarrier", newInstanceMap.get("multiCarrier") == null ? JSONObject.NULL : newInstanceMap.get("multiCarrier"));
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varVValidateSw", "Y");
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varVCopyItemTag", false);
		objVar.put("varVInvCurrRtOld", JSONObject.NULL);
		objVar.put("varVInvoiceValueOld", JSONObject.NULL);
		objVar.put("varVMarkupRateOld", JSONObject.NULL);
		objVar.put("varVInvCurrRtNew", JSONObject.NULL);
		objVar.put("varVInvoiceValueNew", JSONObject.NULL);
		objVar.put("varVMarkupRateNew", JSONObject.NULL);
		objVar.put("varMarkupTag", newInstanceMap.get("markupTag") == null ? JSONObject.NULL : newInstanceMap.get("markupTag"));
		
		return objVar;
	}
	
	/**
	 * 
	 * @param newInstanceMap
	 * @return
	 * @throws JSONException
	 */
	private JSONObject createObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		
		objPar.put("paramRenumSw", "N");
		objPar.put("paramPostRecSwitch", "N");
		objPar.put("paramCarrierSw", "N");
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency") == null ? JSONObject.NULL : newInstanceMap.get("defaultCurrency"));
		objPar.put("paramDefaultRegion", newInstanceMap.get("defaultRegion") == null ? JSONObject.NULL : newInstanceMap.get("defaultRegion"));
		objPar.put("paramDfltCoverage", "");
		objPar.put("paramOra2010Sw", newInstanceMap.get("ora2010Sw") == null ? JSONObject.NULL : newInstanceMap.get("ora2010Sw"));
		objPar.put("paramDefaultPrintTag", newInstanceMap.get("defaultPrintTag") == null ? JSONObject.NULL : newInstanceMap.get("defaultPrintTag"));
		objPar.put("paramIsPack", newInstanceMap.get("isPack"));
		
		return objPar;
	}
	
	/**
	 * 
	 * @param newInstanceMap
	 * @return
	 * @throws JSONException
	 */
	private JSONObject createObjectMiscVariables(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objMiscVar = new JSONObject();
		
		objMiscVar.put("miscDeletePolicyDeductibles", "N");
		objMiscVar.put("miscDeletePerilDiscById", "N");
		objMiscVar.put("miscDeleteItemDiscById", "N");
		objMiscVar.put("miscDeletePolbasDiscById", "N");
		objMiscVar.put("miscCopyPeril", "N");
		objMiscVar.put("miscNbtInvoiceSw", "N");
		objMiscVar.put("miscCopy", "N");				
		
		return objMiscVar;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCargoService#saveGIPIWCargo(java.lang.String, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void saveGIPIWCargo(String param, GIISUser USER)
			throws SQLException, JSONException, ParseException {		
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("cargoItems", this.prepareGIPIWCargoForInsertUpdate(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setCarrierRows", this.getGipiWCargoCarrierService().prepareGIPIWCargoCarrierForInsert(new JSONArray(objParams.getString("setCarrierRows"))));
		params.put("delCarrierRows", this.getGipiWCargoCarrierService().prepareGIPIWCargoCarrierForDelete(new JSONArray(objParams.getString("delCarrierRows"))));
		params.put("delVesAccumuRows", this.getGipiWVesAccumulationService().prepareGIPIWVesAccumulationForDelete(new JSONArray(objParams.getString("delVesAccumuRows"))));
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
		params.put("userId", USER.getUserId());
		params.put("parType", objParams.getString("parType")); // andrew - 05.01.2011 - for endt
		
		//to include parameters needed for peril updates 
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		this.getGipiWCargoDAO().saveGIPIWCargo(params);
	}
	
	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIPIWCargo> prepareGIPIWCargoForInsertUpdate(JSONArray setRows) throws JSONException, ParseException {
		List<GIPIWCargo> cargoList = new ArrayList<GIPIWCargo>();
		//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		GIPIWCargo cargo = null;
		JSONObject objItem = null;
		JSONObject objCargo = null;
		
		for(int i=0, length=setRows.length(); i<length; i++){
			cargo = new GIPIWCargo();
			objItem = setRows.getJSONObject(i);
			objCargo = objItem.isNull("gipiWCargo") ? null : objItem.getJSONObject("gipiWCargo");
			
			if(objCargo != null){				
				cargo.setParId(objItem.isNull("parId") ? null : objItem.getString("parId"));
				cargo.setItemNo(objItem.isNull("itemNo") ? null : objItem.getString("itemNo"));
				cargo.setRecFlagWCargo(objCargo.isNull("recFlagWCargo") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("recFlagWCargo")));
				cargo.setPrintTag(objCargo.isNull("printTag") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("printTag")));
				cargo.setVesselCd(objCargo.isNull("vesselCd") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("vesselCd")));
				cargo.setGeogCd(objCargo.isNull("geogCd") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("geogCd")));
				cargo.setCargoClassCd(objCargo.isNull("cargoClassCd") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("cargoClassCd")));
				cargo.setVoyageNo(objCargo.isNull("voyageNo") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("voyageNo")));
				cargo.setBlAwb(objCargo.isNull("blAwb") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("blAwb")));
				cargo.setOrigin(objCargo.isNull("origin") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("origin")));
				cargo.setDestn(objCargo.isNull("destn") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("destn")));
				cargo.setEtd(objCargo.isNull("etd") ? null : (objCargo.getString("etd").equals("") ? null : DateFormatter.formatDate(objCargo.getString("etd"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
				cargo.setEta(objCargo.isNull("eta") ? null : (objCargo.getString("eta").equals("") ? null : DateFormatter.formatDate(objCargo.getString("eta"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
				cargo.setCargoType(objCargo.isNull("cargoType") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("cargoType")));
				cargo.setDeductText(objCargo.isNull("deductText") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("deductText")));
				cargo.setPackMethod(objCargo.isNull("packMethod") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("packMethod")));
				cargo.setTranshipOrigin(objCargo.isNull("transhipOrigin") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("transhipOrigin")));
				cargo.setTranshipDestination(objCargo.isNull("transhipDestination") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("transhipDestination")));
				cargo.setLcNo(objCargo.isNull("lcNo") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("lcNo")));
				cargo.setCpiRecNo(objCargo.isNull("cpiRecNo") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("cpiRecNo")));
				cargo.setCpiBranchCd(objCargo.isNull("cpiBranchCd") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("cpiBranchCd")));
				cargo.setInvoiceValue(objCargo.isNull("invoiceValue") ? null : new BigDecimal(objCargo.getString("invoiceValue").replaceAll(",", "")));
				cargo.setInvCurrCd(objCargo.isNull("invCurrCd") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("invCurrCd")));
				cargo.setInvCurrRt(objCargo.isNull("invCurrRt") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("invCurrRt")));
				cargo.setMarkupRate(objCargo.isNull("markupRate") ? null : StringFormatter.unescapeHtmlJava(objCargo.getString("markupRate")));
				cargo.setRecFlag(objCargo.isNull("recFlag")? null : StringFormatter.unescapeHtmlJava(objCargo.getString("recFlag")));
				
				cargoList.add(cargo);
				cargo = null;
			}
		}		
		
		return cargoList;
	}

	public void setGipiWPolWCService(GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}

	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}

	@Override
	public Map<String, Object> newFormInstanceTG(Map<String, Object> params)
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
		newInstanceMap = this.getGipiWCargoDAO().gipis006NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("itemCargos", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMN(parId))));	//Gzelle 06022015 SR4302
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		//formMap.put("gipiWCargoCarrier", new JSONArray(this.getGipiWCargoCarrierService().getGipiWCargoCarrier(parId)));
		//formMap.put("gipiWVesAir", new JSONArray(this.getGipiWVesAirService().getWVesAir(parId)));
		//formMap.put("gipiWVesAccumulation", new JSONArray(this.getGipiWVesAccumulationService().getGIPIWVesAccumulation(parId)));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridMN");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		//Map<String, Object> itemMarineCargoTableGrid = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemMarineCargoTableGrid = TableGridUtil.getTableGrid3(request, tgParams); //replaced by: Mark C. 04162015 SR4302
		//itemMarineCargoTableGrid.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemMN(parId)));
		itemMarineCargoTableGrid.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMN(parId)))); //replaced by: Mark C. 04162015 SR4302
		itemMarineCargoTableGrid.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemMarineCargoTableGrid.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		itemMarineCargoTableGrid.put("gipiWVesAir", new JSONArray(this.getGipiWVesAirService().getWVesAir(parId)));
		itemMarineCargoTableGrid.put("gipiWVesAccumulation", new JSONArray(this.getGipiWVesAccumulationService().getGIPIWVesAccumulation(parId)));
		itemMarineCargoTableGrid.put("gipiWCargoCarrier", new JSONArray(this.getGipiWCargoCarrierService().getGipiWCargoCarrier(parId)));
		request.setAttribute("itemTableGrid", new JSONObject(itemMarineCargoTableGrid));
		
		return formMap;
	}
}
