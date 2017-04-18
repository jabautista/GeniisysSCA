package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.gicl.dao.GICLBrdrxClmsRegisterDAO;
import com.geniisys.gicl.service.GICLBrdrxClmsRegisterService;

public class GICLBrdrxClmsRegisterServiceImpl implements GICLBrdrxClmsRegisterService{

	private GICLBrdrxClmsRegisterDAO giclBrdrxClmsRegisterDAO;

	public GICLBrdrxClmsRegisterDAO getGiclBrdrxClmsRegisterDAO() {
		return giclBrdrxClmsRegisterDAO;
	}

	public void setGiclBrdrxClmsRegisterDAO(GICLBrdrxClmsRegisterDAO giclBrdrxClmsRegisterDAO) {
		this.giclBrdrxClmsRegisterDAO = giclBrdrxClmsRegisterDAO;
	}

	@Override
	public String whenNewFormInstanceGicls202(HttpServletRequest request) throws SQLException {
		JSONObject result = new JSONObject(this.getGiclBrdrxClmsRegisterDAO().whenNewFormInstanceGicls202());
		return result.toString();
	}
	
	@Override
	public String whenNewBlockE010Gicls202(HttpServletRequest request, String userId) throws SQLException {
		JSONObject result = new JSONObject(this.getGiclBrdrxClmsRegisterDAO().whenNewBlockE010Gicls202(userId)); 
		return result.toString();
	}
	
	@Override
	public String getPolicyNumberGicls202(HttpServletRequest request, String userId) throws SQLException {		
		JSONObject result = new JSONObject(this.getGiclBrdrxClmsRegisterDAO().getPolicyNumberGicls202(userId)); 
		return result.toString();
	}

	@Override
	public String extractGicls202(HttpServletRequest request, String userId) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("repName", Integer.parseInt(request.getParameter("repName")));
		params.put("brdrxType", Integer.parseInt(request.getParameter("brdrxType")));
		params.put("brdrxDateOption", Integer.parseInt(request.getParameter("brdrxDateOption")));
		params.put("brdrxOption", Integer.parseInt(request.getParameter("brdrxOption")));
		params.put("dspGrossTag", Integer.parseInt(request.getParameter("dspGrossTag")));
		params.put("paidDateOption", Integer.parseInt(request.getParameter("paidDateOption")));
		params.put("perBuss", Integer.parseInt(request.getParameter("perBuss")));
		params.put("perIssource", Integer.parseInt(request.getParameter("perIssource")));
		params.put("perLineSubline", Integer.parseInt(request.getParameter("perLineSubline")));
		params.put("perPolicy", Integer.parseInt(request.getParameter("perPolicy")));
		params.put("perEnrollee", Integer.parseInt(request.getParameter("perEnrollee")));
		params.put("perLine", Integer.parseInt(request.getParameter("perLine")));
		params.put("perIss", Integer.parseInt(request.getParameter("perIss")));
		params.put("perIntermediary", Integer.parseInt(request.getParameter("perIntermediary")));
		params.put("perLossCat", Integer.parseInt(request.getParameter("perLossCat")));
		params.put("dspFromDate", request.getParameter("dspFromDate") == null || request.getParameter("dspFromDate") == "" ? null : df.parse(request.getParameter("dspFromDate")));
		params.put("dspToDate", request.getParameter("dspToDate") == null || request.getParameter("dspToDate") == "" ? null : df.parse(request.getParameter("dspToDate")));
		params.put("dspAsOfDate", request.getParameter("dspAsOfDate") == null || request.getParameter("dspAsOfDate") == "" ? null : df.parse(request.getParameter("dspAsOfDate")));
		params.put("branchOption", Integer.parseInt(request.getParameter("branchOption")));
		params.put("regButton", Integer.parseInt(request.getParameter("regButton")));
		params.put("netRcvryChkbx", request.getParameter("netRcvryChkbx"));
		params.put("dspRcvryFromDate", request.getParameter("dspRcvryFromDate") == null || request.getParameter("dspRcvryFromDate") == "" ? null : df.parse(request.getParameter("dspRcvryFromDate")));
		params.put("dspRcvryToDate", request.getParameter("dspRcvryToDate") == null || request.getParameter("dspRcvryToDate") == "" ? null : df.parse(request.getParameter("dspRcvryToDate")));
		params.put("dateOption", Integer.parseInt(request.getParameter("dateOption")));
		params.put("dspLineCd", request.getParameter("dspLineCd"));
		params.put("dspSublineCd", request.getParameter("dspSublineCd"));
		params.put("dspIssCd", request.getParameter("dspIssCd"));
		params.put("dspLossCatCd", request.getParameter("dspLossCatCd"));
		params.put("dspPerilCd", request.getParameter("dspPerilCd") == null || request.getParameter("dspPerilCd") == "" ? null : Integer.parseInt(request.getParameter("dspPerilCd")));
		params.put("dspIntmNo", request.getParameter("dspIntmNo") == null || request.getParameter("dspIntmNo") == "" ? null : Integer.parseInt(request.getParameter("dspIntmNo")));
		params.put("dspLineCd2", request.getParameter("dspLineCd2"));
		params.put("dspSublineCd2", request.getParameter("dspSublineCd2"));
		params.put("dspIssCd2", request.getParameter("dspIssCd2"));
		params.put("dspIssueYy", request.getParameter("dspIssueYy") == null || request.getParameter("dspIssueYy") == "" ? null : Integer.parseInt(request.getParameter("dspIssueYy")));
		params.put("dspPolSeqNo", request.getParameter("dspPolSeqNo") == null || request.getParameter("dspPolSeqNo") == "" ? null : Integer.parseInt(request.getParameter("dspPolSeqNo")));
		params.put("dspRenewNo", request.getParameter("dspRenewNo") == null || request.getParameter("dspRenewNo") == "" ? null : Integer.parseInt(request.getParameter("dspRenewNo")));
		params.put("dspEnrollee", request.getParameter("dspEnrollee"));
		params.put("dspControlType", request.getParameter("dspControlType") == null || request.getParameter("dspControlType") == "" ? null : Integer.parseInt(request.getParameter("dspControlType")));
		params.put("dspControlNumber", request.getParameter("dspControlNumber"));
		Integer count = (Integer) this.getGiclBrdrxClmsRegisterDAO().extractGicls202(params); 
		return count.toString();
	}
	
	@Override
	public String validateLineCd2GIcls202(HttpServletRequest request) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd2", request.getParameter("lineCd2"));
		params.put("issCd2", request.getParameter("issCd2"));
		return this.getGiclBrdrxClmsRegisterDAO().validateLineCd2GIcls202(params);
	}

	@Override
	public String validateSublineCd2Gicls202(HttpServletRequest request) throws SQLException{
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd2", request.getParameter("lineCd2"));
		params.put("sublineCd2", request.getParameter("sublineCd2"));
		return this.getGiclBrdrxClmsRegisterDAO().validateSublineCd2Gicls202(params);
	}
	
	@Override
	public String validateIssCd2Gicls202(HttpServletRequest request) throws SQLException{
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd2", request.getParameter("lineCd2"));
		params.put("issCd2", request.getParameter("issCd2"));
		return this.getGiclBrdrxClmsRegisterDAO().validateIssCd2Gicls202(params);
	}

	@Override
	public String validateLineCdGIcls202(HttpServletRequest request) throws SQLException {
		String lineCd = request.getParameter("lineCd");
		return this.getGiclBrdrxClmsRegisterDAO().validateLineCdGicls202(lineCd);
	}

	@Override
	public String validateSublineCdGicls202(HttpServletRequest request) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.getGiclBrdrxClmsRegisterDAO().validateSublineCdGicls202(params);
	}

	@Override
	public String validateIssCdGicls202(HttpServletRequest request) throws SQLException {
		String issCd = request.getParameter("issCd");
		return this.getGiclBrdrxClmsRegisterDAO().validateIssCdGicls202(issCd);
	}

	@Override
	public String validateLossCatCdGicls202(HttpServletRequest request) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		return this.getGiclBrdrxClmsRegisterDAO().validateLossCatCdGicls202(params);
	}

	@Override
	public String validatePerilCdGicls202(HttpServletRequest request) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd")));
		return this.getGiclBrdrxClmsRegisterDAO().validatePerilCdGicls202(params);
	}

	@Override
	public String validateIntmNoGicls202(HttpServletRequest request) throws SQLException {
		//Integer intmNo = request.getParameter("intmNo") == "" || request.getParameter("intmNo") == null ? null : Integer.parseInt(request.getParameter("intmNo"));
		BigDecimal intmNo = request.getParameter("intmNo") == "" || request.getParameter("intmNo") == null ? null : new BigDecimal(request.getParameter("intmNo"));
		return this.getGiclBrdrxClmsRegisterDAO().validateIntmNoGicls202(intmNo);
	}
	
	@Override
	public String validateControlTypeCdGicls202(HttpServletRequest request) throws SQLException {
		Integer controlTypeCd = request.getParameter("controlTypeCd") == "" || request.getParameter("controlTypeCd") == null ? null : Integer.parseInt(request.getParameter("controlTypeCd"));
		return this.getGiclBrdrxClmsRegisterDAO().validateControlTypeCdGicls202(controlTypeCd);
	}

	@Override
	public String printGicls202(HttpServletRequest request, String userId) throws SQLException {
		Integer repName = Integer.parseInt(request.getParameter("repName")); 
		JSONObject result = new JSONObject(this.getGiclBrdrxClmsRegisterDAO().printGicls202(repName, userId)); 
		return result.toString();
	}
}
