package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
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
import com.geniisys.gicl.dao.GICLCatastrophicEventDAO;
import com.geniisys.gicl.entity.GICLCatDtl;
import com.geniisys.gicl.service.GICLCatastrophicEventService;

public class GICLCatastrophicEventServiceImpl implements GICLCatastrophicEventService {
	private GICLCatastrophicEventDAO giclCatastrophicEventDAO;
	
	public GICLCatastrophicEventDAO getGiclCatastrophicEventDAO() {
		return giclCatastrophicEventDAO;
	}

	public void setGiclCatastrophicEventDAO(GICLCatastrophicEventDAO giclCatastrophicEventDAO) {
		this.giclCatastrophicEventDAO = giclCatastrophicEventDAO;
	}
	
	@Override
	public JSONObject showCatastrophicEventInquiry(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showCatastrophicEventInquiry");
		params.put("selection", request.getParameter("selection"));
		params.put("catastrophicCd", request.getParameter("catastrophicCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("location", request.getParameter("location"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("calTotal", request.getParameter("calTotal")); //4-29-2016 SR-5417
		Map<String, Object> tbgCatastrophicEvent = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTbgCatastrophicEvent = new JSONObject(tbgCatastrophicEvent);
		request.setAttribute("jsonTbgCatastrophicEvent", jsonTbgCatastrophicEvent);
		return jsonTbgCatastrophicEvent;
	}

	@Override
	public Map<String, Object> validateGicls057Line(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lineName", request.getParameter("lineName"));
		return giclCatastrophicEventDAO.validateGicls057Line(params);
	}

	@Override
	public Map<String, Object> validateGicls057Catastrophy(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("catastrophicCd", request.getParameter("catastrophicCd"));
		params.put("catastrophicDesc", request.getParameter("catastrophicDesc"));
		return giclCatastrophicEventDAO.validateGicls057Catastrophy(params);
	}

	@Override
	public Map<String, Object> validateGicls057Branch(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("issName", request.getParameter("issName"));
		return giclCatastrophicEventDAO.validateGicls057Branch(params);
	}

	@Override
	public Map<String, Object> getUserParams(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return this.getGiclCatastrophicEventDAO().getUserParams(params);
	}

	@Override
	public Integer extractOsPdPerCat(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("catCd", request.getParameter("catCd").equals("") ? request.getParameter("catCd") : Integer.parseInt(request.getParameter("catCd")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("locationCd", request.getParameter("locationCd"));
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("riCd", request.getParameter("riCd").equals("") ? request.getParameter("riCd") : Integer.parseInt(request.getParameter("riCd")));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("osDateOption", request.getParameter("osDateOption").equals("") ? request.getParameter("osDateOption") : Integer.parseInt(request.getParameter("osDateOption")));
		params.put("pdDateOption", request.getParameter("pdDateOption").equals("") ? request.getParameter("pdDateOption") : Integer.parseInt(request.getParameter("pdDateOption")));
		return this.getGiclCatastrophicEventDAO().extractOsPdPerCat(params);
	}

	@Override
	public JSONObject valExtOsPdClmRecBefPrint(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		JSONObject json = new JSONObject(this.getGiclCatastrophicEventDAO().valExtOsPdClmRecBefPrint(params));
		return json;
	}

	@Override
	public JSONObject getGICLS056CatastrophicEvent(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS056CatastrophicEvent");
		params.put("userId", USER.getUserId());
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getGICLS056Details(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS056Details");
		params.put("userId", USER.getUserId());
		params.put("catCd", request.getParameter("catCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("pageSize", 5);
		
		System.out.println("getGICLS056Details PARAMS");
		System.out.println(params);
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getGICLS056ClaimList(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS056ClaimList");
		params.put("userId", USER.getUserId());
		
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("location", request.getParameter("location"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("searchType", request.getParameter("searchType"));
		
		System.out.println("getGICLS056ClaimList");
		System.out.println("PARAMS");
		System.out.println(params);
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getGICLS056ClaimListFi(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS056ClaimListFi");
		params.put("userId", USER.getUserId());
		
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("location", request.getParameter("location"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("searchType", request.getParameter("searchType"));
		
		System.out.println("getGICLS056ClaimListFi");
		System.out.println("PARAMS");
		System.out.println(params);
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public void gicls056UpdateDetails(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		
		//JSONObject obj = new JSONObject(request.getParameter("objParams"));
		//JSONArray arr = new JSONArray(obj.getString("setRows"));		
		String[] checkedClaims = request.getParameter("checkedClaims").split(","); 
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		for(int x = 0; x < checkedClaims.length; x++){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("claimId", checkedClaims[x]);
			map.put("catCd", request.getParameter("catCd"));
			map.put("userId", USER.getUserId());
			map.put("pAction", request.getParameter("pAction"));
			list.add(map);
		}
		
		/*for(int i = 0; i < arr.length(); i++){
			
			JSONObject rec = arr.getJSONObject(i);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("claimId", rec.getString("claimId"));
			map.put("catCd", request.getParameter("catCd"));
			map.put("userId", USER.getUserId());
			map.put("pAction", request.getParameter("pAction"));
			list.add(map);
		}*/
		
		this.giclCatastrophicEventDAO.gicls056UpdateDetails(list);		
	}

	@Override
	public void saveGicls056(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGicls056");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLCatDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLCatDtl.class));
		params.put("appUser", userId);
		this.giclCatastrophicEventDAO.saveGicls056(params);
	}

	@Override
	public String gicls056ValDelete(HttpServletRequest request)
			throws SQLException {
		String catCd = request.getParameter("catCd");
		return this.giclCatastrophicEventDAO.gicls056ValDelete(catCd);
	}

	@Override
	public void gicls056UpdateDetailsAll(HttpServletRequest request, String userId)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls056UpdateDetailsAll");
		params.put("userId", userId);
		
		params.put("catCd", request.getParameter("catCd"));
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("location", request.getParameter("location"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("searchType", request.getParameter("searchType"));
		
		System.out.println("gicls056UpdateDetailsAll");
		System.out.println("PARAMS");
		System.out.println(params);
		
		this.giclCatastrophicEventDAO.gicls056UpdateDetailsAll(params);
	}

	@Override
	public void gicls056RemoveAll(HttpServletRequest request, String userId)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls056RemoveAll");
		params.put("userId", userId);
		params.put("catCd", request.getParameter("catCd"));
		this.giclCatastrophicEventDAO.gicls056RemoveAll(params);
	}

	@Override
	public void gicls056ValAddRec(HttpServletRequest request)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls056ValAddRec");
		params.put("catCd", request.getParameter("catCd"));
		params.put("catDesc", request.getParameter("catDesc"));
		this.giclCatastrophicEventDAO.gicls056ValAddRec(params);
		
	}

	@Override
	public String gicls056GetClaimNos(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls056GetClaimNos");
		params.put("userId", userId);
		params.put("catCd", request.getParameter("catCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		
		return (String) giclCatastrophicEventDAO.gicls056GetClaimNos(params);
	}

	@Override
	public String gicls056GetClaimNosList(HttpServletRequest request,
			String userId) throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls056GetClaimNosList");
		params.put("userId", userId);
		
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("location", request.getParameter("location"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("searchType", request.getParameter("searchType"));
		
		return (String) giclCatastrophicEventDAO.gicls056GetClaimNosList(params);
	}

	@Override
	public String gicls056GetClaimNosListFi(HttpServletRequest request,
			String userId) throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls056GetClaimNosListFi");
		params.put("userId", userId);
		
		params.put("lossCatCd", request.getParameter("lossCatCd"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("location", request.getParameter("location"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("searchType", request.getParameter("searchType"));
		
		return (String) giclCatastrophicEventDAO.gicls056GetClaimNosListFi(params);
	}

	@Override
	public JSONObject gicls056GetDspAmt(HttpServletRequest request, String userId)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("catCd", request.getParameter("catCd"));
		params.put("userId", userId);
		return new JSONObject(giclCatastrophicEventDAO.gicls056GetDspAmt(params));
	}

}
