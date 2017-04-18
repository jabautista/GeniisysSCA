package com.geniisys.gipi.exceptions;

import java.sql.SQLException;

public class PostedRIExistingException extends SQLException{

	/**
	 * 
	 */
	private static final long serialVersionUID = 6026753615506247698L;
	
	public PostedRIExistingException(String msg) {
		super(msg);
	}

	public PostedRIExistingException(Throwable cause) {
		super(cause);
	}
}
