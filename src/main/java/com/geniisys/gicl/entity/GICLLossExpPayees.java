package com.geniisys.gicl.entity;

import com.geniisys.framework.util.BaseEntity;

public class GICLLossExpPayees extends BaseEntity{
	
	private Integer claimId;
	private Integer itemNo;
	private Integer perilCd;
	private Integer groupedItemNo;
	private String payeeType;
	private String payeeTypeDesc;
	private String payeeClassCd;
	private String className;
	private Integer payeeCd;
	private String dspPayeeName;
	private Integer clmClmntNo;
	private String existClmLossExp;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
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
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public String getPayeeType() {
		return payeeType;
	}
	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}
	public void setPayeeTypeDesc(String payeeTypeDesc) {
		this.payeeTypeDesc = payeeTypeDesc;
	}
	public String getPayeeTypeDesc() {
		return payeeTypeDesc;
	}
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	public String getClassName() {
		return className;
	}
	public void setClassName(String className) {
		this.className = className;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public String getDspPayeeName() {
		return dspPayeeName;
	}
	public void setDspPayeeName(String dspPayeeName) {
		this.dspPayeeName = dspPayeeName;
	}
	public Integer getClmClmntNo() {
		return clmClmntNo;
	}
	public void setClmClmntNo(Integer clmClmntNo) {
		this.clmClmntNo = clmClmntNo;
	}
	public void setExistClmLossExp(String existClmLossExp) {
		this.existClmLossExp = existClmLossExp;
	}
	public String getExistClmLossExp() {
		return existClmLossExp;
	}
	
	

}
