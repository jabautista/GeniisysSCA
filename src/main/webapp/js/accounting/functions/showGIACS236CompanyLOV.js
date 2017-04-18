function showGIACS236CompanyLOV() {
	// onLOV = true;
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {
			action : "getGIACS236CompanyLOV",
			//searchString : $("txtFreeText").value,
			page : 1,
			controlModule :"GIACS236"
		},
		title : "Valid Values for Company",
		width : 370,
		height : 400,
		columnModel : [ {
			id: "fundCd",
			title: "Code",
			width : '100px',
		}, {
			id : "fundDesc",
			title : "Description",
			width : '235px',
			renderer: function(value) {
				return unescapeHTML2(value);
			}
		} ],
		draggable : true,
		//autoSelectOneRecord: true,
		//filterText:  $("txtFreeText").value,
		onSelect : function(row) {
			$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
			/* recoveryDetailsCount = row.recoveryDetailsCount;
			onLOV = false;
			assdNo = row.assdNo;
			freeText = unescapeHTML2(row.assdName);
			$("txtFreeText").value = freeText;
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery"); */
		},
		onCancel : function () {
			/* onLOV = false;
			$("txtFreeText").focus(); */
		},
		onUndefinedRow : function(){
			/* customShowMessageBox("No record selected.", imgMessage.INFO, "txtFreeText");
			onLOV = false; */
		}
	});
}