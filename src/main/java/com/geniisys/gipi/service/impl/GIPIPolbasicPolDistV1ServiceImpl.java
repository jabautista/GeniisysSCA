package com.geniisys.gipi.service.impl;


import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.controllers.GIPIPolbasicPolDistV1Controller;
import com.geniisys.gipi.dao.GIPIPolbasicPolDistV1DAO;
import com.geniisys.gipi.entity.GIPIPolbasicPolDistV1;
import com.geniisys.gipi.service.GIPIPolbasicPolDistV1Service;
import com.seer.framework.util.StringFormatter;

public class GIPIPolbasicPolDistV1ServiceImpl implements GIPIPolbasicPolDistV1Service {

	private GIPIPolbasicPolDistV1DAO gipiPolbasicPolDistV1DAO;
	
	public void setGipiPolbasicPolDistV1DAO(GIPIPolbasicPolDistV1DAO gipiPolbasicPolDistV1DAO) {
		this.gipiPolbasicPolDistV1DAO = gipiPolbasicPolDistV1DAO;
	}

	public GIPIPolbasicPolDistV1DAO getGipiPolbasicPolDistV1DAO() {
		return gipiPolbasicPolDistV1DAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGIPIPolbasicPolDistV1List(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareGIPIPolbasicPolDistV1Filter((String) params.get("filter")));
		List<GIPIPolbasicPolDistV1> list = this.getGipiPolbasicPolDistV1DAO().getGIPIPolbasicPolDistV1List(params);
		params.put("rows", new JSONArray((List<GIPIPolbasicPolDistV1>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}
	
	private GIPIPolbasicPolDistV1 prepareGIPIPolbasicPolDistV1Filter(String filter) throws JSONException{
		GIPIPolbasicPolDistV1 gipiPolbasicPolDistV1 = new GIPIPolbasicPolDistV1();
		JSONObject jsonFilter = null;
		
		if(null == filter){
			jsonFilter = new JSONObject();
		}else{
			jsonFilter = new JSONObject(filter);
		}
		
		gipiPolbasicPolDistV1.setLineCd(jsonFilter.isNull("lineCd") ? "" : jsonFilter.getString("lineCd"));
		gipiPolbasicPolDistV1.setSublineCd(jsonFilter.isNull("sublineCd") ? "" : jsonFilter.getString("sublineCd"));
		gipiPolbasicPolDistV1.setIssCd(jsonFilter.isNull("issCd") ? "" : jsonFilter.getString("issCd"));
		gipiPolbasicPolDistV1.setIssueYy(jsonFilter.isNull("issueYy") ? null : jsonFilter.getInt("issueYy"));
		gipiPolbasicPolDistV1.setPolSeqNo(jsonFilter.isNull("polSeqNo") ? null : jsonFilter.getInt("polSeqNo"));
		gipiPolbasicPolDistV1.setRenewNo(jsonFilter.isNull("renewNo") ? null : jsonFilter.getInt("renewNo"));
		gipiPolbasicPolDistV1.setEndtYy(jsonFilter.isNull("endtYy") ? null : jsonFilter.getInt("endtYy"));
		gipiPolbasicPolDistV1.setEndtSeqNo(jsonFilter.isNull("endtSeqNo") ? null : jsonFilter.getInt("endtSeqNo"));
		gipiPolbasicPolDistV1.setAssdName(jsonFilter.isNull("assdName") ? "" : jsonFilter.getString("assdName"));
		gipiPolbasicPolDistV1.setDistNo(jsonFilter.isNull("distNo") ? null : jsonFilter.getInt("distNo"));
		gipiPolbasicPolDistV1.setUserId(GIPIPolbasicPolDistV1Controller.userId);
		
		return gipiPolbasicPolDistV1;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicPolDistV1Service#getGIPIPolbasicPolDistV1ListForPerilDist(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGIPIPolbasicPolDistV1ListForPerilDist(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareGIPIPolbasicPolDistV1Filter((String) params.get("filter")));
		List<GIPIPolbasicPolDistV1> list = this.getGipiPolbasicPolDistV1DAO().getGIPIPolbasicPolDistV1ListForPerilDist(params);
		params.put("rows", new JSONArray((List<GIPIPolbasicPolDistV1>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGIPIPolbasicPolDistV1ListOneRiskDist(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareGIPIPolbasicPolDistV1Filter((String) params.get("filter")));
		List<GIPIPolbasicPolDistV1> list = this.getGipiPolbasicPolDistV1DAO().getGIPIPolbasicPolDistV1ListOneRiskDist(params);
		params.put("rows", new JSONArray((List<GIPIPolbasicPolDistV1>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public void getV1ListDistByTsiPremPeril(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getV1ListDistByTsiPremPeril");
		params.put("moduleId", "GIUWS017");
		params.put("userId", USER.getUserId());
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("gipiPolbasicPolDistV1TableGrid", grid);
		request.setAttribute("object", grid);
		request.setAttribute("refreshAction", "showV1ListDistByTsiPremPeril");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicPolDistV1Service#getGiuws012Currency(java.lang.Integer, java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getGiuws012Currency(Integer policyId,
			Integer distNo, Integer distSeqNo) throws SQLException {
		return this.getGipiPolbasicPolDistV1DAO().getGiuws012Currency(policyId, distNo, distSeqNo);
	}

	@Override
	public void getV1PopMissingDistRec(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("ACTION", "getV1PopMissingDistRec"); replaced by: Nica 12.27.2012
		params.put("ACTION", "getPolDistV1Giuts999");
		params.put("moduleId", "GIUTS999");
		params.put("userId", USER.getUserId());
		params.put("paramLineCd", request.getParameter("paramLineCd"));
		params.put("paramSublineCd", request.getParameter("paramSublineCd"));
		params.put("paramIssCd", request.getParameter("paramIssCd"));
		params.put("paramIssueYy", request.getParameter("paramIssueYy"));
		params.put("paramPolSeqNo", request.getParameter("paramPolSeqNo"));
		params.put("paramRenewNo", request.getParameter("paramRenewNo"));
		params.put("paramDistNo", request.getParameter("paramDistNo"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("gipiPolbasicPolDistV1TableGrid", grid);
		request.setAttribute("object", grid);
		String refreshAction = "showV1ListPopuMissDistRec&paramLineCd="+request.getParameter("paramLineCd")+
				               "&paramSublineCd="+request.getParameter("paramSublineCd")+"&paramIssCd="+request.getParameter("paramIssCd")+
				               "&paramIssueYy="+request.getParameter("paramIssueYy")+"&paramPolSeqNo="+request.getParameter("paramPolSeqNo")+
				               "&paramRenewNo="+request.getParameter("paramRenewNo")+"&paramDistNo="+request.getParameter("paramDistNo"); // added by: Nica 12.27.2012
		request.setAttribute("refreshAction", refreshAction);
	}

	@Override
	public String createMissingDistRec(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", request.getParameter("distNo"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		return new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(this.gipiPolbasicPolDistV1DAO.createMissingDistRec(params))).toString();
	}

}

