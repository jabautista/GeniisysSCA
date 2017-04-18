<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="collateralTransMainDiv" name="collateralTransMainDiv" style="margin-top : 1px;">
	<form id="collateralTransMainForm" name="collateralTransMainForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp" ></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Collateral Transaction</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" id="gro" style="float: right">Hide</label>
				</span>
			</div>
		</div>
		<div id="collateralTransSubDiv" name="collateralTransSubDiv" style="border: 1px solid gray;">
			<div >
				<div id="collateralTableGridSectionDiv" class="sectionDiv" style="height: 200;">
					<div id="collateralTableGridDiv" style= "padding: 10px;">
						<div id="collateralTableGrid" style="height: 200px; width: 900px;"></div>
					</div>
				</div>
			</div>
			<div id="tableDiv" name="tableDiv" changeTagAttr="true" class="sectionDiv">
				<table align="center" style="padding-top: 15px;">
					<tr>
						<td class="rightAlligned">Collateral Type</td>
						<td class="leftAlligned" id="optionType" name="optionType">
							<select class="required" id="inputType" name="inputType">
							<option value=""></option>
							<c:forEach var="doc" items="${collateralListing}">
								<option id="inType" value="${doc.collType}" collType="${doc.collType}" style="width: 275px;">${doc.collName}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>	
						<td class="rightAlligned">Description</td>
						<td class="leftAlligned" >
						<div id="optionDesc" name="optionDesc" >
							<select id="inputDesc" name="inputDesc">
							  <!--<option value=""></option>-->
							<c:forEach var="desc" items="${collateralDescList}">
								<option id="option1" value="${desc.collDesc}" style="width: 275px;" collType ="${desc.collType}" collVal="${desc.collVal}" revDate="${desc.revDate}" collDesc="${desc.collDesc}" collId="${desc.collId}" collValDis="<fmt:formatNumber value="${desc.collVal}" pattern="#,###,##0.00" />">
								${desc.collDesc}
								</option>								
							</c:forEach>	
							</select>	
							
							<select id="inputDesc3" name="inputDesc3" style="width: 308px;" class="required">
							<c:forEach var="desc" items="${collateralDescList}">
								<option value="${desc.collDesc}">${desc.collDesc}</option>	
								</c:forEach>
							</select>		
						</div>				
						</td>	
					</tr>
					<tr>
						<td class="rightAlligned" >Collateral Value</td>
						<td class="leftAlligned">
							<input type="text" id="collValue" name="collValue" style="width: 300px; text-align: right;" ></input>	
							<input type="hidden" id="collValue2" name="collValue2"></input>				
						</td>
					</tr>
					<tr>
						<td class="rightAlligned">Receive Date</td>
						<td class="leftAlligned">
							<span class="" style="float: left; width: 305px; border: 1px solid gray;">
							<input style="float: left; width: 85%; border: none; height: 9px;" id="dateSubmitted" name="dateSubmitted" type="text" value="" tabindex="1" readonly="readonly"  changeTagAttr="true"/>
							<img id="hrefDateSubmitted" name="hrefDateSubmitted" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateSubmitted'),this, null);" style="margin-left: 20px; margin-top: 2px;" alt="Date Submitted"  />
							</span>			
						</td>
					</tr>
				
				</table>
				<div id="buttonDiv" name="buttonDiv" align="center" style="padding: 10px 0 10px 0;" changeTagAttr="true">
					<div style="margin: 10px">
						<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" ></input>
						<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete"></input>
						<!--  <input type="button" class="button" id="btnEdit" name="btnEdit" value="Post Edit"></input>-->
					</div>			
				</div>
			</div>		
		</div>
		<br></br>
		<div id="buttonDiv2" name="buttonDiv2" style="padding: 10px 0 50px 0; float: left; text-align: center; width:100%;" >
			<input type="button" class="button" id="btnCollBonds" name="btnCollBonds" value="Collateral Bonds" style="display: none;"></input> <!-- hide by steven 10.13.2014 -->
			<!--<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel"></input>-->
			<input type="button" class="button" id="btnSave" name="btnSave" value="Save"></input>				
		</div>
	</form>
</div>

<script type="text/javaScript">

	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	setModuleId("GIPIS018");
	//initializePARBasicMenu();
	clear();
	parId ='${parId}';	
	removeAllOptions($("inputDesc3"));
	var selectedIndex = -1;
	var collSw = 0;
	var collId = 0;
	var delCounter= 0;
	var cancelTag =1;
	var addCounter= 0;
	var editSw=0;
	var toggled = 0;
	var tempArray = new Object();
	var tempArray2 = new Array();
	var temp = new Array();
	try {
		var objCollateral = new Object();
		objCollateral.objCollateralListTableGrid = JSON.parse('${jsonCollList}'.replace(/\\/g, '\\\\'));
		objCollateral.objCollateralList = objCollateral.objCollateralListTableGrid.rows || [];
		
		var rowNumber = objCollateral.objCollateralList.length;
		var prevY= -1;
		var collateralTableModel = {
				url:contextPath+"/GIPIWCollateralTransactionController?action=showCollateralTransactionPage&refresh=1&parId="+parId,
				options:{
						title: '',
						width: '900px',
						height: '175px',
						onRowDoubleClick: function(param){
							var row = collateralTableGrid.geniisysRows[param];
							var collType = row.collType;
						},
						onCellFocus: function(element, value, x, y,id){
							removeAllOptions($("inputDesc3"));
							var opt = document.createElement("option");
							opt.value = "";
							opt.text = "";
							$("inputDesc3").options.add(opt);
							validStatus = true;
							if (prevY != y && prevY != -1){
								showEdit();
							}
							prevY = y;
							var mtgId = collateralTableGrid._mtgId;
							selectedIndex = -1;
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								selectedIndex = y;
								//selectedCollateralIndex= y;
							}
							try{
							temp =collateralTableGrid.getRow(selectedIndex);
							} catch (e) {}
							if (collateralTableGrid.geniisysRows[y]!=null){

								var row = collateralTableGrid.geniisysRows[y];
								$("inputType").value = row.collType;
								$("collValue").value = addCommas(parseFloat(row.collVal));
								//$("dateSubmitted").value = row.lastUpdate;
								$("dateSubmitted").value = row.revDate;
								opt.value = row.collDesc;
								opt.text = row.collDesc; 
								$("inputDesc").value = row.collDesc;
								tempArray.collVal = row.collVal; 
								tempArray.inputType = row.collType;
								tempArray.collDesc = row.collDesc; 
								tempArray.revDate = row.revDate;
								tempArray.collId = row.collId;
								
							}else if (collateralTableGrid.geniisysRows[y]==null){
								var rowAdded = collateralTableGrid.getNewRowsAdded();
								for(var i= 0; i<rowAdded.length; i++){
									if (y==rowAdded[i].divCtrId){
										newInd =1;
										$("inputType").value = rowAdded[i].collType;
										$("collValue").value = addCommas(parseFloat(rowAdded[i].collVal));
										$("dateSubmitted").value = rowAdded[i].revDate;
										//$("inputInDesc").value = rowAdded[i].collDesc;
										opt.value = rowAdded[i].collDesc;
										opt.text = rowAdded[i].collDesc;
										tempArray.collVal = rowAdded[i].collVal; 
										tempArray.inputType = rowAdded[i].collType;
										tempArray.collDesc = rowAdded[i].collDesc; 
										tempArray.revDate = rowAdded[i].revDate;
										tempArray.collId = rowAdded[i].collId;
										//editingNewRowsAdded();
									};
								};						
							};					
					
							enableButton("btnDelete");
							disableButton("btnAdd");
							toggled = 1;
							//hideOptions();
						},
						onRemoveRowFocus: function(){
							//showEdit();
							$("collValue").value = "";
							$("dateSubmitted").value = "";
							//$("inputInDesc").value =""; 
							$("inputDesc3").value =""; 
							clear();
							selectedIndex = -1;
							toggled = 0;
						},
						postSave: function(){

						}
				},
				
				columnModel:[
				 		{   id: 'recordStatus',
						    title: '',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'rowNum',
							width: '0px',
							visible: false
							
						},	
						{	id: 'collType',
							title: 'Collateral Type',
							width: '175',
							visible: true,
							align: 'center',
							titleAlign: 'center',
							filterOption: true
						},
						{	id: 'collDesc',
							title: 'Description',
							width:	'375'
						},
						{	id: 'collVal',
							title: 'Value',
							width: '165',
							type: 'number',
	            			maxlength: 16,
	            			geniisysClass: 'money',
	            			geniisysMinValue: '-9999999999.99',    
	            			geniisysMaxValue: '9,999,999,999.99',
							align: 'right',
							titleAlign: 'right'
						},
						{	id: 'revDate',
							title: 'Date Submittted',
							width: '170',
							align:	'center',
							titleAlign:	'center'
							//type: 'date'
						},
						{	id: 'collId',
							width: '0px',
							visible: false
						},	
						],
				rows:objCollateral.objCollateralList
			};
			collateralTableGrid = new MyTableGrid(collateralTableModel);
			collateralTableGrid.pager = objCollateral.objCollateralListTableGrid;
			collateralTableGrid.render('collateralTableGrid');


			
	} catch (e) {
		showMessageBox("Error " + e.message, imgMessage.ERROR);
	};

	var collDescLOV = new Object();
	collDescLOV = JSON.parse('${collateralDescList2}'.replace(/\\/g, '\\\\'));
	var newInd = 0;
	var colval ="";
	var recvDate ="";
	$("btnAdd").observe("click", addCollateral);
	$("btnDelete").observe("click", deleteCollateral);
	$("btnSave").observe("click", saveCollateral);
	$("btnCollBonds").observe("click", showCollBonds);
	//$("btnEdit").observe("click", showEdit);

	$("inputDesc").observe("change", function(){
		try{
		var i =$("inputDesc").selectedIndex;
		$("collValue").value =$("inputDesc").options[i].getAttribute("collValDis");
		$("collValue2").value =$("inputDesc").options[i].getAttribute("collVal");
		$("dateSubmitted").value = $("inputDesc").options[i].getAttribute("revDate");
		collId =  $("inputDesc").options[i].getAttribute("collId");
		//remove by steven 10.14.2014
// 		if (toggled == 1){
// 			collateralTableGrid.setValueAt($("inputDesc").value, collateralTableGrid.getColumnIndex('collDesc'), selectedIndex, true);
// 			collateralTableGrid.setValueAt($("collValue").value, collateralTableGrid.getColumnIndex('collVal'), selectedIndex, true);
// 			collateralTableGrid.setValueAt($("dateSubmitted").value, collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true);
// 			collateralTableGrid.setValueAt(collId, collateralTableGrid.getColumnIndex('collId'), selectedIndex, true);
// 		}
		}catch(e){}
	});

	$("inputDesc3").observe("change", function(){
		try{
		var i =$("inputDesc3").selectedIndex;
		//$("collValue").value = collDescLOV[i].collValDis;
		$("collValue").value = colVal;
		$("collValue2").value =colVal;
		$("dateSubmitted").value = recvDate;
		//remove by steven 10.14.2014
// 		if (toggled == 1){
// 			collateralTableGrid.setValueAt($("inputDesc3").value, collateralTableGrid.getColumnIndex('collDesc'), selectedIndex, true);
// 			collateralTableGrid.setValueAt($("collValue").value, collateralTableGrid.getColumnIndex('collVal'), selectedIndex, true);
// 			collateralTableGrid.setValueAt($("dateSubmitted").value, collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true);
// 			collateralTableGrid.setValueAt(collId, collateralTableGrid.getColumnIndex('collId'), selectedIndex, true);
// 		}
		}catch(e){}
		var temDesc = $("inputDesc3").value;
		if (newInd == 1){
			collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('collDesc')] = temDesc ;
		}
	});

	$("collValue").observe("change", function(){

		try{
			$("collValue2").value = $("collValue").value;
			var temVal = $("collValue").value;
			//remove by steven 10.14.2014
// 			if (toggled == 1){
// 				collateralTableGrid.setValueAt(($("collValue").value), collateralTableGrid.getColumnIndex('collVal'), selectedIndex, true);
// 				collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('collVal')] = $F("collValue").value;
// 			}
		}catch(e){}
		if (newInd == 1){
		collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('collVal')] = temVal ;
		}
	});
	
	
	$("inputType").observe("change", function(){
		
		try{
			$("inputDesc").hide();
			$("inputDesc3").show();
			//$("inputDesc3").value="";
			//$("collValue").value = "";
			//$("dateSubmitted").value = "";
			//checkCollType();
// 			if (toggled == 1){
// 				collateralTableGrid.setValueAt($("inputType").value, collateralTableGrid.getColumnIndex('collType'), selectedIndex, true);	
// 			}
		}catch(e){}
			removeAllOptions($("inputDesc3"));
			var opt = document.createElement("option");
			opt.value = "";
			opt.text = "";
			$("inputDesc3").options.add(opt);
			collDescLOV = getCollDesc();
			for(var a=0; a<collDescLOV.length; a++){
				if (collDescLOV[a].collType == $("inputType").value ){
					var opt = document.createElement("option");
					opt.value = collDescLOV[a].collDesc;
					colVal = collDescLOV[a].collVal;
					recvDate = collDescLOV[a].revDate;
					collId = collDescLOV[a].collId;
					opt.text = collDescLOV[a].collDesc;
					$("inputDesc3").options.add(opt);
				}
			}
			//$("inputDesc3").value = initValue;	
		
		var temType = $("inputType").value;
		if (newInd == 1){
			collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('collType')] = temType ;
			collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('collId')]= collId;
		}
		
	});

	$("tableDiv").observe("mouseover", function(){
		try{
			if ($("dateSubmitted").value != collateralTableGrid.getValueAt(collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true)){	
				if (toggled == 1){
					collateralTableGrid.setValueAt($("dateSubmitted").value , collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true);
				}
			}
		}catch(e){}
		var temDate = $("dateSubmitted").value;
		if (newInd == 1){
			try{
				collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('revDate')] = temDate;
			}catch(e){};
		}
	});
	/*
	$("dateSubmitted").observe("mouseup", function(){
		try{
			if (toggled == 1){
				collateralTableGrid.setValueAt($("dateSubmitted").value , collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true);
			}
		}catch(e){}
		var temDate = $("dateSubmitted").value;
		if (newInd == 1){
			collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('revDate')] = temDate;
		}
	});
	*/

	function hideOptions() {
		$("inputDesc").hide();
		$("inputDesc3").hide();
		$("inputType").hide();
	};

	function clear() {
		$("inputDesc").hide();
		$("collValue").value = "";
		$("dateSubmitted").value = "";
		$("inputDesc3").show();
		$("inputDesc3").value="";
		$("inputType").show();
		$("inputType").value = "";
		enableButton("btnAdd");
		disableButton("btnDelete");
		removeAllOptions($("inputDesc3"));
	};

	function populate() {
		hideOptions();
		//$("inputInDesc").show();
		enableButton("btnDelete");
		disableButton("btnAdd");
	};

	//

	function deleteCollateral() {
		deleteRow(collateralTableGrid, selectedIndex);
		changeTag = 1;
	};

	function saveCollateral() {
		showEdit();
		var deletedRows = new Array();
		cancelTag =0;
		deletedRows = collateralTableGrid.getDeletedRows();
		if (collateralTableGrid.getModifiedRows().length!=0){
			changeTag =1;
		};
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			checkStatus();
		} 
		changeTag = 0;
		
	};

	
	function cancelCollateral() {
		cancelTag =1;
		if (changeTag == 1){
			showConfirmBox("", 
				   	   "Do you want to save the changes you have made?", 
				   	   "Yes", "No", commitAddedRows,showParListing);
		}else{
			//showParListing();
		}
	};

	function showCollBonds() {
	};
	
	try{
	if ($("dateSubmitted").value != collateralTableGrid.getValueAt(collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true)){
		collateralTableGrid.setValueAt($("dateSubmitted").value , collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true);				
	}
	}catch(e){}
	function showEdit(){
		if (toggled ==1){
			if (newInd != 1){
				checkIfValid();
			}
		}
		try{
		if ($("dateSubmitted").value != collateralTableGrid.getValueAt(collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true)){
			collateralTableGrid.setValueAt($("dateSubmitted").value , collateralTableGrid.getColumnIndex('revDate'), selectedIndex, true);				
		}
		}catch(e){}
		if (newInd != 1){
			if (collateralTableGrid.getModifiedRows().length != collateralTableGrid.getDeletedRows().length){
				if (validStatus == true){
					tempArray2.push(temp);	
				}	
			}
		};
		//cancelTag=0;
		changeTag =1;
		editSw = 0;
		
	};
	validStatus = true;
	function checkCollType(){
		var i =$("inputType").selectedIndex;
		var collType = $("inputType").options[i].getAttribute("collType");
		if (collType != null) {
			if (collType == $("inputDesc").options[1].getAttribute("collType")) {
				//$("inputDesc3").hide();
				$("inputDesc").show();
				//$("inputDesc2").hide();
			} else if (collType == $("inputDesc2").options[1].getAttribute("collType")) {
				$("inputDesc").hide();
				$("inputDesc2").show();
				//$("inputDesc3").hide();
				collSw = 1;
			} else if (i == 0) {
				$("inputDesc").hide();
				$("inputDesc2").hide();
				$("inputDesc3").show();
				$("collValue").value = "";
				$("dateSubmitted").value = "";
			}
			i = 0;
		}

	};
	
	function addCollateral() {
		if ($F("inputType")== null || (($F("inputType")==1&&($F("inputDesc3")== null || $F("inputDesc3")=="" )))|| $F("inputType")=="") {
			showMessageBox("Field must be entered");
		//}else if($F("inputType")== null ||$F("inputType")=="" || (($F("inputType")==2&&($F("inputDesc2")== null || $F("inputDesc2")=="" )))){
			//showMessageBox("Field must be entered1");	
		}else{
			var objArray = new Array();
			objArray.collType = $F("inputType");
			objArray.collDesc = $F("inputDesc3");
			
			if (editSw == 1){
				objArray.collVal = $F("collValue");
			}else{
				objArray.collVal = $F("collValue2");
			};
			objArray.revDate = $F("dateSubmitted");
			objArray.collId = collId;
			if (collSw == 1) {
				objArray.collDesc = $F("inputDesc2");
			}
			;
			objArray.push(objArray);
			changeTag = 1;
			rowNumber++;
			createNewRows(collateralTableGrid, objArray);
			addCounter=collateralTableGrid.getNewRowsAdded().length;
			clear();
		}
	};

	function createNewRows(collateralTableGrid, objArray){
		
		var newRows = collateralTableGrid.generateRows(objArray);
		for (var i=0; i<newRows.length; i++){
			var divCtrId = (rowNumber-1) * -1;
			newRows[i][collateralTableGrid.getColumnIndex('divCtrId')] = -divCtrId;
			collateralTableGrid.bodyTable.down('tbody').insert({bottom: collateralTableGrid._createRow(newRows[i], -divCtrId)});
			//collateralTableGrid.newRowsAdded[divCtrId-1] = newRows[i];
			collateralTableGrid.newRowsAdded[-divCtrId] = newRows[i];
			collateralTableGrid.keys.setTopLimit(-divCtrId);
			collateralTableGrid._addKeyBehaviorToRow(newRows[i], -divCtrId);
			collateralTableGrid.keys.addMouseBehaviorToRow(-divCtrId);
			collateralTableGrid._applyCellCallbackToRow(-divCtrId);
			collateralTableGrid.scrollTop = collateralTableGrid.bodyDiv.scrollTop = 0;
		}	
	}
	
	function deleteRow(tableGrid, selectedIndex){

		if (tableGrid.newRowsAdded[selectedIndex] != null){
			$('mtgRow'+tableGrid._mtgId+'_'+tableGrid.newRowsAdded[selectedIndex][tableGrid.getColumnIndex('divCtrId')]).addClassName('selectedRow');
			$('mtgRow'+tableGrid._mtgId+'_'+selectedIndex).hide();
			tableGrid.newRowsAdded[(selectedIndex)] = null;	
			addCounter--;				
		}else{
		$('mtgRow'+tableGrid._mtgId+'_'+tableGrid.rows[selectedIndex][tableGrid.getColumnIndex('divCtrId')]).addClassName('selectedRow');
            if (selectedIndex >=0) {
            	if ($('mtgRow'+tableGrid._mtgId+'_'+selectedIndex).getStyle("display") != "none"){
            		tableGrid.deletedRows.push(tableGrid.getRow(selectedIndex));
            	}
            } else {
            	tableGrid.newRowsAdded[Math.abs(selectedIndex)-1] = null;
            }
            $('mtgRow'+tableGrid._mtgId+'_'+selectedIndex).hide();	
		}
		delCounter=collateralTableGrid.getDeletedRows().length;
		changeTag = 1;
		rowNumber--;
		if (editSw != 1){
			clear();
		};
		//editSw=0;
	}
	var strParameters = "";

	function checkStatus(){
		if (toggled ==1){
			if (newInd != 1){
				checkIfValid();
			}
		}
		if (cancelTag == 1){
			showParListing();
		}else{
			commitAddedRows();
		}
		validStatus = true;
	};

	function commitAddedRows(){
		if (cancelTag == 1){
			showEdit();	
		}
		var paramUpdate = tempArray2;
		var addedRows = collateralTableGrid.getNewRowsAdded();
		var modifiedRows = collateralTableGrid.getModifiedRows();
		var delRows  = collateralTableGrid.getDeletedRows();
		var objParameters = new Object();
		objParameters.delRows = delRows;
		//objParameters.setRows = addedRows.concat(modifiedRows);
		objParameters.setRows = addedRows;
		objParameters.setModifiedRows = modifiedRows;
		objParameters.setParamUpdate = paramUpdate;
		strParameters = JSON.stringify(objParameters);
		new Ajax.Request(contextPath+"/GIPIWCollateralTransactionController?action=insertNewCollateral",{
			method: "POST",
			asynchronous: true,
			evalScripts: true,
			parameters:{strAdded: strParameters,
						parId: parId},
			//parameters:{strAdded: strAdded},
			onCreate: function () {
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Done!");
					if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
						selectedIndex = -1;   
						var totCounter = addCounter + delCounter + collateralTableGrid.getModifiedRows().length;
						addCounter = 0;
						delCounter = 0;
						showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
						if (cancelTag == 1){
							showParListing();
						}else{
							clear();
							changeTag = 0;
							collateralTableGrid.clear();
							collateralTableGrid.refresh();
						}
						collateralTableGrid.newRowsAdded = [];
						collateralTableGrid.deletedRows = [];
						collateralTableGrid.modifiedRows = [];
						temp = [];
						tempArray2 = [];
						newInd= 0;
						cancelTag=0;
					}
				}			
			}
		});
	};

	function addCommas(nStr)
	{
		nStr1=nStr.toFixed(2);
		nStr1 += '';
		x = nStr1.split('.');
		x1 = x[0];
		x2 = x.length > 1 ? '.' + x[1] : '';
		var rgx = /(\d+)(\d{3})/;
		while (rgx.test(x1)) {
			x1 = x1.replace(rgx, '$1' + ',' + '$2');
		}
		return x1 + x2;
	}
	function checkIfValid(){
		var tempCT;
		var tempCD;
		try{
			if (newInd == 1){
				//tempCD = collateralTableGrid.newRowsAdded[selectedIndex][collateralTableGrid.getColumnIndex('collDesc')];
			}else{
				tempCT = collateralTableGrid.getValueAt(collateralTableGrid.getColumnIndex('collType'), selectedIndex, true);
				tempCD = collateralTableGrid.getValueAt(collateralTableGrid.getColumnIndex('collDesc'), selectedIndex, true);
			}
		}catch (e){}
		var tempCD2= "";
		for(var a=0; a<collDescLOV.length; a++){
			if (collDescLOV[a].collType == tempCT ){
				tempCD2 = collDescLOV[a].collDesc;
			}
		}
		if (tempCD != null){
			if (tempCT == null || tempCT=="" || tempCD != tempCD2){
				validStatus = false;
			}
		}
	}
	
	function getCollDesc() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIPIWCollateralTransactionController", {
				parameters : {action : "getCollDesc",
							  collType : $F("inputType")},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = eval(response.responseText);
						objReturn = obj;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getCollDesc",e);
		}
	}
	
	observeReloadForm("reloadForm", showCollateralTransactionPage); //added by steven 10.13.2014
	initializeChangeTagBehavior(checkStatus);
		
</script>