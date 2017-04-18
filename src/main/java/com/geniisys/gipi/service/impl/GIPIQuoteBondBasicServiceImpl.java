package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.dao.GIPIQuoteBondBasicDAO;
import com.geniisys.gipi.entity.GIPIQuoteBondBasic;
import com.geniisys.gipi.service.GIPIQuoteBondBasicService;

public class GIPIQuoteBondBasicServiceImpl implements GIPIQuoteBondBasicService{

	private Logger log = Logger.getLogger(GIPIQuoteBondBasicServiceImpl.class);
	private GIPIQuoteBondBasicDAO gipiQuoteBondBasicDAO;

	public GIPIQuoteBondBasicDAO getGipiQuoteBondBasicDAO() {
		return gipiQuoteBondBasicDAO;
	}

	public void setGipiQuoteBondBasicDAO(GIPIQuoteBondBasicDAO gipiQuoteBondBasicDAO) {
		this.gipiQuoteBondBasicDAO = gipiQuoteBondBasicDAO;
	}

	@Override
	public GIPIQuoteBondBasic getGIPIQuoteBondBasic(Integer quoteId)
			throws SQLException {
		return this.gipiQuoteBondBasicDAO.getGIPIQuoteBondBasic(quoteId);
	}

	@Override
	public GIPIQuoteBondBasic prepareBondPolicyData(HttpServletRequest request,
			GIISUser USER) throws ParseException {
		log.info("Preparing Bond Policy Data...");
		GIPIQuoteBondBasic bondPolicy = new GIPIQuoteBondBasic();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		bondPolicy.setQuoteId(Integer.parseInt(request.getParameter("quoteId")));
		bondPolicy.setObligeeNo(request.getParameter("obligeeNo"));
		bondPolicy.setPrinId(request.getParameter("prinId"));
		bondPolicy.setValPeriodUnit(request.getParameter("valPeriodUnit"));
		bondPolicy.setValPeriod(request.getParameter("valPeriod"));
		bondPolicy.setCollFlag(request.getParameter("collFlag"));
		bondPolicy.setClauseType(request.getParameter("clauseType"));
		bondPolicy.setNpNo(request.getParameter("npNo"));
		bondPolicy.setContractDtl(request.getParameter("contractDtl"));
		bondPolicy.setContractDate(request.getParameter("contractDate")=="" || request.getParameter("contractDate")==null? null :sdf.parse(request.getParameter("contractDate")));
		bondPolicy.setCoPrinSw(request.getParameter("coPrinSw"));
		bondPolicy.setWaiverLimit(new BigDecimal(request.getParameter("dspWaiverLimit") == "" || request.getParameter("dspWaiverLimit") == null ? "0" :request.getParameter("dspWaiverLimit").replaceAll(",", "")));
		bondPolicy.setIndemnityText(request.getParameter("indemnityText"));
		bondPolicy.setBondDtl(request.getParameter("bondDtl"));
		bondPolicy.setEndtEffDate(request.getParameter("endtEffDate")=="" || request.getParameter("endtEffDate")==null? null :sdf.parse(request.getParameter("endtEffDate")));
		bondPolicy.setRemarks(request.getParameter("remarks"));
		return bondPolicy;
	}

	@Override
	public String saveBondPolicyData(Map<String, Object> params)
			throws SQLException {
		return this.gipiQuoteBondBasicDAO.saveBondPolicyData(params);
	}
	
}
