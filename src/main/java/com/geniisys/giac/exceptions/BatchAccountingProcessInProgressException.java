package com.geniisys.giac.exceptions;

public class BatchAccountingProcessInProgressException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public BatchAccountingProcessInProgressException(String msg) {
		super(msg);
	}
}
