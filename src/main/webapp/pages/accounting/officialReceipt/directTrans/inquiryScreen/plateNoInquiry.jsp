<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="updatePolicyDistrictEtcMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Policy / Bill Nos. Thru Plate</label>
		</div>
	</div>
	
	<div id="policyDiv" class="sectionDiv" style="width: 920px; height: 50px;">
		<table align="center" border="0" style="margin: 10px auto;">
			<tr>
				<td style="padding-right: 5px;">Assured</td>
				<td>
					<div id="assdNoDiv" class="required" style="width: 100px; height: 20px; border: solid gray 1px; float: left;">
						<input id="txtAssdNo" name="txtAssdNo" type="text" maxlength="30" class="required integerNoNegativeUnformatted rightAligned" style="border: none; float: left; width: 75px; height: 13px; margin: 0px;" tabindex="202" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredLOV" alt="Go" style="float: right;" tabindex="201"/>							
					</div>
					<input type="text" id="txtAssdName" class="required" readonly="readonly" style="margin: 0 0 0 5px; width: 500px; height: 14px;" tabindex="202"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="gipiVehicleDiv" class="sectionDiv"  style="width: 920px; height: 410px;">
	
		<div id="tbgVehicleDiv" style="margin: 10px 10px 25px 10px; height: 323px"></div>
		
		<div class="buttonsDiv">
			<input id="btnReturn" type="button" class="button" value="Return" style="width: 80px;">
		</div>
	
	</div>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS213");
	setDocumentTitle("Policy / Bill Nos. Thru Plate");
	initializeAll();
	$("acExit").hide();

	hideToolbarButton("btnToolbarPrint");
	hideToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");	
	disableToolbarButton("btnToolbarEnterQuery");	
	
	var selectedRowInfo = null;
	var selectedIndex = null;
	
	var objVehicle = new Object();
	objVehicle.tableGrid = JSON.parse('${jsonVehicleList}'.replace(/\\/g, '\\\\'));
	objVehicle.objRows = objVehicle.tableGrid.rows || [];
	objVehicle.objList = [];	// holds all the geniisys rows
	
	try{
		var vehicleModel = {
			url: contextPath + "/GIACOrderOfPaymentController?action=showGiacs213&refresh=1&assdNo="+$F("txtAssdNo"),
			options: {
				width : '900px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = tbgVehicle.geniisysRows[y];
					selectedIndex = y;
					tbgVehicle.keys.releaseKeys();
				},
				/*onRowDoubleClick: function(y){
					exitModule(true);
				},*/
				onRemoveRowFocus: function(){
					tbgVehicle.keys.releaseKeys();
					selectedRowInfo = null;
					selectedIndex = null;
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					tbgVehicle.onRemoveRowFocus();
				},
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgVehicle.onRemoveRowFocus();
					}					
				},
				onRefresh: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgVehicle.onRemoveRowFocus();
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
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						tbgVehicle.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
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
					id: 'policyId',
					width: '0px',
					visible: false
				},
				{
					id: 'itemNo',
					width: '0px',
					visible: false
				},
				{
					id: 'dspAssdNo',
					width: '0px',
					visible: false
				},  
				{
					id: 'dspPremSeqNo',
					width: '0px',
					visible: false
				}, 
				{
					id: 'dspBillIssCd',
					width: '0px',
					visible: false
				}, 
				{
					id: 'plateNo',
					title: 'Plate No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				}, 
				{
					id: 'dspBillNo',
					title: 'Bill No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				}, 
				{
					id: 'dspLineCd dspSublineCd dspIssCd dspIssueYy dspPolSeqNo',
					title: 'Policy No.',
					sortable: true,
					children: [
						{
							id: 'dspLineCd',
							title: 'Line',
							width: 60,
							visible: true,
							sortable: true,
							filterOption: true
						},  	
						{
							id: 'dspSublineCd',
							title: 'Subline',
							width: 90,
							visible: true,
							sortable: true,
							filterOption: true
						},  	
						{
							id: 'dspIssCd',
							title: 'Iss Cd',
							width: 60,
							visible: true,
							sortable: true,
							filterOption: true
						},  	
						{
							id: 'dspIssueYy',
							title: 'Iss Yy',
							width: 50,
							visible: true,
							sortable: true,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},  	
						{
							id: 'dspPolSeqNo',
							title: 'Pol Seq No',
							width: 100,
							visible: true,
							sortable: true,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							renderer: function(value){
								return formatNumberDigits(value, 7);
							}
						}       
					]
				},	
				{
					id: 'dspEndtSeqNo dspEndtType',
					title: 'Endt. No.',
					sortable: true,
					children: [
						{
							id: 'dspEndtSeqNo',
							title: 'Endt Seq No.',
							width: 70,
							visible: true,
							sortable: true,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},   
						{
							id: 'dspEndtType',
							title: 'Endt Type',
							width: 70,
							visible: true,
							sortable: true,
							filterOption: true
						}     
					]
				},					
				{
					id: 'dspAssdName',
					title: 'Assured Name',
					width: '280px',
					visible: true,
					sortable: true,
					filterOption: true
				}
			],
			rows: objVehicle.objRows
		};
		
		tbgVehicle = new MyTableGrid(vehicleModel);
		tbgVehicle.pager = objVehicle.tableGrid;
		tbgVehicle.render('tbgVehicleDiv');
		tbgVehicle.afterRender = function(){
			objVehicle.objList = tbgVehicle.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Vehicle tablegrid error", e);
	}
	
	function showAssuredLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtAssdNo").trim() == "" ? "%" : $F("txtAssdNo"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs286AssdLov",
					search : searchString,
					page : 1
				},
				title : "",
				width : 370,
				height : 386,
				columnModel : [ {
					id : "assdNo",
					width : '100px',
					title: 'Assd No',
					renderer: function(value){
						return formatNumberDigits(value, 6);
					}
				}, {
					id : "assdName",
					title : "Assd Name",
					width : '255px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtAssdNo").setAttribute("lastValidValue", formatNumberDigits(row.assdNo, 6) );
						$("txtAssdNo").value = formatNumberDigits(row.assdNo, 6);
						$("txtAssdName").value = unescapeHTML2(row.assdName);
						
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						
						countVehiclesInsured();
					}
				},
				onCancel: function(){
					$("txtAssdNo").focus();
					$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAssdNo");
				} 
			});
		}catch(e){
			showErrorMessage("showAssuredLOV", e);
		}		
	}
	
	function countVehiclesInsured(){
		try{
			new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
				parameters: {
					action:		"countVehiclesInsured",
					assdNo:		$F("txtAssdNo")
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == 0){
							showMessageBox("Assured does not have a vehicle insured.", "W");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("countVehiclesInsured", e);
		}
	}
	
	function exitModule(rowDoubleClick){
		if (rowDoubleClick && selectedRowInfo != null){
			objGIACS213.policyId  = selectedRowInfo.policyId;
			objGIACS213.lineCd = selectedRowInfo.dspLineCd;
			objGIACS213.sublineCd = selectedRowInfo.dspSublineCd;
			objGIACS213.issCd = selectedRowInfo.dspIssCd;
			objGIACS213.issueYy = selectedRowInfo.dspIssueYy;
			objGIACS213.polSeqNo = selectedRowInfo.dspPolSeqNo;
			objGIACS213.endtSeqNo = selectedRowInfo.dspEndtSeqNo;
			objGIACS213.endtType = selectedRowInfo.dspEndtType;
			objGIACS213.assdName = selectedRowInfo.dspAssdName;
			objGIACS213.premSeqNo = selectedRowInfo.dspPremSeqNo;
		}else{
			objGIACS213.policyId  = null;
			objGIACS213.lineCd = null;
			objGIACS213.sublineCd = null;
			objGIACS213.issCd = null;
			objGIACS213.issueYy = null;
			objGIACS213.polSeqNo = null;
			objGIACS213.endtSeqNo = null;
			objGIACS213.endtType = null;
			objGIACS213.assdName = null;
			objGIACS213.premSeqNo = null;
		}
		
		$("acExit").show();
		showORInfo();
	}
	
	$("searchAssuredLOV").observe("click", function(){
		showAssuredLOV(true);
	});
	
	$("txtAssdNo").observe("change", function(){
		if (this.value != ""){
			showAssuredLOV(false);
		}else{
			$("txtAssdName").clear();
			$("txtAssdNo").setAttribute("lastValidValue", "");
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		disableToolbarButton("btnToolbarExecuteQuery");	
		disableToolbarButton("btnToolbarEnterQuery");	
		$("txtAssdNo").clear();
		$("txtAssdName").clear();
		$("txtAssdNo").readOnly = false;
		enableSearch("searchAssuredLOV");
		tbgVehicle.url = contextPath + "/GIACOrderOfPaymentController?action=showGiacs213&refresh=1&assdNo="+$F("txtAssdNo");
		tbgVehicle._refreshList();
		$("txtAssdNo").focus();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		disableToolbarButton("btnToolbarExecuteQuery");	
		$("txtAssdNo").readOnly = true;
		disableSearch("searchAssuredLOV");
		tbgVehicle.url = contextPath + "/GIACOrderOfPaymentController?action=showGiacs213&refresh=1&assdNo="+$F("txtAssdNo");
		tbgVehicle._refreshList();
	});
	
	$("btnToolbarExit").observe("click", exitModule);
	
	$("btnReturn").observe("click", exitModule);
	
	$("txtAssdNo").focus();
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>