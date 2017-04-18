package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.MediaAlreadyExistingException;
import com.geniisys.common.exceptions.UploadSizeLimitExceededException;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWVehicleDAO;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWVehicle;
import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIMCUploadService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemDiscountService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWMcAccService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.service.GIPIWVehicleService;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.gipi.util.GIPIWItemUtil;
import com.seer.framework.util.StringFormatter;

/**
 * 
 * @author rencela
 *
 */
public class GIPIWVehicleServiceImpl implements GIPIWVehicleService{
	
	private GIPIWVehicleDAO gipiWVehicleDAO;
	private GIPIWPolbasService gipiWPolbasService;
	private GIPIWItemService gipiWItemService;
	private GIPIWPerilDiscountService gipiWPerilDiscountService;
	private GIPIWItemDiscountService gipiWItemDiscountService;
	private GIPIWPolbasDiscountService gipiWPolbasDiscountService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIParMortgageeFacadeService gipiWMortgageeService;
	private GIPIWMcAccService gipiWMcAccService;
	private GIPIWItemPerilService gipiWItemPerilService;
	private GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService;
	
	private static Logger log = Logger.getLogger(GIPIWVehicleServiceImpl.class);

	public GIPIWVehicleDAO getGipiWVehicleDAO() {
		return gipiWVehicleDAO;
	}

	public void setGipiWVehicleDAO(GIPIWVehicleDAO gipiWVehicleDAO) {
		this.gipiWVehicleDAO = gipiWVehicleDAO;
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

	public GIPIParMortgageeFacadeService getGipiWMortgageeService() {
		return gipiWMortgageeService;
	}

	public void setGipiWMortgageeService(
			GIPIParMortgageeFacadeService gipiWMortgageeService) {
		this.gipiWMortgageeService = gipiWMortgageeService;
	}	

	public GIPIWMcAccService getGipiWMcAccService() {
		return gipiWMcAccService;
	}

	public void setGipiWMcAccService(GIPIWMcAccService gipiWMcAccService) {
		this.gipiWMcAccService = gipiWMcAccService;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#newFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> newFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
		
				
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWVehicleDAO().gipis010NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package		
		request.setAttribute("ctplDfltTsiAmt", giisParamService.getParamValueN("CTPL_PERIL_TSI"));
		request.setAttribute("ctplCd", giisParamService.getParamValueN("CTPL"));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		formMap.put("itemVehicles", new JSONArray(this.getGipiWItemService().getParItemMC(parId)));
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		formMap.put("objGIPIWMcAccs", new JSONArray(this.getGipiWMcAccService().getGipiWMcAccbyParId(parId)));
		formMap.put("objGIPIWMortgagee", new JSONArray(this.getGipiWMortgageeService().getGIPIWMortgagee(parId)));
		
		return formMap;
	}
	
	/**
	 * 
	 * @param request
	 * @param lovHelper
	 * @param gipiWPolbas
	 */
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper, GIPIWPolbas gipiWPolbas){
		//String[] covs = {null, null};
		String[] covs = {gipiWPolbas.getLineCd(), StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] groupParam = {gipiWPolbas.getAssdNo()};
		String[] motorTypeParam = {StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] cgRefCodes = {"GIPI_VEHICLE.MOTOR_COVERAGE"};
		String[] perilParam = {"" /*packLineCd*/, gipiWPolbas.getLineCd(), "" /*packSublineCd*/, StringFormatter.unescapeHtmlJava(gipiWPolbas.getSublineCd()), Integer.toString(gipiWPolbas.getParId())}; //Deo [01.03.2017]: added StringFormatter (SR-23567)
		String[] mortgParam = {String.valueOf(gipiWPolbas.getParId()), gipiWPolbas.getIssCd()};
		String[] regTypeParam = {"GIPI_VEHICLE.REG_TYPE"};
		
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		request.setAttribute("coverages", lovHelper.getList(LOVHelper.COVERAGE_CODES, covs));
		request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING2, groupParam));
		request.setAttribute("regions", lovHelper.getList(LOVHelper.REGION_LISTING));		
		request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));
		//request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));
		//request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_LISTING_BY_SUBLINE1, motorTypeParam));
		request.setAttribute("basicColors", lovHelper.getList(LOVHelper.MC_BASIC_COLOR_LISTING));
		request.setAttribute("colors", lovHelper.getList(LOVHelper.MC_ALL_COLOR));
		//request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_LISTING_BY_SUBLINE, motorTypeParam));
		request.setAttribute("motorTypes", lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING, motorTypeParam));
		request.setAttribute("sublineTypes", lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING, motorTypeParam));
		request.setAttribute("motorCoverages", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, cgRefCodes));
		request.setAttribute("perilListing", StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PERIL_SUBLINE_LISTING, perilParam)));
		
		request.setAttribute("accessoryListing", lovHelper.getList(LOVHelper.ACCESSORY_LISTING)); // accessory
		request.setAttribute("mortgageeListing", lovHelper.getList(LOVHelper.MORTGAGEE_LISTING_POLICY, mortgParam)); // mortgagee
		request.setAttribute("regTypeListing", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, regTypeParam));
	}
	
	/**
	 * 
	 * @param newInstanceMap
	 * @return
	 * @throws JSONException
	 */
	private JSONObject createObjectVariable(Map<String, Object> newInstanceMap) throws JSONException{		
		JSONObject objVar = new JSONObject();
		
		objVar.put("varVRecCount", JSONObject.NULL);		
		objVar.put("varVNumber", JSONObject.NULL);
		objVar.put("varVCount", 0);
		objVar.put("varValRecSw", "N");
		objVar.put("varVDeductibles", 0);
		objVar.put("varVSumDeductibles", 0);
		objVar.put("varVTotalDeductibles", JSONObject.NULL);
		objVar.put("varVPrevTotalDedutibles", 0);
		objVar.put("varOldCurrencyCd", JSONObject.NULL);
		objVar.put("varVPar", JSONObject.NULL);
		objVar.put("varCheckSw", "N");
		objVar.put("varOldCurrencyDesc", JSONObject.NULL);
		objVar.put("varVDateFormat", JSONObject.NULL /*Conflict sa oracle forms at web form :D kaya null na muna*/);
		objVar.put("varUpdateSw", "N");
		objVar.put("varInsertDeleteSw", "N");
		objVar.put("varNoVehicleInfo", "N");
		objVar.put("varCopyFlag", "N");
		objVar.put("varWVehicleUpdFlag", "N");
		objVar.put("varCreatePackItem", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varPrevTariffZone", JSONObject.NULL);
		objVar.put("varPrevTariffZoneDesc", JSONObject.NULL);
		objVar.put("varPrevDeductibleCd", JSONObject.NULL);
		objVar.put("varPrevDeductibleTitle", JSONObject.NULL);
		objVar.put("varVPackPolFlag", JSONObject.NULL);
		objVar.put("varVItemTag", JSONObject.NULL);
		objVar.put("varPrevDeductibleAmt", JSONObject.NULL);
		objVar.put("varPost", JSONObject.NULL);
		objVar.put("varSwitchPostRec", "N");
		objVar.put("varDiscExist", "N");
		objVar.put("varGroupSw", "N");
		objVar.put("varOldCoverageCd", JSONObject.NULL);
		objVar.put("varOldCoverageDesc", JSONObject.NULL);
		objVar.put("varSublineCommercial", newInstanceMap.get("varSublineCommercial"));
		objVar.put("varSublineMotorcycle", newInstanceMap.get("varSublineMotorcycle"));
		objVar.put("varSublinePrivate", newInstanceMap.get("varSublinePrivate"));
		objVar.put("varSublineLto", newInstanceMap.get("varSublineLto"));
		objVar.put("varCocLto", newInstanceMap.get("varCocLto"));
		objVar.put("varCocNlto", newInstanceMap.get("varCocNlto"));
		objVar.put("varOldSerial", JSONObject.NULL);
		objVar.put("varOldMotor", JSONObject.NULL);
		objVar.put("varOldPlate", JSONObject.NULL);
		objVar.put("varOldCarCompany", JSONObject.NULL);
		objVar.put("varOldMake", JSONObject.NULL);
		objVar.put("varOldEngine", JSONObject.NULL);
		objVar.put("varVCopyItem", JSONObject.NULL);
		objVar.put("varPost2", "Y");
		objVar.put("varOldGroupCd", JSONObject.NULL);
		objVar.put("varOldGroupDesc", JSONObject.NULL);
		objVar.put("varCoInsSw", JSONObject.NULL);
		objVar.put("varVMcCompanySw", newInstanceMap.get("varMcCompanySw"));
		objVar.put("varOldMotorCoverageCd", JSONObject.NULL);
		objVar.put("varOldMotorCoverage", JSONObject.NULL);
		objVar.put("varVGenerateCOC", newInstanceMap.get("varGenerateCoc"));
		objVar.put("varVCopyItemTag", false);
		objVar.put("varPlanSw", newInstanceMap.get("planSw"));		
		
		return objVar;
	}
	
	/**
	 * 
	 * @param newInstanceMap
	 * @return
	 * @throws JSONException
	 */
	private JSONObject createObjectParameter(Map<String, Object> newInstanceMap) throws JSONException {
		JSONObject objParam = new JSONObject();
		
		objParam.put("paramDfltCoverage", newInstanceMap.get("parDfltCoverage"));
		objParam.put("paramDefaultCurrency", newInstanceMap.get("defaultCurrency"));
		objParam.put("paramDefaultRegion", newInstanceMap.get("defaultRegion"));
		objParam.put("paramDefaultTowing", newInstanceMap.get("defaultTowing"));
		objParam.put("paramDefaultPlateNo", newInstanceMap.get("defaultPlateNo"));
		objParam.put("paramOtherSw", "N");
		objParam.put("paramDdlCommit", "N");
		objParam.put("paramPostRecSwitch", "N");
		objParam.put("paramPostSw", "N");
		objParam.put("paramOra2010Sw", newInstanceMap.get("ora2010Sw"));
		objParam.put("paramUserAccess", newInstanceMap.get("userAccess"));
		objParam.put("paramIsPack", newInstanceMap.get("isPack"));
		
		return objParam;
	}
	
	/**
	 * 
	 * @return
	 * @throws JSONException
	 */
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

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#saveGIPIWVehicle(java.lang.String, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void saveGIPIWVehicle(String param, GIISUser user)
			throws SQLException, JSONException, ParseException {		
		JSONObject objParams = new JSONObject(param);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("vehicleItems", this.prepareGIPIWVehicleForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("setMortgagees", this.getGipiWMortgageeService().prepareGIPIWMortgageeForInsert(new JSONArray(objParams.getString("setMortgagees"))));
		params.put("delMortgagees", this.getGipiWMortgageeService().prepareGIPIWMortgageeForDelete(new JSONArray(objParams.getString("delMortgagees"))));
		params.put("setAccessories", this.getGipiWMcAccService().prepareGIPIWMcAccForInsert(new JSONArray(objParams.getString("setAccRows"))));
		params.put("delAccessories", this.getGipiWMcAccService().prepareGIPIWMcAccForDelete(new JSONArray(objParams.getString("delAccRows"))));
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
				
		//to include parameters needed for peril updates BRY 02.08.2011
		params = gipiWItemPerilService.updateItemServiceParams(params, objParams);
		
		this.getGipiWVehicleDAO().saveGIPIWVehicle(params);					
	}
	
	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	/**
	 * 
	 * @param gipiWItemPerilService
	 */
	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}

	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIPIWVehicle> prepareGIPIWVehicleForInsert(JSONArray setRows) throws JSONException, ParseException{
		List<GIPIWVehicle> vehicleList = new ArrayList<GIPIWVehicle>();
		GIPIWVehicle vehicle = null;
		JSONObject objItem = null;
		JSONObject objVehicle = null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=setRows.length(); i < length; i++){
			vehicle = new GIPIWVehicle();
			objItem = setRows.getJSONObject(i);
			objVehicle = objItem.isNull("gipiWVehicle") ? null : objItem.getJSONObject("gipiWVehicle");
			
			if(objVehicle != null){
				vehicle.setParId(objItem.isNull("parId") ? null : objItem.getInt("parId"));
				vehicle.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
				vehicle.setAssignee(objVehicle.isNull("assignee") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("assignee")));
				vehicle.setAcquiredFrom(objVehicle.isNull("acquiredFrom") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("acquiredFrom")));
				vehicle.setMotorNo(objVehicle.isNull("motorNo") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("motorNo")));
				vehicle.setOrigin(objVehicle.isNull("origin") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("origin")));
				vehicle.setDestination(objVehicle.isNull("destination") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("destination")));
				vehicle.setTypeOfBodyCd(objVehicle.isNull("typeOfBodyCd") ? null : objVehicle.getInt("typeOfBodyCd"));
				vehicle.setPlateNo(objVehicle.isNull("plateNo") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("plateNo")));
				vehicle.setModelYear(objVehicle.isNull("modelYear") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("modelYear")));
				vehicle.setCarCompanyCd(objVehicle.isNull("carCompanyCd") ? null : objVehicle.getInt("carCompanyCd"));
				vehicle.setMvFileNo(objVehicle.isNull("mvFileNo") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("mvFileNo")));
				vehicle.setNoOfPass(objVehicle.isNull("noOfPass") ? null : objVehicle.getInt("noOfPass"));
				vehicle.setMakeCd(objVehicle.isNull("makeCd") ? null : objVehicle.getInt("makeCd"));
				vehicle.setBasicColorCd(objVehicle.isNull("basicColorCd") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("basicColorCd")));
				vehicle.setColorCd(objVehicle.isNull("colorCd") ? null : objVehicle.getInt("colorCd"));
				vehicle.setSeriesCd(objVehicle.isNull("seriesCd") ? null : objVehicle.getInt("seriesCd"));
				vehicle.setMotType(objVehicle.isNull("motType") ? null : objVehicle.getInt("motType"));
				vehicle.setUnladenWt(objVehicle.isNull("unladenWt") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("unladenWt")));
				vehicle.setTowing(objVehicle.isNull("towing") ? null : new BigDecimal(objVehicle.getString("towing").replaceAll(",", "")));
				vehicle.setSerialNo(objVehicle.isNull("serialNo") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("serialNo")));
				vehicle.setSublineTypeCd(objVehicle.isNull("sublineTypeCd") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("sublineTypeCd")));
				vehicle.setCocType(objVehicle.isNull("cocType") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("cocType")));
				vehicle.setCocSerialNo(objVehicle.isNull("cocSerialNo") ? null : objVehicle.getInt("cocSerialNo"));
				vehicle.setCocYy(objVehicle.isNull("cocYy") ? null : objVehicle.getInt("cocYy"));
				vehicle.setCtvTag(objVehicle.isNull("ctvTag") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("ctvTag")));
				vehicle.setRepairLim(objVehicle.isNull("repairLim") ? null : new BigDecimal(objVehicle.getString("repairLim").replaceAll(",", "")));
				vehicle.setMotorCoverage(objVehicle.isNull("motorCoverage") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("motorCoverage")));
				vehicle.setSublineCd(objVehicle.isNull("sublineCd") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("sublineCd")));
				vehicle.setCocSerialSw(objVehicle.isNull("cocSerialSw") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("cocSerialSw")));
				vehicle.setEstValue(objVehicle.isNull("estValue") ? null : new BigDecimal(objVehicle.getString("estValue")));
				vehicle.setTariffZone(objVehicle.isNull("tariffZone") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("tariffZone")));
				vehicle.setCocIssueDate(objVehicle.isNull("cocIssueDate") ? null : sdf.parse(objVehicle.getString("cocIssueDate")));
				vehicle.setCocSeqNo(objVehicle.isNull("cocSeqNo") ? null : objVehicle.getInt("cocSeqNo"));
				vehicle.setCocAtcn(objVehicle.isNull("cocAtcn") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("cocAtcn")));
				vehicle.setMake(objVehicle.isNull("make") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("make")));
				vehicle.setColor(objVehicle.isNull("color") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("color")));
				vehicle.setRegType(objVehicle.isNull("regType") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("regType")));
				vehicle.setMvType(objVehicle.isNull("mvType") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("mvType")));
				vehicle.setMvPremType(objVehicle.isNull("mvPremType") ? null : StringFormatter.unescapeHtmlJava(objVehicle.getString("mvPremType")));
				
				vehicleList.add(vehicle);
				vehicle = null;				
			}			
		}
		
		return vehicleList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#checkCOCSerialNoInPolicyAndPar(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public String checkCOCSerialNoInPolicyAndPar(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("cocType", request.getParameter("cocType"));
		params.put("cocSerialNo", Integer.parseInt(request.getParameter("cocSerialNo")));
		params.put("cocYy", request.getParameter("cocYy")); //jcmbrigino 01212014 UCPBGEN-14750
		
		Debug.print("check COC params - "+params);
		return this.getGipiWVehicleDAO().checkCOCSerialNoInPolicyAndPar(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#validateOtherInfo(java.lang.String)
	 */
	@Override
	public String validateOtherInfo(String param) throws SQLException,
			JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setItems", GIPIWItemUtil.prepareGIPIWItemMapForInsert(new JSONArray(objParams.getString("setItemRows"))));
		params.put("delItems", GIPIWItemUtil.prepareGIPIWItemForDelete(new JSONArray(objParams.getString("delItemRows"))));
		params.put("vehicleItems", this.prepareGIPIWVehicleForInsert(new JSONArray(objParams.getString("setItemRows"))));		
		params.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));		
		params.put("misc", new JSONObject(objParams.getString("misc")));
		
		return this.getGipiWVehicleDAO().validateOtherInfo(params);
	}

	/**
	 * @param gipiWPolWCService the gipiWPolWCService to set
	 */
	public void setGipiWPolWCService(GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService) {
		this.gipiWPolWCService = gipiWPolWCService;
	}

	/**
	 * @return the gipiWPolWCService
	 */
	public GIPIWPolicyWarrantyAndClauseFacadeService getGipiWPolWCService() {
		return gipiWPolWCService;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#uploadFleetData(java.util.Map)
	 */
	@Override
	public void uploadFleetData(Map<String, Object> params)
			throws SQLException, JSONException, IOException,  MediaAlreadyExistingException{
		ApplicationContext APPLICATION_CONTEXT= (ApplicationContext) params.get("APPLICATION_CONTEXT");
		ServletContext servletContext = (ServletContext) params.get("servletContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		HttpServletResponse response = (HttpServletResponse) params.get("response");
		
		GIPIMCUploadService mcUploadService = (GIPIMCUploadService) APPLICATION_CONTEXT.getBean("gipiMCUploadService");
			
		int parId = Integer.parseInt(request.getParameter("parId"));
		String filePath = (String) APPLICATION_CONTEXT.getBean("uploadPath");
		
		// create file upload factory and upload servlet
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		
		// set file upload progress listener
		FileUploadListener listener = new FileUploadListener();
		HttpSession session = request.getSession();
		session.setAttribute("LISTENER", listener);
		
		// upload servlet allows to set upload listener
		upload.setProgressListener(listener);
		
		// to be used to write response
		StringBuffer sb = new StringBuffer();
		
		List items = null;
		FileItem fileItem = null;
		String myFileName = "";
		
		try{
			(new File(filePath + "/" + parId)).mkdir();
			filePath = filePath + "/" + parId;
			
			// iterate over all uploaded files
			items = upload.parseRequest(request);
			File uploadedFile = null;
			
			for(Iterator i = items.iterator(); i.hasNext();){
				fileItem = (FileItem) i.next();
				if(!(fileItem.isFormField())){
					if(fileItem.getSize() > 0){
						// code that handle uploaded fileItem
						// don't forget to delete uploaded files after you're done
						// with them. use fileItem.delete()
						
						String myFullFileName = fileItem.getName();
						String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/"; // Windows or Unix
						int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
						int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
						
						// Ignore the path and get the filename
						myFileName = myFullFileName.substring(lastIndexOfSlash+1);
						
						if(!(FileUtil.isExcelFile(myFullFileName, lastIndexOfPeriod))){
							fileItem.delete();
							throw new FileUploadException("The file you are trying to upload is not supported.");					
						}else if(listener.getBytesRead() > 1048576){
							fileItem.delete();
							throw new UploadSizeLimitExceededException("Upload limit is only 1MB");
						}else{
							// create new file object
							System.out.println("Path : " + filePath);
							uploadedFile = new File(filePath, myFileName);
							if(uploadedFile.isFile()){
								throw new MediaAlreadyExistingException("Media already exists!");
							}
							
							// write the uploaded file to the system
							fileItem.write(uploadedFile);
							sb.append("SUCCESS");
							
							// write media to drive c:
							if(("".equalsIgnoreCase(mcUploadService.validateUploadFile(myFileName)))){
								throw new MediaAlreadyExistingException("The fleet data you are trying to upload is already existing!");
							}						
							
							System.out.println("Filename : " + myFileName);
							
							List<GIPIWItem> fleetUploads = new ArrayList<GIPIWItem>();
							try {
								HSSFWorkbook fleet = new HSSFWorkbook(new FileInputStream(uploadedFile));
								HSSFSheet sheet = fleet.getSheetAt(0);
								int rows = sheet.getPhysicalNumberOfRows();
								System.out.println("Rows: " + rows);								
								
								for (int r = 1; r < rows; r++) {
									HSSFRow row = sheet.getRow(r);
									if (row == null) {
										continue;
									}
						
									int cells = row.getPhysicalNumberOfCells();
									System.out.println("Cells: " + cells);
									String value = null;
									GIPIWItem item = new GIPIWItem();
									GIPIWVehicle vehicle = new GIPIWVehicle();
									
									item.setParId(parId);
									
									for (short c = 0; c < cells; c++) {
										HSSFCell cell = row.getCell(c);
										switch (cell.getCellType()) {
											case HSSFCell.CELL_TYPE_NUMERIC:
												value = String.valueOf((int) cell.getNumericCellValue());
												break;
											case HSSFCell.CELL_TYPE_STRING:
												value = cell.getStringCellValue();
												break;											
											default:
										}
										
										switch (c) {
											case 0: item.setItemNo("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 1: item.setItemTitle("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 2: item.setCoverageCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 3: item.setCurrencyCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 4: item.setCurrencyRt(new BigDecimal(value)); break;
											case 5: item.setItemDesc("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 6: item.setItemDesc2("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 7: item.setRegionCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 8: vehicle.setAcquiredFrom("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 9: vehicle.setAssignee("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 10: vehicle.setBasicColorCd("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 11: vehicle.setCarCompanyCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 12: vehicle.setCocAtcn("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 13: vehicle.setCocIssueDate("".equalsIgnoreCase(value) ? null : null); break;
											case 14: vehicle.setCocSeqNo("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 15: vehicle.setCocSerialNo(Integer.parseInt(value)); break;
											case 16: vehicle.setCocType("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 17: vehicle.setCocYy("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 18: vehicle.setColor("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 19: vehicle.setColorCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 20: vehicle.setCtvTag("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 21: vehicle.setDestination("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 22: vehicle.setEstValue("".equalsIgnoreCase(value) ? null : new BigDecimal(value)); break;
											case 23: vehicle.setModelYear("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 24: vehicle.setMake("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 25: vehicle.setMakeCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 26: vehicle.setMotType("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 27: vehicle.setMotorNo("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 28: vehicle.setMvFileNo("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 29: vehicle.setNoOfPass("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 30: vehicle.setOrigin("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 31: vehicle.setPlateNo("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 32: vehicle.setRepairLim("".equalsIgnoreCase(value) ? null : new BigDecimal(value)); break;
											case 33: vehicle.setSerialNo("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 34: vehicle.setSeriesCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 35: vehicle.setSublineTypeCd("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 36: vehicle.setTariffZone("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;
											case 37: vehicle.setTowing("".equalsIgnoreCase(value) ? null : new BigDecimal(value)); break;
											case 38: vehicle.setTypeOfBodyCd("".equalsIgnoreCase(value) ? null : Integer.parseInt(value)); break;
											case 39: vehicle.setUnladenWt("".equalsIgnoreCase(value) ? null : StringEscapeUtils.escapeJava(value)); break;										
											default:
										}
										
										item.setGipiWVehicle(vehicle);
										System.out.print(value+"\t\t\t");
									}
									//uFleet.setFileName(myFileName);
									//uFleet.setUploadNo(r);
									fleetUploads.add(item);
								}
								System.out.println("\n");
								System.out.println("Fleet Size: " + fleetUploads.size());
							} catch (NumberFormatException e) {
								e.printStackTrace();
								log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
								throw new InvalidUploadFeetDataException("The file has invalid data formatting.");
							} catch (FileNotFoundException e) {
								e.printStackTrace();
								log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
							} catch (IOException e) {
								e.printStackTrace();
								log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
							}
						}
					}
				}
			}
		}catch (InvalidUploadFeetDataException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - " +e.getMessage());
		} catch (MediaAlreadyExistingException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
			throw new MediaAlreadyExistingException("ERROR: " + e.getMessage());			
		} catch (FileUploadException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (UploadSizeLimitExceededException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			response.getWriter().write("ERROR - "+e.getMessage());
		} finally {
			session.removeAttribute("LISTENER");
			FileUtil.deleteDirectory(filePath);
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#gipis060NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis060NewFormInstance(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();
				
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
		GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		
		//int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId")); // andrew - 07.08.2011
		int parId = Integer.parseInt(request.getParameter("parId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWVehicleDAO().gipis010NewFormInstance(newInstanceMap);
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		request.setAttribute("ctplDfltTsiAmt", giisParamService.getParamValueN("CTPL_PERIL_TSI"));
		request.setAttribute("displayMotorCoverage", giisParamService.getParamValueV2("DISPLAY_MOTOR_COVERAGE")); // added by: Nica 05.15.2012
		request.setAttribute("parType", "E");
		request.setAttribute("gipiPolbasics", StringFormatter.escapeHTMLInJSONArray(new JSONArray(gipiPolbasicService.getEndtPolicyMC(parId)))); // andrew - 07162015 - SR 19819/19298
		request.setAttribute("gipiWPolbas", new JSONObject(gipiWPolbasService.getGipiWPolbas(parId)));
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());
		formMap.put("itemVehicles", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMC(parId)))); // andrew - 07162015 - SR 19819/19298
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		formMap.put("objGIPIWMcAccs", new JSONArray(this.getGipiWMcAccService().getGipiWMcAccbyParId(parId)));
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

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWVehicleService#gipis060ValidateItem(java.util.Map)
	 */
	@Override
	public void gipis060ValidateItem(Map<String, Object> params)
			throws SQLException {
		this.getGipiWVehicleDAO().gipis060ValidateItem(params);
	}
	
	@Override
	public Map<String, Object> newFormInstanceTG(Map<String, Object> params)
			throws SQLException, JSONException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		Map<String, Object> newInstanceMap = new HashMap<String, Object>();		
				
		ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		int parId = Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		GIPIWPolbas gipiWPolbas = this.getGipiWPolbasService().getGipiWPolbas(parId);
		
		newInstanceMap.put("parId", gipiWPolbas.getParId());
		newInstanceMap = this.getGipiWVehicleDAO().gipis010NewFormInstance(newInstanceMap);		
		
		loadListingToRequest(request, lovHelper, gipiWPolbas);
		
		request.setAttribute("USER", params.get("USER"));		
		request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.17.2011 - to determine if package
		request.setAttribute("ctplDfltTsiAmt", giisParamService.getParamValueN("CTPL_PERIL_TSI"));
		request.setAttribute("ctplCd", giisParamService.getParamValueN("CTPL"));
		request.setAttribute("displayMotorCoverage", giisParamService.getParamValueV2("DISPLAY_MOTOR_COVERAGE")); // added by: Nica 05.15.2012
		newInstanceMap.put("isPack", request.getParameter("isPack"));		
		
		formMap.put("vars", this.createObjectVariable(newInstanceMap));
		formMap.put("pars", this.createObjectParameter(newInstanceMap));
		formMap.put("misc", this.createObjectMiscVariables());		
		formMap.put("gipiWPerilDiscount", new JSONArray(this.getGipiWPerilDiscountService().getDeleteDiscountList(parId)));		
		
		Map<String, Object> tgParams = new HashMap<String, Object>();		
		tgParams.put("ACTION", "getGIPIWItemTableGridMC");		
		tgParams.put("parId", parId);
		tgParams.put("pageSize", 5);		
		
		//Map<String, Object> itemMotorTableGrid = TableGridUtil.getTableGrid(request, tgParams);
		Map<String, Object> itemMotorTableGrid = TableGridUtil.getTableGrid3(request, tgParams);  //replaced by: Mark C. 04162015 SR4302
		//itemMotorTableGrid.put("gipiWItem", new JSONArray(this.getGipiWItemService().getParItemMC(parId)));
		itemMotorTableGrid.put("gipiWItem", StringFormatter.escapeHTMLInJSONArray(new JSONArray(this.getGipiWItemService().getParItemMC(parId)))); //replaced by: Mark C. 04162015 SR4302
		itemMotorTableGrid.put("gipiWDeductibles", new JSONArray(this.getGipiWDeductibleService().getAllGIPIWDeductibles(parId)));
		itemMotorTableGrid.put("gipiWItemPeril", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));
		itemMotorTableGrid.put("gipiWMortgagee", new JSONArray(this.getGipiWMortgageeService().getGIPIWMortgagee(parId)));
		itemMotorTableGrid.put("gipiWMcAcc", new JSONArray(this.getGipiWMcAccService().getGipiWMcAccbyParId(parId)));
		request.setAttribute("itemTableGrid", new JSONObject(itemMotorTableGrid));
		
		return formMap;
	}

	@Override
	public Map<String, Object> validatePlateNo(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWVehicleDAO().validatePlateNo(params);
	}

	@Override
	public String validateCocSerialNo(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWVehicleDAO().validateCocSerialNo(params);		
	}

	@Override
	public List<GIPIWVehicle> getVehiclesForPAR(Integer parId)
			throws SQLException {
		return this.getGipiWVehicleDAO().getVehiclesForPAR(parId);
	}	
}
