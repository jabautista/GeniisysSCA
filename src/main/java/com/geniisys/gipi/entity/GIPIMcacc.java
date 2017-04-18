package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIPIMcacc extends BaseEntity{
	
	private Integer policyId;		
	private Integer itemNo;		
	private Integer accessoryCd;		
	private BigDecimal accAmt;		
	private String userId;		
	private Date lastUpdate;		
	private Integer cpiRecNo;		
	private String cpiBranchCd;		
	private String deleteSw;		
	private String arcExtData;
	
	private BigDecimal totalAccAmt;
	private String accessoryDesc;
	
	public GIPIMcacc() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public GIPIMcacc(Integer policyId, Integer itemNo, Integer accessoryCd,
			BigDecimal accAmt, String userId, Date lastUpdate,
			Integer cpiRecNo, String cpiBranchCd, String deleteSw,
			String arcExtData) {
		super();
		this.policyId = policyId;
		this.itemNo = itemNo;
		this.accessoryCd = accessoryCd;
		this.accAmt = accAmt;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.deleteSw = deleteSw;
		this.arcExtData = arcExtData;
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
	public Integer getAccessoryCd() {
		return accessoryCd;
	}
	public void setAccessoryCd(Integer accessoryCd) {
		this.accessoryCd = accessoryCd;
	}
	public BigDecimal getAccAmt() {
		return accAmt;
	}
	public void setAccAmt(BigDecimal accAmt) {
		this.accAmt = accAmt;
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

	public BigDecimal getTotalAccAmt() {
		return totalAccAmt;
	}

	public void setTotalAccAmt(BigDecimal totalAccAmt) {
		this.totalAccAmt = totalAccAmt;
	}

	public String getAccessoryDesc() {
		return accessoryDesc;
	}

	public void setAccessoryDesc(String accessoryDesc) {
		this.accessoryDesc = accessoryDesc;
	}		
	
	
}
