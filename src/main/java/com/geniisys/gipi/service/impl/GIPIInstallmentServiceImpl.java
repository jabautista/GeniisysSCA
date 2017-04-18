/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIInstallmentDAO;
import com.geniisys.gipi.entity.GIPIInstallment;
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIInstallmentServiceImpl.
 */
public class GIPIInstallmentServiceImpl implements GIPIInstallmentService{
	
	private Logger log = Logger.getLogger(GIPIInstallmentServiceImpl.class);
	private GIPIInstallmentDAO gipiInstallmentDAO;
	
	/**
	 * @return the gipiInstallmentDAO
	 */
	public GIPIInstallmentDAO getGipiInstallmentDAO() {
		return gipiInstallmentDAO;
	}

	/**
	 * @param gipiInstallmentDAO the gipiInstallmentDAO to set
	 */
	public void setGipiInstallmentDAO(GIPIInstallmentDAO gipiInstallmentDAO) {
		this.gipiInstallmentDAO = gipiInstallmentDAO;
	}

	@Override
	public Map<String, Object> checkInstNo(Map<String, Object> param) throws SQLException {
		// TODO Auto-generated method stub
		log.info("Retrieving Installment records...");
		//log.info(""+ " Installment record/s retrieved.");
		return this.gipiInstallmentDAO.checkInstNo(param);
	}

	@Override
	public Integer getDaysOverdue(Map<String, Object> param) throws SQLException {
		// TODO Auto-generated method stub
		return this.gipiInstallmentDAO.getDaysOverdue(param);
	}

	@SuppressWarnings("deprecation")
	public PaginatedList getInstNoList(Map<String, Object> params) throws SQLException{
		List<GIPIInstallment> instNoList = this.gipiInstallmentDAO.getInstNoList(params);
		PaginatedList paginatedList = new PaginatedList(instNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(Integer.parseInt((String) params.get("pageNo")));
		return paginatedList;
	}

	@Override
	public String getUnpaidPremiumDtls(HttpServletRequest request)	throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("issCd", request.getParameter("issCd"));
		params.put("clmFileDate", request.getParameter("clmFileDate"));
		log.info("Getting Unpaid Premium : "+params);
		params = this.gipiInstallmentDAO.getUnpaidPremiumDtls(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}

	@Override
	public Integer checkInstNoGIACS007(Map<String, Object> param)
			throws SQLException {
		log.info("Checking Inst No...");
		return this.gipiInstallmentDAO.checkInstNoGIACS007(param);
	}

	@Override
	public JSONObject getInvoicePaytermsInfo(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getInvoicePaytermsInfo");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", (request.getParameter("premSeqNo") != null && !request.getParameter("premSeqNo").equals("")) ? Integer.parseInt(request.getParameter("premSeqNo")) : null);
		params.put("itemGrp", (request.getParameter("itemGrp") != null && !request.getParameter("itemGrp").equals("")) ? Integer.parseInt(request.getParameter("itemGrp")) : null);
		
		Map<String, Object> paytermsList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(paytermsList);
		return json;
	}
}
