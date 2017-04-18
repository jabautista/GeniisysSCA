package com.geniisys.gipi.service.impl;

import java.sql.SQLException;

import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIVesAirDAO;
import com.geniisys.gipi.entity.GIPIVesAir;
import com.geniisys.gipi.service.GIPIVesAirService;
import com.seer.framework.util.StringFormatter;

public class GIPIVesAirServiceImpl implements GIPIVesAirService{
	
	private GIPIVesAirDAO gipiVesAirDAO;

	public void setGipiVesAirDAO(GIPIVesAirDAO gipiVesAirDAO) {
		this.gipiVesAirDAO = gipiVesAirDAO;
	}

	public GIPIVesAirDAO getGipiVesAirDAO() {
		return gipiVesAirDAO;
	}
		
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCargoInformations(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIVesAir> cargoInfoList = this.gipiVesAirDAO.getCargoInformations(params);
		params.put("rows", new JSONArray((List<GIPIVesAir>)StringFormatter.escapeHTMLInList(cargoInfoList)));
		grid.setNoOfPages(cargoInfoList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}




	
}
