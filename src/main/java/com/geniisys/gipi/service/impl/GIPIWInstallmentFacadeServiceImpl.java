/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWInstallmentDAO;
import com.geniisys.gipi.entity.GIPIWInstallment;
import com.geniisys.gipi.service.GIPIWInstallmentFacadeService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWinvTaxFacadeService;


/**
 * The Class GIPIWInstallmentFacadeServiceImpl.
 */
public class GIPIWInstallmentFacadeServiceImpl implements GIPIWInstallmentFacadeService {

/** The gipi w installment dao. */
private GIPIWInstallmentDAO  gipiWInstallmentDao;
private GIPIWinvTaxFacadeService gipiWinvTaxFacadeService;
private GIPIWInvoiceFacadeService gipiWInvoiceFacadeService;


	/**
 * @return the gipiWInvoiceFacadeService
 */
public GIPIWInvoiceFacadeService getGipiWInvoiceFacadeService() {
	return gipiWInvoiceFacadeService;
}

/**
 * @param gipiWInvoiceFacadeService the gipiWInvoiceFacadeService to set
 */
public void setGipiWInvoiceFacadeService(
		GIPIWInvoiceFacadeService gipiWInvoiceFacadeService) {
	this.gipiWInvoiceFacadeService = gipiWInvoiceFacadeService;
}

	/**
 * @return the gipiWinvTaxFacadeService
 */
public GIPIWinvTaxFacadeService getGipiWinvTaxFacadeService() {
	return gipiWinvTaxFacadeService;
}

/**
 * @param gipiWinvTaxFacadeService the gipiWinvTaxFacadeService to set
 */
public void setGipiWinvTaxFacadeService(
		GIPIWinvTaxFacadeService gipiWinvTaxFacadeService) {
	this.gipiWinvTaxFacadeService = gipiWinvTaxFacadeService;
}

	/**
	 * Sets the gipi w installment dao.
	 * 
	 * @param gipiWInstallmentDAO the new gipi w installment dao
	 */
	public void setGipiWInstallmentDAO(GIPIWInstallmentDAO gipiWInstallmentDAO) {
		this.gipiWInstallmentDao = gipiWInstallmentDAO;
	}
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWInstallmentFacadeServiceImpl.class);
	
	/**
	 * Gets the gipi w installment dao.
	 * 
	 * @return the gipi w installment dao
	 */
	public GIPIWInstallmentDAO getGipiWInstallmentDAO() {
		return gipiWInstallmentDao;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInstallmentFacadeService#getGIPIWInstallment(int, int, int)
	 */
	@Override
	public List<GIPIWInstallment> getGIPIWInstallment(int parId, int itemGrp, int takeupSeqNo) throws SQLException {
		log.info("Retrieving WInstallment...");
		List<GIPIWInstallment> gipiWInstallment = gipiWInstallmentDao.getGIPIWInstallment(parId, itemGrp, takeupSeqNo);
		log.info("WInstallment Size():" + gipiWInstallment.size());
		return gipiWInstallment;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInstallmentFacadeService#deleteGIPIWinstallment(int)
	 */
	@Override
	public boolean deleteGIPIWinstallment(int parId) throws SQLException {
		log.info("Deleting all Winstallment. . .");
			this.getGipiWInstallmentDAO().deleteGIPIWinstallment(parId);
		log.info("Winstallment deleted!");
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInstallmentFacadeService#saveGIPIWInstallment(java.util.Map)
	 */
	@Override
	public boolean saveGIPIWInstallment(Map<String, Object> parameters)
			throws SQLException {
		Integer parId = (Integer) parameters.get("parId");
		Integer itemGrp = (Integer) parameters.get("itemGrp");
		String[] tsNo = (String[]) parameters.get("takeupSeqNo");
		Date instDueDate = (Date) parameters.get("dueDate");
		String[] instNo = (String[]) parameters.get("instNo");
		String[] instSharePct = (String[]) parameters.get("sharePct");
		String[] instPremAmt = (String[]) parameters.get("premAmt");
		String[] instTaxAmt = (String[]) parameters.get("taxAmt");
		String[] instAmtDue = (String[]) parameters.get("totalDue");
		BigDecimal instTotalSharePct = (BigDecimal) parameters.get("totalSharePct");
		BigDecimal instTotalPremAmt = (BigDecimal) parameters.get("totalPremAmt");
		BigDecimal instTotalTaxAmt = (BigDecimal) parameters.get("totalTaxAmt");
		BigDecimal instTotalAmountDue = (BigDecimal) parameters.get("totalAmountDue");
		System.out.println("installment takeup" + instNo);
		GIPIWInstallment winstallment = null;
		
		for(int i=0; i < tsNo.length; i++){
			winstallment = new GIPIWInstallment();
			
			winstallment.setDueDate(instDueDate);
			winstallment.setItemGrp(itemGrp);
			winstallment.setInstNo(Integer.parseInt(instNo[i]));
			winstallment.setSharePct(new BigDecimal(instSharePct[i]));
			winstallment.setPremAmt(new BigDecimal(instPremAmt[i]));
			winstallment.setTaxAmt(new BigDecimal(instTaxAmt[i]));
			winstallment.setTakeupSeqNo(Integer.parseInt(tsNo[i]));
			winstallment.setParId(parId);
			winstallment.setTotalDue(new BigDecimal(instAmtDue[i]));
			winstallment.setTotalSharePct(instTotalSharePct);
			winstallment.setTotalPremAmt(instTotalPremAmt);
			winstallment.setTotalTaxAmt(instTotalTaxAmt);
			winstallment.setTotalAmountDue(instTotalAmountDue);
			
			this.getGipiWInstallmentDAO().saveGIPIWInstallment(winstallment);
		}
		
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInstallmentFacadeService#doPaytermComputation(java.lang.Integer, java.lang.String, java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, Object> doPaytermComputation(Map<String, Object> params) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(params.get("parameters").toString());
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("paytermParams", params); 
		allParams.put("addedModifiedWinvTax", gipiWinvTaxFacadeService.prepareAddModifiedTaxInfo(new JSONArray(objParameters.getString("addedModifiedWinvTax"))));
		allParams.put("deletedWinvTax", gipiWinvTaxFacadeService.prepareTaxInfoToDelete(new JSONArray(objParameters.getString("deletedWinvTax"))));
		allParams.put("allWInvoiceDtls", gipiWInvoiceFacadeService.prepareWInvoice2(new JSONArray(objParameters.getString("allWInvoiceDtls"))));
		log.info("computing payment terms. . . ");
		this.getGipiWInstallmentDAO().doPaytermComputation(allParams);
		log.info("payment terms computed!");
		return params;
	}

	@Override
	public List<GIPIWInstallment> getAllGIPIWInstallment(int parId)	throws SQLException {
		log.info("Retrieving WInstallment...");
		List<GIPIWInstallment> gipiWInstallment = gipiWInstallmentDao.getAllGIPIWInstallment(parId);
		log.info("WInstallment Size():" + gipiWInstallment.size());
		return gipiWInstallment;
	}
	
}
