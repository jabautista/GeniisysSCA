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
import com.geniisys.gipi.dao.GIPIWAviationItemDAO;
import com.geniisys.gipi.entity.GIPIWAviationItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWAviationItemService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;

public class GIPIWAviationItemServiceImpl implements GIPIWAviationItemService{

	private GIPIWAviationItemDAO gipiWAviationItemDAO;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWItemService gipiWItemService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;

	public GIPIWAviationItemDAO getGipiWAviationItemDAO() {
		return gipiWAviationItemDAO;
	}

	public void setGipiWAviationItemDAO(GIPIWAviationItemDAO gipiWAviationItemDAO) {
		this.gipiWAviationItemDAO = gipiWAviationItemDAO;
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
	
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWAviationItemDAO.isExist(parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWAviationItem> getGipiWAviationItem(Integer parId)
			throws SQLException {

		//List<Object> list = new ArrayList<Object>();
		//list.addAll(this.gipiWAviationItemDAO.getGipiWAviationItem(parId));
		//StringFormatter.replaceQuotesInList(this.gipiWAviationItemDAO.getGipiWAviationItem(parId));
		//this.gipiWAviationItemDAO.getGipiWAviationItem(parId);
		
		return (List<GIPIWAviationItem>) StringFormatter.replaceQuotesInList(this.gipiWAviationItemDAO.getGipiWAviationItem(parId));
	}

	@Override
	public void saveGipiWAviation(List<GIPIWAviationItem> aviationItems)
			throws SQLException {
		this.gipiWAviationItemDAO.saveGipiWAviation(aviationItems);
	}

	@Override
	public Map<String, String> preCommitAviationItem(Integer parId,
			Integer itemNo, String vesselCd) throws SQLException {
		return this.gipiWAviationItemDAO.preCommitAviationItem(parId, itemNo, vesselCd);
	}

	@Override
	public boolean saveAvaiationItem(Map<String, Object> param)
			throws SQLException {
		return this.gipiWAviationItemDAO.saveAvaiationItem(param);
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
		newInstanceMap = this.getGipiWAviationItemDAO().gipis019NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPolbas", gipiWPolbas);
		formMap.put("itemAviations", new JSONArray(this.getGipiWItemService().getParItemAV(parId)));
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
		
		request.setAttribute("vesselListing", lovHelper.getList(LOVHelper.VESSEL_LISTING4));
		
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
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varVPar", JSONObject.NULL);
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varCoInsSw", JSONObject.NULL);
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
	public void saveGIPIWAviationItm(String param, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("aviationItems", this.prepareGIPIWAviationItmForInsertUpdate(new JSONArray(objParams.getString("setItemRows"))));
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
		
		this.getGipiWAviationItemDAO().saveGIPIWAviationItm(params);		
	}
	
	private List<GIPIWAviationItem> prepareGIPIWAviationItmForInsertUpdate(JSONArray setRows) throws JSONException {
		List<GIPIWAviationItem> avList = new ArrayList<GIPIWAviationItem>();
		GIPIWAviationItem av = null;
		JSONObject objItem = null;
		JSONObject objAv = null;		
		
		for(int i=0, length=setRows.length(); i < length; i++){
			av = new GIPIWAviationItem();
			objItem = setRows.getJSONObject(i);
			objAv = objItem.isNull("gipiWAviationItem") ? null : objItem.getJSONObject("gipiWAviationItem");
			
			if(objAv != null){
				av.setParId(objItem.isNull("parId") ? "" : StringFormatter.unescapeHtmlJava(objItem.getString("parId")));
				av.setItemNo(objItem.isNull("itemNo") ? "" : StringFormatter.unescapeHtmlJava(objItem.getString("itemNo")));
				av.setVesselCd(objAv.isNull("vesselCd") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("vesselCd")));
				av.setTotalFlyTime(objAv.isNull("totalFlyTime") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("totalFlyTime")));
				av.setQualification(objAv.isNull("qualification") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("qualification")));
				av.setPurpose(objAv.isNull("purpose") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("purpose")));
				av.setGeogLimit(objAv.isNull("geogLimit") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("geogLimit")));
				av.setDeductText(objAv.isNull("deductText") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("deductText")));
				av.setRecFlagAv(objAv.isNull("recFlagAv") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("recFlagAv")));
				av.setFixedWing(objAv.isNull("fixedWing") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("fixedWing")));
				av.setRotor(objAv.isNull("rotor") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("rotor")));
				av.setPrevUtilHrs(objAv.isNull("prevUtilHrs") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("prevUtilHrs")));
				av.setEstUtilHrs(objAv.isNull("estUtilHrs") ? "" : StringFormatter.unescapeHtmlJava(objAv.getString("estUtilHrs")));
				avList.add(av);
				av = null;
			}
		}
		return avList;
	}

	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}

	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	public void setGipiWPolWCService(GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}

	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}
	
	@Override
	public Map<String, Object> gipis082NewFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWAviationItemDAO().gipis019NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		request.setAttribute("parType", "E");
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyAV(parId)))); // andrew - 08062015 - KB 308
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPolbas", gipiWPolbas);
		formMap.put("itemAviations", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemAV(parId)))); // andrew - 08062015 - KB 308
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
		newInstanceMap = this.getGipiWAviationItemDAO().gipis019NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.18.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables(newInstanceMap));
		formMap.put("gipiWPolbas", gipiWPolbas);
		//formMap.put("itemAviations", new JSONArray(this.getGipiWItemService().getParItemAV(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridAV");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		//Map<String, Object> itemAviationTG = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemAviationTG = TableGridUtil.getTableGrid3(request, tgParams); //replaced by: Mark C. 04152015 SR4302
		//itemAviationTG.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemAV(parId)));
		itemAviationTG.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemAV(parId)))); //replaced by: Mark C. 04152015 SR4302
		itemAviationTG.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemAviationTG.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		
		request.setAttribute("itemTableGrid", new JSONObject(itemAviationTG));
		
		return formMap;
	}	
}
