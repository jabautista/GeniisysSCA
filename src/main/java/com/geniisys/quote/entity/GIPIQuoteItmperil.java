package com.geniisys.quote.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIPIQuoteItmperil extends BaseEntity{
	
	private Integer quoteId;
	private Integer itemNo;
	private Integer perilCd;
	private BigDecimal premRt;
	private String compRem;
	private BigDecimal tsiAmt;
	private BigDecimal premAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private BigDecimal annPremAmt;
	private String asChargedSw;
	private String discountSw;
	private String lineCd;
	private String prtFlag;
	private String recFlag;
	private BigDecimal riCommAmt;
	private BigDecimal riCommRt;
	private String subchargeSw;
	private String tarfCd;
	private BigDecimal annTsiAmt;
	private Integer basicPerilCd;
	private String perilType;	
	
	private String perilName;
	private BigDecimal perilPremRt;
	private BigDecimal perilTsiAmt;
	private BigDecimal perilPremAmt;
	private String perilCompRem;
	private Integer perilQuoteId;
	private Integer perilItemNo;
	private Integer perilBasicPerilCd;
	private String perilPrtFlag;
	private String perilLineCd;
	
	private String issCd;
	private String mortgCd;
	private BigDecimal amount;
	private String remarks;
	
	
	
	
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getMortgCd() {
		return mortgCd;
	}

	public void setMortgCd(String mortgCd) {
		this.mortgCd = mortgCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public GIPIQuoteItmperil() {
		super();
	}

	public Integer getQuoteId() {
		return quoteId;
	}


	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}


	public Integer getItemNo() {
		return itemNo;
	}


	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}


	public Integer getPerilCd() {
		return perilCd;
	}


	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}


	public BigDecimal getPremRt() {
		return premRt;
	}


	public void setPremRt(BigDecimal premRt) {
		this.premRt = premRt;
	}


	public String getCompRem() {
		return compRem;
	}


	public void setCompRem(String compRem) {
		this.compRem = compRem;
	}


	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}


	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}


	public BigDecimal getPremAmt() {
		return premAmt;
	}


	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}


	public Integer getCpiRecNo() {
		return cpiRecNo;
	}


	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}


	public String getCpiBranchCd() {
		return cpiBranchCd;
	}


	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}


	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}


	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}


	public String getAsChargedSw() {
		return asChargedSw;
	}


	public void setAsChargedSw(String asChargedSw) {
		this.asChargedSw = asChargedSw;
	}


	public String getDiscountSw() {
		return discountSw;
	}


	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}


	public String getLineCd() {
		return lineCd;
	}


	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}


	public String getPrtFlag() {
		return prtFlag;
	}


	public void setPrtFlag(String prtFlag) {
		this.prtFlag = prtFlag;
	}


	public String getRecFlag() {
		return recFlag;
	}


	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}


	public BigDecimal getRiCommAmt() {
		return riCommAmt;
	}


	public void setRiCommAmt(BigDecimal riCommAmt) {
		this.riCommAmt = riCommAmt;
	}


	public BigDecimal getRiCommRt() {
		return riCommRt;
	}


	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}


	public String getSubchargeSw() {
		return subchargeSw;
	}


	public void setSubchargeSw(String subchargeSw) {
		this.subchargeSw = subchargeSw;
	}


	public String getTarfCd() {
		return tarfCd;
	}


	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}


	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}


	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}


	public Integer getBasicPerilCd() {
		return basicPerilCd;
	}


	public void setBasicPerilCd(Integer basicPerilCd) {
		this.basicPerilCd = basicPerilCd;
	}

	public String getPerilType() {
		return perilType;
	}

	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public BigDecimal getPerilPremRt() {
		return perilPremRt;
	}

	public void setPerilPremRt(BigDecimal perilPremRt) {
		this.perilPremRt = perilPremRt;
	}

	public BigDecimal getPerilTsiAmt() {
		return perilTsiAmt;
	}

	public void setPerilTsiAmt(BigDecimal perilTsiAmt) {
		this.perilTsiAmt = perilTsiAmt;
	}

	public BigDecimal getPerilPremAmt() {
		return perilPremAmt;
	}

	public void setPerilPremAmt(BigDecimal perilPremAmt) {
		this.perilPremAmt = perilPremAmt;
	}

	public String getPerilCompRem() {
		return perilCompRem;
	}

	public void setPerilCompRem(String perilCompRem) {
		this.perilCompRem = perilCompRem;
	}

	public Integer getPerilQuoteId() {
		return perilQuoteId;
	}

	public void setPerilQuoteId(Integer perilQuoteId) {
		this.perilQuoteId = perilQuoteId;
	}

	public Integer getPerilItemNo() {
		return perilItemNo;
	}

	public void setPerilItemNo(Integer perilItemNo) {
		this.perilItemNo = perilItemNo;
	}

	public Integer getPerilBasicPerilCd() {
		return perilBasicPerilCd;
	}

	public void setPerilBasicPerilCd(Integer perilBasicPerilCd) {
		this.perilBasicPerilCd = perilBasicPerilCd;
	}

	public String getPerilPrtFlag() {
		return perilPrtFlag;
	}

	public void setPerilPrtFlag(String perilPrtFlag) {
		this.perilPrtFlag = perilPrtFlag;
	}

	public String getPerilLineCd() {
		return perilLineCd;
	}

	public void setPerilLineCd(String perilLineCd) {
		this.perilLineCd = perilLineCd;
	}

}
