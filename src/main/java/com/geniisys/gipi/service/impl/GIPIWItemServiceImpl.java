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

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.pack.service.GIPIWPackageInvTaxService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWAccidentItemService;
import com.geniisys.gipi.service.GIPIWAviationItemService;
import com.geniisys.gipi.service.GIPIWCargoService;
import com.geniisys.gipi.service.GIPIWCasualtyItemService;
import com.geniisys.gipi.service.GIPIWCasualtyPersonnelService;
import com.geniisys.gipi.service.GIPIWCommInvoicePerilService;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWEngineeringItemService;
import com.geniisys.gipi.service.GIPIWFireItmService;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWItemVesService;
import com.geniisys.gipi.service.GIPIWMcAccService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWVehicleService;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItemServiceImpl.
 */
public class GIPIWItemServiceImpl implements GIPIWItemService {
	
	/** The gipi w item dao. */
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIPARListService gipiParListService;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWFireItmService gipiWFireItmService;
	private GIPIWAviationItemService gipiWAviationItemService;
	private GIPIWItemVesService gipiWItemVesService;
	private GIPIWCasualtyItemService gipiWCasualtyItemService;
	private GIPIWCasualtyPersonnelService gipiWCasualtyPersonnelService;
	private GIPIWGroupedItemsService gipiWGroupedItemsService;
	private GIPIWEngineeringItemService gipiWEngineeringItemService;
	private GIPIWAccidentItemService gipiWAccidentItemService;
	private GIPIWCargoService gipiWCargoService;
	private GIPIWVehicleService gipiWVehicleService;
	private GIPIWMcAccService gipiWMcAccService;
	private GIPIWPackageInvTaxService gipiWPackageInvTaxService;
	private GIPIWCommInvoicePerilService gipiWCommInvoicePerilService;
	private GIPIWCommInvoiceService gipiWCommInvoiceService;
	private GIPIWInvoiceFacadeService gipiWInvoiceService;
	
	private static Logger log = Logger.getLogger(GIPIWItemServiceImpl.class);	
	
	public GIPIPARListService getGipiParListService() {
		return gipiParListService;
	}

	public void setGipiParListService(GIPIPARListService gipiParListService) {
		this.gipiParListService = gipiParListService;
	}

	public GIPIWPolbasService getGipiWPolbasService() {
		return gipiWPolbasService;
	}

	public void setGipiWPolbasService(GIPIWPolbasService gipiWPolbasService) {
		this.gipiWPolbasService = gipiWPolbasService;
	}	

	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}

	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}

	public void setGipiWDeductibleService(
			GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}	

	public GIPIWFireItmService getGipiWFireItmService() {
		return gipiWFireItmService;
	}

	public void setGipiWFireItmService(GIPIWFireItmService gipiWFireItmService) {
		this.gipiWFireItmService = gipiWFireItmService;
	}

	public GIPIWAviationItemService getGipiWAviationItemService() {
		return gipiWAviationItemService;
	}

	public void setGipiWAviationItemService(
			GIPIWAviationItemService gipiWAviationItemService) {
		this.gipiWAviationItemService = gipiWAviationItemService;
	}

	public GIPIWItemVesService getGipiWItemVesService() {
		return gipiWItemVesService;
	}

	public void setGipiWItemVesService(GIPIWItemVesService gipiWItemVesService) {
		this.gipiWItemVesService = gipiWItemVesService;
	}

	public GIPIWCasualtyItemService getGipiWCasualtyItemService() {
		return gipiWCasualtyItemService;
	}

	public void setGipiWCasualtyItemService(
			GIPIWCasualtyItemService gipiWCasualtyItemService) {
		this.gipiWCasualtyItemService = gipiWCasualtyItemService;
	}

	public GIPIWCasualtyPersonnelService getGipiWCasualtyPersonnelService() {
		return gipiWCasualtyPersonnelService;
	}

	public void setGipiWCasualtyPersonnelService(
			GIPIWCasualtyPersonnelService gipiWCasualtyPersonnelService) {
		this.gipiWCasualtyPersonnelService = gipiWCasualtyPersonnelService;
	}

	public GIPIWGroupedItemsService getGipiWGroupedItemsService() {
		return gipiWGroupedItemsService;
	}

	public void setGipiWGroupedItemsService(
			GIPIWGroupedItemsService gipiWGroupedItemsService) {
		this.gipiWGroupedItemsService = gipiWGroupedItemsService;
	}

	public GIPIWEngineeringItemService getGipiWEngineeringItemService() {
		return gipiWEngineeringItemService;
	}

	public void setGipiWEngineeringItemService(
			GIPIWEngineeringItemService gipiWEngineeringItemService) {
		this.gipiWEngineeringItemService = gipiWEngineeringItemService;
	}

	public GIPIWAccidentItemService getGipiWAccidentItemService() {
		return gipiWAccidentItemService;
	}

	public void setGipiWAccidentItemService(
			GIPIWAccidentItemService gipiWAccidentItemService) {
		this.gipiWAccidentItemService = gipiWAccidentItemService;
	}

	public GIPIWCargoService getGipiWCargoService() {
		return gipiWCargoService;
	}

	public void setGipiWCargoService(GIPIWCargoService gipiWCargoService) {
		this.gipiWCargoService = gipiWCargoService;
	}

	public GIPIWVehicleService getGipiWVehicleService() {
		return gipiWVehicleService;
	}

	public void setGipiWVehicleService(GIPIWVehicleService gipiWVehicleService) {
		this.gipiWVehicleService = gipiWVehicleService;
	}

	public GIPIWMcAccService getGipiWMcAccService() {
		return gipiWMcAccService;
	}

	public void setGipiWMcAccService(GIPIWMcAccService gipiWMcAccService) {
		this.gipiWMcAccService = gipiWMcAccService;
	}	

	public GIPIWPackageInvTaxService getGipiWPackageInvTaxService() {
		return gipiWPackageInvTaxService;
	}

	public void setGipiWPackageInvTaxService(
			GIPIWPackageInvTaxService gipiWPackageInvTaxService) {
		this.gipiWPackageInvTaxService = gipiWPackageInvTaxService;
	}

	public GIPIWCommInvoicePerilService getGipiWCommInvoicePerilService() {
		return gipiWCommInvoicePerilService;
	}

	public void setGipiWCommInvoicePerilService(
			GIPIWCommInvoicePerilService gipiWCommInvoicePerilService) {
		this.gipiWCommInvoicePerilService = gipiWCommInvoicePerilService;
	}

	public GIPIWCommInvoiceService getGipiWCommInvoiceService() {
		return gipiWCommInvoiceService;
	}

	public void setGipiWCommInvoiceService(
			GIPIWCommInvoiceService gipiWCommInvoiceService) {
		this.gipiWCommInvoiceService = gipiWCommInvoiceService;
	}

	public GIPIWInvoiceFacadeService getGipiWInvoiceService() {
		return gipiWInvoiceService;
	}

	public void setGipiWInvoiceService(GIPIWInvoiceFacadeService gipiWInvoiceService) {
		this.gipiWInvoiceService = gipiWInvoiceService;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemService#getGIPIWItem(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getGIPIWItem(Integer parId) throws SQLException {
		//return (List<GIPIWItem>) StringFormatter.replaceQuotesInList(getGipiWItemDAO().getGIPIWItem(parId));//this.getGipiWItemDAO().getGIPIWItem(parId); replaced by: Nica 04.30.2013
		return (List<GIPIWItem>) StringFormatter.escapeHTMLInList(getGipiWItemDAO().getGIPIWItem(parId));
	}

	/**
	 * Sets the gipi w item dao.
	 * 
	 * @param gipiWItemDAO the new gipi w item dao
	 */
	public void setGipiWItemDAO(GIPIWItemDAO gipiWItemDAO) {
		this.gipiWItemDAO = gipiWItemDAO;
	}

	/**
	 * Gets the gipi w item dao.
	 * 
	 * @return the gipi w item dao
	 */
	public GIPIWItemDAO getGipiWItemDAO() {
		return gipiWItemDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemService#updateItemValues(java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public boolean updateItemValues(BigDecimal tsiAmt, BigDecimal premAmt,
			BigDecimal annTsiAmt, BigDecimal annPremAmt, Integer parId,
			Integer itemNo) throws SQLException {
		this.getGipiWItemDAO().updateItemValues(tsiAmt, premAmt, annTsiAmt, annPremAmt, parId, itemNo);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemService#getWItemCount(java.lang.Integer)
	 */
	@Override
	public Integer getWItemCount(Integer parId) throws SQLException {
		return this.getGipiWItemDAO().getWItemCount(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemService#updateWPolbas(java.lang.Integer)
	 */
	@Override
	public void updateWPolbas(Integer parId) throws SQLException {
		this.getGipiWItemDAO().updateWPolbas(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWItemService#getTsi(java.lang.Integer)
	 */
	@Override
	public void getTsi(Integer parId) throws SQLException {
		this.getGipiWItemDAO().getTsi(parId);
	}

	@Override
	public GIPIWItem getTsiPremAmt(Integer parId, Integer itemNo)
			throws SQLException {
		return this.gipiWItemDAO.getTsiPremAmt(parId, itemNo);
	}

	@Override
	public List<Integer> getDistinctItemNos(int parId) throws SQLException {		
		return this.getGipiWItemDAO().getDistinctItemNos(parId);
	}

	@Override
	public String validateEndtAddItem(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemDAO().validateEndtAddItem(params);
	}
	
	public List<GIPIWItem> getEndtAddItemList(Map<String, Object> params) throws SQLException {
		return this.getGipiWItemDAO().getEndtAddItemList(params);
	}

	@Override
	public void updateItemGroup(Integer parId, Integer itemGrp, Integer itemNo)
			throws SQLException {
		this.getGipiWItemDAO().updateItemGroup(parId, itemGrp, itemNo);
		
	}

	@Override
	public Map<String, Object> getPlanDetails(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemDAO().getPlanDetails(params);
	}
	
	private GIPIWItem setObjToGIPIWItem(JSONObject objItem) throws JSONException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIWItem item = new GIPIWItem();
		try {
			item.setParId(objItem.getInt("parId"));
			item.setItemNo(objItem.getInt("itemNo"));
			item.setItemTitle(objItem.getString("itemTitle"));
			item.setItemDesc(objItem.isNull("itemDesc") ? null : objItem.getString("itemDesc"));
			item.setItemDesc2(objItem.isNull("itemDesc2") ? null : objItem.getString("itemDesc2"));
			item.setTsiAmt(objItem.isNull("tsiAmt") ? null : new BigDecimal(objItem.getString("tsiAmt")));
			item.setPremAmt(objItem.isNull("premAmt") ? null : new BigDecimal(objItem.getString("premAmt")));
			item.setAnnPremAmt(objItem.isNull("annPremAmt") ? null : new BigDecimal(objItem.getString("annPremAmt")));
			item.setAnnTsiAmt(objItem.isNull("annTsiAmt") ? null : new BigDecimal(objItem.getString("annTsiAmt")));
			item.setRecFlag(objItem.isNull("recFlag") ? null : objItem.getString("recFlag"));
			item.setCurrencyCd(objItem.isNull("currencyCd") ? null : objItem.getInt("currencyCd"));
			item.setCurrencyRt(objItem.isNull("currencyRt") ? null : new BigDecimal(objItem.getString("currencyRt")));
			item.setGroupCd(objItem.isNull("groupCd") ? null : objItem.getInt("groupCd"));
			item.setFromDate(objItem.isNull("fromDate") ? null : df.parse(objItem.getString("fromDate")));
			item.setToDate(objItem.isNull("toDate") ? null : df.parse(objItem.getString("toDate")));
			item.setPackLineCd(objItem.isNull("packLineCd") ? null : objItem.getString("packLineCd"));
			item.setPackSublineCd(objItem.isNull("packSublineCd") ? null : objItem.getString("packSublineCd"));
			item.setDiscountSw(objItem.isNull("discountSw") ? null : objItem.getString("discountSw"));
			item.setCoverageCd(objItem.isNull("coverageCd") ? null : objItem.getInt("coverageCd"));
			item.setOtherInfo(objItem.isNull("otherInfo") ? null : objItem.getString("otherInfo"));
			item.setSurchargeSw(objItem.isNull("surchargeSw") ? null : objItem.getString("surchargeSw"));
			item.setRegionCd(objItem.isNull("regionCd") ? null : objItem.getInt("regionCd"));
			item.setChangedTag(objItem.isNull("changedTag") ? null : objItem.getString("changedTag"));
			item.setProrateFlag(objItem.isNull("prorateFlag") ? null : objItem.getString("prorateFlag"));
			item.setCompSw(objItem.isNull("compSw") ? null : objItem.getString("compSw"));
			item.setShortRtPercent(objItem.isNull("shortRtPercent") ? null : new BigDecimal(objItem.getString("shortRtPercent")));
			item.setPackBenCd(objItem.isNull("packBenCd") ? null : objItem.getInt("packBenCd"));
			item.setPaytTerms(objItem.isNull("paytTerms") ? null : objItem.getString("paytTerms"));
			item.setRiskNo(objItem.isNull("riskNo") ? null : objItem.getInt("riskNo"));
			item.setRiskItemNo(objItem.isNull("riskItemNo") ? null : objItem.getInt("riskItemNo"));
		} catch (ParseException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return item;
	}

	@Override
	public List<GIPIWItem> prepareGIPIWItemListing(JSONArray setRows)
			throws SQLException, JSONException {
		List<GIPIWItem> items = new ArrayList<GIPIWItem>();
		JSONObject objItem = null;
		for(int i=0, length=setRows.length(); i < length; i++){
			objItem = setRows.getJSONObject(i);
			items.add(this.setObjToGIPIWItem(objItem));
		}		
		return items;
	}
	
	@Override
	public List<GIPIWItem> getParItemMC(int parId) throws SQLException {		
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemMC(parId)); //kenneth @ FGIC 10.28.2014 added escape
		return this.getGipiWItemDAO().getParItemMC(parId); //replaced by: Mark C. 04162015 SR4302
	}

	@Override
	public List<GIPIWItem> getParItemEN(int parId) throws SQLException {		
		return this.getGipiWItemDAO().getParItemEN(parId); // andrew - 08072015 - SR 19335
	}

	@Override
	public List<GIPIWItem> getParItemFI(int parId) throws SQLException {		
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemFI(parId));
		return this.getGipiWItemDAO().getParItemFI(parId); //replaced by: Mark C. 04162015 SR4302
	}	

	@Override
	public List<GIPIWItem> getParItemAC(int parId) throws SQLException {
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemAC(parId)); //kenneth @ FGIC 10.28.2014 added escape
		return this.getGipiWItemDAO().getParItemAC(parId); //replaced by: Mark C. 04152015 SR4302
	}

	@Override
	public List<GIPIWItem> getParItemCA(int parId) throws SQLException {		
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemCA(parId)); //kenneth @ FGIC 10.28.2014 added escape
		return this.getGipiWItemDAO().getParItemCA(parId); //replaced by: Mark C. 04162015 SR4302
	}

	@Override
	public List<GIPIWItem> getParItemMN(int parId) throws SQLException {		
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemMN(parId));
		return this.getGipiWItemDAO().getParItemMN(parId); //replaced by: Mark C. 04162015 SR4302
	}

	@Override
	public List<GIPIWItem> getParItemAV(int parId) throws SQLException {
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemAV(parId)); //kenneth @ FGIC 10.28.2014 added escape
		return this.getGipiWItemDAO().getParItemAV(parId); //replaced by: Mark C. 04152015 SR4302
	}

	@Override
	public List<GIPIWItem> getParItemMH(int parId) throws SQLException {		
		//return (List<GIPIWItem>) StringFormatter.escapeHTMLInList4(this.getGipiWItemDAO().getParItemMH(parId)); //kenneth @ FGIC 10.28.2014 added escape
		return this.getGipiWItemDAO().getParItemMH(parId); //replaced by: Mark C. 04162015 SR4302
	}

	@Override
	public List<GIPIWItem> getPackPolicyItems(int packParId) throws SQLException {		
		return this.getGipiWItemDAO().getPackParPolicyItems(packParId);
	}

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> gipis095NewFormInstance(
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		int packParId = Integer.parseInt(request.getParameter("globalPackParId") == null ? request.getParameter("packParId") : request.getParameter("globalPackParId"));
		//GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("packParId", packParId);
		newInstanceMap = this.getGipiWItemDAO().gipiw095NewFormInstance(newInstanceMap);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("isPack", "Y");
		
		formMap.put("vars", this.createGIPIS095ObjectVariable(newInstanceMap));
		formMap.put("pars", this.createGIPIS095ObjectParameter(newInstanceMap));
		formMap.put("misc", new JSONObject());
		
		List<GIPIPARList> packParlist =  (List<GIPIPARList>) StringFormatter.escapeHTMLInList(this.getGipiParListService().getPackItemParList(packParId, null));
		formMap.put("packParList", packParlist);
		//formMap.put("packParList", new JSONArray(this.getGipiParListService().getPackItemParList(packParId, null)));
		
		/*List<GIPIWItem> packItems = (List<GIPIWItem>) StringFormatter.escapeHTMLInList((this.getGipiWItemDAO().getPackParPolicyItems(packParId)));
		formMap.put("packPolicyItems",packItems);*/ //comment out by jeffdojello 05.07.2013 replaced by code below		
		formMap.put("packPolicyItems", new JSONArray(this.getGipiWItemDAO().getPackParPolicyItems(packParId))); //remove comment by jeffdojello 05.07.2013
		formMap.put("packLineSublineList", new JSONArray(this.getGipiWItemDAO().getPackageRecords(packParId)));		
		
		return formMap;
	}
	
	@Override
	public Map<String, Object> gipis096NewFormInstance(
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		int packParId = Integer.parseInt(request.getParameter("globalPackParId") == null ? request.getParameter("packParId") : request.getParameter("globalPackParId"));
		
		newInstanceMap.put("packParId", packParId);
		newInstanceMap = this.getGipiWItemDAO().gipiw096NewFormInstance(newInstanceMap);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("isPack", "Y");
		
		formMap.put("vars", this.createGIPIS095ObjectVariable(newInstanceMap));
		formMap.put("pars", this.createGIPIS095ObjectParameter(newInstanceMap));
		formMap.put("misc", new JSONObject());
		formMap.put("packParList", new JSONArray(this.getGipiParListService().getAllPackItemParList(packParId, null)));
		formMap.put("packPolicyItems", new JSONArray(this.getGipiWItemDAO().getPackParPolicyItems(packParId)));
		formMap.put("packLineSublineList", new JSONArray(this.getGipiWItemDAO().getPackageRecords(packParId)));		
		
		return formMap;
	}
	
	private JSONObject createGIPIS095ObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varOldPackLineCd", JSONObject.NULL);
		objVar.put("varParNumBtn",	"DESC");
		objVar.put("varVMaxNo", 0);
		objVar.put("varPeril", JSONObject.NULL);
		objVar.put("varFireItem", JSONObject.NULL);
		objVar.put("varAviation", JSONObject.NULL);
		objVar.put("varItemVes", JSONObject.NULL);
		objVar.put("varCasualtyItem", JSONObject.NULL);
		objVar.put("varCasualtyPersonnel", JSONObject.NULL);
		objVar.put("varGroupedItems", JSONObject.NULL);
		objVar.put("varDeductibles", JSONObject.NULL);
		objVar.put("varLocation", JSONObject.NULL);
		objVar.put("varAccidentItem", JSONObject.NULL);
		objVar.put("varUppaItem", JSONObject.NULL);
		objVar.put("varCargo", JSONObject.NULL);
		objVar.put("varVehicle", JSONObject.NULL);
		objVar.put("varMcAcc", JSONObject.NULL);
		objVar.put("varFI", newInstanceMap.get("variablesFI") == null ? JSONObject.NULL : newInstanceMap.get("variablesFI"));
		objVar.put("varAV", newInstanceMap.get("variablesAV") == null ? JSONObject.NULL : newInstanceMap.get("variablesAV"));
		objVar.put("varMH", newInstanceMap.get("variablesMH") == null ? JSONObject.NULL : newInstanceMap.get("variablesMH"));
		objVar.put("varCA", newInstanceMap.get("variablesCA") == null ? JSONObject.NULL : newInstanceMap.get("variablesCA"));
		objVar.put("varEN", newInstanceMap.get("variablesEN") == null ? JSONObject.NULL : newInstanceMap.get("variablesEN"));
		objVar.put("varAC", newInstanceMap.get("variablesAC") == null ? JSONObject.NULL : newInstanceMap.get("variablesAC"));
		objVar.put("varMN", newInstanceMap.get("variablesMN") == null ? JSONObject.NULL : newInstanceMap.get("variablesMN"));
		objVar.put("varMC", newInstanceMap.get("variablesMC") == null ? JSONObject.NULL : newInstanceMap.get("variablesMC"));
		objVar.put("varSwitchLine", JSONObject.NULL);
		objVar.put("varSwitchSubline", JSONObject.NULL);
		objVar.put("varSwitchInsert", "N");
		objVar.put("varSwitchDelete", "N");
		objVar.put("varVCount", JSONObject.NULL);
		objVar.put("varPost", "Y");
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varLcEn", JSONObject.NULL);
		objVar.put("varLcCa", JSONObject.NULL);
		objVar.put("varPlanLineCd", JSONObject.NULL);
		objVar.put("varPlanSublineCd", JSONObject.NULL);
		objVar.put("varDelLineCd", JSONObject.NULL);
		objVar.put("varDelSublineCd", JSONObject.NULL);
		
		return objVar;
	}
	
	private JSONObject createGIPIS095ObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency") == null ? JSONObject.NULL : newInstanceMap.get("defaultCurrency"));
		objPar.put("paramOra2010Sw", newInstanceMap.get("ora2010Sw") == null ? JSONObject.NULL : newInstanceMap.get("ora2010Sw"));
		
		return objPar;
	}

	@Override
	public void savePackagePolicyItems(String param,GIISUser USER) throws SQLException,
			JSONException, ParseException {		
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("delPackInvTaxes", this.getGipiWPackageInvTaxService().prepareGIPIWPackageInvTaxForDelete(new JSONArray(objParams.getString("delPackInvTax"))));
		params.put("delCommInvPerils", this.getGipiWCommInvoicePerilService().prepareGIPIWCommInvoicePerilForDelete(new JSONArray(objParams.getString("delCommInvPerils"))));
		params.put("delCommInvoices", this.getGipiWCommInvoiceService().prepareGIPIWCommInvoicesForDelete(new JSONArray(objParams.getString("delCommInvoices"))));
		params.put("delInvoices", this.getGipiWInvoiceService().prepareGIPIWInvoiceForDelete(new JSONArray(objParams.getString("delInvoice"))));
		
		params.put("vars", new JSONObject(objParams.getString("vars")));
		params.put("pars", new JSONObject(objParams.getString("pars")));
		params.put("misc", new JSONObject(objParams.getString("misc")));
		
		params.put("packParId", objParams.getInt("packParId"));
		params.put("appUser", USER.getUserId()); //added by steven 06.06.2013

		this.getGipiWItemDAO().savePackagePolicyItems(params);
	}
	
	@Override
	public void saveEndtPackagePolicyItems(String param, GIISUser USER) throws SQLException,
			JSONException, ParseException {		
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delItemRows")), USER.getUserId(), GIPIWItem.class));
		
		params.put("vars", new JSONObject(objParams.getString("vars")));
		params.put("pars", new JSONObject(objParams.getString("pars")));
		params.put("misc", new JSONObject(objParams.getString("misc")));
		
		params.put("packParId", objParams.getInt("packParId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("issCd", objParams.getString("issCd"));
		params.put("issueYy", objParams.getInt("issueYy"));
		params.put("polSeqNo", objParams.getInt("polSeqNo"));
		params.put("renewNo", objParams.getInt("renewNo"));
		params.put("userId", USER.getUserId());
		
		this.getGipiWItemDAO().saveEndtPackagePolicyItems(params);
	}
	
	public Integer checkItemExist(Integer parId) throws SQLException {
		return this.getGipiWItemDAO().checkItemExist(parId);
	}

	@Override
	public Map<String, Object> gipis096ValidateItemNo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItemDAO().gipis096ValidateItemNo(params);
	}

	@Override
	public void renumber(Integer parId, GIISUser USER) throws SQLException {
		this.getGipiWItemDAO().renumber(parId, USER);		//modified by Gzelle 09302014	
	}

	@Override	//added by Gzelle 10242014
	public String checkGetDefCurrRt() throws SQLException {
		return this.gipiWItemDAO.checkGetDefCurrRt();
	}
} 