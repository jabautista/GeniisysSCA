package com.geniisys.common.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GIISBancTypeDtl extends BaseEntity {

	private String bancTypeCd;
	
	private Integer itemNo;
	
	private Integer intmNo;
	
	private String intmName;
	
	private String intmType;
	
	private String intmTypeDesc;
	
	private BigDecimal sharePercentage;
	
	private String remarks;
	
	private String userId;
	
	private Date lastUpdate;
	
	private String fixedTag;
	
	private Integer parentIntmNo;
	
	private String parentIntmName;
	
	private String dspLastUpdate;

	public String getParentIntmName() {
		return parentIntmName;
	}

	public void setParentIntmName(String parentIntmName) {
		this.parentIntmName = parentIntmName;
	}

	public String getBancTypeCd() {
		return bancTypeCd;
	}

	public void setBancTypeCd(String bancTypeCd) {
		this.bancTypeCd = bancTypeCd;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public Integer getIntmNo() {
		return intmNo;
	}

	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}

	public String getIntmType() {
		return intmType;
	}

	public void setIntmType(String intmType) {
		this.intmType = intmType;
	}

	public BigDecimal getSharePercentage() {
		return sharePercentage;
	}

	public void setSharePercentage(BigDecimal sharePercentage) {
		this.sharePercentage = sharePercentage;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public String getFixedTag() {
		return fixedTag;
	}

	public void setFixedTag(String fixedTag) {
		this.fixedTag = fixedTag;
	}

	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}

	public String getIntmName() {
		return intmName;
	}

	public void setIntmTypeDesc(String intmTypeDesc) {
		this.intmTypeDesc = intmTypeDesc;
	}

	public String getIntmTypeDesc() {
		return intmTypeDesc;
	}
	
	public Integer getParentIntmNo() {
		return parentIntmNo;
	}

	public void setParentIntmNo(Integer parentIntmNo) {
		this.parentIntmNo = parentIntmNo;
	}

	public String getDspLastUpdate() {
		return dspLastUpdate;
	}

	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}
}
