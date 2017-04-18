package com.geniisys.giex.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIEXPerilDepreciation extends BaseEntity {
	private String lineCd;
	private String lineName;
	private Integer perilCd;
	private String perilName;
	private String rate;
	private String remarks;

	public GIEXPerilDepreciation() {
		super();
	}

	public GIEXPerilDepreciation(String lineCd, String lineName,
			Integer perilCd, String perilName, String rate, String remarks) {
		super();
		this.lineCd = lineCd;
		this.lineName = lineName;
		this.perilCd = perilCd;
		this.perilName = perilName;
		this.rate = rate;
		this.remarks = remarks;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public String getRate() {
		return rate;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getRemarks() {
		return remarks;
	}

}
