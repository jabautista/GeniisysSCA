package com.geniisys.common.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISGeninInfoDAO;
import com.geniisys.common.entity.GIISGeninInfo;
import com.geniisys.common.entity.GIISTakeupTerm;
import com.geniisys.common.service.GIISGeninInfoService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACAcctEntries;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.seer.framework.util.StringFormatter;

public class GIISGeninInfoServiceImpl implements GIISGeninInfoService{

	public GIISGeninInfoDAO giisGeninInfoDAO;

	public GIISGeninInfoDAO getGiisGeninInfoDAO() {
		return giisGeninInfoDAO;
	}
	public void setGiisGeninInfoDAO(GIISGeninInfoDAO giisGeninInfoDAO) {
		this.giisGeninInfoDAO = giisGeninInfoDAO;
	}
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getInitInfoList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIPIWPolGenin> list = (List<GIPIWPolGenin>) StringFormatter.replaceQuotesInList(this.giisGeninInfoDAO.getInitInfoList(params));
		PaginatedList paginatedList = new PaginatedList(list , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getGenInfoList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIPIWPolGenin> list = (List<GIPIWPolGenin>) StringFormatter.escapeHTMLInList3(this.giisGeninInfoDAO.getGenInfoList(params));
		PaginatedList paginatedList = new PaginatedList(list , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	@Override
	public JSONObject showGiiss180(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss180RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("geninInfoCd") != null){
			String geninInfoCd = request.getParameter("geninInfoCd");
			this.giisGeninInfoDAO.valDeleteRec(geninInfoCd);
		}
	}

	@Override
	public void saveGiiss180(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", /*this.prepareGeninInfoForInsert(new JSONArray(request.getParameter("setRows")), userId)*/ JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISGeninInfo.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISGeninInfo.class));
		params.put("appUser", userId);
		this.giisGeninInfoDAO.saveGiiss180(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("geninInfoCd") != null){
			String geninInfoCd = request.getParameter("geninInfoCd");
			this.giisGeninInfoDAO.valAddRec(geninInfoCd);
		}
	}
	
	public 	String allowUpdate(String geninInfoCd) throws SQLException{
		return this.giisGeninInfoDAO.allowUpdateGiiss180(geninInfoCd);
	}
	
	public List<GIISGeninInfo> prepareGeninInfoForInsert(JSONArray rows, String userId) throws SQLException, JSONException{
		GIISGeninInfo geninInfo = null;
		JSONObject json = null;
		List<GIISGeninInfo> items = new ArrayList<GIISGeninInfo>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			geninInfo = new GIISGeninInfo();
			
			geninInfo.setGeninInfoCd(json.isNull("geninInfoCd") ? null : json.getString("geninInfoCd"));
			geninInfo.setGeninInfoTitle(json.isNull("geninInfoTitle") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("geninInfoTitle"))));
			geninInfo.setGenInfo01(json.isNull("genInfo01") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo01"))));
			geninInfo.setGenInfo02(json.isNull("genInfo02") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo02"))));
			geninInfo.setGenInfo03(json.isNull("genInfo03") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo03"))));
			geninInfo.setGenInfo04(json.isNull("genInfo04") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo04"))));
			geninInfo.setGenInfo05(json.isNull("genInfo05") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo05"))));
			geninInfo.setGenInfo06(json.isNull("genInfo06") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo06"))));
			geninInfo.setGenInfo07(json.isNull("genInfo07") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo07"))));
			geninInfo.setGenInfo08(json.isNull("genInfo08") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo08"))));
			geninInfo.setGenInfo09(json.isNull("genInfo09") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo09"))));
			geninInfo.setGenInfo10(json.isNull("genInfo10") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo10"))));
			geninInfo.setGenInfo11(json.isNull("genInfo11") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo11"))));
			geninInfo.setGenInfo12(json.isNull("genInfo12") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo12"))));
			geninInfo.setGenInfo13(json.isNull("genInfo13") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo13"))));
			geninInfo.setGenInfo14(json.isNull("genInfo14") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo14"))));
			geninInfo.setGenInfo15(json.isNull("genInfo15") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo15"))));
			geninInfo.setGenInfo16(json.isNull("genInfo16") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo16"))));
			geninInfo.setGenInfo17(json.isNull("genInfo17") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("genInfo17"))));
			geninInfo.setInitialInfo01(json.isNull("initialInfo01") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo01"))));
			geninInfo.setInitialInfo02(json.isNull("initialInfo02") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo02"))));
			geninInfo.setInitialInfo03(json.isNull("initialInfo03") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo03"))));
			geninInfo.setInitialInfo04(json.isNull("initialInfo04") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo04"))));
			geninInfo.setInitialInfo05(json.isNull("initialInfo05") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo05"))));
			geninInfo.setInitialInfo06(json.isNull("initialInfo06") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo06"))));
			geninInfo.setInitialInfo07(json.isNull("initialInfo07") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo07"))));
			geninInfo.setInitialInfo08(json.isNull("initialInfo08") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo08"))));
			geninInfo.setInitialInfo09(json.isNull("initialInfo09") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo09"))));
			geninInfo.setInitialInfo10(json.isNull("initialInfo10") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo10"))));
			geninInfo.setInitialInfo11(json.isNull("initialInfo11") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo11"))));
			geninInfo.setInitialInfo12(json.isNull("initialInfo12") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo12"))));
			geninInfo.setInitialInfo13(json.isNull("initialInfo13") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo13"))));
			geninInfo.setInitialInfo14(json.isNull("initialInfo14") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo14"))));
			geninInfo.setInitialInfo15(json.isNull("initialInfo15") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo15"))));
			geninInfo.setInitialInfo16(json.isNull("initialInfo16") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo16"))));
			geninInfo.setInitialInfo17(json.isNull("initialInfo17") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("initialInfo17"))));
			geninInfo.setRemarks(json.isNull("remarks") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
			geninInfo.setUserId(userId);
			
			items.add(geninInfo);
		}
		
		return items;
	}
}
