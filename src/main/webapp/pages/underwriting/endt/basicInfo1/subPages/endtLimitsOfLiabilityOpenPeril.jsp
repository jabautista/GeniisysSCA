<div id="endtOpenPerilMainDiv" name="endtOpenPerilMainDiv" style="width: 100%; padding: 0 0 0 0;">
	<!-- <div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;"> -->
		<!-- <div id="innerDiv" name="innerDiv">
			<label>Peril</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div> -->		
	<!-- </div> -->
	
	<!-- <div id="endtOpenPerilDiv" name="endtOpenPerilDiv" class="sectionDiv" style="height: 250px;"> -->
		<div id="endtOpenPerilTGDiv" name="endtOpenPerilTGDiv" style="float: left; width: 80%; height: 350px; padding: 20px 0 0 20px;"> <!-- padding: 20px 0 0 40px; -->
			<!-- this is where the table will be placed -->
		</div>
		<div id="withInvoiceDiv" name="withInvoiceDiv" class="sectionDiv" style="width: 75px; margin: 50px 20px 0 65px;" align="center"> <!-- margin: 50px 0 0 30px; -->
			<table align="center" width="20px" style="margin: 5px 0px 5px 0px" border="0">
				<tr>
					<td width="90%" align="center" style="font-size: 11px;">
						<input type="checkbox" id="chkWithInvoice" name="chkWithInvoice" disabled="disabled" style="background-color: green;">
						<br />With Invoice
					</td>
				</tr>
			</table>
		</div>
		<div id="endtOpenPerilDtlDiv" name="endtOpenPerilDtlDiv" style="float: left; width: 100%; height: 130px; padding: 0 0 0 0; " align="center">
			<table width="50%" BORDER="0">
				<tr>
					<td class="rightAligned" width="22%">Peril</td>
					<td class="leftAligned" width="78%">
						<span class="required lovSpan" style="width: 99.5%;">
							<input type="text" class="required" id="txtPerilName" name="txtPerilName" style="border: none; float: left; width: 250px; height: 13px; margin: 0px;" readonly="readonly" tabindex="401 /">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOpenPeril" name="searchOpenPeril" alt="Go" style="float: right;" tabindex="402" />
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Premium Rate</td>
					<td class="leftAligned">
						<input type="text" class="moneyRate" id="txtPremiumRate" name="txtPremiumRate" style="width: 97.7%; text-align: right;" tabindex="403" maxlength="13" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned">								
						<div style="border: 1px solid gray; height: 20px; width: 99.5%;" >
							<textarea id="txtRemarks" name="txtRemarks" style="width: 91%; border: none; height: 13px; resize: none;" maxlength="4000" tabindex="404"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="405" />
						</div>
					</td>
				</tr>
			</table>
			
			<div class="buttonsDiv" id="endtPerilButtonsDiv" style="width: 100%; height: 20px;  " align="center">
				<input type="button" class="button" style="width: 60px;" id="btnAddPeril" name="btnAddPeril" value="Add" />
				<input type="button" class="button" style="width: 60px;" id="btnDeletePeril" name="btnDeletePeril" value="Delete" />
				<!-- <input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" /> -->			
			</div>	
			
		</div>	
		
		<div id="hiddenEndtOpenPerilDiv" name="hiddenEndtOpenPerilDiv" height="0">
			<input type="hidden" id="hiddenPerilCd" name="hiddenPerilCd" value="" />
			<input type="hidden" id="hiddenBasicPerilCd" name="hiddenBasicPerilCd" value="" />
			<input type="hidden" id="hiddenPerilType" name="hiddenPerilType" value="" />
		</div>
	<!-- </div> -->
</div>


<script type="text/javascript">

	objEndtLol.selectedPerilIndex = -1;
	objEndtLol.selectedPerilRow = "";
	objEndtLol.openPeril = [];
	
	objEndtLol.objOpenPerilTableGrid = JSON.parse('${openPerilTG}');
	objEndtLol.objOpenPerilRows = objEndtLol.objOpenPerilTableGrid.rows || [];
	
	try{
		var myGeogCd = nvl($F("geogCd"), 0);		
		
		var openPerilTableModel = {
			url: contextPath+"/GIPIWOpenPerilController?action=getEndtLolOpenPeril&refresh=1&globalParId="+$F("globalParId")
					+"&geogCd="+myGeogCd+"&lineCd="+objUWGlobal.lineCd,
			options: {
				height: '310px',
				width: '777px',
				onCellFocus: function(element, value, x, y, id){
					objEndtLol.selectedPerilIndex = y;
					objEndtLol.selectedPerilRow = openPerilTableGrid.geniisysRows[y];
					populateEndtPerilDetails(true); 
					openPerilTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					objEndtLol.selectedPerilIndex = -1;
					objEndtLol.selectedPerilRow = "";
					populateEndtPerilDetails(false);
					openPerilTableGrid.keys.releaseKeys();
				},
				prePager : function (){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					}  else {
						return true;
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
				},
				beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						return true;
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
				}
			},
			columnModel:[
			             {	 
			            	 id: 'recordStatus',
			            	 width: '0px',
			            	 visible: false,
			            	 editor: 'checkbox'
			             },
			             {	 
			            	 id: 'divCtrId',
			            	 width: '0px',
			            	 visible: false
			             },
			             {	 
			            	 id: 'perilName',
			            	 title: 'Peril',
			            	 width: '280px',
			            	 visible: true,
			            	 filterOption: true
			             },
			             {
			            	 id: 'premiumRate',
			            	 title: 'Rate',
			            	 width: '160px',
			            	 align: 'right',
			            	 geniisysClass: 'rate',
			            	 visible: true,
			            	 filterOption: true,
			            	 filterOptionType: 'number'
			             },
			             {
			            	 id: 'remarks',
			            	 title: 'Remarks',
			            	 width: '325px',
			            	 visible: true,
			            	 filterOption: true
			             }
			             ],
			rows: objEndtLol.objOpenPerilRows
		};
		openPerilTableGrid = new MyTableGrid(openPerilTableModel);
		openPerilTableGrid.pager = objEndtLol.objOpenPerilTableGrid;
		openPerilTableGrid.render('endtOpenPerilTGDiv');
		openPerilTableGrid.afterRender = function(){
			objEndtLol.openPeril = openPerilTableGrid.geniisysRows;
			$("chkWithInvoice").checked = checkInvoiceTag();
			//$("chkWithInvoice").checked = ($F("withInvoiceTag") == "Y" ? true : false);
			populateEndtPerilDetails(false);
		};
	}catch(e){
		showErrorMessage("Error in Open Peril Table Grid: ",e);
	}
	
	
	function populateEndtPerilDetails(populate){
		$("txtPerilName").value = populate ? unescapeHTML2(objEndtLol.selectedPerilRow.perilName) : "";
		$("txtPremiumRate").value = populate ? formatToNineDecimal(objEndtLol.selectedPerilRow.premiumRate) : "";
		$("txtRemarks").value = populate ? unescapeHTML2(objEndtLol.selectedPerilRow.remarks) : "";
		
		$("hiddenPerilCd").value = populate ? objEndtLol.selectedPerilRow.perilCd : "";
		$("hiddenBasicPerilCd").value = populate ? objEndtLol.selectedPerilRow.basicPerilCd : "";
		$("hiddenPerilType").value = populate ? objEndtLol.selectedPerilRow.perilType : "";
		
		if(populate){
			$("btnAddPeril").value = "Update";
			disableSearch("searchOpenPeril");
			enableButton("btnDeletePeril");
		}else{
			$("btnAddPeril").value = "Add";
			enableSearch("searchOpenPeril");
			disableButton("btnDeletePeril");
		}
	}
	
	// displays the open perils 
	function showOpenPerilLOV(){
		try{
			var notIn = "";
			var withPrevious = false;
			var perilType = "";
			var rows = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
			
			for(var i=0; i<rows.length; i++){
				notIn += withPrevious ? "," : "";
				notIn = notIn + rows[i].perilCd;
				withPrevious = true;
			}
			
			perilType = notIn == "" ? "B" : "";
			
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: { action		: "getWOpenPerilLOV",
								 lineCd		: $F("globalLineCd"),
								 sublineCd	: $F("globalSublineCd"),
								 perilType	: perilType,
								 notIn		: notIn != "" ? "(" + notIn +")" : "0"
								},
				title: "Valid Values for Peril",
				width: 421,
				height: 386,
				columnModel: [
				              	{	id: "perilName",
				              		title: "Peril",
				              		width: '225px'
				              	},
				              	{	id: 'perilSname',
				              		title: "Peril Short Name",
				              		width: '110px'
				              	},
				              	{	id: 'perilType',
				              		title: 'Peril Type',
				              		width: '65px'				              		
				              	},
				              	{	id: 'perilCd',
				              		width: '0px',
				              		visible: false
				              	},
				              	{	id: 'bascPerlCd', 
				              		width: '0px',
				              		visible: false
				              	}
				              ],
				draggable: true,
				onSelect: function(row){
					if(row != undefined){
						if($F("recFlag") == "D"){
							getRecordFlag(row);
						} //else {
							if(validatePeril(row)){
								$("txtPerilName").value = unescapeHTML2(row.perilName);
								$("hiddenPerilCd").value = row.perilCd;
								$("hiddenBasicPerilCd").value = row.bascPerlCd;
								$("hiddenPerilType").value = row.perilType;
							} else {
								showMessageBox("The basic peril (" + row.bascPerlName + ") should be added before this allied peril.", "E");
							}
						//}
					}
				}
			});
		}catch(e){
			showErrorMessage("showOpenPerilLOV", e);
		}
	}
	
	//  working
	function getRecordFlag(row){
		new Ajax.Request(contextPath+"/GIPIWOpenLiabController", {
			method: "GET",
			parameters: {
				action		: "getRecFlagGIPIS173",
				geogCd		: nvl($F("geogCd"), $F("inputGeography")),
				lineCd		: objEndtLol.vars.lineCd,  		//$F("globalLineCd"),
				sublineCd	: objEndtLol.vars.sublineCd, 	// $F("globalSublineCd"),
				issCd		: objEndtLol.vars.issCd,
				issueYy		: objEndtLol.vars.issueYy, 		//objUWGlobal.issueYy,
				polSeqNo	: objEndtLol.vars.polSeqNo, 	//objUWGlobal.polSeqNo,
				perilCd		: row.perilCd,					//$F("hiddenPerilCd"),
				recFlag		: $F("recFlag")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var objResp = JSON.parse(response.responseText);
					if(objResp.message != 'SUCCESS'){
						showMessageBox(objResp.message, "I");
					}
				} 
			}
		});
	}
	
	
	function validatePeril(peril){
		var rows = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
		
		if(nvl(peril.bascPerlCd, "") != ""){
			for(var i=0; i<rows.length; i++){
				if(peril.bascPerlCd == rows[i].perilCd){
					return true;
				}
			}
			return false;
		}
		return true;
	}
	
	function checkInvoiceTag(){
		var rows = row = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1});
		
		for(var i=0; i<rows.length; i++){
			if(nvl(rows[i].premiumRate, "") != "" && rows[i].perilCd != objEndtLol.selectedPerilRow.perilCd){
				return true;
			}
		}
		return false;
	}
	
	function validatePremiumRate(){
		if($("txtPremiumRate").value != ""){
			if(isNaN(parseFloat($F("txtPremiumRate")))){
				showWaitingMessageBox("Field must be of form 999.099999999.", "I", function(){
					$("txtPremiumRate").value = "";
				});
				return false;
			}else if(parseFloat($F("txtPremiumRate")) > parseFloat(100)){
				showWaitingMessageBox("Premium Rate must not exceed 100.", "I", function(){
					$("txtPremiumRate").value = "";
				});
				return false;
			} /* else if(checkInvoiceTag()){ // CS version allows any rate be entered in any Basic Peril. 
				showWaitingMessageBox("Limit of liability is automatically identified as Total Sum Insured. " +
						"To compute for the premium of MOP (TSI * rate), only one rate must be entered on any Basic Peril.", "I",
						function(){
							$("txtPremiumRate").value = "";
						});
					return false;
			} */			
		}
		return true;
	}
	
	// adds new open peril into the table grid display
	function addOpenPeril(){
		var rowObj = createOpenPeril($("btnAddPeril").value);
		if($("btnAddPeril").value == "Add"){
			objEndtLol.openPeril.push(rowObj);
			openPerilTableGrid.addBottomRow(rowObj);
		}else{
			objEndtLol.openPeril.splice(objEndtLol.selectedPerilIndex, 1, rowObj);
			openPerilTableGrid.updateVisibleRowOnly(rowObj, objEndtLol.selectedPerilIndex);
		}
		openPerilTableGrid.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function deleteOpenPeril(){
		var delObj = createOpenPeril("Delete");
		objEndtLol.openPeril.splice(objEndtLol.selectedPerilIndex, 1, delObj);
		openPerilTableGrid.deleteVisibleRowOnly(objEndtLol.selectedPerilIndex);
		openPerilTableGrid.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function createOpenPeril(func){
		var rowObjPeril = new Object();
		rowObjPeril.parId = $F("globalParId");
		rowObjPeril.geogCd = nvl($F("geogCd"), $F("inputGeography"));
		rowObjPeril.lineCd = $F("globalLineCd");
		rowObjPeril.perilCd	= $F("hiddenPerilCd");
		rowObjPeril.perilName = $F("txtPerilName");
		rowObjPeril.recFlag = "A";
		rowObjPeril.premiumRate = $F("txtPremiumRate");
		rowObjPeril.withInvoiceTag = $F("chkWithInvoice");
		rowObjPeril.remarks = $F("txtRemarks");
		rowObjPeril.basicPerilCd = $F("hiddenBasicPerilCd");
		rowObjPeril.perilType = $F("hiddenPerilType");
		rowObjPeril.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0: 1;
		return rowObjPeril;
	}
	
	/*function checkBasicPeril(){
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
	}*/
	
	
	// new version for checkBasicPeril function above
	function checkBasicPeril(){
		var perilCd = objEndtLol.selectedPerilRow.perilCd;
		var rows = (objEndtLol.openPeril).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
				
		for(var i=0; i<rows.length; i++){
			if(rows[i].basicPerilCd == perilCd){
				return rows[i].perilName;
			}
		} 
		
		var isBasicExists = false;
		var perilName = null;
		
		for(var i=0; i<rows.length; i++){
			if(rows[i].perilType = "B" && rows[i].perilCd != perilCd){ // may iba pang basic
				isBasicExists = true;
				//break;
				//
				for(var j=0; j<rows.length; j++){
					if(rows[j].perilType = "A"  && rows[j].basicPerilCd == rows[i].basicPerilCd){//
						perilName = rows[j].perilName;
						break;
					}
				}
				//
			}
			
			/* for(var j=0; j<rows.length; j++){
				if(rows[j].perilType = "A"){
					perilName = rows[j].perilName;
					break;
				}
			} */
		}
		return isBasicExists ? "" : perilName;
	}
	
	
	$("txtPremiumRate").observe("focus", function(){
		if($F("txtPerilName") == ""){
			showMessageBox("Please select a peril before adding premium rate.", "I");
		}
	});
	
	$("txtPremiumRate").observe("change", function(){
		validatePremiumRate();
	});
	
	$("txtRemarks").observe("focus", function(){
		if($F("txtPerilName") == ""){
			showMessageBox("Please select a peril before adding remarks.",  "I");
		} else {
			if($F("txtPremiumRate") != ""){
				$("txtPremiumRate").value = formatToNineDecimal($F("txtPremiumRate"));
			}
		}
	});
	
	$("editRemarks").observe("click", function(){
		if($F("txtPerilName") == ""){
			showMessageBox("Please select a peril before editing remarks.", "I");
		} else {
			showEditor("txtRemarks", 4000);
		}
	});
	
	$("searchOpenPeril").observe("click", function(){
		var reqGeog = $F("inputGeography");
		var reqLimit = $F("inputLimit");
		var reqCurrency = $F("inputCurrency");
		
		if(reqGeog == "" || reqLimit == "" || reqCurrency == ""){
			showMessageBox("Please select Geography, Limit of Liability, and Currency first.", "I");
		} else {
			showOpenPerilLOV();
		}
	});
	
	$("btnAddPeril").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("endtOpenPerilDtlDiv") && validatePremiumRate){
			addOpenPeril();
			$("chkWithInvoice").checked = checkInvoiceTag();
		}
		
		
	});
	
	$("btnDeletePeril").observe("click", function(){
		var basicPerilName = checkBasicPeril();
		
		if(nvl(basicPerilName, "") != ""){
			showMessageBox("Cannot delete this record while its subsequent ally (" + basicPerilName + ") exists.", "E");
		}else{
			deleteOpenPeril();
			$("chkWithInvoice").value = checkInvoiceTag();
		}
	});
	
</script>