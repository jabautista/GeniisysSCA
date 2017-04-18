<div class="sectionDiv" style="width: 462px;">
	<div id="lineLossExpTableDiv" style="padding-top: 10px; padding-bottom: 10px">
		<div id="lineLossExpTable" style="height: 311px; padding-left: 6px;"></div>
	</div>
	<div align="center" style="width: 462px; margin-bottom: 10px;" >
		<input type="button" class="button" id="btnTaxRateHistory" value="Tax Rate History" tabindex="208">
	</div>
</div>
<div align="center" id="lineLossExpFormDiv" style="width: 462px;" class="sectionDiv">
	<table style="margin-top: 5px;">
		<tr>
			<td class="rightAligned" style="width:60px; padding-right: 7px;">Line</td>
			<td class="leftAligned" style="width:350px;">
				<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtLineCd" name="txtLineCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class	="required disableDelKey allCaps" maxlength="2" tabindex="101" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLine" name="searchLine" alt="Go" style="float: right;">
				</span> 
				<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
					<input type="text" id="txtLineName" name="txtLineName" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" maxlength="30" readonly="readonly" tabindex="102" />
				</span>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:60px; padding-right: 7px;">Loss/Expense</td>
			<td class="leftAligned" style="width:350px;">
				<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtLossExpCd" name="txtLossExpCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" value="00" lastValidValue="00" class="disableDelKey allCaps" maxlength="5" tabindex="103" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLossExp" name="searchLine" alt="Go" style="float: right;">
				</span> 
				<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
					<input type="text" id="txtLossExpDesc" name="txtLossExpDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" value="ALL LOSSES/EXPENSES" lastValidValue="ALL LOSSES/EXPENSES" maxlength="30" readonly="readonly" tabindex="104" />
				</span>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 7px;">Tax Rate</td>
			<td class="leftAligned" colspan="3">
				<input id="txtTaxRateLLE" type="text" class="required applyDecimalRegExp2 rightAligned" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Tax Rate" style="width: 165px;" tabindex="105" maxlength="">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
	</div>
</div>
<div align="center" style="width: 462px; margin-top: 5px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210" style=" margin-top: 10px;">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211" style="margin-top: 10px;">
</div>
<script type="text/javascript">	
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var obj = {};
	var rowIndex = -1;
	obj.exitPage = null;
	disableButton("btnTaxRateHistory");
	
	var objParams = JSON.parse('${objectParams}');
	
	var jsonLineLossExp = JSON.parse('${jsonLineLossExp}');	
			lineLossExpTable = {
					url : contextPath+"/GIISLossTaxesController?action=showLineLossExp&refresh=1&lossTaxId="+objParams.lossTaxId+"&issCd=" +unescapeHTML2(objParams.issCd),
					options: {
						id: 2,
						width: '450px',
						hideColumnChildTitle : true,
						pager: {
						},
						toolbar : {
							elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
							onFilter: function(){
								rowIndex = -1;
								setValues(null);
								tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
								tbgLineLossExp.keys.releaseKeys();
							}
						},
						onCellFocus : function(element, value, x, y, id) {
							tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
							tbgLineLossExp.keys.releaseKeys();
							setValues(tbgLineLossExp.geniisysRows[y]);
							rowIndex = y;
							enableButton("btnTaxRateHistory");
						},
						prePager: function(){
							if(changeTag == 1){
								showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
									$("btnSave").focus();
								});
								return false;
							}
							rowIndex = -1;
							tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
							tbgLineLossExp.keys.releaseKeys();
							setValues(null);
						},
						onRemoveRowFocus : function(element, value, x, y, id){					
							tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
							tbgLineLossExp.keys.releaseKeys();
							disableButton("btnTaxRateHistory");
							rowIndex = -1;
							setValues(null);
						},
						onSort : function(){
							tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
							tbgLineLossExp.keys.releaseKeys();	
							disableButton("btnTaxRateHistory");
							setValues(null);
							rowIndex = -1;
						},
						onRefresh : function(){
							tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
							tbgLineLossExp.keys.releaseKeys();
							disableButton("btnTaxRateHistory");
							setValues(null);
							rowIndex = -1;
						},
						beforeSort : function(){
							if(changeTag == 1){
								showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
									$("btnSave").focus();
								});
								return false;
							}
						},
						checkChanges: function(){
							return (changeTag == 1 ? true : false);
						},
						masterDetailRequireSaving: function(){
							return (changeTag == 1 ? true : false);
						},
						masterDetailValidation: function(){
							return (changeTag == 1 ? true : false);
						},
						masterDetail: function(){
							return (changeTag == 1 ? true : false);
						},
						masterDetailSaveFunc: function() {
							return (changeTag == 1 ? true : false);
						},
						masterDetailNoFunc: function(){
							return (changeTag == 1 ? true : false);
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
							id : 'lineCd lineName',
							title : 'Line',
							width : '150px',
							align : 'left',
							titleAlign : 'left',
							children : [ {
								id : 'lineCd',
								title: 'Line Code',
								width : 30,
								filterOption : true,
								editable : false
							}, {
								id : 'lineName',
								title: 'Line Name',
								width : 120,
								filterOption : true,
								editable : false
							} ] 
						},				
						{
							id : 'lossExpCd lossExpDesc',
							title : 'Loss/Expense',
							width : '170px',
							align : 'left',
							titleAlign : 'left',
							  children : [ {
								id : 'lossExpCd',
								title: 'Loss Exp Code',
								width : 30,
								filterOption : true,
								editable : false
							}, {
								id : 'lossExpDesc',
								title: 'Loss Exp Desc',
								width : 140,
								filterOption : true,
								editable : false
							} ]
						},
						{
							id : "taxRate",
							title: "Tax Rate",
							width: '90px',
							align : "right",
							titleAlign : "right",
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
								return formatToNthDecimal(value,9);
							}
						}
					],
					rows: jsonLineLossExp.rows
				};
			
			tbgLineLossExp = new MyTableGrid(lineLossExpTable);
			tbgLineLossExp.pager = jsonLineLossExp;
			tbgLineLossExp.render('lineLossExpTable');
			
			$("searchLine").observe("click", function(){
				showLineLOV("%");
			});
			
			function setValues(rec){
				try{
					obj.lineCd = (rec == null ? "" : unescapeHTML2(rec.lineCd));
					obj.lossExpCd = (rec == null ? "" : unescapeHTML2(rec.lossExpCd));
					obj.lineName = (rec == null ? "" : unescapeHTML2(rec.lineName));
					obj.lossExpDesc = (rec == null ? "" : unescapeHTML2(rec.lossExpDesc));
					$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
					$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
					$("txtLossExpCd").value = (rec == null ? "00" : unescapeHTML2(rec.lossExpCd));
					$("txtLossExpDesc").value = (rec == null ? "ALL LOSSES/EXPENSES" : unescapeHTML2(rec.lossExpDesc));
					$("txtTaxRateLLE").value = (rec == null ? "" : (formatToNthDecimal(rec.taxRate,9)));
					
					rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
					//rec == null ? enableButton("btnAdd") : disableButton("btnAdd");
					rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
					rec == null ? $("txtLossExpCd").readOnly = false : $("txtLossExpCd").readOnly = true;
					//rec == null ? $("txtTaxRateLLE").readOnly = false : $("txtTaxRateLLE").readOnly = true;
					rec == null ? enableSearch("searchLine") : disableSearch("searchLine");
					rec == null ? enableSearch("searchLossExp") : disableSearch("searchLossExp");
				} catch(e){
					showErrorMessage("setValues", e);
				}
			}
			
			function showLineLOV(x){
				try{
					LOV.show({
						controller : "ClaimsLOVController",
						urlParameters : {
							  action : "getGicls106LineLOV",
							  issCd : unescapeHTML2(objParams.issCd),
							  search : x,
								page : 1
						},
						title: "List of Lines",
						width: 400,
						height: 400,
						columnModel: [
				 			{
								id : 'lineCd',
								title: 'Line Cd',
								width : '100px',
								align: 'left'
							},
							{
								id : 'lineName',
								title: 'Line Name',
							    width: '265px',
							    align: 'left'
							}
						],
						autoSelectOneRecord : true,
						filterText: nvl(escapeHTML2(x), "%"), 
						draggable: true,
						onSelect: function(row) {
							if(row != undefined){
								$("txtLineCd").value = unescapeHTML2(row.lineCd);
								$("txtLineName").value = unescapeHTML2(row.lineName);
								if($("txtLineCd").value != $("txtLineCd").getAttribute("lastValidValue")){
									$("txtLossExpCd").value = "00";
									$("txtLossExpDesc").value = "ALL LOSSES/EXPENSES";
									$("txtLossExpCd").setAttribute("lastValidValue", "00");
									$("txtLossExpDesc").setAttribute("lastValidValue", "ALL LOSSES/EXPENSES");
								}
								$("txtLineCd").setAttribute("lastValidValue",unescapeHTML2(row.lineCd));
								$("txtLineName").setAttribute("lastValidValue",unescapeHTML2(row.lineName));
							}
						},
						onCancel: function(){
							$("txtLineCd").focus();
							$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
							$("txtLineName").value = $("txtLineName").getAttribute("lastValidValue");
				  		},
				  		onUndefinedRow: function(){
				  			$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
							$("txtLineName").value = $("txtLineName").getAttribute("lastValidValue");
							customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				  		}
					});
				}catch(e){
					showErrorMessage("showLineLOV",e);
				}
			}
			
			$("searchLossExp").observe("click", function(){
					showLossExpLOV("%");
			});
			
			var lineLossExp = {};
			
			function showLossExpLOV(x){
				try{
					LOV.show({
						controller : "ClaimsLOVController",
						urlParameters : {
							  action : "getGicls106LossExpLOV",
							  search : x,
								page : 1,
								lineCd : $F("txtLineCd")
						},
						title: "List of Losses/Expenses",
						width: 400,
						height: 400,
						columnModel: [
				 			{
								id : 'lossExpCd',
								title: 'Loss Exp Cd',
								width : '87px',
								align: 'left'
							},
							{
								id : 'lossExpDesc',
								title: 'Loss Exp Desc',
							    width: '205px',
							    align: 'left'
							},
							{
								id : 'lossExpType',
								title: 'Loss Exp Type',
							    width: '87px',
							    align: 'left'
							}
						],
						autoSelectOneRecord : true,
						filterText: nvl(escapeHTML2(x), "%"), 
						draggable: true,
						onSelect: function(row) {
							if(row != undefined){
								$("txtLossExpCd").value = unescapeHTML2(row.lossExpCd);
								$("txtLossExpDesc").value = unescapeHTML2(row.lossExpDesc);
								lineLossExp.lossExpType = unescapeHTML2(row.lossExpType);
								$("txtLossExpCd").setAttribute("lastValidValue",unescapeHTML2(row.lossExpCd));
								$("txtLossExpDesc").setAttribute("lastValidValue",unescapeHTML2(row.lossExpType));
							}
						},
						onCancel: function(){
							$("txtLossExpCd").focus();
							$("txtLossExpCd").value = $("txtLossExpCd").getAttribute("lastValidValue");
							$("txtLossExpDesc").value = $("txtLossExpDesc").getAttribute("lastValidValue");
				  		},
				  		onUndefinedRow: function(){
				  			$("txtLossExpCd").value = $("txtLossExpCd").getAttribute("lastValidValue");
							$("txtLossExpDesc").value = $("txtLossExpDesc").getAttribute("lastValidValue");
							customShowMessageBox("No record selected.", imgMessage.INFO, "txtLossExpCd");
				  		}
					});
				}catch(e){
					showErrorMessage("showLossExpLOV",e);
				}
			}
			
			
			
			function setRec(){
				try {
					//var obj = (rec == null ? {} : rec);
					var obj = {};
					obj.lineCd = escapeHTML2($F("txtLineCd"));
					obj.lineName = escapeHTML2($F("txtLineName"));
					obj.lossExpCd = escapeHTML2($F("txtLossExpCd"));
					obj.lossExpDesc = escapeHTML2($F("txtLossExpDesc"));
					obj.taxRate = escapeHTML2($F("txtTaxRateLLE"));
					obj.lossExpType = lineLossExp.lossExpType;
					obj.lossTaxId = objParams.lossTaxId;
					//obj.userId = userId;
					/* var lastUpdate = new Date();
					obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'); */
					
					return obj;
				} catch(e){
					showErrorMessage("setRec", e);
				}
			}
			
			function addRec(){
				try {
					var lineLossExp = setRec();
					if($F("btnAdd") == "Add"){
						tbgLineLossExp.addBottomRow(lineLossExp);
					} else {
						tbgLineLossExp.updateVisibleRowOnly(lineLossExp, rowIndex, false);
					}
					changeTag = 1;
					clearFields();
					setValues(null);
					tbgLineLossExp.keys.removeFocus(tbgLineLossExp.keys._nCurrentFocus, true);
					tbgLineLossExp.keys.releaseKeys();
				} catch(e){
					showErrorMessage("addRec", e);
				}
			}	
			
			function clearFields(){
				$("txtLineCd").value = "";
				$("txtLossExpCd").value = "00";
				$("txtTaxRateLLE").value = "";
				$("txtLineName").value = "";
				$("txtLossExpDesc").value = "ALL LOSSES/EXPENSES";
				obj.lossExpType = "";
			}
			
			$("btnAdd").observe("click", valLineLossExp);
			$("btnSave").observe("click", saveLineLossExp);
			
			$("btnCancel").observe("click", function(){
				if(changeTag == 0) {
					closeLineLossExp();
				} else {
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
							"Yes", "No", "Cancel", function() {
								obj.exitPage = closeLineLossExp;
								saveLineLossExp();
							}, function() {
								closeLineLossExp();
							}, "");
				}
			});
			
			function closeLineLossExp(){
				changeTag = 0;
				overlayLineLossExp.close();
				delete overlayLineLossExp;
			}
			
			function saveLineLossExp(){
				if(changeTag == 0) {
					showMessageBox(objCommonMessage.NO_CHANGES, "I");
					return;
				}
				var setRows = getAddedAndModifiedJSONObjects(tbgLineLossExp.geniisysRows);
				new Ajax.Request(contextPath+"/GIISLossTaxesController", {
					method: "POST",
					parameters : {
									action : "saveLineLossExp",
							 	  	setRows : prepareJsonAsParameter(setRows),
							 	  },
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if(obj.exitPage != null) {
									obj.exitPage();
								} else {
									tbgLineLossExp._refreshList();
								}
							});
							changeTag = 0;
							enableButton($("btnCopyTaxLine"));
						}
					}
				});
			}
			
			function valLineLossExp(){
				try{
					if(checkAllRequiredFieldsInDiv("lineLossExpFormDiv")){
						if($F("btnAdd") == "Add") {
							var addedSameExists = false;
							
							for ( var i = 0; i < tbgLineLossExp.geniisysRows.length; i++) {
								if (tbgLineLossExp.geniisysRows[i].recordStatus == 0 || tbgLineLossExp.geniisysRows[i].recordStatus == 1) {
									if (unescapeHTML2(tbgLineLossExp.geniisysRows[i].lossExpCd) == $F("txtLossExpCd") && unescapeHTML2(tbgLineLossExp.geniisysRows[i].lineCd) == $F("txtLineCd")) {
										addedSameExists = true;
									}
								} 
							}
							if (addedSameExists) {
								showMessageBox("Record already exists with the same line_cd and loss_exp_cd.", imgMessage.ERROR);
								return;
							}
							new Ajax.Request(contextPath + "/GIISLossTaxesController", {
								parameters : {
												action : "valLineLossExp",
											  	lossExpCd : $F("txtLossExpCd"),
											  	lineCd : $F("txtLineCd"),
											  	lossTaxId : objParams.lossTaxId
											 },
								onCreate : showNotice("Processing, please wait..."),
								onComplete : function(response){
									hideNotice();
									if(response.responseText == "Y"){
										showMessageBox("Record already exists with the same line_cd and loss_exp_cd.", imgMessage.ERROR);
									} else if(response.responseText != "Y"){
										addRec();
									} else {
										addRec();
									}
								}
							});
						} else {
							addRec();
						}
					}
				} catch(e){
					showErrorMessage("valLineLossExp", e);
				}
			}
			
			$("txtLineCd").observe("change", function(){
				if($("txtLineCd").value == ""){
					$("txtLineName").value = "";
					$("txtLossExpCd").value = "00";
					$("txtLossExpDesc").value = "ALL LOSSES/EXPENSES";
					$("txtLineCd").setAttribute("lastValidValue", "");
					$("txtLineName").setAttribute("lastValidValue", "");
					$("txtLossExpCd").setAttribute("lastValidValue", "00");
					$("txtLossExpDesc").setAttribute("lastValidValue", "ALL LOSSES/EXPENSES");
				} else {
					validateLine();
				}
			});
			
			$("txtLossExpCd").observe("change", function(){
				if($("txtLossExpCd").value == ""){
					$("txtLossExpCd").value = "00";
					$("txtLossExpDesc").value = "ALL LOSSES/EXPENSES";
					$("txtLossExpCd").setAttribute("lastValidValue", "00");
					$("txtLossExpDesc").setAttribute("lastValidValue", "ALL LOSSES/EXPENSES");
				} else {
					validateLossExp();
				}
			});
			
			function validateLine(){
				new Ajax.Request(contextPath+"/GIISLossTaxesController", {
					method: "POST",
					parameters: {
						action: "validateGicls106Line",
						lineCd: $F("txtLineCd"),
						issCd: unescapeHTML2(objParams.issCd)
					},
					onCreate: showNotice("Please wait..."),
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText);
							if(nvl(obj.lineCd, "") == ""){
								showLineLOV($("txtLineCd").value);
							} else if(obj.lineCd == "manyrows"){
								showLineLOV($("txtLineCd").value);
							} else{
								$("txtLineCd").value = unescapeHTML2(obj.lineCd);
								$("txtLineName").value = unescapeHTML2(obj.lineName);
								if($("txtLineCd").value != $("txtLineCd").getAttribute("lastValidValue")){
									$("txtLossExpCd").value = "00";
									$("txtLossExpDesc").value = "ALL LOSSES/EXPENSES";
									$("txtLossExpCd").setAttribute("lastValidValue", "00");
									$("txtLossExpDesc").setAttribute("lastValidValue", "ALL LOSSES/EXPENSES");
								}
								$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(obj.lineCd));
								$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(obj.lineName));
							}
						}
					}
				});
			}
			
			function validateLossExp(){
				new Ajax.Request(contextPath+"/GIISLossTaxesController", {
					method: "POST",
					parameters: {
						action: "validateGicls106LossExp",
						lineCd: $F("txtLineCd"),
						lossExpCd: $F("txtLossExpCd")
					},
					onCreate: showNotice("Please wait..."),
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText);
							if(nvl(obj.lossExpCd, "") == ""){
								showLossExpLOV($("txtLossExpCd").value);
							} else if (obj.lossExpCd == "manyrows"){
								showLossExpLOV($("txtLossExpCd").value);
							} else{
								$("txtLossExpCd").value = unescapeHTML2(obj.lossExpCd);
								$("txtLossExpDesc").value = unescapeHTML2(obj.lossExpDesc);
								lineLossExp.lossExpType = unescapeHTML2(obj.lossExpType);
								$("txtLossExpCd").setAttribute("lastValidValue",unescapeHTML2(obj.lossExpCd));
								$("txtLossExpDesc").setAttribute("lastValidValue",unescapeHTML2(obj.lossExpDesc));
							}
						}
					}
				});
			}
			
			$("btnTaxRateHistory").observe("click", function(){
				if (changeTag == 1) {
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				} else {
					showLineLossExpHistory();
				} 
			});
			
			
			
			function showLineLossExpHistory() {
				try {
					overlayLineLossExpHist = Overlay.show(contextPath
							+ "/GIISLossTaxesController", {
						urlContent : true,
						urlParameters : {
							action : "showLineLossExpHistory",
							ajax : "1",
							lossTaxId : objParams.lossTaxId,
							lineCd : obj.lineCd,
							lossExpCd : obj.lossExpCd,
							lineName : obj.lineName,
							lossExpDesc : obj.lossExpDesc
							},
						title : "Tax Rate History per Line and Loss/Expense",
						height: 380,
						 width: 403,
						draggable : true
					});
				} catch (e) {
					showErrorMessage("showLineLossExp", e);
				}
			}
</script>