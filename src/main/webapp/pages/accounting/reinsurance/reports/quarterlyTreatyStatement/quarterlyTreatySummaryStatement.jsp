<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="qrtrlyTrtySummaryMainDiv" name="qrtrlyTrtySummaryMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Quarterly Treaty Summary Statement</label>
	   	</div>
	</div>
	
	<div id="treatyDiv" name="treatyDiv" class="sectionDiv">
		<div id="treatyTGDiv" namae="treatyTGDiv" style="margin: 10px 10px 10px 10px; width: 898px; height:330px;"></div>
	</div>
	
	<div id="riDiv" name="riDiv" class="sectionDiv">
		<div id="treatyPanelTGDiv" name="treatyPanelTGDiv" style="margin: 10px 10px 0 10px; width: 898px; height:330px;"></div>
	
		<div id="textFieldDiv" name="textFieldDiv">
			<div id="leftSideDiv" name="leftSideDiv" style="margin: 10px 10px 10px 10px; float:left;">
				<table>
					<tr>
						<td class="rightAligned">Last Extract</td>
						<td>
							<input type="text" id="txtExtractUserId" name="txtExtractUserId" style="width: 100px; margin-left: 5px;" readonly="readonly" tabindex="101" />
							<input type="text" id="txtLastExtract" name="txtLastExtract" style="width: 100px; margin-left: 2px;" readonly="readonly" tabindex="102" />
						</td>
					</tr>
				</table>
			</div>
			
			<div id="rightSideDiv" name="rightSideDiv" style="margin: 10px 10px 10px 280px; float:left;">
				<table>
					<tr>
						<td class="rightAligned">Last Update</td>
						<td>
							<input type="text" id="txtUserId" name="txtUserId" style="width: 100px; margin-left: 5px;" readonly="readonly" tabindex="103" />
							<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 100px; margin-left: 2px;" readonly="readonly" tabindex="104" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="buttonsDiv" style="margin: 10px 10px 30px 10px;">
			<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width:120px;" />
			<input type="button" class="button" id="btnCompute" name="btnCompute" value="Compute" style="width:120px;" />
			<input type="button" class="button" id="btnPost" name="btnPost" value="Post" style="width:120px;" />
			<input type="button" class="button" id="btnView" name="btnView" value="View" style="width:120px;" />
			<input type="button" class="button" id="btnReports" name="btnReports" value="Reports" style="width:120px;" />
		</div>
	</div>

</div>

<script type="text/javascript">
	objTreaty.currentUserId = ('${userId}');
	
	var selectedComputeTagList = [];
	
	try {
		objTreaty.treatyTableGrid = JSON.parse('${treatyList}');
		objTreaty.treatyRows = objTreaty.treatyTableGrid.rows || [];
		objTreaty.treatySelectedRow = null;
		
		treatyTableModel = {
				url: contextPath+"/GIACReinsuranceReportsController?action=showQuarterlyTreatyStatement&refresh=1",
				id: 1,
				options: {
					id: 1,
		          	height: '310px',
		          	width: '900px',
		          	hideColumnChildTitle: true,
		          	onCellFocus: function(element, value, x, y, id){
		          		objTreaty.treatySelectedRow = treatyTableGrid.geniisysRows[y];
		          		refreshChildTableGrid(objTreaty.treatySelectedRow);
		          		treatyTableGrid.keys.removeFocus(treatyTableGrid.keys._nCurrentFocus, true);
		          		treatyTableGrid.keys.releaseKeys();
		            },
		            onRemoveRowFocus: function(){
		            	objTreaty.treatySelectedRow = null;
		            	refreshChildTableGrid(objTreaty.treatySelectedRow);
		            	treatyTableGrid.keys.removeFocus(treatyTableGrid.keys._nCurrentFocus, true);
		            	treatyTableGrid.keys.releaseKeys();
		            },
		            toolbar: {
		            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            	onRefresh: function(){
		            		objTreaty.treatySelectedRow = null;
		            		refreshChildTableGrid(objTreaty.treatySelectedRow);
		            	},
		            	onFilter: function(){
		            		objTreaty.treatySelectedRow = null;
		            		refreshChildTableGrid(objTreaty.treatySelectedRow);
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
							{	id: 'qtr',
								title: 'Quarter',
								width: '0',
								visible: false
							},
							{	id: 'lineCd treatyYy shareCd treatyName',
								title: 'Treaty',
								width: 690,
								sortable: true,
								children: [
											{
												id: 'lineCd',
												title: 'Line Cd',
												width: 50,
												filterOption: true
											},
											{
												id: 'treatyYy',
												title: 'Treaty Yy',
												width: 50,
												align: 'right',
												filterOption: true,
												filterOptionType: 'number',
												renderer: function(value){
													return formatNumberDigits(value, 2);
												}
											},
											{
												id: 'shareCd',
												title: 'Share Cd',
												width: 50,
												align: 'right',
												filterOption: true,
												filterOptionType: 'number',
												renderer: function(value){
													return formatNumberDigits(value, 3);
												}
											},
											{
												id: 'treatyName',
												title: 'Treaty Name',
												width: 550,
												filterOption: true					
											}
								]
							},
							{	id: 'year',
								title: 'Year',
								width: '100px',
								align: 'right',
								titleAlign: 'right',
								filterOption: true,
								filterOptionType: 'number'
							},
							{	id: 'qtrStr',
								title: 'Quarter',
								width: '75px',
								filterOption: true
							}
							],
				rows: objTreaty.treatyRows
			};
			treatyTableGrid = new MyTableGrid(treatyTableModel);
			treatyTableGrid.pager = objTreaty.treatyTableGrid;
			treatyTableGrid.render('treatyTGDiv');
	} catch(e){
		showErrorMessage("treatyTableGrid: ", e);
	}
	
	//if(objTreaty.treatySelectedRow == null){
		try {
			var treatyPanelSelectedRow = null;
			var treatyPanelTableGrid = JSON.parse('${treatyPanelList}');
			var treatyPanelRows = treatyPanelTableGrid.rows || [];
			
			treatyPanelTableModel = {
					url: contextPath + "/GIACReinsuranceReportsController?action=getTreatyPanelList&refresh=1"
									 + "&lineCd="	+ (objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.lineCd, "") : "")
									 + "&shareCd="	+ (objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.shareCd, "") : "")
									 + "&treatyYy="	+ (objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.treatyYy, "") : "")
									 + "&year="		+ (objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.year, "") : "")
									 + "&qtr="		+ (objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.qtr, "") : ""),
					id: 2,
					options: {
						id: 2,
			          	height: '310px',
			          	width: '900px',
			          	hideColumnChildTitle: true,
			          	onCellFocus: function(element, value, x, y, id){
			          		
			          		var mtgId = treatyPanelTG._mtgId;
			          		if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
			          			treatyPanelSelectedRow = treatyPanelTG.geniisysRows[y];
			          			populateFields(treatyPanelSelectedRow);
							}
			          		
			          		/*treatyPanelTG.keys.removeFocus(treatyPanelTG.keys._nCurrentFocus, true);
			          		treatyPanelTG.keys.releaseKeys();*/
			            },
			            onRemoveRowFocus: function(){
			            	treatyPanelSelectedRow = null;
			            	populateFields(treatyPanelSelectedRow);
			            	treatyPanelTG.keys.removeFocus(treatyPanelTG.keys._nCurrentFocus, true);
			            	treatyPanelTG.keys.releaseKeys();
			            },
			            onSort: function(){
			            	selectedComputeTagList = [];
		            		treatyPanelTG.onRemoveRowFocus();
			            },
			            toolbar: {
			            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],	
			            	onRefresh: function(){
			            		treatyPanelTG.onRemoveRowFocus();
			            		selectedComputeTagList = [];			            		
			            	},
			            	onFilter: function(){
			            		treatyPanelTG.onRemoveRowFocus();
			            		selectedComputeTagList = [];			            		
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
								{	id: 'finalTag',
									title: '&nbsp;&nbsp;F',
									width: '30px',
									align: 'center',
									titleAlign: 'center',
									sortable: true,
								    editable: false,
									defaultValue: false,
									otherValue: false,
								    editor: new MyTableGrid.CellCheckbox({
							            getValueOf: function(value){
						            		if (value){
												return "Y";
						            		} else {
												return "N";	
						            		}	
						            	}
								    })
								},
								{	id: 'computeTag',
									title: '&nbsp;&nbsp;C',
									width: '30px',
									align: 'center',
									titleAlign: 'center',
									sortable: false,
								    editable: true,
									defaultValue: false,
									otherValue: false,
								    editor: new MyTableGrid.CellCheckbox({
							            getValueOf: function(value){
						            		if (value){
												return "Y";
						            		} else {
												return "N";	
						            		}	
						            	},
									    onClick: function(value, checked){
									    	var newValue = checked;
									    	if(nvl(treatyPanelSelectedRow.finalTag, "N") == "Y" && value == "Y"){
									    		showMessageBox("Record has already been posted.", "I");
									    		newValue = false;
									    	} else if(nvl(treatyPanelSelectedRow.finalTag, "N") == "N"){
									    		var row = { "lineCd" : objTreaty.treatySelectedRow.lineCd, "year" : objTreaty.treatySelectedRow.year, "qtr" : objTreaty.treatySelectedRow.qtr,
							    							"shareCd" :  objTreaty.treatySelectedRow.shareCd, "treatyYy" : objTreaty.treatySelectedRow.treatyYy, "riCd" : treatyPanelSelectedRow.riCd };
									    		
									    		if(value == "N"){ //remove from list
									    			removeSelectedCTag(row);
									    		} else if(value == "Y"){ //add to list
									    			changeTag = 1;
									    			insertSelectedCTag(row);
									    		}
									    	}
									    	tagSelectedRow(newValue, treatyPanelTG._mtgId, treatyPanelTG.getColumnIndex("computeTag"), treatyPanelSelectedRow.divCtrId);
									    }
								    })
								},
								{	id: 'riCd',
									title: 'RI Code',
									width: '80px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number'
								},
								{	id: 'riName',
									title: 'Reinsurer Name',
									width: '495px',
									filterOption: true
								},
								{	id: 'endingBalAmt',
									title: 'Ending Balance',
									width: '240px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return nvl(formatCurrency(value), "");
									}
								}
								],
					rows: treatyPanelRows
				};
				treatyPanelTG = new MyTableGrid(treatyPanelTableModel);
				treatyPanelTG.pager = treatyPanelTableGrid;
				treatyPanelTG.render('treatyPanelTGDiv');
				treatyPanelTG.afterRender = function(){
					treatyPanelRows = treatyPanelTG.geniisysRows;
					
					var currRow = selectedComputeTagList;
					for(var i=0; i<currRow.length; i++){
						for(var j=0; j<treatyPanelRows.length; j++){
							if(currRow[i].lineCd == treatyPanelRows[j].lineCd && currRow[i].shareCd == treatyPanelRows[j].shareCd &&
									currRow[i].treatyYy == treatyPanelRows[j].treatyYy && currRow[i].riCd == treatyPanelRows[j].riCd &&
									currRow[i].year == treatyPanelRows[j].year && currRow[i].qtr == treatyPanelRows[j].qtr){
								$('mtgInput' + treatyPanelTG._mtgId + '_' + treatyPanelTG.getColumnIndex("computeTag") + ',' + j).checked = true;
							}
						}
					}
				};
		} catch(e){
			showErrorMessage("treatyPanelTG: ", e);
		}
	//}
	
	function refreshChildTableGrid(row){
		treatyPanelTG.url = contextPath+"/GIACReinsuranceReportsController?action=getTreatyPanelList&refresh=1"
						+ "&lineCd="	+ (row != null ? nvl(row.lineCd, "") : "")
						+ "&shareCd="	+ (row != null ? nvl(row.shareCd, "") : "")
						+ "&treatyYy="	+ (row != null ? nvl(row.treatyYy, "") : "")
						+ "&year="		+ (row != null ? nvl(row.year, "") : "")
						+ "&qtr="		+ (row != null ? nvl(row.qtr, "") : "");
		treatyPanelTG.refresh();
		selectedComputeTagList = [];
	}
	
	function populateFields(row){
		$("txtExtractUserId").value = row != null ? nvl(row.extUserId, "") : "";
		$("txtLastExtract").value 	= row != null ? nvl(row.lastExtract, "") : "";
		$("txtUserId").value 		= row != null ? nvl(row.userId, "") : "";
		$("txtLastUpdate").value 	= row != null ? nvl(row.lastUpdate, "") : "";
	}
	
	//checks/unchecks checkbox 'C' in the tablegrid
	function tagSelectedRow(isTagged, mtgId, x, y){
		$('mtgInput' + mtgId + '_' + x + ',' + y).checked = isTagged;
		isTagged ? $('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell') : $('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');		
	}
	
	function insertSelectedCTag(row){
		var exists = false;
		var currRow = selectedComputeTagList;
		for(var i=0; i<currRow.length; i++){
			if(currRow[i].lineCd == row.lineCd && currRow[i].treatyYy == row.treatyYy && 
					currRow[i].shareCd == row.shareCd && currRow[i].riCd == row.riCd && 
					currRow[i].year == row.year && currRow[i].qtr == row.qtr){
				exists = true;
				break;
			}
		}
		
		if(!exists){
			selectedComputeTagList.push(row);
		}
	}
	
	function removeSelectedCTag(row){
		var currRow = selectedComputeTagList;
		for(var i=0; i<currRow.length; i++){
			if(currRow[i].lineCd == row.lineCd && currRow[i].treatyYy == row.treatyYy && 
					currRow[i].shareCd == row.shareCd && currRow[i].riCd == row.riCd && 
					currRow[i].year == row.year && currRow[i].qtr == row.qtr){
				selectedComputeTagList.splice(i,1);
				break;
			}
		}
		if(selectedComputeTagList.length){
			changeTag = 0;
		}
	}
	
	function executeBtnAction(btnId, action, onCreateNotice, onCompleteNotice, noSelectedNotice){
		if(selectedComputeTagList.length == 0){
			showMessageBox(noSelectedNotice, "I");
		} else {
			try {
				var objParams = new Object();
				objParams.setRows = selectedComputeTagList;
				new Ajax.Request(contextPath + "/GIACReinsuranceReportsController?action="+action,{
					method: "POST",
					parameters : {
						objParams: JSON.stringify(objParams)						
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice(onCreateNotice);
					},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							if(response.responseText == "SUCCESS"){
								showWaitingMessageBox(onCompleteNotice,"I", function(){
									changeTag = 0;
									treatyPanelTG.refresh();
									selectedComputeTagList = [];
								});
							}
						}
					}
				});
			} catch(e){
				showErrorMessage(btnId+": ",e);
			}
		}
	}
	
	$("btnExtract").observe("click", function(){
		if(objTreaty.treatySelectedRow != null){
			extractOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
				urlParameters : { action : "showExtractOverlay" },
				title : "Extract",
				height : 235,
				width : 610,
				urlContent : true,
				draggable : true,
				showNotice : true,
				noticeMessage : "Loading, please wait..."
			});
		} else {
			showMessageBox("Please select a record first.", "I");
		}
	});
	
	$("btnCompute").observe("click", function(){
		executeBtnAction("btnCompute", "computeTaggedRecords", "Processing record(s), please wait...", "Computation complete!", "You have not yet tagged any record for computation.");		
	});
	
	$("btnPost").observe("click", function(){
		executeBtnAction("btnPost", "postTaggedRecords", "Processing record(s), please wait...", "Posting complete!", "You have not yet tagged any record for posting.");
	});
	
	$("btnView").observe("click", function(){
		if(treatyPanelSelectedRow != null){
			try {
				new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
					method: "POST",
					parameters : {
						action	: "checkBeforeView",
						lineCd	: nvl(objTreaty.treatySelectedRow.lineCd, ""),
						shareCd	: nvl(objTreaty.treatySelectedRow.shareCd, ""),
						treatyYy: nvl(objTreaty.treatySelectedRow.treatyYy, ""),
						riCd	: nvl(treatyPanelSelectedRow.riCd, ""),
						year	: nvl(objTreaty.treatySelectedRow.year, ""),
						qtr		: nvl(objTreaty.treatySelectedRow.qtr, "")
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice("Loading, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var resp = JSON.parse(response.responseText);
							if(nvl(resp.exist, "") == ""){
								showMessageBox("No record of Quarter Summary yet for this RI-" + resp.riCd+".", "I");
							} else {
								//punta sa overlay
								treatyStatementOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
									urlParameters : { 
										action  : "showTreatyStatementOverlay",
										lineCd	: nvl(objTreaty.treatySelectedRow.lineCd, ""),
										shareCd	: nvl(objTreaty.treatySelectedRow.shareCd, ""),
										treatyYy: nvl(objTreaty.treatySelectedRow.treatyYy, ""),
										riCd	: nvl(treatyPanelSelectedRow.riCd, ""),
										year	: nvl(objTreaty.treatySelectedRow.year, ""),
										qtr		: nvl(objTreaty.treatySelectedRow.qtr, "")
									},
									title : "Treaty Statement",
									height : 485,
									width : 900,
									urlContent : true,
									draggable : true,
									showNotice : true,
									noticeMessage : "Loading, please wait..."
								});
							}
						}
					}
				});
			} catch(e){
				showErrorMessage("btnView (checkBeforeView) : ",e);
			}			
		} else {
			showMessageBox("Please select a record first.", "I");
		}
	});
	
	$("btnReports").observe("click", function(){
		printQTSReportsOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "getReportList",
				fromPage	: "quarterlyTreatySummary"
			},
			title : "List of Reports",
			height : 310,
			width : 460,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});		
	});
	
	setModuleId("GIACS220");
	setDocumentTitle("Quarterly Treaty Summary Statement");
	initializeAll();
	populateFields(null);
</script>