package com.geniisys.giuw.service.impl;

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
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIPolbasicPolDistV1;
import com.geniisys.gipi.exceptions.DistributionException;
import com.geniisys.gipi.exceptions.NegateDistributionException;
import com.geniisys.gipi.exceptions.PostingParException;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.giuw.dao.GIUWPolDistDAO;
import com.geniisys.giuw.entity.GIUWPerilds;
import com.geniisys.giuw.entity.GIUWPerildsDtl;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.entity.GIUWWPerilds;
import com.geniisys.giuw.entity.GIUWWPerildsDtl;
import com.geniisys.giuw.entity.GIUWWitemds;
import com.geniisys.giuw.entity.GIUWWpolicyds;
import com.geniisys.giuw.entity.GIUWWpolicydsDtl;
import com.geniisys.giuw.service.GIUWPolDistService;
import com.seer.framework.util.StringFormatter;

public class GIUWPolDistServiceImpl implements GIUWPolDistService{

	private GIUWPolDistDAO giuwPolDistDAO;

	public GIUWPolDistDAO getGiuwPolDistDAO() {
		return giuwPolDistDAO;
	}

	public void setGiuwPolDistDAO(GIUWPolDistDAO giuwPolDistDAO) {
		this.giuwPolDistDAO = giuwPolDistDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDist(Integer parId, String moduleId) throws SQLException {
		List<GIUWPolDist> giuwPolDistList = this.giuwPolDistDAO.getGIUWPolDist(parId);
		
		//***** shan 05.14.2014
		if (moduleId != null && moduleId.equals("GIUWS005")){
			for (GIUWPolDist giuwPolDist : giuwPolDistList) {
				updateDistSpct1(giuwPolDist.getDistNo()); 
			}
			// retrieves list to fetch updated dist_spct1
			giuwPolDistList = this.giuwPolDistDAO.getGIUWPolDist(parId);
		}
		//***** end shan 05.14.2014
				
		// escape html all the sublists in GIUW Pol Dist
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWWpolicyds> giuwWpolicydsList = giuwPolDist.getGiuwWpolicyds();
			// escape html all the sublists in GIUW Pol Dist
			for (GIUWWpolicyds giuwWpolicyds : giuwWpolicydsList) {
				giuwWpolicyds.setGiuwWpolicydsDtl((List<GIUWWpolicydsDtl>) StringFormatter.escapeHTMLInList(giuwWpolicyds.getGiuwWpolicydsDtl()));
			}
			giuwPolDist.setGiuwWpolicyds((List<GIUWWpolicyds>) StringFormatter.escapeHTMLInList(giuwWpolicydsList));
		}
		return giuwPolDistList;
	}

	@Override
	public String checkDistFlag(Integer distNo, Integer distSeqNo)
			throws SQLException {
		return this.giuwPolDistDAO.checkDistFlag(distNo, distSeqNo);
	}

	@Override
	public Map<String, Object> compareGipiItemItmperil(Map<String, Object> params)
			throws SQLException {
		return this.giuwPolDistDAO.compareGipiItemItmperil(params);
	}
	
	@Override
	public Map<String, Object> compareGipiItemItmperil2(Map<String, Object> params)
			throws SQLException {
		return this.giuwPolDistDAO.compareGipiItemItmperil2(params);
	}	

	@Override
	public Map<String, Object> createItems(Map<String, Object> params)
			throws SQLException {
		return this.giuwPolDistDAO.createItems(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> giuws003NewFormInstance(
			Map<String, Object> params) throws SQLException {
		Map<String, Object> formMap = new HashMap<String, Object>();
		List<GIUWPolDist> giuwPolDistList = new ArrayList<GIUWPolDist>();
		String isPack = (params.get("isPack") == null) ? "N" : params.get("isPack").toString();
		Integer packParId = Integer.parseInt((params.get("packParId") == null) ? "0" : params.get("packParId").toString());
		Integer parId = null;
		
		//ApplicationContext APPLICATION_CONTEXT = (ApplicationContext) params.get("applicationContext");
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		Integer globalParId = request.getParameter("globalParId") == null ? 0 : (request.getParameter("globalParId").toString().isEmpty() ? 0 : new Integer(request.getParameter("globalParId").toString()));
		Integer globalPackParId = request.getParameter("globalPackParId") == null ? 0 : (request.getParameter("globalPackParId").toString().isEmpty() ? 0 : new Integer(request.getParameter("globalPackParId").toString()));
		//LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		
		if (params.get("newParId") == null) { // added by emman - used in GIUWS003
			parId = globalPackParId == 0 ? globalParId : globalPackParId;
		} else if (params.get("newParId").toString().isEmpty() || Integer.parseInt(params.get("newParId").toString()) == 0) {
			parId = globalPackParId == 0 ? globalParId : globalPackParId;
		} else {
			parId = Integer.parseInt(params.get("newParId").toString());// commented by tonio July 13, 2011 for package handling Integer.parseInt(request.getParameter("globalParId") == null ? request.getParameter("parId") : request.getParameter("globalParId"));
		}
		
		if ("Y".equals(isPack)) {
			giuwPolDistList = this.getGiuwPolDistDAO().getPackGIUWPolDist1(packParId);
		} else {
			giuwPolDistList = this.getGiuwPolDistDAO().getGIUWPolDist1(parId);
		}
		
		// escape html all the sublists in GIUW Pol Dist
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWWPerilds> giuwWPerildsList = giuwPolDist.getGiuwWPerilds();
			// escape html all the sublists in GIUW Pol Dist
			for (GIUWWPerilds giuwWPerilds : giuwWPerildsList) {
				giuwWPerilds.setGiuwWPerildsDtl((List<GIUWWPerildsDtl>) StringFormatter.escapeHTMLInList(giuwWPerilds.getGiuwWPerildsDtl()));
			}
			giuwPolDist.setGiuwWPerilds((List<GIUWWPerilds>) StringFormatter.escapeHTMLInList(giuwWPerildsList));
		}
		
		request.setAttribute("USER", params.get("USER"));
		request.setAttribute("forDist", "Y");		
		request.setAttribute("giuwPolDist", new JSONArray((List<GIUWPolDist>) StringFormatter.escapeHTMLInList(giuwPolDistList)));
		
		return formMap;
	}

	@Override
	public Map<String, Object> postDist(Map<String, Object> params, String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS004", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));
		
		return this.giuwPolDistDAO.postDist(params);
	}

	@Override
	public Map<String, Object> savePrelimOneRiskDist(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS004", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		params.put("savePosting", objParams.getString("savePosting"));
		params.put("distSpctChk", objParams.getString("distSpctChk"));
		return this.giuwPolDistDAO.savePrelimOneRiskDist(params);
	}

	private List<GIUWWpolicydsDtl> prepareGiuwWpolicydsDtlRows(JSONArray rows,
			GIISUser USER) throws JSONException {
		List<GIUWWpolicydsDtl> polDistList = new ArrayList<GIUWWpolicydsDtl>();
		GIUWWpolicydsDtl polDist = null;
		JSONObject objPolDist = null;
		
		for(int i=0, length=rows.length(); i < length; i++){
			polDist = new GIUWWpolicydsDtl();
			objPolDist = rows.getJSONObject(i);
			
			polDist.setDistNo(objPolDist.isNull("distNo") ? null : objPolDist.getInt("distNo"));
			polDist.setDistSeqNo(objPolDist.isNull("distSeqNo") ? null : objPolDist.getInt("distSeqNo"));
			polDist.setLineCd(objPolDist.isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("lineCd")));
			polDist.setShareCd(objPolDist.isNull("shareCd") ? null : objPolDist.getInt("shareCd"));
			polDist.setDistSpct(objPolDist.isNull("distSpct") ? null : objPolDist.getString("distSpct").replaceAll(",", ""));
			polDist.setDistTsi(objPolDist.isNull("distTsi") ? null : new  BigDecimal(objPolDist.getString("distTsi").replaceAll(",", "")));
			polDist.setDistPrem(objPolDist.isNull("distPrem") ? null : new  BigDecimal(objPolDist.getString("distPrem").replaceAll(",", "")));
			polDist.setAnnDistSpct(objPolDist.isNull("annDistSpct") ? null : objPolDist.getString("annDistSpct").replaceAll(",", ""));
			polDist.setAnnDistTsi(objPolDist.isNull("annDistTsi") ? null : new  BigDecimal(objPolDist.getString("annDistTsi").replaceAll(",", "")));
			polDist.setDistGrp(objPolDist.isNull("distGrp") || "".equals(objPolDist.getString("distGrp")) ? null : objPolDist.getInt("distGrp"));
			polDist.setDistSpct1(objPolDist.isNull("distSpct1") || "".equals(objPolDist.getString("distSpct1")) ? null : objPolDist.getString("distSpct1").replaceAll(",", ""));
			polDist.setArcExtData(objPolDist.isNull("arcExtData") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("arcExtData")));
			polDist.setDspTrtyCd(objPolDist.isNull("dspTrtyCd") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("dspTrtyCd")));
			polDist.setDspTrtyName(objPolDist.isNull("dspTrtyName") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("dspTrtyName")));
			polDist.setDspTrtySw(objPolDist.isNull("dspTrtySw") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("dspTrtySw")));
			polDist.setNbtShareType(objPolDist.isNull("nbtShareType") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("nbtShareType")));
			polDist.setUserId(USER.getUserId());
			
			polDistList.add(polDist);
			polDist = null;
		}
		return polDistList;
	}

	private List<GIUWWpolicyds> prepareGiuwWpolicydsRows(JSONArray rows, GIISUser USER) throws JSONException {
		List<GIUWWpolicyds> polDistList = new ArrayList<GIUWWpolicyds>();
		GIUWWpolicyds polDist = null;
		JSONObject objPolDist = null;
		
		for(int i=0, length=rows.length(); i < length; i++){
			polDist = new GIUWWpolicyds();
			objPolDist = rows.getJSONObject(i);
			
			polDist.setDistNo(objPolDist.isNull("distNo") ? null : objPolDist.getInt("distNo"));
			polDist.setDistSeqNo(objPolDist.isNull("distSeqNo") ? null : objPolDist.getInt("distSeqNo"));
			polDist.setDistFlag(objPolDist.isNull("distFlag") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("distFlag")));
			polDist.setTsiAmt(objPolDist.isNull("tsiAmt") ? null : new  BigDecimal(objPolDist.getString("tsiAmt").replaceAll(",", "")));
			polDist.setPremAmt(objPolDist.isNull("premAmt") ? null : new  BigDecimal(objPolDist.getString("premAmt").replaceAll(",", "")));
			polDist.setItemGrp(objPolDist.isNull("itemGrp") || "".equals(objPolDist.getString("itemGrp")) ? null : objPolDist.getInt("itemGrp"));
			polDist.setAnnTsiAmt(objPolDist.isNull("annTsiAmt") ? null : new  BigDecimal(objPolDist.getString("annTsiAmt").replaceAll(",", "")));
			polDist.setArcExtData(objPolDist.isNull("arcExtData") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("arcExtData")));
			polDist.setCurrencyCd(objPolDist.isNull("currencyCd") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("currencyCd")));
			polDist.setCurrencyDesc(objPolDist.isNull("currencyDesc") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("currencyDesc")));
			polDist.setNbtLineCd(objPolDist.isNull("nbtLineCd") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("nbtLineCd")));
			polDist.setUserId(USER.getUserId());
			
			polDistList.add(polDist);
			polDist = null;
		}
		return polDistList;
	}

	private List<GIUWPolDist> prepareGiuwPoldistRows(JSONArray rows, GIISUser USER) throws JSONException, ParseException {
		List<GIUWPolDist> polDistList = new ArrayList<GIUWPolDist>();
		GIUWPolDist polDist = null;
		JSONObject objPolDist = null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		JSONArray objDs = null;		
		
		for(int i=0, length=rows.length(); i < length; i++){
			polDist = new GIUWPolDist();
			objPolDist = rows.getJSONObject(i);
			
			polDist.setDistNo(objPolDist.isNull("distNo") ? null : objPolDist.getInt("distNo"));
			polDist.setParId(objPolDist.isNull("parId") ? null : objPolDist.getInt("parId"));
			polDist.setDistFlag(objPolDist.isNull("distFlag") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("distFlag")));
			polDist.setRedistFlag(objPolDist.isNull("redistFlag") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("redistFlag")));
			polDist.setEffDate(objPolDist.isNull("effDate") || "".equals(objPolDist.getString("effDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("effDate"))));
			polDist.setExpiryDate(objPolDist.isNull("expiryDate") || "".equals(objPolDist.getString("expiryDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("expiryDate"))));
			polDist.setCreateDate(objPolDist.isNull("createDate") || "".equals(objPolDist.getString("createDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("createDate"))));
			polDist.setPostFlag(objPolDist.isNull("postFlag") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("postFlag")));
			polDist.setPolicyId(objPolDist.isNull("policyId") || "".equals(objPolDist.getString("policyId")) ? null : objPolDist.getInt("policyId"));
			polDist.setEndtType(objPolDist.isNull("endtType") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("endtType")));
			polDist.setTsiAmt(objPolDist.isNull("tsiAmt") ? null : new  BigDecimal(objPolDist.getString("tsiAmt").replaceAll(",", "")));
			polDist.setPremAmt(objPolDist.isNull("premAmt") ? null : new  BigDecimal(objPolDist.getString("premAmt").replaceAll(",", "")));
			polDist.setAnnTsiAmt(objPolDist.isNull("annTsiAmt") ? null : new  BigDecimal(objPolDist.getString("annTsiAmt").replaceAll(",", "")));
			polDist.setDistType(objPolDist.isNull("distType") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("distType")));
			polDist.setItemPostedSw(objPolDist.isNull("itemPostedSw") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("itemPostedSw")));
			polDist.setExLossSw(objPolDist.isNull("exLossSw") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("exLossSw")));
			polDist.setNegateDate(objPolDist.isNull("negateDate") || "".equals(objPolDist.getString("negateDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("negateDate"))));
			polDist.setAcctEntDate(objPolDist.isNull("acctEntDate") || "".equals(objPolDist.getString("acctEntDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("acctEntDate"))));
			polDist.setAcctNegDate(objPolDist.isNull("acctNegDate") || "".equals(objPolDist.getString("acctNegDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("acctNegDate"))));
			polDist.setBatchId(objPolDist.isNull("batchId") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("batchId")));
			polDist.setLastUpdDate(objPolDist.isNull("lastUpdDate") || "".equals(objPolDist.getString("lastUpdDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("lastUpdDate"))));
			polDist.setCpiRecNo(objPolDist.isNull("cpiRecNo") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("cpiRecNo")));
			polDist.setCpiBranchCd(objPolDist.isNull("cpiBranchCd") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("cpiBranchCd")));
			polDist.setAutoDist(objPolDist.isNull("autoDist") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("autoDist")));
			polDist.setOldDistNo(objPolDist.isNull("oldDistNo") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("oldDistNo")));
			polDist.setPostDate(objPolDist.isNull("postDate") || "".equals(objPolDist.getString("postDate")) ? null : sdf.parse(StringEscapeUtils.unescapeHtml(objPolDist.getString("postDate"))));
			polDist.setTakeupSeqNo(objPolDist.isNull("takeupSeqNo") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("takeupSeqNo")));
			polDist.setItemGrp(objPolDist.isNull("itemGrp") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("itemGrp")));
			polDist.setArcExtData(objPolDist.isNull("arcExtData") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("arcExtData")));
			polDist.setMultiBookingMm(objPolDist.isNull("multiBookingMm") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("multiBookingMm")));
			polDist.setMultiBookingYy(objPolDist.isNull("multiBookingYy") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("multiBookingYy")));
			polDist.setMeanDistFlag(objPolDist.isNull("meanDistFlag") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("meanDistFlag")));
			polDist.setVarShare(objPolDist.isNull("varShare") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("varShare")));
			polDist.setDistPostFlag(objPolDist.isNull("distPostFlag") ? null : StringEscapeUtils.unescapeHtml(objPolDist.getString("distPostFlag")));
			polDist.setUserId(USER.getUserId());
			polDist.setAppUser(USER.getUserId());
			
			objDs = objPolDist.isNull("giuwWpolicyds") ? null : new JSONArray(objPolDist.getString("giuwWpolicyds"));
			
			// check if objDs is still null, and check if giuwWPerilds is not null (for Preliminary Peril Dist, emman 06.03.2011)
			if (objDs == null) {
				objDs = objPolDist.isNull("giuwWPerilds") ? null : new JSONArray(objPolDist.getString("giuwWPerilds"));
				polDist.setGiuwWPerilds(this.prepareGiuwWPerildsRows(objDs, USER));
			} else {
				polDist.setGiuwWpolicyds(this.prepareGiuwWpolicydsRows(objDs, USER));
			}
			
			polDistList.add(polDist);
			polDist = null;
		}
		return polDistList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDist2(Integer parId) throws SQLException {
		List<GIUWPolDist> giuwPolDistList = this.giuwPolDistDAO.getGIUWPolDist2(parId);
		// escape html all the sublists in GIUW Pol Dist
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWWitemds> giuwWitemdsList = giuwPolDist.getGiuwWitemds();
			giuwPolDist.setGiuwWitemds((List<GIUWWitemds>) StringFormatter.escapeHTMLInList(giuwWitemdsList));
		}
		return giuwPolDistList;
	}

	@Override
	public Map<String, Object> createItems2(Map<String, Object> params)
			throws Exception {
		return this.giuwPolDistDAO.createItems2(params);
	}

	@Override
	public String saveSetupGroupDist(String parameter, String userId)
			throws SQLException, Exception {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("userId", userId);
		allParams.put("parId", objParameters.getString("parId"));
		allParams.put("lineCd", objParameters.getString("lineCd"));
		allParams.put("sublineCd", objParameters.getString("sublineCd"));
		allParams.put("issCd", objParameters.getString("issCd"));
		allParams.put("packPolFlag", objParameters.getString("packPolFlag"));
		allParams.put("polFlag", objParameters.getString("polFlag")); // changed from packPolFlag to polFlag (emman 07.15.2011)
		allParams.put("parType", objParameters.getString("parType"));
		allParams.put("isPack", objParameters.getString("isPack"));
		allParams.put("setRows", prepareSetupGroupJSON(new JSONArray(objParameters.getString("setRows")), userId));
		allParams.put("recreateRows", prepareSetupGroupCreatedItemsJSON(new JSONArray(objParameters.getString("recreateRows")), userId));
		return this.giuwPolDistDAO.saveSetupGroupDist(allParams);
	}

	private List<Map<String, Object>> prepareSetupGroupCreatedItemsJSON(JSONArray rows,
			String userId) throws JSONException {
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String, Object> params = null;
		
		for(int index=0; index<rows.length(); index++) {
			params = new HashMap<String, Object>();
			params.put("distNo", rows.getJSONObject(index).isNull("distNo") || rows.getJSONObject(index).get("distNo").equals("") ? null : rows.getJSONObject(index).getInt("distNo"));
			params.put("parId", rows.getJSONObject(index).isNull("parId") || rows.getJSONObject(index).get("parId").equals("") ? null : rows.getJSONObject(index).getInt("parId"));
			params.put("lineCd", rows.getJSONObject(index).isNull("lineCd") || rows.getJSONObject(index).get("lineCd").equals("") ? null : rows.getJSONObject(index).getString("lineCd"));
			params.put("sublineCd", rows.getJSONObject(index).isNull("sublineCd") || rows.getJSONObject(index).get("sublineCd").equals("") ? null : rows.getJSONObject(index).getString("sublineCd"));
			params.put("issCd", rows.getJSONObject(index).isNull("issCd") || rows.getJSONObject(index).get("issCd").equals("") ? null : rows.getJSONObject(index).getString("issCd"));
			params.put("packPolFlag", rows.getJSONObject(index).isNull("packPolFlag") || rows.getJSONObject(index).get("packPolFlag").equals("") ? null : rows.getJSONObject(index).getString("packPolFlag"));
			params.put("polFlag", rows.getJSONObject(index).isNull("polFlag") || rows.getJSONObject(index).get("polFlag").equals("") ? null : rows.getJSONObject(index).getString("polFlag"));
			params.put("parType", rows.getJSONObject(index).isNull("parType") || rows.getJSONObject(index).get("parType").equals("") ? null : rows.getJSONObject(index).getString("parType"));
			params.put("itemGrp", rows.getJSONObject(index).isNull("itemGrp") || rows.getJSONObject(index).get("itemGrp").equals("") ? null : rows.getJSONObject(index).getString("itemGrp"));
			params.put("takeupSeqNo", rows.getJSONObject(index).isNull("takeupSeqNo") || rows.getJSONObject(index).get("takeupSeqNo").equals("") ? null : rows.getJSONObject(index).getString("takeupSeqNo"));
			params.put("label", rows.getJSONObject(index).isNull("label") || rows.getJSONObject(index).get("label").equals("") ? null : rows.getJSONObject(index).getString("label"));
			params.put("userId", userId);
			list.add(params);
			params = null;
		}
		return list;
	}

	private List<GIUWWitemds> prepareSetupGroupJSON(JSONArray rows, String userId) throws JSONException {
		GIUWWitemds giuwWitemds = null;
		List<GIUWWitemds> list = new ArrayList<GIUWWitemds>();
		
		for(int index=0; index<rows.length(); index++) {
			giuwWitemds = new GIUWWitemds();
			giuwWitemds.setDistNo(rows.getJSONObject(index).isNull("distNo") || rows.getJSONObject(index).get("distNo").equals("") ? null : rows.getJSONObject(index).getInt("distNo"));
			giuwWitemds.setDistSeqNo(rows.getJSONObject(index).isNull("distSeqNo") || rows.getJSONObject(index).get("distSeqNo").equals("") ? null : rows.getJSONObject(index).getInt("distSeqNo"));
			giuwWitemds.setItemNo(rows.getJSONObject(index).isNull("itemNo") || rows.getJSONObject(index).get("itemNo").equals("") ? null : rows.getJSONObject(index).getInt("itemNo"));
			giuwWitemds.setTsiAmt(rows.getJSONObject(index).isNull("tsiAmt") || rows.getJSONObject(index).get("tsiAmt").equals("") ? null : new BigDecimal(rows.getJSONObject(index).getString("tsiAmt").replaceAll(",", "")));
			giuwWitemds.setPremAmt(rows.getJSONObject(index).isNull("premAmt") || rows.getJSONObject(index).get("premAmt").equals("") ? null : new BigDecimal(rows.getJSONObject(index).getString("premAmt").replaceAll(",", "")));
			giuwWitemds.setAnnTsiAmt(rows.getJSONObject(index).isNull("annTsiAmt") || rows.getJSONObject(index).get("annTsiAmt").equals("") ? null : new BigDecimal(rows.getJSONObject(index).getString("annTsiAmt").replaceAll(",", "")));
			giuwWitemds.setArcExtData(rows.getJSONObject(index).isNull("arcExtData") || rows.getJSONObject(index).get("arcExtData").equals("") ? null : rows.getJSONObject(index).getString("arcExtData"));
			giuwWitemds.setOrigDistSeqNo(rows.getJSONObject(index).isNull("origDistSeqNo") || rows.getJSONObject(index).get("origDistSeqNo").equals("") ? null : rows.getJSONObject(index).getString("origDistSeqNo"));
			giuwWitemds.setItemGrp(rows.getJSONObject(index).isNull("itemGrp") || rows.getJSONObject(index).get("itemGrp").equals("") ? null : rows.getJSONObject(index).getString("itemGrp"));
			giuwWitemds.setUserId(userId);
			list.add(giuwWitemds);
			giuwWitemds = null;
		}
		return list;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#checkDistFlagGiuws003(java.util.Map)
	 */
	@Override
	public void checkDistFlagGiuws003(Map<String, Object> params)
			throws SQLException {
		this.getGiuwPolDistDAO().checkDistFlagGiuws003(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#createItemsGiuws003(java.util.Map)
	 */
	@Override
	public Map<String, Object> createItemsGiuws003(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().createItemsGiuws003(params);
	}

	@Override
	public Map<String, Object> postDistGiuws003(Map<String, Object> params,
			String parameter, GIISUser USER) throws SQLException,
			JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS003", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWPerildsRows", this.prepareGiuwWPerildsRows(new JSONArray(objParams.getString("giuwWPerildsRows")), USER));
		params.put("giuwWPerildsDtlSetRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlSetRows")), USER));
		params.put("giuwWPerildsDtlDelRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlDelRows")), USER));
		
		return this.giuwPolDistDAO.postDistGiuws003(params);
	}
	
	private List<GIUWWPerilds> prepareGiuwWPerildsRows(JSONArray rows, GIISUser USER) throws JSONException {
		List<GIUWWPerilds> perilDistList = new ArrayList<GIUWWPerilds>();
		GIUWWPerilds perilDist = null;
		JSONObject objPerilDist = null;
		
		for(int i=0, length=rows.length(); i < length; i++){
			perilDist = new GIUWWPerilds();
			objPerilDist = rows.getJSONObject(i);
			
			perilDist.setDistNo(objPerilDist.isNull("distNo") ? null : objPerilDist.getInt("distNo"));
			perilDist.setDistSeqNo(objPerilDist.isNull("distSeqNo") ? null : objPerilDist.getInt("distSeqNo"));
			perilDist.setPerilCd(objPerilDist.isNull("perilCd") ? null : objPerilDist.getInt("perilCd"));
			perilDist.setLineCd(objPerilDist.isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("lineCd")));
			perilDist.setTsiAmt(objPerilDist.isNull("tsiAmt") ? null : new  BigDecimal(objPerilDist.getString("tsiAmt").replaceAll(",", "")));
			perilDist.setPremAmt(objPerilDist.isNull("premAmt") ? null : new  BigDecimal(objPerilDist.getString("premAmt").replaceAll(",", "")));
			perilDist.setAnnTsiAmt(objPerilDist.isNull("annTsiAmt") ? null : new  BigDecimal(objPerilDist.getString("annTsiAmt").replaceAll(",", "")));
			perilDist.setDistFlag(objPerilDist.isNull("distFlag") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("distFlag")));			
			perilDist.setArcExtData(objPerilDist.isNull("arcExtData") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("arcExtData")));
			perilDist.setCurrencyDesc(objPerilDist.isNull("currencyDesc") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("currencyDesc")));
			perilDist.setUserId(USER.getUserId());
			perilDist.setAppUser(USER.getUserId());
			
			perilDistList.add(perilDist);
			perilDist = null;
		}
		return perilDistList;
	}
	
	private List<GIUWWPerildsDtl> prepareGiuwWPerildsDtlRows(JSONArray rows, GIISUser USER) throws JSONException {
		List<GIUWWPerildsDtl> perilDistDtlList = new ArrayList<GIUWWPerildsDtl>();
		GIUWWPerildsDtl perilDtlDist = null;
		JSONObject objPerilDist = null;
		
		for(int i=0, length=rows.length(); i < length; i++){
			perilDtlDist = new GIUWWPerildsDtl();
			objPerilDist = rows.getJSONObject(i);
			
			perilDtlDist.setDistNo(objPerilDist.isNull("distNo") ? null : objPerilDist.getInt("distNo"));
			perilDtlDist.setDistSeqNo(objPerilDist.isNull("distSeqNo") ? null : objPerilDist.getInt("distSeqNo"));
			perilDtlDist.setLineCd(objPerilDist.isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("lineCd")));
			perilDtlDist.setPerilCd(objPerilDist.isNull("perilCd") ? null : objPerilDist.getInt("perilCd"));
			perilDtlDist.setShareCd(objPerilDist.isNull("shareCd") ? null : objPerilDist.getInt("shareCd"));
			perilDtlDist.setDistSpct(objPerilDist.isNull("distSpct") ? null : objPerilDist.getString("distSpct").replaceAll(",", ""));
			perilDtlDist.setDistTsi(objPerilDist.isNull("distTsi") ? null : new  BigDecimal(objPerilDist.getString("distTsi").replaceAll(",", "")));
			perilDtlDist.setDistPrem(objPerilDist.isNull("distPrem") ? null : new  BigDecimal(objPerilDist.getString("distPrem").replaceAll(",", "")));
			perilDtlDist.setAnnDistSpct(objPerilDist.isNull("annDistSpct") ? null : objPerilDist.getString("annDistSpct").replaceAll(",", ""));
			perilDtlDist.setAnnDistTsi(objPerilDist.isNull("annDistTsi") ? null : new  BigDecimal(objPerilDist.getString("annDistTsi").replaceAll(",", "")));
			perilDtlDist.setDistGrp(objPerilDist.isNull("distGrp") ? null : objPerilDist.getInt("distGrp"));
			perilDtlDist.setDistSpct1(objPerilDist.isNull("distSpct1") ? null : objPerilDist.getString("distSpct1").replaceAll(",", ""));
			perilDtlDist.setArcExtData(objPerilDist.isNull("arcExtData") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("arcExtData")));
			perilDtlDist.setTrtyName(objPerilDist.isNull("trtyName") ? null : StringEscapeUtils.unescapeHtml(objPerilDist.getString("trtyName")));
			perilDtlDist.setUserId(USER.getUserId());
			perilDtlDist.setAppUser(USER.getUserId());
			
			perilDistDtlList.add(perilDtlDist);
			perilDtlDist = null;
		}
		return perilDistDtlList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#savePrelimPerilDist(java.lang.String, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public Map<String, Object> savePrelimPerilDist(String parameter,
			GIISUser USER, String isPack) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS003", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWPerildsRows", this.prepareGiuwWPerildsRows(new JSONArray(objParams.getString("giuwWPerildsRows")), USER));
		params.put("giuwWPerildsDtlSetRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlSetRows")), USER));
		params.put("giuwWPerildsDtlDelRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlDelRows")), USER));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		params.put("postSw", objParams.getString("postSw"));
		params.put("isPack", isPack);
		return this.giuwPolDistDAO.savePrelimPerilDist(params);
	}

	@Override
	public Map<String, Object> checkDistMenu(HttpServletRequest request,
			GIISUser USER, ApplicationContext APPLICATIONCONTEXT) throws SQLException {
		GIISParameterFacadeService giisp = (GIISParameterFacadeService) APPLICATIONCONTEXT.getBean("giisParameterFacadeService");
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("parId", request.getParameter("parId"));
		params.put("issCdRi", giisp.getParamValueV2("ISS_CD_RI"));
		params.put("pack", request.getParameter("isPack"));
		return this.giuwPolDistDAO.checkDistMenu(params);
	}

	@Override
	public Map<String, Object> savePrelimPerilDistByTsiPrem(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params = prepareTablesForPeril(objParams, USER);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS006", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		params.put("savePosting", objParams.getString("savePosting"));
		params = this.giuwPolDistDAO.savePrelimPerilDistByTsiPrem(params);
		Map<String, Object> paramsOut = new HashMap<String, Object>();
		paramsOut.put("message", params.get("message"));
		paramsOut.put("giuwPolDist", params.get("giuwPolDist"));
		return paramsOut;
	}

	@Override
	public Map<String, Object> createItemsGiuws006(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", distNo);
		params.put("parId", parId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("polFlag", request.getParameter("polFlag"));
		params.put("parType", request.getParameter("parType"));
		params.put("userId", USER.getUserId());
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("label", request.getParameter("label"));
		params =  this.giuwPolDistDAO.createItemsGiuws006(params);
		params.put("newItems", new JSONObject((GIUWPolDist) StringFormatter.escapeHTMLInObject(params.get("newItems"))));
		return params;
	}
	
	public Map<String, Object> savePrelimOneRiskDistByTsiPrem(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS005", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		params.put("savePosting", objParams.getString("savePosting"));
		return this.giuwPolDistDAO.savePrelimOneRiskDistByTsiPrem(params);
	}
	
	@Override
	public Map<String, Object> postDistGiuws006(HttpServletRequest request, String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
		Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("distNo", distNo);
		params.put("distSeqNo", distSeqNo);
		params.put("moduleId", "GIUWS006");
		params.put("userId", USER.getUserId());
		params.put("currentFormName", "GIUWS006");
		
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS006", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.putAll(prepareTablesForPeril(objParams, USER));
		return this.giuwPolDistDAO.postDistGiuws006(params);
	}

	private List<HashMap<String, Object>>  prepareDistPostedRecreated(String moduleId, JSONArray rows, GIISUser USER) throws JSONException {
		List<HashMap<String, Object>> postedRecreatedList = new ArrayList<HashMap<String, Object>>();
		HashMap<String, Object> polDist = null;
		JSONObject objPolDist = null;
		
		for(int i=0, length=rows.length(); i < length; i++){
			polDist = new HashMap<String, Object>();
			objPolDist = rows.getJSONObject(i);
			
			if (objPolDist.getInt("processId") == i){
				if ("R".equals(objPolDist.getString("process"))){
					polDist.put("parId", (objPolDist.isNull("parId") ? null : objPolDist.getInt("parId")));
					polDist.put("distNo", (objPolDist.isNull("distNo") ? null : objPolDist.getInt("distNo")));
					polDist.put("lineCd", (objPolDist.isNull("lineCd") ? null : objPolDist.getString("lineCd")));
					polDist.put("sublineCd",(objPolDist.isNull("sublineCd") ? null : objPolDist.getString("sublineCd")));
					polDist.put("issCd", (objPolDist.isNull("issCd") ? null : objPolDist.getString("issCd")));
					polDist.put("packPolFlag", (objPolDist.isNull("packPolFlag") ? null : objPolDist.getString("packPolFlag")));
					polDist.put("polFlag", (objPolDist.isNull("polFlag") ? null : objPolDist.getString("polFlag")));
					polDist.put("parType", (objPolDist.isNull("parType") ? null : objPolDist.getString("parType")));
					polDist.put("userId", USER.getUserId());
					polDist.put("process", (objPolDist.isNull("process") ? null : objPolDist.getString("process")));
					polDist.put("processId", (objPolDist.isNull("processId") ? null : objPolDist.getInt("processId")));
					polDist.put("label", (objPolDist.isNull("label") ? null : objPolDist.getString("label")));
				}else if("P".equals(objPolDist.getString("process"))){
					polDist.put("parId", (objPolDist.isNull("parId") ? null : objPolDist.getInt("parId")));
					polDist.put("distNo", (objPolDist.isNull("distNo") ? null : objPolDist.getInt("distNo")));
					polDist.put("distSeqNo", (objPolDist.isNull("distSeqNo") ? null : objPolDist.getInt("distSeqNo")));
					polDist.put("moduleId", moduleId);
					polDist.put("userId", USER.getUserId());
					polDist.put("currentFormName", moduleId);
					polDist.put("process", (objPolDist.isNull("process") ? null : objPolDist.getString("process")));
					polDist.put("processId", (objPolDist.isNull("processId") ? null : objPolDist.getInt("processId")));
					polDist.put("overrideSwitch", (objPolDist.isNull("overrideSwitch") ? null : objPolDist.getString("overrideSwitch")));
				} 
			}
			
			postedRecreatedList.add(polDist);
			polDist = null;
		}
		
		return postedRecreatedList;
	}
	
	@Override
	public Map<String, Object> createItemsGiuws005(Map<String, Object> params)
			throws SQLException {
		return this.giuwPolDistDAO.createItemsGiuws005(params);
	}
	
	public Map<String, Object> postDistGiuw005(Map<String, Object> params, String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS005", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));

		return this.giuwPolDistDAO.postDistGiuws005(params);
	}

	@Override
	public String checkIfPosted(Integer distno) throws SQLException {
		// TODO Auto-generated method stub
		return this.giuwPolDistDAO.checkIfPosted(distno);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getPackGIUWPolDist(Integer packParId)
			throws SQLException {
		List<GIUWPolDist> giuwPolDistList = this.giuwPolDistDAO.getPackGIUWPolDist(packParId);
		// escape html all the sublists in GIUW Pol Dist
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWWitemds> giuwWitemdsList = giuwPolDist.getGiuwWitemds();
			giuwPolDist.setGiuwWitemds((List<GIUWWitemds>) StringFormatter.escapeHTMLInList(giuwWitemdsList));
		}
		return giuwPolDistList;
	}	
	
	@Override
	public List<GIUWPolDist> getGIUWPolDistGiuws013(Map<String, Object> params) throws SQLException {
		List<GIUWPolDist> giuwPolDistList = this.giuwPolDistDAO.getGIUWPolDistGiuws013(params);
		System.out.println("LIST SIZE: " + giuwPolDistList.size());
		// escape html all the sublists in GIUW Pol Dist
		/*
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWWpolicyds> giuwWpolicydsList = giuwPolDist.getGiuwWpolicyds();
			// escape html all the sublists in GIUW Pol Dist
			for (GIUWWpolicyds giuwWpolicyds : giuwWpolicydsList) {
				giuwWpolicyds.setGiuwWpolicydsDtl((List<GIUWWpolicydsDtl>) StringFormatter.escapeHTMLInList(giuwWpolicyds.getGiuwWpolicydsDtl()));
			}
			giuwPolDist.setGiuwWpolicyds((List<GIUWWpolicyds>) StringFormatter.escapeHTMLInList(giuwWpolicydsList));
		}
		*/
		return giuwPolDistList;
	}
	
	@Override
	public List<GIUWPolDist> getGIUWPolDistGiuws016(Map<String, Object> params) throws SQLException {
		List<GIUWPolDist> giuwPolDistList = this.giuwPolDistDAO.getGIUWPolDistGiuws016(params);
		System.out.println("LIST SIZE: " + giuwPolDistList.size());
		return giuwPolDistList;
	}
	
	public Map<String, Object> postDistGiuws013(Map<String, Object> params) throws SQLException, JSONException, ParseException {
		

		return this.giuwPolDistDAO.postDistGiuws013(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#getGIUWPolDistForPerilDistribution(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public List<GIUWPolDist> getGIUWPolDistForPerilDistribution(Integer parId, Integer distNo)
			throws SQLException {
		List<GIUWPolDist> giuwPolDistList = new ArrayList<GIUWPolDist>();
		giuwPolDistList = this.getGiuwPolDistDAO().getGIUWPolDistForPerilDistribution(parId, distNo);
		return this.formatTableForPeril(giuwPolDistList);
	}
	
	public Map<String, Object> saveOneRiskDistGiuws013(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS013", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		//params.put("savePosting", objParams.getString("savePosting"));
		params.put("policyId", objParams.getString("policyId"));
		params.put("batchId", objParams.getString("batchId"));
		params.put("batchDistSw", objParams.has("batchDistSw") ? objParams.getString("batchDistSw") : "");
		Debug.print("SAVE PARAMS: " + params);
		return this.giuwPolDistDAO.saveOneRiskDistGiuws013(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#saveDistributionByPeril(java.lang.String, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public Map<String, Object> saveDistributionByPeril(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		//params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS003", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWPerildsRows", this.prepareGiuwWPerildsRows(new JSONArray(objParams.getString("giuwWPerildsRows")), USER));
		params.put("giuwWPerildsDtlSetRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlSetRows")), USER));
		params.put("giuwWPerildsDtlDelRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlDelRows")), USER));
		params.put("parId", objParams.getInt("parId"));
		params.put("distNo", objParams.getInt("distNo"));
		params.put("policyId", objParams.getInt("policyId"));
		params.put("postSw", objParams.getString("postSw"));
		params.put("userId", USER.getUserId());
		
		return this.giuwPolDistDAO.saveDistributionByPeril(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void showPreliminaryOneRiskDist(HttpServletRequest request,
			GIPIPARListService gipiParListService) throws SQLException {
		System.out.println("parId: " + request.getParameter("globalParId") + "packParId: " + request.getParameter("globalPackParId"));
		
		Integer initialParSelected = Integer.parseInt((request.getParameter("initialParSelected") == "" || request.getParameter("initialParSelected") == null) ? "0" : request.getParameter("initialParSelected"));
		Integer parId = Integer.parseInt("".equals(request.getParameter("globalParId")) ? "0" : request.getParameter("globalParId"));
		Integer packParId = Integer.parseInt("".equals(request.getParameter("globalPackParId")) ? "0" : request.getParameter("globalPackParId"));
		String isPack = packParId == 0 ? "N" : "Y";
		
		System.out.println("ISPACK: " + isPack);
		request.setAttribute("isPack", isPack);
		
		if ("Y".equals(isPack)) { // andrew - added condition to execute the retrieval of package par records only for package
			List<GIPIPARList> gipiPolParList = (List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, null));
			request.setAttribute("parPolicyList", new JSONArray(gipiPolParList));
			
			if(initialParSelected == 0){
				parId = gipiPolParList.get(0).getParId();
				System.out.println("NEW PAR ID!!!!" + parId);
			}else {					
				if (packParId != 0) {
					parId = initialParSelected;
				}
			}
		} else{
			request.setAttribute("parPolicyList", new JSONArray());
		}
		
		request.setAttribute("parId", initialParSelected == 0 ? parId : initialParSelected);
		request.setAttribute("forDist", "Y");
		request.setAttribute("GIUWPolDistJSON", new JSONArray((List<GIUWPolDist>) StringFormatter.replaceQuotesInList(this.getGIUWPolDist(parId, null))));
	}

	@Override
	public List<GIUWPolDist> getGIUWPolDistGiuts002(Map<String, Object> params)
			throws SQLException {
		List<GIUWPolDist> giuwPolDistList = this.giuwPolDistDAO.getGIUWPolDistGiuts002(params);
		System.out.println("LIST SIZE: " + giuwPolDistList.size());
		return giuwPolDistList;
	}

	@Override
	public Map<String, Object> negDistGiuts002(Map<String, Object> params)
			throws SQLException {
		return this.giuwPolDistDAO.negDistGiuts002(params);
	}
	
	@Override
	public Map<String, Object> checkExistingClaimGiuts002(Map<String, Object> params)
			throws SQLException {
		return this.giuwPolDistDAO.checkExistingClaimGiuts002(params);
	}
	
	@Override
	public List<GIUWPolDist> getDistByTsiPremPeril(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", new Integer(request.getParameter("policyId") == null ? "0" : (request.getParameter("policyId").toString().isEmpty() ? "0" : request.getParameter("policyId"))));
		params.put("distNo", new Integer(request.getParameter("distNo") == null ? "0" : (request.getParameter("distNo").toString().isEmpty() ? "0" : request.getParameter("distNo"))));
		params.put("polFlag", request.getParameter("polFlag"));
		params.put("parType", request.getParameter("parType"));
		params.put("userId", USER.getUserId());
		params.put("parId", request.getParameter("parId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		
		List<GIUWPolDist> giuwPolDistList = new ArrayList<GIUWPolDist>();
		giuwPolDistList = this.getGiuwPolDistDAO().getDistByTsiPremPeril(params);
		
		return this.formatTableForPeril(giuwPolDistList);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#postDistGiuws012(java.util.Map)
	 */
	@Override
	public Map<String, Object> postDistGiuws012(Map<String, Object> params)
			throws SQLException, PostingParException {
		return this.getGiuwPolDistDAO().postDistGiuws012(params);
	}

	@Override
	public void saveDistrByTSIPremGroup(String parameters, GIISUser USER)
			throws SQLException, Exception, JSONException {
		JSONObject objParams = new JSONObject(parameters);
		
		Map<String, Object> params = new HashMap<String, Object>();		
		//params.put("giuwPoldistRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("giuwPolDistRows")), USER.getUserId(), GIUWPolDist.class));
		//params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		//params.put("giuwWpolicydsRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER.getUserId(), GIUWWpolicyds.class));
		//params.put("giuwWpolicydsDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER.getUserId(), GIUWWpolicydsDtl.class));
		//params.put("giuwWpolicydsDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER.getUserId(), GIUWWpolicydsDtl.class));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		params.put("policyId", objParams.getString("policyId"));
		params.put("batchId", objParams.getString("batchId"));
		params.put("postSw", objParams.getString("postSw"));
		Debug.print("SAVE PARAMS: " + params);
		this.getGiuwPolDistDAO().saveDistrByTSIPremGroup(params);

	}
	
	@Override
	public Map<String, Object> postDistGiuws016(Map<String, Object> params)
			throws SQLException, PostingParException {
		return this.getGiuwPolDistDAO().postDistGiuws016(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveDistByTsiPremPeril(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException, DistributionException{
		JSONObject objParams = new JSONObject(parameter);
		DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params = prepareTablesForPeril(objParams, USER);
		params.put("policyId", objParams.getString("policyId"));
		params.put("distNo", objParams.getString("distNo"));
		params.put("polFlag", objParams.getString("polFlag"));
		params.put("parType", objParams.getString("parType"));
		params.put("userId", USER.getUserId());
		params.put("parId", objParams.getInt("parId"));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("issCd", objParams.getString("issCd"));
		params.put("issueYy", objParams.getString("issueYy"));
		params.put("polSeqNo", objParams.getString("polSeqNo"));
		params.put("renewNo", objParams.getString("renewNo"));
		params.put("effDate", format.parse(objParams.getString("effDate")));
		params.put("packPolFlag", objParams.getString("packPolFlag"));
		params.put("postSw", objParams.getString("postSw"));
		params.put("moduleId", "GIUWS017");
		params.put("endtIssCd", objParams.getString("endtIssCd"));
		params.put("endtYy", objParams.getString("endtYy"));
		
		params = this.giuwPolDistDAO.saveDistByTsiPremPeril(params);
		List<GIUWPolDist> giuwPolDistList = (List<GIUWPolDist>) params.get("giuwPolDist");

		Map<String, Object> paramsOut = new HashMap<String, Object>();
		paramsOut.put("message", params.get("message"));
		paramsOut.put("giuwPolDist",  giuwPolDistList != null ? this.formatTableForPeril(giuwPolDistList) :null);
		paramsOut.put("gipiPolbasicPolDistV1", (List<GIPIPolbasicPolDistV1>) params.get("gipiPolbasicPolDistV1") != null ? StringFormatter.escapeHTMLInList((List<GIPIPolbasicPolDistV1>) params.get("gipiPolbasicPolDistV1")) :null);
		paramsOut.put("workflowMsg", params.get("workflowMsg"));
		
		return paramsOut;
	}
	
	private Map<String, Object> prepareTablesForPeril(JSONObject objParams, GIISUser USER) throws JSONException, ParseException{
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWPerildsRows", this.prepareGiuwWPerildsRows(new JSONArray(objParams.getString("giuwWPerildsRows")), USER));
		params.put("giuwWPerildsDtlSetRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlSetRows")), USER));
		params.put("giuwWPerildsDtlDelRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlDelRows")), USER));
		return params;
	}
	
	@SuppressWarnings("unchecked")
	private List<GIUWPolDist> formatTableForPeril(List<GIUWPolDist> polDist){
		List<GIUWPolDist> giuwPolDistList = polDist;
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWWPerilds> giuwWPerildsList = giuwPolDist.getGiuwWPerilds();
			for (GIUWWPerilds giuwWPerilds : giuwWPerildsList) {
				giuwWPerilds.setGiuwWPerildsDtl((List<GIUWWPerildsDtl>) StringFormatter.escapeHTMLInList(giuwWPerilds.getGiuwWPerildsDtl()));
			}
			giuwPolDist.setGiuwWPerilds((List<GIUWWPerilds>) StringFormatter.escapeHTMLInList(giuwWPerildsList));
		}
		return (List<GIUWPolDist>) StringFormatter.escapeHTMLInList(giuwPolDistList);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#getDistFlagAndBatchId(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getDistFlagAndBatchId(Integer policyId,
			Integer distNo) throws SQLException {
		return this.getGiuwPolDistDAO().getDistFlagAndBatchId(policyId, distNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#getGIUWPolDistForRedistribution(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public List<GIUWPolDist> getGIUWPolDistForRedistribution(Integer parId,
			Integer distNo) throws SQLException {
		List<GIUWPolDist> giuwPolDistList = new ArrayList<GIUWPolDist>();
		giuwPolDistList = this.getGiuwPolDistDAO().getGIUWPolDistForRedistribution(parId, distNo);
		return this.formatTableForRedistribution(giuwPolDistList);
	}
	
	@SuppressWarnings("unchecked")
	private List<GIUWPolDist> formatTableForRedistribution(List<GIUWPolDist> polDist){
		List<GIUWPolDist> giuwPolDistList = polDist;
		for (GIUWPolDist giuwPolDist : giuwPolDistList) {
			List<GIUWPerilds> giuwPerildsList = giuwPolDist.getGiuwPerilds();
			for (GIUWPerilds giuwPerilds : giuwPerildsList) {
				giuwPerilds.setGiuwPerildsDtl((List<GIUWPerildsDtl>) StringFormatter.escapeHTMLInList(giuwPerilds.getGiuwPerildsDtl()));
			}
			giuwPolDist.setGiuwPerilds((List<GIUWPerilds>) StringFormatter.escapeHTMLInList(giuwPerildsList));
		}
		return (List<GIUWPolDist>) StringFormatter.escapeHTMLInList(giuwPolDistList);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#negateDistributionGiuts021(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void negateDistributionGiuts021(Map<String, Object> params)
			throws SQLException, NegateDistributionException {
		this.getGiuwPolDistDAO().negateDistributionGiuts021(params);
		
		List<GIUWPolDist> polDistList = (List<GIUWPolDist>) StringFormatter.escapeHTMLInList(params.get("polDistList"));
		
		params.put("polBasic", StringFormatter.escapeHTMLInObject(params.get("polBasic")));
		
		if (polDistList != null) {
			for (GIUWPolDist polDist : polDistList) {
				List<GIUWPerilds> perildsList = (List<GIUWPerilds>) StringFormatter.escapeHTMLInList(polDist.getGiuwPerilds());
				
				for (GIUWPerilds perilds : perildsList) {
					perilds.setGiuwPerildsDtl((List<GIUWPerildsDtl>) StringFormatter.escapeHTMLInList(perilds.getGiuwPerildsDtl()));
				}
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#saveRedistribution(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveRedistribution(Map<String, Object> params)
			throws SQLException {
		this.getGiuwPolDistDAO().saveRedistribution(params);
		
		List<GIUWPolDist> polDistList = (List<GIUWPolDist>) StringFormatter.escapeHTMLInList(params.get("polDistList"));
		
		params.put("polBasic", StringFormatter.escapeHTMLInObject(params.get("polBasic")));
		
		if (polDistList != null) {
			for (GIUWPolDist polDist : polDistList) {
				List<GIUWPerilds> perildsList = (List<GIUWPerilds>) StringFormatter.escapeHTMLInList(polDist.getGiuwPerilds());
				
				for (GIUWPerilds perilds : perildsList) {
					perilds.setGiuwPerildsDtl((List<GIUWPerildsDtl>) StringFormatter.escapeHTMLInList(perilds.getGiuwPerildsDtl()));
				}
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWPolDistService#endRedistributionTransaction()
	 */
	@Override
	public void endRedistributionTransaction() throws SQLException {
		this.getGiuwPolDistDAO().endRedistributionTransaction();
	}

	@Override
	public Map<String, Object> validateExistingDist(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().validateExistingDist(params);
	}
	
	/**
	 * Adjust distribution tables upon posting Edgar 03/05/2014
	 */
	@Override
	public Map<String, Object> adjustPerilDistTables(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().adjustPerilDistTables(params);
	}

	/**
	 * Recomputes distribution premium amounts upon saving/posting edgar 04/29/2014
	 */
	@Override
	public Map<String, Object> recomputePerilDistPrem(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().recomputePerilDistPrem(params);
	}

	/**
	 * Compare distribution tables and itemperil table edgar 05/05/2014
	 */
	@Override
	public Map<String, Object> compareWitemPerilToDs(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().compareWitemPerilToDs(params);
	}
	
	/**
	 * Gets the peril type for checking of endorsement edgar 05/05/2014
	 */
	@Override
	public Map<String, Object> getPerilType(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().getPerilType(params);
	}

	/**
	 * Gets the expiry date for comparison to effectivity date of policy edgar 05/06/2014
	 */
	@Override
	public Map<String, Object> getTreatyExpiry(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().getTreatyExpiry(params);
	}

	/**
	 * Execute deletion of distribution master tables during unposting edgar 05/07/2014
	 */
	@Override
	public Map<String, Object> unpostDist(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().unpostDist(params);
	}

	/**
	 * Recompute and adjust distribution tables with discrepancies edgar 05/07/2014
	 */
	@Override
	public Map<String, Object> recomputeAfterCompare(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().recomputeAfterCompare(params);
	}

	/**
	 *  get takeup term edgar 05/08/2014
	 */
	@Override
	public Map<String, Object> getTakeUpTerm(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().getTakeUpTerm(params);
	}
	
	/**
	 * updates dist_spct1 when distribution is saved in GIUWS003 then navigate to GIUWS006 shan 05.06.2014
	 */	
	public void updateDistSpct1(Integer distNo) throws SQLException{
		this.getGiuwPolDistDAO().updateDistSpct1(distNo);
	}

	@Override
	public void updateGIUWS017DistSpct1(HttpServletRequest request)
			throws SQLException {
		String distNo = request.getParameter("distNo");
		this.getGiuwPolDistDAO().updateGIUWS017DistSpct1(distNo);
	}

	@Override
	public Map<String, Object> getPolicyTakeUp(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().getPolicyTakeUp(params);
	}

	@Override
	public Map<String, Object> comparePolItmperilToDs(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().comparePolItmperilToDs(params);
	}

	/**
	 *  Compare distribution tables and itemperil table for One Risk edgar 05/12/2014
	 */
	@Override
	public Map<String, Object> compareWitemPerilToDsGIUWS004(
			Map<String, Object> params) throws SQLException {
		return this.getGiuwPolDistDAO().compareWitemPerilToDsGIUWS004(params);
	}

	/**
	 *  Recomputes dist prem amounts when dist_spct1 has value for GIUWS004, GIUWS013 edgar 05/12/2014
	 */
	@Override
	public Map<String, Object> adjustDistPremGIUWS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().adjustDistPremGIUWS004(params);
	}
	
	/**
	 *  Adjust all working distribution tables for GIUWS004, GIUWS013 edgar 05/12/2014
	 */
	@Override
	public Map<String, Object> adjustAllWTablesGIUWS004(
			Map<String, Object> params) throws SQLException {
		return this.getGiuwPolDistDAO().adjustAllWTablesGIUWS004(params);
	}

	/**
	 *  check if non-null distSpct1 exists edgar 05/13/2014
	 */
	@Override
	public Map<String, Object> getDistScpt1Val(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().getDistScpt1Val(params);
	}

	/**
	 *  Updates dist_spct1 to null when it has value but same with dist_spct for GIUWS004, GIUWS013 edgar 05/13/2014
	 */
	@Override
	public Map<String, Object> updateDistSpct1ToNull(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().updateDistSpct1ToNull(params);
	}

	/**
	 *  Delete and Reinsert when posting in GIUWS004 which was saved from Peril modules edgar 05/14/2014
	 */
	@Override
	public Map<String, Object> deleteReinsertGIUWS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().deleteReinsertGIUWS004(params);
	}
	
	public void compareDelRinsrtWdistTable(Integer distNo) throws SQLException{
		this.getGiuwPolDistDAO().compareDelRinsrtWdistTable(distNo);
	}
	
	public void updateAutoDistGIUWS005(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", request.getParameter("distNo"));
		params.put("autoDist", request.getParameter("autoDist"));
		
		this.getGiuwPolDistDAO().updateAutoDistGIUWS005(params);
	}
	
	public String compareWdistTable(Map<String, Object> params) throws SQLException{		
		return this.getGiuwPolDistDAO().compareWdistTable(params);
	}
	
	public Map<String, Object> getWpolbasGIUWS005(Integer parId) throws SQLException{
		return this.getGiuwPolDistDAO().getWpolbasGIUWS005(parId);
	}
	
	//Gzelle 06112014
	public void compareDelRinsrtWdistTableGIUWS004(Integer distNo) throws SQLException{
		this.getGiuwPolDistDAO().compareDelRinsrtWdistTableGIUWS004(distNo);
	}
	
	public void cmpareDelRinsrtWdistTbl1GIUWS004(Integer distNo) throws SQLException{
		this.getGiuwPolDistDAO().cmpareDelRinsrtWdistTbl1GIUWS004(distNo);
	}
	
	@Override
	public Map<String, Object> postDistGiuws004Final(Map<String, Object> params, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS004", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));
		return this.giuwPolDistDAO.postDistGiuws004Final(params);
	}
	//end
	
	@Override
	public String checkBinderExist(Integer policyId, Integer distNo)
			throws SQLException {
		return this.giuwPolDistDAO.checkBinderExist(policyId, distNo);
	}
	
	public Map<String, Object> checkNullDistPremGIUWS006(HttpServletRequest request) throws SQLException{
		Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").isEmpty() ? "0" : request.getParameter("distNo")));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", distNo);				
		params.put("btnSw", request.getParameter("btnSw"));		
		
		return this.getGiuwPolDistDAO().checkNullDistPremGIUWS006(params);
	}
	
	public void populateWitemPerilDtl(Integer distNo) throws SQLException{
		this.getGiuwPolDistDAO().populateWitemPerilDtl(distNo);
	}
	
	public String checkSumInsuredPremGIUWS006(Integer distNo) throws SQLException{
		return this.getGiuwPolDistDAO().checkSumInsuredPrem(distNo);
	}
	
	public String validateB4PostGIUWS006(Map<String, Object> params) throws SQLException{		
		return this.getGiuwPolDistDAO().validateB4PostGIUWS006(params);
	}
	
	//edgar 06/10/2014
	@Override
	public Map<String, Object> postDistGiuws003Final(Map<String, Object> params,
			String parameter, GIISUser USER) throws SQLException,
			JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS003", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWPerildsRows", this.prepareGiuwWPerildsRows(new JSONArray(objParams.getString("giuwWPerildsRows")), USER));
		params.put("giuwWPerildsDtlSetRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlSetRows")), USER));
		params.put("giuwWPerildsDtlDelRows", this.prepareGiuwWPerildsDtlRows(new JSONArray(objParams.getString("giuwWPerildsDtlDelRows")), USER));
		
		return this.giuwPolDistDAO.postDistGiuws003Final(params);
	}
	
	public Map<String, Object> postDistGiuws006Final(HttpServletRequest request, String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		Integer distNo = Integer.parseInt("".equals(request.getParameter("distNo")) ? "0" : request.getParameter("distNo"));
		Integer distSeqNo = Integer.parseInt("".equals(request.getParameter("distSeqNo")) ? "0" : request.getParameter("distSeqNo"));
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("distNo", distNo);
		params.put("distSeqNo", distSeqNo);
		params.put("moduleId", "GIUWS006");
		params.put("userId", USER.getUserId());
		params.put("currentFormName", "GIUWS006");
		
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS006", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.putAll(prepareTablesForPeril(objParams, USER));
		return this.giuwPolDistDAO.postDistGiuws006Final(params);
	}

	@Override
	public void validateRenumItemNos(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("policyId") != null && request.getParameter("distNo") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("policyId", request.getParameter("policyId"));
			params.put("distNo", request.getParameter("distNo"));
			this.giuwPolDistDAO.validateRenumItemNos(params);
		}
	}
	
	public Map<String, Object> postDistGiuw005Final(Map<String, Object> params, String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		params.put("postedRecreated", this.prepareDistPostedRecreated("GIUWS005", new JSONArray(objParams.getString("giuwPolDistPostedRecreated")), USER));
		params.put("giuwPoldistRows", this.prepareGiuwPoldistRows(new JSONArray(objParams.getString("giuwPolDistRows")), USER));
		params.put("giuwWpolicydsRows", this.prepareGiuwWpolicydsRows(new JSONArray(objParams.getString("giuwWpolicydsRows")), USER));
		params.put("giuwWpolicydsDtlSetRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlSetRows")), USER));
		params.put("giuwWpolicydsDtlDelRows", this.prepareGiuwWpolicydsDtlRows(new JSONArray(objParams.getString("giuwWpolicydsDtlDelRows")), USER));

		return this.giuwPolDistDAO.postDistGiuws005Final(params);
	}

	@Override
	public void preSaveOuterDist(HttpServletRequest request)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		
		List<Map<String, Object>> perilDsList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> perilDsDtlList = new ArrayList<Map<String, Object>>();
		
		JSONArray perilJSON = new JSONArray(objParams.getString("perilDsList"));
		JSONArray perilDtlJSON = new JSONArray(objParams.getString("perilDsDtlList"));
		
		for(int i = 0; i < perilJSON.length(); i++){
			Map<String, Object> map = new HashMap<String, Object>();
			JSONObject obj = perilJSON.getJSONObject(i);
			
			map.put("lineCd", obj.getString("lineCd"));
			map.put("perilCd", obj.getInt("perilCd"));
			map.put("tsiAmt", obj.getDouble("tsiAmt"));
			map.put("premAmt", obj.getDouble("premAmt"));
			perilDsList.add(map);
		}
		
		for(int i = 0; i < perilDtlJSON.length(); i++){
			Map<String, Object> map = new HashMap<String, Object>();
			JSONObject obj = perilDtlJSON.getJSONObject(i);
			
			map.put("policyId", request.getParameter("policyId"));
			map.put("lineCd", obj.getString("lineCd"));
			map.put("shareCd", obj.getInt("shareCd"));
			map.put("perilCd", obj.getInt("perilCd"));
			map.put("distSeqNo", obj.getInt("distSeqNo"));
			perilDsDtlList.add(map);
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("distNo", request.getParameter("distNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("parType", request.getParameter("parType"));
		params.put("mode", request.getParameter("mode"));
		params.put("giuwWPerildsRows", perilDsList);
		params.put("giuwWPerildsDtlRows", perilDsDtlList);
		this.getGiuwPolDistDAO().preSaveOuterDist(params);
	}
	
	@Override
	public Map<String, Object> checkPostedBinder(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistDAO().checkPostedBinder(params);
	}

	@Override
	public void checkItemPerilAmountAndShare(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", request.getParameter("distNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		this.giuwPolDistDAO.checkItemPerilAmountAndShare(params);
	}

	@Override
	public String checkIfDiffPerilGroupShare(Integer distNo)
			throws SQLException {
		return this.giuwPolDistDAO.checkIfDiffPerilGroupShare(distNo);
	}

	@Override
	public Map<String, Object> validateFaculPremPaytGIUTS002(
			Map<String, Object> params) throws SQLException {
		return this.giuwPolDistDAO.validateFaculPremPaytGIUTS002(params);
	}

	@Override
	public void preValidationNegDist(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("distNo", request.getParameter("distNo"));
		this.giuwPolDistDAO.preValidationNegDist(params);
	}
	//edgar 09/26/2014
	@Override
	public void validateTakeupGiuts021(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		Integer policyId = Integer.parseInt(request.getParameter("policyId"));
		params.put("policyId", policyId);
		this.giuwPolDistDAO.validateTakeupGiuts021(params);
	}
}