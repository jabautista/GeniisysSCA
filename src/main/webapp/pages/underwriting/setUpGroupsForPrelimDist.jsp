<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="setupGroupForPrelimDistMainDiv" name="setupGroupForPrelimDistMainDiv" style="margin-top: 1px;">
	<input type="hidden" id="initialParId" value="${parId}"/>
	<input type="hidden" id="initialLineCd" value=""/> 	
	<form id="setupGroupForPrelimDistForm" name="setupGroupForPrelimDistForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<c:if test="${isPack eq 'Y'}">
			<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
		</c:if>
		
		<div id="distGroupMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Group</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistGroup" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			<div id="distGroupMain" class="sectionDiv" style="border: 0px;">	
				<div id="distGroup1Div" class="sectionDiv" style="display: block;">
					<div id="distListingTableDiv" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 35%; text-align: right; margin-right: 15px;">Distribution No.</label>
							<label style="width: 60%; text-align: left; ">Distribution Status</label>
						</div>
						<div id="distListingDiv" name="distListingDiv" class="tableContainer">
								
						</div>
					</div>	
				</div>
				<div id="distGroup2Div" class="sectionDiv" style="display: block;">
					<div id="distWitemdsDiv" style="position:relative; height: 350px; margin: 10px;">
					
					</div>
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnCreateItems"	name="btnCreateItems"	class="button"	value="Create Items" />
			<input type="button" id="btnNewGroup"		name="btnNewGroup"		class="button"	value="New Group" />
			<input type="button" id="btnJoinGroup" 		name="btnJoinGroup" 	class="button"	value="Join Group" />			
			<input type="button" id="btnCancel"			name="btnCancel"		class="button"	value="Cancel" />
			<input type="button" id="btnSave" 			name="btnSave" 			class="button"	value="Save" />			
		</div>
	</form>
</div>	
<script type="text/JavaScript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIUWS001");
	objUW.hidObjGIUWS001 = {};
	objUW.hidObjGIUWS001.GIUWPolDist = JSON.parse('${GIUWPolDistJSON}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIUWS001.selectedGIUWPolDist = {};
	objUW.hidObjGIUWS001.GIUWWitemds = [];
	objUW.hidObjGIUWS001.recreateArr = [];
	
	var tableGrid;
	var selItemGrp = null;

	// for package (emman 07.14.2011)
	var isPack = '${isPack}';

	// Global Variables (emman 07.14.2011)
	var globalParType = (isPack != "Y") ? $F("globalParType") : objUWGlobal.parType;
	var globalLineCd = (isPack != "Y") ? $F("globalLineCd") : null;
	var globalParId = (isPack != "Y") ? $F("globalParId") : objUWGlobal.packParId;
	var globalPackParId = (isPack != "Y") ? $F("globalPackParId") : objUWGlobal.packParId;
	var globalSublineCd = (isPack != "Y") ? $F("globalSublineCd") : null;
	var globalIssCd = (isPack != "Y") ? $F("globalIssCd") : null;
	var globalPackPolFlag = (isPack != "Y") ? $F("globalPackPolFlag") : null;
	var globalPolFlag = (isPack != "Y") ? $F("globalPolFlag") : null;
	
	var tableModel = {
		options : {
			hideColumnChildTitle: true,
			querySort: false,				// to sort using existing rows
			addSettingBehavior: false,     	// disable|remove setting icon button
			addDraggingBehavior: false,    	// disable dragging behavior
			onCellFocus : function(element, value, x, y, id) {
				var exist = "N";
				disableButton("btnNewGroup");
				disableButton("btnJoinGroup");
				$$('.mtgInput'+tableGrid._mtgId+'_0').each(function(row){
			        if (row.checked){
			        	enableButton("btnNewGroup");
						enableButton("btnJoinGroup");
						return;
			        }    
			    });
				$$('.mtgInput'+tableGrid._mtgId+'_0').each(function(row){
			        if (row.checked){
			        	var coords = row.id.substring(row.id.indexOf('_') + 1, row.id.length).split(',');
			            var yy = coords[1];
			            if (yy<0){
							if (tableGrid.newRowsAdded[Math.abs(yy)-1] != null) tableGrid.newRowsAdded[Math.abs(yy)-1][tableGrid.getColumnIndex('recordStatus')] = true;
						}
			        }    
			    });
	            
				selItemGrp = selItemGrp == null ? (y>=0?tableGrid.rows[y][tableGrid.getColumnIndex('itemGrp')]:tableGrid.newRowsAdded[Math.abs(y)-1][tableGrid.getColumnIndex('itemGrp')]) :selItemGrp;
				
				for (var i=0; i<tableGrid.rows.length; i++){
					var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
					var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
					var recordStatus = tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')];
					var itemGrp = tableGrid.rows[i][tableGrid.getColumnIndex('itemGrp')];
					var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
					if ($F("txtC080DistNo") == distNo && recordStatus && nvl(deleted,"") == ""){
						exist = "Y";
						if(itemGrp != selItemGrp){
							showMessageBox("Only items of the same item group may be combined.", imgMessage.INFO);
							$('mtgInput'+tableGrid._mtgId+'_0,'+divCtrId).checked = false;
							tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')] = "";
						}
					}
				}
				
				for (var i=0; i<tableGrid.newRowsAdded.length; i++){
					if (tableGrid.newRowsAdded[i] != null){
						var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
						var divCtrId = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')];
						var recordStatus = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')];
						var itemGrp = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('itemGrp')];
						var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
						if ($F("txtC080DistNo") == distNo && recordStatus && nvl(deleted,"") == ""){
							exist = "Y";
							if(itemGrp != selItemGrp){
								showMessageBox("Only items of the same item group may be combined.", imgMessage.INFO);
								$('mtgInput'+tableGrid._mtgId+'_0,'+divCtrId).checked = false;
								tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')] = "";
							}
						}
					}
				}		
				if (exist == "N") selItemGrp = null;
			},
			toolbar : {
				onSave: function() {
					for (var i=0; i<tableGrid.rows.length; i++){
						var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
						if (tableGrid.modifiedRows.indexOf(divCtrId) == -1) tableGrid.modifiedRows.push(divCtrId);
					}
				
					var ok = true;
				 	var addedRows 	 	= tableGrid.getNewRowsAdded();
					var modifiedRows 	= tableGrid.getModifiedRows();
					var delRows  	 	= tableGrid.getDeletedRows();
					var recreateRows 	= prepareJsonAsParameter(objUW.hidObjGIUWS001.recreateArr);
					var objParameters = new Object();
					//objParameters.delRows = delRows; //no need na ito.
					objParameters.setRows = addedRows.concat(modifiedRows);
					objParameters.recreateRows = recreateRows;
					objParameters.parId = (isPack != "Y") ? globalParId : globalPackParId;
					objParameters.lineCd = globalLineCd;
					objParameters.sublineCd = globalSublineCd;
					objParameters.issCd = globalIssCd;
					objParameters.packPolFlag = globalPackPolFlag;
					objParameters.polFlag = globalPolFlag;
					objParameters.parType = globalParType;
					objParameters.isPack = isPack;
					
					var strParameters = JSON.stringify(objParameters);
					new Ajax.Request(contextPath+"/GIUWPolDistController?action=saveSetupGroupDist",{
						method: "POST",
						parameters:{
							parameters: strParameters
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function(){
							showNotice("Saving, please wait...");
						},
						onComplete: function(response){
							hideNotice("");
							if(checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS"){
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
									changeTag = 0;
									ok = true;
								}
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								ok = false;
							}
						}	 
					});	
					return ok; 	
				},
				postSave: function(){
					showSetUpGroupsForPrelimDist();
				}
			}	
		},
		columnModel : [
		 	//si recordStatus at divCtrId column is required... 
		   	{ 								// this column will only use for deletion
		   		id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
		   	 	title: '',
		   		width: 19,
		   		sortable: false,
		   		editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
		   		//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
		   		//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
		   		editor: 'checkbox',
		   		hideSelectAllBox: true
		   	},
		   	{
		   		id: 'divCtrId',
		   		width: '0',
		   		visible: false 
		   	},
		   	{
				id: 'distNo',
				width: '0',
				visible: false 	
			},
		   	{
				id: 'itemNo',
				title: 'Item',
				width: 42,
				editable: false,
				align: 'right',
				renderer: function (value){
					return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
				} 		
			},
		   	{
				id: 'distSeqNo',
				title: 'Grp',
				width: 37,
				editable: false,
				align: 'center' 		
			},
		   	{
				id: 'nbtItemTitle',
				title: 'Item Title',
				width: 90,
				editable: false 		
			},
		   	{
				id: 'nbtItemDesc',
				title: 'Item Description',
				width: 108,
				editable: false 		
			},
		   	{
				id: 'tsiAmt',
				title: 'Sum Insured',
				type : 'number',
				width: 100,
				editable: false,
				geniisysClass : 'money'	
			},
		   	{
				id: 'premAmt',
				title: 'Premium',
				type : 'number',
				width: 100,
				editable: false ,
				geniisysClass : 'money'		
			},
			{
				id: 'annTsiAmt',
				width: '0',
				visible: false 	
			},
			{
				id: 'arcExtData',
				width: '0',
				visible: false 	
			},
		   	{
				id: 'itemGrp',
				title: 'Item Grp',
				width: 65,
				editable: false,
				align: 'right',
				renderer: function (value){
					return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
				}
			},
			{
				id: 'nbtCurrencyCd',
				width: '0',
				visible: false 	
			},
			{
				id: 'origDistSeqNo',
				width: '0',
				visible: false 	
			},
		   	{
				id: 'dspShortName dspCurrencyRt',
				title: 'Currency / Rate',
				width : 147,
				children : [
		            {
		                id : 'dspShortName',
		                width : 50,
		                editable: false 		
		            },
		            {
		                id : 'dspCurrencyRt', 
		                width : 100,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatToNthDecimal(nvl(value, 0),9);
						}		
		            }
				]
			},
		   	{
				id: 'dspPackLineCd dspPackSublineCd',
				title: 'Package Line',
				width : 147,
				children : [
		            {
		                id : 'dspPackLineCd',
		                width : 50,
		                editable: false		
		            },
		            {
		                id : 'dspPackSublineCd',
		                width : 100,
		                editable: false,
		                defaultValue: "" 		
		            }
				]
			},
			{
				id: 'deleted',
				width: '0',
				visible: false,
				defaultValue: ''
			}	
		],
		rows : objUW.hidObjGIUWS001.GIUWWitemds		
	};		
		
	function setItemGrid(){
		try{
			tableGrid = new MyTableGrid(tableModel);
			tableGrid.render('distWitemdsDiv');  // 'mytable1' div id that will contain the table grid
			$("innerBodyDiv"+tableGrid._mtgId).hide();
		}catch(e){
			showErrorMessage("setItemGrid", e);
		}
	}

	function checkTablGrid(){
		try{
			disableButton("btnNewGroup");
			disableButton("btnJoinGroup");
			if (nvl(tableGrid,null) instanceof MyTableGrid){
				for (var i=0; i<tableGrid.rows.length; i++){
					var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
					var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
					var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
					if ($F("txtC080DistNo") == ""){
						tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')] = "";
						selItemGrp = null;
						$("innerBodyDiv"+tableGrid._mtgId).hide();
						$("mtgRow"+tableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+tableGrid._mtgId+"_"+divCtrId).hide() :null;
						tableGrid.unselectRows();
					}else{
						$("innerBodyDiv"+tableGrid._mtgId).show();
						tableGrid.unselectRows();
						$("mtgInput"+tableGrid._mtgId+"_0,"+divCtrId).checked = false;
						if (Number($F("txtC080DistNo")) != distNo || nvl(deleted,"") == "Y"){
							$("mtgRow"+tableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+tableGrid._mtgId+"_"+divCtrId).hide() :null;
						}else{
							$("mtgRow"+tableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+tableGrid._mtgId+"_"+divCtrId).show() :null;
						}	
					}
				}
				for (var i=0; i<tableGrid.newRowsAdded.length; i++){
					if (tableGrid.newRowsAdded[i] != null){
						var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
						var divCtrId = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')];
						var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
						if ($F("txtC080DistNo") == ""){
							tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')] = "";
							selItemGrp = null;
							$("innerBodyDiv"+tableGrid._mtgId).hide();
							$("mtgRow"+tableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+tableGrid._mtgId+"_"+divCtrId).hide() :null;
							tableGrid.unselectRows();
						}else{
							$("innerBodyDiv"+tableGrid._mtgId).show();
							tableGrid.unselectRows();
							$("mtgInput"+tableGrid._mtgId+"_0,"+divCtrId).checked = false;
							if (Number($F("txtC080DistNo")) != distNo || nvl(deleted,"") == "Y"){
								$("mtgRow"+tableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+tableGrid._mtgId+"_"+divCtrId).hide() :null;
							}else{
								$("mtgRow"+tableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+tableGrid._mtgId+"_"+divCtrId).show() :null;
							}	
						}
					}
				}
			}
		}catch(e){
			showErrorMessage("checkTablGrid", e);
		}
	}	
	
	//prepare listing for Main distribution
	function prepareList(obj){
		try{
			var list = '<label style="width: 35%; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
					   '<label style="width: 60%; text-align: left; ">'+nvl(obj.distFlag,'')+'-'+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(35, "...")+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList", e);
		}	
	}

	//show all listing
	function showList(objArray){
		try{
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareList(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				newDiv.setAttribute("id", "rowSetUpGroupsDist"+a);
				newDiv.setAttribute("name", "rowSetUpGroupsDist");
				newDiv.setAttribute("distNo", objArray[a].distNo);
				newDiv.setAttribute("parId", objArray[a].parId);
				newDiv.addClassName("tableRow");

				if (isPack == "Y") {
					newDiv.setStyle("display : none");
				}

				newDiv.update(content);
				$("distListingDiv").insert({bottom : newDiv});
				for(var b=0; b<objArray[a].giuwWitemds.length; b++){
					objArray[a].giuwWitemds[b].deleted = '';
					objUW.hidObjGIUWS001.GIUWWitemds.push(objArray[a].giuwWitemds[b]);
				}
				if (a == (objArray.length-1)){
					setItemGrid(); 
				}

				resizeTableBasedOnVisibleRows("distListingTableDiv", "distListingDiv");
			}
		}catch(e){
			showErrorMessage("showList", e);
		}	
	}

	//to show/generate the table listing
	showList(objUW.hidObjGIUWS001.GIUWPolDist);

	function clearForm(){
		try{
			supplyDist(null);
			deselectRows("distListingDiv", "rowSetUpGroupsDist");
			checkTableItemInfo("distListingTableDiv","distListingDiv","rowSetUpGroupsDist");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}
	
	//create observe on Main list
	$$("div#distListingDiv div[name=rowSetUpGroupsDist]").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
		setClickObserverPerRow(row, 'distListingDiv', 'rowSetUpGroupsDist', 
				function(){
					var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
					for(var a=0; a<objUW.hidObjGIUWS001.GIUWPolDist.length; a++){
						if (objUW.hidObjGIUWS001.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUWS001.GIUWPolDist[a].recordStatus != -1){
							supplyDist(objUW.hidObjGIUWS001.GIUWPolDist[a]);
						}
					}
				}, 
				clearForm);
	});

	function supplyDist(obj){
		try{
			objUW.hidObjGIUWS001.selectedGIUWPolDist 	= obj==null?{}:obj;
			$("txtC080DistNo").value 					= nvl(obj==null?null:obj.distNo,'') == '' ? null :formatNumberDigits(obj.distNo,8);
			$("txtC080DistFlag").value 					= nvl(obj==null?null:obj.distFlag,'');
			$("txtC080MeanDistFlag").value 				= nvl(obj==null?null:obj.meanDistFlag,'');
			buttonLabel(obj);
			checkTablGrid();
		}catch(e){
			showErrorMessage("supplyDist", e);
		}
	}	

	function buttonLabel(obj){
		try{
			if (obj == null){
				disableButton("btnCreateItems");
				$("btnCreateItems").value = "Create Items";
				disableButton("btnNewGroup"); 
				disableButton("btnJoinGroup");
			}else{
				if (obj.giuwWpolicydsExist == "Y"){
					enableButton("btnCreateItems");
					$("btnCreateItems").value = "Recreate Items";
				}else{
					enableButton("btnCreateItems");
					$("btnCreateItems").value = "Create Items";
				}
				if(obj.distFlag == "3" || (nvl(obj.reverseDate,null) == null && nvl(obj.reverseSw,null) == "N")){
					disableButton("btnCreateItems");
				}		
			}	
		}catch(e){
			showErrorMessage("buttonLabel", e);
		}
	}	
	
	function generateOverlayLovRow(id, objArray, width){
		try{
			for(var a=0; a<objArray.length; a++){
				var newDiv = new Element("div");
				newDiv.setAttribute("id", a);
				newDiv.setAttribute("name", id+"LovRow");
				newDiv.setAttribute("val", objArray[a]);
				newDiv.setAttribute("class", "lovRow");
				newDiv.setStyle("width:98%; margin:auto;");
				
				var codeDiv = new Element("label");
				codeDiv.setStyle("width:100%; float:left; text-align:center;");
				codeDiv.setAttribute("title", nvl(objArray[a],''));
				codeDiv.update(nvl(objArray[a],'&nbsp;'));
				
				newDiv.update(codeDiv);
				$("lovListingDiv").insert({bottom: newDiv});
				var header1 = generateOverlayLovHeader('100%', 'Existing Groups');
				$("lovListingDivHeader").innerHTML = header1;
				$("lovListingMainDivHeader").show();
			}
		}catch(e){
			showErrorMessage("generateOverlayLovRow", e);
		}
	}

	function clearGroup(){
		try{
			disableButton("btnNewGroup");
			disableButton("btnJoinGroup");
			selItemGrp = null;
			tableGrid.unselectRows();
			for (var i=0; i<tableGrid.rows.length; i++){
				var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
				tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')] = "";
				$("mtgInput"+tableGrid._mtgId+"_0,"+divCtrId).checked = false;
			}
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					var divCtrId = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')];
					tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')] = "";
					$("mtgInput"+tableGrid._mtgId+"_0,"+divCtrId).checked = false;
				}
			}	
			$$('.mtgInput'+tableGrid._mtgId+'_0').each(function(row){
		        if (row.checked){
		        	row.checked = false;
		        }    
		    });
		}catch(e){
			showErrorMessage("clearGroup", e);
		}
	}	

	function checkJoinGroups(group){
		try{
			var ok = true;
			var arr = [];
			for (var i=0; i<tableGrid.rows.length; i++){
				var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
				var distSeqNo = Number(tableGrid.rows[i][tableGrid.getColumnIndex('distSeqNo')]);
				var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')]; 
				if (Number($F("txtC080DistNo")) == distNo && nvl(deleted,"") == ""){
					if (tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')]){
						if (arr.toString().indexOf(group) == -1){ arr.push(group);}
					}else{
						if (arr.toString().indexOf(distSeqNo) == -1) {arr.push(distSeqNo);}
					}		
				}	
			}	
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
					var distSeqNo = Number(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distSeqNo')]);
					var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')]; 
					if (Number($F("txtC080DistNo")) == distNo && nvl(deleted,"") == ""){
						if (tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')]){
							if (arr.toString().indexOf(group) == -1){ arr.push(group);}
						}else{
							if (arr.toString().indexOf(distSeqNo) == -1) {arr.push(distSeqNo);}
						}		
					}
				}
			}		
			arr.sort();
			for (var i=0; i<arr.length; i++){
				if ((i+1) != arr[i]){
					ok = false;
					$break;
				}	
			}	
			return ok;
		}catch(e){
			showErrorMessage("checkJoinGroups", e);
		}
	}	

	function changeGrouping(value){
		try{
			for (var i=0; i<tableGrid.rows.length; i++){
				if (nvl(tableGrid.rows[i],null) != null){
					var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
					var itemGrp = tableGrid.rows[i][tableGrid.getColumnIndex('itemGrp')];
					var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
					var distSeqNo = tableGrid.rows[i][tableGrid.getColumnIndex('distSeqNo')];
					var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
					if (Number($F("txtC080DistNo")) == distNo && itemGrp == selItemGrp && tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')] && nvl(deleted,"") == ""){
						tableGrid.setValueAt(value,tableGrid.getIndexOf('distSeqNo'),divCtrId,true);
					}	
				}
			}
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (nvl(tableGrid.newRowsAdded[i],null) != null){
					var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
					var itemGrp = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('itemGrp')];
					var divCtrId = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')];
					var distSeqNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distSeqNo')];
					var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
					if (Number($F("txtC080DistNo")) == distNo && itemGrp == selItemGrp && tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')] && nvl(deleted,"") == ""){
						tableGrid.setValueAt(value,tableGrid.getIndexOf('distSeqNo'),divCtrId,true);
					}	
				}
			}
			changeTag=1;
		}catch(e){
			showErrorMessage("changeGrouping", e);
		}		
	}	
	
	function startLOV(id, title, objArray, width){
		try{
			if (nvl(objArray.length,0) <= 0){
				showMessageBox("There are no available groups to choose from. Please try choosing a different set of records.", imgMessage.ERROR);
				return false;
			}
			if (($("contentHolder").readAttribute("src") != id)) {
				initializeOverlayLov(id, title, width);
				generateOverlayLovRow(id, objArray, width);
				function onOk(){
					try{
						var group = unescapeHTML2(getSelectedRowAttrValue(id+"LovRow", "val"));
						if (group == ""){showMessageBox("Please select any group first.", imgMessage.ERROR); return;};
						if (!checkJoinGroups(group)){ 
							//showMessageBox("The selected record(s) cannot be added to the specified group as such will violate the sequential ordering of the group numbers.  Please try grouping a different set of records.", imgMessage.ERROR); replaced by: Nica 04.24.2013
							showWaitingMessageBox("The selected record(s) cannot be grouped into one as such will violate the sequential ordering of the group numbers. " +
						              "Please try grouping a different set of records.", imgMessage.ERROR, unTaggedTableGridCheckBox);
							hideOverlay();
							return;
						}else{
							changeGrouping(group);
						}
						clearGroup();
						hideOverlay();
					}catch(e){
						showErrorMessage("startLOV - onOk", e);
					}
				}
				observeOverlayLovRow(id);
				observeOverlayLovButton(id, onOk);
				observeOverlayLovFilter(id, objArray);
			}
			$("filterTextLOV").focus();
		}catch(e){
			showErrorMessage("startLOV", e);
		}
	}	
	
	function joinExistingGroup(){
		try{
			var objArray = [];
			for (var i=0; i<tableGrid.rows.length; i++){
				var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
				var itemGrp = tableGrid.rows[i][tableGrid.getColumnIndex('itemGrp')];
				var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
				var distSeqNo = tableGrid.rows[i][tableGrid.getColumnIndex('distSeqNo')];
				var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
				if (Number($F("txtC080DistNo")) == distNo && itemGrp == selItemGrp && nvl(deleted,"") == ""){
					if (objArray.toString().indexOf(distSeqNo) == -1) objArray.push(distSeqNo);
				}
			}	
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
					var itemGrp = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('itemGrp')];
					var divCtrId = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')];
					var distSeqNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distSeqNo')];
					var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
					if (Number($F("txtC080DistNo")) == distNo && itemGrp == selItemGrp && nvl(deleted,"") == ""){
						if (objArray.toString().indexOf(distSeqNo) == -1) objArray.push(distSeqNo);
					}
				}
			}		
			startLOV("GIUWS001-Join", "Join Group?", objArray.sort(), 340);	
		}catch(e){
			showErrorMessage("joinExistingGroup", e);
		}
	}	

	function regroupCurrentSelection(){
		try{
			var arr = [];
			var nextDistSeqNo = 0;
			var checkedCount = 0;
			var selectedArr = [];
			var firstDistSeqNo = "";
			for (var i=0; i<tableGrid.rows.length; i++){
				var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
				var distSeqNo = Number(tableGrid.rows[i][tableGrid.getColumnIndex('distSeqNo')]);
				var itemGrp = tableGrid.rows[i][tableGrid.getColumnIndex('itemGrp')];
				var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
				if (Number($F("txtC080DistNo")) == distNo && nvl(deleted,"") == ""){
					arr.push(distSeqNo);
					if (distSeqNo > nextDistSeqNo){
						nextDistSeqNo = distSeqNo;
					}	
					if (itemGrp == selItemGrp && tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')]){
						firstDistSeqNo = distSeqNo;
						checkedCount++;
						selectedArr.push(distSeqNo);
					}				
				}	
			}	
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
					var distSeqNo = Number(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distSeqNo')]);
					var itemGrp = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('itemGrp')];
					var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
					if (Number($F("txtC080DistNo")) == distNo && nvl(deleted,"") == ""){
						arr.push(distSeqNo);
						if (distSeqNo > nextDistSeqNo){
							nextDistSeqNo = distSeqNo;
						}	
						if (itemGrp == selItemGrp && tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')]){
							firstDistSeqNo = distSeqNo;
							checkedCount++;
							selectedArr.push(distSeqNo);
						}				
					}
				}
			}		
			
			nextDistSeqNo = nextDistSeqNo + 1;
			var origNextDistSeqNo = nextDistSeqNo;
			arr.sort();
			selectedArr.sort();

			var countSameDistSeqNo = 0;
			for (var i=0; i<tableGrid.rows.length; i++){
				var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
				var distSeqNo = Number(tableGrid.rows[i][tableGrid.getColumnIndex('distSeqNo')]);
				var itemGrp = tableGrid.rows[i][tableGrid.getColumnIndex('itemGrp')];
				var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
				if (Number($F("txtC080DistNo")) == distNo && nvl(deleted,"") == ""){
					if (firstDistSeqNo == distSeqNo) countSameDistSeqNo++;
				}	
			}
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
					var distSeqNo = Number(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distSeqNo')]);
					var itemGrp = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('itemGrp')];
					var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
					if (Number($F("txtC080DistNo")) == distNo && nvl(deleted,"") == ""){
						if (firstDistSeqNo == distSeqNo) countSameDistSeqNo++;
					}	
				}
			}		
			
			if (checkedCount>1){
				if (countSameDistSeqNo>1){
					nextDistSeqNo = selectedArr.last();
					if (checkJoinGroups(origNextDistSeqNo)) nextDistSeqNo = origNextDistSeqNo;
				}
				if (selectedArr.toString().indexOf((nextDistSeqNo-1)) != -1){ //if highest exist in selected item
					nextDistSeqNo = selectedArr[0];
					if (checkJoinGroups(selectedArr.last())) nextDistSeqNo = selectedArr.last();
					if (checkJoinGroups(origNextDistSeqNo)) nextDistSeqNo = origNextDistSeqNo;
					if (selectedArr.toString().indexOf(arr[0]) != -1){
						if (checkJoinGroups(origNextDistSeqNo)) nextDistSeqNo = origNextDistSeqNo;
					}	
				}else{
					if (countSameDistSeqNo == 1){
						nextDistSeqNo = selectedArr[0];
					}else{
						if (checkJoinGroups(origNextDistSeqNo)) nextDistSeqNo = origNextDistSeqNo;
					}
				}	
			}else{
				if (countSameDistSeqNo==1){
					nextDistSeqNo = firstDistSeqNo;
				}		
			}	

			if (!checkJoinGroups(nextDistSeqNo)){
				//showMessageBox("The selected record(s) cannot be grouped into one as such will violate the sequential ordering of the group numbers.  Please try grouping a different set of records.", imgMessage.ERROR); replaced by: Nica 04.24.2013
				showWaitingMessageBox("The selected record(s) cannot be grouped into one as such will violate the sequential ordering of the group numbers. " +
						              "Please try grouping a different set of records.", imgMessage.ERROR, unTaggedTableGridCheckBox);
				return;
			}else{
				changeGrouping(nextDistSeqNo);
				clearGroup();
			}		
		}catch(e){
			showErrorMessage("regroupCurrentSelection", e);
		}
	}
	
	function unTaggedTableGridCheckBox(){ // added by: Nica 04.24.2013
		for (var i=0; i<tableGrid.rows.length; i++){
			var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
			var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
			var recordStatus = tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')];
			var deleted = tableGrid.rows[i][tableGrid.getColumnIndex('deleted')];
			if ($F("txtC080DistNo") == distNo && recordStatus && nvl(deleted,"") == ""){
				$('mtgInput'+tableGrid._mtgId+'_0,'+divCtrId).checked = false;
				tableGrid.rows[i][tableGrid.getColumnIndex('recordStatus')] = "";
				
			}
		}

		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
				var divCtrId = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')];
				var recordStatus = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')];
				var deleted = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')];
				if ($F("txtC080DistNo") == distNo && recordStatus && nvl(deleted,"") == ""){
					$('mtgInput'+tableGrid._mtgId+'_0,'+divCtrId).checked = false;
					tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('recordStatus')] = "";
					
				}
			}
		}
	}
	
	function postedBinderExists(){ //edgar 11/25/2014 (base on Sir Jom's codes): Check for PAR's posted binder.
		try{
			var exists = false;
			new Ajax.Request(contextPath+"/GIPIPARListController",{
				parameters:{
					action: "checkForPostedBinder",
					parId : globalParId,
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							exists = true;
						}
					}
				}
			});
			return exists;
		} catch(e){
			showErrorMessage("postedBinderExists", e);
		}
	}
	
	$("btnJoinGroup").observe("click", function(){
		if (postedBinderExists()){ //added edgar 11/25/2014 : for checking posted binders
			showWaitingMessageBox('Cannot recreate or regrouped items for PAR with posted binder(s).', 'I', function(){
				// in case functions are to be added.
			});	
			return false;
		}		
		joinExistingGroup();
	});

	$("btnNewGroup").observe("click", function(){
		if (postedBinderExists()){ //added edgar 11/25/2014 : for checking posted binders
			showWaitingMessageBox('Cannot recreate or regrouped items for PAR with posted binder(s).', 'I', function(){
				// in case functions are to be added.
			});	
			return false;
		}
		regroupCurrentSelection();
	});

	function deleteExistingItems(){
		try{
			for (var i=0; i<tableGrid.rows.length; i++){
				var distNo = tableGrid.rows[i][tableGrid.getColumnIndex('distNo')];
				if (Number($F("txtC080DistNo")) == distNo){
					tableGrid.rows[i][tableGrid.getColumnIndex('deleted')] = "Y";
				}
			}
			for (var i=0; i<tableGrid.newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					var distNo = tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('distNo')];
					if (Number($F("txtC080DistNo")) == distNo){
						tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('deleted')] = "Y";
					}
				}
			}
		}catch(e){
			showErrorMessage("deleteExistingItems", e);
		}
	}
	
	function createItems(){
		try{
			var ok = true;
			var noticeMsg = $("btnCreateItems").value == "Recreate Items" ? "Recreating" :"Creating";
			
			var parameters = {};
			parameters.action = "createItems2";
			parameters.distNo = objUW.hidObjGIUWS001.selectedGIUWPolDist.distNo;
			parameters.parId = (isPack != "Y") ? globalParId : objUW.hidObjGIUWS001.selectedGIUWPolDist.parId;
			parameters.lineCd = globalLineCd;
			parameters.sublineCd = globalSublineCd;
			parameters.issCd = globalIssCd;
			parameters.packPolFlag = globalPackPolFlag;
			parameters.polFlag = globalPolFlag;
			parameters.parType = globalParType;
			parameters.itemGrp = objUW.hidObjGIUWS001.selectedGIUWPolDist.itemGrp;
			parameters.takeupSeqNo = objUW.hidObjGIUWS001.selectedGIUWPolDist.takeupSeqNo;
			parameters.label = $("btnCreateItems").value;
			
			new Ajax.Request(contextPath+"/GIUWPolDistController",{
				parameters:parameters,
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice(noticeMsg+" Items, please wait...");
				},
				onComplete: function(response){
					hideNotice();						 
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (res.message == ""){
							objUW.hidObjGIUWS001.recreateArr.push(parameters);
							var rows = res.newItems;

							//update Main List
							var content = prepareList(rows);
							var index = getSelectedRowIdInTable("distListingDiv", "rowSetUpGroupsDist");
							$("rowSetUpGroupsDist"+index).update(content);  
							objUW.hidObjGIUWS001.GIUWPolDist[index] = rows;
							objUW.hidObjGIUWS001.GIUWPolDist[index].divCtrId = index;
							objUW.hidObjGIUWS001.GIUWPolDist[index].recordStatus = 0;
							
							//Groups
							clearGroup();
							deleteExistingItems();
							tableGrid.deleteAnyRows('distNo', objUW.hidObjGIUWS001.selectedGIUWPolDist.distNo); 
							tableGrid.createNewRows(rows.giuwWitemds.reverse());
							disableButton("btnNewGroup");
							disableButton("btnJoinGroup");
							$("btnCreateItems").value = "Recreate Items";
							changeTag=0;
							showWaitingMessageBox(noticeMsg+" Items complete.", imgMessage.SUCCESS, showSetUpGroupsForPrelimDist);
							checkTablGrid();
							hideNotice();
						}	
					}else{
						ok = false;
						customShowMessageBox(res.message, imgMessage.ERROR, "btnCreateItems");
						return false;
					}	
				}
			});	
			return ok;
		}catch (e) {
			showErrorMessage("createItems", e);
		}	
	}	
	
	$("btnCreateItems").observe("click", function(){
		if (postedBinderExists()){ //added edgar 11/25/2014 : for checking posted binders
			showWaitingMessageBox('Cannot recreate or regrouped items for PAR with posted binder(s).', 'I', function(){
				// in case functions are to be added.
			});	
			return false;
		}
		if (!compareGipiItemItmperil()) return false;
		if ($("btnCreateItems").value == "Recreate Items"){
			showConfirmBox("Recreate Items", "All pre-existing data associated with this distribution record will be deleted. Are you sure you want to continue?", 
					"Yes", "No", createItems, "");
		}else{
			createItems();
		}		
	});

	function saveSetUp(refresh){
		/*var self = tableGrid;
		self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
    	if (self.getModifiedRows().length == 0 && self.getNewRowsAdded().length == 0 && self.getDeletedRows().length == 0){showMessageBox("No changes to save.", imgMessage.INFO); return false;} //to check if changes exist 
    	if (!self.preCommit()){ return false; } //to validate all required field before saving
    	var ok = true;
    	if (self.options.toolbar.onSave) {
    		ok = self.options.toolbar.onSave.call();
    	}
    	if ((ok || ok==undefined) && nvl(refresh,false)){
    		if (self.options.toolbar.postSave) {
        		self.options.toolbar.postSave.call();
        	}
    	}	
    	self.keys._nCurrentFocus = null;*/ // replaced by: Nica 04.24.2013 - to prompt confirmation message before saving
		
    	showConfirmBox("Confirmation", "All data associated with this distribution record will be recreated. " +
			    "Are you sure you want to continue?", "Yes", "No", 
			    function(){
					var self = tableGrid;
					self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
			    	if (self.getModifiedRows().length == 0 && self.getNewRowsAdded().length == 0 && self.getDeletedRows().length == 0){showMessageBox("No changes to save.", imgMessage.INFO); return false;} //to check if changes exist 
			    	if (!self.preCommit()){ return false; } //to validate all required field before saving
			    	var ok = true;
			    	if (self.options.toolbar.onSave) {
			    		ok = self.options.toolbar.onSave.call();
			    	}
			    	if ((ok || ok==undefined) && nvl(refresh,false)){
			    		if (self.options.toolbar.postSave) {
			        		self.options.toolbar.postSave.call();
			        	}
			    	}	
			    	self.keys._nCurrentFocus = null;
				}, "");
    	
	}

	// parlist observer (emman 07.14.2011)
	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setPackParPolicyObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}

	function setPackParPolicyObserver(row) {
		try {
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){
					($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");

					($("distListingDiv").childElements()).invoke("hide");
					($$("div#distListingDiv div[parId='"+ row.readAttribute("parId") +"']")).invoke("show");
					
					// set global vars
					globalLineCd = row.readAttribute("lineCd");
					globalSublineCd = row.readAttribute("sublineCd");
					globalIssCd = row.readAttribute("issCd");
					globalPolFlag = row.readAttribute("polFlag");
					globalPackPolFlag = row.readAttribute("packPolFlag");

					resizeTableBasedOnVisibleRows("distListingTableDiv", "distListingDiv");
					supplyDist(null);
					deselectRows("distListingDiv", "rowSetUpGroupsDist");

					// set global variables in pack par parameter form (emman 07.15.2011)
					//$("globalParId").value = row.readAttribute("parId");
					//$("globalLineCd").value = globalLineCd; commented by: Nica 09.10.2012
					$("initialParId").value = row.readAttribute("parId"); //andrew - 10.03.2011
					$("initialLineCd").value = globalLineCd; //andrew - 10.03.2011
				} else {
					($("distListingDiv").childElements()).invoke("hide");
					resizeTableBasedOnVisibleRows("distListingTableDiv", "distListingDiv");
					supplyDist(null);
					deselectRows("distListingDiv", "rowSetUpGroupsDist");

					// reset global vars
					globalLineCd = null;
					globalSublineCd = null;
					globalIssCd = null;
					globalPolFlag = null;
					globalPackPolFlag = null;

					// reset global variables in pack par parameter form (emman 07.15.2011)
					//$("globalParId").value = "";
					//$("globalLineCd").value = "";
				}
			});
		} catch(e){
			showErrorMessage("setPackParPolicyRowObserver", e);
		}
	}

	if (isPack == "Y") {
		objGIPIParList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
		$("parNo").value = "${packParNo}";
		//$("assuredName").value = "${packAssdName }"; replaced by: Nica 04.24.2013 to add unescapeHTML2
		$("assuredName").value = unescapeHTML2("${packAssdName }");
		showPackagePARPolicyList(objGIPIParList);
		loadPackageParPolicyRowObserver();
	}
	
	observeReloadForm("reloadForm", showSetUpGroupsForPrelimDist);
	observeCancelForm("btnCancel", saveSetUp, (isPack == "Y") ? showPackParListing : showParListing);
	observeSaveForm("btnSave", function(){saveSetUp(true);});
	
	clearForm();
	changeTag = 0;
	initializeChangeTagBehavior(saveSetUp);
	setDocumentTitle("Set - Up Groups for Distribution (Preliminary)");
	window.scrollTo(0,0); 	
	hideNotice("");
}catch (e) {
	showErrorMessage("set-up groups", e);
}
</script>		