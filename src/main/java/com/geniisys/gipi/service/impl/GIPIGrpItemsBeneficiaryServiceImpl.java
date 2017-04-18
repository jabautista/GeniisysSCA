package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIGrpItemsBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;
import com.geniisys.gipi.service.GIPIGrpItemsBeneficiaryService;
import com.seer.framework.util.StringFormatter;

public class GIPIGrpItemsBeneficiaryServiceImpl implements GIPIGrpItemsBeneficiaryService{
	
	private GIPIGrpItemsBeneficiaryDAO gipiGrpItemsBeneficiaryDAO;

	public GIPIGrpItemsBeneficiaryDAO getGipiGrpItemsBeneficiaryDAO() {
		return gipiGrpItemsBeneficiaryDAO;
	}

	public void setGipiGrpItemsBeneficiaryDAO(
			GIPIGrpItemsBeneficiaryDAO gipiGrpItemsBeneficiaryDAO) {
		this.gipiGrpItemsBeneficiaryDAO = gipiGrpItemsBeneficiaryDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGrpItemsBeneficiaries(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIGrpItemsBeneficiary> grpItemsBeneficiaryList = this.getGipiGrpItemsBeneficiaryDAO().getGrpItemsBeneficiaries(params);
		params.put("rows", new JSONArray((List<GIPIGrpItemsBeneficiary>)StringFormatter.escapeHTMLInList(grpItemsBeneficiaryList)));
		grid.setNoOfPages(grpItemsBeneficiaryList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	

}
