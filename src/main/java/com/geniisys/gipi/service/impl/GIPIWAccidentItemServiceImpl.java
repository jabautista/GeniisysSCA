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

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWAccidentItemDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIWAccidentItem;
import com.geniisys.gipi.entity.GIPIWBeneficiary;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIItmPerilGroupedService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWAccidentItemService;
import com.geniisys.gipi.service.GIPIWBeneficiaryService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.geniisys.gipi.service.GIPIWGrpItemsBeneficiaryService;
import com.geniisys.gipi.service.GIPIWItemDiscountService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWItmperlBeneficiaryService;
import com.geniisys.gipi.service.GIPIWItmperlGroupedService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.DateFormatter;
import com.geniisys.gipi.util.GIPIWGroupedItemsUtil;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;

public class GIPIWAccidentItemServiceImpl implements GIPIWAccidentItemService{

	public GIPIWAccidentItemDAO gipiWAccidentItemDAO;
	
	private GIPIWItemService gipiWItemService;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWItemDiscountService gipiWItemDiscountService;
	private GIPIWPolbasDiscountService gipiWPolbasDiscountService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWBeneficiaryService gipiWBeneficiaryService;
	
	private GIPIWGroupedItemsService gipiWGroupedItemsService;
	private GIPIWItmperlGroupedService gipiWItmperlGroupedService;
	private GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService;
	private GIPIWItmperlBeneficiaryService gipiWItmperlBeneficiaryService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;
	private GIPIPolbasicService gipiPolbasicService;
	
	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}

	public void setGipiWPolWCService(
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}	
	
	public GIPIWAccidentItemDAO getGipiWAccidentItemDAO() {
		return gipiWAccidentItemDAO;
	}

	public void setGipiWAccidentItemDAO(GIPIWAccidentItemDAO gipiWAccidentItemDAO) {
		this.gipiWAccidentItemDAO = gipiWAccidentItemDAO;
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

	public GIPIWItemDiscountService getGipiWItemDiscountService() {
		return gipiWItemDiscountService;
	}

	public void setGipiWItemDiscountService(
			GIPIWItemDiscountService gipiWItemDiscountService) {
		this.gipiWItemDiscountService = gipiWItemDiscountService;
	}

	public GIPIWPolbasDiscountService getGipiWPolbasDiscountService() {
		return gipiWPolbasDiscountService;
	}

	public void setGipiWPolbasDiscountService(
			GIPIWPolbasDiscountService gipiWPolbasDiscountService) {
		this.gipiWPolbasDiscountService = gipiWPolbasDiscountService;
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
	
	public GIPIWBeneficiaryService getGipiWBeneficiaryService() {
		return gipiWBeneficiaryService;
	}

	public void setGipiWBeneficiaryService(
			GIPIWBeneficiaryService gipiWBeneficiaryService) {
		this.gipiWBeneficiaryService = gipiWBeneficiaryService;
	}
	
	public GIPIWGroupedItemsService getGipiWGroupedItemsService() {
		return gipiWGroupedItemsService;
	}

	public void setGipiWGroupedItemsService(
			GIPIWGroupedItemsService gipiWGroupedItemsService) {
		this.gipiWGroupedItemsService = gipiWGroupedItemsService;
	}

	public GIPIWItmperlGroupedService getGipiWItmperlGroupedService() {
		return gipiWItmperlGroupedService;
	}

	public void setGipiWItmperlGroupedService(
			GIPIWItmperlGroupedService gipiWItmperlGroupedService) {
		this.gipiWItmperlGroupedService = gipiWItmperlGroupedService;
	}

	public GIPIWGrpItemsBeneficiaryService getGipiWGrpItemsBeneficiaryService() {
		return gipiWGrpItemsBeneficiaryService;
	}

	public void setGipiWGrpItemsBeneficiaryService(
			GIPIWGrpItemsBeneficiaryService gipiWGrpItemsBeneficiaryService) {
		this.gipiWGrpItemsBeneficiaryService = gipiWGrpItemsBeneficiaryService;
	}

	public GIPIWItmperlBeneficiaryService getGipiWItmperlBeneficiaryService() {
		return gipiWItmperlBeneficiaryService;
	}

	public void setGipiWItmperlBeneficiaryService(
			GIPIWItmperlBeneficiaryService gipiWItmperlBeneficiaryService) {
		this.gipiWItmperlBeneficiaryService = gipiWItmperlBeneficiaryService;
	}	
	
	public GIPIPolbasicService getGipiPolbasicService() {
		return gipiPolbasicService;
	}

	public void setGipiPolbasicService(GIPIPolbasicService gipiPolbasicService) {
		this.gipiPolbasicService = gipiPolbasicService;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWAccidentItem> getGipiWAccidentItem(Integer parId)
			throws SQLException {
		return (List<GIPIWAccidentItem>) StringFormatter.replaceQuotesInList(this.gipiWAccidentItemDAO.getGipiWAccidentItem(parId));
	}

	@Override
	public void saveGIPIParAccidentItem(Map<String, Object> params)
			throws SQLException {
		this.gipiWAccidentItemDAO.saveGIPIParAccidentItem(params);
	}

	@Override
	public String saveGIPIParAccidentItemModal(Map<String, Object> params)
			throws SQLException {
		return this.gipiWAccidentItemDAO.saveGIPIParAccidentItemModal(params);
	}

	public String saveGipiWAccidentGroupedItemsModal(String objParams)
			throws SQLException, JSONException, ParseException {
		JSONObject objectParameters = new JSONObject(objParams);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("groupedItemsUpdateItems", GIPIWGroupedItemsUtil.prepareGIPIWAccGroupedItemsForUpdate(new JSONArray(objectParameters.getString("groupedItemsForPopBen"))));
		params.put("coverageUpdateItems", GIPIWGroupedItemsUtil.prepareGIPIWAccGroupedItemsForUpdate(new JSONArray(objectParameters.getString("coverageItemsForPopBen"))));
		params.put("retrievedGroupedItems", GIPIWGroupedItemsUtil.prepareGIPIWAccGroupedItemsForInsert(new JSONArray(objectParameters.getString("groupedItemsForRetGrp"))));
		params.put("setGroupedItems", GIPIWGroupedItemsUtil.prepareGIPIWAccGroupedItemsForInsert(new JSONArray(objectParameters.getString("setGroupedItems"))));
		params.put("delGroupedItems", GIPIWGroupedItemsUtil.prepareGIPIWGroupedItemsForDelete(new JSONArray(objectParameters.getString("delGroupedItems"))));
		params.put("setCoverageItems", this.prepareCoverageItemsForInsert(new JSONArray(objectParameters.getString("setCoverageItems"))));
		params.put("delCoverageItems", this.prepareCoverageItemsForDelete(new JSONArray(objectParameters.getString("delCoverageItems"))));
		params.put("setBeneficiaryItems", this.prepareBeneficiaryItemsForInsert(new JSONArray(objectParameters.getString("setBeneficiaryItems"))));
		params.put("delBeneficiaryItems", this.prepareBeneficiaryItemsForDelete(new JSONArray(objectParameters.getString("delBeneficiaryItems"))));
		params.put("setBeneficiaryPerils", this.prepareBeneficiaryPerilsForInsert(new JSONArray(objectParameters.getString("setBeneficiaryPerils"))));
		params.put("delBeneficiaryPerils", this.prepareBeneficiaryPerilsForDelete(new JSONArray(objectParameters.getString("delBeneficiaryPerils"))));
		params.put("groupedItemsForInsert", this.prepareRetGroupedItemsForInsert(new JSONArray(objectParameters.getString("objRetGroupedItemsParams"))));
		
		return this.gipiWAccidentItemDAO.saveGipiWAccidentGroupedItemsModal(params);
	}
	
	//the following functions are just added here...subject to transfer
	public List<Map<String, Object>> prepareRetGroupedItemsForInsert(JSONArray retGrpItems) throws JSONException{
		List<Map<String, Object>> groupedItems = new ArrayList<Map<String, Object>>();
		Map<String, Object> groupedItemsMap = null;
		JSONObject grpItemsObj = null;
		
		for (int i = 0; i < retGrpItems.length(); i++){
			groupedItemsMap = new HashMap<String, Object>();
			grpItemsObj = retGrpItems.getJSONObject(i);
			
			groupedItemsMap.put("parId", grpItemsObj.isNull("parId") ? null : grpItemsObj.getInt("parId"));
			groupedItemsMap.put("lineCd", grpItemsObj.isNull("lineCd") ? null : grpItemsObj.getString("lineCd"));
			groupedItemsMap.put("sublineCd", grpItemsObj.isNull("sublineCd") ? null : grpItemsObj.getString("sublineCd"));
			groupedItemsMap.put("issCd", grpItemsObj.isNull("issCd") ? null : grpItemsObj.getString("issCd"));
			groupedItemsMap.put("issueYy", grpItemsObj.isNull("issueYy") ? null : grpItemsObj.getString("issueYy"));
			groupedItemsMap.put("polSeqNo", grpItemsObj.isNull("polSeqNo") ? null : grpItemsObj.getString("polSeqNo"));
			groupedItemsMap.put("renewNo", grpItemsObj.isNull("renewNo") ? null : grpItemsObj.getString("renewNo"));
			groupedItemsMap.put("itemNo", grpItemsObj.isNull("itemNo") ? null : grpItemsObj.getInt("itemNo"));
			groupedItemsMap.put("effDate", grpItemsObj.isNull("effDate") ? null : grpItemsObj.getString("effDate"));
			groupedItemsMap.put("groupedItemNo", grpItemsObj.isNull("groupedItemNo") ? null : grpItemsObj.getString("groupedItemNo"));
			groupedItemsMap.put("groupedItemTitle", grpItemsObj.isNull("groupedItemTitle") ? null : grpItemsObj.getString("groupedItemTitle"));
			groupedItemsMap.put("controlCd", grpItemsObj.isNull("controlCd") ? null : grpItemsObj.getString("controlCd"));
			groupedItemsMap.put("controlTypeCd", grpItemsObj.isNull("controlTypeCd") ? null : grpItemsObj.getString("controlTypeCd"));
			
			groupedItems.add(groupedItemsMap);
			groupedItemsMap = null;
		}
		
		return groupedItems;
	}
	
	public List<GIPIWItmperlGrouped> prepareCoverageItemsForInsert(JSONArray coverageItemRow) throws JSONException{
		List<GIPIWItmperlGrouped> coverageItemsList = new ArrayList<GIPIWItmperlGrouped>();
		GIPIWItmperlGrouped coverageItem = null;
		JSONObject covObjItem = null;
		
		for (int i = 0; i < coverageItemRow.length(); i++){
			coverageItem = new GIPIWItmperlGrouped();
			covObjItem = coverageItemRow.getJSONObject(i);
			
			coverageItem.setAggregateSw(covObjItem.isNull("aggregateSw") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("aggregateSw")));
			coverageItem.setAnnPremAmt(covObjItem.isNull("annPremAmt") || covObjItem.getString("annPremAmt").equals("") ? null : new BigDecimal(covObjItem.getString("annPremAmt").replaceAll(",", "")));
			coverageItem.setAnnTsiAmt(covObjItem.isNull("annTsiAmt") || covObjItem.getString("annTsiAmt").equals("") ? null : new BigDecimal(covObjItem.getString("annTsiAmt").replaceAll(",", "")));
			coverageItem.setBaseAmt(covObjItem.isNull("baseAmt") || covObjItem.getString("baseAmt").equals("") ? null : new BigDecimal(covObjItem.getString("baseAmt").replaceAll(",", "")));
			coverageItem.setGroupedItemNo(covObjItem.isNull("groupedItemNo") ? null : covObjItem.getInt("groupedItemNo"));
			coverageItem.setGroupedItemTitle(covObjItem.isNull("groupedItemTitle") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("groupedItemTitle")));
			coverageItem.setItemNo(covObjItem.isNull("itemNo") ? null : covObjItem.getInt("itemNo"));
			coverageItem.setLineCd(covObjItem.isNull("lineCd") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("lineCd")));
			coverageItem.setNoOfDays(covObjItem.isNull("noOfDays") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("noOfDays")));
			coverageItem.setParId(covObjItem.isNull("parId") ? null : covObjItem.getInt("parId"));
			coverageItem.setPerilCd(covObjItem.isNull("perilCd") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("perilCd")));
			coverageItem.setPerilName(covObjItem.isNull("perilName") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("perilName")));
			coverageItem.setPerilType(covObjItem.isNull("perilType") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("perilType")));
			coverageItem.setPremAmt(covObjItem.isNull("premAmt") ? null : new BigDecimal(covObjItem.getString("premAmt")));
			coverageItem.setPremRt(covObjItem.isNull("premRt") ? null : covObjItem.getString("premRt"));
			coverageItem.setRecFlag(covObjItem.isNull("recFlag") ? null : StringFormatter.unescapeHtmlJava(covObjItem.getString("recFlag")));
			coverageItem.setRiCommAmt(covObjItem.isNull("riCommAmt") || covObjItem.getString("riCommAmt").equals("") ? null : new BigDecimal(covObjItem.getString("riCommAmt")));
			coverageItem.setRiCommRate(covObjItem.isNull("riCommRate") || covObjItem.getString("riCommRate").equals("") ? null : new BigDecimal(covObjItem.getString("riCommRate")));
			coverageItem.setTsiAmt(covObjItem.isNull("tsiAmt") || covObjItem.getString("tsiAmt").equals("") ? null : new BigDecimal(covObjItem.getString("tsiAmt")));
			coverageItem.setWcSw(covObjItem.isNull("wcSw") ? "N" : StringFormatter.unescapeHtmlJava(covObjItem.getString("wcSw")));
			
			coverageItemsList.add(coverageItem);
			coverageItem = null;
		}
		
		return coverageItemsList;
	}
	
	public List<Map<String, Object>> prepareCoverageItemsForDelete(JSONArray coverageItemRow) throws JSONException{
		List<Map<String, Object>> coverageItemsList = new ArrayList<Map<String,Object>>();
		Map<String, Object> deletedCoverageItems = null;
		
		for (int i = 0; i < coverageItemRow.length(); i++){
			deletedCoverageItems = new HashMap<String, Object>();
			deletedCoverageItems.put("parId", coverageItemRow.getJSONObject(i).isNull("parId") ? null : coverageItemRow.getJSONObject(i).getInt("parId"));
			deletedCoverageItems.put("itemNo", coverageItemRow.getJSONObject(i).isNull("itemNo") ? null : coverageItemRow.getJSONObject(i).getInt("itemNo"));
			deletedCoverageItems.put("groupedItemNo", coverageItemRow.getJSONObject(i).isNull("groupedItemNo") ? null : coverageItemRow.getJSONObject(i).getString("groupedItemNo"));
			deletedCoverageItems.put("perilCd", coverageItemRow.getJSONObject(i).isNull("perilCd") ? null : coverageItemRow.getJSONObject(i).getString("perilCd"));
			coverageItemsList.add(deletedCoverageItems);
			deletedCoverageItems = null;
		}
		
		return coverageItemsList;
	}
	
	public List<GIPIWGrpItemsBeneficiary> prepareBeneficiaryItemsForInsert(JSONArray beneficiaryItemRow) throws JSONException, ParseException{
		List<GIPIWGrpItemsBeneficiary> beneficiaryItemsList = new ArrayList<GIPIWGrpItemsBeneficiary>();
		GIPIWGrpItemsBeneficiary beneficiaryItem = null;
		JSONObject benObjItem = null;
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for (int i = 0; i < beneficiaryItemRow.length(); i++){
			beneficiaryItem = new GIPIWGrpItemsBeneficiary();
			benObjItem = beneficiaryItemRow.getJSONObject(i);
			
			beneficiaryItem.setAge(benObjItem.isNull("age") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("age")));
			beneficiaryItem.setBeneficiaryAddr(benObjItem.isNull("beneficiaryAddr") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("beneficiaryAddr")));
			beneficiaryItem.setBeneficiaryName(benObjItem.isNull("beneficiaryName") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("beneficiaryName")));
			beneficiaryItem.setBeneficiaryNo(benObjItem.isNull("beneficiaryNo") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("beneficiaryNo")));
			beneficiaryItem.setCivilStatus(benObjItem.isNull("civilStatus") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("civilStatus")));
			beneficiaryItem.setDateOfBirth(benObjItem.isNull("dateOfBirth") || benObjItem.getString("dateOfBirth").equals("")? null : sdf.parse(benObjItem.getString("dateOfBirth")));
			beneficiaryItem.setGroupedItemNo(benObjItem.isNull("groupedItemNo") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("groupedItemNo")));
			beneficiaryItem.setItemNo(benObjItem.isNull("itemNo") ? null : benObjItem.getInt("itemNo"));
			beneficiaryItem.setParId(benObjItem.isNull("parId") ? null : benObjItem.getInt("parId"));
			beneficiaryItem.setRelation(benObjItem.isNull("relation") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("relation")));
			beneficiaryItem.setSex(benObjItem.isNull("sex") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("sex")));
			
			beneficiaryItemsList.add(beneficiaryItem);
			beneficiaryItem = null;
		}
		
		return beneficiaryItemsList;
	}
	
	public List<Map<String, Object>> prepareBeneficiaryItemsForDelete(JSONArray beneficiaryItemRow) throws JSONException{
		List<Map<String, Object>> beneficiaryItemsList = new ArrayList<Map<String,Object>>();
		Map<String, Object> deletedBeneficiaryItems = null;
		
		for (int i = 0; i < beneficiaryItemRow.length(); i++){
			deletedBeneficiaryItems = new HashMap<String, Object>();
			deletedBeneficiaryItems.put("parId", beneficiaryItemRow.getJSONObject(i).isNull("parId") ? null : beneficiaryItemRow.getJSONObject(i).getInt("parId"));
			deletedBeneficiaryItems.put("itemNo", beneficiaryItemRow.getJSONObject(i).isNull("itemNo") ? null : beneficiaryItemRow.getJSONObject(i).getInt("itemNo"));
			deletedBeneficiaryItems.put("groupedItemNo", beneficiaryItemRow.getJSONObject(i).isNull("groupedItemNo") ? null : beneficiaryItemRow.getJSONObject(i).getString("groupedItemNo"));
			deletedBeneficiaryItems.put("beneficiaryNo", beneficiaryItemRow.getJSONObject(i).isNull("beneficiaryNo") ? null : beneficiaryItemRow.getJSONObject(i).getString("beneficiaryNo"));
			beneficiaryItemsList.add(deletedBeneficiaryItems);
			deletedBeneficiaryItems = null;
		}
		
		System.out.println("Preparing beneficiary items for delete : " + beneficiaryItemsList.toString());
		
		return beneficiaryItemsList;
	}
	
	public List<GIPIWItmperlBeneficiary> prepareBeneficiaryPerilsForInsert(JSONArray beneficiaryPerilsRow) throws JSONException{
		List<GIPIWItmperlBeneficiary> beneficiaryPerilsList = new ArrayList<GIPIWItmperlBeneficiary>();
		GIPIWItmperlBeneficiary beneficiaryPeril = null;
		JSONObject benObjPeril = null;
		
		for (int i = 0; i < beneficiaryPerilsRow.length(); i++){
			beneficiaryPeril = new GIPIWItmperlBeneficiary();
			benObjPeril	= beneficiaryPerilsRow.getJSONObject(i);
			
			beneficiaryPeril.setAnnPremAmt(benObjPeril.isNull("annPremAmt") || benObjPeril.getString("annPremAmt").equals("") ? null : new BigDecimal(benObjPeril.getString("annPremAmt").replaceAll(",", "")));
			beneficiaryPeril.setAnnTsiAmt(benObjPeril.isNull("annTsiAmt") || benObjPeril.getString("annTsiAmt").equals("") ? null : new BigDecimal(benObjPeril.getString("annTsiAmt").replaceAll(",", "")));
			beneficiaryPeril.setBeneficiaryNo(benObjPeril.isNull("beneficiaryNo") ? null : StringFormatter.unescapeHtmlJava(benObjPeril.getString("beneficiaryNo")));
			beneficiaryPeril.setGroupedItemNo(benObjPeril.isNull("groupedItemNo") ? null : StringFormatter.unescapeHtmlJava(benObjPeril.getString("groupedItemNo")));
			beneficiaryPeril.setItemNo(benObjPeril.isNull("itemNo") ? null : benObjPeril.getInt("itemNo"));
			beneficiaryPeril.setLineCd(benObjPeril.isNull("lineCd") ? null : StringFormatter.unescapeHtmlJava(benObjPeril.getString("lineCd")));
			beneficiaryPeril.setParId(benObjPeril.isNull("parId") ? null : benObjPeril.getInt("parId"));
			beneficiaryPeril.setPerilCd(benObjPeril.isNull("perilCd") ? null : StringFormatter.unescapeHtmlJava(benObjPeril.getString("perilCd")));
			beneficiaryPeril.setPerilName(benObjPeril.isNull("perilName") ? null : StringFormatter.unescapeHtmlJava(benObjPeril.getString("perilName")));
			beneficiaryPeril.setPremAmt(benObjPeril.isNull("premAmt") || benObjPeril.getString("premAmt").equals("") ? null : new BigDecimal(benObjPeril.getString("premAmt").replaceAll(",", "")));
			beneficiaryPeril.setPremRt(benObjPeril.isNull("premRt") || benObjPeril.getString("premRt").equals("") ? null : new BigDecimal(benObjPeril.getString("premRt").replaceAll(",", "")));
			beneficiaryPeril.setRecFlag(benObjPeril.isNull("recFlag") ? null : StringFormatter.unescapeHtmlJava(benObjPeril.getString("recFlag")));
			beneficiaryPeril.setTsiAmt(benObjPeril.isNull("tsiAmt") || benObjPeril.getString("tsiAmt").equals("") ? null : new BigDecimal(benObjPeril.getString("tsiAmt").replaceAll(",", "")));
			
			beneficiaryPerilsList.add(beneficiaryPeril);
			beneficiaryPeril = null;
		}
		
		return beneficiaryPerilsList;
	}
	
	public List<Map<String, Object>> prepareBeneficiaryPerilsForDelete(JSONArray beneficiaryPerilsRow) throws JSONException{
		List<Map<String, Object>> beneficiaryPerilsList = new ArrayList<Map<String,Object>>();
		Map<String, Object> deletedBeneficiaryPerils = null;
		
		for (int i = 0; i < beneficiaryPerilsRow.length(); i++){
			deletedBeneficiaryPerils = new HashMap<String, Object>();
			deletedBeneficiaryPerils.put("parId", beneficiaryPerilsRow.getJSONObject(i).isNull("parId") ? null : beneficiaryPerilsRow.getJSONObject(i).getInt("parId"));
			deletedBeneficiaryPerils.put("itemNo", beneficiaryPerilsRow.getJSONObject(i).isNull("itemNo") ? null : beneficiaryPerilsRow.getJSONObject(i).getInt("itemNo"));
			beneficiaryPerilsList.add(deletedBeneficiaryPerils);
			deletedBeneficiaryPerils = null;
		}
		
		return beneficiaryPerilsList;
	}
	//end -- Angelo 12-01-2010
	
	@Override
	public GIPIWAccidentItem getEndtGipiWAccidentItemDetails(
			Map<String, Object> params) throws SQLException {
		
		return this.gipiWAccidentItemDAO.getEndtGipiWItemAccidentDetails(params);
	}

	@Override
	public Map<String, Object> getEndtGipiWAccidentItemDetails2(
			Map<String, Object> params) throws SQLException {
		return this.gipiWAccidentItemDAO.getEndtGipiWItemAccidentDetails2(params);
	}

	@Override
	public String preInsertAccident(Map<String, Object> params)
			throws SQLException {
		return this.gipiWAccidentItemDAO.preInsertAccident(params);
	}

	@Override
	public void saveEndtAccidentItemInfoPage(Map<String, Object> params)
			throws SQLException, JSONException {		
		this.gipiWAccidentItemDAO.saveEndtAccidentItemInfoPage(params);
		
	}

	@Override
	public GIPIWAccidentItem preInsertEndtAccident(Map<String, Object> params)
			throws SQLException {		
		return this.gipiWAccidentItemDAO.preInsertEndtAccident(params);
	}
	
	public String checkUpdateGipiWPolbasValidity(Map<String, Object> params)
			throws SQLException {
		return this.gipiWAccidentItemDAO.checkUpdateGipiWPolbasValidity(params);
	}
	
	public String checkCreateDistributionValidity(Integer parId)
	throws SQLException {
		return this.gipiWAccidentItemDAO.checkCreateDistributionValidity(parId);
	}
	
	@Override
	public String checkGiriDistfrpsExist(Integer parId) throws SQLException {
		return this.gipiWAccidentItemDAO.checkGiriDistfrpsExist(parId);
	}
	
	@Override
	public void changeItemAccGroup(Integer parId) throws SQLException {
		this.gipiWAccidentItemDAO.changeItemAccGroup(parId);
	}

	@Override
	public boolean saveAccidentItem(Map<String, Object> param) throws SQLException {
		return this.gipiWAccidentItemDAO.saveAccidentItem(param);
	}

	@Override
	public String saveGIPIEndtAccidentItemModal(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWAccidentItemDAO().saveGIPIEndtAccidentItemModal(params);
	}
		
	public String checkRetrieveGroupedItems(Map<String, Object> params) throws SQLException {
		return this.getGipiWAccidentItemDAO().checkRetrieveGroupedItems(params);
	}
	
	@Override
	public Map<String, Object> retrieveGroupedItems(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		
		param.put("parId", Integer.parseInt(request.getParameter("globalParId")));
		param.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));		
		param.put("setGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(objParams.getString("setGroupedItems"))));
		param.put("delGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForDelete(new JSONArray(objParams.getString("delGroupedItems"))));
		
		return this.getGipiWAccidentItemDAO().retrieveGroupedItems(param);
	}
	
	@Override
	public void insertRetrievedGroupedItems(Map<String, Object> params)
			throws SQLException {
		this.getGipiWAccidentItemDAO().insertRetrievedGroupedItems(params);
		
	}
	
	@Override
	public List<GIPIWGroupedItems> retGrpItmsGipiWGroupedItems(
			Map<String, Object> params) throws SQLException {
		return getGipiWAccidentItemDAO().retGrpItmsGipiWGroupedItems(params);
	}

	@Override
	public List<GIPIWItmperlGrouped> retGrpItmsGipiWItmperlGrouped(
			Map<String, Object> params) throws SQLException {
		return getGipiWAccidentItemDAO().retGrpItmsGipiWItmperlGrouped(params);
	}

	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWAccidentItemService#newFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> newFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIWItmperlGroupedService itmPerilGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
		
		int parId = (Integer) params.get("parId");
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		
		newInstanceMap.put("parId", parId);
		newInstanceMap = this.getGipiWAccidentItemDAO().gipis012NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, helper, gipiWPolbas);
		
		List<GIPIWBeneficiary> bene = this.getGipiWBeneficiaryService().getGipiWBeneficiary(parId);
		List<GIPIWItem> item = this.getGipiWItemService().getParItemAC(parId);
		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		formMap.put("gipiWAccidentItem", new JSONArray(item));
		formMap.put("beneficiaries", new JSONArray(bene));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getGipiWPerilDiscount(parId)));
		formMap.put("polbasInceptDate", gipiWPolbas.getInceptDate());
		formMap.put("polbasExpiryDate", gipiWPolbas.getExpiryDate());
		formMap.put("gipiWItmPerilGrouped", new JSONArray(itmPerilGroupedService.getGipiWItmperlGrouped2(parId)));
		return formMap;
	}
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper helper, GIPIWPolbas polbas) {
		//String[] covs = {null, null};
		String[] covs = {polbas.getLineCd(), StringFormatter.unescapeHtmlJava(polbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] groupParam = {polbas.getAssdNo()};
		String[] perilParam = {"" , polbas.getLineCd(), "" , StringFormatter.unescapeHtmlJava(polbas.getSublineCd()), Integer.toString(polbas.getParId())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] planParam = {polbas.getLineCd(), StringFormatter.unescapeHtmlJava(polbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] benParam = {polbas.getLineCd()};
		String[] civilStat = {"CIVIL STATUS"};
		
		request.setAttribute("currency", helper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("coverages", helper.getList(LOVHelper.COVERAGE_CODES, covs));
		request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("regions", helper.getList(LOVHelper.REGION_LISTING));
		request.setAttribute("plans", helper.getList(LOVHelper.PACKAGE_BENEFIT_LISTING, planParam));
		request.setAttribute("payTerms", helper.getList(LOVHelper.PAYTERM_LISTING));
		
		List<LOV> benDtlsListing = helper.getList(LOVHelper.PACKAGE_BENEFIT_DTL_LISTING, benParam);
		StringFormatter.replaceQuotesInList(benDtlsListing);
		request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));
		
		request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
		request.setAttribute("benDtlsListing", new JSONArray(benDtlsListing));
		
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));
	}

	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varVDateFormat", JSONObject.NULL);
		objVar.put("varVSublineCd", JSONObject.NULL);
		objVar.put("varVInceptDate", JSONObject.NULL);
		objVar.put("varVExpiryDate", JSONObject.NULL);
		objVar.put("varSublineTr", JSONObject.NULL);
		objVar.put("varSublineHa", JSONObject.NULL);
		objVar.put("varSublineGa", JSONObject.NULL);
		objVar.put("varSublineAd", JSONObject.NULL);
		objVar.put("varOldPackageCd", JSONObject.NULL);
		objVar.put("varOldCtrlTypeCd", JSONObject.NULL);
		objVar.put("varOldPaytTermsDesc", JSONObject.NULL);
		objVar.put("varOldControlCd", JSONObject.NULL);
		objVar.put("varVWPlan", JSONObject.NULL);
		objVar.put("varVChkBtn", "N");
		objVar.put("varVBaseSw", "N");
		objVar.put("varVLastGrp", JSONObject.NULL);
		objVar.put("varVPopChekr", "N");
		objVar.put("varVDelbenSw", "N");
		objVar.put("varVPackBenCd", JSONObject.NULL);
		objVar.put("varVItmPerilExists", false);
		objVar.put("varVPerl", true);
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varVNumber2", JSONObject.NULL);
		objVar.put("varVNumber3", JSONObject.NULL);
		objVar.put("varVReccount", JSONObject.NULL);
		objVar.put("varVAge", JSONObject.NULL);
		objVar.put("varVUpdate", JSONObject.NULL);
		objVar.put("varVButton", JSONObject.NULL);
		objVar.put("varVNumberBen", JSONObject.NULL);
		objVar.put("varCtr", JSONObject.NULL);
		objVar.put("varVNulled", JSONObject.NULL);
		objVar.put("varVNewQry", JSONObject.NULL);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varOldCoverageCd", JSONObject.NULL);
		objVar.put("varOldCoverageDesc", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varClearDelete", JSONObject.NULL);
		objVar.put("varClearPerils", JSONObject.NULL);
		objVar.put("varFirstRecordSw", JSONObject.NULL);
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varNewInstance", JSONObject.NULL);
		objVar.put("varDateOfBirth", JSONObject.NULL);
		objVar.put("varAge", JSONObject.NULL);
		objVar.put("varCivilStatus", JSONObject.NULL);
		objVar.put("varCounter", JSONObject.NULL);
		objVar.put("varCounter1", JSONObject.NULL);
		objVar.put("varDiscExist", "N");
		objVar.put("varOkSw", "N");
		objVar.put("varCancelSw", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varGrpSw", "N");
		objVar.put("varConsSw", "N");
		objVar.put("varPostBlkSw", "N");
		objVar.put("varVCurrCd", JSONObject.NULL);
		objVar.put("varVErr", "N");
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varNewSw", "Y");
		objVar.put("varNewSw2", "Y");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varVDiscAmt", JSONObject.NULL);
		objVar.put("varVDiscPerilPrem", JSONObject.NULL);
		objVar.put("varVDiscItemPrem", JSONObject.NULL);
		objVar.put("varVDiscItemNo", JSONObject.NULL);
		objVar.put("varVOldNoOfDays", JSONObject.NULL);
		objVar.put("varVChkerGrp", "N");
		objVar.put("varVPrevEnrollee", JSONObject.NULL);
		objVar.put("varVGrpPeril", JSONObject.NULL);
		objVar.put("varVItmPeril", JSONObject.NULL);
		objVar.put("varVNoOfDays", 0);
		objVar.put("varVDaysGrp", 0);
		objVar.put("varVGrpItmToDate", JSONObject.NULL);
		objVar.put("varVGrpItmFromDate", JSONObject.NULL);
		objVar.put("varVItmToDate", JSONObject.NULL);
		objVar.put("varVItmFromDate", JSONObject.NULL);
		objVar.put("varVProrateFlag", JSONObject.NULL);
		objVar.put("varVCompSw", JSONObject.NULL);
		objVar.put("varVShortRtPercent", JSONObject.NULL);
		objVar.put("varVGroupedItems", "N");
		objVar.put("varVPremRtChanged", "N");
		objVar.put("varVTsiAmtChanged", "N");
		objVar.put("varVPremAmtChanged", "N");
		objVar.put("varVCopyItemTag", false);
		objVar.put("varPlanSw", JSONObject.NULL);
		
		return objVar;
	}
	
	private JSONObject createObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objParam = new JSONObject();
		
		objParam.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency"));
		objParam.put("paramDefaultRegion", newInstanceMap.get("defaultRegion"));
		objParam.put("paramDfltCoverage", newInstanceMap.get("parDfltCoverage"));
		objParam.put("paramUserAccess", newInstanceMap.get("userAccess"));
		objParam.put("paramPostRecordSW", "N");
		objParam.put("paramDfltCoverage", JSONObject.NULL);
		objParam.put("paramDelSw", "N");
		objParam.put("paramOra2010Sw", newInstanceMap.get("ora2010Sw"));
		objParam.put("paramIsPack", newInstanceMap.get("isPack"));
		
		return objParam;
	}
	
	private JSONObject createObjectMiscVariables() throws JSONException {
		JSONObject objMiscVar = new JSONObject();
		
		objMiscVar.put("miscDeletePolicyDeductibles", "N");
		objMiscVar.put("miscDeletePerilDiscById", "N");
		objMiscVar.put("miscDeleteItemDiscById", "N");
		objMiscVar.put("miscDeletePolbasDiscById", "N");
		objMiscVar.put("miscCopyPeril", "N");
		objMiscVar.put("miscNbtInvoiceSw", "N");
		objMiscVar.put("miscIsRenumbered", "N");
		objMiscVar.put("miscRenumberedItems", JSONObject.NULL);
		objMiscVar.put("miscChangedItems", JSONObject.NULL);
		objMiscVar.put("miscCopy", "N");	
		objMiscVar.put("miscChangeNoOfPerson", JSONObject.NULL);
		objMiscVar.put("miscDeleteBill", JSONObject.NULL);
		objMiscVar.put("miscPlanPopulateBenefits", JSONObject.NULL);
		
		return objMiscVar;
	}

	@Override
	public void saveGIPIWAccidentItem(String param, GIISUser user)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("accidentItems", this.prepareAccidentItemsForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParams.getString("setDeductRows"))));
		params.put("delDeductRows", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParams.getString("delDeductRows"))));
		params.put("setBeneficiaries", this.prepareBeneficiariesForInsert(new JSONArray(objParams.getString("setBeneficiaries"))));
		params.put("delBeneficiaries", this.prepareBeneficiariesForDelete(new JSONArray(objParams.getString("delBeneficiaries"))));
		params.put("setGrpItmRows", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(objParams.getString("setGrpItmRows"))));
		params.put("delGrpItmRows", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForDelete(new JSONArray(objParams.getString("delGrpItmRows"))));
		params.put("setGrpItmBenRows", this.getGipiWGrpItemsBeneficiaryService().prepareGIPIWGrpItemsBeneficiaryForInsertUpdate(new JSONArray(objParams.getString("setGrpItmBenRows"))));
		params.put("delGrpItmBenRows", this.getGipiWGrpItemsBeneficiaryService().prepareGIPIWGrpItemsBeneficiaryForDelete(new JSONArray(objParams.getString("delGrpItmBenRows"))));
		params.put("setPerils", this.getGipiWItemPerilService().prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("setPerils"))));
		params.put("delPerils", this.getGipiWItemPerilService().prepareGIPIWItemPerilsListing(new JSONArray(objParams.getString("delPerils"))));
		//params.put("setWCs",this.getGipiWPolWCService().prepareGIPIWPolWCForInsert(new JSONArray(objParams.getString("setWCs"))));
		//edited by d.alcantara, for saving wc in endt accident
		if(objParams.getString("parType").equals("E")){
			params.put("setWCs", this.getGipiWPolWCService().prepareDefaultGIPIWPolWC(new JSONArray(objParams.getString("setWCs"))));
		} else {
			params.put("setWCs", this.getGipiWPolWCService().prepareGIPIWPolWCForInsert(new JSONArray(objParams.getString("setWCs"))));
		}
		
		JSONObject misc = new JSONObject(objParams.getString("misc"));
		JSONArray newNos = new JSONArray(objParams.getString("newItemNos"));
		JSONArray oldNos = new JSONArray(objParams.getString("oldItemNos"));
		int parId = objParams.getInt("parId");
		
		params.put("vars", new JSONObject(objParams.getString("vars")));
		params.put("pars", new JSONObject(objParams.getString("pars")));
		params.put("misc", misc);
		
		params.put("newItemNos", newNos);
		params.put("oldItemNos", oldNos);
		
		params.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));
		
		params.put("parId", parId);
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("parType", objParams.getString("parType"));
		params.put("userId", user.getUserId());
		
		String doRenumber = misc.isNull("miscIsRenumbered") ? "N" : misc.getString("miscIsRenumbered");	
		if(doRenumber.equals("Y")) {
			params.put("renumberedGroupedItems", this.prepareRenumberedGroupedItems(parId, oldNos, newNos));
		} else {
			params.put("renumberedGroupedItems", null);
		}
		
		//to include parameters needed for peril updates 
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		System.out.println("WAccidentItemService: Saving accident item...");
		this.getGipiWAccidentItemDAO().saveGIPIWAccidentItem(params);
	}
	

	private Map<String, Object> prepareRenumberedGroupedItems(int parId, JSONArray oldNos, JSONArray newNos) throws JSONException, SQLException {
		Map<String, Object> groupedItems = new HashMap<String, Object>();
		List<GIPIWGroupedItems> grpItems = new ArrayList<GIPIWGroupedItems>();
		List<GIPIWItmperlGrouped> grpItmPerils = new ArrayList<GIPIWItmperlGrouped>();
		List<GIPIWGrpItemsBeneficiary> grpBenItems = new ArrayList<GIPIWGrpItemsBeneficiary>();
		List<GIPIWItmperlBeneficiary> grpBenPerils = new ArrayList<GIPIWItmperlBeneficiary>();
		
		if(oldNos != null && newNos != null && (oldNos.length() == newNos.length())) {
			for(int i=0; i<oldNos.length(); i++) {
				List<GIPIWGroupedItems> oldGrpItems = this.getGipiWGroupedItemsService().getGipiWGroupedItems2(parId, oldNos.getInt(i));
				List<GIPIWItmperlGrouped> oldGrpPerils = this.getGipiWItmperlGroupedService().getGipiWItmperlGrouped(parId, oldNos.getInt(i));
				List<GIPIWGrpItemsBeneficiary> oldGrpBens = this.getGipiWGrpItemsBeneficiaryService().getGipiWGrpItemsBeneficiary(parId, oldNos.getInt(i));
				List<GIPIWItmperlBeneficiary> oldBenPerils = this.getGipiWItmperlBeneficiaryService().getGipiWItmperlBeneficiary(parId, oldNos.getInt(i));
				
				GIPIWGroupedItems itmTemp = null;
				for(GIPIWGroupedItems g: oldGrpItems) {
					itmTemp = g;
					itmTemp.setItemNo(newNos.getString(i));
					grpItems.add(itmTemp);
					itmTemp = null;
				}
				GIPIWItmperlGrouped perlTemp = null;
				for(GIPIWItmperlGrouped p: oldGrpPerils) {
					perlTemp = p;
					perlTemp.setItemNo(newNos.getInt(i));
					grpItmPerils.add(p);
					perlTemp = null;
				}
				GIPIWGrpItemsBeneficiary benTemp = null;
				for(GIPIWGrpItemsBeneficiary b: oldGrpBens) {
					benTemp = b;
					benTemp.setItemNo(newNos.getInt(i));
					grpBenItems.add(benTemp);
					benTemp = null;
				}
				GIPIWItmperlBeneficiary bpTemp = null;
				for(GIPIWItmperlBeneficiary bp: oldBenPerils) {
					bpTemp = bp;
					bpTemp.setItemNo(newNos.getInt(i));
					grpBenPerils.add(bpTemp);
					bpTemp = null;
				}
			}
		}
		
		groupedItems.put("groupedItems", grpItems);
		groupedItems.put("groupedItmPerils", grpItmPerils);
		groupedItems.put("groupedBeneficiaries", grpBenItems);
		groupedItems.put("groupedBenPerils", grpBenPerils);
		
		return groupedItems;
		
	}
	
	private List<GIPIWAccidentItem> prepareAccidentItemsForInsert(JSONArray setRows) throws JSONException, ParseException {
		List<GIPIWAccidentItem> acItemList = new ArrayList<GIPIWAccidentItem>();
		GIPIWAccidentItem acItem = null;
		JSONObject objItem = null;
		JSONObject objACItem = null;
		//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		System.out.println("set rows length  "+setRows.length());
		for(int i=0, length=setRows.length(); i<length; i++) {
			acItem = new GIPIWAccidentItem();
			objItem = setRows.getJSONObject(i);
			objACItem = objItem.isNull("gipiWAccidentItem") ? null : objItem.getJSONObject("gipiWAccidentItem");
			System.out.println("obj AC Item:: -- "+objACItem);
			if(objACItem != null) {
				acItem.setParId(objItem.isNull("parId") ? null : objItem.getString("parId"));
				acItem.setItemNo(objItem.isNull("itemNo") ? null : objItem.getString("itemNo"));
				//acItem.setDateOfBirth(objACItem.isNull("dateOfBirth") ? null : sdf.parse(objACItem.getString("dateOfBirth")));
				acItem.setDateOfBirth(objACItem.isNull("dateOfBirth") ? null : (objACItem.getString("dateOfBirth").equals("") ? null : DateFormatter.formatDate(objACItem.getString("dateOfBirth"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
				acItem.setAge(objACItem.isNull("age") ? null : objACItem.getString("age"));
				acItem.setCivilStatus(objACItem.isNull("civilStatus") ? null : objACItem.getString("civilStatus"));
				acItem.setPositionCd(objACItem.isNull("positionCd") ? null : objACItem.getString("positionCd"));
				acItem.setMonthlySalary(objACItem.isNull("monthlySalary") ? null : new BigDecimal(objACItem.getString("monthlySalary")));
				//acItem.setSalaryGrade(objACItem.isNull("salaryGrade") ? null : objACItem.getString("salaryGrade"));
				acItem.setSalaryGrade(objACItem.isNull("salaryGrade") ? null : StringFormatter.unescapeHTML(StringFormatter.unescapeHtmlJava(objACItem.getString("salaryGrade")))); //replaced by: Mark C. 04132015 SR4302
				acItem.setNoOfPersons(objACItem.isNull("noOfPersons") ? null : objACItem.getString("noOfPersons"));
				acItem.setDestination(objACItem.isNull("destination") ? null : StringFormatter.unescapeHTML(StringFormatter.unescapeHtmlJava(objACItem.getString("destination"))));
				acItem.setHeight(objACItem.isNull("height") ? null : StringEscapeUtils.unescapeHtml(objACItem.getString("height")) );
				//acItem.setWeight(objACItem.isNull("weight") ? null : objACItem.getString("weight"));
				acItem.setWeight(objACItem.isNull("weight") ? null : StringEscapeUtils.unescapeHtml(objACItem.getString("weight"))); ////replaced by: Mark C. 04132015 SR4302
				acItem.setSex(objACItem.isNull("sex") ? null : objACItem.getString("sex"));
				acItem.setGroupPrintSw(objACItem.isNull("groupPrintSw") ? null : objACItem.getString("groupPrintSw"));
				acItem.setAcClassCd(objACItem.isNull("acClassCd") ? null : objACItem.getString("acClassCd"));
				acItem.setLevelCd(objACItem.isNull("levelCd") ? null : objACItem.getString("levelCd"));
				acItem.setParentLevelCd(objACItem.isNull("parentLevelCd") ? null : objACItem.getString("parentLevelCd"));
				acItem.setProrateFlag(objACItem.isNull("prorateFlag") ? null : objACItem.getString("prorateFlag"));
				acItem.setCompSw(objACItem.isNull("compSw") ? null : objACItem.getString("compSw"));
				acItem.setShortRtPercent(objACItem.isNull("shortRtPercent") ? null : new BigDecimal(objACItem.getString("shortRtPercent")));
				acItem.setChangeNOP(objACItem.isNull("changeNOP") ? null : objACItem.getString("changeNOP"));
				acItemList.add(acItem);
				acItem = null;
			}
		}
		
		return acItemList;
	}
	
	/*
	 *  
	 */
	public List<GIPIWBeneficiary> prepareBeneficiariesForInsert(JSONArray beneficiaryItemRow) throws JSONException, ParseException{
		List<GIPIWBeneficiary> beneficiaryItemsList = new ArrayList<GIPIWBeneficiary>();
		GIPIWBeneficiary beneficiaryItem = null;
		JSONObject benObjItem = null;
		//DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for (int i = 0; i < beneficiaryItemRow.length(); i++){
			beneficiaryItem = new GIPIWBeneficiary();
			benObjItem = beneficiaryItemRow.getJSONObject(i);			
			
			beneficiaryItem.setAge(benObjItem.isNull("age") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("age")));
			beneficiaryItem.setBeneficiaryAddr(benObjItem.isNull("beneficiaryAddr") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("beneficiaryAddr")));
			beneficiaryItem.setBeneficiaryName(benObjItem.isNull("beneficiaryName") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("beneficiaryName")));
			beneficiaryItem.setBeneficiaryNo(benObjItem.isNull("beneficiaryNo") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("beneficiaryNo")));
			beneficiaryItem.setCivilStatus(benObjItem.isNull("civilStatus") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("civilStatus")));
			//beneficiaryItem.setDateOfBirth(benObjItem.isNull("dateOfBirth") || benObjItem.getString("dateOfBirth").equals("")? null : sdf.parse(benObjItem.getString("dateOfBirth")));
			beneficiaryItem.setDateOfBirth(benObjItem.isNull("dateOfBirth") ? null : (benObjItem.getString("dateOfBirth").equals("") ? null : DateFormatter.formatDate(benObjItem.getString("dateOfBirth"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
			beneficiaryItem.setItemNo(benObjItem.isNull("itemNo") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("itemNo")));
			beneficiaryItem.setParId((benObjItem.isNull("parId") ? null : benObjItem.getString("parId")));
			beneficiaryItem.setRelation(benObjItem.isNull("relation") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("relation")));
			beneficiaryItem.setSex(benObjItem.isNull("sex") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("sex")));
			beneficiaryItem.setRemarks(benObjItem.isNull("remarks") ? null : StringFormatter.unescapeHtmlJava(benObjItem.getString("remarks")));
			
			beneficiaryItemsList.add(beneficiaryItem);
			beneficiaryItem = null;
		}
		
		return beneficiaryItemsList;
	}
	
	
	public List<Map<String, Object>> prepareBeneficiariesForDelete(JSONArray beneficiaryItemRow) throws JSONException{
		List<Map<String, Object>> beneficiaryItemsList = new ArrayList<Map<String,Object>>();
		Map<String, Object> deletedBeneficiaryItems = null;
		
		for (int i = 0; i < beneficiaryItemRow.length(); i++){
			deletedBeneficiaryItems = new HashMap<String, Object>();
			deletedBeneficiaryItems.put("parId", beneficiaryItemRow.getJSONObject(i).isNull("parId") ? null : beneficiaryItemRow.getJSONObject(i).getInt("parId"));
			deletedBeneficiaryItems.put("itemNo", beneficiaryItemRow.getJSONObject(i).isNull("itemNo") ? null : beneficiaryItemRow.getJSONObject(i).getInt("itemNo"));
			deletedBeneficiaryItems.put("beneficiaryNo", beneficiaryItemRow.getJSONObject(i).isNull("beneficiaryNo") ? null : beneficiaryItemRow.getJSONObject(i).getString("beneficiaryNo"));
			beneficiaryItemsList.add(deletedBeneficiaryItems);
			deletedBeneficiaryItems = null;
		}
		
		System.out.println("Preparing beneficiary items for delete : " + beneficiaryItemsList.toString());
		
		return beneficiaryItemsList;
	}

	@Override
	public Map<String, Object> showACGroupedItems(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> groupMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIWGroupedItemsService gipiWGroupedItemsService = (GIPIWGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiWGroupedItemsService");
		//GIPIWItemPerilService gipiwItemPerilService = 
		GIPIWItmperlGroupedService itmPerilGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
		GIPIWGrpItemsBeneficiaryService grpItmBenService = (GIPIWGrpItemsBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWGrpItemsBeneficiaryService");
		GIPIWItmperlBeneficiaryService itmperlBenService = (GIPIWItmperlBeneficiaryService) APPLICATION_CONTEXT.getBean("gipiWItmperlBeneficiaryService");
		
		int parId = (Integer) params.get("parId");
		int itemNo = params.get("itemNo") == null ? 0 : (Integer) params.get("itemNo");
		
		GIPIWPolbas polbas = this.getGipiWPolbasService().getGipiWPolbas(parId);	
		
		loadACGroupedListingsToRequest(request, lovHelper, polbas);
		
		groupMap.put("gipiWGroupedItems", new JSONArray(gipiWGroupedItemsService.getGipiWGroupedItems2(parId, itemNo)));
		groupMap.put("itemPerilExist", this.getGipiWItemPerilService().isExist(parId, itemNo));
		groupMap.put("itemPerilGroupedExist", this.getGipiWItemPerilService().isExist2(parId, itemNo));
		groupMap.put("gipiWItmperlGrouped", new JSONArray(itmPerilGroupedService.getGipiWItmperlGrouped(parId, itemNo)));
		groupMap.put("gipiWGrpItemsBeneficiary", new JSONArray(grpItmBenService.getGipiWGrpItemsBeneficiary(parId, itemNo)));
		groupMap.put("gipiWItmperlBeneficiary", new JSONArray(itmperlBenService.getGipiWItmperlBeneficiary(parId, itemNo)));
		groupMap.put("itemTsi", this.getGipiWItemService().getTsiPremAmt(parId, itemNo));
		return groupMap;
	}
	
	private void loadACGroupedListingsToRequest(HttpServletRequest request, LOVHelper helper, GIPIWPolbas polbas) {
		String lineCd = polbas.getLineCd();
		String sublineCd = polbas.getSublineCd();
		String assdNo = polbas.getAssdNo();
		String parId = Integer.toString(polbas.getParId());
		
		String[] planParam = {lineCd, sublineCd};
		String[] civilStat = {"CIVIL STATUS"};
		String[] groupParam = {assdNo};
		String[] perilParam = {parId, lineCd, sublineCd};
		String[] perilParam2 = {lineCd, sublineCd};
		
		request.setAttribute("plans", helper.getList(LOVHelper.PACKAGE_BENEFIT_LISTING, planParam));
		request.setAttribute("payTerms", helper.getList(LOVHelper.PAYTERM_LISTING));
		request.setAttribute("controlTypes", helper.getList(LOVHelper.CONTROL_TYPE_LISTING));
		request.setAttribute("civilStatus", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
		request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));
		request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("perils", helper.getList(LOVHelper.PERIL_NAME_LISTING3, perilParam));
		request.setAttribute("beneficiaryPerils", helper.getList(LOVHelper.PERIL_NAME_LISTING2, perilParam2));
	}

	@Override
	public Map<String, Object> gipis065NewFormInstance(
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);

		newInstanceMap.put("parId", gipiWPolbas.getParId());
		this.getGipiWAccidentItemDAO().gipis065NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("isPack", request.getParameter("isPack"));
		request.setAttribute("parType", "E");	
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));//edgar 02/02/2015
		
		formMap.put("vars", this.gipis065CreateObjectVariable(newInstanceMap));
		formMap.put("pars", this.gipis065CreateObjectParameter(newInstanceMap));
		formMap.put("misc", this.gipis065CreateObjectMiscVariables(newInstanceMap));
		formMap.put("polbasInceptDate", gipiWPolbas.getInceptDate());
		formMap.put("polbasExpiryDate", gipiWPolbas.getExpiryDate());
		formMap.put("gipiWPolbas", new JSONObject(gipiWPolbas));
		formMap.put("gipiWAccidentItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemAC(parId))));
		formMap.put("beneficiaries", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWBeneficiaryService().getGipiWBeneficiary(parId))));
		formMap.put("gipiWGroupedItems", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems(parId))));
		formMap.put("gipiWPerilDiscount", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWPerilDiscountService().getGipiWPerilDiscount(parId))));
		formMap.put("gipiWItmPerilGrouped", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItmperlGroupedService().getGipiWItmperlGrouped2(parId))));
		formMap.put("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiPolbasicService().getEndtPolicyAC(parId))));
		GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
		try {//monmon
			formMap.put("itemAnnTsiPrem", new JSONArray(gipiItemService.getItemAnnTsiPrem(parId)));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		GIPIPolbasic basic = this.getGipiPolbasicService().getEndtPolicyAC(parId).get(0);
		List<GIPIItem> sItem = basic.getGipiItems();
		for(GIPIItem i: sItem) {
			System.out.println("GIPIItems: "+i.getParId()+", "+i.getAnnPremAmt()+", "+i.getAnnTsiAmt()+", "+i.getItemNo());
		}
		
		return formMap;
	}
	
	private JSONObject gipis065CreateObjectVariable(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varFromPost", "N");
		objVar.put("varVPremRt", JSONObject.NULL);
		objVar.put("varVTsiAmt", JSONObject.NULL);
		objVar.put("varVAnnTsiAmt", JSONObject.NULL);
		objVar.put("varVPremAmt", JSONObject.NULL);
		objVar.put("varAnnPremAmt", JSONObject.NULL);
		objVar.put("varVTsiAmt2", JSONObject.NULL);
		objVar.put("varVPremAmt2", JSONObject.NULL);
		objVar.put("varVAnnPremAmt2", JSONObject.NULL);
		objVar.put("varVDays", JSONObject.NULL);
		objVar.put("varIssCdRi", JSONObject.NULL);
		objVar.put("varVCanvasSw", "N");
		objVar.put("varVPerilGrpExist", false);
		objVar.put("varDelDiscSw", "N");
		objVar.put("varVPerilCdSw", 1);
		objVar.put("varVPerilName", JSONObject.NULL);
		objVar.put("varVPerilCd", JSONObject.NULL);
		objVar.put("varVDspPerilName", JSONObject.NULL);
		objVar.put("varVDspPerilType", JSONObject.NULL);
		objVar.put("varTariffSw", "N");
		objVar.put("varVBaseSw", "N");
		objVar.put("varVMax", JSONObject.NULL);
		objVar.put("varVChkBtn", "N");
		objVar.put("varVAnnTsi", JSONObject.NULL);
		objVar.put("varVAnnPrem", JSONObject.NULL);
		objVar.put("varVItmperilExist", false);
		objVar.put("varVPerl", true);
		objVar.put("varVDefaultVals", "N");
		objVar.put("varVAnnPrem1", JSONObject.NULL);
		objVar.put("varVAnnTsi1", JSONObject.NULL);
		objVar.put("varVRecCount", JSONObject.NULL);
		objVar.put("varVSublineCd", JSONObject.NULL);
		objVar.put("varVAge", JSONObject.NULL);
		objVar.put("varVDateFormat", JSONObject.NULL);
		objVar.put("varSublineTr", newInstanceMap.get("varSublineTr") != null ? newInstanceMap.get("varSublineTr") : "TR");
		objVar.put("varSublineHa", newInstanceMap.get("varSublineHa") != null ? newInstanceMap.get("varSublineHa") : "HA");
		objVar.put("varSublineGa", newInstanceMap.get("varSublineGa") != null ? newInstanceMap.get("varSublineGa") : "GA");
		objVar.put("varVUpdate", JSONObject.NULL);
		objVar.put("varVButton", JSONObject.NULL);
		objVar.put("varVGroupDeleted", "N");
		objVar.put("varVPackBenCd", JSONObject.NULL);
		objVar.put("varOldPackageCd", JSONObject.NULL);
		objVar.put("varVInceptDate", JSONObject.NULL);
		objVar.put("varVCurRec", 1);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varFirstRecordSw", JSONObject.NULL);
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varNewInstance", JSONObject.NULL);
		objVar.put("varDateOfBirth", JSONObject.NULL);
		objVar.put("varAge", JSONObject.NULL);
		objVar.put("varCivilStatus", JSONObject.NULL);
		objVar.put("varCurItem", JSONObject.NULL);
		objVar.put("varErrorSw", "N");
		objVar.put("varPhilPeso", JSONObject.NULL);
		objVar.put("varOldCoverageCd", JSONObject.NULL);
		objVar.put("varOldCoverageDesc", JSONObject.NULL);
		objVar.put("varClearDelate", JSONObject.NULL);
		objVar.put("varClearPerils", JSONObject.NULL);
		objVar.put("varCount", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varCounter", JSONObject.NULL);
		objVar.put("varSiwtchRecFlag", JSONObject.NULL);
		objVar.put("varVPolicyId", JSONObject.NULL);
		objVar.put("varVLineCd", JSONObject.NULL);
		objVar.put("varVSublineCd", JSONObject.NULL);
		objVar.put("varVIssCd", JSONObject.NULL);
		objVar.put("varVIssueYy", JSONObject.NULL);
		objVar.put("varVPolSeqNo", JSONObject.NULL);
		objVar.put("varVRenewNo", JSONObject.NULL);
		objVar.put("varVEffDate", JSONObject.NULL);
		objVar.put("varVEndtExpiryDate", JSONObject.NULL);
		objVar.put("varVShortRtPercent", JSONObject.NULL);
		objVar.put("varVProvPremTag", JSONObject.NULL);
		objVar.put("varVProvPremPct", JSONObject.NULL);
		objVar.put("varVProrateFlag", JSONObject.NULL);
		objVar.put("varGroupSw", "N");
		objVar.put("varGrpSw", "N");
		objVar.put("varConsSw", "N");
		objVar.put("varVNumber2", JSONObject.NULL);
		objVar.put("varVNumber3", JSONObject.NULL);
		objVar.put("varCounter1", JSONObject.NULL);
		objVar.put("varCompSw", "N");
		objVar.put("varVAge", JSONObject.NULL);
		objVar.put("varVErr", "N");
		objVar.put("varCancelSw", "N");
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varNewSw", "Y");
		objVar.put("varNewSw2", "Y");
		objVar.put("varDiscExist", "N");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varEndtTaxSw", newInstanceMap.get("varEndtTax") != null ? newInstanceMap.get("varEndtTax") : JSONObject.NULL);
		objVar.put("varWithPerilSw", "N");
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varVExpiryDate", JSONObject.NULL);
		objVar.put("varVOldNoOfDays", 0);
		objVar.put("varVPopCheckr", "N");
		objVar.put("varVAnnTsiAmtOld", JSONObject.NULL);
		objVar.put("varVAnnPremAmtOld", JSONObject.NULL);
		objVar.put("varVNegateItem", "N");
		objVar.put("varVAdjAnnTsi", 0);
		objVar.put("varAdjAnnTsiEnrol", 0);
		objVar.put("varAdjAnnPrem", 0);
		objVar.put("varAdjAnnPremEnrol", 0);
		objVar.put("varVNavi", "Y");
		objVar.put("varVCopyItemTag", false);
		
		return objVar;
	}
	
	private JSONObject gipis065CreateObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objPar = new JSONObject();
		
		objPar.put("parItemCnt", 0);
		objPar.put("paramPrevItem", JSONObject.NULL);
		objPar.put("paramParameter482", "N");
		objPar.put("paramNewFormSw", "N");
		objPar.put("paramPostSw", "N");
		objPar.put("paramCommitSw", "N");
		objPar.put("paramValidateSw","N");
		objPar.put("paramTsiLimitSw", "Y");
		objPar.put("paramOldType", JSONObject.NULL);
		objPar.put("paramPremSw", "N");
		objPar.put("paramTsiSw", "N");
		objPar.put("paramCtplSw", "N");
		objPar.put("paramFnlDelSw", "N");
		objPar.put("paramBasicSw", "N");
		objPar.put("paramParameter483", "N");
		objPar.put("paramCursorSw", "N");
		objPar.put("paramPreSw", "N");
		objPar.put("paramParameter484", "N");
		objPar.put("paramAddDeleteSw", JSONObject.NULL);
		objPar.put("paramDfltCoverage", newInstanceMap.get("parDfltCoverage") != null ? newInstanceMap.get("parDfltCoverage") : JSONObject.NULL);
		objPar.put("paramPostRecordSw1", "N");
		objPar.put("paramPostRecordSw", "N");
		objPar.put("paramPostRecSwitch", "N");
		objPar.put("paramPolFlag", "N");
		objPar.put("paramDelSw", "N");
		objPar.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency") != null ? newInstanceMap.get("defaultCurrency") : JSONObject.NULL);		
		
		return objPar;
	}
	
	private JSONObject gipis065CreateObjectMiscVariables(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objMiscVar = new JSONObject();
		
		objMiscVar.put("miscDeletePolicyDeductibles", "N");
		objMiscVar.put("miscDeletePerilDiscById", "N");
		objMiscVar.put("miscDeleteItemDiscById", "N");
		objMiscVar.put("miscDeletePolbasDiscById", "N");
		objMiscVar.put("miscCopyPeril", "N");
		objMiscVar.put("miscNbtInvoiceSw", "N");
		objMiscVar.put("miscIsRenumbered", "N");
		objMiscVar.put("miscRenumberedItems", JSONObject.NULL);
		objMiscVar.put("miscChangedItems", JSONObject.NULL);
		objMiscVar.put("miscCopy", "N");
		objMiscVar.put("miscChangeNoOfPerson", JSONObject.NULL);
		objMiscVar.put("miscDeleteBill", JSONObject.NULL);
		objMiscVar.put("miscPlanPopulateBenefits", JSONObject.NULL);
		
		return objMiscVar;
	}

	@Override
	public void showEndtACGroupedItems(Map<String, Object> params)
			throws SQLException, JSONException {
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("APPLICATION_CONTEXT");
		LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		GIPIItmPerilGroupedService itmPerilGroupedService = (GIPIItmPerilGroupedService) APPLICATION_CONTEXT.getBean("gipiItmPerilGroupedService");
		
		int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
		int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
		
		GIPIWPolbas par =  this.getGipiWPolbasService().getGipiWPolbas(parId);		
		
		request.setAttribute("parId", parId);
		request.setAttribute("itemNo", itemNo);
		request.setAttribute("lineCd", par.getLineCd());
		request.setAttribute("issCd", par.getIssCd());
		request.setAttribute("isFromOverwriteBen", request.getParameter("isFromOverwriteBen"));
		
		String stringParId = ("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
		
		String[] planParam = {par.getLineCd(), par.getSublineCd()};
		String[] civilStat = {"CIVIL STATUS"};
		String[] groupParam = {par.getAssdNo()};
		String[] perilParam = {stringParId, par.getLineCd(), par.getSublineCd()};
		
		request.setAttribute("plans", helper.getList(LOVHelper.PACKAGE_BENEFIT_LISTING, planParam));
		request.setAttribute("payTerms", helper.getList(LOVHelper.PAYTERM_LISTING));
		request.setAttribute("controlTypes", helper.getList(LOVHelper.CONTROL_TYPE_LISTING));		
		request.setAttribute("civilStats", helper.getList(LOVHelper.CG_REF_CODE_LISTING, civilStat));
		request.setAttribute("positionListing", helper.getList(LOVHelper.POSITION_LISTING));							
		request.setAttribute("groups", helper.getList(LOVHelper.GROUP_LISTING2, groupParam));				
		request.setAttribute("perils", helper.getList(LOVHelper.PERIL_NAME_LISTING3, perilParam));
		request.setAttribute("beneficiaryPerils", helper.getList(LOVHelper.PERIL_NAME_LISTING2, planParam));
		
		request.setAttribute("gipiWPolbas", new JSONObject(par));
		
		List<GIPIWGroupedItems> groupedItems = this.getGipiWGroupedItemsService().getGipiWGroupedItems2(parId,itemNo);
		List<GIPIWItmperlGrouped> itmperlGrouped = this.getGipiWItmperlGroupedService().getGipiWItmperlGrouped2(parId);
		List<GIPIWGrpItemsBeneficiary> beneficiary = this.getGipiWGrpItemsBeneficiaryService().getGipiWGrpItemsBeneficiary2(parId);
		List<GIPIWItmperlBeneficiary> benPeril = this.getGipiWItmperlBeneficiaryService().getGipiWItmperlBeneficiary2(parId);
		
		request.setAttribute("gipiWGroupedItems", groupedItems);
		request.setAttribute("objGIPIWGroupedItems", new JSONArray(groupedItems));		
		request.setAttribute("gipiWItmperlGrouped", itmperlGrouped);
		request.setAttribute("objGIPIWItmperlGrouped", new JSONArray(itmperlGrouped));
		request.setAttribute("gipiWGrpItemsBeneficiary", beneficiary);
		request.setAttribute("objGIPIWGrpItemsBeneficiary", new JSONArray(beneficiary));
		request.setAttribute("gipiWItmperlBeneficiary", benPeril);
		request.setAttribute("objGIPIWItmperlBeneficiary", new JSONArray(benPeril));
		//added by d.alcantara, list of gipi item perils
		request.setAttribute("gipiItmPerilGrouped", new JSONArray(itmPerilGroupedService.getPolItmPerils(parId)));
		
		HashMap<String, Object> perlExistsMap = new HashMap<String, Object>();
		perlExistsMap.put("itemNo", itemNo);
		perlExistsMap.put("lineCd", par.getLineCd());
		perlExistsMap.put("sublineCd", par.getSublineCd());
		perlExistsMap.put("issCd", par.getIssCd());
		perlExistsMap.put("issueYy", par.getIssueYy());
		perlExistsMap.put("polSeqNo", par.getPolSeqNo());
		perlExistsMap.put("renewNo", par.getRenewNo());
		perlExistsMap.put("effDate", par.getEffDate());
		Debug.print("item peril exists: "+this.getGipiWItemPerilService().checkItmPerilExists(perlExistsMap)+
				" /// "+perlExistsMap);
		request.setAttribute("isItmPerilExists", this.getGipiWItemPerilService().checkItmPerilExists(perlExistsMap));
		//request.setAttribute("itemPerilExist", this.getGipiWItemPerilService().isExist(parId, itemNo));		
		//request.setAttribute("itemPerilGroupedExist", this.getGipiWItmperlGroupedService().isExist(parId, itemNo));		
		//request.setAttribute("gipiWItem", this.getGipiWItemService().getTsiPremAmt(parId, itemNo));		
	}

	@Override
	public void saveEndtACGroupedItemsModal(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject((String) params.get("param"));
		GIISUser user = (GIISUser) params.get("USER");
		
		params.put("setItemRows", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(objParams.getString("setGroupedItems"))));
		params.put("delGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForDelete(new JSONArray(objParams.getString("delGroupedItems"))));
		params.put("setCoverages", this.getGipiWItmperlGroupedService().prepareGIPIWItmperlGroupedForInsertUpdate(new JSONArray(objParams.getString("setCoverages"))));
		params.put("delCoverages", this.getGipiWItmperlGroupedService().prepareGIPIWItmperlGroupedForDelete(new JSONArray(objParams.getString("delCoverages"))));
		params.put("setBeneficiaries", this.getGipiWGrpItemsBeneficiaryService().prepareGIPIWGrpItemsBeneficiaryForInsertUpdate(new JSONArray(objParams.getString("setBeneficiaries"))));
		params.put("delBeneficiaries", this.getGipiWGrpItemsBeneficiaryService().prepareGIPIWGrpItemsBeneficiaryForDelete(new JSONArray(objParams.getString("delBeneficiaries"))));
		params.put("setBenPerils", this.getGipiWItmperlBeneficiaryService().prepareGIPIWItmperlBeneficiaryForInsertUpdate(new JSONArray(objParams.getString("setBenPerils"))));
		params.put("delBenPerils", this.getGipiWItmperlBeneficiaryService().prepareGIPIWItmperlBeneficiaryForDelete(new JSONArray(objParams.getString("delBenPerils"))));
		
		params.put("vars", new JSONObject(objParams.getString("vars")));
		params.put("pars", new JSONObject(objParams.getString("pars")));
		params.put("misc", new JSONObject(objParams.getString("misc")));
		
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("parType", objParams.getString("parType"));
		params.put("userId", user.getUserId());
		
		params.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));
		
		this.getGipiWAccidentItemDAO().saveEndtACGroupedItemsModal(params);
	}

	@Override
	public String gipis065CheckIfPerilExists(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWAccidentItemDAO().gipis065CheckIfPerilExists(params);
	}

	@Override
	public Map<String, Object> newFormInstanceTG(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		//GIPIWItmperlGroupedService itmPerilGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
		
		int parId = (Integer) params.get("parId");
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);		
		
		newInstanceMap.put("parId", parId);
		newInstanceMap = this.getGipiWAccidentItemDAO().gipis012NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, helper, gipiWPolbas);
		
		//List<GIPIWBeneficiary> bene = this.getGipiWBeneficiaryService().getGipiWBeneficiary(parId);
		//List<GIPIWItem> item = this.getGipiWItemService().getParITemAH(parId);		
		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		newInstanceMap.put("isPack", request.getParameter("isPack"));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		//formMap.put("gipiWAccidentItem", new JSONArray(item));
		//formMap.put("beneficiaries", new JSONArray(bene));
		formMap.put("gipiWPolbas", gipiWPolbas);
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));
		//formMap.put("polbasInceptDate", gipiWPolbas.getInceptDate());
		//formMap.put("polbasExpiryDate", gipiWPolbas.getExpiryDate());
		//formMap.put("gipiWItmPerilGrouped", new JSONArray(itmPerilGroupedService.getGipiWItmperlGrouped2(parId)));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridAC");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);
		
		//Map<String, Object> itemAccidentTG = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemAccidentTG = TableGridUtil.getTableGrid3(request, tgParams); //replaced by: Mark C. 04152015 SR4302
		//itemAccidentTG.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemAC(parId)));  
		itemAccidentTG.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemAC(parId)))); //replaced by: Mark C. 04152015 SR4302
		itemAccidentTG.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemAccidentTG.put("gipiWItemPeril", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId))));
		itemAccidentTG.put("gipiWBeneficiary", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWBeneficiaryService().getGipiWBeneficiary(parId))));
		itemAccidentTG.put("gipiWGroupedItems", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems(parId))));		
		itemAccidentTG.put("gipiWItmperlGrouped", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItmperlGroupedService().getGipiWItmperlGrouped2(parId))));
		//itemAccidentTG.put("gipiWGrpItemsBeneficiary", new JSONArray(this.getGipiWGrpItemsBeneficiaryService().getGipiWGrpItemsBeneficiary2(parId)));
		itemAccidentTG.put("gipiWGrpItemsBeneficiary", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWGrpItemsBeneficiaryService().getGipiWGrpItemsBeneficiary2(parId)))); //replaced by: Mark C. 04152015 SR4302
		request.setAttribute("itemTableGrid", new JSONObject(itemAccidentTG));
		
		return formMap;
	}

	@Override
	public Map<String, Object> showACGroupedItemsTG(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> groupMap = new HashMap<String, Object>();
		
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");		
		
		int parId = (Integer) params.get("parId");
		int itemNo = params.get("itemNo") == null ? 0 : (Integer) params.get("itemNo");
		
		GIPIWPolbas polbas = this.getGipiWPolbasService().getGipiWPolbas(parId);	
		
		loadACGroupedListingsToRequest(request, lovHelper, polbas);
		
		//groupMap.put("gipiWGroupedItems", new JSONArray(gipiWGroupedItemsService.getGipiWGroupedItems2(parId, itemNo)));
		groupMap.put("itemPerilExist", this.getGipiWItemPerilService().isExist(parId, itemNo));
		groupMap.put("itemPerilGroupedExist", this.getGipiWItemPerilService().isExist2(parId, itemNo));
		//groupMap.put("gipiWItmperlGrouped", new JSONArray(itmPerilGroupedService.getGipiWItmperlGrouped(parId, itemNo)));
		//groupMap.put("gipiWGrpItemsBeneficiary", new JSONArray(grpItmBenService.getGipiWGrpItemsBeneficiary(parId, itemNo)));
		//groupMap.put("gipiWItmperlBeneficiary", new JSONArray(itmperlBenService.getGipiWItmperlBeneficiary(parId, itemNo)));
		groupMap.put("itemTsi", this.getGipiWItemService().getTsiPremAmt(parId, itemNo));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWGroupedItemsTableGrid");		
		tgParams.put("parId", parId);
		tgParams.put("itemNo", itemNo);		
		
		//Map<String, Object> itemAccidentTG = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemAccidentTG = TableGridUtil.getTableGrid3(request, tgParams);  //replaced by: Mark C. 04152015  SR4302
		//itemAccidentTG.put("gipiWGroupedItems", new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems2(parId, itemNo)));
		itemAccidentTG.put("gipiWGroupedItems", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems2(parId, itemNo)))); //replaced by: Mark C. 04152015 SR4302
		itemAccidentTG.put("gipiWItmperlGrouped", new JSONArray(this.getGipiWItmperlGroupedService().getGipiWItmperlGrouped(parId, itemNo)));
		//itemAccidentTG.put("gipiWGrpItemsBeneficiary", new JSONArray(this.getGipiWGrpItemsBeneficiaryService().getGipiWGrpItemsBeneficiary(parId, itemNo)));
		itemAccidentTG.put("gipiWGrpItemsBeneficiary", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWGrpItemsBeneficiaryService().getGipiWGrpItemsBeneficiary(parId, itemNo)))); //replaced by: Mark C. 04152015 SR4302
		itemAccidentTG.put("gipiWItmperlBeneficiary", new JSONArray(this.getGipiWItmperlBeneficiaryService().getGipiWItmperlBeneficiary(parId, itemNo)));
		
		request.setAttribute("accGroupedItemsTableGrid", new JSONObject(itemAccidentTG));
		
		return groupMap;
	}

	@Override
	public void saveAccidentGroupedItemsModalTG(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject((String) params.get("param"));
		//GIISUser user = (GIISUser) params.get("USER");
		
		params.put("setItemRows", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		//params.put("delItemRows", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("accidentItems", this.prepareAccidentItemsForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(objParams.getString("setGroupedItems"))));
		params.put("delGroupedItems", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForDelete(new JSONArray(objParams.getString("delGroupedItems"))));
		params.put("setCoverages", this.getGipiWItmperlGroupedService().prepareGIPIWItmperlGroupedForInsertUpdate(new JSONArray(objParams.getString("setCoverages"))));
		params.put("delCoverages", this.getGipiWItmperlGroupedService().prepareGIPIWItmperlGroupedForDelete(new JSONArray(objParams.getString("delCoverages"))));
		params.put("setBeneficiaries", this.getGipiWGrpItemsBeneficiaryService().prepareGIPIWGrpItemsBeneficiaryForInsertUpdate(new JSONArray(objParams.getString("setBeneficiaries"))));
		params.put("delBeneficiaries", this.getGipiWGrpItemsBeneficiaryService().prepareGIPIWGrpItemsBeneficiaryForDelete(new JSONArray(objParams.getString("delBeneficiaries"))));
		params.put("setBenPerils", this.getGipiWItmperlBeneficiaryService().prepareGIPIWItmperlBeneficiaryForInsertUpdate(new JSONArray(objParams.getString("setBenPerils"))));
		params.put("delBenPerils", this.getGipiWItmperlBeneficiaryService().prepareGIPIWItmperlBeneficiaryForDelete(new JSONArray(objParams.getString("delBenPerils"))));
		
		params.put("misc", new JSONObject(objParams.getString("misc")));
		
		/*
		params.put("vars", new JSONObject(objParams.getString("vars")));
		params.put("pars", new JSONObject(objParams.getString("pars")));		
		
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("parType", objParams.getString("parType"));
		params.put("userId", user.getUserId());
		*/
		//params.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));
		
		this.getGipiWAccidentItemDAO().saveAccidentGroupedItemsModalTG(params);		
	}	

	@Override
	public Map<String, Object> showPopulateBenefits(Map<String, Object> params)
			throws SQLException, JSONException {		
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		Integer parId = Integer.parseInt(request.getParameter("parId"));
		Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWGroupedItemsTableGrid");		
		tgParams.put("parId", parId);
		tgParams.put("itemNo", itemNo);
		
		// this parameters is used in accident grouped items
		if(request.getParameter("notIn") != null && !(request.getParameter("notIn").equals(""))){
			tgParams.put("notIn", request.getParameter("notIn"));
		}		
		
		request.setAttribute("command", request.getParameter("command"));
		request.setAttribute("selectedGroupedItemNo", request.getParameter("selectedGroupedItemNo"));
		request.setAttribute("popChecker", request.getParameter("popChecker"));
		
		Map<String, Object> popBenefits = TableGridUtil.getTableGrid(request, tgParams);
		
		// this parameters is used in accident grouped items
		if(request.getParameter("notIn") != null && !(request.getParameter("notIn").equals(""))){
			popBenefits.put("gipiWGroupedItems", new JSONArray(this.getGipiWGroupedItemsService().getGIPIWGroupedItems(tgParams)));
		}else{
			popBenefits.put("gipiWGroupedItems", new JSONArray(this.getGipiWGroupedItemsService().getGipiWGroupedItems2(parId, itemNo)));
		}		
		
		return popBenefits;
	}

	@Override
	public void populateBenefits(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String parameters = params.get("parameters").toString();		
		
		paramMap.put("groupedItemList", this.getGipiWGroupedItemsService().prepareGIPIWGroupedItemsForInsertUpdate(new JSONArray(parameters)));
		paramMap.put("selectedGroupedItemNo", params.get("selectedGroupedItemNo"));
		paramMap.put("delBenSw", params.get("delBenSw").toString());				
		paramMap.put("popChecker", params.get("popChecker").toString());
		paramMap.put("issCd", params.get("issCd"));
		paramMap.put("lineCd", params.get("lineCd"));
		
		this.getGipiWAccidentItemDAO().populateBenefits(paramMap);		
	}	
}
