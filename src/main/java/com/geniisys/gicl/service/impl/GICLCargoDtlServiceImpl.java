/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLCargoDtlServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 28, 2011
	Description: 
*/


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
import com.geniisys.gicl.dao.GICLCargoDtlDAO;
import com.geniisys.gicl.entity.GICLCargoDtl;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLCargoDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLCargoDtlServiceImpl implements GICLCargoDtlService{
	private GICLCargoDtlDAO giclCargoDtlDAO;
	
	
	public GICLCargoDtlDAO getGiclCargoDtlDAO() {
		return giclCargoDtlDAO;
	}


	public void setGiclCargoDtlDAO(GICLCargoDtlDAO giclCargoDtlDAO) {
		this.giclCargoDtlDAO = giclCargoDtlDAO;
	}


	@Override
	public void getGICLCargoDtlGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getCargoItemDtl");
		params.put("pageSize", 5);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclCargoDtlGrid", grid);
		request.setAttribute("giclCargoDtl", grid);
		request.setAttribute("showClaimStat", "Y");
	}


	@SuppressWarnings("unchecked")
	@Override
	public String validateClmItemNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
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
		params= this.getGiclCargoDtlDAO().validateClmItemNo(params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLCargoDtl>) params.get("row")) :"[]");
		return new JSONObject(params).toString();
	}


	@Override
	public String saveClmItemMarineCargo(HttpServletRequest request,
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
		params.put("giclCargoDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemSetRows")), USER.getUserId(), GICLCargoDtl.class));
		params.put("giclCargoDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemDelRows")), USER.getUserId(), GICLCargoDtl.class));
		params.put("giclItemPerilSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilSetRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemPerilDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilDelRows")), USER.getUserId(), GICLItemPeril.class));
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.getGiclCargoDtlDAO().saveClmItemMarineCargo(params))).toString();
	}

}
