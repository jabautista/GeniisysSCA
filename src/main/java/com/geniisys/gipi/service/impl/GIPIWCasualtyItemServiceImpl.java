package com.geniisys.gipi.service.impl;

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
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWCasualtyItemDAO;
import com.geniisys.gipi.entity.GIPIWCasualtyItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWCasualtyItemService;
import com.geniisys.gipi.service.GIPIWCasualtyPersonnelService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;

public class GIPIWCasualtyItemServiceImpl implements GIPIWCasualtyItemService{

	private GIPIWCasualtyItemDAO gipiWCasualtyDAO;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWItemService gipiWItemService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWGroupedItemsService gipiWGroupedItemsService;
	private GIPIWCasualtyPersonnelService gipiWCasualtyPersonnelService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;

	public GIPIWCasualtyItemDAO getGipiWCasualtyDAO() {
		return gipiWCasualtyDAO;
	}

	public void setGipiWCasualtyDAO(GIPIWCasualtyItemDAO gipiWCasualtyDAO) {
		this.gipiWCasualtyDAO = gipiWCasualtyDAO;
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

	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}

	public void setGipiWDeductibleService(
			GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}
	
	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}	

	public GIPIWPerilDiscountService getGipiWPerilDiscountService() {
		return gipiWPerilDiscountService;
	}

	public void setGipiWPerilDiscountService(
			GIPIWPerilDiscountService gipiWPerilDiscountService) {
		this.gipiWPerilDiscountService = gipiWPerilDiscountService;
	}	

	public GIPIWGroupedItemsService getGipiWGroupedItemsService() {
		return gipiWGroupedItemsService;
	}

	public void setGipiWGroupedItemsService(
			GIPIWGroupedItemsService gipiWGroupedItemsService) {
		this.gipiWGroupedItemsService = gipiWGroupedItemsService;
	}

	public GIPIWCasualtyPersonnelService getGipiWCasualtyPersonnelService() {
		return gipiWCasualtyPersonnelService;
	}

	public void setGipiWCasualtyPersonnelService(
			GIPIWCasualtyPersonnelService gipiWCasualtyPersonnelService) {
		this.gipiWCasualtyPersonnelService = gipiWCasualtyPersonnelService;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCasualtyItem> getGipiWCasualtyItem(Integer parId)
			throws SQLException {
		return (List<GIPIWCasualtyItem>) StringFormatter.replaceQuotesInList(this.gipiWCasualtyDAO.getGipiWCasualtyItem(parId));
	}

	@Override
	public void saveGIPIParCasualtyItem(Map<String, Object> params)
			throws SQLException {
		this.gipiWCasualtyDAO.saveGIPIParCasualtyItem(params);
	}

	@Override
/*	public Map<String, Object> gipis061NewFormInstance(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWCasualtyDAO().gipis061NewFormInstance(params);
	}*/

	public void saveGIPIEndtCasualtyItem(String param, GIISUser user) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("casualtyItems", this.prepareGIPIWCasualtyItemForInsert(new JSONArray(objParams.getString("setItemRows"))));		
		params.put("setGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(objParams.getString("setGrpItmRows"))));
		params.put("delGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForDelete(new JSONArray(objParams.getString("delGrpItmRows"))));
		params.put("setPersonnels", this.getGipiWCasualtyPersonnelService().prepareGIPIWCasualtyPersonnelForInsertUpdate(new JSONArray(objParams.getString("setCasPerRows"))));
		params.put("delPersonnels", this.getGipiWCasualtyPersonnelService().prepareGIPIWCasualtyPersonnelForDelete(new JSONArray(objParams.getString("delCasPerRows"))));
		params.put("setDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParams.getString("setDeductRows"))));
		params.put("delDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParams.getString("delDeductRows"))));
		params.put("setItemPerils", this.getGipiWItemPerilService().prepareEndtItemPerilForInsert(new JSONArray(objParams.getString("setItemPerils"))));
		params.put("delItemPerils", this.getGipiWItemPerilService().prepareEndtItemPerilForDelete(new JSONArray(objParams.getString("delItemPerils"))));
		params.put("setPerilWCs", this.getGipiWItemPerilService().preparePerilWCs(new JSONArray(objParams.getString("setPerilWCs"))));
		
		params.put("vars", new JSONArray(objParams.getString("vars")));
		params.put("pars", new JSONArray(objParams.getString("pars")));
		params.put("misc", new JSONArray(objParams.getString("misc")));
		params.put("itemNoList", this.getItemNoListFromView(new JSONArray(objParams.getString("itemNoList"))));
		
		params.put("gipiWPolbas", this.getGipiWPolbasService().getGipiWPolbas(objParams.getInt("parId")));
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));		
		params.put("userId", user.getUserId());		
		
		this.getGipiWCasualtyDAO().saveGIPIEndtCasualtyItem(params);
	}
	
	private List<GIPIWCasualtyItem> prepareGIPIWCasualtyItemForInsert(JSONArray setRows) throws JSONException{
		List<GIPIWCasualtyItem> casualtyItemList = new ArrayList<GIPIWCasualtyItem>();
		GIPIWCasualtyItem casualtyItem = null;
		JSONObject objItem = null;
		JSONObject objCasualty = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			//if(setRows.getJSONObject(i).getInt("masterDetail") > 0){
				casualtyItem = new GIPIWCasualtyItem();				
				objItem = setRows.getJSONObject(i);
				objCasualty = objItem.isNull("gipiWCasualtyItem") ? null : objItem.getJSONObject("gipiWCasualtyItem");
				
				if(objCasualty != null){
					casualtyItem.setParId(objItem.isNull("parId") ? null : objItem.getString("parId"));
					casualtyItem.setItemNo(objItem.isNull("itemNo") ? null : objItem.getString("itemNo"));
					casualtyItem.setSectionLineCd(objCasualty.isNull("sectionLineCd") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("sectionLineCd")));
					casualtyItem.setSectionSublineCd(objCasualty.isNull("sectionSublineCd") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("sectionSublineCd")));
					casualtyItem.setSectionOrHazardCd(objCasualty.isNull("sectionOrHazardCd") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("sectionOrHazardCd")));
					casualtyItem.setPropertyNoType(objCasualty.isNull("propertyNoType") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("propertyNoType")));
					casualtyItem.setCapacityCd(objCasualty.isNull("capacityCd") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("capacityCd")));
					casualtyItem.setPropertyNo(objCasualty.isNull("propertyNo") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("propertyNo")));
					casualtyItem.setLocation(objCasualty.isNull("location") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("location")));
					casualtyItem.setConveyanceInfo(objCasualty.isNull("conveyanceInfo") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("conveyanceInfo")));
					casualtyItem.setLimitOfLiability(objCasualty.isNull("limitOfLiability") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("limitOfLiability")));
					casualtyItem.setInterestOnPremises(objCasualty.isNull("interestOnPremises") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("interestOnPremises")));
					casualtyItem.setSectionOrHazardInfo(objCasualty.isNull("sectionOrHazardInfo") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("sectionOrHazardInfo")));
					casualtyItem.setLocationCd(objCasualty.isNull("locationCd") ? null : StringFormatter.unescapeHtmlJava(objCasualty.getString("locationCd")));
					
					casualtyItemList.add(casualtyItem);
					casualtyItem = null;				
				}				
			//}			
		}
		
		return casualtyItemList;
	}
	
	private Map<String, Integer> getItemNoListFromView(JSONArray itemNoList) throws JSONException{
		Map<String, Integer> itemMap = new HashMap<String, Integer>();
		
		for(int i=0, length=itemNoList.length(); i < length; i++){			
			itemMap.put(itemNoList.getJSONObject(i).getString("itemNo"), itemNoList.getJSONObject(i).getInt("itemNo"));			
		}
		
		return itemMap;	
	}

	@Override
	public boolean saveCasualtyItem(Map<String, Object> param)
			throws SQLException {
		return this.gipiWCasualtyDAO.saveCasualtyItem(param);
	}

	@Override
	public Map<String, Object> newFormInstace(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		//int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId")); // andrew - 07.08.2011
		int parId = Integer.parseInt(request.getParameter("parId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWCasualtyDAO().gipis011NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPolbas", gipiWPolbas);
		formMap.put("itemCasualties", new JSONArray(this.getGipiWItemService().getParItemCA(parId)));
		formMap.put("groupedItems", new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems(parId)));
		formMap.put("casualtyPersonnels", new JSONArray(this.getGipiWCasualtyPersonnelService().getGipiWCasualtyPersonnel(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		
		return formMap;
	}
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIWPolbas gipiWPolbas) {
		String[] lineSublineParams = {gipiWPolbas.getLineCd(), StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] groupParam = {gipiWPolbas.getAssdNo()};
		String[] perilParam = {"" /*packLineCd*/, gipiWPolbas.getLineCd(), "" /*packSublineCd*/, StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), Integer.toString(gipiWPolbas.getParId())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, lineSublineParams));
		request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));
		request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("locationListing", lovHelper.getList(LOVHelper.CA_LOCATION_LISTING));
		//request.setAttribute("sectionHazardListing", lovHelper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING, lineSublineParams)); // replaced by: Nica 05.16.2012
		request.setAttribute("sectionHazardListing", lovHelper.getList(LOVHelper.CA_SECTION_OR_HAZARD_LIST, lineSublineParams));
		request.setAttribute("capacityListing", lovHelper.getList(LOVHelper.POSITION_LISTING));
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));		
	}
	
	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varItemNo", 0);
		objVar.put("varVSublineCd", JSONObject.NULL);
		objVar.put("varVNumber2", 0);
		objVar.put("varLineCd", JSONObject.NULL);
		objVar.put("varVPhilPeso", JSONObject.NULL);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varVInterestOnPremises", JSONObject.NULL);
		objVar.put("varVSectionOrHazardInfo", JSONObject.NULL);
		objVar.put("varVConveyanceInfo", JSONObject.NULL);
		objVar.put("varVPropertyNo", JSONObject.NULL);
		objVar.put("varVPropertyNoType", JSONObject.NULL);
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varPrevAmtCovered", JSONObject.NULL);
		objVar.put("varPrevDeductibleCd", JSONObject.NULL);
		objVar.put("varPrevDeductibleAmt", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varVCount", 0);
		objVar.put("varCounter", 1);
		objVar.put("varDeductibleAmt", JSONObject.NULL);
		objVar.put("varVItemNo", JSONObject.NULL);
		objVar.put("varSwitchPostRecord", "N");
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varVPar", JSONObject.NULL);
		objVar.put("varVPersonNo", JSONObject.NULL);
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varVNavi", "Y");
		objVar.put("varVCopyItemTag", false);
		
		return objVar;
	}
	
	private JSONObject createObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		
		objPar.put("paramPostRecSwitch", "N");
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency"));
		objPar.put("paramDefaultRegion", newInstanceMap.get("defaultRegion"));
		objPar.put("paramDfltCoverage", JSONObject.NULL);
		objPar.put("paramOra2010Sw", newInstanceMap.get("ora2010Sw"));
		objPar.put("paramIsPack", newInstanceMap.get("isPack"));
		objPar.put("paramSublineCd", newInstanceMap.get("sublineCd")); //Added by Jerome 08.23.2016 SR 5606
		objPar.put("paramMenuLineCd", newInstanceMap.get("lineCd")); //Added by Jerome 08.23.2016 SR 5606
		
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
		
		return objMiscVar;
	}

	@Override
	public void saveGIPIWCasualtyItem(String param, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("casualtyItems", this.prepareGIPIWCasualtyItemForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(objParams.getString("setGrpItmRows"))));
		params.put("delGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForDelete(new JSONArray(objParams.getString("delGrpItmRows"))));
		params.put("setPersonnels", this.getGipiWCasualtyPersonnelService().prepareGIPIWCasualtyPersonnelForInsertUpdate(new JSONArray(objParams.getString("setCasPerRows"))));
		params.put("delPersonnels", this.getGipiWCasualtyPersonnelService().prepareGIPIWCasualtyPersonnelForDelete(new JSONArray(objParams.getString("delCasPerRows"))));
		params.put("setDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParams.getString("setDeductRows"))));
		params.put("delDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParams.getString("delDeductRows"))));
		params.put("setPerils", this.getGipiWItemPerilService().prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("setPerils"))));
		params.put("delPerils", this.getGipiWItemPerilService().prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("delPerils"))));
		//params.put("setWCs", this.getGipiWPolWCService().prepareGIPIWPolWCForInsert(new JSONArray(objParams.getString("setWCs"))));
		
		if(objParams.getString("parType").equals("E")){ //added by steven 9/10/2012
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
		params.put("parType", objParams.getString("parType"));  //added by steven 9/10/2012
		
		params.put("userId", USER.getUserId());
		
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		this.getGipiWCasualtyDAO().saveGIPIWCasualtyItem(params);
	}
	
	@Override
	public Map<String, Object> gipis061NewFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 11.18.2016 SR 5606
		newInstanceMap = this.getGipiWCasualtyDAO().gipis011NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		request.setAttribute("parType", "E");
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyCA(parId)))); // andrew - 07152015 - SR 19819/19452
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPolbas", gipiWPolbas);
		formMap.put("itemCasualties", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemCA(parId)))); // andrew - 07152015 - SR 19819/19452
		formMap.put("groupedItems", new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems(parId)));
		formMap.put("casualtyPersonnels", new JSONArray(this.getGipiWCasualtyPersonnelService().getGipiWCasualtyPersonnel(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
		try {//monmon
			formMap.put("itemAnnTsiPrem", new JSONArray(gipiItemService.getItemAnnTsiPrem(parId)));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return formMap;
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

		int parId = Integer.parseInt(request.getParameter("parId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 09.20.2016 SR 5606
		newInstanceMap = this.getGipiWCasualtyDAO().gipis011NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPolbas", gipiWPolbas);		
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridCA");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		//Map<String, Object> itemCasualtyTableGrid = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemCasualtyTableGrid = TableGridUtil.getTableGrid3(request, tgParams); //replaced by: Mark C. 04162015 SR4302
		//itemCasualtyTableGrid.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemCA(parId)));
		itemCasualtyTableGrid.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemCA(parId)))); //replaced by: Mark C. 04162015 SR4302
		itemCasualtyTableGrid.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemCasualtyTableGrid.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		//itemCasualtyTableGrid.put("gipiWGroupedItems", new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems(parId)));		
		itemCasualtyTableGrid.put("gipiWGroupedItems", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems(parId)))); //replaced by: Mark C. 04162015 SR4302
		//itemCasualtyTableGrid.put("gipiWCasualtyPersonnel", new JSONArray(this.getGipiWCasualtyPersonnelService().getGipiWCasualtyPersonnel(parId)));
		itemCasualtyTableGrid.put("gipiWCasualtyPersonnel", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWCasualtyPersonnelService().getGipiWCasualtyPersonnel(parId)))); //replaced by: Mark C. 04162015 SR4302
		request.setAttribute("itemTableGrid", new JSONObject(itemCasualtyTableGrid));
		
		return formMap;
	}
}
