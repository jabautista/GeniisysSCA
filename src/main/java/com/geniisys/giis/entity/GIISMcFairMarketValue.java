package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISMcFairMarketValue extends BaseEntity {
	
	private String  	carCompany;
	private String  	make;
	private String  	engineSeries;
	private Integer 	carCompanyCd;
	private Integer 	makeCd;
	private Integer 	seriesCd;
	private String  	modelYear;
	private Integer 	histNo;
	private String  	effDate;
	private BigDecimal  fmvValue;
	private BigDecimal  fmvValueMin;
	private BigDecimal  fmvValueMax;
	private String  	deleteSw;
	private Integer 	maxSequence;
	private String  	lastEffDate;
	

	public GIISMcFairMarketValue(){
		super();
	}

	public GIISMcFairMarketValue(String carCompany, String make, String engineSeries, Integer carCompanyCd,
			Integer makeCd, Integer seriesCd, String modelYear, Integer histNo,
			String effDate, BigDecimal fmvValue, BigDecimal fmvValueMin, BigDecimal fmvValueMax, String deleteSw, Integer maxSequence, String lastEffDate) {
		super();
		this.setCarCompany(carCompany);
		this.setMake(make);
		this.setEngineSeries(engineSeries);
		this.setCarCompanyCd(carCompanyCd);
		this.setMakeCd(makeCd);
		this.setSeriesCd(seriesCd);
		this.setModelYear(modelYear);
		this.setHistNo(histNo);
		this.setEffDate(effDate);
		this.setFmvValue(fmvValue);
		this.setFmvValueMin(fmvValueMin);
		this.setFmvValueMax(fmvValueMax);
		this.setDeleteSw(deleteSw);
		this.setMaxSequence(maxSequence);
		this.setLastEffDate(lastEffDate);
	}

	public String getCarCompany() {
		return carCompany;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}

	public String getEngineSeries() {
		return engineSeries;
	}

	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}

	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}

	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}

	public Integer getMakeCd() {
		return makeCd;
	}

	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}

	public Integer getSeriesCd() {
		return seriesCd;
	}

	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
	}

	public String getModelYear() {
		return modelYear;
	}

	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}

	public Integer getHistNo() {
		return histNo;
	}

	public void setHistNo(Integer histNo) {
		this.histNo = histNo;
	}

	public String getEffDate() {
		return effDate;
	}

	public void setEffDate(String effDate) {
		this.effDate = effDate;
	}

	public BigDecimal getFmvValue() {
		return fmvValue;
	}

	public void setFmvValue(BigDecimal fmvValue) {
		this.fmvValue = fmvValue;
	}

	public BigDecimal getFmvValueMin() {
		return fmvValueMin;
	}

	public void setFmvValueMin(BigDecimal fmvValueMin) {
		this.fmvValueMin = fmvValueMin;
	}

	public BigDecimal getFmvValueMax() {
		return fmvValueMax;
	}

	public void setFmvValueMax(BigDecimal fmvValueMax) {
		this.fmvValueMax = fmvValueMax;
	}

	public String getDeleteSw() {
		return deleteSw;
	}

	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}

	public Integer getMaxSequence() {
		return maxSequence;
	}

	public void setMaxSequence(Integer maxSequence) {
		this.maxSequence = maxSequence;
	}

	public String getLastEffDate() {
		return lastEffDate;
	}

	public void setLastEffDate(String lastEffDate) {
		this.lastEffDate = lastEffDate;
	}


}
