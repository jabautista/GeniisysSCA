package com.geniisys.giuts.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giuts.dao.SpoilageReinstatementDAO;
import com.geniisys.giuts.service.SpoilageReinstatementService;

public class SpoilageReinstatementServiceImpl implements SpoilageReinstatementService{

	private SpoilageReinstatementDAO spoilageReinstatementDAO; 
	
	public SpoilageReinstatementDAO getSpoilageReinstatementDAO(){
		return spoilageReinstatementDAO;
	}
	
	public void setSpoilageReinstatementDAO(SpoilageReinstatementDAO spoilageReinstatementDAO){
		this.spoilageReinstatementDAO = spoilageReinstatementDAO;
	}
	
	@Override
	public String whenNewFormInstanceGiuts003(HttpServletRequest request) throws SQLException {
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().whenNewFormInstanceGiuts003());
		return result.toString();
	}

	@Override
	public String spoilPolicyGiuts003(HttpServletRequest request, String userId) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("endtSeqNo", request.getParameter("endtSeqNo") == null || request.getParameter("endtSeqNo") == "" ? null : Integer.parseInt(request.getParameter("endtSeqNo")));
		params.put("effDate", request.getParameter("effDate") == null || request.getParameter("effDate").equals("") ? null : df.parse(request.getParameter("effDate")));
		params.put("acctEntDate", request.getParameter("acctEntDate") == null || request.getParameter("acctEntDate").equals("") ? null : df.parse(request.getParameter("acctEntDate")));
		params.put("spldFlag", request.getParameter("spldFlag"));
		params.put("spoilCd", request.getParameter("spoilCd"));
		params.put("requireReason", request.getParameter("requireReason"));
		params.put("polFlag", request.getParameter("polFlag"));
		params.put("userId", userId);
		System.out.println("GIUTS003 Spoil policy param: "+ params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().spoilPolicyGiuts003(params));
		return result.toString();
	}

	@Override
	public String unspoilPolicyGiuts003(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("spldFlag", request.getParameter("spldFlag"));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		System.out.println("GIUTS003 Unspoil policy param: "+ params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().unspoilPolicyGiuts003(params));
		return result.toString();
	}

	@Override
	public String postPolicyGiuts003(HttpServletRequest request, String userId) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("effDate", request.getParameter("effDate") == null || request.getParameter("effDate").equals("") ? null : df.parse(request.getParameter("effDate")));
		params.put("acctEntDate", request.getParameter("acctEntDate") == null || request.getParameter("acctEntDate").equals("") ? null : df.parse(request.getParameter("acctEntDate")));
		params.put("spldFlag", request.getParameter("spldFlag"));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate") == null || request.getParameter("endtExpiryDate").equals("") ? null : df.parse(request.getParameter("endtExpiryDate")));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent") == null || request.getParameter("shortRtPercent").equals("") ? null : new BigDecimal(request.getParameter("shortRtPercent")));
		params.put("userId", userId);
		System.out.println("GIUTS003 Post policy param: "+ params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().postPolicyGiuts003(params));
		return result.toString();
	}

	@Override
	public String postPolicy2Giuts003(HttpServletRequest request, String userId) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("effDate", request.getParameter("effDate") == null || request.getParameter("effDate").equals("") ? null : df.parse(request.getParameter("effDate")));
		params.put("acctEntDate", request.getParameter("acctEntDate") == null || request.getParameter("acctEntDate").equals("") ? null : df.parse(request.getParameter("acctEntDate")));
		params.put("spldFlag", request.getParameter("spldFlag"));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate") == null || request.getParameter("endtExpiryDate").equals("") ? null : df.parse(request.getParameter("endtExpiryDate")));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent") == null || request.getParameter("shortRtPercent").equals("") ? null : new BigDecimal(request.getParameter("shortRtPercent")));
		params.put("userId", userId);
		params.put("alert", request.getParameter("alert"));
		System.out.println("GIUTS003 Post policy2 param: "+ params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().postPolicy2Giuts003(params));
		return result.toString();
	}
	
	

	@Override
	public Map<String, Object> whenNewFormGiuts003a() throws SQLException {
		return this.spoilageReinstatementDAO.whenNewFormGiuts003a();
	}


	@Override
	public String getPackPolicyDetailsGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		System.out.println("getPackPolicyDetailsGiuts003a params: "+params.toString());
		JSONObject result = new JSONObject(this.spoilageReinstatementDAO.getPackPolicyDetailsGiuts003a(params));
		
		return result.toString();
	}
	
	@Override
	public String chkPackPolicyForSpoilageGiuts003a(HttpServletRequest request) throws SQLException { //changed by kenneth 07132015 SR 4753 
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packPolicyId", Integer.parseInt(request.getParameter("packPolicyId")));
		params.put("issCd", request.getParameter("issCd"));
		System.out.println(params.toString());
		
		this.spoilageReinstatementDAO.chkPackPolicyForSpoilageGiuts003a(params);
		return params.get("pMessage") != null ? params.get("pMessage").toString() : ""; //apollo cruz 11.13.2015 sr#20906
	}

	@Override
	public String spoilPackGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("spoilCd", request.getParameter("spoilCd") == "" ? null : request.getParameter("spoilCd"));
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("spldFlag", request.getParameter("spldFlag"));		
		JSONObject result = new JSONObject(this.spoilageReinstatementDAO.spoilPackGiuts003a(params));
		
		return result.toString();
	}

	@Override
	public String unspoilPackGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("issCd", request.getParameter("spoilCd"));
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("spldFlag", request.getParameter("spldFlag"));
		JSONObject result = new JSONObject(this.spoilageReinstatementDAO.unspoilPackGiuts003a(params));
		
		return result.toString();
	}

	
	@Override
	public String chkPackPolicyPostGiuts003a(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("packPolicyId", Integer.parseInt(request.getParameter("packPolicyId")));
		params.put("userId", USER.getUserId());
		params.put("continueSpoilage", request.getParameter("continueSpoilage"));
		params.put("start", Integer.parseInt(request.getParameter("start")));
		
		JSONObject result = new JSONObject(this.spoilageReinstatementDAO.chkPackPolicyPostGiuts003a(params));
		System.out.println("chkPackPolicyPostGiuts003a after: "+result.toString());
		return result.toString();
	}

	@Override
	public String whenNewFormInstanceGIUTS028(HttpServletRequest request)
			throws SQLException {
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().whenNewFormInstanceGIUTS028());
		return result.toString();
	}

	@Override
	public String validateGIUTS028EndtRecord(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("policyId", request.getParameter("policyId"));
		System.out.println("GIUTS028 Validate of Endt Record Parameters...." + params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().validateGIUTS028EndtRecord(params));
		return result.toString();
	}

	@Override
	public void validateGIUTS028CheckPaid(Map<String, Object> params)
			throws SQLException {
		this.getSpoilageReinstatementDAO().validateGIUTS028CheckPaid(params);
	}

	@Override
	public void validateGIUTS028CheckRIPayt(Map<String, Object> params)
			throws SQLException {
		this.getSpoilageReinstatementDAO().validateGIUTS028CheckRIPayt(params);
	}

	@Override
	public void validateGIUTS028RenewPol(Map<String, Object> params)
			throws SQLException {
		this.getSpoilageReinstatementDAO().validateGIUTS028RenewPol(params);
	}

	@Override
	public void validateGIUTS028CheckAcctEntDate(Map<String, Object> params)
			throws SQLException {
		this.getSpoilageReinstatementDAO().validateGIUTS028CheckAcctEntDate(params);
	}

	@Override
	public String checkMrn(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		System.out.println("GIUTS028 Check Marine Record Parameters...." + params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().checkMrn(params));
		return result.toString();
	}

	@Override
	public String checkEndtOnProcess(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		System.out.println("GIUTS028 Check if there is Endorsement being processed...." + params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().checkEndtOnProcess(params));
		return result.toString();
	}

	@Override
	public String processGIUTS028Reinstate(HttpServletRequest request,
			String userId) throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("vCancelPolicy", Integer.parseInt(request.getParameter("vCancelPolicy")));
		params.put("oldPolFlag", request.getParameter("oldPolFlag"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("vMaxEndt", Integer.parseInt(request.getParameter("vMaxEndt")));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		System.out.println("Reinstatement Parameters......." + params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().processGIUTS028Reinstate(params)); 
		return result.toString();
	}
	
	/* benjo 09.03.2015 UW-SPECS-2015-080 */
	@Override
	public String checkOrigRenewStatus(HttpServletRequest request)
			throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().checkOrigRenewStatus(params));
		return result.toString();
	}

	@Override
	public String whenNewFormInstanceGIUTS028A(HttpServletRequest request)
			throws SQLException {
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().whenNewFormInstanceGIUTS028A());
		return result.toString();
	}

	@Override
	public String reinstatePackageGIUTS028A(HttpServletRequest request,
			String userId) throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("packPolicyId", Integer.parseInt(request.getParameter("packPolicyId")));
		System.out.println("Package Reinstatement Validation Parameters......." + params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().reinstatePackageGIUTS028A(params)); 
		return result.toString();
	}

	@Override
	public String postGIUTS028AReinstate(HttpServletRequest request,
			String userId) throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("packPolicyId", Integer.parseInt(request.getParameter("packPolicyId")));
		System.out.println("Package Reinstatement Posting Parameters......." + params);
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().postGIUTS028AReinstate(params)); 
		return result.toString();
	}

	@Override
	public String validateSpoilCdGiuts003(HttpServletRequest request) throws SQLException {
		String spoilCd = request.getParameter("spoilCd");
		return this.getSpoilageReinstatementDAO().validateSpoilCdGiuts003(spoilCd);
	}

	/* benjo 09.03.2015 UW-SPECS-2015-080 */
	@Override
	public String checkPackOrigRenewStatus(HttpServletRequest request)
			throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("packPolicyId", Integer.parseInt(request.getParameter("packPolicyId")));
		JSONObject result = new JSONObject(this.getSpoilageReinstatementDAO().checkPackOrigRenewStatus(params));
		return result.toString();
	}
}
