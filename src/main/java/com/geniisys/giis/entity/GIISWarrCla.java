package com.geniisys.giis.entity;

public class GIISWarrCla extends BaseEntity{
	
	private String lineCd;
	private String lineName;
	private String mainWcCd;
	private String wcTitle;
	private String wcText;
	private String wcText01;
	private String wcText02;
	private String wcText03;
	private String wcText04;
	private String wcText05;
	private String wcText06;
	private String wcText07;
	private String wcText08;
	private String wcText09;
	private String wcText10;
	private String wcText11;
	private String wcText12;
	private String wcText13;
	private String wcText14;
	private String wcText15;
	private String wcText16;
	private String wcText17;
	private String wcSw;
	private String printSw;
	private String remarks;
	private String wcSwDesc;
	private String activeTag;
	
	public GIISWarrCla(){
		super();
	}

	public GIISWarrCla(String lineCd, String lineName, String mainWcCd, String wcTitle,
			String wcText, String wcSw, String printSw, String remarks, String wcSwDesc) {
		super();
		this.lineCd = lineCd;
		this.lineName = lineName;
		this.mainWcCd = mainWcCd;
		this.wcTitle = wcTitle;
		this.wcText = wcText;
		this.wcSw = wcSw;
		this.printSw = printSw;
		this.remarks = remarks;
		this.wcSwDesc = wcSwDesc;
	}

	public String getMainWcCd() {
		return mainWcCd;
	}

	public void setMainWcCd(String mainWcCd) {
		this.mainWcCd = mainWcCd;
	}

	public String getWcTitle() {
		return wcTitle;
	}

	public void setWcTitle(String wcTitle) {
		this.wcTitle = wcTitle;
	}

	public String getWcText() {
		wcText = (this.getWcText01() != null ? this.getWcText01() : "") + 
				 (this.getWcText02() != null ? this.getWcText02() : "") + 
				 (this.getWcText03() != null ? this.getWcText03() : "") + 
				 (this.getWcText04() != null ? this.getWcText04() : "") + 
				 (this.getWcText05() != null ? this.getWcText05() : "") + 
				 (this.getWcText06() != null ? this.getWcText06() : "") +
				 (this.getWcText07() != null ? this.getWcText07() : "") + 
				 (this.getWcText08() != null ? this.getWcText08() : "") + 
				 (this.getWcText09() != null ? this.getWcText09() : "") + 
				 (this.getWcText10() != null ? this.getWcText10() : "") + 
				 (this.getWcText11() != null ? this.getWcText11() : "") + 
				 (this.getWcText12() != null ? this.getWcText12() : "") +
				 (this.getWcText13() != null ? this.getWcText13() : "") + 
				 (this.getWcText14() != null ? this.getWcText14() : "") + 
				 (this.getWcText15() != null ? this.getWcText15() : "") + 
				 (this.getWcText16() != null ? this.getWcText16() : "") + 
				 (this.getWcText17() != null ? this.getWcText17() : "");
		return wcText;
	}

	public void setWcText(String wcText) {
		this.wcText = wcText;
	}

	public String getWcText01() {
		return wcText01;
	}

	public void setWcText01(String wcText01) {
		this.wcText01 = wcText01;
	}

	public String getWcText02() {
		return wcText02;
	}

	public void setWcText02(String wcText02) {
		this.wcText02 = wcText02;
	}

	public String getWcText03() {
		return wcText03;
	}

	public void setWcText03(String wcText03) {
		this.wcText03 = wcText03;
	}

	public String getWcText04() {
		return wcText04;
	}

	public void setWcText04(String wcText04) {
		this.wcText04 = wcText04;
	}

	public String getWcText05() {
		return wcText05;
	}

	public void setWcText05(String wcText05) {
		this.wcText05 = wcText05;
	}

	public String getWcText06() {
		return wcText06;
	}

	public void setWcText06(String wcText06) {
		this.wcText06 = wcText06;
	}

	public String getWcText07() {
		return wcText07;
	}

	public void setWcText07(String wcText07) {
		this.wcText07 = wcText07;
	}

	public String getWcText08() {
		return wcText08;
	}

	public void setWcText08(String wcText08) {
		this.wcText08 = wcText08;
	}

	public String getWcText09() {
		return wcText09;
	}

	public void setWcText09(String wcText09) {
		this.wcText09 = wcText09;
	}

	public String getWcText10() {
		return wcText10;
	}

	public void setWcText10(String wcText10) {
		this.wcText10 = wcText10;
	}

	public String getWcText11() {
		return wcText11;
	}

	public void setWcText11(String wcText11) {
		this.wcText11 = wcText11;
	}

	public String getWcText12() {
		return wcText12;
	}

	public void setWcText12(String wcText12) {
		this.wcText12 = wcText12;
	}

	public String getWcText13() {
		return wcText13;
	}

	public void setWcText13(String wcText13) {
		this.wcText13 = wcText13;
	}

	public String getWcText14() {
		return wcText14;
	}

	public void setWcText14(String wcText14) {
		this.wcText14 = wcText14;
	}

	public String getWcText15() {
		return wcText15;
	}

	public void setWcText15(String wcText15) {
		this.wcText15 = wcText15;
	}

	public String getWcText16() {
		return wcText16;
	}

	public void setWcText16(String wcText16) {
		this.wcText16 = wcText16;
	}

	public String getWcText17() {
		return wcText17;
	}

	public void setWcText17(String wcText17) {
		this.wcText17 = wcText17;
	}

	public String getWcSw() {
		return wcSw;
	}

	public void setWcSw(String wcSw) {
		this.wcSw = wcSw;
	}

	public String getPrintSw() {
		return printSw;
	}

	public void setPrintSw(String printSw) {
		this.printSw = printSw;
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

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getWcSwDesc() {
		return wcSwDesc;
	}

	public void setWcSwDesc(String wcSwDesc) {
		this.wcSwDesc = wcSwDesc;
	}

	public String getActiveTag() {
		return activeTag;
	}

	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}	
	
}
