/** Show LOV of Bank Account Type 
 *  Reference By: GICLS150 - Payee Maintenance Module
 *  @author fons ellarina  
 *  @date 06.04.2014
 * */
function showBankAcctTypeLOV(obj){
	LOV.show({
		controller : "ClaimsLOVController",
		urlParameters : {
			action : "getBankAcctTypeLOV",
			searchString : ($("txtBankAcctTyp").readAttribute("lastValidValue") != $F("txtBankAcctTyp") ? nvl($F("txtBankAcctTyp"),"%") : "%"),
			page : 1				
		},
		title : "List of Bank Account Types",
		width : 380,
		height : 270,
		columnModel : [ {
			id : "rvLowValue",
			title : "Value",
			width : '100px'
		}, {
			id : "rvMeaning",
			title : "Meaning",
			width : '265px'
		}],
		draggable : true,
		autoSelectOneRecord : true,
		filterText : ($("txtBankAcctTyp").readAttribute("lastValidValue") != $F("txtBankAcctTyp") ? nvl($F("txtBankAcctTyp"),"%") : "%"),
		onSelect : function(row) {
			if(obj == objParameter){
				$("divStatus").innerHTML = "NOT YET APPROVED";
				changeTag = 1;
			}	
			$("txtBankAcctTyp").value = unescapeHTML2(row.rvMeaning).toUpperCase();		
			obj.bankAcctTyp = unescapeHTML2(row.rvMeaning).toUpperCase();
			obj.bankAcctType = unescapeHTML2(row.rvLowValue);
			$("txtBankAcctTyp").setAttribute("lastValidValue",unescapeHTML2(row.rvMeaning).toUpperCase());
			$("txtBankAcctTyp").focus();
		},
		onCancel : function() {
			$("txtBankAcctTyp").value = $("txtBankAcctTyp").readAttribute("lastValidValue");
			$("txtBankAcctTyp").focus();
		},
		onUndefinedRow : function() {
			customShowMessageBox("No record selected.", imgMessage.INFO,
					"txtBankAcctTyp");
			$("txtBankAcctTyp").value = $("txtBankAcctTyp").readAttribute("lastValidValue");
			$("txtBankAcctTyp").focus();
		}
	});
}