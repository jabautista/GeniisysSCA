package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
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
import com.geniisys.gipi.dao.GIPIReassignParEndtDAO;
import com.geniisys.gipi.entity.GIPIReassignParEndt;
import com.geniisys.gipi.service.GIPIReassignParEndtService;

public class GIPIReassignParEndtServiceImpl implements GIPIReassignParEndtService {

	private GIPIReassignParEndtDAO gipiReassignParEndtDAO;

	/**
	 * @return the gipiReassignParEndtDAO
	 */
	public GIPIReassignParEndtDAO getGipiReassignParEndtDAO() {
		return gipiReassignParEndtDAO;
	}

	/**
	 * @param gipiReassignParEndtDAO the gipiReassignParEndtDAO to set
	 */
	public void setGipiReassignParEndtDAO(GIPIReassignParEndtDAO gipiReassignParEndtDAO) {
		this.gipiReassignParEndtDAO = gipiReassignParEndtDAO;
	}
	
	private static String leftPad(String value, int width) {
        return String.format("%" + width + "s", value).replace(' ', '0');
    }

	@Override
	public JSONObject getReassignParEndtListing(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReassignParEndtListing");
		params.put("userId",userId);
		Map<String, Object> reassignParEndt = TableGridUtil.getTableGrid(request, params);
		JSONObject objReassignParEndt = new JSONObject(reassignParEndt);
		JSONArray rows = objReassignParEndt.getJSONArray("rows");
		for (int i = 0; i < rows.length(); i++) {
			rows.getJSONObject(i).put("tbgPackPolFlag", rows.getJSONObject(i).getString("packPolFlag").equals("Y") ? true : false);
			rows.getJSONObject(i).put("parNo", rows.getJSONObject(i).getString("lineCd")+" - "+rows.getJSONObject(i).getString("issCd")+" - "+rows.getJSONObject(i).getString("parYY")+" - "+leftPad(rows.getJSONObject(i).getString("parSeqNo"),6)+" - "+leftPad(rows.getJSONObject(i).getString("quoteSeqNo"),2));
		}
		objReassignParEndt.remove("rows");
		objReassignParEndt.put("rows", rows);
		return objReassignParEndt;
	}

	@Override
	public String checkUser(HttpServletRequest request,String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("underwriter", request.getParameter("underwriter"));
		return gipiReassignParEndtDAO.checkUser(params);
	}

	@Override
	public List<Map<String, Object>> saveReassignParEndt(HttpServletRequest request, GIISUser USER)
			throws SQLException,JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setReassignParEndt")), USER.getUserId(), GIPIReassignParEndt.class));	
		params.put("postFormParams", preparePostFormParams(params,USER));
		return this.gipiReassignParEndtDAO.saveReassignParEndt(params);
	}

	@SuppressWarnings("unchecked")
	private List<Map<String, Object>> preparePostFormParams(Map<String, Object> params, GIISUser USER) throws JSONException {
//		List<GIPIReassignParEndt> listParams = (List<GIPIReassignParEndt>) JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setReassignParEndt")), USER.getUserId(), GIPIReassignParEndt.class);	
		List<GIPIReassignParEndt> listParams = (List<GIPIReassignParEndt>) params.get("insParams");
		List<Map<String, Object>> postFormParamsList = new ArrayList<Map<String,Object>>();
		for (GIPIReassignParEndt gipiReassignParEndt : listParams) {
			Map<String, Object> postFormParams = new HashMap<String, Object>();
			postFormParams.put("moduleId", "GIPIS057");
			postFormParams.put("underwriter", gipiReassignParEndt.getUnderwriter());
			postFormParams.put("userId", USER.getUserId());
			postFormParams.put("parId", gipiReassignParEndt.getParId());
			postFormParams.put("lineCd", gipiReassignParEndt.getLineCd());
			postFormParams.put("issCd", gipiReassignParEndt.getIssCd());
			postFormParams.put("parYY", gipiReassignParEndt.getParYY());
			postFormParams.put("parSeqNo", gipiReassignParEndt.getParSeqNo());
			postFormParams.put("quoteSeqNo", gipiReassignParEndt.getQuoteSeqNo());
			postFormParams.put("msg", "");
			postFormParamsList.add(postFormParams);
		}
		return postFormParamsList;
	}
	
}
