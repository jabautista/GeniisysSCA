package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIMortgagee extends BaseEntity{
	
	private Integer policyId;		
	private String issCd;		
	private Integer itemNo;		
	private String mortgCd;		
	private BigDecimal amount;		
	private String remarks;		
	private Date lastUpdate;		
	private String userId;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String deleteSw;		
	private String arcExtData;
	private String mortgName;
	private BigDecimal sumAmount;
	private Integer quote_id; // added for package quotation mortagees 5.2.2011
	private Integer pack_quote_id;// added for package quotation mortagees 5.2.2011
	private Integer itemNoDisplay;
	
	public GIPIMortgagee() {
		super();
	}

	public GIPIMortgagee(Integer policyId, String issCd, Integer itemNo,
			String mortgCd, BigDecimal amount, String remarks, Date lastUpdate,
			String userId, Integer cpiRecNo, String cpiBranchCd,
			String deleteSw, String arcExtData) {
		super();
		this.policyId = policyId;
		this.issCd = issCd;
		this.itemNo = itemNo;
		this.mortgCd = mortgCd;
		this.amount = amount;
		this.remarks = remarks;
		this.lastUpdate = lastUpdate;
		this.userId = userId;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.deleteSw = deleteSw;
		this.arcExtData = arcExtData;
	}

	
	public Integer getQuote_id() {
		return quote_id;
	}

	public void setQuote_id(Integer quoteId) {
		quote_id = quoteId;
	}

	public Integer getPack_quote_id() {
		return pack_quote_id;
	}

	public void setPack_quote_id(Integer packQuoteId) {
		pack_quote_id = packQuoteId;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getMortgCd() {
		return mortgCd;
	}

	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getDeleteSw() {
		return deleteSw;
	}

	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getMortgName() {
		return mortgName;
	}

	public void setMortgName(String mortgName) {
		this.mortgName = mortgName;
	}

	public BigDecimal getSumAmount() {
		return sumAmount;
	}

	public void setSumAmount(BigDecimal sumAmount) {
		this.sumAmount = sumAmount;
	}

	public Integer getItemNoDisplay() {
		return itemNoDisplay;
	}

	public void setItemNoDisplay(Integer itemNoDisplay) {
		this.itemNoDisplay = itemNoDisplay;
	}		

	
	
}
