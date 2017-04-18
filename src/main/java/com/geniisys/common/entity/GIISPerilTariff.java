package com.geniisys.common.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GIISPerilTariff extends BaseEntity{

	private String lineCd;
	private String perilCd;
	private String tarfCd;
	private String tarfDesc;
	private BigDecimal tarfRate;
	
	public GIISPerilTariff() {
		
	}
	
	public GIISPerilTariff(String lineCd, String perilCd, String tarfCd,
			String tarfDesc, BigDecimal tarfRate) {
		this.lineCd = lineCd;
		this.perilCd = perilCd;
		this.tarfCd = tarfCd;
		this.tarfDesc = tarfDesc;
		this.tarfRate = tarfRate;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}

	public String getTarfCd() {
		return tarfCd;
	}

	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	public String getTarfDesc() {
		return tarfDesc;
	}

	public void setTarfDesc(String tarfDesc) {
		this.tarfDesc = tarfDesc;
	}

	public BigDecimal getTarfRate() {
		return tarfRate;
	}

	public void setTarfRate(BigDecimal tarfRate) {
		this.tarfRate = tarfRate;
	}	

}
