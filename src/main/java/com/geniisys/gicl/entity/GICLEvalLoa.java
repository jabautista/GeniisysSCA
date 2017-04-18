/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLEvalLoa.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Feb 27, 2012
	Description: 
*/


package com.geniisys.gicl.entity;

import com.geniisys.framework.util.BaseEntity;

public class GICLEvalLoa extends BaseEntity{
	private Integer claimId;
	private Integer itemNo;
	private String payeeTypeCd;
	private Integer payeeCd;
	private Integer evalId;
	private Integer clmLossId;
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
	public String getPayeeTypeCd() {
		return payeeTypeCd;
	}
	public void setPayeeTypeCd(String payeeTypeCd) {
		this.payeeTypeCd = payeeTypeCd;
	}
	public Integer getPayeeCd() {
		return payeeCd;
	}
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	public Integer getEvalId() {
		return evalId;
	}
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	public Integer getClmLossId() {
		return clmLossId;
	}
	public void setClmLossId(Integer clmLossId) {
		this.clmLossId = clmLossId;
	}
	
	
}
