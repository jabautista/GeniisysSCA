package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIACWholdingTaxes extends BaseEntity {

	private Integer whtaxId;
	private String gibrGfunFundCd;
	private String gibrBranchCd;
	private Integer whtaxCode;
	private String birTaxCd;
	private BigDecimal percentRate;
	private String whtaxDesc;
	private String indCorpTag;
	private String dspIndCorpTag;
	private String remarks;
	private String startDt;
	private String endDt;
	private Integer glAcctId;
	private String slTypeCd;
	private String dspSlTypeName;
	private Integer dspGlAcctCategory;
	private Integer dspGlControlAcct;
	private Integer dspGlSubAcct1;
	private Integer dspGlSubAcct2;
	private Integer dspGlSubAcct3;
	private Integer dspGlSubAcct4;
	private Integer dspGlSubAcct5;
	private Integer dspGlSubAcct6;
	private Integer dspGlSubAcct7;
	private String dspGlAcctName;

	public String getDspIndCorpTag() {
		return dspIndCorpTag;
	}

	public void setDspIndCorpTag(String dspIndCorpTag) {
		this.dspIndCorpTag = dspIndCorpTag;
	}

	public String getStartDt() {
		return startDt;
	}

	public void setStartDt(String startDt) {
		this.startDt = startDt;
	}

	public String getEndDt() {
		return endDt;
	}

	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}

	public Integer getGlAcctId() {
		return glAcctId;
	}

	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
	}

	public String getSlTypeCd() {
		return slTypeCd;
	}

	public void setSlTypeCd(String slTypeCd) {
		this.slTypeCd = slTypeCd;
	}

	public String getDspSlTypeName() {
		return dspSlTypeName;
	}

	public void setDspSlTypeName(String dspSlTypeName) {
		this.dspSlTypeName = dspSlTypeName;
	}

	public Integer getDspGlAcctCategory() {
		return dspGlAcctCategory;
	}

	public void setDspGlAcctCategory(Integer dspGlAcctCategory) {
		this.dspGlAcctCategory = dspGlAcctCategory;
	}

	public Integer getDspGlControlAcct() {
		return dspGlControlAcct;
	}

	public void setDspGlControlAcct(Integer dspGlControlAcct) {
		this.dspGlControlAcct = dspGlControlAcct;
	}

	public Integer getDspGlSubAcct1() {
		return dspGlSubAcct1;
	}

	public void setDspGlSubAcct1(Integer dspGlSubAcct1) {
		this.dspGlSubAcct1 = dspGlSubAcct1;
	}

	public Integer getDspGlSubAcct2() {
		return dspGlSubAcct2;
	}

	public void setDspGlSubAcct2(Integer dspGlSubAcct2) {
		this.dspGlSubAcct2 = dspGlSubAcct2;
	}

	public Integer getDspGlSubAcct3() {
		return dspGlSubAcct3;
	}

	public void setDspGlSubAcct3(Integer dspGlSubAcct3) {
		this.dspGlSubAcct3 = dspGlSubAcct3;
	}

	public Integer getDspGlSubAcct4() {
		return dspGlSubAcct4;
	}

	public void setDspGlSubAcct4(Integer dspGlSubAcct4) {
		this.dspGlSubAcct4 = dspGlSubAcct4;
	}

	public Integer getDspGlSubAcct5() {
		return dspGlSubAcct5;
	}

	public void setDspGlSubAcct5(Integer dspGlSubAcct5) {
		this.dspGlSubAcct5 = dspGlSubAcct5;
	}

	public Integer getDspGlSubAcct6() {
		return dspGlSubAcct6;
	}

	public void setDspGlSubAcct6(Integer dspGlSubAcct6) {
		this.dspGlSubAcct6 = dspGlSubAcct6;
	}

	public Integer getDspGlSubAcct7() {
		return dspGlSubAcct7;
	}

	public void setDspGlSubAcct7(Integer dspGlSubAcct7) {
		this.dspGlSubAcct7 = dspGlSubAcct7;
	}

	public String getDspGlAcctName() {
		return dspGlAcctName;
	}

	public void setDspGlAcctName(String dspGlAcctName) {
		this.dspGlAcctName = dspGlAcctName;
	}

	public Integer getWhtaxId() {
		return whtaxId;
	}

	public void setWhtaxId(Integer whtaxId) {
		this.whtaxId = whtaxId;
	}

	public String getGibrBranchCd() {
		return gibrBranchCd;
	}

	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}

	public Integer getWhtaxCode() {
		return whtaxCode;
	}

	public void setWhtaxCode(Integer whtaxCode) {
		this.whtaxCode = whtaxCode;
	}

	public String getBirTaxCd() {
		return birTaxCd;
	}

	public void setBirTaxCd(String birTaxCd) {
		this.birTaxCd = birTaxCd;
	}

	public BigDecimal getPercentRate() {
		return percentRate;
	}

	public void setPercentRate(BigDecimal percentRate) {
		this.percentRate = percentRate;
	}

	public String getWhtaxDesc() {
		return whtaxDesc;
	}

	public void setWhtaxDesc(String whtaxDesc) {
		this.whtaxDesc = whtaxDesc;
	}

	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}

	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}

	public String getIndCorpTag() {
		return indCorpTag;
	}

	public void setIndCorpTag(String indCorpTag) {
		this.indCorpTag = indCorpTag;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}
