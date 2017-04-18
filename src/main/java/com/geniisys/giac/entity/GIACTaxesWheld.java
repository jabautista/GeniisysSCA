/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 17, 2010
 ***************************************************/
package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIACTaxesWheld extends BaseEntity{
	private Integer 	adviceId;
	private Integer 	claimId;
	private String 		cpiBranchCd;
	private Integer 	cpiRecNo;
	private Integer 	gaccTranId;
	private String 		generationType;
	private Integer 	gwtxWhtaxId;
	private Integer		itemNo;
	private String 		orPrintTag;
	private String		payeeClassCd;
	private Integer		payeeCd;
	private String 		remarks;
	private Integer 	slCd;
	private String 		slTypeCd;
	private BigDecimal  wholdingTaxAmt;
	private BigDecimal  incomeAmt;
	private String		genType;
	private String		userId;
	private Date		lastUpdate;
	
	// other block items
	private Integer		whtaxCode;
	private String		birTaxCd;
	private BigDecimal	percentRate;
	private String		whtaxDesc;
	private String		payeeFirstName;
	private String		payeeMiddleName;
	private String		payeeLastName;
	private String		drvPayeeCd;
	private String		slName;
	
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public BigDecimal getIncomeAmt() {
		return incomeAmt;
	}
	public void setIncomeAmt(BigDecimal incomeAmt) {
		this.incomeAmt = incomeAmt;
	}
	public String getGenType() {
		return genType;
	}
	public void setGenType(String genType) {
		this.genType = genType;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public Date getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public Integer getWhtaxCode() {
		return whtaxCode;
	}
	public void setWhtaxCode(Integer whtaxCode) {
		this.whtaxCode = whtaxCode;
	}
	public String getBirTaxCd() {
		return birTaxCd;
	}
	public void setBirTaxCd(String birTaxCd) {
		this.birTaxCd = birTaxCd;
	}
	public BigDecimal getPercentRate() {
		return percentRate;
	}
	public void setPercentRate(BigDecimal percentRate) {
		this.percentRate = percentRate;
	}
	public String getWhtaxDesc() {
		return whtaxDesc;
	}
	public void setWhtaxDesc(String whtaxDesc) {
		this.whtaxDesc = whtaxDesc;
	}
	public String getPayeeFirstName() {
		return payeeFirstName;
	}
	public void setPayeeFirstName(String payeeFirstName) {
		this.payeeFirstName = payeeFirstName;
	}
	public String getPayeeMiddleName() {
		return payeeMiddleName;
	}
	public void setPayeeMiddleName(String payeeMiddleName) {
		this.payeeMiddleName = payeeMiddleName;
	}
	public String getPayeeLastName() {
		return payeeLastName;
	}
	public void setPayeeLastName(String payeeLastName) {
		this.payeeLastName = payeeLastName;
	}
	public String getDrvPayeeCd() {
		return drvPayeeCd;
	}
	public void setDrvPayeeCd(String drvPayeeCd) {
		this.drvPayeeCd = drvPayeeCd;
	}
	public String getSlName() {
		return slName;
	}
	public void setSlName(String slName) {
		this.slName = slName;
	}
	public Integer getAdviceId() {
		return adviceId;
	}
	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	public String getGenerationType() {
		return generationType;
	}
	public void setGenerationType(String generationType) {
		this.generationType = generationType;
	}
	public Integer getGwtxWhtaxId() {
		return gwtxWhtaxId;
	}
	public void setGwtxWhtaxId(Integer gwtxWhtaxId) {
		this.gwtxWhtaxId = gwtxWhtaxId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public String getOrPrintTag() {
		return orPrintTag;
	}
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getSlCd() {
		return slCd;
	}
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}
	public String getSlTypeCd() {
		return slTypeCd;
	}
	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}
	public BigDecimal getWholdingTaxAmt() {
		return wholdingTaxAmt;
	}
	public void setWholdingTaxAmt(BigDecimal wholdingTaxAmt) {
		this.wholdingTaxAmt = wholdingTaxAmt;
	}
	
}
