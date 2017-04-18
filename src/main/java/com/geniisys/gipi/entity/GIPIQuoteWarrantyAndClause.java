/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.util.Date;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIPIQuoteWarrantyAndClause.
 */
public class GIPIQuoteWarrantyAndClause extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -9004834448537905747L;

	/** The quote id. */
	private int quoteId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The wc cd. */
	private String wcCd;
	
	/** The print seq no. */
	private Integer printSeqNo;
	
	/** The wc title. */
	private String wcTitle;
	
	/** The wc text. */
	private String wcText;
	
	/** The wc text1. */
	private String wcText1;
	
	/** The wc text2. */
	private String wcText2;
	
	/** The wc text3. */
	private String wcText3;
	
	/** The wc text4. */
	private String wcText4;
	
	/** The wc text5. */
	private String wcText5;
	
	/** The wc text6. */
	private String wcText6;
	
	/** The wc text7. */
	private String wcText7;
	
	/** The wc text8. */
	private String wcText8;
	
	/** The wc text9. */
	private String wcText9;
	
	/** The wc text10. */
	private String wcText10;
	
	/** The wc text11. */
	private String wcText11;
	
	/** The wc text12. */
	private String wcText12;
	
	/** The wc text13. */
	private String wcText13;
	
	/** The wc text14. */
	private String wcText14;
	
	/** The wc text15. */
	private String wcText15;
	
	/** The wc text16. */
	private String wcText16;
	
	/** The wc text17. */
	private String wcText17;
	
	/** The wc remarks. */
	private String wcRemarks;
	
	/** The print sw. */
	private String printSw;
	
	/** The change tag. */
	private String changeTag;
	
	/** The wc title2. */
	private String wcTitle2;
	
	/** The swc seq no. */
	private Integer swcSeqNo;
	
	/** The wc sw. */
	private String wcSw;
	
	/** The maximum PrintSeqNo. */
	private Integer maxPrintSeqNo;

	/**
	 * Instantiates a new gIPI quote warranty and clause.
	 */
	public GIPIQuoteWarrantyAndClause() {

	}

	/**
	 * Instantiates a new gIPI quote warranty and clause.
	 * 
	 * @param quoteId the quote id
	 * @param lineCd the line cd
	 * @param wcCd the wc cd
	 * @param printSeqNo the print seq no
	 * @param wcTitle the wc title
	 * @param wcText the wc text
	 * @param printSw the print sw
	 * @param changeTag the change tag
	 * @param userId the user id
	 * @param wcTitle2 the wc title2
	 * @param swcSeqNo the swc seq no
	 */
	public GIPIQuoteWarrantyAndClause(int quoteId, String lineCd, String wcCd,
			int printSeqNo, String wcTitle, String wcText1, String printSw,
			String changeTag, String userId, String wcTitle2, Integer swcSeqNo) {

		this.quoteId = quoteId;
		this.lineCd = lineCd;
		this.wcCd = wcCd;
		this.printSeqNo = printSeqNo;
		this.wcTitle = wcTitle;
		this.wcText1 = wcText1;
		this.printSw = printSw;
		this.changeTag = changeTag;
		super.setUserId(userId);
		super.setLastUpdate(new Date());
		this.wcTitle2 = wcTitle2;
		this.swcSeqNo = swcSeqNo;
	}//Steven 3.6.2012

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
	 * @param wcSw the new wc sw
	 */
	public void setWcSw(String wcSw) {
		this.wcSw = wcSw;
	}

	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public int getQuoteId() {
		return quoteId;
	}

	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(int quoteId) {
		this.quoteId = quoteId;
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
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
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
	 * @param printSeqNo the new prints the seq no
	 */
	public void setPrintSeqNo(Integer printSeqNo) {
		this.printSeqNo = printSeqNo;
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
	 * @param wcTitle the new wc title
	 */
	public void setWcTitle(String wcTitle) {
		this.wcTitle = wcTitle;
	}

	/**
	 * Gets the wc text1.
	 * 
	 * @return the wc text1
	 */
	public String getWcText1() {
		return wcText1;
	}

	/**
	 * Sets the wc text1.
	 * 
	 * @param wcText1 the new wc text1
	 */
	public void setWcText1(String wcText1) {
		this.wcText1 = wcText1;
	}

	/**
	 * Gets the wc text2.
	 * 
	 * @return the wc text2
	 */
	public String getWcText2() {
		return wcText2;
	}

	/**
	 * Sets the wc text2.
	 * 
	 * @param wcText2 the new wc text2
	 */
	public void setWcText2(String wcText2) {
		this.wcText2 = wcText2;
	}

	/**
	 * Gets the wc text3.
	 * 
	 * @return the wc text3
	 */
	public String getWcText3() {
		return wcText3;
	}

	/**
	 * Sets the wc text3.
	 * 
	 * @param wcText3 the new wc text3
	 */
	public void setWcText3(String wcText3) {
		this.wcText3 = wcText3;
	}

	/**
	 * Gets the wc text4.
	 * 
	 * @return the wc text4
	 */
	public String getWcText4() {
		return wcText4;
	}

	/**
	 * Sets the wc text4.
	 * 
	 * @param wcText4 the new wc text4
	 */
	public void setWcText4(String wcText4) {
		this.wcText4 = wcText4;
	}

	/**
	 * Gets the wc text5.
	 * 
	 * @return the wc text5
	 */
	public String getWcText5() {
		return wcText5;
	}

	/**
	 * Sets the wc text5.
	 * 
	 * @param wcText5 the new wc text5
	 */
	public void setWcText5(String wcText5) {
		this.wcText5 = wcText5;
	}

	/**
	 * Gets the wc text6.
	 * 
	 * @return the wc text6
	 */
	public String getWcText6() {
		return wcText6;
	}

	/**
	 * Sets the wc text6.
	 * 
	 * @param wcText6 the new wc text6
	 */
	public void setWcText6(String wcText6) {
		this.wcText6 = wcText6;
	}

	/**
	 * Gets the wc text7.
	 * 
	 * @return the wc text7
	 */
	public String getWcText7() {
		return wcText7;
	}

	/**
	 * Sets the wc text7.
	 * 
	 * @param wcText7 the new wc text7
	 */
	public void setWcText7(String wcText7) {
		this.wcText7 = wcText7;
	}

	/**
	 * Gets the wc text8.
	 * 
	 * @return the wc text8
	 */
	public String getWcText8() {
		return wcText8;
	}

	/**
	 * Sets the wc text8.
	 * 
	 * @param wcText8 the new wc text8
	 */
	public void setWcText8(String wcText8) {
		this.wcText8 = wcText8;
	}

	/**
	 * Gets the wc text9.
	 * 
	 * @return the wc text9
	 */
	public String getWcText9() {
		return wcText9;
	}

	/**
	 * Sets the wc text9.
	 * 
	 * @param wcText9 the new wc text9
	 */
	public void setWcText9(String wcText9) {
		this.wcText9 = wcText9;
	}

	/**
	 * Gets the wc text10.
	 * 
	 * @return the wc text10
	 */
	public String getWcText10() {
		return wcText10;
	}

	/**
	 * Sets the wc text10.
	 * 
	 * @param wcText10 the new wc text10
	 */
	public void setWcText10(String wcText10) {
		this.wcText10 = wcText10;
	}

	/**
	 * Gets the wc text11.
	 * 
	 * @return the wc text11
	 */
	public String getWcText11() {
		return wcText11;
	}

	/**
	 * Sets the wc text11.
	 * 
	 * @param wcText11 the new wc text11
	 */
	public void setWcText11(String wcText11) {
		this.wcText11 = wcText11;
	}

	/**
	 * Gets the wc text12.
	 * 
	 * @return the wc text12
	 */
	public String getWcText12() {
		return wcText12;
	}

	/**
	 * Sets the wc text12.
	 * 
	 * @param wcText12 the new wc text12
	 */
	public void setWcText12(String wcText12) {
		this.wcText12 = wcText12;
	}

	/**
	 * Gets the wc text13.
	 * 
	 * @return the wc text13
	 */
	public String getWcText13() {
		return wcText13;
	}

	/**
	 * Sets the wc text13.
	 * 
	 * @param wcText13 the new wc text13
	 */
	public void setWcText13(String wcText13) {
		this.wcText13 = wcText13;
	}

	/**
	 * Gets the wc text14.
	 * 
	 * @return the wc text14
	 */
	public String getWcText14() {
		return wcText14;
	}

	/**
	 * Sets the wc text14.
	 * 
	 * @param wcText14 the new wc text14
	 */
	public void setWcText14(String wcText14) {
		this.wcText14 = wcText14;
	}

	/**
	 * Gets the wc text15.
	 * 
	 * @return the wc text15
	 */
	public String getWcText15() {
		return wcText15;
	}

	/**
	 * Sets the wc text15.
	 * 
	 * @param wcText15 the new wc text15
	 */
	public void setWcText15(String wcText15) {
		this.wcText15 = wcText15;
	}

	/**
	 * Gets the wc text16.
	 * 
	 * @return the wc text16
	 */
	public String getWcText16() {
		return wcText16;
	}

	/**
	 * Sets the wc text16.
	 * 
	 * @param wcText16 the new wc text16
	 */
	public void setWcText16(String wcText16) {
		this.wcText16 = wcText16;
	}

	/**
	 * Gets the wc text17.
	 * 
	 * @return the wc text17
	 */
	public String getWcText17() {
		return wcText17;
	}

	/**
	 * Sets the wc text17.
	 * 
	 * @param wcText17 the new wc text17
	 */
	public void setWcText17(String wcText17) {
		this.wcText17 = wcText17;
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
	 * @param wcRemarks the new wc remarks
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
	 * @param printSw the new prints the sw
	 */
	public void setPrintSw(String printSw) {
		this.printSw = printSw;
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
	 * @param changeTag the new change tag
	 */
	public void setChangeTag(String changeTag) {
		this.changeTag = changeTag;
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
	 * @param wcTitle2 the new wc title2
	 */
	public void setWcTitle2(String wcTitle2) {
		this.wcTitle2 = wcTitle2;
	}

	/**
	 * Gets the swc seq no.
	 * 
	 * @return the swc seq no
	 */
	public Integer getSwcSeqNo() {
		return swcSeqNo;
	}

	/**
	 * Sets the swc seq no.
	 * 
	 * @param swcSeqNo the new swc seq no
	 */
	public void setSwcSeqNo(Integer swcSeqNo) {
		this.swcSeqNo = swcSeqNo;
	}

	/**
	 * Gets the serial version uid.
	 * 
	 * @return the serial version uid
	 */
	public static long getSerialVersionUID() {
		return serialVersionUID;
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
	 * @param wcCd the new wc cd
	 */
	public void setWcCd(String wcCd) {
		this.wcCd = wcCd;
	}

	/**
	 * Gets the wc text.
	 * 
	 * @return the wc text
	 */
	public String getWcText() {
		wcText = (this.getWcText1() != null ? this.getWcText1() : "") + 
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
		return wcText;
	}

	/**
	 * Sets the wc text.
	 * 
	 * @param wcText the new wc text
	 */
	public void setWcText(String wcText) {
		this.wcText = wcText;
	}

	public Integer getMaxPrintSeqNo() {
		return maxPrintSeqNo;
	}

	public void setMaxPrintSeqNo(Integer maxPrintSeqNo) {
		this.maxPrintSeqNo = maxPrintSeqNo;
	}

}
