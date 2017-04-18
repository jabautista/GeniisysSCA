package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.jfree.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

import com.geniisys.gipi.dao.GIPIWEngineeringItemDAO;

import com.geniisys.gipi.entity.GIPIWEngineeringItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWLocation;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWEngineeringItemService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIWItemUtil;


public class GIPIWEngineeringItemServiceImpl implements GIPIWEngineeringItemService{
	
	private GIPIWEngineeringItemDAO gipiWEngineeringItemDAO;
	
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWItemService gipiWItemService;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;
	
	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}

	public void setGipiWPolWCService(
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}

	public void setGipiWEngineeringItemDAO(GIPIWEngineeringItemDAO gipiWEngineeringItemDAO) {
		this.gipiWEngineeringItemDAO = gipiWEngineeringItemDAO;
	}

	public GIPIWEngineeringItemDAO getGipiWEngineeringItemDAO() {
		return gipiWEngineeringItemDAO;
	}
	
	
	public GIPIWItemService getGipiWItemService() {
		return gipiWItemService;
	}

	public void setGipiWItemService(GIPIWItemService gipiWItemService) {
		this.gipiWItemService = gipiWItemService;
	}
	
	public GIPIWPolbasService getGipiWPolbasService() {
		return gipiWPolbasService;
	}

	public void setGipiWPolbasService(GIPIWPolbasService gipiWPolbasService) {
		this.gipiWPolbasService = gipiWPolbasService;
	}

	public GIPIWPerilDiscountService getGipiWPerilDiscountService() {
		return gipiWPerilDiscountService;
	}

	public void setGipiWPerilDiscountService(
			GIPIWPerilDiscountService gipiWPerilDiscountService) {
		this.gipiWPerilDiscountService = gipiWPerilDiscountService;
	}

	/**
	 * @return the gipiWDeductibleService
	 */
	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}

	/**
	 * @param gipiWDeductibleService the gipiWDeductibleService to set
	 */
	public void setGipiWDeductibleService(
			GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}

	/**
	 * @return the gipiWItemPerilService
	 */
	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	/**
	 * @param gipiWItemPerilService the gipiWItemPerilService to set
	 */
	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}
	
	@Override
	public List<GIPIWEngineeringItem> getGipiWENItems(Integer parId)
			throws SQLException {
		return this.getGipiWEngineeringItemDAO().getGipiWENItems(parId);
	}

	@Override
	public void saveEngineeringItem(String param, GIISUser user)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
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
		params.put("userId", user.getUserId());
		params.put("parType", objParams.getString("parType")); // andrew - 05.01.2011 - for endt
		
		//to include parameters needed for peril
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		this.getGipiWEngineeringItemDAO().saveEngineeringItem(params);
	}

	@Override
	public void saveEndtEngineeringItem(String endtEngineeringItemInfo, Map<String, Object> params)	throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(endtEngineeringItemInfo);
		Debug.print("JSON" + objParameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("addModifiedEngineeringItem", this.prepareAddModifiedEngineeringItem(new JSONArray(objParameters.getString("setItemRows"))));
		allParams.put("deletedEngineeringItem", this.prepareDeletedEngineeringItem(new JSONArray(objParameters.getString("delItemRows"))));
		allParams.put("setItemPerils", this.getGipiWItemPerilService().prepareEndtItemPerilForInsert(new JSONArray(objParameters.getString("setItemPerils"))));
		allParams.put("delItemPerils", this.getGipiWItemPerilService().prepareEndtItemPerilForDelete(new JSONArray(objParameters.getString("delItemPerils"))));
		allParams.put("setDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParameters.getString("setDeductRows"))));
		allParams.put("delDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParameters.getString("delDeductRows"))));
		
		this.gipiWEngineeringItemDAO.saveEndtEngineeringItem(allParams);
	}

	@Override
	public List<GIPIWLocation> getWLocPerItem(int parId) throws SQLException {
		return this.getGipiWEngineeringItemDAO().getWLocPerItem(parId);
	}

	
	public List<GIPIWItem> prepareAddModifiedEngineeringItem(JSONArray setRows) throws JSONException, ParseException {
		GIPIWItem gipiWEngineeringItem = null;
		JSONObject json = null;
		List<GIPIWItem> setEngineeringEndtItem = new ArrayList<GIPIWItem>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			gipiWEngineeringItem = new GIPIWItem();						
			gipiWEngineeringItem.setParId(json.isNull("parId") ? null : json.getInt("parId"));
			gipiWEngineeringItem.setItemNo(json.isNull("itemNo") ? null : json.getInt("itemNo"));
			gipiWEngineeringItem.setItemTitle(json.isNull("itemTitle") ? null : json.getString("itemTitle"));
			gipiWEngineeringItem.setItemDesc(json.isNull("itemDesc") ? null : json.getString("itemDesc"));
			gipiWEngineeringItem.setItemDesc2(json.isNull("itemDesc2") ? null : json.getString("itemDesc2"));
			gipiWEngineeringItem.setCurrencyCd(json.isNull("currencyCd") ? null : json.getInt("currencyCd"));
			gipiWEngineeringItem.setCurrencyRt(json.isNull("currencyRt") ? null : new BigDecimal(json.getString("currencyRt")));
			gipiWEngineeringItem.setRegionCd(json.isNull("regionCd") ? null : json.getInt("regionCd"));
			gipiWEngineeringItem.setGroupCd(json.isNull("groupCd") ? null : json.getString("groupCd").isEmpty() ? null : Integer.parseInt((json.getString("groupCd"))));
			gipiWEngineeringItem.setItemGrp(json.isNull("itemGrp") ? null : json.getInt("itemGrp"));
			gipiWEngineeringItem.setRecFlag(json.isNull("recFlag") ? null : json.getString("recFlag"));
			gipiWEngineeringItem.setOtherInfo(json.isNull("otherInfo") ? null : json.getString("otherInfo"));
			setEngineeringEndtItem.add(gipiWEngineeringItem);
		}	
		return setEngineeringEndtItem;
	}
	
	public List<Map<String, Object>> prepareDeletedEngineeringItem(JSONArray delRows) throws JSONException {
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
	public Map<String, Object> newENInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext appContext = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper helper = (LOVHelper) appContext.getBean("lovHelper");
		
		int parId = (Integer) params.get("parId");
		GIPIWPolbas polbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		newInstanceMap.put("parId", polbas.getParId());
		newInstanceMap = this.getGipiWEngineeringItemDAO().gipis004NewFormInstance(newInstanceMap);
		loadListingToRequest(request, helper, polbas);
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		
		List<GIPIWItem> itms = this.getGipiWItemService().getParItemEN(parId);

		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameters(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		formMap.put("gipiWEnItem", new JSONArray(itms));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		return formMap;
	}
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper helper, GIPIWPolbas gipiWPolbas) {
		String[] perilParam = {"", gipiWPolbas.getLineCd(), "", StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), Integer.toString(gipiWPolbas.getParId())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] assd = {gipiWPolbas.getAssdNo()};
		String[] lineParams = {gipiWPolbas.getLineCd(), StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		
		request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));	
		request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, lineParams));
		request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, assd));
		request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));
		List<LOV> deductiblesList = helper.getList(LOVHelper.POLICY_DEDUCTIBLE, lineParams);	
		StringFormatter.replaceQuotesInList(deductiblesList);				
		request.setAttribute("objDeductibleListing", new JSONArray(deductiblesList));
	}
	
	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		Log.info("Creating object variables... " + newInstanceMap.get("parId"));
		//GIPIWPolbas pol = (GIPIWPolbas) newInstanceMap.get("polbas");
		objVar.put("varVRecCount", JSONObject.NULL);
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varVPar", JSONObject.NULL);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varVSublineCd", JSONObject.NULL);
		objVar.put("varCreatePackItem", "N");
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varSublineOthers", "OTH");
		objVar.put("varSublinePCP", "PCP");
		objVar.put("varSublineBPV", "BPV");
		objVar.put("varSublineOP", "OP");
		objVar.put("varVPackFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varSwitchDelete", JSONObject.NULL);
		objVar.put("varSwitchInsert", JSONObject.NULL);
		objVar.put("varSwitchIncrement", JSONObject.NULL);
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varPlanSw", "N");
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		return objVar;
	}
	
	private JSONObject createObjectParameters(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency"));
		objPar.put("paramDefaultRegion", newInstanceMap.get("defaultRegion"));
		objPar.put("paramOtherSw", "N");
		objPar.put("paramDdlCommit", "N");
		objPar.put("paramPostRecSwitch", "N");
		objPar.put("paramPostSw", "N");
		objPar.put("paramUserAccess", newInstanceMap.get("userAccess"));
		objPar.put("paramOra2010Sw", newInstanceMap.get("ora2010Sw"));
		objPar.put("paramValSw", "Y");
		objPar.put("paramPostRecSwitch", "N");
		objPar.put("paramIsPack", newInstanceMap.get("isPack"));
		
		return objPar;
	}
	
	private JSONObject createObjectMiscVariables() throws JSONException {
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
	public Map<String, Object> gipis067NewFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext appContext = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper helper = (LOVHelper) appContext.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) appContext.getBean("gipiPolbasicService");
		
		int parId = (Integer) params.get("parId");
		GIPIWPolbas polbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		newInstanceMap.put("parId", polbas.getParId());
		newInstanceMap = this.getGipiWEngineeringItemDAO().gipis004NewFormInstance(newInstanceMap);
		loadListingToRequest(request, helper, polbas);
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		request.setAttribute("parType", "E");
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyEN(parId)))); // andrew - 08072015 - SR 19335
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		List<GIPIWItem> itms = this.getGipiWItemService().getParItemEN(parId);

		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameters(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		formMap.put("gipiWEnItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(itms))); // andrew - 08072015 - SR 19335
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
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
	public Map<String, Object> newENInstanceTG(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext appContext = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper helper = (LOVHelper) appContext.getBean("lovHelper");
		
		int parId = (Integer) params.get("parId");
		GIPIWPolbas polbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", polbas.getParId());
		newInstanceMap = this.getGipiWEngineeringItemDAO().gipis004NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, helper, polbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));		
		

		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameters(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		//formMap.put("gipiWEnItem", new JSONArray(itms));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridEN");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		Map<String, Object> itemEngineeringTG = TableGridUtil.getTableGrid(request, tgParams);
		itemEngineeringTG.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemEN(parId)))); // andrew - 08072015 - SR 19335 
		itemEngineeringTG.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemEngineeringTG.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		
		request.setAttribute("itemTableGrid", new JSONObject(itemEngineeringTG));
		
		return formMap;
	}	
}
