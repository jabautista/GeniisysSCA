package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLEvalDeductibles extends BaseEntity{
	
	private Integer evalId;
	private String dedCd;
	private String dspExpDesc;
	private String sublineCd;
	private Integer noOfUnit;
	private BigDecimal dedBaseAmt;
	private BigDecimal dedAmt;
	private BigDecimal dedRate;
	private String dedText;
	private String payeeTypeCd;
	private Integer payeeCd;
	private String dspCompanyDesc;
	private String netTag;
	
	public Integer getEvalId() {
		return evalId;
	}
	public void setEvalId(Integer evalId) {
		this.evalId = evalId;
	}
	public String getDedCd() {
		return dedCd;
	}
	public void setDedCd(String dedCd) {
		this.dedCd = dedCd;
	}
	public String getDspExpDesc() {
		return dspExpDesc;
	}
	public void setDspExpDesc(String dspExpDesc) {
		this.dspExpDesc = dspExpDesc;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public Integer getNoOfUnit() {
		return noOfUnit;
	}
	public void setNoOfUnit(Integer noOfUnit) {
		this.noOfUnit = noOfUnit;
	}
	public BigDecimal getDedBaseAmt() {
		return dedBaseAmt;
	}
	public void setDedBaseAmt(BigDecimal dedBaseAmt) {
		this.dedBaseAmt = dedBaseAmt;
	}
	public BigDecimal getDedAmt() {
		return dedAmt;
	}
	public void setDedAmt(BigDecimal dedAmt) {
		this.dedAmt = dedAmt;
	}
	public BigDecimal getDedRate() {
		return dedRate;
	}
	public void setDedRate(BigDecimal dedRate) {
		this.dedRate = dedRate;
	}
	public String getDedText() {
		return dedText;
	}
	public void setDedText(String dedText) {
		this.dedText = dedText;
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
	public String getDspCompanyDesc() {
		return dspCompanyDesc;
	}
	public void setDspCompanyDesc(String dspCompanyDesc) {
		this.dspCompanyDesc = dspCompanyDesc;
	}
	public String getNetTag() {
		return netTag;
	}
	public void setNetTag(String netTag) {
		this.netTag = netTag;
	}

}
