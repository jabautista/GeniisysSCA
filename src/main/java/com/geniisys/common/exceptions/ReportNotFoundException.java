package com.geniisys.common.exceptions;

public class ReportNotFoundException extends RuntimeException{

	private static final long serialVersionUID = 1L;
	
	public ReportNotFoundException(){
		super("The report you are trying to generate does not exist.");
	}
	
	public ReportNotFoundException(String message){		
		super(message);
	}

}
