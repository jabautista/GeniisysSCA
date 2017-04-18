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
import com.geniisys.gipi.dao.GIPIWItemVesDAO;
import com.geniisys.gipi.entity.GIPIWItemVes;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWItemVesService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;

public class GIPIWItemVesServiceImpl implements GIPIWItemVesService {

	private GIPIWItemVesDAO gipiWItemVesDAO;
	
	public GIPIWItemVesDAO getGipiWItemVesDAO(){
		return gipiWItemVesDAO;
	};
	
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWItemService gipiWItemService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;
	
	public void setGipiWItemVesDAO(GIPIWItemVesDAO gipiWItemVesDAO) {
		this.gipiWItemVesDAO = gipiWItemVesDAO;
	}
	@Override
	public List<GIPIWItemVes> getGipiWItemVes(Integer parId)
			throws SQLException {		
		return this.gipiWItemVesDAO.getGipiWItemVes(parId);
	}
	
	/**
	 * @param gipiWDeductibleService the gipiWDeductibleService to set
	 */
	public void setGipiWDeductibleService(GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}
	/**
	 * @return the gipiWDeductibleService
	 */
	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}
	/**
	 * @param gipiWItemPerilService the gipiWItemPerilService to set
	 */
	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}
	/**
	 * @return the gipiWItemPerilService
	 */
	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}
	/**
	 * @param gipiWPolbasService the gipiWPolbasService to set
	 */
	public void setGipiWPolbasService(GIPIWPolbasService gipiWPolbasService) {
		this.gipiWPolbasService = gipiWPolbasService;
	}
	/**
	 * @return the gipiWPolbasService
	 */
	public GIPIWPolbasService getGipiWPolbasService() {
		return gipiWPolbasService;
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
	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}
	public void setGipiWPolWCService(
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}
	
	
	
	@Override
	public void saveGIPIParMarineHullItem(Map<String, Object> params)
			throws SQLException {		
		this.gipiWItemVesDAO.saveGIPIParMarineHullItem(params);
		
	}
	@Override
	public GIPIWItemVes getEndtGipiWItemVesDetails(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWItemVesDAO().getEndtGipiWItemVesDetails(params);
	}
	@Override
	public String validateVessel(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemVesDAO().validateVessel(params);
	}
	@Override
	public void saveEndtMarineHullItemInfoPage(Map<String, Object> params)
			throws SQLException {
		this.getGipiWItemVesDAO().saveEndtMarineHullItemInfoPage(params);
	}
	@Override
	public String preInsertMarineHull(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemVesDAO().preInsertMarineHull(params);
	}
	@Override
	public String checkItemVesAddtlInfo(Integer parId) throws SQLException {
		return this.getGipiWItemVesDAO().checkItemVesAddtlInfo(parId);
	}
	@Override
	public void changeItemVesGroup(Integer parId) throws SQLException {
		this.getGipiWItemVesDAO().changeItemVesGroup(parId);
	}
	@Override
	public String checkUpdateGipiWPolbasValidity(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWItemVesDAO().checkUpdateGipiWPolbasValidity(params);
	}
	@Override
	public String checkCreateDistributionValidity(Integer parId)
			throws SQLException {
		return this.getGipiWItemVesDAO().checkCreateDistributionValidity(parId);
	}
	@Override
	public String checkGiriDistfrpsExist(Integer parId) throws SQLException {
		return this.getGipiWItemVesDAO().checkGiriDistfrpsExist(parId);
	}
	@Override
	public void updateGipiWPolbas2(Map<String, Object> updateGIPIWPolbasParams)
			throws SQLException {
		this.getGipiWItemVesDAO().updateGipiWPolbas2(updateGIPIWPolbasParams);
	}
	@Override
	public List<GIPIWItemVes> prepareGIPIWItemVesListing(JSONArray setRows)
			throws SQLException, JSONException {
		List<GIPIWItemVes> items = new ArrayList<GIPIWItemVes>();
		JSONObject objItem = null;
		for(int i=0, length=setRows.length(); i < length; i++){
			objItem = setRows.getJSONObject(i);
			items.add(this.setObjToGIPIWItemVes(objItem));
		}
		System.out.println("itemVes.length = "+items.size());
		return items;
	}
	
	private GIPIWItemVes setObjToGIPIWItemVes(JSONObject obj) throws JSONException {
		GIPIWItemVes item = new GIPIWItemVes();
		item.setParId(obj.getInt("parId"));
		item.setItemNo(obj.getInt("itemNo"));
		item.setVesselCd(obj.isNull("vesselCd") ? null : obj.getString("vesselCd"));
		item.setRecFlag(obj.isNull("recFlag") ? null : obj.getString("recFlag"));
		item.setDeductText(obj.isNull("deductText") ? null : obj.getString("deductText"));
		item.setGeogLimit(obj.isNull("geogLimit") ? null : obj.getString("geogLimit"));
		item.setDryDate(obj.isNull("dryDate") ? null : obj.getString("dryDate"));
		item.setDryPlace(obj.isNull("dryPlace") ? null : obj.getString("dryPlace"));
		return item;
	}
	@Override
	public void saveGIPIEndtItemVes(String param, GIISUser user)
			throws SQLException, JSONException, ParseException {
		System.out.println(param);
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("vesItems", this.prepareGIPIWItemVesListing(new JSONArray(objParams.getString("setItemRows"))));		
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
		params.put("issCd", objParams.getString("issCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));	
		params.put("distNo", objParams.getString("distNo"));
		params.put("userId", user.getUserId());		

		params.put("negateItem", objParams.getString("negateItem"));
		params.put("prorateFlag", objParams.getString("prorateFlag"));
		params.put("compSw", objParams.getString("compSw"));
		params.put("endtExpiryDate", objParams.getString("endtExpiryDate"));
		params.put("effDate", objParams.getString("effDate"));
		params.put("shortRtPercent", objParams.getString("shortRtPercent"));
		params.put("expiryDate", objParams.getString("expiryDate"));
		
		this.getGipiWItemVesDAO().saveGIPIEndtItemVes(params);
	}
	
	private Map<String, Integer> getItemNoListFromView(JSONArray itemNoList) throws JSONException{
		Map<String, Integer> itemMap = new HashMap<String, Integer>();
		
		for(int i=0, length=itemNoList.length(); i < length; i++){			
			itemMap.put(itemNoList.getJSONObject(i).getString("itemNo"), itemNoList.getJSONObject(i).getInt("itemNo"));
			//System.out.println(itemNoList.getJSONObject(i).getString("itemNo"));
		}
		
		return itemMap;	
	}
	
	@Override
	public Map<String, Object> newFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		System.out.println("new form instance...");
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		//int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId")); // andrew - 07.08.2011
		int parId = Integer.parseInt(request.getParameter("parId"));
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWItemVesDAO().gipis009NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));	
		formMap.put("mhItems", new JSONArray(this.getGipiWItemService().getParItemMH(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		
		return formMap;
	}
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIWPolbas gipiWPolbas) throws JSONException {
		String[] lineSubLineParams = { gipiWPolbas.getLineCd(), StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()) }; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, lineSubLineParams));
		
		String[] vesParams = {StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), gipiWPolbas.getIssCd(), //Deo [01.03.2017]: added StringFormatter (SR-23567)
								gipiWPolbas.getIssueYy()==null?"":gipiWPolbas.getIssueYy().toString(), 
								gipiWPolbas.getPolSeqNo()==null?"":gipiWPolbas.getPolSeqNo().toString(), 
								gipiWPolbas.getRenewNo()==null?"":gipiWPolbas.getRenewNo().toString()};
		request.setAttribute("marineHullList", lovHelper.getList(LOVHelper.MARINE_HULL_LISTING, vesParams));
		
		String[] groupParam = { gipiWPolbas.getAssdNo() };
		request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));
		
		String[] perilParam = {"" /*packLineCd*/, gipiWPolbas.getLineCd(), "" /*packSublineCd*/, StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), Integer.toString(gipiWPolbas.getParId())};	//Deo [01.03.2017]: added StringFormatter (SR-23567)
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));
	}
	
	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varVPar", JSONObject.NULL);		
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varOldCoverageCd", JSONObject.NULL);
		objVar.put("varOldCoverageDesc", JSONObject.NULL);
		//objVar.put("varPost", "Y"); belle 03282011 for confirmation to m'grace
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varNewSw", "Y");
		
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varVRiskNo", JSONObject.NULL);
		objVar.put("varVCopyItemTag", false);
		
		objVar.put("varVReccount", JSONObject.NULL);
		objVar.put("varVDateFormat", JSONObject.NULL);
		
		
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
	public void saveGIPIWItemVes(String param, GIISUser user)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		System.out.println("Saving Marine Hull Item Information...");
		Map<String, Object> params = new HashMap<String, Object>();		
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("mhItems", this.prepareGIPIWItemVesForInsertUpdate(new JSONArray(objParams.getString("setItemRows"))));
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
		
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		this.getGipiWItemVesDAO().saveGIPIWItemVes(params);
	}
	
	private List<GIPIWItemVes> prepareGIPIWItemVesForInsertUpdate(JSONArray setRows) throws JSONException {
		List<GIPIWItemVes> mhItems = new ArrayList<GIPIWItemVes>();
		GIPIWItemVes itemVes = null;
		JSONObject objItem = null;
		JSONObject objMH = null;
		//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=setRows.length(); i<length; i++) {
			itemVes = new GIPIWItemVes();
			objItem = setRows.getJSONObject(i);
			objMH = objItem.isNull("gipiWItemVes") ? null : objItem.getJSONObject("gipiWItemVes");
			
			if(objMH != null) {
				itemVes.setParId(objItem.isNull("parId") ? null : objItem.getInt("parId"));
				itemVes.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				itemVes.setVesselCd(objMH.isNull("vesselCd") ? null : StringFormatter.unescapeHtmlJava(objMH.getString("vesselCd")));
				itemVes.setGeogLimit(objMH.isNull("geogLimit")? null : StringFormatter.unescapeHtmlJava(objMH.getString("geogLimit")));
				itemVes.setRecFlag(objMH.isNull("recFlag") ? null : StringFormatter.unescapeHtmlJava(objMH.getString("recFlag")));
				itemVes.setDeductText(objMH.isNull("deductText")? null : StringFormatter.unescapeHtmlJava(objMH.getString("deductText")));
				itemVes.setDryDate(objMH.isNull("dryDate") ? null : objMH.getString("dryDate"));
				itemVes.setDryPlace(objMH.isNull("dryPlace") ? null : StringFormatter.unescapeHtmlJava(objMH.getString("dryPlace")));
				
				mhItems.add(itemVes);
				itemVes = null;
			}
			
			return mhItems;
		}
 		
		return mhItems;
	}

	@Override
	public Map<String, Object> gipis081NewFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		System.out.println("new form instance...");
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWItemVesDAO().gipis009NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		request.setAttribute("parType", "E");
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyMH(parId))));  // andrew - 07152015 - SR 19741/19712
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));	
		formMap.put("gipiWItemVes", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMH(parId))));  // andrew - 07152015 - SR 19741/19712
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
		newInstanceMap = this.getGipiWItemVesDAO().gipis009NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));		
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridMH");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		//Map<String, Object> itemMarineHullTG = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemMarineHullTG = TableGridUtil.getTableGrid3(request, tgParams); //replaced by: Mark C. 04162015 SR4302
		//itemMarineHullTG.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemMH(parId)));
		itemMarineHullTG.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMH(parId)))); //replaced by: Mark C. 04162015 SR4302
		itemMarineHullTG.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemMarineHullTG.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		
		request.setAttribute("itemTableGrid", new JSONObject(itemMarineHullTG));
		
		return formMap;
	}
	
	
}
