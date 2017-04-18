package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIDeductiblesDAO;
import com.geniisys.gipi.entity.GIPIDeductibles;
import com.geniisys.gipi.service.GIPIDeductiblesService;
import com.seer.framework.util.StringFormatter;

public class GIPIDeductiblesServiceImpl implements GIPIDeductiblesService{
	
	private GIPIDeductiblesDAO gipiDeductiblesDAO;

	public GIPIDeductiblesDAO getGipiDeductiblesDAO() {
		return gipiDeductiblesDAO;
	}

	public void setGipiDeductiblesDAO(GIPIDeductiblesDAO gipiDeductiblesDAO) {
		this.gipiDeductiblesDAO = gipiDeductiblesDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getDeductibles(HashMap<String, Object> params)throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIDeductibles> deductibleList = this.getGipiDeductiblesDAO().getDeductibles(params);
		params.put("rows", new JSONArray((List<GIPIDeductibles>)StringFormatter.escapeHTMLInList(deductibleList)));
		grid.setNoOfPages(deductibleList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getItemDeductibles(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIDeductibles> itemDuductibles = this.getGipiDeductiblesDAO().getItemDeductibles(params);
		params.put("rows", new JSONArray((List<GIPIDeductibles>)StringFormatter.escapeHTMLInList(itemDuductibles)));
		grid.setNoOfPages(itemDuductibles);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}

	
	
}
