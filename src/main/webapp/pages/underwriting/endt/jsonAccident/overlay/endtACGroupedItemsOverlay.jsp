<div id="groupedItemsMainDiv" style="width: 920px;">
	<div id="outerDiv" name="outerDiv" style="margin-top: 2px;">
		<div id="innerDiv" name="innerDiv">
			<label>Grouped Items/Beneficiary Information</label>
		</div>
	</div>
		<div id="groDiv">
			<div id="groupedItemsInfoDiv" class="sectionDiv">
				<div id="groupedItemsTGDiv" style="height: 233px; width: 100%; padding: 5px 0 0 10px;">
					
				</div>
				<div id="groupedItemsInfoDiv" style="padding-right: 32px;">
					<table align="center" border="0" style="margin-bottom: 3px;">
						<tr>
							<td class="rightAligned" style="width: 100px;">Enrollee Code </td>
							<td class="leftAligned">
								<input id="groupedItemNo" name="groupedItemNo" type="text" style="width: 215px;" maxlength="9" class="required integerNoNegativeUnformatted" tabindex="1101"/>
							</td>
							
							<td class="rightAligned" >Plan </td>
							<td class="leftAligned" >
								<span class="lovSpan" style="width: 221px;">
									<input id="txtPackageCd" name="txtPackageCd" type="text" style="border: none; float: left; width: 190px; height: 13px; margin: 0px;" maxlength="50" tabindex="1104" readonly="readonly"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPack" name="searchPack" alt="Go" style="float: right;" tabindex=""/>
								</span>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Enrollee Name </td>
							<td class="leftAligned">
								<input id="groupedItemTitle" name="groupedItemTitle" type="text" style="width: 215px;" maxlength="50" class="required upper" tabindex="1102"/>
							</td>
							
							<td class="rightAligned" >Payment Mode </td>
							<td class="leftAligned" >
								<span class="lovSpan" style="width: 221px;">
									<input id="txtPaytTerms" name="txtPaytTerms" type="text" style="border: none; float: left; width: 190px; height: 13px; margin: 0px;" maxlength="50" tabindex="1106" readonly="readonly"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPaytTerms" name="searhPaytTerms" alt="Go" style="float: right;" tabindex=""/>
								</span>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" >Principal Code </td>
							<td class="leftAligned">
								<input id="txtPrincipalCd" name="txtPrincipalCd" type="text" style="width: 215px;" maxlength="9" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Principal Code is invalid. Valid value is from 0000001 to 9999999" tabindex="1103"/>
							</td>
							
							<td class="rightAligned" style="width: 105px;">Effectivity Date </td>
							<td class="leftAligned">
								<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
						    		<input style="height: 13px; width: 84px; border: none; float: left;" id="grpFromDate" name="grpFromDate" type="text" value="" readonly="readonly" oldValue="" tabindex="1108"/>
						    		<img name="accModalDate" id="hrefFromDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex=""/>
								</div>
								<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
						    		<input style="height: 13px; width: 84px; border: none; float: left;" id="grpToDate" name="grpToDate" type="text" value="" readonly="readonly" oldValue="" tabindex="1110"/>
						    		<img name="accModalDate" id="hrefToDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex=""/>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="groupedItemsInfoDiv2" class="sectionDiv">
				<table align="center" border="0" style="margin-bottom:5px; padding-top: 1px;">
					<tr>
						<td class="rightAligned" >Sex </td>
						<td class="leftAligned" >
							<select  id="sex" name="sex" style="width: 223px" tabindex="1201">
								<option value=""></option>
								<option value="F">FEMALE</option>
								<option value="M">MALE</option>
							</select>
						</td>
						
						<td class="rightAligned" style="width:105px;">Control Type </td>
						<td class="leftAligned" >
							<span class="lovSpan" style="width: 221px;">
								<input id=txtControlTypeDesc name="txtControlTypeDesc" type="text" style="border: none; float: left; width: 190px; height: 13px; margin: 0px;" readonly="readonly" tabindex="1211"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchControlType" name="searchControlType" alt="Go" style="float: right;" tabindex=""/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Birthday </td>
						<td class="leftAligned">
						<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:15px;">
					   		<input style="height: 13px; width: 84px; border: none; float: left;" id="dateOfBirth" name="dateOfBirth" type="text" value="" readonly="readonly" tabindex="1202"/>
					   		<img name="accModalDate" id="hrefBirthdayDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateOfBirth'),this, null);" alt="Birthday" style="margin-right: 2px; margin-top: 1px;" tabindex=""/>
						</div>
							Age
							<input id="age" name="age" type="text" style="width: 64px;" maxlength="3" class="integerNoNegativeUnformattedNoComma rightAligned" errorMsg="Entered Age is invalid." tabindex="1204"/>
						</td>
						<td class="rightAligned" >Control Code </td>
						<td class="leftAligned" >
							<input id="controlCd" name="controlCd" type="text" style="width: 215px;" maxlength="250" tabindex="1213"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Civil Status </td>
						<td class="leftAligned" >
							<span class="lovSpan" style="width: 221px;">
								<input id="txtCivilStatus" name="txtCivilStatus" type="text" style="border: none; float: left; width: 190px; height: 13px; margin: 0px;" readonly="readonly" tabindex="1205"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchStatus" name="searchStatus" alt="Go" style="float: right;" tabindex=""/>
							</span>
						</td>				
						<td class="rightAligned" >Salary </td>
						<td class="leftAligned" >
							<input id="salary" name="salary" type="text" style="width: 215px;" maxlength="14" class="money2" min="-9999999999.99" max="9999999999.99" errorMsg="Invalid Salary. Value should be from -9,999,999,999.99 to 9,999,999,999.99." tabindex="1214"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Occupation </td>
						<td class="leftAligned" >
							<span class="lovSpan" style="width: 221px;">
								<input id="position" name="position" type="text" style="border: none; float: left; width: 190px; height: 13px; margin: 0px;" readonly="readonly" tabindex="1207"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOccupation" name="searchOccupation" alt="Go" style="float: right;" tabindex=""/>
							</span>
						</td>
						<td class="rightAligned" >Salary Grade </td>
						<td class="leftAligned" >
							<input id="salaryGrade" name="salaryGrade" type="text" style="width: 215px;" maxlength="3" tabindex="1215"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Group </td>
						<td class="leftAligned" >
							<span class="lovSpan" style="width: 221px;">
								<input id="txtGroupDesc" name="txtGroupDesc" type="text" style="border: none; float: left; width: 190px; height: 13px; margin: 0px;" maxlength="5" readonly="readonly" tabindex="1209"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchGroup" name="searchGroup" alt="Go" style="float: right;" tabindex=""/>
							</span>
						</td>
						<td class="rightAligned" >Amount Covered </td>
						<td class="leftAligned" >
							<input id="amountCovered" name="amountCovered" type="text" style="width: 215px;" class="money" maxlength="17" min="-99999999999999.99" max="99999999999999.99" errorMsg="Invalid Amount Covered. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." tabindex="1216"/>
						</td>
					</tr>			
				</table>
				<div id="buttonsDiv1" align="center" style="margin-bottom: 5px;">
					<input id="btnAdd" type="button" class="button" value="Add" tabindex="1217">
					<input id="btnDelete" type="button" class="button" value="Delete" tabindex="1218">	
				</div>
			</div>
		</div>
	<div id="buttonsDiv" align="center" style="margin-top: 5px; float: left; width: 100%">
		<input id="btnCoverage" type="button" class="button" value="Coverage" style="width: 120px;" tabindex="1301">
		<input id="btnBeneficiary" type="button" class="button" value="Beneficiary" style="width: 120px;" tabindex="1302">
		<input id="btnUpload" type="button" class="button" value="Upload Enrollees" style="width: 120px;" tabindex="1303">
		<input id="btnRetrieve" type="button" class="button" value="Retrieve Grp Items" style="width: 120px;" tabindex="1304">
		<input id="btnCancelGrouped" type="button" class="button" value="Cancel" style="width: 120px;" tabindex="1305">
		<input id="btnSave" type="button" class="button" value="Save" style="width: 120px;" tabindex="1306">	
	</div>
	<div id="hiddenDiv">
		<input id="positionCdHid" type="hidden"/>
		<input id="packBenCdHid" type="hidden"/>
		<input id="groupCdHid" type="hidden">
		<input id="controlTypeCdHid" type="hidden"/>
		<input id="includeTagHid" type="hidden"/>
		<input id="civilStatusHid" type="hidden">
		<input id="remarksHid" type="hidden">
		<input id="lineCdHid" type="hidden">
		<input id="sublineCdHid" type="hidden">
		<input id="deleteSwHid" type="hidden">
		<input id="annPremAmtHid" type="hidden">
		<input id="annTsiAmtHid" type="hidden">
		<input id="premAmtHid" type="hidden">
		<input id="tsiAmtHid" type="hidden">
		<input id="paytTermsHid" type="hidden">
		<input id="overwriteBen" type="hidden">
	</div>
</div>

<script type="text/javascript">
	var selectedRow = "";
	var selectedIndex = -1;
	var noOfPersons = 0;
	
	objGroupedItems = new Object();
	objGroupedItems.vars = JSON.parse('${vars}');
	objGroupedItems.vars.effDate = dateFormat(objGroupedItems.vars.effDate, 'mm-dd-yyyy');
	objGroupedItems.vars.endtExpiryDate = dateFormat(objGroupedItems.vars.endtExpiryDate, 'mm-dd-yyyy');
	objGroupedItems.vars.inceptDate = dateFormat(objGroupedItems.vars.inceptDate, 'mm-dd-yyyy');
	objGroupedItems.vars.expiryDate = dateFormat(objGroupedItems.vars.expiryDate, 'mm-dd-yyyy');
	objGroupedItems.selectedRow = "";
	
	initializeAll();
	makeInputFieldUpperCase();
	initializeAllMoneyFields();
	changeTag = 0;
	
	disableButton("btnDelete");
	observeBackSpaceOnDate("grpFromDate");
	observeBackSpaceOnDate("grpToDate");
	observeBackSpaceOnDate("dateOfBirth");
	observeBackSpaceOnDate("txtPackageCd");
	observeBackSpaceOnDate("txtCivilStatus");
	observeBackSpaceOnDate("position");
	observeBackSpaceOnDate("txtGroupDesc");
	observeBackSpaceOnDate("txtPaytTerms");
	observeBackSpaceOnDate("txtControlTypeDesc");
	
	objGroupedItems.objGroupedItemsTableGrid = JSON.parse('${groupedItemsTGJson}');
	objGroupedItems.objGroupedItemsRows = objGroupedItems.objGroupedItemsTableGrid.rows || [];
	try{
		var groupedItemsTableModel = {
			url: contextPath+"/GIPIWGroupedItemsController?action=getGroupedItemsListing&refresh=1&parId="+objGroupedItems.vars.parId+
					"&itemNo="+objGroupedItems.vars.itemNo,
			options: {
				id: 1,
	          	height: '206px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedRow = groupedItemsTableGrid.geniisysRows[y];
	          		objGroupedItems.selectedRow = selectedRow;
	          		selectedIndex = y;
	          		populateGroupedItemFields(true);
	            },
	            onRemoveRowFocus: function(){
	            	selectedRow = "";
	            	objGroupedItems.selectedRow = "";
	            	selectedIndex = -1;
	            	groupedItemsTableGrid.keys.releaseKeys();
	            	populateGroupedItemFields(false);
	            },
	            prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
					} else {
						groupedItemsTableGrid.onRemoveRowFocus();
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
	            	groupedItemsTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		groupedItemsTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		groupedItemsTableGrid.onRemoveRowFocus();
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
				{	id:			'deleteSw',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;D',
					altTitle: 'Delete Switch',
					width:		'25px',
					editable:  true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	},
		            	onClick: function(value, checked, y){
		            		if(changeTag == 1){
		            			$("mtgInput"+groupedItemsTableGrid._mtgId+"_2," + selectedIndex).checked = !checked;
		            			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		            		}else{
		            			modifyDeleteSw(value, checked);
		            		}
	 			    	}
		            })
				},
				{	id: 'groupedItemNo',
					title: 'Enrollee Code',
					width: '100px',
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					renderer: function (value){
						return formatNumberDigits(value, 9);
					}
				},
				{	id: 'groupedItemTitle',
					title: 'Enrollee Name',
					width: '210px',
					filterOption: true
				},
				{	id: 'principalCd',
					title: 'Principal Code',
					width: '100px',
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					renderer: function (value){
						if(nvl(value, "") != ""){
							return formatNumberDigits(value, 9);
						}
						return value;
					}
				},
				{	id: 'packageCd',
					title: 'Plan',
					width: '75px',
					filterOption: true
				},
				{	id: 'paytTerms',
					title: 'Payment Mode',
					width: '100px',
					filterOption: true
				},
				{	id: 'fromDate',
					title: 'Effectivity Date',
					width: '125px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{	id: 'toDate',
					title: 'Expiry Date',
					width: '125px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				}
			],
			rows: objGroupedItems.objGroupedItemsTableGrid.rows
		};
		groupedItemsTableGrid = new MyTableGrid(groupedItemsTableModel);
		groupedItemsTableGrid.pager = objGroupedItems.objGroupedItemsTableGrid;
		groupedItemsTableGrid.render('groupedItemsTGDiv');
		groupedItemsTableGrid.afterRender = function(){
			objGroupedItems.groupedItems = groupedItemsTableGrid.geniisysRows;
			groupedItemsTableGrid.keys.releaseKeys();
			
			changeTag = 0;
			if(objACGlobal.createdParArray != undefined && objACGlobal.createdParArray != ""){ //added by christian 04/29/2013
				objACGlobal.addCreatedParEndt(objACGlobal.createdParArray);
				objACGlobal.createdParArray = [];
				changeTag = 1;
			}
		};
	}catch(e){
		showErrorMessage("Error in Grouped Items TableGrid", e);
	}
	
	$("groupedItemNo").observe("change", function(){
		if($F("groupedItemNo") != ""){
			if(preGroupedItemNo()){
				validateGroupedItemNo();	
			}else{
				clearFocusElementOnError("groupedItemNo", "Grouped Item No. must be unique.");
			}
		}
	});
	
	$("groupedItemTitle").observe("change", function(){
		if($F("groupedItemTitle") != ""){
			validateGroupedItemTitle();
		}
	});
	
	$("txtPrincipalCd").observe("change", function(){
		if($F("txtPrincipalCd") != ""){
			if($F("txtPrincipalCd") == removeLeadingZero($F("groupedItemNo"))){
				clearFocusElementOnError("txtPrincipalCd", "Principal code cannot be the same as the Enrollee code.");
			}else{
				validatePrincipalCd();
			}
		}
	});
	
	$("hrefFromDate").observe("click", function(){
		$("grpFromDate").setAttribute("oldValue", $F("grpFromDate"));
		scwShow($("grpFromDate"),this, null);
	});
	
	$("hrefToDate").observe("click", function(){
		$("grpToDate").setAttribute("oldValue", $F("grpToDate"));
		scwShow($("grpToDate"),this, null);
	});
	
	$("grpFromDate").observe("blur", function(){
		if($F("grpFromDate") != ""){
			validateGrpFromDate();
		}
	});
	
	$("grpToDate").observe("blur", function(){
		if($F("grpToDate") != ""){
			validateGrpToDate();
		}
	});
	
	$("dateOfBirth").observe("blur", function(){
		if(!validateBirthday()){
			$("dateOfBirth").value = "";
			$("age").value = "";
			showMessageBox("Date of birth should not be later than system date.", "E");
		}else if ($F("dateOfBirth") != ""){
			$("age").value = computeAge($F("dateOfBirth"));
		}
	});
	
	$("amountCovered").observe("change", function(){
		if($F("groupedItemNo") != ""){
			validateAmtCovered();	
		}
	});
	
	$("searchPack").observe("click", function(){
		groupedItemsTableGrid.keys.releaseKeys();
		if(objGroupedItems.vars.itmperilExist == "Y"){
			showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. " +
					"Please check the records in the item peril module.", "I");
		}else{
			showPackageBenefitLOV();
		}
	});
	
	$("searchPaytTerms").observe("click", function(){
		groupedItemsTableGrid.keys.releaseKeys();
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getPayTermsLOV"},
				title: "Payment Mode",
				width: 375,
				height: 386,
				columnModel:[
								{	id : "paytTerms",
									title: "Payment Code",
									width: "120px",
								},
				             	{	id : "paytTermsDesc",
									title: "Description",
									width: "240px"
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("txtPaytTerms").value = row.paytTermsDesc;
						$("paytTermsHid").value = row.paytTerms;
					}
				}
			});
		}catch(e){
			showErrorMessage("getCapacityLOV",e);
		}
	});
	
	$("searchStatus").observe("click", function(){
		groupedItemsTableGrid.keys.releaseKeys();
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
						$("txtCivilStatus").value = row.rvMeaning.toUpperCase();
						$("civilStatusHid").value = row.rvLowValue;
					}
				}
			});
		}catch(e){
			showErrorMessage("getCapacityLOV",e);
		}
	});
	
	$("searchOccupation").observe("click", function(){
		groupedItemsTableGrid.keys.releaseKeys();
		try{
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action : "getCapacityLOV"},
				title: "Position",
				width: 375,
				height: 386,
				columnModel:[
				             	{	id : "position",
									title: "Position",
									width: '362px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("position").value = row.position;
						$("positionCdHid").value = row.positionCd;
					}
				}
			});
		}catch(e){
			showErrorMessage("getCapacityLOV",e);
		}
	});
	
	$("searchGroup").observe("click", function(){
		groupedItemsTableGrid.keys.releaseKeys();
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getGroupCdLOV",
								assdNo : $F("globalAssdNo")
								},
				title: "Group",
				width: 375,
				height: 386,
				columnModel:[
				             	{	id : "groupCd",
									title: "Group Cd",
									width: '75px'
								},
								{	id : "groupDesc",
									title: "Description",
									width: '285px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("groupCdHid").value = row.groupCd;
						$("txtGroupDesc").value = unescapeHTML2(row.groupDesc);
					}
				}
			});
		}catch(e){
			showErrorMessage("getGroupLOV",e);
		}
	});
	
	$("searchControlType").observe("click", function(){
		groupedItemsTableGrid.keys.releaseKeys();
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getControlTypeLOV",
								assdNo : $F("globalAssdNo")
								},
				title: "List of Control Types",
				width: 375,
				height: 386,
				columnModel:[
				             	{	id : "controlTypeCd",
									title: "Control Type",
									width: '75px'
								},
								{	id : "controlTypeDesc",
									title: "Description",
									width: '285px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("txtControlTypeDesc").value = row.controlTypeDesc;
						$("controlTypeCdHid").value = row.controlTypeCd;
					}
				}
			});
		}catch(e){
			showErrorMessage("getControlTypeLOV",e);
		}
	});

	$("btnAdd").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("groupedItemsInfoDiv")){
			addGroupedItem();
		}
	});
	
	$("btnDelete").observe("click", function(){
		deleteGroupedItem();
	});	
	
	$("btnCoverage").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			if(selectedIndex == -1){
				showMessageBox("Select a grouped item first before proceeding to coverage screen.", "I");
			}else if(objGroupedItems.vars.itmperilExist == "Y"){
				showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. " +
						"Please check the records in the item peril module.", "I");
			}else{
				groupedItemsTableGrid.keys.releaseKeys();
				objGroupedItems.showEnrolleeCoverageOverlay();
			}
		}
	});
	
	$("btnBeneficiary").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			if(selectedIndex == -1){
				showMessageBox("Select a grouped item first before proceeding to beneficiary screen.", "I");
			}else{
				showBeneficiaryOverlay();
			}
		}
	});
	
	$("btnUpload").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			objUWGlobal.callingForm = "GIPIS065";
			showUploadEnrolleesOverlay2(objGroupedItems.vars.parId, objGroupedItems.vars.itemNo, "");
		}
	});
	
	$("btnRetrieve").observe("click", function(){
		if(objGroupedItems.vars.itmperilExist == "Y"){
			showMessageBox("You cannot insert grouped item peril because there are existing item perils for this item. " +
					"Please check the records in the item peril module.", "I");
		}else{
			if(changeTag == 1){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			}else{
				validateRetrieveGrpItems();
			}
		}
	});
	
	function showPackageBenefitLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action    : "getPackageBenefitLOV",
								lineCd    : $F("globalLineCd"),
								sublineCd : $F("globalSublineCd")
								},
				title: "List of Plans",
				width: 375,
				height: 386,
				columnModel:[
				             	{	id : "packBenCd",
									title: "Plan",
									width: '75px'
								},
								{	id : "packageCd",
									title: "Plan Description",
									width: '285px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						showConfirmBox("Confirmation", "Selecting/changing a plan will populate/overwrite perils for this grouped item. " +
							"Would you like to continue?", "Yes", "No",
							function(){
								$("txtPackageCd").value = row.packageCd;
								$("packBenCdHid").value = row.packBenCd;
								$("overwriteBen").value = "Y";
							}, "", "");
					}
				}
			});
		}catch(e){
			showErrorMessage("showPackageBenefitLOV",e);
		}
	}

	function showEnrolleeCoverageOverlay(){
		enrolleeOverlay = Overlay.show(contextPath+"/GIPIWItmperlGroupedController", {
			urlParameters: {
				action           : "showEnrolleeCoverageOverlay",
				parId  	         : objGroupedItems.vars.parId,
				itemNo		     : objGroupedItems.vars.itemNo,
				groupedItemNo    : objGroupedItems.selectedRow.groupedItemNo,
				groupedItemTitle : objGroupedItems.selectedRow.groupedItemTitle,
				lineCd		  	 : objGroupedItems.vars.lineCd,
				issCd		  	 : objGroupedItems.vars.issCd,
				sublineCd	  	 : objGroupedItems.vars.sublineCd,
				issueYy		  	 : objGroupedItems.vars.issueYy,
				polSeqNo	  	 : objGroupedItems.vars.polSeqNo,
				renewNo	      	 : objGroupedItems.vars.renewNo,
				packBenCd		 : objGroupedItems.selectedRow.packBenCd
			},
			urlContent : true,
			draggable: true,
		    title: "Enrollee Coverages",
		    height: 540,
		    width: 735
		});
	}
	objGroupedItems.showEnrolleeCoverageOverlay = showEnrolleeCoverageOverlay;
	
	function validateRetrieveGrpItems(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateRetrieveGrpItems",{
			parameters : {
				lineCd    : objGroupedItems.vars.lineCd,
				issCd	  : objGroupedItems.vars.issCd,
				sublineCd : objGroupedItems.vars.sublineCd,
				issueYy	  : objGroupedItems.vars.issueYy,
				polSeqNo  : objGroupedItems.vars.polSeqNo,
				renewNo   : objGroupedItems.vars.renewNo,
				effDate   : objGroupedItems.vars.effDate,
				itemNo    : objGroupedItems.vars.itemNo
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showRetrieveGrpItemsOverlay();
					}else{
						showMessageBox(response.responseText, "I");
					}
				}
			}
		});
	}
		
	function showRetrieveGrpItemsOverlay(){
		retrieveGrpItemsOverlay = Overlay.show(contextPath+"/GIPIWGroupedItemsController", {
			urlParameters: {
				action        : "showRetrieveGrpItemsOverlay",
				parId  	      : objGroupedItems.vars.parId,
				lineCd		  : objGroupedItems.vars.lineCd,
				sublineCd	  : objGroupedItems.vars.sublineCd,
				issCd		  : objGroupedItems.vars.issCd,
				issueYy       : objGroupedItems.vars.issueYy,
				polSeqNo      : objGroupedItems.vars.polSeqNo,
				renewNo		  : objGroupedItems.vars.renewNo,
				itemNo		  : objGroupedItems.vars.itemNo,
				effDate		  : objGroupedItems.vars.effDate
			},
			urlContent : true,
			draggable: true,
		    title: "Retrieve Group Items",
		    height: 310,
		    width: 650
		});
	}
		
	function modifyDeleteSw(value, checked){
		deleteSwVars = new Object();
		getDeleteSwVars();
		
		if(value == "N"){
			showConfirmBox("Confirmation", "Untagging Delete switch will totally delete all existing perils for this group item. Would you like to continue?",
					"Yes", "No", deleteItmPerilGrouped,
					function(){
						$("mtgInput"+groupedItemsTableGrid._mtgId+"_2," + selectedIndex).checked = true;
					}, "");
		}else{
			if(deleteSwVars.message == "ZERO"){
				showMessageBox("This group item had already been negated or zero out on previous endorsement.", "I");
				$("mtgInput"+groupedItemsTableGrid._mtgId+"_2," + selectedIndex).checked = !($("mtgInput"+groupedItemsTableGrid._mtgId+"_2," + selectedIndex).checked);
			}
		}
		
		if(deleteSwVars.message == "PRINCIPAL"){
			showMessageBox("Cannot delete Enrollee. Currently being used as the principal of other enrollees.", "I");
			$("mtgInput"+groupedItemsTableGrid._mtgId+"_2," + selectedIndex).checked = false;
		}else if(deleteSwVars.exist == "N" && value == "Y"){
			showConfirmBox("Confirmation", "Tagging Delete switch will automatically negate all perils for current group item, which means that it is deleted. Do you want to continue?",
					"Yes", "No", preNegateDelete,
					function(){
						$("mtgInput"+groupedItemsTableGrid._mtgId+"_2," + selectedIndex).checked = false;
					}, "");
		}
	}
	
	function deleteItmPerilGrouped(){
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController?action=deleteItmPerilGrouped",{
			parameters : {
				parId		   : objGroupedItems.vars.parId,
				itemNo		   : objGroupedItems.vars.itemNo,
				groupedItemNo  : selectedRow.groupedItemNo,
				lineCd		   : objGroupedItems.vars.lineCd,
				issCd		   : objGroupedItems.vars.issCd,
				sublineCd	   : objGroupedItems.vars.sublineCd,
				issueYy        : objGroupedItems.vars.issueYy,
				polSeqNo	   : objGroupedItems.vars.polSeqNo,
				renewNo	       : objGroupedItems.vars.renewNo,
				effDate        : objGroupedItems.vars.effDate,
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				compSw		   : objGroupedItems.vars.compSw,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				shortRtPercent : objGroupedItems.vars.shortRtPct,
				endtTaxSw	   : objGroupedItems.vars.endtTaxSw,
				packLineCd	   : objGroupedItems.vars.packLineCd,
				packSublineCd  : objGroupedItems.vars.packSublineCd,
				parStatus	   : objGroupedItems.vars.parStatus,
				packPolFlag    : objGroupedItems.vars.packPolFlag				
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					showWaitingMessageBox("Deletion has been successfully completed.", "I", function(){
						groupedItemsTableGrid.refresh();
					});
				}
			}
		});
	}
	
	function preNegateDelete(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=preNegateDelete",{
			parameters : {
				parId		  : objGroupedItems.vars.parId,
				itemNo		  : objGroupedItems.vars.itemNo,
				groupedItemNo : $F("groupedItemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "EXIST"){
						showConfirmBox("Confirmation", "Existing perils for this grouped item will be automatically deleted. " +
								"Do you want to continue?", "Yes", "No",
								function(){
									if(nvl($F("globalBackEndt"), "N") == "Y"){
										checkBackEndt();
									}else{
										negateDelete();
									}
								}, "", "");
					}else if(response.responseText == "SUCCESS"){
						if(nvl($F("globalBackEndt"), "N") == "Y"){
							checkBackEndt();
						}else{
							negateDelete();
						}
					}
				}
			}
		});
	}
	
	function checkBackEndt(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=checkBackEndt",{
			parameters : {
				lineCd		  : objGroupedItems.vars.lineCd,
				issCd		  : objGroupedItems.vars.issCd,
				sublineCd	  : objGroupedItems.vars.sublineCd,
				issueYy       : objGroupedItems.vars.issueYy,
				polSeqNo	  : objGroupedItems.vars.polSeqNo,
				renewNo	      : objGroupedItems.vars.renewNo,
				effDate		  : objGroupedItems.vars.effDate,
				itemNo		  : objGroupedItems.vars.itemNo,
				groupedItemNo : $F("groupedItemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						negateDelete();
					} else{
						showMessageBox("Deletion of this peril is not allowed because this is a backward endorsement and " +
								"there is an existing endorsement for peril " + response.responseText);
					}
				}
			}
		});
	}
	
	function negateDelete(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=negateDelete",{
			parameters : {
				lineCd		   : objGroupedItems.vars.lineCd,
				issCd		   : objGroupedItems.vars.issCd,
				sublineCd	   : objGroupedItems.vars.sublineCd,
				issueYy        : objGroupedItems.vars.issueYy,
				polSeqNo	   : objGroupedItems.vars.polSeqNo,
				renewNo	       : objGroupedItems.vars.renewNo,
				parId		   : objGroupedItems.vars.parId,
				itemNo		   : objGroupedItems.vars.itemNo,
				groupedItemNo  : $F("groupedItemNo"),
				toDate		   : $F("grpToDate"),
				fromDate	   : $F("grpFromDate"),
				effDate        : objGroupedItems.vars.effDate,
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				compSw		   : objGroupedItems.vars.compSw,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				shortRtPercent : objGroupedItems.vars.shortRtPct,
				endtTaxSw	   : objGroupedItems.vars.endtTaxSw,
				packLineCd	   : objGroupedItems.vars.packLineCd,
				packSublineCd  : objGroupedItems.vars.packSublineCd,
				parStatus	   : objGroupedItems.vars.parStatus,
				packPolFlag    : objGroupedItems.vars.packPolFlag
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					showWaitingMessageBox("Deletion has been successfully completed... Check Grouped Item Peril Module for information", "I", function(){
						groupedItemsTableGrid.refresh();
					});
				}
			}
		});
	}
	
	function getDeleteSwVars(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=getDeleteSwVars",{
			parameters : {
				parId		  : objGroupedItems.vars.parId,
				itemNo		  : objGroupedItems.vars.itemNo,
				groupedItemNo : selectedRow.groupedItemNo,
				fromDate	  : $F("grpFromDate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					deleteSwVars.message = obj.message;
					deleteSwVars.exist = obj.exist;
				}
			}
		});
	}
	
	function showBeneficiaryOverlay(){
		groupedItemsTableGrid.keys.releaseKeys();
		beneficiaryOverlay = Overlay.show(contextPath+"/GIPIWGrpItemsBeneficiaryController", {
			urlParameters: {
				action        : "showGrpItemsBenOverlay",
				parId  	      : objGroupedItems.vars.parId,
				itemNo		  : objGroupedItems.vars.itemNo,
				groupedItemNo : selectedRow.groupedItemNo
			},
			urlContent : true,
			draggable: true,
		    title: "Beneficiary Information",
		    height: 580,
		    width: 860
		});
	}
	
	function preGroupedItemNo(){
		for(var i = 0; i < objGroupedItems.groupedItems.length; i++){
			if((objGroupedItems.groupedItems[i].recordStatus != -1) && 
				(parseInt(removeLeadingZero($F("groupedItemNo"))) == parseInt(removeLeadingZero(objGroupedItems.groupedItems[i].groupedItemNo)))){
				return false;
			}
		}
		return true;
	}
	
	function validateGroupedItemNo(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateGroupedItemNo",{
			parameters : {
				parId  	      : objGroupedItems.vars.parId,
				itemNo 		  : objGroupedItems.vars.itemNo,
				groupedItemNo : $F("groupedItemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message == "SUCCESS"){
						if(nvl(obj.packBenCd, "") != "" && $F("packBenCdHid") == ""){
							$("packBenCdHid").value = obj.packBenCd;
						}
						if($F("grpFromDate") == ""){
							$("grpFromDate").value = nvl(obj.fromDate, "") == "" ? "" : dateFormat(obj.fromDate, "mm-dd-yyyy");
						}
						if($F("grpToDate") == ""){
							$("grpToDate").value = nvl(obj.toDate, "") == "" ? "" : dateFormat(obj.toDate, "mm-dd-yyyy");
						}
						$("groupedItemNo").value = formatNumberDigits($F("groupedItemNo"), 9);
						getGroupedItem();
					}else{
						clearFocusElementOnError("groupedItemNo", obj.message);
					}
				}
			}
		});
	}
	
	function validateGroupedItemTitle(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateGroupedItemTitle",{
			parameters : {
				parId  	         : objGroupedItems.vars.parId,
				itemNo 		     : objGroupedItems.vars.itemNo,
				groupedItemTitle : $F("groupedItemTitle")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message == "SUCCESS"){
						$("sublineCdHid").value = obj.sublineCd;
					}else{
						clearFocusElementOnError("groupedItemTitle", obj.message);
					}
				}
			}
		});
	}
	
	function validatePrincipalCd(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validatePrincipalCd",{
			parameters : {
				parId  	         : objGroupedItems.vars.parId,
				itemNo 		     : objGroupedItems.vars.itemNo,
				principalCd      : $F("txtPrincipalCd")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						clearFocusElementOnError("txtPrincipalCd", obj.message);
					}else{
						$("txtPrincipalCd").value = formatNumberDigits($F("txtPrincipalCd"), 9);
					}
				}
			}
		});
	}
	
	function validateGrpFromDate(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateGrpFromDate",{
			parameters : {
				parId  	 : objGroupedItems.vars.parId,
				itemNo   : objGroupedItems.vars.itemNo,
				fromDate : $F("grpFromDate"),
				toDate	 : $F("grpToDate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						showMessageBox(obj.message, "I");
						$("grpFromDate").value = $("grpFromDate").getAttribute("oldValue");
					}
				}
			}
		});
	}
	
	function validateGrpToDate(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateGrpToDate",{
			parameters : {
				parId  	 : objGroupedItems.vars.parId,
				itemNo   : objGroupedItems.vars.itemNo,
				fromDate : $F("grpFromDate"),
				toDate	 : $F("grpToDate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						showMessageBox(obj.message, "I");
						$("grpToDate").value = $("grpToDate").getAttribute("oldValue");
					}
				}
			}
		});
	}

	function validateAmtCovered(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateAmtCovered",{
			parameters : {
				lineCd : objGroupedItems.vars.lineCd,
				sublineCd : objGroupedItems.vars.sublineCd,
				issCd : objGroupedItems.vars.issCd,
				issueYy : objGroupedItems.vars.issueYy,
				polSeqNo : objGroupedItems.vars.polSeqNo,
				renewNo : objGroupedItems.vars.renewNo,
				effDate : objGroupedItems.vars.effDate,
				groupedItemNo : removeLeadingZero($F("groupedItemNo")),
				itemNo : objGroupedItems.vars.itemNo,
				amountCovered : unformatCurrencyValue($F("amountCovered")),
				groupedItemTitle : $F("groupedItemTitle"),
				recFlag : objGroupedItems.vars.recFlag
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != "SUCCESS"){
						$("amountCovered").value = obj.amountCovered;
						showMessageBox(obj.message, "E");
					}
				}
			}
		});
	}
		
	function getGroupedItem(){
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=getGroupedItem",{
			parameters : {
				parId         : objGroupedItems.vars.parId,
				itemNo        : objGroupedItems.vars.itemNo,
				lineCd		  : objGroupedItems.vars.lineCd,
				issCd		  : objGroupedItems.vars.issCd,
				sublineCd	  : objGroupedItems.vars.sublineCd,
				issueYy		  : objGroupedItems.vars.issueYy,
				polSeqNo	  : objGroupedItems.vars.polSeqNo,
				renewNo		  : objGroupedItems.vars.renewNo,
				groupedItemNo : $F("groupedItemNo"),
				amountCovered : unformatCurrencyValue($F("amountCovered")),
				groupCd		  : $F("groupCd")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					populateFromRetrieved(obj);
				}
			}
		});
	}
	
	function populateFromRetrieved(obj){
		$("groupedItemNo").value = nvl($F("groupedItemNo"), nvl(formatNumberDigits(obj.groupedItemNo, 9), ""));
		$("groupedItemTitle").value = nvl(unescapeHTML2(obj.groupedItemTitle), "");
		$("txtPackageCd").value = nvl(obj.packageCd, "");
		$("packBenCdHid").value = nvl(obj.packBenCd, "");
		$("grpFromDate").value =  nvl($F("grpFromDate"), nvl(obj.fromDate, "") == "" ? "" : dateFormat(obj.fromDate, 'mm-dd-yyyy'));
		$("grpToDate").value = nvl($F("grpToDate"), nvl(obj.toDate, "") == "" ? "" : dateFormat(obj.toDate, 'mm-dd-yyyy'));
		$("txtControlTypeDesc").value = nvl(unescapeHTML2(obj.controlTypeDesc), "");
		$("controlTypeCdHid").value = nvl(obj.controlTypeCd, "");
		$("controlCd").value = nvl(obj.controlCd, "");
		$("sex").selectedIndex = (obj.sex == "M" ? 2 : obj.sex == "F" ? 1 : 0);
		$("position").value = nvl(unescapeHTML2(obj.positionDesc), "");
		$("positionCdHid").value = nvl(obj.positionCd, "");
		$("txtCivilStatus").value = nvl(unescapeHTML2(obj.civilStatusDesc), "");
		$("civilStatusHid").value = nvl(obj.civilStatus, "");
		$("age").value = nvl(obj.age, "");
		$("salary").value = nvl(obj.salary, "") == "" ? "" : formatCurrency(obj.salary);
		$("salaryGrade").value = nvl(unescapeHTML2(obj.salaryGrade), "");
		$("amountCovered").value = nvl(obj.amountCovered, "") == "" ? "" : formatCurrency(obj.amountCovered);
		$("includeTagHid").value = nvl(obj.includeTag, "N");
		$("remarksHid").value = nvl(obj.remarksHid, "");
		$("txtPrincipalCd").value = nvl(obj.principalCd, "");
		$("dateOfBirth").value = nvl(obj.dateOfBirth, "") == "" ? "" : dateFormat(obj.dateOfBirth, 'mm-dd-yyyy');
		$("txtPaytTerms").value = nvl(unescapeHTML2(obj.paytTermsDesc), "");
		$("paytTermsHid").value = nvl(obj.paytTerms, "");
		$("position").value = nvl(unescapeHTML2(obj.positionDesc), "");
		$("positionCdHid").value = nvl(obj.positionCd, "");
		$("txtGroupDesc").value = nvl(unescapeHTML2(obj.groupDesc), "");
		$("groupCdHid").value = nvl(obj.groupCd, "");
		$("overwriteBen").value = "N";
	}

	function addGroupedItem(){
		var rowObj = setGroupedItem($("btnAdd").value);
		
		if($("btnAdd").value == "Add"){
			objGroupedItems.groupedItems.push(rowObj);
			groupedItemsTableGrid.addBottomRow(rowObj);
		}else{
			objGroupedItems.groupedItems.splice(selectedIndex, 1, rowObj);
			groupedItemsTableGrid.updateVisibleRowOnly(rowObj, selectedIndex);
		}
		
		groupedItemsTableGrid.onRemoveRowFocus();
		changeTag = 1;
	}
	
	//created by christian 04/29/2013
	function addCreatedParEndt(array){
		try{
			for (var i=0; i<array.length; i++) {
  				var obj = new Object();
				obj.parId = objGroupedItems.vars.parId;
				obj.itemNo = objGroupedItems.vars.itemNo;
				obj.groupedItemNo = array[i].groupedItemNo;
				obj.includeTag = "N";
				obj.groupedItemTitle = array[i].groupedItemTitle;
				obj.sex = array[i].sex;
				obj.civilStatusDesc = array[i].civilStatusDesc;
				obj.civilStatus = array[i].civilStatus;
				obj.dateOfBirth = array[i].dateOfBirth;
				obj.age = array[i].age;
				obj.salary = parseFloat(array[i].salary);
				obj.salaryGrade = array[i].salaryGrade;
				obj.amountCovered = parseFloat(array[i].amountCoverage);
				obj.remarks = array[i].remarks;
				obj.fromDate = array[i].fromDate;
				obj.toDate = array[i].toDate;
				obj.controlCd = array[i].controlCd;
				obj.controlTypeDesc = array[i].controlTypeDesc;
				obj.controlTypeCd = array[i].controlTypeCd;
				obj.recordStatus = 0;
				
				objGroupedItems.groupedItems.push(obj);
				groupedItemsTableGrid.addBottomRow(obj);
			}
		}catch(e){
			showErrorMessage("addCreatedPar", e);
		}
	}
	objACGlobal.addCreatedParEndt = addCreatedParEndt;
	
	function deleteGroupedItem(){
		changeTag = 1;
		selectedRow.recordStatus = -1;
		objGroupedItems.groupedItems.splice(selectedIndex, 1, selectedRow);
		groupedItemsTableGrid.deleteVisibleRowOnly(selectedIndex);
		groupedItemsTableGrid.onRemoveRowFocus();
	}

	function setGroupedItem(func){
		var obj = new Object();
		obj.parId = objGroupedItems.vars.parId;
		obj.itemNo = objGroupedItems.vars.itemNo;
		obj.groupedItemNo = $F("groupedItemNo");
		obj.includeTag = $F("includeTagHid");
		obj.groupedItemTitle = $F("groupedItemTitle");
		obj.sex = $F("sex");
		obj.positionDesc = $F("position");
		obj.positionCd = nvl($F("position"), "") == "" ? "" : $F("positionCdHid");
		obj.civilStatusDesc = $F("txtCivilStatus");
		obj.civilStatus = nvl($F("txtCivilStatus"), "") == "" ? "" : $F("civilStatusHid");
		obj.dateOfBirth = $F("dateOfBirth");
		obj.age = $F("age");
		obj.salary = $F("salary") == "" ? "" : parseFloat($F("salary").replace(/,/g, ""));
		obj.salaryGrade = $F("salaryGrade");
		obj.amountCovered = $F("amountCovered") == "" ? "" : parseFloat($F("amountCovered").replace(/,/g, ""));
		obj.remarks = $F("remarksHid");
		obj.lineCd = $F("lineCdHid");
		obj.sublineCd = $F("sublineCdHid");
		obj.deleteSw = $F("deleteSwHid");
		obj.groupCd = nvl($F("txtGroupDesc"), "") == "" ? "" : $F("groupCdHid");
		obj.groupDesc = $F("txtGroupDesc");
		obj.packageCd = $F("txtPackageCd");
		obj.packBenCd = nvl($F("txtPackageCd"), "") == "" ? "" : $F("packBenCdHid");
		obj.fromDate = $F("grpFromDate");
		obj.toDate = $F("grpToDate");
		obj.paytTerms = nvl($F("txtPaytTerms"), "") == "" ? "" : $F("paytTermsHid");
		obj.paytTermsDesc = $F("txtPaytTerms");
		obj.annTsiAmt = $F("annTsiAmtHid");
		obj.annPremAmt = $F("annPremAmtHid");
		obj.controlCd = $F("controlCd");
		obj.controlTypeDesc = $F("txtControlTypeDesc");
		obj.controlTypeCd = nvl($F("txtControlTypeDesc"), "") == "" ? "" : $F("controlTypeCdHid");
		obj.tsiAmt = $F("tsiAmtHid");
		obj.premAmt = $F("premAmtHid");
		obj.principalCd = $F("txtPrincipalCd");
		obj.overwriteBen = nvl($F("overwriteBen"), "N");
		obj.recordStatus = func == "Add" ? 0 : 1;
		return obj;
	}

	function saveGroupedItems(changeNo){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objGroupedItems.groupedItems);
		objParams.delRows = getDeletedJSONObjects(objGroupedItems.groupedItems);
		
		new Ajax.Request(contextPath+"/GIPIWGroupedItemsController?action=saveGroupedItems",{
			method: "POST",
			parameters:{
				parameters     : JSON.stringify(objParams),
				parId	       : objGroupedItems.vars.parId,
				lineCd	       : objGroupedItems.vars.lineCd,
				sublineCd      : objGroupedItems.vars.sublineCd,
				issCd	       : objGroupedItems.vars.issCd,
				issueYy        : objGroupedItems.vars.issueYy, 
				polSeqNo       : objGroupedItems.vars.polSeqNo,
				renewNo        : objGroupedItems.vars.renewNo,
				effDate        : objGroupedItems.vars.effDate,
				itemNo         : objGroupedItems.vars.itemNo,
				noOfPersons    : changeNo ? noOfPersons : null, 
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				compSw		   : objGroupedItems.vars.compSw,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				shortRtPercent : objGroupedItems.vars.shortRtPct,
				endtTaxSw	   : objGroupedItems.vars.endtTaxSw,
				packLineCd	   : objGroupedItems.vars.packLineCd,
				packSublineCd  : objGroupedItems.vars.packSublineCd,
				parStatus	   : objGroupedItems.vars.parStatus,
				packPolFlag    : objGroupedItems.vars.packPolFlag,
				itmperilExist  : objGroupedItems.vars.itmperilExist
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Grouped Items, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							changeTag = 0;
							objUWGlobal.callingForm = "";
							groupedItemsTableGrid.keys.releaseKeys();
							groupedItemsOverlay.close();
							showItemInfo();
						});
					}
				}
			}
		});
	}
	
	function checkNoOfPersons(){
		noOfPersons = groupedItemsTableGrid.pager.total;
		nopPol = validateNoOfPersons();
		if(groupedItemsTableGrid.pager.total != 0 && groupedItemsTableGrid.pager.total < 2 && nopPol == 0){ // added by christian 04/29/2013
			showMessageBox("Minimum no. of Grouped Items is two(2).", imgMessage.INFO);
			return false;
		}
		if((parseInt(objGroupedItems.vars.noOfPersons) != parseInt(noOfPersons))){ /* && (parseInt(noOfPersons) > 1 ) commented out by christian 04/29/2013*/
			showConfirmBox("Confirmation", "Saving changes will update the No. of Persons, " +
					"do you want to continue?", "Yes", "No",
					function(){
						saveGroupedItems(true); 
					}, "", "");
		}else{
			saveGroupedItems(false);
		}
	}

	function populateGroupedItemFields(populate){
		$("groupedItemNo").value = populate ? formatNumberDigits(selectedRow.groupedItemNo, 9) : "";
		$("groupedItemTitle").value = populate ? unescapeHTML2(selectedRow.groupedItemTitle) : "";
		$("txtPrincipalCd").value = populate ? (nvl(selectedRow.principalCd, "") == "" ? "" : formatNumberDigits(selectedRow.principalCd, 9)) : "";
		$("packBenCdHid").value = populate ? nvl(selectedRow.packBenCd, "") : "";
		$("txtPackageCd").value = populate ? nvl(unescapeHTML2(selectedRow.packageCd), "") : "";
		$("grpFromDate").value = populate ? (nvl(selectedRow.fromDate, "") == "" ? "" : dateFormat(selectedRow.fromDate, "mm-dd-yyyy")) : "";
		$("grpToDate").value = populate ? (nvl(selectedRow.toDate, "") == "" ? "" : dateFormat(selectedRow.toDate, "mm-dd-yyyy")) : "";
		$("sex").selectedIndex = populate ? (selectedRow.sex == "M" ? 2 : selectedRow.sex == "F" ? 1 : 0) : 0;
		$("dateOfBirth").value = populate ? (nvl(selectedRow.dateOfBirth, "") == "" ? "" : dateFormat(selectedRow.dateOfBirth, "mm-dd-yyyy")) : "";
		$("age").value = populate ? nvl(selectedRow.age, "") : "";
		$("civilStatusHid").value = populate ? nvl(selectedRow.civilStatus, "") : "";
		$("txtCivilStatus").value = populate ? nvl(unescapeHTML2(selectedRow.civilStatusDesc), "") : "";
		$("positionCdHid").value = populate ? nvl(selectedRow.positionCd, "") : "";
		$("position").value = populate ? nvl(unescapeHTML2(selectedRow.positionDesc), "") : "";
		$("txtGroupDesc").value = populate ? nvl(selectedRow.groupDesc, "") : "";
		$("groupCdHid").value = populate ? nvl(selectedRow.groupCd, "") : "";
		$("controlTypeCdHid").value = populate ? nvl(selectedRow.controlTypeCd, "") : "";
		$("txtControlTypeDesc").value = populate ? nvl(unescapeHTML2(selectedRow.controlTypeDesc), "") : "";
		$("controlCd").value = populate ? nvl(unescapeHTML2(selectedRow.controlCd), "") : "";
		$("salary").value = populate ? formatCurrency(selectedRow.salary) : "";
		$("salaryGrade").value = populate ? nvl(unescapeHTML2(selectedRow.salaryGrade), "") : "";
		$("amountCovered").value = populate ? formatCurrency(selectedRow.amountCovered) : "";
		$("txtPaytTerms").value = populate ? nvl(unescapeHTML2(selectedRow.paytTermsDesc), "") : "";
		$("paytTermsHid").value = populate ? nvl(selectedRow.paytTerms, "") : "";
		$("sublineCdHid").value = populate ? selectedRow.sublineCd : "";
		$("includeTagHid").value = populate ? selectedRow.includeTag : "";
		$("remarksHid").value = populate ? selectedRow.remarks : "";
		$("lineCdHid").value = populate ? selectedRow.lineCd : "";
		$("deleteSwHid").value = populate ? selectedRow.deleteSw : "";
		$("lineCdHid").value = populate ? selectedRow.lineCd : "";
		$("annPremAmtHid").value = populate ? selectedRow.annPremAmt : "";
		$("annTsiAmtHid").value = populate ? selectedRow.annTsiAmt : "";
		$("premAmtHid").value = populate ? selectedRow.premAmt : "";
		$("tsiAmtHid").value = populate ? selectedRow.tsiAmt : "";
		$("overwriteBen").value = populate ? "N" : "";
		$("btnAdd").value = populate ? "Update" : "Add";
		populate ? enableButton("btnDelete") : disableButton("btnDelete");
		populate ? disableInputField("groupedItemNo") : enableInputField("groupedItemNo");
	}
	
	function validateBirthday(){
		var sysdate = new Date();
		var date = Date.parse($F("dateOfBirth"));
		//var date2 = date.toString("MM-dd-yyyy"); --modified condition by robert 03.06.2013
		//if(date2 > sysdate.toString("MM-dd-yyyy")){
		if(date > sysdate){
			return false;
		}else{
			return true;
		}
	}
	
	$$("input[type='text']").each(function(input){
		input.observe("focus", function(){
			groupedItemsTableGrid.keys.releaseKeys();
		});
	});
	
	observeSaveForm("btnSave", checkNoOfPersons);
	observeCancelForm("btnCancelGrouped", checkNoOfPersons, function(){
		changeTag = 0;
		objUWGlobal.callingForm = "";
		groupedItemsTableGrid.keys.releaseKeys();
		groupedItemsOverlay.close();
		showItemInfo();
	});
	
	function validateNoOfPersons(){	//added by Gzelle 10072014
		var result = "";
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateNoOfPersons",{
			parameters : {
				lineCd    : objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"),
				sublineCd : objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"),
				issCd 	  : $F("globalIssCd"),
				issueYy   : $F("globalIssueYy"),
				polSeqNo  : $F("globalPolSeqNo"),
				renewNo	  : $F("globalRenewNo"),
				itemNo 	  : $F("itemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					result =  response.responseText;
				}
			}
		});
		return result;
	}	
</script>