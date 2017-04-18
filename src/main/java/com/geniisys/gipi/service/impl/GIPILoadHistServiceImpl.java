package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.dao.GIPILoadHistDAO;
import com.geniisys.gipi.entity.GIPILoadHist;
import com.geniisys.gipi.service.GIPILoadHistService;
import com.seer.framework.util.StringFormatter;

public class GIPILoadHistServiceImpl implements GIPILoadHistService{
	
	private GIPILoadHistDAO gipiLoadHistDAO;

	public GIPILoadHistDAO getGipiLoadHistDAO() {
		return gipiLoadHistDAO;
	}

	public void setGipiLoadHistDAO(GIPILoadHistDAO gipiLoadHistDAO) {
		this.gipiLoadHistDAO = gipiLoadHistDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPILoadHist> getGipiLoadHist() throws SQLException {
		return (List<GIPILoadHist>) StringFormatter.replaceQuotesInList(this.gipiLoadHistDAO.getGipiLoadHist());
	}

	@Override
	public String createToPar(String uploadNo, Integer parId, Integer itemNo,
			String polId, String lineCd, String issCd, String userId)
			throws SQLException {
		return this.gipiLoadHistDAO.createToPar(uploadNo, parId, itemNo, polId, lineCd, issCd, userId);
	}

	@Override
	public List<Map<String, Object>> getUploadedEnrollees(HttpServletRequest request)  //created by christian 04/29/2013
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("uploadNo", request.getParameter("uploadNo"));
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.gipiLoadHistDAO.getUploadedEnrollees(params);
	}

}
