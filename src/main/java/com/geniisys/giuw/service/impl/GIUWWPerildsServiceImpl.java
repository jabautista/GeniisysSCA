package com.geniisys.giuw.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giuw.dao.GIUWWPerildsDAO;
import com.geniisys.giuw.entity.GIUWWPerilds;
import com.geniisys.giuw.service.GIUWWPerildsService;
import com.seer.framework.util.StringFormatter;

public class GIUWWPerildsServiceImpl implements GIUWWPerildsService {
	
	private GIUWWPerildsDAO giuwwPerildsDAO;

	public void setGiuwwPerildsDAO(GIUWWPerildsDAO giuwwPerildsDAO) {
		this.giuwwPerildsDAO = giuwwPerildsDAO;
	}

	public GIUWWPerildsDAO getGiuwwPerildsDAO() {
		return giuwwPerildsDAO;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGiuwWperildsForDistFinal(
		Map<String, Object> params) throws SQLException, JSONException {
		Integer pageSize = 999999999; // jhing 12.05.2014  temporary set pagesize to this value so that pagination will not happen. Business process wise it would be quite impossible to have this no. of perils
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), pageSize /*ApplicationWideParameters.PAGE_SIZE */ ); // jhing 12.04.2014 replaced defult pagesize with variable
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIUWWPerilds> list = this.getGiuwwPerildsDAO().getGiuwWperildsForDistFinal(params);
		params.put("rows", new JSONArray((List<GIUWWPerilds>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;

	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.service.GIUWWPerildsService#isExistGiuwWPerildsGIUWS012(java.lang.Integer)
	 */
	@Override
	public String isExistGiuwWPerildsGIUWS012(Integer distNo)
			throws SQLException {
		return this.getGiuwwPerildsDAO().isExistGiuwWPerildsGIUWS012(distNo);
	}
}
