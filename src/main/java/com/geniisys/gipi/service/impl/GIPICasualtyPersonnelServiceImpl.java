package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPICasualtyPersonnelDAO;
import com.geniisys.gipi.entity.GIPICasualtyPersonnel;
import com.geniisys.gipi.service.GIPICasualtyPersonnelService;
import com.seer.framework.util.StringFormatter;

public class GIPICasualtyPersonnelServiceImpl implements GIPICasualtyPersonnelService{
	
	private GIPICasualtyPersonnelDAO gipiCasualtyPersonnelDAO;

	public GIPICasualtyPersonnelDAO getGipiCasualtyPersonnelDAO() {
		return gipiCasualtyPersonnelDAO;
	}

	public void setGipiCasualtyPersonnelDAO(
			GIPICasualtyPersonnelDAO gipiCasualtyPersonnelDAO) {
		this.gipiCasualtyPersonnelDAO = gipiCasualtyPersonnelDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCasualtyItemPersonnel(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPICasualtyPersonnel> casualtyPersonnel = this.getGipiCasualtyPersonnelDAO().getCasualtyItemPersonnel(params);
		params.put("rows", new JSONArray((List<GIPICasualtyPersonnel>)StringFormatter.escapeHTMLInList(casualtyPersonnel)));
		grid.setNoOfPages(casualtyPersonnel);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	
}
