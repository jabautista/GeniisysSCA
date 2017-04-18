/** Show LOV of Bank Name
 *  Reference By: GICLS150 - Payee Maintenance Module
 *  @author fons ellarina  
 *  @date 06.04.2014
 * */
function showBankNameLOV(obj) {
	LOV.show({
		controller : "ClaimsLOVController",
		urlParameters : {
			action : "getGICLS150BankLov",
			searchString : ($("txtBankName").readAttribute("lastValidValue") != $F("txtBankName") ? nvl($F("txtBankName"),"%") : "%"),
			page : 1
		},
		title : "List of Banks",
		width : 537,
		height : 387,
		columnModel : [ {
			id : "bankCd",
			title : "Bank Code",
			width : '100px',

		}, {
			id : "bankSname",
			title : "Bank Name",
			width : '120px'
		}, {
			id : "bankName",
			title : "Bank",
			width : '300px'
		} ],
		draggable : true,
		autoSelectOneRecord : true,
		filterText : ($("txtBankName").readAttribute("lastValidValue") != $F("txtBankName") ? nvl($F("txtBankName"),"%") : "%"),
		onSelect : function(row) {
			if(obj == objParameter){
				$("divStatus").innerHTML = "NOT YET APPROVED";
				changeTag = 1;
			}			
			$("txtBankName").value = unescapeHTML2(row.bankName)
					.toUpperCase();
			obj.bankCd = unescapeHTML2(row.bankCd);
			obj.bankName = unescapeHTML2(row.bankName);
			$("txtBankName").setAttribute("lastValidValue", unescapeHTML2(row.bankName).toUpperCase());
			$("txtBankName").focus();
		},
		onCancel : function() {
			$("txtBankName").value = $("txtBankName").readAttribute("lastValidValue");
			$("txtBankName").focus();

		},
		onUndefinedRow : function() {
			customShowMessageBox("No record selected.",
					imgMessage.INFO, "txtBankName");
			$("txtBankName").value = $("txtBankName").readAttribute("lastValidValue");
		}
	});
}