/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 8, 2010
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.service.GICLClaimsService;
import com.seer.framework.util.StringFormatter;

public class GICLClaimsServiceImpl implements GICLClaimsService{

	private GICLClaimsDAO giclClaimsDAO;
	private static Logger log = Logger.getLogger(GICLClaimsServiceImpl.class);
	
	private void preparePolicyParams(Map<String, Object> params, HttpServletRequest request, GIISUser USER){
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getClaims(java.lang.Integer)
	 */
	@Override
	public GICLClaims getClaims(Integer claimId) throws SQLException {
		log.info("Getting Claim Id: " + claimId);
		return this.getGiclClaimsDAO().getClaims(claimId);
	}

	/**
	 * @param giclClaimsDAO the giclClaimsDAO to set
	 */
	public void setGiclClaimsDAO(GICLClaimsDAO giclClaimsDAO) {
		this.giclClaimsDAO = giclClaimsDAO;
	}

	/**
	 * @return the giclClaimsDAO
	 */
	public GICLClaimsDAO getGiclClaimsDAO() {
		return giclClaimsDAO;
	}

	/*
	 * 
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getRelatedClaims(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getRelatedClaims(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GICLClaims> claimList = this.getGiclClaimsDAO().getRelatedClaims(params);
		params.put("rows", new JSONArray((List<GICLClaims>)StringFormatter.escapeHTMLInList(claimList)));
		grid.setNoOfPages(claimList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getClaimsTableGridListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getClaimsTableGridListing(Map<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("lineCd",params.get("lineCd"));
		params.put("filter", this.prepareClaimListDetailFilter((String) params.get("filter")));
		params.put("sortColumn", params.get("sortColumn")); //added by christian - 06.26.2012
		params.put("userId", params.get("userId")); //added by vondanix - 09.30.2015
		params.put("moduleId", params.get("moduleId")); //added by vondanix - 09.30.2015
		params.put("ascDescFlg", params.get("ascDescFlg"));
		List<Map<String, Object>> claimList = this.getGiclClaimsDAO().getClaimsTableGridListing(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.escapeHTMLInListOfMap(claimList)));
		grid.setNoOfPages(claimList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareClaimListDetailFilter(String filter) throws JSONException {
		Map<String, Object> claimList = new HashMap<String, Object>();
		JSONObject jsonClaimListFilter = null;
		
		if (null == filter) {
			jsonClaimListFilter = new JSONObject();
		} else {
			jsonClaimListFilter = new JSONObject(filter);
		}
		
		claimList.put("assuredName", jsonClaimListFilter.isNull("assuredName") ? "" : jsonClaimListFilter.getString("assuredName").toUpperCase());
		claimList.put("plateNumber", jsonClaimListFilter.isNull("plateNumber") ? "" : jsonClaimListFilter.getString("plateNumber").toUpperCase());
		claimList.put("claimStatDesc", jsonClaimListFilter.isNull("claimStatDesc") ? "" : jsonClaimListFilter.getString("claimStatDesc").toUpperCase());
		claimList.put("inHouseAdjustment", jsonClaimListFilter.isNull("inHouseAdjustment") ? "" : jsonClaimListFilter.getString("inHouseAdjustment").toUpperCase());
		claimList.put("claimStatDesc", jsonClaimListFilter.isNull("claimStatDesc") ? "" : jsonClaimListFilter.getString("claimStatDesc").toUpperCase());
		/*claimList.put("lineCode", jsonClaimListFilter.isNull("lineCode") ? "" : jsonClaimListFilter.getString("lineCode").toUpperCase());*/
		claimList.put("sublineCd", jsonClaimListFilter.isNull("sublineCd") ? "" : jsonClaimListFilter.getString("sublineCd").toUpperCase());
		claimList.put("issueCode", jsonClaimListFilter.isNull("issueCode") ? "" : jsonClaimListFilter.getString("issueCode").toUpperCase());
		claimList.put("claimYy", jsonClaimListFilter.isNull("claimYy") ? "" : jsonClaimListFilter.getString("claimYy").toUpperCase());
		claimList.put("claimSequenceNo", jsonClaimListFilter.isNull("claimSequenceNo") ? "" : jsonClaimListFilter.getString("claimSequenceNo").toUpperCase());
		claimList.put("policyIssueCode", jsonClaimListFilter.isNull("policyIssueCode") ? "" : jsonClaimListFilter.getString("policyIssueCode").toUpperCase());
		claimList.put("policySequenceNo", jsonClaimListFilter.isNull("policySequenceNo") ? "" : jsonClaimListFilter.getString("policySequenceNo").toUpperCase());
		claimList.put("renewNo", jsonClaimListFilter.isNull("renewNo") ? "" : jsonClaimListFilter.getString("renewNo").toUpperCase());
		Debug.print("CLAIMLIST: " + claimList);
		return claimList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getLossRecoveryTableGridListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getLossRecoveryTableGridListing(
			Map<String, Object> params) throws SQLException, JSONException {
		// TODO Auto-generated method stub
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 10); //ApplicationWideParameters.PAGE_SIZE
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareLossRecoveryListDetailFilter((String) params.get("filter")));
		List<Map<String, Object>> lossRecoveryList = this.getGiclClaimsDAO().getLossRecoveryTableGridListing(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(lossRecoveryList)));
		grid.setNoOfPages(lossRecoveryList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareLossRecoveryListDetailFilter(String filter) throws JSONException {
		Map<String, Object> claimList = new HashMap<String, Object>();
		JSONObject jsonClaimListFilter = null;
		
		if (null == filter) {
			jsonClaimListFilter = new JSONObject();
		} else {
			jsonClaimListFilter = new JSONObject(filter);
		}
		
		claimList.put("assuredName", jsonClaimListFilter.isNull("assuredName") ? "" : jsonClaimListFilter.getString("assuredName").toUpperCase());
		claimList.put("claimNo", jsonClaimListFilter.isNull("claimNo") ? "" : jsonClaimListFilter.getString("claimNo").toUpperCase());
		claimList.put("clmFileDate", jsonClaimListFilter.isNull("clmFileDate") ? "" : jsonClaimListFilter.getString("clmFileDate").toUpperCase());
		claimList.put("lossDate", jsonClaimListFilter.isNull("lossDate") ? "" : jsonClaimListFilter.getString("lossDate").toUpperCase());		
		claimList.put("policyNo", jsonClaimListFilter.isNull("policyNo") ? "" : jsonClaimListFilter.getString("policyNo").toUpperCase());
		claimList.put("recoveryNo", jsonClaimListFilter.isNull("recoveryNo") ? "" : jsonClaimListFilter.getString("recoveryNo").toUpperCase());
		claimList.put("recStatDesc", jsonClaimListFilter.isNull("recStatDesc") ? "" : jsonClaimListFilter.getString("recStatDesc").toUpperCase());
		Debug.print("CLAIMLIST: " + claimList);
		return claimList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getClaimsBasicInfoDtls(java.lang.Integer)
	 */
	@Override
	public GICLClaims getClaimsBasicInfoDtls(Integer claimId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiclClaimsDAO().getClaimsBasicInfoDtls(claimId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#initializeClaimsMenu(java.util.Map)
	 */
	@Override
	public Map<String, Object> initializeClaimsMenu(Map<String, Object> params)	throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiclClaimsDAO().initializeClaimsMenu(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getClmAssuredDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getClmAssuredDtls(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> catList = this.getGiclClaimsDAO().getClmAssuredDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#enableMenus(java.util.Map)
	 */
	@Override
	public Map<String, Object> enableMenus(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiclClaimsDAO().enableMenus(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#updateClaimsBasicInfo(java.util.Map)
	 */
	@Override
	public void updateClaimsBasicInfo(Map<String, Object> params) throws Exception {
		this.getGiclClaimsDAO().updateClaimsBasicInfo(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimsService#getBasicIntmDtls(java.util.Map)
	 */
	@Override
	public Map<String, Object> getBasicIntmDtls(HttpServletRequest request, GIISUser USER)	throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBasicIntmDtls");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("claimsListTableGrid", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public void clmItemPreDelete(Map<String, Object> params)
			throws SQLException {
		this.giclClaimsDAO.clmItemPreDelete(params);
	}

	@Override
	public void clmItemPostFormCommit(Map<String, Object> params)
			throws SQLException {
		this.giclClaimsDAO.clmItemPostFormCommit(params);
	}

	@Override
	public Map<String, Object> checkClaimPlateNo(Map<String, Object> params)
			throws SQLException {
		params = this.giclClaimsDAO.checkClaimPlateNo(params);
		return params;
	}

	@Override
	public Map<String, Object> checkClaimMotorNo(Map<String, Object> params)
			throws SQLException {
		return this.giclClaimsDAO.checkClaimMotorNo(params);
	}

	@Override
	public Map<String, Object> checkClaimSerialNo(Map<String, Object> params)
			throws SQLException {
		params = this.giclClaimsDAO.checkClaimSerialNo(params);
		return params;
	}

	@Override
	public String checkClaimStatus(String lineCode, String sublineCd,
			String issueCode, Integer claimYy, Integer claimSequenceNo)
			throws SQLException {
		return this.giclClaimsDAO.checkClaimStatus(lineCode, sublineCd, issueCode, claimYy, claimSequenceNo);
	}

	@Override 
	public GICLClaims getClaimInfo(Integer claimId) throws SQLException {
		return this.getGiclClaimsDAO().getClaimInfo(claimId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getBasicClaimDtls(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 10);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GICLClaims> list = this.getGiclClaimsDAO().getBasicClaimDtls(params);
		params.put("rows", new JSONArray((List<GICLClaims>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	@Override
	public void getBasicParametersDetails(GIISParameterFacadeService paramService,GIACParameterFacadeService giacParamService, HttpServletRequest request, GIISUser USER)
			throws SQLException {
		request.setAttribute("lineCd", request.getParameter("lineCd"));
		request.setAttribute("currUser", USER.getUserId());
		request.setAttribute("currUserName", USER.getUsername());
		
		request.setAttribute("issCdParam", paramService.getParamValueV("ISS_CD_HO").toString());
		request.setAttribute("clmStatNotOk", paramService.getParamValueV("NOT OK").getParamValueV());
		request.setAttribute("clmFiledNotice", paramService.getParamValueV("FILED NOTICE").getParamValueV());
		request.setAttribute("branchCdParam", giacParamService.getParamValueV2("BRANCH_CD"));
		request.setAttribute("ora2010Sw", paramService.getParamValueV("ORA2010_SW").getParamValueV());
		request.setAttribute("allowExpiredPol", paramService.getParamValueV("ALLOW_EXPIRED_POLICY").getParamValueV());
		String valPolIssueDateFlag = paramService.getParamValueV("VALIDATE_POL_ISSUE_DATE").getParamValueV();
		request.setAttribute("valPolIssueDateFlag", (valPolIssueDateFlag == null || "".equals(valPolIssueDateFlag)) ? "" : valPolIssueDateFlag);
		request.setAttribute("riIssCd", paramService.getParamValueV2("REINSURANCE"));
		request.setAttribute("lineCodeSU", paramService.getParamValueV2("LINE_CODE_SU"));
		request.setAttribute("bondCoverage", paramService.getParamValueN("BOND_COVERAGE"));
		request.setAttribute("motorCarLineCode", paramService.getParamValueV2("MOTOR CAR LINE CODE"));
		request.setAttribute("mandatoryClaimDocs", paramService.getParamValueV2("MANDATORY CLAIM DOCS"));
		request.setAttribute("valLocOfLoss", paramService.getParamValueV2("VALIDATE LOCATION OF LOSS"));
		request.setAttribute("lineCodeFI", paramService.getParamValueV2("LINE_CODE_FI"));
		request.setAttribute("lineCodeCA", paramService.getParamValueV2("LINE_CODE_CA"));
		request.setAttribute("caSublinePFL", paramService.getParamValueV2("CA_SUBLINE_PFL"));
		request.setAttribute("marineCargoLineCode", paramService.getParamValueV2("MARINE CARGO LINE CODE"));
	}

	@Override
	public String validateClmPolicyNo(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		FormInputUtil.prepareDateParam("lossDate", params, request);
		log.info("Validating policy number : "+params);
		params = this.giclClaimsDAO.validateClmPolicyNo(params);

		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String chkItemForTotalLoss(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		params.put("itemNo", request.getParameter("itemNo"));
		log.info("Checking item total loss : "+params);
		params = this.giclClaimsDAO.chkItemForTotalLoss(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String checkExistingClaims(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		params.put("plateNo", request.getParameter("plateNo"));
		log.info("Checking existing claims : "+params);
		params = this.giclClaimsDAO.checkExistingClaims(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String checkTotalLossSettlement(HttpServletRequest request,
			GIISUser USER) throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		FormInputUtil.prepareDateParam("lossDate", params, request);
		FormInputUtil.prepareDateParam("polEffDate", params, request);
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		params.put("itemNo", request.getParameter("itemNo")); //marco - 10.27.2014 - added @FGIC
		log.info("Checking total loss settlement : "+params);
		return this.giclClaimsDAO.checkTotalLossSettlement(params);
	}

	@Override
	public String validatePlateMotorSerialNo(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("plateNo", request.getParameter("plateNo"));
		params.put("motorNo", request.getParameter("motorNo"));
		params.put("serialNo", request.getParameter("serialNo"));
		params.put("validatePol", request.getParameter("validatePol"));
		params.put("param1", request.getParameter("param1"));
		FormInputUtil.prepareDateParam("lossDate", params, request);
		
		log.info("Validating plate/motor/serial number : "+params);
		params = this.giclClaimsDAO.validatePlateMotorSerialNo(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String checkLossDateTime(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		FormInputUtil.prepareDateParam("lossDate", params, request);
		log.info("Checking loss date/time : "+params);
		params = this.giclClaimsDAO.checkLossDateTime(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String getSublineTime(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		log.info("Getting subline time : "+params);
		return this.giclClaimsDAO.getSublineTime(params);
	}

	@Override
	public String validateLossDatePlateNo(HttpServletRequest request,
			GIISUser USER) throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		params.put("plateNo", request.getParameter("plateNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		FormInputUtil.prepareDateParam("lossDate", params, request);
		FormInputUtil.prepareDateParam("polEffDate", params, request);
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		params.put("time", request.getParameter("time"));
		log.info("Validating Loss Date & Plate No : "+params);
		params = this.giclClaimsDAO.validateLossDatePlateNo(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String validateLossTime(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		FormInputUtil.prepareDateParam("lossDate", params, request);
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		params.put("userLevel", request.getParameter("userLevel"));
		log.info("Validating Loss Time : "+params);
		params = this.giclClaimsDAO.validateLossTime(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String claimCheck(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		FormInputUtil.prepareDateParam("lossDate", params, request);
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		params.put("plateNo", request.getParameter("plateNo"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("lossTime", request.getParameter("lossTime"));
		log.info("Checking Claim : "+params);
		params = this.giclClaimsDAO.claimCheck(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String validateCatastrophicCode(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("clmYy", request.getParameter("clmYy"));
		params.put("clmSeqNo", request.getParameter("clmSeqNo"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("catCd", request.getParameter("catCd"));
		log.info("Validating catastrophic code : "+params);
		params = this.giclClaimsDAO.validateCatastrophicCode(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String getCheckLocationDtl(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("location", request.getParameter("location"));
		params = this.giclClaimsDAO.getCheckLocationDtl(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public String saveGICLS010(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, IOException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		ApplicationWideParameters.DATE_FORMAT = "MM-dd-yyyy hh:mm:ss aa";
		params.put("basicInfo", JSONUtil.prepareObjectFromJSON(new JSONObject(request.getParameter("basicInfo")), USER.getUserId(), GICLClaims.class));
		params.put("procs", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("procs"))));
		params.put("checkNoClaimSw", request.getParameter("checkNoClaimSw"));
		params.put("menuLineCd", request.getAttribute("menuLineCd")); //added by cherrie | 01242014
		log.info("Saving claims basic info : "+params);
		ApplicationWideParameters.DATE_FORMAT = "";
		params = this.giclClaimsDAO.saveGICLS010(params);
		if (params.get("workflowMsgr") != null){
			Runtime rt=Runtime.getRuntime();
			rt.exec((String) params.get("workflowMsgr"));
		}	
		if (params.get("workflowMsgr2") != null){
			Runtime rt=Runtime.getRuntime();
			rt.exec((String) params.get("workflowMsgr2"));
		}
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public void deleteWorkflowRec3(String eventDesc, String moduleId, String userId,
			Object colValue) throws SQLException {
		this.giclClaimsDAO.deleteWorkflowRec3(eventDesc, moduleId, userId, colValue);
	}

	@Override
	public String checkPrivAdjExist(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
		log.info("Checking if private adjuster exist : "+params);
		return this.giclClaimsDAO.checkPrivAdjExist(params);
	}

	@Override
	public void refreshClaims(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		FormInputUtil.prepareDateParam("polEffDate", params, request);
		FormInputUtil.prepareDateParam("dspLossDate", params, request);
		params.put("claimId", request.getParameter("claimId"));
		log.info("Refreshing Claims : "+params);
		this.giclClaimsDAO.refreshClaims(params);
	}

	@Override
	public Map<String, Object> getUpdateLossRecoveryTagListing(
			HttpServletRequest request, GIISUser user) throws SQLException, JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getUpdateLossRecoveryTagListing");
		params.put("pageSize", 10);
		params.put("userId", user.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		System.out.println(params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("updateLossRecoveryTagTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public void getClaimsPerPolicy(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		System.out.println(":::::::::::::getClaimsPerPolicy::::::::::::");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("nbtLineCd", request.getParameter("lineCd"));
		params.put("nbtSublineCd", request.getParameter("sublineCd"));
		params.put("nbtPolIssCd", request.getParameter("polIssCd"));
		params.put("nbtIssueYy", request.getParameter("issueYy"));
		params.put("nbtPolSeqNo", request.getParameter("polSeqNo"));
		params.put("nbtRenewNo", request.getParameter("renewNo"));
		params.put("ACTION", "getClaimsPerPolicyGrid");
		params.put("module", request.getParameter("module"));
		params.put("callFrom", request.getParameter("callFrom"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("perPolicyTG", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public void getClaimsPerPolicyDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		params.put("ACTION", "getClaimsPerPolicyDetailsGrid");
		params.put("module", request.getParameter("module"));
		params.put("clmFileDate", request.getParameter("clmFileDate"));
		params.put("lossDate", request.getParameter("lossDate"));
		//params.put("assuredName", request.getParameter("assdName"));
		System.out.println("params ::::::::::::::::::::::::::::::::");
		System.out.println(params);
		FormInputUtil.prepareDateParam("asOfDate", params, request);
		FormInputUtil.prepareDateParam("fromDate", params, request);
		FormInputUtil.prepareDateParam("toDate", params, request);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("perPolicyDetailsTG", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public void updateLossTagRecovery(HttpServletRequest request, GIISUser user)
			throws SQLException, JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		System.out.println(request.getParameter("claims"));
		//JSONArray claims = new JSONArray(params.get("claims"));
		params.put("claims", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("claims"))));
		params.put("userId", user.getUserId());
		
		this.getGiclClaimsDAO().updateLossTagRecovery(params);
	}

	@Override
	public Map<String, Object> checkUnpaidPremiums(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("evalId", request.getParameter("evalId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("clmFileDate", request.getParameter("clmFileDate") == null || "".equals(request.getParameter("clmFileDate")) ? null :date.parse(request.getParameter("clmFileDate")));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("userId", USER.getUserId());
		return this.getGiclClaimsDAO().checkUnpaidPremiums(params);
	}


	@Override
	public Map<String, Object> checkUnpaidPremiums2(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("evalId", request.getParameter("evalId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("clmFileDate", request.getParameter("clmFileDate") == null || "".equals(request.getParameter("clmFileDate")) ? null :date.parse(request.getParameter("clmFileDate")));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("userId", USER.getUserId());
		return this.getGiclClaimsDAO().checkUnpaidPremiums2(params);
	}


	@Override
	public void getRecoveryAmounts(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params = this.getGiclClaimsDAO().getRecoveryAmounts(params);
		log.info("Recovery Amounts : "+params);
		request.setAttribute("recoverableAmt", params.get("recoverableAmt"));
		request.setAttribute("recoveredAmt", params.get("recoveredAmt"));
	}

	@Override
	public Map<String, Object> checkClaimReqDocs(Integer claimId)
			throws SQLException {
		return getGiclClaimsDAO().checkClaimReqDocs(claimId);
	}

	@Override
	public GICLClaims getRelatedClaimsGICLS024(Integer claimId)
			throws SQLException {
		return this.getGiclClaimsDAO().getRelatedClaimsGICLS024(claimId);
	}

	
	public Map<String, Object> checkUserFunction(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiclClaimsDAO().checkUserFunction(params);
	}

	@Override 
	public String validateLineCd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		return this.giclClaimsDAO.validateLineCd(params);
	}

	@Override
	public String validatePolIssCd(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("polIssCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		log.info("Validate PolIssCd : "+params);
		return this.giclClaimsDAO.validatePolIssCd(params);
	}

	@Override
	public String validateSublineCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		log.info("Validate PolIssCd : "+params);
		return this.giclClaimsDAO.validateSublineCd(params);
	}

	@Override
	public String validateRenewNoGIACS007(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		preparePolicyParams(params, request, USER);
		log.info("Validate Renew No : "+params);
		return this.giclClaimsDAO.validateRenewNoGIACS007(params);
	}

	@Override
	public boolean saveBatchClaimCLosing(Map<String, Object> params)
			throws Exception {
		log.info("Saving GIACLossRiCollns...");
		this.getGiclClaimsDAO().saveBatchClaimCLosing(params);
		log.info("GIACLossRiCollns Saved.");
		return true;
	}

	@Override
	public String checkClaimToOpen(Integer claimId) throws SQLException {
		log.info("checkClaimToOpen...");
		return this.giclClaimsDAO.checkClaimToOpen(claimId);
	}

	@Override
	public List<GICLClaims> getObjClaimClosingList(HttpServletRequest request, Map<String, Object> params) 
			throws SQLException, Exception {
		log.info("getObjClaimClosingList...");
		log.info("filter: " + request.getParameter("objFilter"));
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		System.out.println("getObjClaimClosingList params: " + params);
		System.out.println("out: " + getGiclClaimsDAO().getObjClaimClosingList(params).size());
		return this.getGiclClaimsDAO().getObjClaimClosingList(params);
	}
	
	public Map<String, Object> openClaims(Map<String, Object> params) throws SQLException, Exception {
		log.info("openClaims : "+params);
		return this.getGiclClaimsDAO().openClaims(params);
	}

	@Override
	public void reOpenClaimsGICLS039(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("reOpenClaimsGICLS039 : " + params);
		this.getGiclClaimsDAO().reOpenClaimsGICLS039(params);
	}

	public Map<String, Object> confirmUserGICLS039(Map<String, Object> params) throws SQLException, Exception {
		log.info("confirmUserGICLS039 : "+params);
		return this.getGiclClaimsDAO().confirmUserGICLS039(params);
	}

	@Override
	public String denyWithdrawCancelClaims(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("denyWithdrawCancelClaims : "+params);
		return this.getGiclClaimsDAO().denyWithdrawCancelClaims(params);
	}

	@Override
	public Map<String, Object> checkClaimClosing(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("checkClaimClosing : "+params);
		return this.getGiclClaimsDAO().checkClaimClosing(params);
	}

	@Override
	public Map<String, Object> validateFlaGICLS039(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("validateFlaGICLS039 : "+params);
		return this.getGiclClaimsDAO().validateFlaGICLS039(params);
	}

	@Override
	public String closeClaims(Map<String, Object> params) throws SQLException,
			Exception {
		log.info("closeClaims : "+params);
		return this.getGiclClaimsDAO().closeClaims(params);
	}

	@Override
	//added by cherrie 12.13.2012 - for GICLS254
	public void showClaimsHistory(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		//add codes here		
	}

	@Override
	//added by cherrie 12.18.2012 - for GICLS254
	public void getGiclClaim(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("nbtLineCd", request.getParameter("lineCd"));
		params.put("nbtSublineCd", request.getParameter("sublineCd"));
		params.put("nbtPolIssCd", request.getParameter("polIssCd"));
		params.put("nbtIssueYy", request.getParameter("issueYy"));
		params.put("nbtPolSeqNo", request.getParameter("polSeqNo"));
		params.put("nbtRenewNo", request.getParameter("renewNo"));
		params.put("ACTION", "getClaimsHistoryGrid");
		params.put("module", request.getParameter("module"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("clmHistTG", grid);
		request.setAttribute("object", grid);
		
	}

	@Override
	public void getClmReserv(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void getLossExp(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public GICLClaims getGICLS260BasicInfoDetails(
			Map<String, Object> params) throws SQLException, Exception {
		return (GICLClaims) StringFormatter.escapeHTMLInObject(this.getGiclClaimsDAO().getGICLS260BasicInfoDetails(params));
	}

	@Override
	public Map<String, Object> initializeGICLS260Variables(
			Map<String, Object> params) throws SQLException {
		return this.getGiclClaimsDAO().initializeGICLS260Variables(params);
	}

	@Override
	public Map<String, Object> gicls125ReopenRecovery(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("userId", USER.getUserId());
		return this.getGiclClaimsDAO().gicls125ReopenRecovery(params);
	}

	@Override
	public void validateGiacParameterStatus(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		this.giclClaimsDAO.validateGiacParameterStatus(params);
	}
	
	@Override
	public String validateGICLS010Line(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		return this.getGiclClaimsDAO().validateGICLS010Line(params); 
	}
	
	@Override
	public JSONObject showGicls273(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls273RecList");	
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(recList);
		request.setAttribute("jsonExGratiaList", json);
		return json;
	}
	
	@Override
	public JSONObject showGicls273PaymentDetails(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls273SubRecList");	
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(recList);
		request.setAttribute("jsonPaymentDetails", json);
		return json;
	}
	
	@Override
	public String checkSharePercentage(HttpServletRequest request) throws SQLException {	//carlo 01-06-2017 SR-5900
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.giclClaimsDAO.checkSharePercentage(params);
	}
}
