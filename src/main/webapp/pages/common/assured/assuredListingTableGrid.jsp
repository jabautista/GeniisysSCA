<!-- 
Remarks: Assured Listing TableGrid
Date : 01-05-2012
Developer: Bonok 
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="assuredListingTGMainDiv" name="assuredListingTGMainDiv" style="float: left; width: 100%;">
	<div id="assuredListingTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="assuredListingTableGridExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="assuredListingDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Assured Listing</label>
		   	</div>
		</div>
		<div class="sectionDiv" id="assuredListingSectionDiv" style="">
			<div id="assuredListingTableDiv" style="padding: 10px;">
				<div id="assuredListingTable" style="height: 306px"></div>
			</div>
			<div style="margin: 10px; margin-top: 20px; text-align: center;" align="center">
				<input type="button" class="button" id="btnListAll" value="List All" style="width: 150px;">
				<input type="button" class="button disabledButton" id="btnIntmDetails" value="Intermediary Details" style="width: 150px;">
			</div>
	   	</div>
	</div>
</div>

<div id="assuredTGDiv" name="assuredTGDiv" style="margin-top: 1px; display: none;">
</div>

<script type="text/javascript">
	setModuleId("GIISS006");
	setDocumentTitle("Assured Listing");
	selectedIndex = -1;
	var userId = '${userId}';
	var withAccessToGiiss006b = false;
	
	var objTGAssured = new Object();
	//objTGAssured.objTGAssuredListing = JSON.parse('${assuredListingTableGrid}'.replace(/\\/g, '\\\\'));
	//objTGAssured.objTGAssuredList = objTGAssured.objTGAssuredListing.rows || [];
	
	var assuredListingTable = {
			url: contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}&objFilter={strAssdNo : -1}",
			options: {
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
					var mtgId = assuredListTableGrid._mtgId;
					selectedIndex = -1;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						selectedIndex = y;
					}
					
					if(assuredListTableGrid.geniisysRows[y].intmNo != null){
						enableButton("btnIntmDetails");
					} else {
						disableButton("btnIntmDetails");
					}
					
					observeChangeTagInTableGrid(assuredListTableGrid);
					assuredListTableGrid.keys.removeFocus(assuredListTableGrid.keys._nCurrentFocus, true);
					assuredListTableGrid.keys.releaseKeys();
				},
				onCellBlur: function(){
					observeChangeTagInTableGrid(assuredListTableGrid);
				},
				onRemoveRowFocus: function(){
					selectedIndex = -1;
					disableButton("btnIntmDetails");
				},
				onRowDoubleClick: function(y){
					if (withAccessToGiiss006b) { //angelo 04.04.2014 added checking if user has access
						var row = assuredListTableGrid.geniisysRows[y];
						assuredListTableGrid.keys.releaseKeys();
						showAssuredMaintenance(row.assdNo); 
					} else {
						showMessageBox("You are not allowed to access this module.", "E");
					}
				},
				onSort: function(){
					selectedIndex = -1;
				},
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.PRINT_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter : function(){
						if($F("mtgFilterText"+assuredListTableGrid._mtgId) == ""){
							assuredListTableGrid.url = contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}&objFilter={strAssdNo : -1}";	
						} else {
							assuredListTableGrid.url = contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}";
						}
						selectedIndex = -1;
					},
					onAdd: function(){
						if (withAccessToGiiss006b) {
							assuredListTableGrid.keys.removeFocus(assuredListTableGrid.keys._nCurrentFocus, true);
							assuredListTableGrid.keys.releaseKeys();
							maintainAssuredTG("assuredListingTGMainDiv", "");
						} else {
							showMessageBox("You are not allowed to access this module.", "E");
							return false;
						}
					},
					onEdit: function(){
						if (withAccessToGiiss006b) {
							if(selectedIndex >= 0){
								var row = assuredListTableGrid.geniisysRows[selectedIndex];
								assuredListTableGrid.keys.removeFocus(assuredListTableGrid.keys._nCurrentFocus, true);
								assuredListTableGrid.keys.releaseKeys();
								showAssuredMaintenance(row.assdNo);
								
							}else{
								showMessageBox("Please select an assured first.", imgMessage.ERROR);
							}
						} else {
							showMessageBox("You are not allowed to access this module.", "E");
						}
					},
					onDelete: function(){
						if(selectedIndex >= 0){
							var row = assuredListTableGrid.geniisysRows[selectedIndex];
							showConfirmBox("Delete assured confirmation", "This will delete all information pertaining to this Assured.  Do you want to continue?", 
									"Yes", "No", function(){
													deleteAssuredTG(row.assdNo);
												 }, "");
						}else{
							showMessageBox("Please select an assured first.", imgMessage.ERROR);
						}
					},
					onPrint: function(){
						showGenericPrintDialog("Print Assured Listing", printGIPIR800);
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
			    	id: "activeTag",
			    	title: "&nbsp;&nbsp;A",
			    	altTitle: "Active Tag",
			    	width: '30px',
			    	titleAlign: 'center',
			    	align: 'center',
			    	filterOption: true,
			    	filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
			    },
                {
			    	id : "corporateTag",
					title: "Corporate Tag",
					width: '95px',
					titleAlign : 'left',
					align: 'left',
					filterOption: true
			    },
			    {
					id: 'assdNo',					
			   		width: '0',
			   		visible: false
				},
			    {
					id: 'strAssdNo',
					title: "Assured No.",
			   		width: '90px',
			   		titleAlign: 'right',
			   		align: 'right',
			   		filterOption: true,
			   		filterOptionType: 'integerNoNegative'
				},
			    {
			   		id: "assdName",
			   		title: "Assured Name",
			   		width: '280px',
			   		titleAlign: 'left',
			   		align: 'left',
			   		filterOption: true
			    },
			    {
			    	id: "mailAddress1",
			    	title: "Address",
			    	width: '280px',
			    	titleAlign : 'left',
			    	align: 'left',
			    	filterOption: true
			    },			    
			    {
			    	id: "intmNo",
			    	title: "Intermediary No.",
			    	width: '100px',
			    	titleAlign: 'right',
			    	align: 'right',
			    	filterOption: true,
			    	filterOptionType: 'integerNoNegative' //added validation
			    } 
			],
		rows: [] //objTGAssured.objTGAssuredList
	};
	assuredListTableGrid = new MyTableGrid(assuredListingTable);
	assuredListTableGrid.pager = {}; //objTGAssured.objTGAssuredListing;	
	assuredListTableGrid.render('assuredListingTable');	
	assuredListTableGrid.afterRender = function(){
		if(assuredListTableGrid.geniisysRows.length == 0){
			$("mtgPagerMsg"+assuredListTableGrid._mtgId).innerHTML = "<strong>Use Filter to view record/s or press List All button to show all records.</strong>";
		}
	}
	
	function printGIPIR800(){
		try {
			var reportId = "GIPIR800";
			var reportTitle = "Assured Listing";
			
			var content = contextPath+"/MaintenanceReportsController?action=printReport"
							+"&reportId="+reportId+"&reportTitle="+reportTitle;	
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, reportTitle);
			}else if($F("selDestination") == "printer"){
				content+="&printerName="+$F("selPrinter");
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "FILE"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printGIPIR800", e);
		}
	}
	
	if(assuredMaintainExitCtr==1 || assuredMaintainExitCtr==2){
		$("smoothmenu1").hide();
		assuredMaintainGimmExitCtr = 1;
	}
	/* EDITED BY MARKS 04.08.2016 SR-21916 */
	$("assuredListingTableGridExit").observe("click", function(){
		if(assuredListingTableGridExit == 0 && (assuredMaintainExitCtr==2)){
			   goToModule("/GIISUserController?action=goToMarketing", "Marketing Main", null);
	   }/* else if(assuredListingTableGridExit == 1){    UNKNOWN CONDITION 
		    exitCtr = 0;								 COMMENTED OUT INCASE OF FUTURE USE
			$("smoothmenu1").show();                     EDITED BY MARKS 04.08.2016
			assuredMaintainExitCtr = 0;                  SR-21916
			assuredListingTableGridExit=0;
			getLineListing(); */ 
		else if(assuredListingTableGridExit == 2){
			exitCtr = 0;
			assuredListingTableGridExit=0;
			showPARCreationPage();
		}else if(assuredListingTableGridExit == 3){
			exitCtr = 0;
			assuredListingTableGridExit=0;
			showPackPARCreationPage();
		}else if(assuredListingTableGridExit == 0){
	   		exitCtr = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}else{ 
			assuredMaintainExitCtr = 0;
		}
	});
	/* END SR-21916 */
	
	$("btnListAll").observe("click", function(){
		assuredListTableGrid.url = contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}";
		assuredListTableGrid._refreshList();
		selectedIndex = -1;
	});
	
	$("mtgRefreshBtn"+assuredListTableGrid._mtgId).observe("mouseup", function(){
		assuredListTableGrid.url = contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}&objFilter={strAssdNo : -1}";
		selectedIndex = -1;
		disableButton("btnIntmDetails");
	});
		
	withAccessToGiiss006b = checkUserModule("GIISS006B");
	
	$("btnIntmDetails").observe("click", function(){
		overlayGiiss006IntmDetails = Overlay.show(contextPath+"/GIISAssuredController", {
			urlContent : true,
			urlParameters: {action : "showGiiss006IntmDetails",
							assdNo : assuredListTableGrid.geniisysRows[selectedIndex].assdNo},
		    title: "Intermediary Details",
		    height: 380,
		    width: 650,
		    draggable: true
		});
	});
	
/* 	$("mtgBtnOkFilter"+assuredListTableGrid._mtgId).observe("mouseup", function(){
		if($F("mtgFilterText"+assuredListTableGrid._mtgId) == ""){
			assuredListTableGrid.url = contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}&objFilter={strAssdNo : -1}";	
		} else {
			assuredListTableGrid.url = contextPath+"/GIISAssuredController?action=getAssuredTableGrid&assdNo=${assdNo}";
		}
	}); */
</script>