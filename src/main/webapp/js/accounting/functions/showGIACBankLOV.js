/**
 * Shows giac bank list of values
 * @author andrew robes
 * @date 10.21.2011
 * @module GIACS090
 */
function showGIACBankLOV(rep){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getGIACBankLOV",
						page: 1},
		title: "Bank List",
		width: 500,
		height: 350,
		columnModel : [
		               {
		            	   id : "bankSname",
		            	   title: "Bank",
		            	   width: '120px'		            	   
		               },
		               {
		            	   id: "bankName",
		            	   title: "Bank Name",
		            	   width: '300px'
		               },
		               {
		            	   id: "bankCd",
		            	   title: "Bank Code",
		            	   width: '100px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			$("txtBankName"+rep).value = unescapeHTML2(row.bankName); //added by steven 9/27/2012
			$("hidBankCd"+rep).value = row.bankCd;
		}
	});	
}