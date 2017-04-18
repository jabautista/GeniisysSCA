package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLTakeUpHist extends BaseEntity{
	private Integer claimId;
	private Integer takeUpHist;
	private String takeUpType;
	private Integer itemNo;
	private Integer perilCd;
	private String userId;
	private Date lastUpdate;
	private Integer clmResHistId;
	private Integer acctTranId;
	private Date acctDate;
	private BigDecimal osLoss;
	private BigDecimal osExpense;
	private Integer acctIntmCd;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Date tranDate;
	private String issCd;
	private String distNo;
	private Integer groupedItemNo;
	
	public GICLTakeUpHist() {
		super();
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public Integer getTakeUpHist() {
		return takeUpHist;
	}

	public void setTakeUpHist(Integer takeUpHist) {
		this.takeUpHist = takeUpHist;
	}

	public String getTakeUpType() {
		return takeUpType;
	}

	public void setTakeUpType(String takeUpType) {
		this.takeUpType = takeUpType;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public Object getStrLastUpdate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (lastUpdate != null) {
			return df.format(lastUpdate);			
		} else {
			return null;
		}
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public Integer getClmResHistId() {
		return clmResHistId;
	}

	public void setClmResHistId(Integer clmResHistId) {
		this.clmResHistId = clmResHistId;
	}

	public Integer getAcctTranId() {
		return acctTranId;
	}

	public void setAcctTranId(Integer acctTranId) {
		this.acctTranId = acctTranId;
	}
	
	public Object getStrAcctDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (acctDate != null) {
			return df.format(acctDate);			
		} else {
			return null;
		}
	}

	public Date getAcctDate() {
		return acctDate;
	}

	public void setAcctDate(Date acctDate) {
		this.acctDate = acctDate;
	}

	public BigDecimal getOsLoss() {
		return osLoss;
	}

	public void setOsLoss(BigDecimal osLoss) {
		this.osLoss = osLoss;
	}

	public BigDecimal getOsExpense() {
		return osExpense;
	}

	public void setOsExpense(BigDecimal osExpense) {
		this.osExpense = osExpense;
	}

	public Integer getAcctIntmCd() {
		return acctIntmCd;
	}

	public void setAcctIntmCd(Integer acctIntmCd) {
		this.acctIntmCd = acctIntmCd;
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

	public Date getTranDate() {
		return tranDate;
	}

	public void setTranDate(Date tranDate) {
		this.tranDate = tranDate;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getDistNo() {
		return distNo;
	}

	public void setDistNo(String distNo) {
		this.distNo = distNo;
	}

	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}

	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	
}
