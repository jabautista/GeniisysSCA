package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLAccidentDtlDAO;
import com.geniisys.gicl.entity.GICLAccidentDtl;
import com.geniisys.gicl.entity.GICLBeneficiary;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLAccidentDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLAccidentDtlServiceImpl implements GICLAccidentDtlService {
	private GICLAccidentDtlDAO giclAccidentDtlDAO;
	

	public void setGiclAccidentDtlDAO(GICLAccidentDtlDAO giclAccidentDtlDAO) {
		this.giclAccidentDtlDAO = giclAccidentDtlDAO;
	}

	public GICLAccidentDtlDAO getGiclAccidentDtlDAO() {
		return giclAccidentDtlDAO;
	}

	@Override
	public void getGICLAccidentDtlGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAccidentItemDtl");
		params.put("pageSize", 5);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclAccidentDtlGrid", grid);
		request.setAttribute("showClaimStat", "Y");
	}

	@SuppressWarnings("unchecked")
	@Override
	public String validateClmItemNo(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>(); 
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		params.put("inceptDate", request.getParameter("inceptDate") == null || "".equals(request.getParameter("inceptDate")) ? null :date.parse(request.getParameter("inceptDate")));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("from", request.getParameter("from"));
		params.put("to", request.getParameter("to"));
		params = this.getGiclAccidentDtlDAO().validateClmItemNo(params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLAccidentDtl>) params.get("row")) :"[]");
		params.put("c017b", params.get("c017b") != null ? StringFormatter.escapeHTMLInList((List<GICLBeneficiary>) params.get("c017b")) :"[]");
		return new JSONObject(params).toString();
	}

	@Override
	public String saveClmItemAccident(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		System.out.println("String parameters: "+request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("giclAccidentDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemSetRows")), USER.getUserId(), GICLAccidentDtl.class));
		params.put("giclAccidentDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemDelRows")), USER.getUserId(), GICLAccidentDtl.class));
		params.put("giclItemPerilSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilSetRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemPerilDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilDelRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemBenSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("beneficiarySetRows")), USER.getUserId(), GICLBeneficiary.class));
		params.put("giclItemBenDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("beneficiaryDelRows")), USER.getUserId(), GICLBeneficiary.class));
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.getGiclAccidentDtlDAO().saveClmItemAccident(params))).toString();
	}

	@Override
	public void getBeneficiaryDtlGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getItemBeneficiaryDtl");
		params.put("pageSize", 5);
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclBeneficiaryDtlGrid", grid);
		
	}

	@Override
	public void getClmAvailmentsGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getItemClaimAvailments");
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("noOfDays", request.getParameter("noOfDays"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclAvailmentsGrid", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public String getGroupedItemTitle(Map<String, Integer> params)
			throws SQLException {
		return this.giclAccidentDtlDAO.getGroupedItemTitle(params);
	}

	@Override
	//modified by kenneth SR20950 11.12.2015
	public String getAcBaseAmount(HttpServletRequest request)
			throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		return this.getGiclAccidentDtlDAO().getAcBaseAmount(params);
	}

}
