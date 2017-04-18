package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gixx.dao.GIXXPolwcDAO;
import com.geniisys.gixx.entity.GIXXPolwc;
import com.geniisys.gixx.service.GIXXPolwcService;
import com.seer.framework.util.StringFormatter;

public class GIXXPolwcServiceImpl implements GIXXPolwcService {

	private GIXXPolwcDAO gixxPolwcDAO;

	public GIXXPolwcDAO getGixxPolwcDAO() {
		return gixxPolwcDAO;
	}

	public void setGixxPolwcDAO(GIXXPolwcDAO gixxPolwcDAO) {
		this.gixxPolwcDAO = gixxPolwcDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIXXRelatedWcInfo(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer)params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIXXPolwc> polwcList = this.getGixxPolwcDAO().getGIXXRelatedWcInfo(params);
		params.put("rows", new JSONArray((List<GIXXPolwc>) StringFormatter.escapeHTMLInList(polwcList)));
		grid.setNoOfPages(polwcList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}
	
}
