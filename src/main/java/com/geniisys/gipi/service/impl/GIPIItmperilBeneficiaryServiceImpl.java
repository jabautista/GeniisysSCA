package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIItmperilBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIItmperilBeneficiary;
import com.geniisys.gipi.service.GIPIItmperilBeneficiaryService;
import com.seer.framework.util.StringFormatter;

public class GIPIItmperilBeneficiaryServiceImpl implements GIPIItmperilBeneficiaryService{

	private GIPIItmperilBeneficiaryDAO gipiItmperilBeneficiaryDAO;

	public GIPIItmperilBeneficiaryDAO getGipiItmperilBeneficiaryDAO() {
		return gipiItmperilBeneficiaryDAO;
	}

	public void setGipiItmperilBeneficiaryDAO(
			GIPIItmperilBeneficiaryDAO gipiItmperilBeneficiaryDAO) {
		this.gipiItmperilBeneficiaryDAO = gipiItmperilBeneficiaryDAO;
	}

	@SuppressWarnings({ "unchecked" })
	@Override
	public HashMap<String, Object> getItmperilBeneficiaries(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIItmperilBeneficiary> itmperilBeneficiaryList = this.getGipiItmperilBeneficiaryDAO().getItmperilBeneficiaries(params);
		params.put("rows", new JSONArray((List<GIPIGrpItemsBeneficiary>)StringFormatter.escapeHTMLInList(itmperilBeneficiaryList)));
		grid.setNoOfPages(itmperilBeneficiaryList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	
}
