/**
 * Call modal page for Bank reference number in GIPIS002, GIPIS017
 * @author Jerome Orio 01.11.2011
 * @version 1.0
 * @param 
 * @return
 */
function openSearchBankRefNo(){
	Modalbox.show(contextPath+"/GIPIParInformationController?action=openSearchBankRefNo&ajaxModal=1&parId="+$F("globalParId"),  
			  {title: "Search Bank Reference Number.", 
			  width: 900,
			  asynchronous: false});
}