package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIDeductibles extends BaseEntity{


	private Integer policyId;		
	private Integer itemNo;		
	private String dedLineCd;		
	private String dedSublineCd;		
	private String dedDeductibleCd;		
	private String deductibleText;		
	private BigDecimal deductibleAmt;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private BigDecimal deductibleRt;		
	private Integer perilCd;		
	private String aggregateSw;		
	private String ceilingSw;		
	private BigDecimal minAmt;		
	private BigDecimal maxAmt;		
	private String rangeSw;		
	private String arcExtData;		
	private String createUser;		
	private Date createDate;		
	private String userId;		
	private Date lastUpdate;
	
	private String deductibleTitle;
	private BigDecimal totalDeductibleAmt;
	private String itemTitle;
	
	public GIPIDeductibles() {
		super();
	}

	public GIPIDeductibles(Integer policyId, Integer itemNo, String dedLineCd,
			String dedSublineCd, String dedDeductibleCd,
			String dedDeductibleText, BigDecimal deductibleAmt,
			Integer cpiRecNo, String cpiBranchCd, BigDecimal deductibleRt,
			Integer perilCd, String aggregateSw, String ceilingSw,
			BigDecimal minAmt, BigDecimal maxAmt, String rangeSw,
			String arcExtData, String createUser, Date createDate,
			String userId, Date lastUpdate) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.dedLineCd = dedLineCd;
		this.dedSublineCd = dedSublineCd;
		this.dedDeductibleCd = dedDeductibleCd;
		this.setDeductibleText(dedDeductibleText);
		this.deductibleAmt = deductibleAmt;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.deductibleRt = deductibleRt;
		this.perilCd = perilCd;
		this.aggregateSw = aggregateSw;
		this.ceilingSw = ceilingSw;
		this.minAmt = minAmt;
		this.maxAmt = maxAmt;
		this.rangeSw = rangeSw;
		this.arcExtData = arcExtData;
		this.createUser = createUser;
		this.createDate = createDate;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
	}

	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getDedLineCd() {
		return dedLineCd;
	}

	public void setDedLineCd(String dedLineCd) {
		this.dedLineCd = dedLineCd;
	}

	public String getDedSublineCd() {
		return dedSublineCd;
	}

	public void setDedSublineCd(String dedSublineCd) {
		this.dedSublineCd = dedSublineCd;
	}

	public String getDedDeductibleCd() {
		return dedDeductibleCd;
	}

	public void setDedDeductibleCd(String dedDeductibleCd) {
		this.dedDeductibleCd = dedDeductibleCd;
	}



	public BigDecimal getDeductibleAmt() {
		return deductibleAmt;
	}

	public void setDeductibleAmt(BigDecimal deductibleAmt) {
		this.deductibleAmt = deductibleAmt;
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

	public BigDecimal getDeductibleRt() {
		return deductibleRt;
	}

	public void setDeductibleRt(BigDecimal deductibleRt) {
		this.deductibleRt = deductibleRt;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public String getAggregateSw() {
		return aggregateSw;
	}

	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}

	public String getCeilingSw() {
		return ceilingSw;
	}

	public void setCeilingSw(String ceilingSw) {
		this.ceilingSw = ceilingSw;
	}

	public BigDecimal getMinAmt() {
		return minAmt;
	}

	public void setMinAmt(BigDecimal minAmt) {
		this.minAmt = minAmt;
	}

	public BigDecimal getMaxAmt() {
		return maxAmt;
	}

	public void setMaxAmt(BigDecimal maxAmt) {
		this.maxAmt = maxAmt;
	}

	public String getRangeSw() {
		return rangeSw;
	}

	public void setRangeSw(String rangeSw) {
		this.rangeSw = rangeSw;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
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

	public String getDeductibleTitle() {
		return deductibleTitle;
	}

	public void setDeductibleTitle(String deductibleTitle) {
		this.deductibleTitle = deductibleTitle;
	}

	public BigDecimal getTotalDeductibleAmt() {
		return totalDeductibleAmt;
	}

	public void setTotalDeductibleAmt(BigDecimal totalDeductibleAmt) {
		this.totalDeductibleAmt = totalDeductibleAmt;
	}

	public void setDeductibleText(String deductibleText) {
		this.deductibleText = deductibleText;
	}

	public String getDeductibleText() {
		return deductibleText;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	
	

}
