package com.geniisys.common.exceptions;

public class ExpiredPasswordException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3875097406469939662L;

	public ExpiredPasswordException(String message){
		super(message);
	}
}
