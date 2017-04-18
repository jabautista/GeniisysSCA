/**
 * Created By Irwin Tabisora. 4.25.2011
 * */

function clearPackQuotationParameters(){
	//NOTE: If necessary, add more properties to clear
	try{
		$("mkQuotationParameters").update("<form id='mkQuotationParametersForm' name='mkQuotationParametersForm'>"+		
				"<input type='hidden' name='globalPackQuoteId' 		id='globalPackQuoteId' 		value='0'/>");
		objGIPIPackQuote = null;
		objGIPIPackQuotations.clear();
	}catch(e){
		showErrorMessage("clearPackQuotationParameters",e);
	}	
}