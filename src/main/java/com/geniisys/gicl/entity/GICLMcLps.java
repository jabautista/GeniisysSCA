package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GICLMcLps extends BaseEntity {
	private String lossExpCd;
	private BigDecimal tinsmithLight;
	private BigDecimal tinsmithMedium;
	private BigDecimal tinsmithHeavy;
	private BigDecimal painting;
	private String remarks;
	private String userId;

	public String getLossExpCd() {
		return lossExpCd;
	}

	public void setLossExpCd(String lossExpCd) {
		this.lossExpCd = lossExpCd;
	}

	public BigDecimal getTinsmithLight() {
		return tinsmithLight;
	}

	public void setTinsmithLight(BigDecimal tinsmithLight) {
		this.tinsmithLight = tinsmithLight;
	}

	public BigDecimal getTinsmithMedium() {
		return tinsmithMedium;
	}

	public void setTinsmithMedium(BigDecimal tinsmithMedium) {
		this.tinsmithMedium = tinsmithMedium;
	}

	public BigDecimal getTinsmithHeavy() {
		return tinsmithHeavy;
	}

	public void setTinsmithHeavy(BigDecimal tinsmithHeavy) {
		this.tinsmithHeavy = tinsmithHeavy;
	}

	public BigDecimal getPainting() {
		return painting;
	}

	public void setPainting(BigDecimal painting) {
		this.painting = painting;
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
}
