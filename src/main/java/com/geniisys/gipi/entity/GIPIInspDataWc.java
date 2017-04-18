package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIInspDataWc extends BaseEntity{

	private double inspNo;
	private String lineCd;
	private String wcCd;
	private String arcExtData;
	
	private String wcTitle;
	/** The wc text. */
	private String wcText1;
	private String wcText2;
	private String wcText3;
	private String wcText4;
	private String wcText5;
	private String wcText6;
	private String wcText7;
	private String wcText8;
	private String wcText9;
	private String wcText10;
	private String wcText11;
	private String wcText12;
	private String wcText13;
	private String wcText14;
	private String wcText15;
	private String wcText16;
	private String wcText17;
	
	/** The combine wc text. */
	private String wcTexts;
	
	public GIPIInspDataWc() {
		
	}

	public GIPIInspDataWc(double inspNo, String lineCd, String wcCd,
			String arcExtData) {
		this.inspNo = inspNo;
		this.lineCd = lineCd;
		this.wcCd = wcCd;
		this.arcExtData = arcExtData;
	}

	public double getInspNo() {
		return inspNo;
	}

	public void setInspNo(double inspNo) {
		this.inspNo = inspNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getWcCd() {
		return wcCd;
	}

	public void setWcCd(String wcCd) {
		this.wcCd = wcCd;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	
	public String getWcTitle() {
		return wcTitle;
	}

	public void setWcTitle(String wcTitle) {
		this.wcTitle = wcTitle;
	}

	public String getWcText1() {
		return wcText1;
	}
	
	public void setWcText1(String wcText1) {
		this.wcText1 = wcText1;
	}

	public String getWcText2() {
		return wcText2;
	}

	public void setWcText2(String wcText2) {
		this.wcText2 = wcText2;
	}

	public String getWcText3() {
		return wcText3;
	}

	public void setWcText3(String wcText3) {
		this.wcText3 = wcText3;
	}

	public String getWcText4() {
		return wcText4;
	}

	public void setWcText4(String wcText4) {
		this.wcText4 = wcText4;
	}

	public String getWcText5() {
		return wcText5;
	}

	public void setWcText5(String wcText5) {
		this.wcText5 = wcText5;
	}

	public String getWcText6() {
		return wcText6;
	}

	public void setWcText6(String wcText6) {
		this.wcText6 = wcText6;
	}

	public String getWcText7() {
		return wcText7;
	}

	public void setWcText7(String wcText7) {
		this.wcText7 = wcText7;
	}

	public String getWcText8() {
		return wcText8;
	}

	public void setWcText8(String wcText8) {
		this.wcText8 = wcText8;
	}

	public String getWcText9() {
		return wcText9;
	}

	public void setWcText9(String wcText9) {
		this.wcText9 = wcText9;
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

	public String getWcTexts() {
		wcTexts = (this.getWcText1() != null ? this.getWcText1() : "") + 
				(this.getWcText2() != null ? this.getWcText2() : "") + 
				(this.getWcText3() != null ? this.getWcText3() : "") + 
				(this.getWcText4() != null ? this.getWcText4() : "") + 
				(this.getWcText5() != null ? this.getWcText5() : "") + 
				(this.getWcText6() != null ? this.getWcText6() : "") +
				(this.getWcText7() != null ? this.getWcText7() : "") + 
				(this.getWcText8() != null ? this.getWcText8() : "") + 
				(this.getWcText9() != null ? this.getWcText9() : "") + 
				(this.getWcText10() != null ? this.getWcText10() : "") + 
				(this.getWcText11() != null ? this.getWcText11() : "") + 
				(this.getWcText12() != null ? this.getWcText12() : "") +
				(this.getWcText13() != null ? this.getWcText13() : "") + 
				(this.getWcText14() != null ? this.getWcText14() : "") + 
				(this.getWcText15() != null ? this.getWcText15() : "") + 
				(this.getWcText16() != null ? this.getWcText16() : "") + 
				(this.getWcText17() != null ? this.getWcText17() : "");
		return wcTexts;
	}
	
	public void setWcTexts(String wcTexts) {
		this.wcTexts = wcTexts;
	}
}
