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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISQuoteInvSeq;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO;
import com.geniisys.gipi.entity.GIPIQuoteInvTax;
import com.geniisys.gipi.entity.GIPIQuoteInvoice;
import com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary;
import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService;

/**
 * The Class GIPIQuoteInvoiceFacadeServiceImpl.
 */
public class GIPIQuoteInvoiceFacadeServiceImpl implements GIPIQuoteInvoiceFacadeService {

	/** The gipi quote invoice dao. */
	private GIPIQuoteInvoiceDAO gipiQuoteInvoiceDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteInvoiceFacadeServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvoiceSummaryList(int)
	 */
	@Override
	public List<GIPIQuoteInvoiceSummary> getGIPIQuoteInvoiceSummaryList(Integer quoteId) throws SQLException {
		return gipiQuoteInvoiceDAO.getGIPIQuoteInvoiceSummaryList(quoteId);		
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvoices(java.lang.Integer, java.lang.String)
	 */
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoices(Integer quoteId,
			String issCd, String lineCd) throws SQLException {
		return gipiQuoteInvoiceDAO.getGIPIQuoteInvoices(quoteId, issCd, lineCd);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#deleteGIPIQuoteInvoice(int, int)
	 */
	@Override
	public void deleteGIPIQuoteInvoice(Integer quoteId, Integer quoteInvNo) throws SQLException {
		this.gipiQuoteInvoiceDAO.deleteGIPIQuoteInvoice(quoteId,quoteInvNo);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#saveGIPIQuoteInvoice(java.util.Map)
	 */
	@Override
	public void saveGIPIQuoteInvoice(Map<String, Object> params)
			throws SQLException {
		HttpServletRequest request 	= (HttpServletRequest) params.get("request");		
		String[] itemNo				= request.getParameterValues("invItemNo");
		
		for(int i = 0; i < itemNo.length; i++){
			String saveTag		= request.getParameter("saveInvoiceTag" + itemNo[i]);
			
			if(saveTag.equalsIgnoreCase("Y")){
				Integer quoteId 	= Integer.parseInt(request.getParameter("quoteId"));
				
				String 		invNo 		= request.getParameter("iInvoiceNumber" 		+ itemNo[i]);
				Integer		invInt		= Integer.valueOf(invNo.replace(" ", "").substring(invNo.indexOf("-"))).intValue();
				Integer 	currCd 		= Integer.parseInt(	request.getParameter("iCurrencyCode" 		+ itemNo[i]));
				String 		currDesc	= request.getParameter("iCurrencyDescription" + itemNo[i]);
				BigDecimal 	currRate 	= new BigDecimal(	request.getParameter("iCurrencyRate" 		+ itemNo[i]));
				BigDecimal 	premAmt 	= new BigDecimal(	request.getParameter("iPremiumAmount"		+ itemNo[i]));
				
				Integer intmNo = null;		String intmName = null;

				if(!request.getParameter("iIntermediaryNumber" 	+ itemNo[i]).equals("")){
					intmNo 		= Integer.parseInt(	request.getParameter("iIntermediaryNumber" 	+ itemNo[i]));
					intmName	= request.getParameter("intmName"			+ itemNo[i]);
				}
				
				BigDecimal 	totalTaxAmt	= new BigDecimal(	request.getParameter("iTaxAmount" + itemNo[i]).replace(",", ""));
				BigDecimal 	amtDue 	= new BigDecimal(	request.getParameter("iAmountDue" + itemNo[i]).replace(",", ""));
				String		issCd 	= request.getParameter("iIssCd" + itemNo[i]);

				String[] taxCodes 	= request.getParameterValues("taxCode"  + itemNo[i]);
				String[] taxDescs 	= request.getParameterValues("taxDesc"  + itemNo[i]);
				String[] taxAmts 	= request.getParameterValues("taxAmount"+ itemNo[i]);
				String[] taxIds 	= request.getParameterValues("taxId"    + itemNo[i]);
				String[] rates 		= request.getParameterValues("rateInv"  + itemNo[i]);
				
				log.info("Deleting invoice record "+ invInt+" ...");
				this.gipiQuoteInvoiceDAO.deleteGIPIQuoteInvoice(quoteId, invInt);

				GIPIQuoteInvoiceSummary inv = null;
				if (taxCodes != null) {
					for(int in=0; in<taxCodes.length; in++){
						inv = new GIPIQuoteInvoiceSummary(
								Integer.valueOf(quoteId).intValue(),		Integer.valueOf(invInt).intValue(),
								invNo,		Integer.valueOf(currCd).intValue(),		currDesc,				
								currRate,	premAmt,	intmNo,		intmName,		totalTaxAmt,
								(taxCodes[in] == null) 	? 0 : Integer.parseInt(taxCodes[in]),
								taxDescs[in],
								(taxAmts[in] == null) 	? new BigDecimal("0") : new BigDecimal(taxAmts[in].replaceAll(",", "")),
								amtDue,
								(taxIds[in] == null) 	? 0 : Integer.parseInt(taxIds[in]),
								(rates[in] == null) 	? new BigDecimal("0") : new BigDecimal(rates[in]));
						log.info("Saving Invoice Information...");
						this.gipiQuoteInvoiceDAO.saveGIPIQuoteInvoice(inv, issCd);
					}
				}
			}
		}
	}
	
	/**
	 * Gets the gipi quote invoice dao.
	 * @return the gipi quote invoice dao
	 */
	public GIPIQuoteInvoiceDAO getGipiQuoteInvoiceDAO() {
		return gipiQuoteInvoiceDAO;
	}
	
	/**
	 * Sets the gipi quote invoice dao.
	 * @param gipiQuoteInvoiceDAO the new gipi quote invoice dao
	 */
	public void setGipiQuoteInvoiceDAO(GIPIQuoteInvoiceDAO gipiQuoteInvoiceDAO) {
		this.gipiQuoteInvoiceDAO = gipiQuoteInvoiceDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvoice(int)
	 */
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoice(Integer quoteId)
			throws SQLException {
		return gipiQuoteInvoiceDAO.getGIPIQuoteInvoice(quoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvSeq(java.lang.String)
	 */
	@Override
	public GIISQuoteInvSeq getGIPIQuoteInvSeq(String issCd, String userId) throws SQLException {
		return gipiQuoteInvoiceDAO.getGIPIQuoteInvSeq(issCd, userId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#saveGIPIQuoteInvoice(java.lang.String, com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary)
	 */
	@Override
	public void saveGIPIQuoteInvoice(String issCd, GIPIQuoteInvoiceSummary gipiQuoteInv) throws SQLException {
		this.getGipiQuoteInvoiceDAO().saveGIPIQuoteInvoice(gipiQuoteInv, issCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvoiceByQuoteId(int)
	 */
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoiceByQuoteId(Integer quoteId)
			throws SQLException {
		return this.getGipiQuoteInvoiceDAO().getGIPIQuoteInvoiceByQuoteId(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvoiceByCurrency(int, int, java.math.BigDecimal)
	 */
	@Override
	public GIPIQuoteInvoice getGIPIQuoteInvoiceByCurrency(Integer quoteId,
			Integer currencyCd, BigDecimal currencyRate, String lineCd, String issCd) throws SQLException {
		return this.getGipiQuoteInvoiceDAO().getGIPIQuoteInvoiceByCurrency(quoteId, currencyCd, currencyRate, lineCd,issCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#prepareQuoteInvoiceJSON(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteInvoice> prepareQuoteInvoiceJSON(JSONArray rows, GIISUser USER)
			throws JSONException {
		GIPIQuoteInvoice gipiQuoteInvoice = null;
		GIPIQuoteInvTax gipiQuoteInvTax = null;
		List<GIPIQuoteInvoice> gipiQuoteInvoices = new ArrayList<GIPIQuoteInvoice>();
		List<GIPIQuoteInvTax> gipiQuoteInvTaxes = null;
		
		int recordStatus = 0;
		for(int index=0; index<rows.length(); index++){
			gipiQuoteInvoice = new GIPIQuoteInvoice();
			
			gipiQuoteInvoice.setAmountDue(rows.getJSONObject(index).isNull("amountDue") ? null : new BigDecimal(rows.getJSONObject(index).getDouble("amountDue")));
			recordStatus = rows.getJSONObject(index).isNull("recordStatus") ? 0 : rows.getJSONObject(index).getInt("recordStatus");
			
			if(recordStatus == 0){
				gipiQuoteInvoice.setCreateDate(USER.getCreateDate());
				gipiQuoteInvoice.setCreateUser(USER.getCreateUser());
			}
			
			gipiQuoteInvoice.setCurrencyCd(rows.getJSONObject(index).isNull("currencyCd") ? null : rows.getJSONObject(index).getInt("currencyCd"));
			gipiQuoteInvoice.setCurrencyRt(rows.getJSONObject(index).isNull("currencyRt") ? null : new BigDecimal(rows.getJSONObject(index).getDouble("currencyRt")));
			gipiQuoteInvoice.setIntmNo(rows.getJSONObject(index).isNull("intmNo") ? null : rows.getJSONObject(index).getInt("intmNo"));
			
			gipiQuoteInvTaxes 	= new ArrayList<GIPIQuoteInvTax>();
			JSONArray taxes 	= rows.getJSONObject(index).getJSONArray("invoiceTaxes");
			
			for(int i=0; i<taxes.length(); i++){ 
				gipiQuoteInvTax = new GIPIQuoteInvTax();
				gipiQuoteInvTax.setIssCd(taxes.getJSONObject(i).isNull("issCd") ? "" : taxes.getJSONObject(i).getString("issCd"));
				gipiQuoteInvTax.setLineCd(taxes.getJSONObject(i).isNull("lineCd") ? "" : taxes.getJSONObject(i).getString("lineCd"));
				gipiQuoteInvTax.setQuoteInvNo(taxes.getJSONObject(i).isNull("quoteInvNo") ? 0 : taxes.getJSONObject(i).getInt("quoteInvNo"));
				gipiQuoteInvTax.setTaxCd(taxes.getJSONObject(i).isNull("taxCd") ? 0 : taxes.getJSONObject(i).getInt("taxCd"));
				gipiQuoteInvTax.setTaxId(taxes.getJSONObject(i).isNull("taxId") ? 0 : taxes.getJSONObject(i).getInt("taxId")); //taxId
				
				gipiQuoteInvTax.setRate(new BigDecimal(taxes.getJSONObject(i).isNull("rate") ? 0 : 
					(taxes.getJSONObject(i).getString("rate").isEmpty() ? 0 : taxes.getJSONObject(i).getDouble("rate")))
				);
				
				gipiQuoteInvTax.setTaxAmt(new BigDecimal(taxes.getJSONObject(i).isNull("taxAmt") ? 0 : taxes.getJSONObject(i).getDouble("taxAmt")));//taxAmt
				gipiQuoteInvTax.setRecordStatus(taxes.getJSONObject(i).isNull("recordStatus") ? 0 : taxes.getJSONObject(i).getInt("recordStatus"));
				gipiQuoteInvTaxes.add(gipiQuoteInvTax);
			}
			
			gipiQuoteInvoice.setInvoiceTaxes(gipiQuoteInvTaxes);
			gipiQuoteInvoice.setIssCd(rows.getJSONObject(index).isNull("issCd") ? null: rows.getJSONObject(index).getString("issCd"));
			gipiQuoteInvoice.setLastUpdate(new Date());
			//gipiQuoteInvoice.setPremAmt(rows.getJSONObject(index).isNull("premAmt") ? null: new BigDecimal(rows.getJSONObject(index).getString("premAmt")));
			gipiQuoteInvoice.setPremAmt(JSONUtil.getBigDecimal(rows, index, "premAmt"));
			gipiQuoteInvoice.setQuoteId(rows.getJSONObject(index).isNull("quoteId") ? null: rows.getJSONObject(index).getInt("quoteId"));
			gipiQuoteInvoice.setQuoteInvNo(rows.getJSONObject(index).isNull("quoteInvNo") ? null: rows.getJSONObject(index).getInt("quoteInvNo"));
			gipiQuoteInvoice.setTaxAmt(rows.getJSONObject(index).isNull("taxAmt") ? null: new BigDecimal(rows.getJSONObject(index).getDouble("taxAmt")));
			gipiQuoteInvoice.setUserId(USER.getUserId());

			gipiQuoteInvoices.add(gipiQuoteInvoice);	
		}
		
			System.out.println("DEV: gipiQuoteInvoices FINAL SIZE = " + gipiQuoteInvoices.size());
		return gipiQuoteInvoices;
	}
	
	/**
	 * 
	 * @param itemPerils
	 * @return
	 */
	public GIPIQuoteInvoice generateInvoiceFromPerilList(List<GIPIQuoteItemPeril> itemPerils){
		log.info("generating invoice from peril list");
		
		
		return null;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getGIPIQuoteInvoiceForPackQuotation(java.lang.Integer)
	 */
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoiceForPackQuotation(
			Integer packQuoteId) throws SQLException {
		return this.getGipiQuoteInvoiceDAO().getGIPIQuoteInvoiceForPackQuotation(packQuoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService#getCurrentInvSeq(java.lang.String)
	 */
	@Override
	public Integer getCurrentInvoiceSequence(String issCd, String userId) throws SQLException {
		return this.getGipiQuoteInvoiceDAO().getCurrentInvoiceSequence(issCd, userId);
	}
}