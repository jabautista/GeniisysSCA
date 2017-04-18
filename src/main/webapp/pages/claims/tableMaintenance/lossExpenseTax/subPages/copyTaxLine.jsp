<div class="sectionDiv" style="width: 380px; margin-top: 5px;">
	<div id="copyTaxLineTableDiv" style="padding-top: 10px; padding-bottom: 10px">
		<div id="copyTaxLineTable" style="height: 311px; padding-left: 10px;"></div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 10px; width: 100px;" />
	<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">	
	var objIssCd = JSON.parse('${objIssCd}');
	
	var obj = {};
	obj.exitPage = null;
	
	function closeOverlay(){
		overlayCopyTax.close();
		delete overlayCopyTax;
	}
	
	$("btnCancel").observe("click", function(){
		if (group.length != 0) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						obj.exitPage = closeOverlay;
						copyTaxandLineToIssueSource();
					}, function() {
						closeOverlay();
					}, "");
		} else {
			closeOverlay();
		}
	});
	
	$("btnOk").observe("click", function(){
		if(group.length != 0){
			showConfirmBox("Confirmation", "Are you sure you want to copy tax?", "Yes", "No",
					function(){
						copyTaxandLineToIssueSource();
					},
					function(){
						tbgCopyTax._refreshList();
					}, "");
		} else {
			customShowMessageBox("Please check the issuing source to which the tax code will be copied.", imgMessage.INFO, "btnOk");
		}
	});
	
	function copyTaxandLineToIssueSource(){
		for ( var i = 0; i < group.length; i++) {
			new Ajax.Request(contextPath+"/GIISLossTaxesController", {
				method: "POST",
				parameters : {
								action : "copyTaxToIssuingSourceAndTaxLine",
								origIssCd: objIssCd.issCd,
								taxType: '${taxType}',
								taxCd:	'${taxCd}',
								taxName: unescapeHTML2('${taxName}'),
								taxRate: '${taxRate}',
								startDate: '${startDate}',
								endDate: '${endDate}',
								glAcctId: '${glAcctId}',
								slTypeCd: '${slTypeCd}',
								remarks: unescapeHTML2('${remarks}'),
								issCd: unescapeHTML2(group[i])
							},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					/* showWaitingMessageBox("Transaction Complete. " + group.length + (group.length == 1 ? " record saved." : " records saved."), imgMessage.SUCCESS, function(){
						if(obj.exitPage != null){
							obj.exitPage();
						} else {
							tbgCopyTax._refreshList();
						}
					}); */
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(obj.exitPage != null){
							obj.exitPage();
						} else {
							tbgCopyTax._refreshList();
						}
					});
				}
			});
		}
	}
	
	selectIssCd = "";
	currY = 0;
	checkboxVal = "";
	group = [];
	
	function insertToGroup(issCd){
		var notExist = true;
		if(group.length == 0){
			group.push(issCd);
			notExist = false;
		} else {
			for ( var i = 0; i < group.length; i++) {
				if(group[i] == issCd){
					notExist = false;
					break;
				}
			}
		}
		if(notExist){
			group.push(issCd);
		}
	}
	
	function removeToGroup(issCd){
		for (var i = 0; i < group.length; i++) {
			if(group[i] == issCd){
				group.splice(i, 1);
			}
		}
	}
	
	function tableCheckBox(grpSw, issCd){
		if(grpSw == "Y"){
			validateTaxToIss(issCd);
		} else if (grpSw == "N"){
			removeToGroup(issCd);
		}
	}
	
	var jsonCopyTax = JSON.parse('${jsonCopyTax}');	
		copyTaxLineTable = {
				url : contextPath+"/GIISLossTaxesController?action=showCopyTaxLine&refresh=1&issCd="+ objIssCd.issCd,
				options: {
					width: '360px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						currY = Number(y);
						selectIssCd = tbgCopyTax.getValueAt(tbgCopyTax.getColumnIndex("issCd"),currY);
						//checkboxVal = tbgCopyTax.getValueAt(tbgCopyTax.getColumnIndex("grpSw"),currY);
						checkboxVal = tbgCopyTax.rows[currY][tbgCopyTax.getColumnIndex('grpSw')];
						tableCheckBox(checkboxVal,selectIssCd);
						tbgCopyTax.keys.removeFocus(tbgCopyTax.keys._nCurrentFocus, true);
						tbgCopyTax.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						currY = 0;
						selectIssCd = "";
						checkboxVal = "";
						tbgCopyTax.keys.removeFocus(tbgCopyTax.keys._nCurrentFocus, true);
						tbgCopyTax.keys.releaseKeys();
					},
					onSort : function(){
						group = [];
						currY = 0;
						selectIssCd = "";
						checkboxVal = "";
						tbgCopyTax.keys.removeFocus(tbgCopyTax.keys._nCurrentFocus, true);
						tbgCopyTax.keys.releaseKeys();	
					},
					onRefresh : function(){
						group = [];
						currY = 0;
						selectIssCd = "";
						checkboxVal = "";
						tbgCopyTax.keys.removeFocus(tbgCopyTax.keys._nCurrentFocus, true);
						tbgCopyTax.keys.releaseKeys();
					},
					prePager: function(){
						if(group.length != 0){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnOk").focus();
							});
							return false;
						}
						tbgCopyTax.keys.removeFocus(tbgCopyTax.keys._nCurrentFocus, true);
						tbgCopyTax.keys.releaseKeys();
					},
					beforeSort : function(){
						if(group.length != 0){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnOk").focus();
							});
							return false;
						}
					},
					checkChanges: function(){
						return (group.length != 0 ? true : false);
					},
					masterDetailRequireSaving: function(){
						return (group.length != 0 ? true : false);
					},
					masterDetailValidation: function(){
						return (group.length != 0 ? true : false);
					},
					masterDetail: function(){
						return (group.length != 0 ? true : false);
					},
					masterDetailSaveFunc: function() {
						return (group.length != 0 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (group.length != 0? true : false);
					}	
					
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: 'grpSw',
	              		title : ' ',
		              	width: '30px',
		              	sortable: false,
		              	editable: true,
		              	editor: new MyTableGrid.CellCheckbox({
			            	getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
		              	})
					},				
					{
						id : "issCd", 
						title: "Code",
						width: '100px'
					},
					{
						id : "issName",
						title: "Branch Name",
						width: '210px'
					}
				],
				rows: jsonCopyTax.rows
			};
		
		tbgCopyTax = new MyTableGrid(copyTaxLineTable);
		tbgCopyTax.pager = jsonCopyTax;
		tbgCopyTax.render('copyTaxLineTable');
		var x = true;
		function validateTaxToIss(issCd){
			new Ajax.Request(contextPath+"/GIISLossTaxesController", {
				method: "POST",
				parameters: {
					action: "validateGicls106LossTaxes",
					taxCd: '${taxCd}',
					taxType: '${taxType}',
					issCd: unescapeHTML2(selectIssCd)
				},
				onCreate: showNotice("Please wait..."),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if(obj.output == "exist"){
							showWaitingMessageBox("Tax Code already exists in selected branch (" + unescapeHTML2(selectIssCd) + ").", "I", function(){
								tbgCopyTax.setValueAt(false, tbgCopyTax.getColumnIndex('grpSw'), currY, true);
							});
						}
						else{
							insertToGroup(issCd);
						}
					}
				}
			});
		}
	
</script>