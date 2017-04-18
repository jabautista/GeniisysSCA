package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIMcaccDAO;
import com.geniisys.gipi.entity.GIPIMcacc;
import com.geniisys.gipi.service.GIPIMcaccService;
import com.seer.framework.util.StringFormatter;

public class GIPIMcaccServiceImpl implements GIPIMcaccService{

	private GIPIMcaccDAO gipiMcaccDAO;

	public GIPIMcaccDAO getGipiMcaccDAO() {
		return gipiMcaccDAO;
	}

	public void setGipiMcaccDAO(GIPIMcaccDAO gipiMcaccDAO) {
		this.gipiMcaccDAO = gipiMcaccDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getVehicleAccessories(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIMcacc> accessoryList = this.getGipiMcaccDAO().getVehicleAccessories(params);
		params.put("rows", new JSONArray((List<GIPIMcacc>)StringFormatter.escapeHTMLInList(accessoryList)));
		grid.setNoOfPages(accessoryList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}
	
	
}
