package com.geniisys.gipi.service.impl;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIItemDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.service.GIPIItemService;
import com.seer.framework.util.StringFormatter;

public class GIPIItemServiceImpl implements GIPIItemService{

	private GIPIItemDAO gipiItemDAO;
	
	@Override
	public List<GIPIItem> getGIPIItemForEndt(int parId) throws SQLException {		
		return this.getGipiItemDAO().getGIPIItemForEndt(parId);
	}

	public void setGipiItemDAO(GIPIItemDAO gipiItemDAO) {
		this.gipiItemDAO = gipiItemDAO;
	}

	public GIPIItemDAO getGipiItemDAO() {
		return gipiItemDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getRelatedItemInfo(HashMap<String, Object> params) throws SQLException {
		
		Integer size;
		if ("policyItemInfo".equals(params.get("pageCalling"))||"policyInfoBasic".equals(params.get("pageCalling"))){
			size = 5;
		}else{
			size = ApplicationWideParameters.PAGE_SIZE;
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),size);//
		if ("policyItemInfo".equals(params.get("pageCalling"))){
			params.put("from", null);
			params.put("to", null);
		}else{
			params.put("from", grid.getStartRow());
			params.put("to", grid.getEndRow());
		}
		if("policyBillGroup".equals(params.get("pageCalling"))){
			List<Map<String, Object>> itemList = this.getGipiItemDAO().getItemGroupList(params);
			params.put("rows", new JSONArray((List<GIPIItem>)StringFormatter.escapeHTMLInListOfMap(itemList)));
			grid.setNoOfPages(itemList);
			params.put("pages", grid.getNoOfPages());
			params.put("total", grid.getNoOfRows());
			return params;
		}
		else{
		List<GIPIItem>	itemList = this.getGipiItemDAO().getRelatedItemInfo(params);
		params.put("rows", new JSONArray((List<GIPIItem>)StringFormatter.escapeHTMLInList(itemList)));
		grid.setNoOfPages(itemList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		}
	}

	@Override
	public String getNonMCItemTitle(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		return this.gipiItemDAO.getNonMCItemTitle(params);
	}
	
	@Override
	public List<Integer> getEndtItemList(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", StringFormatter.unescapeHtmlJava(request.getParameter("sublineCd"))); //Deo [01.03.2017]: added StringFormatter (SR-23567)
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("effDate", request.getParameter("effDate"));
		return this.getGipiItemDAO().getEndtItemList(params);
	}
	
	@Override
	public List<GIPIItem> getItemAnnTsiPrem(int parId)
			throws SQLException, ParseException {
		return this.gipiItemDAO.getItemAnnTsiPrem(parId); //monmon
	}

	@Override
	public String updatePolicyItemCoverage(HttpServletRequest request, String userId) throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIPIItem.class));
		allParams.put("userId", userId);
		return this.getGipiItemDAO().updatePolicyItemCoverage(allParams);		
	}

	@Override
	public JSONObject getGIPIS175Items(HttpServletRequest request)
			throws JSONException, SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIS175Items");
		params.put("policyId", request.getParameter("policyId"));
		params.put("pageSize", 5);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		return json;
	}
	
	public Integer getAttachmentTotalSize(Integer policyId, Integer itemNo) throws SQLException, IOException {
		Integer attachmentTotalSize = 0;
		List<Map<String, Object>> attachments = this.gipiItemDAO.getAttachments(policyId, itemNo);
		
		for(Map<String, Object> attachment : attachments) {
			try {
				FileInputStream fis = new FileInputStream((String) attachment.get("fileName"));
	        	byte[] file = new byte[fis.available()];
				fis.read(file);
				fis.close();
				attachmentTotalSize += file.length;
			} catch (Exception e) {
				continue;
			}
		}
		
		return attachmentTotalSize;
	}
	
}
