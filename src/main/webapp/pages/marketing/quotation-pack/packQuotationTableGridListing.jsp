<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="quoteListingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Generated Package Quotation for ${lineName}</label>
		</div>
	</div>

	<div id="packQuotationTableGridSectionDiv" class="sectionDiv" style="height: 370;">
		<div id="packQuotationTableGridDiv" style= "padding: 10px;">
			<div id="packQuotationTableGrid" style="height: 350px; width: 900px;"></div>
		</div>
	</div>
</div>
<div id="quoteInfoDiv" style="display: none;">
</div>
<script type="text/javascript">

	var selectedIndex = -1;
	clearObjectValues(objMKGlobal);
	quotationFlag = "${quotationFlag}";
	$("quotationMenus").show();
	$("marketingMainMenu").hide();
	initializeMenu();
	initializePackQuotationMenu();
	setModuleId("GIIMM001A");
	setDocumentTitle("Pack Quotation Listing");

	var userId = '${userId}';
	var objUser = JSON.parse('${user}');
	var lineCd = '${lineCd}';
	var directParOpenAccess = '${directParOpenAccess}';
	var arrGIIMM001AButtons = [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.COPY_BTN, MyTableGrid.DUPLICATE_BTN, MyTableGrid.DENY_BTN,MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];

	try{
		var packQuotationObj = new Object();
		packQuotationObj.packQuotationTableGrid = JSON.parse('${gipiPackQuotationListTableGrid}'.replace(/\\/g,'\\\\'));	
		packQuotationObj.packQuotationList = packQuotationObj.packQuotationTableGrid.rows || [];
		var qLineCode = packQuotationObj.packQuotationTableGrid.lineCd;
		var qLineName = packQuotationObj.packQuotationTableGrid.lineName;
		var src = contextPath+"/GIPIPackQuoteController?action=initialPackQuotationListing&lineCd="+qLineCode+"&lineName="+qLineName;
		var packQuotationTableModel = {
			url: contextPath + "/GIPIPackQuoteController?action=refreshPackQuotationListing&lineCd="+qLineCode,
			options:{
				title: '',
	          	height:'325px',
	          	width:'900px',
	          	onCellFocus: function(element, value, x, y, id){
					var mtgId = packQuotationTableGrid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
				     	selectedIndex = y;
				     	selectedQuoteListingIndex = y;
				     	objMKGlobal.packQuoteId = packQuotationTableGrid.geniisysRows[y].packQuoteId;
				     	objGIPIPackQuotations =  packQuotationTableGrid.geniisysRows[y].gipiQuotesList;
				     	setPackQuotationMenu();
					}
					observeChangeTagInTableGrid(packQuotationTableGrid);
					packQuotationTableGrid.keys.removeFocus(packQuotationTableGrid.keys._nCurrenctFocus, true);
		          	packQuotationTableGrid.keys.releaseKeys();
			  	},	onCellBlur: function(){
		  			observeChangeTagInTableGrid(packQuotationTableGrid);			  			
			  	},
			  	onRemoveRowFocus : function(){
			  		selectedIndex = -1;
			  		selectedQuoteListingIndex = -1;
			  		objMKGlobal.packQuoteId = null;
			  		objGIPIPackQuotations.clear();
			  		setPackQuotationMenu();
			  	},
	          	onRowDoubleClick: function(param){
		          	var packQuotationRow = packQuotationTableGrid.geniisysRows[param];
		          	var selectedQuoteId = packQuotationRow.packQuoteId;
		          	var selectedUserId = packQuotationRow.userId;
		          	packQuotationTableGrid.keys.removeFocus(packQuotationTableGrid.keys._nCurrenctFocus, true);
		          	packQuotationTableGrid.keys.releaseKeys();
		          	observeChangeTagInTableGrid(packQuotationTableGrid);
		          	if(validateUserEntryForQuotation(objUser, selectedUserId, directParOpenAccess)){
		          		editPackQuotation(qLineName,qLineCode,selectedQuoteId);
			        }
		          	/*
	          		if(fromReassignQuotation != 1){
	          			var quotationRow = quotationTableGrid.geniisysRows[param];
						var qQuoteId = quotationRow.quoteId;
						var qUserId = 	quotationRow.userId;										              
						quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrenctFocus, true);
						quotationTableGrid.keys.releaseKeys();
				    	observeChangeTagInTableGrid(quotationTableGrid);
						if(validateUserEntryForQuotation(userId, directParOpenAccess, qUserId)){
							editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+qQuoteId+"&ajax=1");
	                    	//editQuotation(src, qLineName, qLineCode, qQuoteId);  
						}
	          		}*/
              	}, 
              	onSort: function(){ //marco - 12.06.2012
              		packQuotationTableGrid.onRemoveRowFocus();
              	},
	        	toolbar: {
               	 	elements: arrGIIMM001AButtons,
                 	onAdd: function(){
              			createPackQuotationTableGrid(qLineName, qLineCode);
				 	},onEdit: function(){
				 		packQuotationTableGrid.keys.removeFocus(packQuotationTableGrid.keys._nCurrenctFocus, true);
			          	packQuotationTableGrid.keys.releaseKeys();
			        	observeChangeTagInTableGrid(packQuotationTableGrid);
			        	
						if(selectedIndex >= 0){
							var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
				          	var selectedQuoteId = packQuotationRow.packQuoteId;
				          	var selectedUserId = packQuotationRow.userId;
				          	if(validateUserEntryForQuotation(objUser, selectedUserId, directParOpenAccess)){
				          		editPackQuotation(qLineName,qLineCode,selectedQuoteId);
					        }
						}else{
							showMessageBox("Please select a quotation.", imgMessage.ERROR);
						}   
			     	},
			     	onDelete:function(){
					 	if(selectedIndex >= 0){
					 		var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
					 		var selectedQuoteId = packQuotationRow.packQuoteId;
					 		var packQuoteUserId = packQuotationRow.userId;
					 		var packQuoteNo = packQuotationRow.quoteNo;
					 		/*if(userId != packQuoteUserId){
								showMessageBox("Record created by another user cannot be deleted.", imgMessage.INFO);
						 	}else{*/
						 	if(validateDeleteQuotation(objUser, packQuoteUserId)){
						 		showConfirmBox(/*"Delete Confirmation"*/ "Confirmation",	// changed by shan 07.07.2014 
									   	   "Are you sure you want to delete quotation number "+packQuoteNo+"?", 
									   	   /*"Ok", "Cancel"*/ "Yes", "No", deletePackQuotation,"");	//Gzelle 10.03.2013 changed Yes/No to Ok/Cancel ; reverted back to Yes/Np : shan 07.07.2014
							 }
					 	}else{
							 showMessageBox("Please select a quotation.", imgMessage.ERROR);
						 	return false;
					 	}
					},onDeny: function(){
						if(selectedIndex >= 0){
							var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
					 		var selectedQuoteId = packQuotationRow.packQuoteId;
					 		var packQuoteUserId = packQuotationRow.userId;
					 		var packQuoteNo = packQuotationRow.quoteNo;
					 		/*if(packQuoteUserId != userId){
								showQuotationListingError("Record created by another user cannot be denied.");
								return false;
							}else {*/
							if(validateDenyQuotation(objUser, packQuoteUserId)){
								//chooseReason(selectedQuoteId, packQuoteNo);
								chooseReasonOverlay(selectedQuoteId, packQuoteNo); // marco - 12.12.2012
							}
						}else{
							showMessageBox("Please select a quotation.", imgMessage.ERROR);
						 	return false;
					 	}
					},onCopy: function(){
						if(selectedIndex >= 0){
							var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
					 		var selectedQuoteId = packQuotationRow.packQuoteId;
					 		var packQuoteUserId = packQuotationRow.userId;
					 		var packQuoteNo = packQuotationRow.quoteNo;

 							   	showConfirmBox(/*"Copy Confirmation"*/ "Confirmation",	// changed by shan 07.07.2014 
 										   "Copy Quotation No. "+packQuoteNo+"?", 
 										   /*"Ok", "Cancel"*/ "Yes", "No", copyPackQuotation,"");  //Gzelle 10.03.2013 changed Yes/No to Ok/Cancel ; reverted back to Yes/No shan 07.70.2014
						}else{
							showMessageBox("Please select a quotation.", imgMessage.ERROR);
						}
					}, onDuplicate: function(){
						if(selectedIndex >= 0){
							var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
					 		var selectedQuoteId = packQuotationRow.packQuoteId;
					 		var packQuoteUserId = packQuotationRow.userId;
					 		var packQuoteNo = packQuotationRow.quoteNo;

 							   	showConfirmBox(/*"Duplicate Confirmation"*/ "Confirmation", // changed by shan 07.07.2014
 										   "Duplicate Quotation No. "+packQuoteNo+"?", 
 										   /*"No", "Cancel"*/ "Yes", "No", duplicatePackQuotation,"");  //Gzelle 10.03.2013 changed Yes/No to Ok/Cancel; reverted back to Yes/No shan 07.07.2014
						}else{
							showMessageBox("Please select a quotation.", imgMessage.ERROR);
						}
					},
					onRefresh: function(){ //marco - 12.06.2012
						packQuotationTableGrid.onRemoveRowFocus();
					},
					onFilter: function(){ //marco - 12.06.2012
	              		packQuotationTableGrid.onRemoveRowFocus();
	              	}
				}	 	
			},
			columnModel:[
				{	id:		'recordStatus',
					title:	'',
					width:  '0',
					visible: false, 
					editor: 'checkBox'
				},
				{	id: 'divCtrId',
						width: '0px',
						visible: false						    
				    },
			    {	id: 'issCd',
					title:  'Issue Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'sublineCd',
					title:  'Subline Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'quotationYy',
					title:  'Quotation Year',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'quotationNo',
					title:  'Quote No.',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'proposalNo',
					title:  'Proposal No.',
					width: '0',
					visible: false,
					filterOption: true
				},
			    {	id: 'quoteNo',
					title:  'Quotation No.',
					width: '225px',
					filterOption: true
				},
			    {	id: 'assdName',
					title:  'Assured Name',
					width: '285px',
					filterOption: true
				},
			    {	id: 'inceptDate', 
					title:  'Incept Date',
					titleAlign: 'center',
					width: '100px',
					align: 'center',
					filterOption: true
				},
			    {	id: 'expiryDate',
					titleAlign: 'center',
					title:  'Expiry Date',
					width: '100px',
					align: 'center',
					filterOption: true
				},
			    {	id: 'validDate',
					title:  'Validity Date',
					titleAlign: 'center',
					width: '100px',
					align: 'center',
					filterOption: true
				},
				{	id: 'userId',
					titleAlign: 'center',
					width: '75px',
					title: 'User ID',
					align: 'center',
					visible: true,
					filterOption: true
				}
			],
			rows: packQuotationObj.packQuotationList	 			
		};

		packQuotationTableGrid = new MyTableGrid(packQuotationTableModel);
		packQuotationTableGrid.pager = packQuotationObj.packQuotationTableGrid;	
		packQuotationTableGrid.render('packQuotationTableGrid');	

		//end of table grid setup
		
		function duplicatePackQuotation(){
			var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
	 		var selectedQuoteId = packQuotationRow.packQuoteId;
	 		
	 		new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=duplicatePackQuotation", {
				asynchronous: true,
				evalScripts: true,
				parameters: {
					packQuoteId: selectedQuoteId
				},
				onCreate: function () {
					showNotice("Copying quotation, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						showMessageBox("New Quotation No. "+(response.responseText.toString().split(","))[1] + ".", imgMessage.INFO); 
						hideNotice("Done!");
						if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
							packQuotationTableGrid.clear();
							packQuotationTableGrid.refresh();
							selectedIndex = -1;
						}
					}
				}
			}); 
		}
		function copyPackQuotation() {
			var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
	 		var selectedQuoteId = packQuotationRow.packQuoteId;
			new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=copyPackQuotation", {
				asynchronous: true,
				evalScripts: true,
				parameters: {
					packQuoteId: selectedQuoteId
				},
				onCreate: function () {
					showNotice("Copying quotation, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						showMessageBox("New Quotation No. "+(response.responseText.toString().split(","))[1] + ".", imgMessage.INFO); 
						hideNotice("Done!");
						if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
							packQuotationTableGrid.clear();
							packQuotationTableGrid.refresh();
							selectedIndex = -1;
						}
					}
				}
			}); 
		}
		function deletePackQuotation(){
			var packQuotationRow = packQuotationTableGrid.geniisysRows[selectedIndex];
	 		var selectedQuoteId = packQuotationRow.packQuoteId;
	 		var packQuoteNo = packQuotationRow.quoteNo;

	 		new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=deletePackQuotation&packQuoteId="+selectedQuoteId,{
	 			asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					showNotice("Deleting quotation, please wait...");
				    },
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						hideNotice(response.responseText);
		 				showMessageBox("The Quotation "+packQuoteNo+" has been deleted.", imgMessage.INFO);
		 				packQuotationTableGrid.clear();
						packQuotationTableGrid.refresh();
						selectedIndex = -1;
					}
				}
		 	});
			return true;
		}
	}catch(e){
		showErrorMessage("deletePackQuotation",e);		
	}
	function chooseReason(packQuoteId, packQuoteNo){
		showOverlayContent2(contextPath+"/GIPIPackQuoteController?action=showReasonPage&packQuoteId="+packQuoteId+"&packQuoteNo="+packQuoteNo+"&lineCd="+qLineCode, 
				"Select Reason", 475, null, null);
	}
	
	function chooseReasonOverlay(packQuoteId, packQuoteNo){
		packQuotationTableGrid.keys.removeFocus(packQuotationTableGrid.keys._nCurrentFocus, true);
		packQuotationTableGrid.keys.releaseKeys();
		selectedIndex = -1;
		packDenyReasonOverlay = Overlay.show(contextPath+"/GIPIPackQuoteController", {
			urlContent : true,
			draggable: true,
			urlParameters: {
				action		: "showReasonPage",
				packQuoteId : packQuoteId,
				packQuoteNo : packQuoteNo,
				lineCd      : qLineCode
			},
		    title: "SELECT REASON",
		    height: 100,
		    width: 475
		});
	}
	
	function setSelectedIndex(){ // bonok :: 05.07.2014
		selectedIndex = 0;
	}
	
	objUWGlobal.setSelectedIndexGIIMM001A = setSelectedIndex;
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
	});
</script>