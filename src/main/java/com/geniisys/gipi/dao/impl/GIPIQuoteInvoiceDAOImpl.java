/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISQuoteInvSeq;
import com.geniisys.common.entity.GIISTaxPeril;
import com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO;
import com.geniisys.gipi.entity.GIPIQuoteInvTax;
import com.geniisys.gipi.entity.GIPIQuoteInvoice;
import com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIPIQuoteInvoiceDAOImpl.
 */
public class GIPIQuoteInvoiceDAOImpl implements GIPIQuoteInvoiceDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteInvoiceDAOImpl.class);

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvoiceSummaryList(int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteInvoiceSummary> getGIPIQuoteInvoiceSummaryList(Integer quoteId)
			throws SQLException {
		log.info("DAO calling getGIPIQuoteInvoiceSummaryList Params:("+quoteId+")");
		return getSqlMapClient().queryForList("getGIPIQuoteInvSummary", quoteId);
	}
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#deleteGIPIQuoteInvoice(int, int)
	 */
	@Override
	public void deleteGIPIQuoteInvoice(Integer quoteId, Integer quoteInvNo) throws SQLException {
		log.info("Deleting GIPIQuoteInvoice [quoteId=" + quoteId + ",quoteInvNo=" + quoteInvNo + "]");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("quoteInvNo", quoteInvNo);
		this.getSqlMapClient().delete("deleteGIPIQuoteInvoice", params);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvoice(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoice(Integer quoteId)
			throws SQLException {
		log.info("Get Quote Invoice listing having quoteId=" + quoteId);
		return getSqlMapClient().queryForList("getInvoiceByQuoteId", quoteId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvoices(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoices(Integer quoteId,
			String issCd, String lineCd) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println("get invoice from db using quoteId = " + quoteId);
		params.put("quoteId", quoteId);
		System.out.println("get invoice from db using quoteId = " + issCd);
		params.put("issCd", issCd);
		
		List<GIPIQuoteInvoice> quoteInvoices = (List<GIPIQuoteInvoice>)getSqlMapClient().queryForList("getGIPIQuoteInvoices", params);
		List<GIPIQuoteInvTax> invTaxes = null;
		List<GIISTaxPeril> defaultInvoiceTaxes = null;
		params.clear();
		for(GIPIQuoteInvoice invoice: quoteInvoices){
			BigDecimal prim = invoice.getPremAmt();
			BigDecimal taxam = invoice.getTaxAmt();
			
			if(prim==null){
				System.out.println("n1");
				prim = new BigDecimal(0);
			}
			if(taxam==null){
				System.out.println("n2");
				taxam = new BigDecimal(0);
			}
			
			invoice.setAmountDue(prim.add(taxam));
//			invoice.setAmountDue(invoice.getPremAmt().add(invoice.getTaxAmt()));
			params.put("issCd", issCd);
			params.put("lineCd", lineCd);
			params.put("quoteInvNo", invoice.getQuoteInvNo());
			invTaxes = getSqlMapClient().queryForList("getGIPIQuoteInvTax", params);
			params.clear();
			params.put("issCd", issCd);
			params.put("lineCd", lineCd);
			defaultInvoiceTaxes = (List<GIISTaxPeril>)this.getSqlMapClient().queryForList("getRequiredTaxPerilListing", params);
			
			invoice.setDefaultInvoiceTaxes(defaultInvoiceTaxes);
			invoice.setInvoiceTaxes(invTaxes);
			
			if((invoice.getTaxAmt() == null || invoice.getTaxAmt() == BigDecimal.ZERO) && invoice.getInvoiceTaxes().size() > 0){
				invoice.setTaxAmt(computeTaxAmount(invoice.getInvoiceTaxes()));
			}
			
		}
		return quoteInvoices;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvSeq(java.lang.String)
	 */
	@Override
	public GIISQuoteInvSeq getGIPIQuoteInvSeq(String issCd, String userId)
			throws SQLException {
		log.info("Get GIISQuoteInvSeq [issCd=" + issCd + "]");
		
		GIISQuoteInvSeq seq = (GIISQuoteInvSeq) getSqlMapClient().queryForObject("getGIPIQuoteInvSeq", issCd);
		if(seq==null){
			log.info("getGIPIQuoteInvSeq NEW invoice SEQUENCE CREATED");
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", issCd);
			params.put("userId", userId);
			getSqlMapClient().insert("setNewIssSequence", params); // sequence set to 1
			System.out.println("null sequence");
			seq = new GIISQuoteInvSeq();
			seq.setQuoteInvNo(0);
			seq.setUserId(userId);
		}
		
		return seq; // (GIISQuoteInvSeq) getSqlMapClient().queryForObject("getGIPIQuoteInvSeq", issCd);
	}

	/**
	 * Manually compute the total tax amount from the invoiceTaxList
	 * @param invoiceTaxList
	 * @return total tax amount - BigDecimal
	 */
	private BigDecimal computeTaxAmount(List<GIPIQuoteInvTax> invoiceTaxList){
		BigDecimal totalTaxAmount = new BigDecimal(0);
		
		for(GIPIQuoteInvTax invoiceTax: invoiceTaxList){
			totalTaxAmount = totalTaxAmount.add(invoiceTax.getTaxAmt());
		}
		
		return totalTaxAmount;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#saveGIPIQuoteInvoice(com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary, java.lang.String)
	 */
	@Override
	public boolean saveGIPIQuoteInvoice(GIPIQuoteInvoiceSummary gipiQuoteInv, String issCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gipiQuoteInv", 	gipiQuoteInv);					params.put("quoteId", 	gipiQuoteInv.getQuoteId());
		params.put("quoteInvNo", 	gipiQuoteInv.getQuoteInvNo());	params.put("currencyCd", gipiQuoteInv.getCurrencyCd());
		params.put("currencyRt", 	gipiQuoteInv.getCurrencyRt());	params.put("premAmt", 	gipiQuoteInv.getPremAmt());
		params.put("intmNo", 		gipiQuoteInv.getIntmNo());		params.put("intmName", 	gipiQuoteInv.getIntmName());
		params.put("totalTaxAmt", 	gipiQuoteInv.getTotalTaxAmt());	params.put("taxCd", 	gipiQuoteInv.getTaxCd());
		params.put("taxDesc", 		gipiQuoteInv.getTaxDesc());		params.put("taxAmt", 	gipiQuoteInv.getTaxAmt());
		params.put("amountDue", 	gipiQuoteInv.getAmountDue());	params.put("taxId", 	gipiQuoteInv.getTaxId());
		params.put("rate", 			gipiQuoteInv.getRate());		params.put("invNo",	 	gipiQuoteInv.getInvNo());
		params.put("issCd", issCd);									params.put("currencyDesc", gipiQuoteInv.getCurrencyDesc());
		
		log.info("DAO calling saveGIPIQuoteInvoiceSummaryList Params:("+params+")");
		this.getSqlMapClient().insert("saveGIPIQuoteInvoice",params);
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvoiceByQuoteId(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoiceByQuoteId(Integer quoteId)
			throws SQLException {
		log.info("Loading gipiQuoteInvoice params:[quoteId=" + quoteId + "]");
		return this.getSqlMapClient().queryForList("getInvoiceByQuoteId", quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvoiceByCurrency(int, int, java.math.BigDecimal)
	 */
	@Override
	public GIPIQuoteInvoice getGIPIQuoteInvoiceByCurrency(Integer quoteId,
			Integer currencyCd, BigDecimal currencyRate, String lineCd, String issCd) throws SQLException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("quoteId", quoteId);
		parameters.put("currencyCd", currencyCd);
		parameters.put("currencyRate", currencyRate);
		parameters.put("issCd", issCd);
		
		log.info("get GIPIQuoteInvoice by Currency [quoteId=" + quoteId + ",currencyCd=" + currencyCd + ",currencyRate=" + currencyRate + "]" + issCd);
		return (GIPIQuoteInvoice)this.getSqlMapClient().queryForObject("getInvoiceByQuoteIdAndCurrency", parameters);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getGIPIQuoteInvoiceForPackQuotation(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteInvoice> getGIPIQuoteInvoiceForPackQuotation(
			Integer packQuoteId) throws SQLException {
		log.info("getGIPIQuoteInvoiceForPackQuotation");
		return this.getSqlMapClient().queryForList("getGIPIQuoteInvoicesForPackQuotation", packQuoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteInvoiceDAO#getCurrentInvoiceSequence(java.lang.String)
	 */
	@Override
	public Integer getCurrentInvoiceSequence(String issCd, String userId) throws SQLException {
		log.info("getCurrentInvoiceSequence");
		Integer tmp = (Integer) this.getSqlMapClient().queryForObject("getCurrentInvSeq", issCd);
		if(tmp==null){
			log.info("getCurrentInvoiceSequence NEW invoice SEQUENCE CREATED");
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", issCd);
			params.put("userId", userId);
			getSqlMapClient().insert("setNewIssSequence", params);
			return 1;
		}
		return tmp;
	}
}