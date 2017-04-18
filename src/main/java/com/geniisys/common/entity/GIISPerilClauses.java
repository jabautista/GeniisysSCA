package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISPerilClauses extends BaseEntity {
	
	private String lineCd;
	private Integer perilCd;
	private String mainWcCd;
	private String printSw;
	private String wcTitle;
	
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public String getMainWcCd() {
		return mainWcCd;
	}
	public void setMainWcCd(String mainWcCd) {
		this.mainWcCd = mainWcCd;
	}
	public String getPrintSw() {
		return printSw;
	}
	public void setPrintSw(String printSw) {
		this.printSw = printSw;
	}
	public String getWcTitle() {
		return wcTitle;
	}
	public void setWcTitle(String wcTitle) {
		this.wcTitle = wcTitle;
	}

}
