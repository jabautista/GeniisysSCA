function observeReqDocRow(row){
	row.observe("mouseover", function ()	{
		row.addClassName("lightblue");
	});

	row.observe("mouseout", function ()	{
		row.removeClassName("lightblue");
	});

	row.observe("click", function ()	{
		row.toggleClassName("selectedRow");
		var selectedRowExists = false;
		if (row.hasClassName("selectedRow"))	{
			try {
				$$("div[name='docRow']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
						selectedRowExists = true;
					}
				});
				
				$("selectedDocSw").value 			= row.down("input", 0).value;
				$("selectedDateSubmitted").value 	= row.down("input", 1).value;
				$("selectedDocCd").value 			= row.down("input", 2).value;
				$("selectedDocName").value 			= row.down("input", 3).value;
				$("selectedUserId").value 			= row.down("input", 4).value;
				$("selectedLastUpdate").value 		= row.down("input", 5).value;
				$("selectedRemarks").value 			= changeSingleAndDoubleQuotes(row.down("input", 6).value);

				var s 								= $("document");
				
				for (var i=0; i<s.length; i++)	{
					if (s.options[i].value==$("selectedDocCd").value)	{
						s.selectedIndex = i;
					}
				}

				$("docCd").value					= $("selectedDocCd").value;
				$("dateSubmitted").value 			= ($("selectedDateSubmitted").value == "---")? "" : $("selectedDateSubmitted").value;
				$("user").value 					= $("selectedUserId").value;
				$("remarks").value 					= changeSingleAndDoubleQuotes(($("selectedRemarks").value == "---")? "" : $("selectedRemarks").value);
				$("postSwitch").checked 			= $("selectedDocSw").value == "Y" ? true : false;
				$("btnAddDocument").value			= "Update";
				enableButton("btnDeleteDocument");

				togglePKFieldView("document", "txtDocName", changeSingleAndDoubleQuotes($("selectedDocName").value), selectedRowExists);
				
			} catch (e){
				showErrorMessage("observeReqDocRow", e);
			}
		} else {
			clearSelectedDocs();
			clearAddDocFields();

			$("btnAddDocument").value			= "Add";
			disableButton("btnDeleteDocument");

			//togglePKFieldView("document", "txtDocName", "", selectedRowExists);
		}
	});
}