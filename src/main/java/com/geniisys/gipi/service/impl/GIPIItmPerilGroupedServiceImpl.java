package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIItmPerilGroupedDAO;
import com.geniisys.gipi.entity.GIPIItmPerilGrouped;
import com.geniisys.gipi.service.GIPIItmPerilGroupedService;
import com.seer.framework.util.StringFormatter;

public class GIPIItmPerilGroupedServiceImpl implements GIPIItmPerilGroupedService{

	private GIPIItmPerilGroupedDAO gipiItmPerilGroupedDAO;

	public GIPIItmPerilGroupedDAO getGipiItmPerilGroupedDAO() {
		return gipiItmPerilGroupedDAO;
	}

	public void setGipiItmPerilGroupedDAO(
			GIPIItmPerilGroupedDAO gipiItmPerilGroupedDAO) {
		this.gipiItmPerilGroupedDAO = gipiItmPerilGroupedDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getItmPerilGroupedList(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIItmPerilGrouped> gipiItmPerilGroupedList = this.getGipiItmPerilGroupedDAO().getItmPerilGroupedList(params);
		params.put("rows", new JSONArray((List<GIPIItmPerilGrouped>)StringFormatter.escapeHTMLInList(gipiItmPerilGroupedList)));
		grid.setNoOfPages(gipiItmPerilGroupedList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItmPerilGrouped> getPolItmPerils(Integer parId)
			throws SQLException {
		return (List<GIPIItmPerilGrouped>) StringFormatter.escapeHTMLInList(this.getGipiItmPerilGroupedDAO().getPolItmPerils(parId));
	}
	
	
}
