package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.dao.GIRIDistFrpsDAO;
import com.geniisys.giri.entity.GIRIDistFrps;
import com.geniisys.giri.service.GIRIDistFrpsService;
import com.geniisys.giri.service.GIRIWFrpsRiService;
import com.seer.framework.util.StringFormatter;

public class GIRIDistFrpsServiceImpl implements GIRIDistFrpsService {
	
	private GIRIDistFrpsDAO giriDistFrpsDAO;
	
	public GIRIDistFrpsDAO getGiriDistFrpsDAO() {
		return giriDistFrpsDAO;
	}

	public void setGiriDistFrpsDAO(GIRIDistFrpsDAO giriDistFrpsDAO) {
		this.giriDistFrpsDAO = giriDistFrpsDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGIRIFrpsList(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareFrpsListDetailFilter((String) params.get("filter")));
		List<GIRIDistFrps> list = this.getGiriDistFrpsDAO().getGIRIFrpsList(params);
		params.put("rows", new JSONArray((List<GIRIDistFrps>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	private GIRIDistFrps prepareFrpsListDetailFilter(String filter) throws JSONException {
		GIRIDistFrps frpsList = new GIRIDistFrps();
		JSONObject jsonFrpsListFilter = null;
		
		if (null == filter){
			jsonFrpsListFilter = new JSONObject();
		}else{
			jsonFrpsListFilter = new JSONObject(filter);
		}
		frpsList.setFrpsYy(jsonFrpsListFilter.isNull("frpsYy") ? null : jsonFrpsListFilter.getInt("frpsYy"));
		frpsList.setFrpsSeqNo(jsonFrpsListFilter.isNull("frpsSeqNo") ? null : jsonFrpsListFilter.getInt("frpsSeqNo"));	
		frpsList.setIssCd(jsonFrpsListFilter.isNull("issCd") ? "" : jsonFrpsListFilter.getString("issCd"));	
		frpsList.setParYy(jsonFrpsListFilter.isNull("parYy") ? null : jsonFrpsListFilter.getInt("parYy"));
		frpsList.setParSeqNo(jsonFrpsListFilter.isNull("parSeqNo") ? null : jsonFrpsListFilter.getInt("parSeqNo"));
		frpsList.setEndtYy(jsonFrpsListFilter.isNull("endtYy") ? null : jsonFrpsListFilter.getInt("endtYy"));
		frpsList.setEndtSeqNo(jsonFrpsListFilter.isNull("endtSeqNo") ? null : jsonFrpsListFilter.getInt("endtSeqNo"));
		frpsList.setSublineCd(jsonFrpsListFilter.isNull("sublineCd") ? null : jsonFrpsListFilter.getString("sublineCd"));
		frpsList.setIssueYy(jsonFrpsListFilter.isNull("issueYy") ? null : jsonFrpsListFilter.getInt("issueYy"));
		frpsList.setPolSeqNo(jsonFrpsListFilter.isNull("polSeqNo") ? null : jsonFrpsListFilter.getInt("polSeqNo"));
		frpsList.setAssdName(jsonFrpsListFilter.isNull("assdName") ? null : jsonFrpsListFilter.getString("assdName"));
		frpsList.setDistNo(jsonFrpsListFilter.isNull("distNo") ? null : jsonFrpsListFilter.getInt("distNo"));
		return frpsList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void getDistFrpsWDistFrpsV(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId)
			throws SQLException, JSONException {
		GIRIWFrpsRiService giriwFrpsRiService = (GIRIWFrpsRiService) APPLICATION_CONTEXT.getBean("giriWFrpsRiService");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("frpsYy", request.getParameter("frpsYy"));
		params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
		params.put("module", request.getParameter("module"));
		params.put("userId", userId);
		JSONArray viewJSON = new JSONArray((List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(this.giriDistFrpsDAO.getDistFrpsWDistFrpsV(params)));
		request.setAttribute("viewJson", viewJSON);
		request.setAttribute("reinsurerTableGrid", giriwFrpsRiService.refreshGiriwFrpsRiGrid(request));
		JSONObject wdistFrpsVJSON = new JSONObject();
		
		if (viewJSON.length() >= 1){
			JSONObject json = null;
			Map<String, Object> p = new HashMap<String, Object>();
			json = viewJSON.getJSONObject(0);
			p.put("lineCd", json.getString("lineCd"));
			p.put("frpsYy", json.getInt("frpsYy"));
			p.put("frpsSeqNo", json.getInt("frpsSeqNo"));
			p.put("moduleId", "GIRIS001");
			p.put("userId", userId);
			
			wdistFrpsVJSON = new JSONObject(StringFormatter.escapeHTMLInMap(this.getDistFrpsWDistFrpsV2(p)));
		}
		
		request.setAttribute("wdistFrpsVJSON", wdistFrpsVJSON);
	}

	@Override
	public HashMap<String, Object> getWFrperilParams(
			HashMap<String, Object> params) throws SQLException, JSONException {
		
		List<HashMap<String, Object>> list = this.getGiriDistFrpsDAO().getGIRIWFrperils(params);
		TableGridUtil grid = new TableGridUtil(1, list.size());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("rows", new JSONArray(/*(List<HashMap<String, Object>>) StringFormatter.escapeHTMLInList(*/list/*)*/));
		params.put("noOfRecords", list.size());
		//grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", list.size()); // bonok :: 07.04.2013 :: to display pager
		params = this.getGiriDistFrpsDAO().getWFrperilSums(params);
		System.out.println("getWFrperilParams test :: "+grid.getStartRow()+" / "+grid.getEndRow() + " :: "+list.size());
		return params;
	}
	
	@Override
	public Map<String, Object> updateDistFrpsGiuts004(Map<String, Object> params)
			throws SQLException {
		return this.giriDistFrpsDAO.updateDistFrpsGiuts004(params);
	}
	
	public Map<String, Object> getDistFrpsWDistFrpsV2(Map<String, Object> params) throws SQLException{
		return this.giriDistFrpsDAO.getDistFrpsWDistFrpsV2(params);
	}

}
	


