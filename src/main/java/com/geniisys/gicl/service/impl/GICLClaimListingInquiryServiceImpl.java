/***************************************************
\ * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	gzelle
 * Create Date	:	02.07.2013
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClaimListingInquiryDAO;
import com.geniisys.gicl.service.GICLClaimListingInquiryService;

public class GICLClaimListingInquiryServiceImpl implements GICLClaimListingInquiryService {
	
	private GICLClaimListingInquiryDAO giclClaimListingInquiryDAO;
	

	public GICLClaimListingInquiryDAO getGiclClaimListingInquiryDAO() {
		return giclClaimListingInquiryDAO;
	}

	public void setGiclClaimListingInquiryDAO(GICLClaimListingInquiryDAO giclClaimListingInquiryDAO) {
		this.giclClaimListingInquiryDAO = giclClaimListingInquiryDAO;
	}

	@Override
	public JSONObject showClaimListingPerColor(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerColor");				
		params.put("appUser", USER.getUserId());
		params.put("colorCd", request.getParameter("colorCd"));
		params.put("basicColorCd", request.getParameter("basicColorCd"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		Map<String, Object> clmListPerColorTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(clmListPerColorTableGrid);
		request.setAttribute("jsonClmListPerColor", json);
		return json;
	}

	@Override
	public String validateColorPerColor(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println("!" + request.getParameter("basicColorCd") + "!" + request.getParameter("color"));
		params.put("ACTION", "validateColorPerColor");
		params.put("basicColorCd", request.getParameter("basicColorCd"));
		params.put("color", request.getParameter("color"));
		return this.giclClaimListingInquiryDAO.validateColorPerColor(params);
	}

	@Override
	public String validateBasicColorPerColor(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateBasicColorPerColor");
		params.put("basicColor", request.getParameter("basicColor"));
		return this.giclClaimListingInquiryDAO.validateBasicColorPerColor(params);
	}
	
	@Override
	public JSONObject showClmListingPerAdjuster(HttpServletRequest request,GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerAdjuster");				
		params.put("appUser", USER.getUserId());
		params.put("payeeNo", request.getParameter("id"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("status", request.getParameter("status"));
		
		Map<String, Object> clmListPerAdjusterTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerAdjuster = new JSONObject(clmListPerAdjusterTableGrid);
		request.setAttribute("jsonClmListPerAdjuster", jsonClmListPerAdjuster);
		return jsonClmListPerAdjuster;
	}

	@Override
	public String validatePayeePerAdjuster(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validatePayeePerAdjuster");
		params.put("payee", request.getParameter("payee"));
		return this.giclClaimListingInquiryDAO.validatePayeePerAdjuster(params);
	}

	@Override
	public JSONObject showClaimListingPerAssured(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmListPerAssured");
		params.put("moduleId", "GICLS251");
		params.put("userId", USER.getUserId());
		params.put("assdNo", request.getParameter("assdNo"));
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		Map<String, Object> perAssuredTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerAssured = new JSONObject(perAssuredTableGrid);
		return jsonClmListPerAssured;
	}
	
	@Override
	public JSONObject showPerAssuredFreeText(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPerAssuredFreeText");
		params.put("moduleId", "GICLS251");
		params.put("userId", USER.getUserId());
		params.put("freeText",request.getParameter("txtFreeText"));
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		Map<String, Object> perAssuredTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerAssured = new JSONObject(perAssuredTableGrid);
		return jsonClmListPerAssured;
	}

	@Override
	public JSONObject showClaimListingPerBlock(HttpServletRequest request, GIISUser USER) throws SQLException,JSONException, ParseException {
			Map<String, Object> params = new HashMap<String, Object>();				
			params.put("ACTION", "getClmListPerBlock");				
			params.put("appUser", USER.getUserId());
			params.put("districtNo", request.getParameter("districtNo"));
			params.put("blockNo", request.getParameter("blockNo"));
			params.put("searchBy", request.getParameter("searchBy"));
			params.put("asOfDate", request.getParameter("asOfDate"));
			params.put("fromDate", request.getParameter("fromDate"));
			params.put("toDate", request.getParameter("toDate"));
			Map<String, Object> clmListPerBlockTableGrid = TableGridUtil.getTableGrid(request, params);
			JSONObject json = new JSONObject(clmListPerBlockTableGrid);
			request.setAttribute("jsonClmListPerBlock", json);
			return json;
		}
	
		@Override
		public String validateDistrictPerBlock(HttpServletRequest request) throws SQLException {
			Map<String, Object> params = new HashMap<String, Object>();
			System.out.println( request.getParameter("blockNo") + "=" + request.getParameter("district"));
			params.put("ACTION", "validateDistrictPerBlock");
			params.put("blockNo", request.getParameter("blockNo"));
			params.put("district", request.getParameter("district"));
			return this.giclClaimListingInquiryDAO.validateDistrictPerBlock(params);
		}
		
		@Override
		public String validateBlockPerBlock(HttpServletRequest request) throws SQLException {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ACTION", "validateBasicBlockPerBlock");
			params.put("basicBlock", request.getParameter("basicBlock"));
			return this.giclClaimListingInquiryDAO.validateBlockPerBlock(params);
		}
		
		@Override
		public JSONObject getBlockByDistrictNo(
				HttpServletRequest request) throws SQLException {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("districtNo", request.getParameter("districtNo"));
			Map<String, Object> blockDetails = this.giclClaimListingInquiryDAO.getBlockByDistrictNo(params);
			JSONObject blockDetailsJSON = new JSONObject(blockDetails);
			return blockDetailsJSON;
		}	
	
	@Override
	public JSONObject getPayorDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPayorDetailsMap");
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		Map<String, Object> payorDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPayorDetails = new JSONObject(payorDetailsTableGrid);
		return jsonPayorDetails;
	}

	@Override
	public JSONObject getHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getHistoryMap");
		params.put("recoveryId", request.getParameter("recoveryId"));
		Map<String, Object> historyTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonHistoryDetails = new JSONObject(historyTableGrid);
		return jsonHistoryDetails;
	}

	@Override
	public JSONObject showClaimListingPerIntermediary(HttpServletRequest request, GIISUser USER) throws SQLException,JSONException {
		String intmNo = request.getParameter("intmNo");	
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("ACTION", "getClmListPerIntermediary");
		params.put("intmNo", intmNo);
		params.put("userId", USER.getUserId());
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		Map<String, Object> clmListPerIntermediaryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerIntermediary = new JSONObject(clmListPerIntermediaryTableGrid);
		return jsonClmListPerIntermediary;
	}

	@Override
	public JSONObject showClaimListingPerPlateNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerPlateNo");	
		params.put("appUser", USER.getUserId());
		params.put("plateNo", request.getParameter("plateNo"));
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		Map<String, Object> clmListPerPlateNoTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerPlateNo = new JSONObject(clmListPerPlateNoTableGrid);
		return jsonClmListPerPlateNo;
	}
	
	@Override
	public JSONObject showClaimListingPerMake(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMakeDetailsInfo");
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("appUser", USER.getUserId());
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		System.out.println(params.get("searchBy"));
		System.out.println(params.get("asOfDate"));
		System.out.println(params.get("fromDate"));
		System.out.println(params.get("toDate"));
		Map<String, Object> makeDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonMakeDetails = new JSONObject(makeDetailsTableGrid);
		return jsonMakeDetails;
	}

	@Override
	public JSONObject getClaimDetails(HttpServletRequest request) throws SQLException, JSONException {
		String claimId = request.getParameter("claimId");
		String perilCd = request.getParameter("perilCd");
		String itemNo =  request.getParameter("itemNo");
		String lineCd = request.getParameter("lineCd");
		request.setAttribute("claimId", claimId);
		request.setAttribute("perilCd", perilCd);
		request.setAttribute("itemNo", itemNo);
		request.setAttribute("lineCd", lineCd);
		request.setAttribute("claimNo", request.getParameter("claimNo"));
		request.setAttribute("lossCatDesc", request.getParameter("lossCatDesc"));
		request.setAttribute("policyNo", request.getParameter("policyNo"));
		request.setAttribute("lossDate", request.getParameter("lossDate"));
		request.setAttribute("assuredName", request.getParameter("assuredName"));
		request.setAttribute("clmStatDesc", request.getParameter("clmStatDesc"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClaimDetailsPerIntermediary");
		params.put("claimId", claimId);
		params.put("perilCd", perilCd);
		params.put("itemNo", itemNo);
		params.put("lineCd", lineCd);
		Map<String, Object> claimDetailsPerIntermediaryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClaimDetailsPerIntermediary = new JSONObject(claimDetailsPerIntermediaryTableGrid);
		return jsonClaimDetailsPerIntermediary;
	}
	@Override
	public JSONObject showClaimListingPerPackagePolicy(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerPackagePolicy");
		params.put("appUser", USER.getUserId());
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));				
		Map<String, Object> clmListPerPackagePolicyTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerPackagePolicy = new JSONObject(clmListPerPackagePolicyTableGrid);
		return jsonClmListPerPackagePolicy;
	}

	@Override
	public JSONObject getRecoveryDetails(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecoveryDetailsMap");
		params.put("claimId", request.getParameter("claimId"));
		Map<String, Object> recoveryDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecoveryDetails = new JSONObject(recoveryDetailsTableGrid);
		return jsonRecoveryDetails;
	}

	@Override
	public JSONObject showClaimListingPerRecoveryType(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerRecoveryType");
		params.put("appUser", USER.getUserId());
		params.put("recTypeCd", request.getParameter("recTypeCd"));
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		Map<String, Object> clmListPerRecoveryTypeTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerRecoveryType = new JSONObject(clmListPerRecoveryTypeTableGrid);
		return jsonClmListPerRecoveryType;
	}

	@Override
	public JSONObject getGICLS258Details(HttpServletRequest request)throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS258DetailsMap");
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		Map<String, Object> recoveryDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecoveryDetails = new JSONObject(recoveryDetailsTableGrid);
		return jsonRecoveryDetails;
	}

	@Override
	public JSONObject showClaimListingPerUser(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getProcessorHistory");
		params.put("claimId", request.getParameter("claimId"));
		Map<String, Object> processorHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonProcessorHistory = new JSONObject(processorHistoryTableGrid);
		return jsonProcessorHistory;
	}

	@Override
	public JSONObject showClaimListingPerPayee(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerPayee");				
		params.put("appUser", USER.getUserId());
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		
		params.put("fileDate2", request.getParameter("fileDate2"));
		params.put("lossDate2", request.getParameter("lossDate2"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		
		Map<String, Object> clmListPerPayeeGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerPayee = new JSONObject(clmListPerPayeeGrid);
		return jsonClmListPerPayee;
	}

	@Override
	public JSONObject showPerPayeeDtl(HttpServletRequest request)
			throws SQLException, JSONException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "showPerPayeeDtl");				
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("claimId", request.getParameter("claimId"));
		
		if (request.getParameter("lossDate") != null) {
			request.setAttribute("claimNo", request.getParameter("claimNo"));
			request.setAttribute("policyNo", request.getParameter("policyNo"));
			request.setAttribute("assured", request.getParameter("assured"));
			SimpleDateFormat dt = new SimpleDateFormat("yyyyy-mm-dd");
			Date lossDate = dt.parse(request.getParameter("lossDate"));
			SimpleDateFormat sdf = new SimpleDateFormat("mm-dd-yyyy");
			request.setAttribute("lossDate", sdf.format(lossDate));
		}
		Map<String, Object> clmListPerPayeeDtlGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPerPayeeDtl = new JSONObject(clmListPerPayeeDtlGrid);
		return jsonPerPayeeDtl;
	}

	@Override
	public JSONObject showClaimListingPerPolicy(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClaimDetailsPerPolicy");
		params.put("appUser", USER.getUserId());
		params.put("moduleId", "GICLS250");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		Map<String, Object> clmListPerPolicyTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonClmListPerPolicy = new JSONObject(clmListPerPolicyTableGrid);
		return jsonClmListPerPolicy;
	}

	@Override
	public JSONObject showClaimListingPerCargoType(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerCargoType");
		params.put("appUser", USER.getUserId());
		params.put("cargoClassCd", request.getParameter("cargoClassCd"));
		params.put("cargoType", request.getParameter("cargoType"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		Map<String, Object> clmListPerCargoTypeTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(clmListPerCargoTypeTableGrid);
		request.setAttribute("jsonClmListPerCargoType", json);
		return json;
	}

	@Override
	public String validateCargoClassPerCargoClass(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cargoClassDesc", request.getParameter("cargoClassDesc"));
		return this.giclClaimListingInquiryDAO.validateCargoClassPerCargoClass(params);
	}

	@Override
	public String validateCargoTypePerCargoClass(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cargoClassCd", request.getParameter("cargoClassCd"));
		params.put("cargoTypeDesc", request.getParameter("cargoTypeDesc"));
		return this.giclClaimListingInquiryDAO.validateCargoTypePerCargoClass(params);
	}

	@Override
	public JSONObject fetchCorrespondingCargoTypeBasedOnClassCd(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cargoClassCd", request.getParameter("cargoClassCd"));
		Map<String, Object> cargoTypeDetails = this.giclClaimListingInquiryDAO.fetchCorrespondingCargoTypeBasedOnClassCd(params);
		JSONObject cargoTypeDetailsJSON = new JSONObject(cargoTypeDetails);
		return cargoTypeDetailsJSON;
	}
	
	@Override
	public JSONArray fetchValidCargo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		List<Integer> cargoId = giclClaimListingInquiryDAO.fetchValidCargo(params);
		JSONArray cargoIdJSON = new JSONArray(cargoId);
		return cargoIdJSON;
	}

	@Override
	public JSONObject showClaimListingPerMotorshop(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerMotorshop");
		params.put("pPayeeCd", request.getParameter("payeeCd"));
		params.put("pFromDate", request.getParameter("fromDate"));
		params.put("pToDate", request.getParameter("toDate"));
		params.put("pAsOfDate", request.getParameter("asOfDate"));
		params.put("pSearchBy", request.getParameter("searchBy"));
		Map<String, Object> clmListPerMotorshopTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(clmListPerMotorshopTableGrid);
		request.setAttribute("jsonClmListPerMotorshop", json);
		return json;
	}

	@Override
	public String validateMotorshop(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("payeeName", request.getParameter("payeeName"));
		return this.giclClaimListingInquiryDAO.validateMotorshop(params);
	}
	@Override
	public JSONObject showClaimListingPerNatureOfLoss(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerNatureOfLoss");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", USER.getUserId());
		Map<String, Object> clmListPerNatureOfLossTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(clmListPerNatureOfLossTableGrid);
		request.setAttribute("jsonClmListPerNatureOfLoss", json);
		return json;
	}

	@Override
	public String validateLineCdByLineName(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineName", request.getParameter("lineName"));
		return this.giclClaimListingInquiryDAO.validateLineCdByLineName(params);
	}

	@Override
	public String validateLossCatDescPerLineCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossCatDesc", request.getParameter("lossCatDesc"));
		return this.giclClaimListingInquiryDAO.validateLossCatDescPerLineCd(params);
	}

	@Override
	public JSONObject fetchValidLossCatDesc(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> lossCatDets = this.giclClaimListingInquiryDAO.fetchValidLossCatDesc(params);
		JSONObject lossCatDetsJSON = new JSONObject(lossCatDets);
		return lossCatDetsJSON;
	}

	@Override
	public JSONArray fetchValidLineCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		List<String> lineCd = giclClaimListingInquiryDAO.fetchValidLineCd(params);
		JSONArray lineCdJSON = new JSONArray(lineCd);
		return lineCdJSON;
	}

	@Override
	public JSONObject showClaimListingPerVessel(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		return null;
	}

	@Override
	public JSONObject showClaimListingPerMotorcarReplacementParts(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
	Map<String, Object> params = new HashMap<String, Object>();
	params.put("ACTION", "getMCReplacementDetailsInfo");
	params.put("carCompanyCd", request.getParameter("carCompanyCd"));
	params.put("makeCd", request.getParameter("makeCd"));
	params.put("modelYear", request.getParameter("modelYear"));
	params.put("lossExpCd", request.getParameter("lossExpCd"));
	params.put("appUser", USER.getUserId());
	params.put("searchBy", request.getParameter("searchBy"));
	params.put("asOfDate", request.getParameter("asOfDate"));
	params.put("fromDate", request.getParameter("fromDate"));
	params.put("toDate", request.getParameter("toDate"));
	Map<String, Object> mcReplacementPartDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
	JSONObject jsonMCReplacementPartDetails = new JSONObject(mcReplacementPartDetailsTableGrid);
	return jsonMCReplacementPartDetails;
	}

	@Override
	public JSONObject showClaimListingPerLawyer(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmListPerLawyer");
		params.put("lawyerCd", request.getParameter("lawyerCd"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("appUser", USER.getUserId());
		params.put("toDate", request.getParameter("toDate"));	
		Map<String, Object> perLawyerTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPerLawyerTableGrid = new JSONObject(perLawyerTableGrid);
		return jsonPerLawyerTableGrid;
	}
	
	@Override
	public String validateLawyer(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateLawyer");
		params.put("lawyerName", request.getParameter("lawyerName"));
		return this.giclClaimListingInquiryDAO.validateLawyer(params);
	}

	@Override
	public JSONObject showClaimListingPerBill(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClaimListingPerBill");
		params.put("payeeNo", request.getParameter("payeeNo"));
		params.put("payeeClassNo", request.getParameter("payeeClassNo"));
		params.put("docNumber", request.getParameter("docNumber"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("appUser", USER.getUserId());
		params.put("toDate", request.getParameter("toDate"));	
		Map<String, Object> mcReplacementPartDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonMCReplacementPartDetails = new JSONObject(mcReplacementPartDetailsTableGrid);
		return jsonMCReplacementPartDetails;
	}

	@Override
	public String validatePayees(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validatePayee");
		params.put("payeeNo", request.getParameter("payeeNo"));
		params.put("payeeName", request.getParameter("payeeName"));
		return this.giclClaimListingInquiryDAO.validatePayees(params);
	}

	@Override
	public String validatePayeeClass(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validatePayee");
		params.put("payeeClassNo", request.getParameter("payeeClassNo"));
		params.put("payeeClass", request.getParameter("payeeClass"));
		return this.giclClaimListingInquiryDAO.validatePayeeClass(params);
	}
	
	@Override
	public String validateDocNumber(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateDocNumber");
		params.put("docNumber", request.getParameter("docNumber"));
		return this.giclClaimListingInquiryDAO.validateDocNumber(params);
	}

	@Override
	public JSONObject showClaimListingPerThirdParty(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getClmListPerThirdParty");
		params.put("appUser", USER.getUserId());
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("payeeNo", request.getParameter("payeeNo"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("tpType", request.getParameter("tpType"));
		Map<String, Object> clmListPerThirdParty = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(clmListPerThirdParty);
		request.setAttribute("jsonClmListPerThirdParty", json);
		return json;
	}

	@Override
	public JSONArray fetchValidThirdParty(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		List<String> payeeClassCd = giclClaimListingInquiryDAO.fetchValidThirdParty(params);
		JSONArray payeeClassCdJSON = new JSONArray(payeeClassCd);
		return payeeClassCdJSON;
	}

	@Override
	public JSONArray validateClassPerClass(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("filter", request.getParameter("filter"));
		params.put("payeeClassCdIn", request.getParameter("payeeClassCdIn"));
		System.out.println(request.getParameter("payeeClassCdIn"));
		List<String> validPayeeDet = this.giclClaimListingInquiryDAO.validateClassPerClass(params);
		JSONArray validPayeeDetJSON = new JSONArray(validPayeeDet);
		return validPayeeDetJSON;
	}

	@Override
	public JSONObject getLossDtlsField(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getLossDtlsField");
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		Map<String, Object> lossDtlsFieldTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonLossDtlsField = new JSONObject(lossDtlsFieldTableGrid);
		return jsonLossDtlsField;
	}

	
	@Override
	public JSONArray validatePayeePerClassCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		List<String> validPayeeDet = this.giclClaimListingInquiryDAO.validatePayeePerClassCd(params);
		JSONArray validPayeeDetJSON = new JSONArray(validPayeeDet);
		return validPayeeDetJSON;
	}
	
	@Override
	public JSONObject getClaimsWithEnrollees(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClaimsWithEnrollees");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("dateType", request.getParameter("dateType"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		Map<String, Object> claimsTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(claimsTG);
	}
	
	@Override
	public String validateGICLS278Field(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("field", request.getParameter("field"));
		params.put("value", request.getParameter("value"));
		return this.getGiclClaimListingInquiryDAO().validateGICLS278Field(params);
	}

	@Override
	public String validateGICLS278Entries(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		return this.getGiclClaimListingInquiryDAO().validateGICLS278Entries(params);
	}
	
	public Map<String, Object> populateGicls256Totals(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", USER.getUserId());
		return giclClaimListingInquiryDAO.populateGicls256Totals(params);
	}
	
	public Map<String, Object> validateGicls277PayeeName(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("searchPayee", request.getParameter("searchPayee"));
		params.put("payeeClass", request.getParameter("payeeClass"));
		return this.giclClaimListingInquiryDAO.validateGicls277PayeeName(params);
	}
	
	@Override
	public JSONObject showGicls276RecoveryDetails(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGicls276RecoveryDetails");
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		Map<String, Object> recoveryDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecoveryDetails = new JSONObject(recoveryDetailsTableGrid);
		return jsonRecoveryDetails;
	}
}
