package com.geniisys.giac.exceptions;

public class InvalidGIACInputVatDataException extends RuntimeException{
	
	private static final long serialVersionUID = 1L;

	public InvalidGIACInputVatDataException(String message){
		super(message);
	}
}
