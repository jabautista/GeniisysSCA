<div id="openPerilMainDiv" name="openPerilMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Peril</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="openPerilDiv" name="openPerilDiv" class="sectionDiv" style="height: 300px;">
		<div id="openPerilTGDiv" name="openPerilTGDiv" style="float: left; width: 78.5%; height: 160px; padding: 10px 0 0 100px;">
		
		</div>
		<div id="withInvoiceDiv" name="withInvoiceDiv" class="sectionDiv" style="width: 75px; margin: 70px 0 0 0;" align="center">
			<table align="center" width="20px" style="margin: 5px 0px 5px 0px">
				<tr>
					<td width="90%" align="center" style="font-size: 11px;"><input type="checkbox" id="withInvoice" name="withInvoice" disabled="disabled" style="background-color: green;"><br/>With Invoice</td>
				</tr>
			</table>
		</div>
		<div id="openPerilInfoDiv" name="openPerilInfoDiv" style="float: left; width: 100%;" align="center">
			<table width="47%">
				<tr>
					<td class="rightAligned" width="22%">Peril</td>
					<td class="leftAligned" width="78%">
						<span class="required lovSpan" style="width: 100%;">
							<input id="txtPerilName" name="txtPerilName" class="required" type="text" style="border: none; float: left; width: 280px; height: 13px; margin: 0px;" readonly="readonly" tabindex="401"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOpenPeril" name="searchOpenPeril" alt="Go" style="float: right;" tabindex="402"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Premium Rate</td>
					<td class="leftAligned"><input type="text" id="txtPremiumRate" name="txtPremiumRate" style="width: 97.5%; text-align: right;" tabindex="403" class="nthDecimal2" maxlength="13"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 99.5%;">
							<textarea id="txtRemarks" name="txtRemarks" style="width: 91%; border: none; height: 13px;" tabindex="404" maxlength="4000"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="405"/>
						</div>
					</td>
				</tr>				
			</table>
		</div>
		<div id="openPerilButtonsDiv" name="openPerilButtonsDiv" class="buttonsDiv" style="float: left; width: 100%;">
			<input id="btnAddOpenPeril" name="btnAddOpenPeril" type="button" class="button" value="Add" tabindex="406">
			<input id="btnDeleteOpenPeril" name=""btnDeleteOpenPeril"" type="button" class="disabledButton" value="Delete" tabindex="407">
		</div>
		<div id="hiddenOpenPerilDiv" name="hiddenOpenPerilDiv" style="display: none;">
			<input id="perilCdHid" name="perilCdHid" type="hidden" value="">
			<input id="basicPerilCdHid" name="basicPerilCdHid" type="hidden" value="">
			<input id="perilTypeHid" name="perilTypeHid" type="hidden" value="">
		</div>
	</div>
</div>

<script type="text/javascript">
	initializeAllMoneyFields();
	objEndtLol.selectedPerilIndex = -1;
	objEndtLol.selectedPerilRow = "";
	objEndtLol.openPeril = [];
	
	objEndtLol.objOpenPerilTableGrid = JSON.parse('${openPerilTG}');
	objEndtLol.objOpenPerilRows = objEndtLol.objOpenPerilTableGrid.rows || [];
	try{
		var openPerilTableModel = {
			url: contextPath+"/GIPIWOpenPerilController?action=getEndtOpenPeril&refresh=1&globalParId="+$F("globalParId")+"&geogCd="+$F("geogCd")
					+"&lineCd="+$F("globalLineCd"),
			options: {
	          	height: '131px',
	          	width: '700px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objEndtLol.selectedPerilIndex = y;
	          		objEndtLol.selectedPerilRow = openPerilTableGrid.geniisysRows[y];
	          		populateOpenPerilFields(true);
	          		openPerilTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objEndtLol.selectedPerilIndex = -1;
	          		objEndtLol.selectedPerilRow = "";
	          		populateOpenPerilFields(false);
	          		openPerilTableGrid.keys.releaseKeys();
	            },
	            beforeSort: function(){
	            	if(changeTagPeril == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	openPerilTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		openPerilTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		openPerilTableGrid.onRemoveRowFocus();
	            	}
	            },
	            prePager: function(){
					if(changeTagPeril == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
                checkChanges: function(){
					return (changeTagPeril == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
				    return (changeTagPeril == 1 ? true : false);
				},
				masterDetailValidation: function(){
				    return (changeTagPeril == 1 ? true : false);
				},
				masterDetail: function(){
				    return (changeTagPeril == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
				    return (changeTagPeril == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
				    return (changeTagPeril == 1 ? true : false);
				}
			},
			columnModel:[
							{   id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox'
							},
							{	id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	id: 'perilName',
								title: 'Peril',
								width: '295px',
								visible: true,
								filterOption: true
							},
							{	id: 'premiumRate',
								title: 'Premium Rate',
								width: '100px',
								align: 'right',
								geniisysClass: 'rate',
								visible: true,
								filterOption: true,
								filterOptionType: 'number'
							},
							{	id: 'remarks',
								title: 'Remarks',
								width: '274px',
								visible: true,
								filterOption: true
							}
						],  				
					rows: objEndtLol.objOpenPerilRows
		};
		openPerilTableGrid = new MyTableGrid(openPerilTableModel);
		openPerilTableGrid.pager = objEndtLol.objOpenPerilTableGrid;
		openPerilTableGrid.render('openPerilTGDiv');
		openPerilTableGrid.afterRender = function(){
			objEndtLol.openPeril = openPerilTableGrid.geniisysRows;
			$("withInvoice").checked = checkInvoiceTag();
		};
	}catch(e){
		showMessageBox("Error in Open Peril TableGrid: " + e, imgMessage.ERROR);
	}
	
	function populateOpenPerilFields(populate){
		$("perilCdHid").value = populate ? objEndtLol.selectedPerilRow.perilCd : "";
		$("txtPerilName").value = populate ? unescapeHTML2(objEndtLol.selectedPerilRow.perilName) : "";
		$("txtPremiumRate").value = populate ? formatToNineDecimal(objEndtLol.selectedPerilRow.premiumRate) : "";
		$("txtRemarks").value = populate ? unescapeHTML2( objEndtLol.selectedPerilRow.remarks) : "";
		$("basicPerilCdHid").value = populate ? objEndtLol.selectedPerilRow.basicPerilCd : "";
		$("perilTypeHid").value = populate ? objEndtLol.selectedPerilRow.perilTypeHid : "";
		
		if(populate){
			$("btnAddOpenPeril").value = "Update";
			disableSearch("searchOpenPeril");
			enableButton("btnDeleteOpenPeril");
		}else{
			$("btnAddOpenPeril").value = "Add";
			enableSearch("searchOpenPeril");
			disableButton("btnDeleteOpenPeril");
		}
	}
	
	function checkInvoiceTag(){
		var rows = row = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});	
		for(var i = 0; i < rows.length; i++){
			if(nvl(rows[i].premiumRate, "") != "" && rows[i].perilCd != objEndtLol.selectedPerilRow.perilCd){
				return true;
			}
		}
		return false;
	}
	
	function showOpenPerilLOV(){
		try{
			var notIn = "";
			var withPrevious = false;
			var perilType = "";
			var rows = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
			
			for(var i = 0; i < rows.length; i++){
				notIn += withPrevious ? "," : "";
				notIn = notIn + rows[i].perilCd;
				withPrevious = true;
			}
			perilType = notIn == "" ? "B" : "";
		
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action 	  : "getWOpenPerilLOV",
								lineCd 	  : $F("globalLineCd"),
								sublineCd : $F("globalSublineCd"),
								perilType : perilType,
								notIn	  : notIn != "" ? "("+notIn+")" : "0"
							    },
				title: "List of Perils",
				width: 421,
				height: 386,
				columnModel:[
				             	{	id : "perilName",
									title: "Peril",
									width: '225px'
								},
								{	id : "perilSname",
									title: "Peril Short Name",
									width: '110px'
								},
								{	id : "perilType",
									title: "Peril Type",
									width: '65px'
								},
								{	id : "perilCd",
									width: '0px',
									visible: false
								},
								{	id : "bascPerlCd",
									width: '0px',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						if($F("recFlag") == "D"){
							checkRiskNote(row);
						}else{
							if(validatePeril(row)){
								$("txtPerilName").value = unescapeHTML2(row.perilName);
								$("perilCdHid").value = row.perilCd;
								$("basicPerilCdHid").value = row.bascPerlCd;
								$("perilTypeHid").value = row.perilType;
							}else{
								showMessageBox("The basic peril (" + row.bascPerlName + ") shoud first be added before this allied peril.", "E");
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("showOpenPerilLOV",e);
		}
	};
	
	function checkRiskNote(row){
		new Ajax.Request(contextPath+"/GIPIWOpenLiabController",{
			method: "GET",
			parameters:{
				action    : "checkRiskNote",
				perilCd	  : row.perilCd,
				geogCd	  : $F("geogCd"),
				lineCd	  : objEndtLol.vars.lineCd,
				sublineCd : objEndtLol.vars.sublineCd,
				issCd	  : objEndtLol.vars.issCd,
				polSeqNo  : objEndtLol.vars.polSeqNo
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						if(validatePeril(row)){
							$("txtPerilName").value = unescapeHTML2(row.perilName);
							$("perilCdHid").value = row.perilCd;
						}else{
							showMessageBox("The basic peril (" + row.bascPerlName + ") shoud first be added before this allied peril.", "E");
						}
					}else{
						showMessageBox(obj.message, "I");
					}
				}
			}
		});
	}
	
	function validatePeril(peril){
		var rows = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
		
		if(nvl(peril.bascPerlCd, "") != ""){
			for(var i = 0; i < rows.length; i++){
				if(peril.bascPerlCd == rows[i].perilCd){
					return true;
				}
			}
			return false;
		}
		return true;
	}
	
	function checkBasicPeril(){
		var perilCd = objEndtLol.selectedPerilRow.perilCd;
		var rows = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
		
		for(var i = 0; i < rows.length; i++){
			if(rows[i].basicPerilCd == perilCd){
				return rows[i].perilName;
			}
		}
		
		var isBasicExists = false;
		var perilName = null;
		for(var i = 0; i < rows.length; i++){
			if(rows[i].perilType == 'B' && rows[i].perilCd != perilCd){
				isBasicExists = true;
				break;
			}
			for(var x = 0; x < rows.length; x++){
				if(rows[x].perilType == 'A'){
					perilName = rows[x].perilName;
					break;
				}
			}
		}
		
		return isBasicExists ? "" : perilName;
	}
		
	function addOpenPeril(){
		var rowObj = setOpenPeril($("btnAddOpenPeril").value);
		if($("btnAddOpenPeril").value == "Add"){
			objEndtLol.openPeril.push(rowObj);
			openPerilTableGrid.addBottomRow(rowObj);
		}else{
			objEndtLol.openPeril.splice(objEndtLol.selectedPerilIndex, 1, rowObj);
			openPerilTableGrid.updateVisibleRowOnly(rowObj, objEndtLol.selectedPerilIndex);
		}
		openPerilTableGrid.onRemoveRowFocus();
		changeTag = 1;
		changeTagPeril = 1;
	}
	
	function deleteOpenPeril(){
		var delObj = setOpenPeril("Delete");
		objEndtLol.openPeril.splice(objEndtLol.selectedPerilIndex, 1, delObj);
		openPerilTableGrid.deleteVisibleRowOnly(objEndtLol.selectedPerilIndex);
		openPerilTableGrid.onRemoveRowFocus();
		changeTag = 1;
		changeTagPeril = 1;
	}
	
	function setOpenPeril(func){
		var rowObjPeril = new Object();
		rowObjPeril.parId = $F("globalParId");
		rowObjPeril.geogCd = $F("geogCd");
		rowObjPeril.lineCd = $F("globalLineCd");
		rowObjPeril.perilCd = $F("perilCdHid");
		rowObjPeril.perilName = $F("txtPerilName");
		rowObjPeril.recFlag = "A";
		rowObjPeril.premiumRate = $F("txtPremiumRate");
		rowObjPeril.withInvoiceTag = $("withInvoice").checked ? "Y" : "N";
		rowObjPeril.remarks = $F("txtRemarks");
		rowObjPeril.basicPerilCd = $F("basicPerilCdHid");
		rowObjPeril.perilType = $F("perilTypeHid");
		rowObjPeril.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return rowObjPeril;
	}
	
	function validatePremiumRate(){
		if($F("txtPremiumRate") != ""){
			if(isNaN(parseFloat($F("txtPremiumRate")))){
				showWaitingMessageBox("Invalid Premium Rate. Valid value should be from 0.000000001 to 100.000000000.", "I", function(){
					$("txtPremiumRate").value = "";
				});
				return false;
			}else if(parseFloat($F("txtPremiumRate")) > parseFloat(100) || parseFloat($F("txtPremiumRate")) <= 0){
				showWaitingMessageBox("Invalid Premium Rate. Valid value should be from 0.000000001 to 100.000000000.", "I", function(){
					$("txtPremiumRate").value = "";
				});
				return false;
			}else if(checkInvoiceTag()){
				showWaitingMessageBox("Limit of liability is automatically identified as Total Sum Insured. " +
					"To compute for the premium of MOP (TSI * rate), only one rate must be entered on any Basic Peril.", "I",
					function(){
						$("txtPremiumRate").value = "";
					});
				return false;
			}
		}
		return true;
	}
	
	$("txtPremiumRate").observe("focus", function(){
		if($F("txtPerilName") == ""){
			showMessageBox("Please select a peril first.", "I");
		}
	});
	
	$("txtRemarks").observe("focus", function(){
		if($F("txtPerilName") == ""){
			showMessageBox("Please select a peril first.", "I");
		}
	});
	
	$("txtPremiumRate").observe("change", function(){
		validatePremiumRate();
	});
	
	$("searchOpenPeril").observe("click", function(){
		if($F("inputGeography") == ""){
			showMessageBox("Please select Geography first.", "I");
		}else{
			showOpenPerilLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		if($F("txtPerilName") == ""){
			showMessageBox("Please select a peril first.", "I");
		}else{
			showOverlayEditor("txtRemarks", 4000, false, null);
		}
	});
	
	$("btnAddOpenPeril").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("openPerilInfoDiv") && validatePremiumRate()){
			addOpenPeril();
			$("withInvoice").checked = checkInvoiceTag();
		}
	});
	
	$("btnDeleteOpenPeril").observe("click", function(){
		var basicPerilName = checkBasicPeril();
		
		if(nvl(basicPerilName, "") != ""){
			showMessageBox("Cannot delete this record while its subsequent ally (" + basicPerilName + ") exists.", "E");
		}else{
			deleteOpenPeril();
			$("withInvoice").checked = checkInvoiceTag();
		}
	});
</script>