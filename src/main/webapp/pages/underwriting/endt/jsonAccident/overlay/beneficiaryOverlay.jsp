<div id="beneficiaryInfoMainDiv" style="width: 852px;">
	<div id="enrolleeInfoDiv" class="sectionDiv" style="margin-top: 2px;">
		<table align="center">
			<tr>
				<td><label>Enrollee:</label></td>
				<td style="padding-left: 5px;"><input id="dspGroupedItemNo" type="text" readonly="readonly" style="width: 100px;" tabindex="-1"></td>
				<td><input id="dspEnrolleeName" type="text" readonly="readonly" style="width: 300px;" tabindex="-1"></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div id="beneficiaryTGDiv" style="width: 700px; height: 175px; padding: 5px 0 0 13px; float: left;">
		
		</div>
		<div id="beneficiaryInfoDiv" style="float: left; margin: 2px 0 2px 5px;">
			<table align="center" width="99%">
				<tr>
					<td class="rightAligned"><label style="width: 88px;">Beneficiary No.</label></td>
					<td class="leftAligned" colspan="5">				
						<input id="bBeneficiaryNo" name="bBeneficiaryNo" type="text" style="width: 225px" maxlength="5" class="required integerNoNegativeUnformatted" tabindex="3101"/>
					</td>
					<td class="rightAligned">Address </td>
					<td class="leftAligned" colspan="3">
						<input id="bBeneficiaryAddr" name="bBeneficiaryAddr" type="text" style="width: 235px" maxlength="50" tabindex="3103"/>
					</td>
					<td class="rightAligned">Relation </td>
					<td class="leftAligned" colspan="4">
						<input id="bRelation" name="bRelation" type="text" style="width: 159px;" maxlength="15" tabindex="3106"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Name </td>
					<td class="leftAligned" colspan="5">				
						<input id="bBeneficiaryName" name="bBeneficiaryName" type="text" style="width: 225px" maxlength="30" class="required upper" tabindex="3102"/>
					</td>
					<td class="rightAligned" width="70px">Status </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 135px; height: 21px; margin-right: 3px;">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 105px; border: none;" name="bCivilStatus" id="bCivilStatus" readonly="readonly" tabindex="3104"/>
							<img id="searchBStatus" alt="goBStatus" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
					</td>
					<td class="rightAligned">Sex </td>
					<td class="lefyAligned">
						<select id="bSex" name="bSex" style="width: 75px;" tabindex="3105">
								<option value=""></option>
								<option value="F">Female</option>
								<option value="M">Male</option>
							</select>
					</td>
					<td class="rightAligned">Birthday </td>
					<td class="leftAligned" style="width: 100px;">
						<div style="float:left; border: solid 1px gray; width: 98px; height: 21px; margin-right:3px; margin-top: 2px;">
					    	<input style="width: 70px; height: 13px; border: none;" id="bDateOfBirth" name="bDateOfBirth" type="text" value="" readonly="readonly" tabindex="3107"/>
					    	<img name="accModalDate" id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bDateOfBirth'),this, null);" alt="Birthday" />
						</div>
					</td>
					<td class="rightAligned">Age </td>
					<td class="leftAligned" style="width: 30px;">
						<input id="bAge" name="bAge" type="text" style="width: 30px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly" tabindex="3108"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="benButtonsDiv" align="center" style="width: 100%; float: left;">
			<input type="button" class="button" id="btnAddBen" value="Add" tabindex="3109"/>
			<input type="button" class="disabledButton" id="btnDeleteBen" value="Delete" tabindex="3110"/>
		</div>
		<div id="beneficiaryPerilTGDiv" align="center" style="width: 625px; height: 178px; padding: 5px 0 0 125px; float: left;">
		
		</div>
		<div id="beneficiaryPerilInfoDiv" align="center" style="float: left; width: 100%;">
			<table>
				<tr>
					<td>Peril Name</td>
					<td>
						<div style="float: left; border: solid 1px gray; width: 220px; height: 21px; margin-right: 3px;" class="required">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 192px; border: none;" name="bPerilName" id="bPerilName" readonly="readonly" class="required" tabindex="3201"/>
							<img id="searchBPeril" alt="goBPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex=""/>						
						</div>
					</td>
					<td>TSI Amount</td>
					<td>
						<input id="bTsiAmt" name="bTsiAmt" type="text" style="width: 215px;" maxlength="18" class="money" readonly="readonly" tabindex="3202"/>
					</td>					
				</tr>
			</table>
		</div>
		<div id="benPerilButtonsDiv" align="center" style="float: left; width: 100%; margin: 2px 0 2px 0;">
			<input type="button" class="disabledButton" id="btnAddBenPeril" value="Add" tabindex="3203"/>
			<input type="button" class="disabledButton" id="btnDeleteBenPeril" value="Delete" tabindex="3204"/>
		</div>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 2px;" align="center">
		<input id="btnSaveBeneficiary" type="button" value="Save" class="button" tabindex="3301">
		<input id="btnCancelBeneficiary" type="button" value="Cancel" class="button" tabindex="3302">
	</div>
	
	<div id="hiddenDiv">
		<input id="bCivilStatusHid" type="hidden">
		<input id="bPerilCdHid" type="hidden">
	</div>
</div>

<script type="text/javascript">
	var selectedBenRow = "";
	var selectedPerilRow = "";
	var selectedBenIndex = -1;
	var selectedPerilIndex = -1;
	
	var objBeneficiary = new Object();
	objBeneficiary.objBeneficiaryTableGrid = JSON.parse('${beneficiaryTGJson}');
	objBeneficiary.objBeneficiaryRows = objBeneficiary.objBeneficiaryTableGrid.rows || [];
	objBeneficiary.beneficiary = [];
	objBeneficiary.peril = [];

	initializeAll();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	disableSearch("searchBPeril");
	$("dspGroupedItemNo").value = objGroupedItems.selectedRow.groupedItemNo;
	$("dspEnrolleeName").value = objGroupedItems.selectedRow.groupedItemTitle;
	
	try{
		var beneficiaryTableModel = {
			url: contextPath+"/GIPIWGrpItemsBeneficiaryController?action=showGrpItemsBenOverlay&refresh=1&parId="+objGroupedItems.selectedRow.parId+
					"&itemNo="+objGroupedItems.selectedRow.itemNo+
					"&groupedItemNo="+objGroupedItems.selectedRow.groupedItemNo,
			options: {
				id: 3,
	          	height: '150px',
	          	width: '825px',
	          	onCellFocus: function(element, value, x, y, id){
	          		if(hasPendingPerilChildRecords()){
	          			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							saveBeneficiary,
							function(){
          						onCellFocus(y);
          					},
          					function(){
          						onCellFocus(y);
          					});	
	          		}else{
	          			onCellFocus(y);
	          		}
	            },
	            onRemoveRowFocus: function(){
	            	if(hasPendingPerilChildRecords()){
	          			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							saveBeneficiary,
							function(){
          						onRemoveRowFocus();
          					},
          					function(){
          						onRemoveRowFocus();
          					});	
	          		}else{
	          			onRemoveRowFocus();
	          		}
	            },
	            prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
					} else {
						beneficiaryTableGrid.onRemoveRowFocus();
						return true;
					}
				},
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	beneficiaryTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		beneficiaryTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		beneficiaryTableGrid.onRemoveRowFocus();
	            	}
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
				{	id: 'beneficiaryNo',
					title: 'No.',
					width: '50px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'beneficiaryName',
					title: 'Beneficiary Name',
					width: '225px',
					filterOption: true
				},
				{	id: 'sex',
					title: 'Sex',
					width: '40px',
					filterOption: true
				},
				{	id: 'relation',
					title: 'Relation',
					width: '110px',
					filterOption: true
				},
				{	id: 'civilStatus',
					title: 'Status',
					width: '60px',
					filterOption: true
				},
				{	id: 'dateOfBirth',
					title: 'Birthday',
					width: '75px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{	id: 'age',
					title: 'Age',
					width: '40px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'beneficiaryAddr',
					title: 'Address',
					width: '275px',
					filterOption: true
				}
			],
			rows: objBeneficiary.objBeneficiaryRows
		};
		beneficiaryTableGrid = new MyTableGrid(beneficiaryTableModel);
		beneficiaryTableGrid.pager = objBeneficiary.objBeneficiaryTableGrid;
		beneficiaryTableGrid.render('beneficiaryTGDiv');
		beneficiaryTableGrid.afterRender = function(){
			objBeneficiary.beneficiary = beneficiaryTableGrid.geniisysRows;
			beneficiaryTableGrid.keys.releaseKeys();
		};
	}catch(e){
		showErrorMessage("Error in Beneficiary Information TableGrid", e);
	}
	
	var objGrpPeril = new Object();
	objGrpPeril.objGrpPerilTableGrid = {};
	objGrpPeril.peril = [];
	try{
		var grpPerilTableGridModel = {
			options: {
				id: 4,
	          	height: '150px',
	          	width: '600px',
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedPerilRow = grpPerilTableGrid.geniisysRows[y];
	          		selectedPerilIndex = y;
	          		populateBenPerilInfo(true);
	            },
	            onRemoveRowFocus: function(){
	            	selectedPerilRow = "";
	            	selectedPerilIndex = -1;
	            	populateBenPerilInfo(false);
	            },
	            prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
					} else {
						grpPerilTableGrid.onRemoveRowFocus();
						return true;
					}
				},
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	grpPerilTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		grpPerilTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		grpPerilTableGrid.onRemoveRowFocus();
	            	}
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
					title: 'Peril Name',
					width: '380px',
					visible: true,
					filterOption: true
				},
				{	id: 'tsiAmt',
					title: 'TSI Amount',
					width: '190px',
					visible: true,
					filterOption: true,
					geniisysClass: 'money',
					align: 'right'
				}
			],
			rows: []
		};
		grpPerilTableGrid = new MyTableGrid(grpPerilTableGridModel);
		grpPerilTableGrid.pager = objGrpPeril.objGrpPerilTableGrid;
		grpPerilTableGrid.render('beneficiaryPerilTGDiv');
		grpPerilTableGrid.afterRender = function(){
			objBeneficiary.peril = grpPerilTableGrid.geniisysRows;
			grpPerilTableGrid.keys.releaseKeys();
		};
	}catch(e){
		showErrorMessage("Error in Beneficiary Peril TableGrid", e);
	}

	$("bBeneficiaryNo").observe("change", function(){
		if($F("bBeneficiaryNo") != ""){
			if(preValidateBenNo()){
				validateBenNo();
			}else{
				clearFocusElementOnError("bBeneficiaryNo", "Beneficiary must be unique.");
			}
		}
	});
	
	$("bDateOfBirth").observe("blur", function(){
		if ($F("bDateOfBirth") != ""){
			$("bAge").value = computeAge($F("bDateOfBirth"));
		}
	});
	
	$("searchBStatus").observe("click", function(){
		try{
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action : "getCgRefCodeLOV2",
								domain : "CIVIL STATUS"},
				title: "Civil Status",
				width: 375,
				height: 386,
				columnModel:[
								{	id : "rvLowValue",
									title: "",
									width: '0px',
									visible: false
								},
				             	{	id : "rvMeaning",
									title: "Civil Status",
									width: '360px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("bCivilStatus").value = row.rvMeaning;
						$("bCivilStatusHid").value = row.rvLowValue;
					}
				}
			});
		}catch(e){
			showErrorMessage("getStatusLOV",e);
		}
	});
	
	$("searchBPeril").observe("click", function(){
		var notIn = createNotInParamBen();
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action    : "getBeneficiaryPerilLOV",
							    lineCd    : objGroupedItems.vars.lineCd,
							    sublineCd : objGroupedItems.selectedRow.sublineCd,
							    notIn	  : notIn},
				title: "Default Perils",
				width: 375,
				height: 386,
				columnModel:[
								{	id : "perilName",
									title: "Peril Name",
									width: '361px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("bPerilCdHid").value = row.perilCd;
						$("bPerilName").value = row.perilName;
					}
				}
			});
		}catch(e){
			showErrorMessage("getPerilLOV",e);
		}
	});
	
	$("btnAddBen").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("beneficiaryInfoDiv")){
			addBen();
		}
	});
	
	$("btnDeleteBen").observe("click", function(){
		deleteBen();
	});
	
	$("btnAddBenPeril").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("beneficiaryPerilInfoDiv")){
			addBenPeril();
		}
	});
	
	$("btnDeleteBenPeril").observe("click", function(){
		deleteBenPeril();
	});
	
	function populateBeneficiaryInfo(pop){
		$("bBeneficiaryNo").value = pop ? selectedBenRow.beneficiaryNo : "";
		$("bBeneficiaryName").value = pop ? selectedBenRow.beneficiaryName : "";
		$("bBeneficiaryAddr").value = pop ? selectedBenRow.beneficiaryAddr : "";
		$("bDateOfBirth").value = pop ? dateFormat(selectedBenRow.dateOfBirth, "mm-dd-yyyy") : "";
		$("bAge").value = pop ? selectedBenRow.age : "";
		$("bSex").value = pop ? selectedBenRow.sex : "";
		$("bRelation").value = pop ? selectedBenRow.relation : "";
		$("bCivilStatus").value = pop ? selectedBenRow.civilStatusDesc : "";
		$("bCivilStatusHid").value = pop ? selectedBenRow.civilStatus : "";
		
		if(pop){
			enableButton("btnDeleteBen"); 
			enableButton("btnAddBenPeril");
			enableSearch("searchBPeril");
			enableInputField("bTsiAmt");
			$("btnAddBen").value = "Update";
			disableInputField("bBeneficiaryNo");
		}else{
			disableButton("btnDeleteBen");
			disableButton("btnAddBenPeril");
			disableButton("btnDeleteBenPeril");
			disableSearch("searchBPeril");
			disableInputField("bTsiAmt");
			$("bPerilName").value = "";
			$("bTsiAmt").value = "";
			$("btnAddBen").value = "Add";
			$("btnAddBenPeril").value = "Add";
			enableInputField("bBeneficiaryNo");
		}
	}
	
	function populateBenPerilInfo(pop){
		$("bPerilCdHid").value = pop ? selectedPerilRow.perilCd : "";
		$("bPerilName").value = pop ? unescapeHTML2(selectedPerilRow.perilName) : "";
		$("bTsiAmt").value = pop ? formatCurrency(selectedPerilRow.tsiAmt) : "";
		
		if(pop){
			enableButton("btnDeleteBenPeril");
			$("btnAddBenPeril").value = "Update";
			disableSearch("searchBPeril");
		}else{
			disableButton("btnDeleteBenPeril");
			$("btnAddBenPeril").value = "Add";
			enableSearch("searchBPeril");
		}
	}
	
	function preValidateBenNo(){
		for(var i = 0; i < objBeneficiary.beneficiary.length; i++){
			if((objBeneficiary.beneficiary[i].recordStatus != -1) && (parseInt(objBeneficiary.beneficiary[i].beneficiaryNo) == parseInt($F("bBeneficiaryNo")))){
				return false;
			}
		}
		return true;
	}
	
	function validateBenNo(){
		new Ajax.Request(contextPath + "/GIPIWGrpItemsBeneficiaryController?action=validateBenNo",{
			parameters : {
				parId  	      : objGroupedItems.vars.parId,
				itemNo 		  : objGroupedItems.vars.itemNo,
				groupedItemNo : objGroupedItems.selectedRow.groupedItemNo,
				beneficiaryNo : $F("bBeneficiaryNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						clearFocusElementOnError("bBeneficiaryNo", obj.message);
					}
				}
			}
		});
	}
	
	function createNotInParamBen(){
		var notIn = "";
		var withPrevious = false;
		for(var i = 0; i < objBeneficiary.peril.length; i++){
			if(objBeneficiary.peril[i].recordStatus != -1){
				notIn += withPrevious ? "," : "";
				notIn = notIn + objBeneficiary.peril[i].perilCd;
				withPrevious = true;
			}
		}
		notIn = (notIn != "" ? "("+notIn+")" : "");
		return notIn;
	}
	
	function addBen(){
		var rowObj = setBen($("btnAddBen").value);
		
		if($("btnAddBen").value == "Add"){
			objBeneficiary.beneficiary.push(rowObj);
			beneficiaryTableGrid.addBottomRow(rowObj);
		}else{
			objBeneficiary.beneficiary.splice(selectedBenIndex, 1, rowObj);
			beneficiaryTableGrid.updateVisibleRowOnly(rowObj, selectedBenIndex);
		}
		changeTag = 1;
		beneficiaryTableGrid.onRemoveRowFocus();
	}
	
	function deleteBen(){
		selectedBenRow.recordStatus = -1;
		objBeneficiary.beneficiary.splice(selectedBenIndex, 1, selectedBenRow);
		beneficiaryTableGrid.deleteVisibleRowOnly(selectedBenIndex);
		beneficiaryTableGrid.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function setBen(func){
		var obj = new Object();
		obj.parId = objGroupedItems.selectedRow.parId;
		obj.itemNo = objGroupedItems.selectedRow.itemNo;
		obj.groupedItemNo = objGroupedItems.selectedRow.groupedItemNo;
		obj.beneficiaryNo = $F("bBeneficiaryNo");
		obj.beneficiaryName = $F("bBeneficiaryName");
		obj.beneficiaryAddr = $F("bBeneficiaryAddr");
		obj.relation = $F("bRelation");
		obj.dateOfBirth = $F("bDateOfBirth");
		obj.age = $F("bAge");
		obj.civilStatus = $F("bCivilStatusHid");
		obj.civilStatusDesc = $F("bCivilStatus");
		obj.sex = $F("bSex");
		obj.recordStatus = func == "Add" ? 0 : 1;
		return obj;
	}
	
	function addBenPeril(){
		var rowObj = setBenPeril($("btnAddBenPeril").value);
		
		if($("btnAddBenPeril").value == "Add"){
			objBeneficiary.peril.push(rowObj);
			grpPerilTableGrid.addBottomRow(rowObj);
		}else{
			objBeneficiary.peril.splice(selectedPerilIndex, 1, rowObj);
			grpPerilTableGrid.updateVisibleRowOnly(rowObj, selectedPerilIndex);
		}
		changeTag = 1;
		grpPerilTableGrid.onRemoveRowFocus();	
	}
	
	function deleteBenPeril(){
		selectedPerilRow.recordStatus = -1;
		objBeneficiary.peril.splice(selectedPerilIndex, 1, selectedPerilRow);
		grpPerilTableGrid.deleteVisibleRowOnly(selectedPerilIndex);
		grpPerilTableGrid.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function setBenPeril(func){
		var obj = new Object();
		obj.parId = objGroupedItems.vars.parId;
		obj.itemNo = objGroupedItems.vars.itemNo;
		obj.groupedItemNo = objGroupedItems.selectedRow.groupedItemNo;
		obj.beneficiaryNo = selectedBenRow.beneficiaryNo;
		obj.lineCd = objGroupedItems.vars.lineCd;
		obj.perilCd = $F("bPerilCdHid");
		obj.perilName = $F("bPerilName");
		obj.recFlag = "C";
		obj.tsiAmt = unformatCurrencyValue($F("bTsiAmt"));
		obj.recordStatus = func == "Add" ? 0 : 1;
		return obj;
	}
	
	function saveBeneficiary(){
		var objParams = new Object();
		objParams.setBenRows = getAddedAndModifiedJSONObjects(objBeneficiary.beneficiary);
		objParams.delBenRows = getDeletedJSONObjects(objBeneficiary.beneficiary);
		objParams.setPerilRows = getAddedAndModifiedJSONObjects(objBeneficiary.peril);
		objParams.delPerilRows = getDeletedJSONObjects(objBeneficiary.peril);
		
		new Ajax.Request(contextPath+"/GIPIWGrpItemsBeneficiaryController?action=saveBeneficiary",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving beneficiaries, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
						changeTag = 0;
						clearObjectRecordStatus(objBeneficiary.beneficiary);
						clearObjectRecordStatus(objBeneficiary.peril);
						beneficiaryTableGrid.refresh();
						getBeneficiaryPeril(false);
						populateBeneficiaryInfo(false);
					}
				}
			}
		});
	}
	
	function getBeneficiaryPeril(show){
		var pParId = show ? selectedBenRow.parId : 0;
		var pItemNo = show ? selectedBenRow.itemNo : 0;
		var pGroupedItemNo = show ? selectedBenRow.groupedItemNo : 0;
		var pBeneficiaryNo = show ? selectedBenRow.beneficiaryNo : 0;
		
		grpPerilTableGrid.url = contextPath+"/GIPIWItmperlBeneficiaryController?action=getGrpPerilTableGrid"+
											"&parId="+pParId+"&itemNo="+pItemNo+"&groupedItemNo="+pGroupedItemNo+
											"&beneficiaryNo="+pBeneficiaryNo;
		grpPerilTableGrid._refreshList();
	}
	
	function hasPendingPerilChildRecords(){
		try{
			return getAddedAndModifiedJSONObjects(objBeneficiary.peril).length > 0 || getDeletedJSONObjects(objBeneficiary.peril).length > 0 ? true : false;
		}catch(e){
			showErrorMessage("hasPendingPerilChildRecords", e);
		}
	}
	
	function onCellFocus(y){
		beneficiaryTableGrid.keys.releaseKeys();
  		selectedBenRow = beneficiaryTableGrid.geniisysRows[y];
  		selectedBenIndex = y;
  		getBeneficiaryPeril(true);
  		populateBeneficiaryInfo(true);
	}
	
	function onRemoveRowFocus(){
		beneficiaryTableGrid.keys.releaseKeys();
    	selectedBenRow = "";
    	selectedBenIndex = -1;
    	getBeneficiaryPeril(false);
    	populateBeneficiaryInfo(false);
	}
	
	observeCancelForm("btnCancelBeneficiary", saveBeneficiary, function(){
		changeTag = 0;
		beneficiaryOverlay.close();
	});
	observeSaveForm("btnSaveBeneficiary", saveBeneficiary);
</script>