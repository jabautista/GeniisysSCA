package com.geniisys.giex.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIEXLine extends BaseEntity {
	private String lineCd;
	private String lineName;

	public GIEXLine() {
		super();
	}

	public GIEXLine(String lineCd, String lineName) {
		super();
		this.lineCd = lineCd;
		this.lineName = lineName;
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

}
