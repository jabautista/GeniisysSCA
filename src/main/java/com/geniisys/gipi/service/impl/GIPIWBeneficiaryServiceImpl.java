package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIWBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIWBeneficiary;
import com.geniisys.gipi.service.GIPIWBeneficiaryService;
import com.seer.framework.util.StringFormatter;

public class GIPIWBeneficiaryServiceImpl implements GIPIWBeneficiaryService{
	
	public GIPIWBeneficiaryDAO gipiWBeneficiaryDAO;

	public GIPIWBeneficiaryDAO getGipiWBeneficiaryDAO() {
		return gipiWBeneficiaryDAO;
	}

	public void setGipiWBeneficiaryDAO(GIPIWBeneficiaryDAO gipiWBeneficiaryDAO) {
		this.gipiWBeneficiaryDAO = gipiWBeneficiaryDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWBeneficiary> getGipiWBeneficiary(Integer parId)
			throws SQLException {
		return (List<GIPIWBeneficiary>) StringFormatter.escapeHTMLJavascriptInList(this.gipiWBeneficiaryDAO.getGipiWBeneficiary(parId));
	}	
}