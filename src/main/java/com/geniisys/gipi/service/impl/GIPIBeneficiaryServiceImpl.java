package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIBeneficiary;
import com.geniisys.gipi.service.GIPIBeneficiaryService;
import com.seer.framework.util.StringFormatter;

public class GIPIBeneficiaryServiceImpl implements GIPIBeneficiaryService{
	
	private GIPIBeneficiaryDAO gipiBeneficiaryDAO;

	public GIPIBeneficiaryDAO getGipiBeneficiaryDAO() {
		return gipiBeneficiaryDAO;
	}

	public void setGipiBeneficiaryDAO(GIPIBeneficiaryDAO gipiBeneficiaryDAO) {
		this.gipiBeneficiaryDAO = gipiBeneficiaryDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiBeneficiaries(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIBeneficiary> beneficiaryList = this.getGipiBeneficiaryDAO().getGipiBeneficiaries(params);
		params.put("rows", new JSONArray((List<GIPIBeneficiary>)StringFormatter.escapeHTMLInList(beneficiaryList)));
		grid.setNoOfPages(beneficiaryList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public GIPIBeneficiary getGIPIBeneficiary(Map<String, Object> params)
			throws SQLException {
		GIPIBeneficiary ben = this.getGipiBeneficiaryDAO().getGIPIBeneficiary(params);			
		
		return ben != null ? (GIPIBeneficiary) StringFormatter.escapeHTMLInObject(ben) : new GIPIBeneficiary();
	}	
}
