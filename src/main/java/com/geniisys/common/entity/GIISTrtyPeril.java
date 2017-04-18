package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.giis.entity.BaseEntity;

public class GIISTrtyPeril extends BaseEntity {
	private String lineCd;
	private Integer trtySeqNo;
	private Integer perilCd;
	private String dspPerilName;
	private BigDecimal trtyComRt;
	private BigDecimal profCommRt;
	private String remarks;
	
	public GIISTrtyPeril(){
		
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getTrtySeqNo() {
		return trtySeqNo;
	}

	public void setTrtySeqNo(Integer trtySeqNo) {
		this.trtySeqNo = trtySeqNo;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public BigDecimal getTrtyComRt() {
		return trtyComRt;
	}

	public void setTrtyComRt(BigDecimal trtyComRt) {
		this.trtyComRt = trtyComRt;
	}

	public BigDecimal getProfCommRt() {
		return profCommRt;
	}

	public void setProfCommRt(BigDecimal profCommRt) {
		this.profCommRt = profCommRt;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getDspPerilName() {
		return dspPerilName;
	}

	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}
}
