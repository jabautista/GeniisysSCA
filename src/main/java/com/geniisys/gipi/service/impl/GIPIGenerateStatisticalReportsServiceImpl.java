package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIGenerateStatisticalReportsDAO;
import com.geniisys.gipi.service.GIPIGenerateStatisticalReportsService;

public class GIPIGenerateStatisticalReportsServiceImpl implements GIPIGenerateStatisticalReportsService{

	private Logger log = Logger.getLogger(GIPIGenerateStatisticalReportsServiceImpl.class);
	
	private GIPIGenerateStatisticalReportsDAO gipiGenerateStatisticalReportsDAO;

	public GIPIGenerateStatisticalReportsDAO getGipiGenerateStatisticalReportsDAO() {
		return gipiGenerateStatisticalReportsDAO;
	}

	public void setGipiGenerateStatisticalReportsDAO(
			GIPIGenerateStatisticalReportsDAO gipiGenerateStatisticalReportsDAO) {
		this.gipiGenerateStatisticalReportsDAO = gipiGenerateStatisticalReportsDAO;
	}
	
	public Map<String, Object> getLineCds() throws SQLException{
		return this.gipiGenerateStatisticalReportsDAO.getLineCds();
	}
	
	public JSONObject getRecCntStatTab(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("statChoice", request.getParameter("statChoice"));
		params.put("subline", request.getParameter("subline"));
		params.put("vessel", request.getParameter("vessel"));
		params.put("cargoClassCd", request.getParameter("cargoClassCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		
		params = this.gipiGenerateStatisticalReportsDAO.getRecCntStatTab(params);
		
		return new JSONObject(params);
	}
	
	public String extractRecordsMotorStat(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("motorStatType", request.getParameter("motorStatType"));
		params.put("zoneType", request.getParameter("zoneType"));
		params.put("dateParam", request.getParameter("dateParam"));
		params.put("printType", request.getParameter("printType"));
		params.put("dateType", request.getParameter("dateType"));
		params.put("vIssCd", request.getParameter("vIssCd"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("year", request.getParameter("year"));
		params.put("appUser", userId);
		
		params = this.gipiGenerateStatisticalReportsDAO.extractRecordsMotorStat(params);
		
		return params.get("msg").toString();
	}
	
	public String chkExistingRecordMotorStat(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("motorStatType", request.getParameter("motorStatType"));
		params.put("printType", request.getParameter("printType"));
		params.put("userId", userId);
		
		return this.gipiGenerateStatisticalReportsDAO.chkExistingRecordMotorStat(params);
	}
	
	public String extractFireStat(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fireStat", request.getParameter("fireStat"));
		params.put("dateRb", request.getParameter("dateRb"));
		params.put("pDate", request.getParameter("pDate"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("busCd", Integer.parseInt(request.getParameter("busCd")));
		params.put("zone", request.getParameter("zone"));
		params.put("zoneType", request.getParameter("zoneType"));
		params.put("riskCnt", request.getParameter("riskCnt"));
		params.put("inclEndt", request.getParameter("inclEndt"));
		params.put("inclExp", request.getParameter("inclExp"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("userId", userId);
		
		params = this.gipiGenerateStatisticalReportsDAO.extractFireStat(params);
		
		return params.get("cnt").toString();
	}
	
	public JSONObject getFireTariffDtl(HttpServletRequest request, GIISUser user, String ACTION) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", ACTION);
		params.put("userId", user.getUserId());
		params.put("asOfSw", request.getParameter("asOfSw"));
		params.put("tarfCd", request.getParameter("tarfCd"));
		params.put("zoneType", request.getParameter("zoneType"));//edgar 03/20/2015
		
		Map<String, Object> fireTariffDtl = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(fireTariffDtl);
		
		return json;
	}
	
	public JSONObject computeFireTariffTotals(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("asOfSw", request.getParameter("asOfSw"));
		params.put("tarfCd", request.getParameter("tarfCd"));
		params.put("zoneType", request.getParameter("zoneType"));//edgar 03/20/2015
		
		JSONObject json = new JSONObject(gipiGenerateStatisticalReportsDAO.computeFireTariffTotals(params));
		
		return json;
	}
	
	public String getTrtyTypeCd(String commitAccumDistShare) throws SQLException{
		return this.gipiGenerateStatisticalReportsDAO.getTrtyTypeCd(commitAccumDistShare);
	}
	
	public JSONObject computeFireZoneMasterTotals(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("asOfSw", request.getParameter("asOfSw"));
		params.put("lineCdFi", request.getParameter("lineCdFi"));
		params.put("zoneType", request.getParameter("zoneType")); // jhing 03.19.2015 
		
		JSONObject json = new JSONObject(gipiGenerateStatisticalReportsDAO.computeFireZoneMasterTotals(params));
		
		return json;
	}
	
	public JSONObject computeFireZoneDetailTotals(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("asOfSw", request.getParameter("asOfSw"));
		params.put("lineCdFi", request.getParameter("lineCdFi"));
		params.put("shareCd", request.getParameter("shareCd"));
		params.put("zoneType", request.getParameter("zoneType"));//edgar 03/20/2015
		
		JSONObject json = new JSONObject(gipiGenerateStatisticalReportsDAO.computeFireZoneDetailTotals(params));
		
		return json;
	}
	
	public JSONObject getFireCommAccumDtl(HttpServletRequest request, GIISUser user, String ACTION) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", ACTION);
		params.put("userId", user.getUserId());
		params.put("asOfSw", request.getParameter("asOfSw"));
		params.put("zone", request.getParameter("zone"));
		params.put("zoneGrp", request.getParameter("zoneGrp"));
		params.put("nbtZoneGrp", request.getParameter("nbtZoneGrp"));
		params.put("zoneType", request.getParameter("zoneType"));
		params.put("shareCd", request.getParameter("shareCd"));
		// jhing 04.23.2015
		params.put("shareType", request.getParameter("shareType"));
		params.put("acctTrtyType", request.getParameter("acctTrtyType"));
		
		Map<String, Object> fireCommAccumDtl = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(fireCommAccumDtl);
		
		return json;
	}
	
	public String getTrtyName(String commitAccumDistShare) throws SQLException{
		return this.gipiGenerateStatisticalReportsDAO.getTrtyName(commitAccumDistShare);
	}
	
	public JSONObject computeFireCATotals(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("asOfSw", request.getParameter("asOfSw"));
		params.put("zone", request.getParameter("zone"));
		params.put("zoneGrp", request.getParameter("zoneGrp"));
		params.put("nbtZoneGrp", request.getParameter("nbtZoneGrp"));
		params.put("zoneType", request.getParameter("zoneType"));
		params.put("shareCd", request.getParameter("shareCd"));
		// jhing 04.23.2015
		params.put("shareType", request.getParameter("shareType"));
		params.put("acctTrtyType", request.getParameter("acctTrtyType"));
		
		JSONObject json = new JSONObject(gipiGenerateStatisticalReportsDAO.computeFireCATotals(params));
		
		return json;
	}
	
	public Integer countFireStatExt(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		if ("by_zone".equals(request.getParameter("fireStat"))){
			params.put("tableName", "GIPI_FIRESTAT_EXTRACT");
		}else if ("by_tariff".equals(request.getParameter("fireStat"))){
			params.put("tableName", "GIXX_FIRESTAT_SUMMARY");
		}
		
		return this.gipiGenerateStatisticalReportsDAO.countFireStatExt(params);
	}
	
	public JSONObject getRiskProfileMaster(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRiskProfileMaster");
		params.put("userId", userId);
		params.put("ctrlLineCd", request.getParameter("ctrlLineCd"));
		params.put("issCd", request.getParameter("credBranch"));
		
		Map<String, Object> riskProfileMaster = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(riskProfileMaster);
		
		return json;
	}
	
	public JSONObject getRiskProfileDetail(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRiskProfileDetail");
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("allLineTag", request.getParameter("allLineTag"));
		params.put("paramDateRB", request.getParameter("paramDateRB"));	//start Gzelle 03252015
		params.put("inclExp", request.getParameter("inclExp"));
		params.put("inclEndt", request.getParameter("inclEndt"));
		params.put("credBranchParam", request.getParameter("credBranchParam"));		//end Gzelle 03252015
		
		Map<String, Object> riskProfileDetail = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(riskProfileDetail);
		
		return json;
	}
	
	public String chkRiskExtRecords(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("allLineTag", request.getParameter("allLineTag"));
		params.put("byTarf", request.getParameter("byTarf"));
				
		return gipiGenerateStatisticalReportsDAO.chkRiskExtRecords(params);
	}
	
	public Integer getTreatyCount(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("startingDate", request.getParameter("startingDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("byTarf", request.getParameter("byTarf"));
		params.put("userId", userId);
		
		return this.gipiGenerateStatisticalReportsDAO.getTreatyCount(params);
	}
	
	public String extractRiskProfile(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("allLineTag", request.getParameter("allLineTag"));
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("byTarf", request.getParameter("byTarf"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("inclEndt", request.getParameter("inclEndt"));
		params.put("inclExp", request.getParameter("inclExp"));
		params.put("userId", userId);
		
		return this.gipiGenerateStatisticalReportsDAO.extractRiskProfile(params);
	}
	
	public String saveRiskProfile(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException{
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("setRows", this.prepareGIPIRiskProfileForInsertUpdate(new JSONArray(objParams.getString("setRows"))));
		//params.put("delRows", this.prepareGIPIRiskProfileForDelete(new JSONArray(objParams.getString("delRows"))));
		
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("setRows"))));
		params.put("delRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("delRows"))));	
		params.put("detailSw", request.getParameter("detailSw"));
		params.put("userResponse", request.getParameter("userResponse"));//Gzelle 04012015
		params.put("isAddFromUpdate", request.getParameter("isAddFromUpdate"));//Gzelle 04072015
		params.put("userId", userId);
		
		return this.gipiGenerateStatisticalReportsDAO.saveRiskProfile(params);
	}

	@Override
	public String checkFireStat(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fireStat", request.getParameter("fireStat"));
		params.put("dateRb", request.getParameter("dateRb"));
		params.put("pDate", request.getParameter("pDate"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("busCd", Integer.parseInt(request.getParameter("busCd")));
		params.put("zone", request.getParameter("zone"));
		params.put("zoneType", request.getParameter("zoneType"));
		params.put("riskCnt", request.getParameter("riskCnt"));
		params.put("inclEndt", request.getParameter("inclEndt"));
		params.put("inclExp", request.getParameter("inclExp"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("userId", userId);
		
		params = this.gipiGenerateStatisticalReportsDAO.checkFireStat(params);
		
		return params.get("cnt").toString();
	}
	
	public String  valBeforeSave(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("allLineTag", request.getParameter("allLineTag"));
		params = gipiGenerateStatisticalReportsDAO.valBeforeSave(params);
		return (String) params.get("msg");
	}
	
	public String  valAddUpdRec(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("allLineTag", request.getParameter("allLineTag"));
		params = gipiGenerateStatisticalReportsDAO.valAddUpdRec(params);
		return (String) params.get("msg");
	}	

	@Override
	public Map<String, Object> validateBeforeExtract(HttpServletRequest request, String userId)
			throws SQLException { //edgar 04/27/2015 FULL WEB SR 4322
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fireStat", request.getParameter("fireStat"));
		params.put("dateRb", request.getParameter("dateRb"));
		params.put("pDate", request.getParameter("pDate"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("busCd", Integer.parseInt(request.getParameter("busCd")));
		params.put("zone", request.getParameter("zone"));
		params.put("zoneType", request.getParameter("zoneType"));
		params.put("riskCnt", request.getParameter("riskCnt"));
		params.put("inclEndt", request.getParameter("inclEndt"));
		params.put("inclExp", request.getParameter("inclExp"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("userId", userId);
		
		
		return this.gipiGenerateStatisticalReportsDAO.validateBeforeExtract(params);
	}
}
