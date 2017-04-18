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
import com.geniisys.gicl.dao.GICLCasualtyDtlDAO;
import com.geniisys.gicl.entity.GICLCasualtyDtl;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLCasualtyDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLCasualtyDtlServiceImpl implements GICLCasualtyDtlService{
	
	private GICLCasualtyDtlDAO giclCasualtyDtlDAO;
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLCasualtyDtlService#getGiclCasualtyDtlGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclCasualtyDtlGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclCasualtyDtlGrid");
		params.put("pageSize", 5);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject ((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclCasualtyDtl", grid);
		request.setAttribute("object", grid);
		request.setAttribute("showClaimStat", "Y");		
	}


	public void setGiclCasualtyDtlDAO(GICLCasualtyDtlDAO giclCasualtyDtlDAO) {
		this.giclCasualtyDtlDAO = giclCasualtyDtlDAO;
	}


	public GICLCasualtyDtlDAO getGiclCasualtyDtlDAO() {
		return giclCasualtyDtlDAO;
	}


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
		params.put("from", request.getParameter("from"));
		params.put("to", request.getParameter("to"));
		params = this.giclCasualtyDtlDAO.validateClmItemNo(params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLCasualtyDtl>) params.get("row")) :"[]");
		return new JSONObject(params).toString();
	}


	@Override
	public String saveClmItemCasualty(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		params.put("groupedItemNo", request.getParameter("groupedItemNo")); // added by: Nica 11.05.2013 - to save grouped items
		params.put("giclCasualtyDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemSetRows")), USER.getUserId(), GICLCasualtyDtl.class));
		params.put("giclCasualtyDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemDelRows")), USER.getUserId(), GICLCasualtyDtl.class));
		params.put("giclItemPerilSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilSetRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemPerilDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilDelRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclPersonnelSetRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("personnelSetRows"))));
		params.put("giclPersonnelDelRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("personnelDelRows"))));
	
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giclCasualtyDtlDAO.saveClmItemCasualty(params))).toString();
	}
	
	


	@Override
	public void getPersonnelGrid(HttpServletRequest request, GIISUser USER)
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
		params.put("from", request.getParameter("from"));
		params.put("to", request.getParameter("to"));
		params = (Map<String, Object>) this.giclCasualtyDtlDAO.getPersonnelList((HashMap<String, Object>) params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLCasualtyDtl>) params.get("row")) :"[]");	
		
	}


/*	@Override
	public String savePersonnel(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		SimpleDateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		String sample = DateFormat.getInstance().format(new Date(0));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId",USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo",request.getParameter("itemNo"));
		params.put("personnelNo",request.getParameter("personnelNo"));
		params.put("name",request.getParameter("name"));
		params.put("includeTag",request.getParameter("includeTag"));
		params.put("lastUpdate",request.getParameter("lastUpdate") == null ? null : new Date(0));
		params.put("capacityCd", request.getParameter("capacityCd"));
		params.put("amountCovered",request.getParameter("amountCovered"));
		
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giclCasualtyDtlDAO.savePersonnel(params))).toString();
	}*/


	private DateFormat nvl(String parameter, java.util.Date parse) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public String getCasualtyGroupedItemTitle(Map<String, Integer> params)
			throws SQLException {
		return this.getCasualtyGroupedItemTitle(params);
	}


	@Override
	public Map<String, Object> validateGroupItemNo(Map<String, Object> params)
			throws SQLException {
	
		return getGiclCasualtyDtlDAO().validateGroupItemNo(params);
	}


	@Override
	public Map<String, Object> validatePersonnelNo(Map<String, Object> params)
			throws SQLException {
		return getGiclCasualtyDtlDAO().validatePersonnelNo(params);
	}
}
