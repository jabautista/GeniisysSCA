package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.dao.GIPIQuoteCosignDAO;
import com.geniisys.gipi.entity.GIPIQuoteCosign;
import com.geniisys.gipi.service.GIPIQuoteCosignService;
import com.seer.framework.util.StringFormatter;

public class GIPIQuoteCosignServiceImpl implements GIPIQuoteCosignService{
	
	private GIPIQuoteCosignDAO gipiQuoteCosignDAO;

	public GIPIQuoteCosignDAO getGipiQuoteCosignDAO() {
		return gipiQuoteCosignDAO;
	}

	public void setGipiQuoteCosignDAO(GIPIQuoteCosignDAO gipiQuoteCosignDAO) {
		this.gipiQuoteCosignDAO = gipiQuoteCosignDAO;
	}

	@Override
	public List<GIPIQuoteCosign> getGIPIQuoteCosigns(Integer quoteId)
			throws SQLException {
		return this.gipiQuoteCosignDAO.getGIPIQuoteCosigns(quoteId);
	}

	@Override
	public List<GIPIQuoteCosign> prepareGIPIQuoteCosignJSON(
			JSONArray rows, String userId) throws JSONException {
		GIPIQuoteCosign cosign = null;
		List<GIPIQuoteCosign> list = new ArrayList<GIPIQuoteCosign>();
		for(int index=0; index<rows.length(); index++) {
			cosign = new GIPIQuoteCosign();
			cosign.setQuoteId(rows.getJSONObject(index).isNull("quoteId") ? null : rows.getJSONObject(index).getInt("quoteId"));
			cosign.setCosignId(rows.getJSONObject(index).isNull("cosignId") ? null : rows.getJSONObject(index).getInt("cosignId"));
			cosign.setCosignName(rows.getJSONObject(index).isNull("cosignName") ? "" : rows.getJSONObject(index).getString("cosignName"));
			cosign.setAssdNo(rows.getJSONObject(index).isNull("assdNo") ? null : rows.getJSONObject(index).getInt("assdNo"));
			cosign.setIndemFlag(rows.getJSONObject(index).isNull("indemFlag") ? "" : rows.getJSONObject(index).getString("indemFlag"));
			cosign.setBondsFlag(rows.getJSONObject(index).isNull("bondsFlag") ? "" : rows.getJSONObject(index).getString("bondsFlag"));
			cosign.setBondsRiFlag(rows.getJSONObject(index).isNull("bondsRiFlag") ? "" : rows.getJSONObject(index).getString("bondsRiFlag"));
			cosign.setAppUser(userId);
			list.add((GIPIQuoteCosign) StringFormatter.replaceQuoteTagIntoQuotesInObject(cosign));
		}
		return list;
	}

}
