/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIPIWPolicyWarrantyAndClause.
 */
public class GIPIWPolicyWarrantyAndClause extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -3091829816343642360L;

	/** The wc cd. */
	private String wcCd;

	/** The par id. */
	private Integer parId;

	/** The line cd. */
	private String lineCd;

	/** The wc sw. */
	private String wcSw;

	/** The wc title. */
	private String wcTitle;

	/** The wc title2. */
	private String wcTitle2;

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
	
	/** The change tag. */
	private String changeTag;

	/** The wc remarks. */
	private String wcRemarks;

	/** The print sw. */
	private String printSw;

	/** The print seq no. */
	private Integer printSeqNo;

	/** The rec flag. */
	private String recFlag;

	private Integer swcSeqNo;
	
	private Integer packParId;
	
	/**the highest PrintSeqNo*/
	private Integer maxPrintSeqNo;
	/**
	 * Instantiates a new gIPIW policy warranty and clause.
	 */
	public GIPIWPolicyWarrantyAndClause() {

	}

	/**
	 * Instantiates a new gIPIW policy warranty and clause.
	 * 
	 * @param wcCd
	 *            the wc cd
	 * @param parId
	 *            the par id
	 * @param lineCd
	 *            the line cd
	 * @param wcSw
	 *            the wc sw
	 * @param wcTitle
	 *            the wc title
	 * @param wcTitle2
	 *            the wc title2
	 * @param wcText
	 *            the wc text
	 * @param changeTag
	 *            the change tag
	 * @param wcRemarks
	 *            the wc remarks
	 * @param printSw
	 *            the print sw
	 * @param printSeqNo
	 *            the print seq no
	 * @param recFlag
	 *            the rec flag
	 */
	public GIPIWPolicyWarrantyAndClause(String wcCd, Integer parId, String lineCd,
			String wcSw, String wcTitle, String wcTitle2, String wcText1,
			String changeTag, String wcRemarks, String printSw, Integer printSeqNo,
			String recFlag) {
		this.wcCd = wcCd;
		this.parId = parId;
		this.lineCd = lineCd;
		this.wcSw = wcSw;
		this.wcTitle = wcTitle;
		this.wcTitle2 = wcTitle2;
		this.wcText1 = wcText1;
		this.changeTag = changeTag;
		this.wcRemarks = wcRemarks;
		this.printSw = printSw;
		this.printSeqNo = printSeqNo;
		this.recFlag = recFlag;
	}

	/**
	 * Gets the wc cd.
	 * 
	 * @return the wc cd
	 */
	public String getWcCd() {
		return wcCd;
	}

	/**
	 * Sets the wc cd.
	 * 
	 * @param wcCd
	 *            the new wc cd
	 */
	public void setWcCd(String wcCd) {
		this.wcCd = wcCd;
	}

	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}

	/**
	 * Sets the par id.
	 * 
	 * @param parId
	 *            the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}

	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd
	 *            the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the wc sw.
	 * 
	 * @return the wc sw
	 */
	public String getWcSw() {
		return wcSw;
	}

	/**
	 * Sets the wc sw.
	 * 
	 * @param wcSw
	 *            the new wc sw
	 */
	public void setWcSw(String wcSw) {
		this.wcSw = wcSw;
	}

	/**
	 * Gets the wc title.
	 * 
	 * @return the wc title
	 */
	public String getWcTitle() {
		return wcTitle;
	}

	/**
	 * Sets the wc title.
	 * 
	 * @param wcTitle
	 *            the new wc title
	 */
	public void setWcTitle(String wcTitle) {
		this.wcTitle = wcTitle;
	}

	/**
	 * Gets the wc title2.
	 * 
	 * @return the wc title2
	 */
	public String getWcTitle2() {
		return wcTitle2;
	}

	/**
	 * Sets the wc title2.
	 * 
	 * @param wcTitle2
	 *            the new wc title2
	 */
	public void setWcTitle2(String wcTitle2) {
		this.wcTitle2 = wcTitle2;
	}

	/**
	 * Gets the wc text.
	 * 
	 * @return the wc text
	 */
	public String getWcText1() {
		return wcText1;
	}

	/**
	 * Sets the wc text.
	 * 
	 * @param wcText
	 *            the new wc text
	 */
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

	/**
	 * Gets the change tag.
	 * 
	 * @return the change tag
	 */
	public String getChangeTag() {
		return changeTag;
	}

	/**
	 * Sets the change tag.
	 * 
	 * @param changeTag
	 *            the new change tag
	 */
	public void setChangeTag(String changeTag) {
		this.changeTag = changeTag;
	}

	/**
	 * Gets the wc remarks.
	 * 
	 * @return the wc remarks
	 */
	public String getWcRemarks() {
		return wcRemarks;
	}

	/**
	 * Sets the wc remarks.
	 * 
	 * @param wcRemarks
	 *            the new wc remarks
	 */
	public void setWcRemarks(String wcRemarks) {
		this.wcRemarks = wcRemarks;
	}

	/**
	 * Gets the prints the sw.
	 * 
	 * @return the prints the sw
	 */
	public String getPrintSw() {
		return printSw;
	}

	/**
	 * Sets the prints the sw.
	 * 
	 * @param printSw
	 *            the new prints the sw
	 */
	public void setPrintSw(String printSw) {
		this.printSw = printSw;
	}

	/**
	 * Gets the prints the seq no.
	 * 
	 * @return the prints the seq no
	 */
	public Integer getPrintSeqNo() {
		return printSeqNo;
	}

	/**
	 * Sets the prints the seq no.
	 * 
	 * @param printSeqNo
	 *            the new prints the seq no
	 */
	public void setPrintSeqNo(Integer printSeqNo) {
		this.printSeqNo = printSeqNo;
	}

	/**
	 * Gets the rec flag.
	 * 
	 * @return the rec flag
	 */
	public String getRecFlag() {
		return recFlag;
	}

	/**
	 * Sets the rec flag.
	 * 
	 * @param recFlag
	 *            the new rec flag
	 */
	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	/**
	 * Gets the serialversionuid.
	 * 
	 * @return the serialversionuid
	 */
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	/**
	 * @param swSeqNo
	 *            the swSeqNo to set
	 */
	public void setSwcSeqNo(Integer swcSeqNo) {
		this.swcSeqNo = swcSeqNo;
	}

	/**
	 * @return the swSeqNo
	 */
	public Integer getSwcSeqNo() {
		return swcSeqNo;
	}

	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}

	public Integer getPackParId() {
		return packParId;
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

	public Integer getMaxPrintSeqNo() {
		return maxPrintSeqNo;
	}

	public void setMaxPrintSeqNo(Integer maxPrintSeqNo) {
		this.maxPrintSeqNo = maxPrintSeqNo;
	}

}
