package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISMcDepreciationRate extends BaseEntity {
	
	private Integer 	id;
	private Integer  	carCompanyCd;	
	private String  	carCompany;	
	private Integer 	makeCd;	
	private String  	make;
	private Integer  	modelYear;		
	private Integer 	seriesCd;	
	private String  	engineSeries;	
	private String  	lineCd;
	private String  	sublineCd;
	private String  	sublineName;		
	private String  	sublineTypeCd;
	private String  	sublineType;	
	private BigDecimal  rate;	
	private String  	deleteSw;	
	
	public GIISMcDepreciationRate(){
		super();
	}

	public GIISMcDepreciationRate(Integer id, Integer carCompanyCd, String carCompany, Integer makeCd, String make, Integer modelYear,
			Integer seriesCd, String engineSeries, String lineCd, String sublineCd, String sublineName, String sublineTypeCd, String sublineType, 
		   BigDecimal rate, String deleteSw) {
		super();
		this.setId(id);
		this.setCarCompanyCd(carCompanyCd);
		this.setCarCompany(carCompany);		
		this.setMakeCd(makeCd);		
		this.setMake(make);
		this.setModelYear(modelYear);
		this.setSeriesCd(seriesCd);		
		this.setEngineSeries(engineSeries);
		this.setMake(lineCd);		
		this.setMake(sublineCd);
		this.setMake(sublineName);
		this.setSublineTypeCd(sublineTypeCd);
		this.setSublineType(sublineType);
		this.setRate(rate);
		this.setDeleteSw(deleteSw);
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}

	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}

	public String getCarCompany() {
		return carCompany;
	}

	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}

	public Integer getMakeCd() {
		return makeCd;
	}

	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}

	public Integer getModelYear() {
		return modelYear;
	}

	public void setModelYear(Integer modelYear) {
		this.modelYear = modelYear;
	}	
	
	public Integer getSeriesCd() {
		return seriesCd;
	}

	public void setSeriesCd(Integer seriesCd) {
		this.seriesCd = seriesCd;
	}

	public String getEngineSeries() {
		return engineSeries;
	}

	public void setEngineSeries(String engineSeries) {
		this.engineSeries = engineSeries;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}	

	public String getSublineName() {
		return sublineName;
	}
	
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}		

	public String getSublineTypeCd() {
		return sublineTypeCd;
	}
	
	public void setSublineTypeCd(String sublineTypeCd) {
		this.sublineTypeCd = sublineTypeCd;
	}	
	
	public String getSublineType() {
		return sublineType;
	}

	public void setSublineType(String sublineType) {
		this.sublineType = sublineType;
	}

	public BigDecimal getRate() {
		return rate;
	}

	public void setRate(BigDecimal rate) {
		this.rate = rate;
	}

	public String getDeleteSw() {
		return deleteSw;
	}

	public void setDeleteSw(String deleteSw) {
		this.deleteSw = deleteSw;
	}




	



}
