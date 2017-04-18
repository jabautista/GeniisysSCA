/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIWPolBasic.
 */
public class GIPIWPolBasic extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The par id. */
	private Integer parId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The iss cd. */
	private String issCd;
	
	/** The foreign acc sw. */
	private String foreignAccSw;
	
	/** The invoice sw. */
	private String invoiceSw;
	
	/** The quotation printed sw. */
	private String quotationPrintedSw;
	
	/** The covernote printed sw. */
	private String covernotePrintedSw;
	
	/** The auto renew flag. */
	private String autoRenewFlag;
	
	/** The prov prem tag. */
	private String provPremTag;
	
	/** The same polno sw. */
	private String samePolnoSw;
	
	/** The reg policy sw. */
	private String regPolicySw;
	
	/** The co insurance sw. */
	private String coInsuranceSw;
	
	/** The manual renew no. */
	private Integer manualRenewNo;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The prorate flag. */
	private String prorateFlag;
	
	/** The endt expiry date. */
	private Date endtExpiryDate;
	
	/** The eff date. */
	private Date effDate;
	
	/** The short rt percent. */
	private BigDecimal shortRtPercent;
	
	/** The prov prem pct. */
	private BigDecimal provPremPct;
	
	/** The expiry date. */
	private Date expiryDate;
	
	/** The with tariff sw. */
	private String withTariffSw;
	
	/** The comp sw. */
	private String compSw;
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}
	
	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	/**
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}
	
	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	/**
	 * Gets the foreign acc sw.
	 * 
	 * @return the foreign acc sw
	 */
	public String getForeignAccSw() {
		return foreignAccSw;
	}
	
	/**
	 * Sets the foreign acc sw.
	 * 
	 * @param foreignAccSw the new foreign acc sw
	 */
	public void setForeignAccSw(String foreignAccSw) {
		this.foreignAccSw = foreignAccSw;
	}
	
	/**
	 * Gets the invoice sw.
	 * 
	 * @return the invoice sw
	 */
	public String getInvoiceSw() {
		return invoiceSw;
	}
	
	/**
	 * Sets the invoice sw.
	 * 
	 * @param invoiceSw the new invoice sw
	 */
	public void setInvoiceSw(String invoiceSw) {
		this.invoiceSw = invoiceSw;
	}
	
	/**
	 * Gets the quotation printed sw.
	 * 
	 * @return the quotation printed sw
	 */
	public String getQuotationPrintedSw() {
		return quotationPrintedSw;
	}
	
	/**
	 * Sets the quotation printed sw.
	 * 
	 * @param quotationPrintedSw the new quotation printed sw
	 */
	public void setQuotationPrintedSw(String quotationPrintedSw) {
		this.quotationPrintedSw = quotationPrintedSw;
	}
	
	/**
	 * Gets the covernote printed sw.
	 * 
	 * @return the covernote printed sw
	 */
	public String getCovernotePrintedSw() {
		return covernotePrintedSw;
	}
	
	/**
	 * Sets the covernote printed sw.
	 * 
	 * @param covernotePrintedSw the new covernote printed sw
	 */
	public void setCovernotePrintedSw(String covernotePrintedSw) {
		this.covernotePrintedSw = covernotePrintedSw;
	}
	
	/**
	 * Gets the auto renew flag.
	 * 
	 * @return the auto renew flag
	 */
	public String getAutoRenewFlag() {
		return autoRenewFlag;
	}
	
	/**
	 * Sets the auto renew flag.
	 * 
	 * @param autoRenewFlag the new auto renew flag
	 */
	public void setAutoRenewFlag(String autoRenewFlag) {
		this.autoRenewFlag = autoRenewFlag;
	}
	
	/**
	 * Gets the prov prem tag.
	 * 
	 * @return the prov prem tag
	 */
	public String getProvPremTag() {
		return provPremTag;
	}
	
	/**
	 * Sets the prov prem tag.
	 * 
	 * @param provPremTag the new prov prem tag
	 */
	public void setProvPremTag(String provPremTag) {
		this.provPremTag = provPremTag;
	}
	
	/**
	 * Gets the same polno sw.
	 * 
	 * @return the same polno sw
	 */
	public String getSamePolnoSw() {
		return samePolnoSw;
	}
	
	/**
	 * Sets the same polno sw.
	 * 
	 * @param samePolnoSw the new same polno sw
	 */
	public void setSamePolnoSw(String samePolnoSw) {
		this.samePolnoSw = samePolnoSw;
	}
	
	/**
	 * Gets the reg policy sw.
	 * 
	 * @return the reg policy sw
	 */
	public String getRegPolicySw() {
		return regPolicySw;
	}
	
	/**
	 * Sets the reg policy sw.
	 * 
	 * @param regPolicySw the new reg policy sw
	 */
	public void setRegPolicySw(String regPolicySw) {
		this.regPolicySw = regPolicySw;
	}
	
	/**
	 * Gets the co insurance sw.
	 * 
	 * @return the co insurance sw
	 */
	public String getCoInsuranceSw() {
		return coInsuranceSw;
	}
	
	/**
	 * Sets the co insurance sw.
	 * 
	 * @param coInsuranceSw the new co insurance sw
	 */
	public void setCoInsuranceSw(String coInsuranceSw) {
		this.coInsuranceSw = coInsuranceSw;
	}
	
	/**
	 * Gets the manual renew no.
	 * 
	 * @return the manual renew no
	 */
	public Integer getManualRenewNo() {
		return manualRenewNo;
	}
	
	/**
	 * Sets the manual renew no.
	 * 
	 * @param manualRenewNo the new manual renew no
	 */
	public void setManualRenewNo(Integer manualRenewNo) {
		this.manualRenewNo = manualRenewNo;
	}
	
	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}
	
	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	
	/**
	 * Gets the prorate flag.
	 * 
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}
	
	/**
	 * Sets the prorate flag.
	 * 
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}
	
	/**
	 * Gets the endt expiry date.
	 * 
	 * @return the endt expiry date
	 */
	public Date getEndtExpiryDate() {
		return endtExpiryDate;
	}
	
	/**
	 * Sets the endt expiry date.
	 * 
	 * @param endtExpiryDate the new endt expiry date
	 */
	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}
	
	/**
	 * Gets the eff date.
	 * 
	 * @return the eff date
	 */
	public Date getEffDate() {
		return effDate;
	}
	
	/**
	 * Sets the eff date.
	 * 
	 * @param effDate the new eff date
	 */
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	
	/**
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}
	
	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}
	
	/**
	 * Gets the prov prem pct.
	 * 
	 * @return the prov prem pct
	 */
	public BigDecimal getProvPremPct() {
		return provPremPct;
	}
	
	/**
	 * Sets the prov prem pct.
	 * 
	 * @param provPremPct the new prov prem pct
	 */
	public void setProvPremPct(BigDecimal provPremPct) {
		this.provPremPct = provPremPct;
	}
	
	/**
	 * Gets the expiry date.
	 * 
	 * @return the expiry date
	 */
	public Date getExpiryDate() {
		return expiryDate;
	}
	
	/**
	 * Sets the expiry date.
	 * 
	 * @param expiryDate the new expiry date
	 */
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	/**
	 * Gets the with tariff sw.
	 * 
	 * @return the with tariff sw
	 */
	public String getWithTariffSw() {
		return withTariffSw;
	}
	
	/**
	 * Sets the with tariff sw.
	 * 
	 * @param withTariffSw the new with tariff sw
	 */
	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}
	
	/**
	 * Sets the comp sw.
	 * 
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}
	
	/**
	 * Gets the comp sw.
	 * 
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}

}
