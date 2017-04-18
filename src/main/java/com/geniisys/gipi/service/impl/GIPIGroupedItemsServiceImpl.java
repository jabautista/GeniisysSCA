package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIGroupedItemsDAO;
import com.geniisys.gipi.entity.GIPIDeductibles;
import com.geniisys.gipi.entity.GIPIGroupedItems;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIGroupedItemsService;
import com.seer.framework.util.StringFormatter;

public class GIPIGroupedItemsServiceImpl implements GIPIGroupedItemsService {

	private GIPIGroupedItemsDAO gipiGroupedItemsDAO;

	public GIPIGroupedItemsDAO getGipiGroupedItemsDAO() {
		return gipiGroupedItemsDAO;
	}

	public void setGipiGroupedItemsDAO(GIPIGroupedItemsDAO gipiGroupedItemsDAO) {
		this.gipiGroupedItemsDAO = gipiGroupedItemsDAO;
	}

	@Override
	public List<GIPIGroupedItems> getGIPIGroupedItemsForEndt(
			Map<String, Object> params) throws SQLException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		
		params.remove("request");
		
		return this.getGipiGroupedItemsDAO().getGIPIGroupedItemsEndt(params);
	}

	@Override
	public String checkIfGroupItemIsZeroOutOrNegated(Map<String, Object> params)
			throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject((String) params.get("parameters"));		
		
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas(new JSONObject(objParameters.getString("gipiWPolbas")));		
		GIPIWItem gipiWItem = new GIPIWItem(new JSONObject(objParameters.getString("gipiWItem")));
		GIPIWGroupedItems gipiWGroupedItems = new GIPIWGroupedItems(new JSONObject(objParameters.getString("gipiWGroupedItems")));
		
		DateFormat formatter = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("lineCd", gipiWPolbas.getLineCd());
		paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
		paramMap.put("issCd", gipiWPolbas.getIssCd());
		paramMap.put("issueYy", gipiWPolbas.getIssueYy());
		paramMap.put("polSeqNo", gipiWPolbas.getPolSeqNo());
		paramMap.put("renewNo", gipiWPolbas.getRenewNo());
		paramMap.put("effDate", formatter.format(gipiWPolbas.getEffDate()));
		paramMap.put("itemNo", gipiWItem.getItemNo());
		paramMap.put("itemFromDate", gipiWItem.getFromDate() == null ? null : formatter.format(gipiWItem.getFromDate()));
		paramMap.put("groupedItemNo", gipiWGroupedItems.getGroupedItemNo());
		paramMap.put("grpFromDate", gipiWGroupedItems.getFromDate() == null ? null : formatter.format(gipiWGroupedItems.getFromDate()));		
		
		return this.getGipiGroupedItemsDAO().checkIfGroupItemIsZeroOutOrNegated(paramMap);
	}

	@Override
	public String checkIfPrincipalEnrollee(Map<String, Object> params)
			throws SQLException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		
		params.remove("request");
		
		return this.getGipiGroupedItemsDAO().checkIfPrincipalEnrollee(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCasualtyGroupedItems(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIGroupedItems> casualtyGroupedItemList = this.getGipiGroupedItemsDAO().getCasualtyGroupedItems(params); 
		params.put("rows", new JSONArray((List<GIPIDeductibles>)StringFormatter.escapeHTMLInList(casualtyGroupedItemList)));
		grid.setNoOfPages(casualtyGroupedItemList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public JSONObject getAccidentGroupedItems(HttpServletRequest request) throws SQLException, JSONException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAccidentGroupedItems");
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
		Map<String, Object> groupedItemList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(groupedItemList);
	}

	@Override
	public JSONObject showGipis212(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis212GroupedItems");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("policyId", request.getParameter("policyId"));
		
		Map<String, Object> gipiGroupedItemList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(gipiGroupedItemList);
	}

	@Override
	public JSONObject showGipis212GroupedItemDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis212GroupedItemDtl");
		params.put("policyId", request.getParameter("policyId"));
		params.put("groupedItemTitle", request.getParameter("groupedItemTitle"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo")); //added by robert SR 5157 12.22.15 
		params.put("itemNo", request.getParameter("itemNo")); //added by robert SR 5157 12.22.15 
		Map<String, Object> gipiGroupedItemDtlList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(gipiGroupedItemDtlList);
	}

	@Override
	public JSONObject getCoverageDtls(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCoverageDtls");
		params.put("policyId", request.getParameter("policyId"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		
		Map<String, Object> coverageDtls = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(coverageDtls);
	}	
}
