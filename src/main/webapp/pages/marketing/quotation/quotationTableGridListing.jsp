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
			<label>List of Generated Quotation for ${lineName}</label>
		</div>
	</div>

	<div id="quotationTableGridSectionDiv" class="sectionDiv" style="height: 370;">
		<div id="quotationTableGridDiv" style= "padding: 10px;">
			<div id="quotationTableGrid" style="height: 350px; width: 900px;"></div>
		</div>
	</div>
</div>
<div id="quoteInfoDiv" style="display: none;">
</div>
<div id="quoteDynamicDiv">
</div>
<script type="text/javascript">
	quotationFlag = "${quotationFlag}";
	$("quotationMenus").show();
	$("marketingMainMenu").hide();
	initializeMenu();
	initializeQuotationMenu();
	setModuleId("GIIMM001");
	setDocumentTitle("Quotation Listing");
	var directParOpenAccess = '${directParOpenAccess}';
	var userId = '${userId}';
	var lineCd = '${lineCd}';
	var objUser = JSON.parse('${user}');
	var selectedIndex = -1;
	var arrGIIMM001Buttons = [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.COPY_BTN, MyTableGrid.DUPLICATE_BTN, MyTableGrid.DENY_BTN,MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];						
   	var arrGIIMM013Buttons = [MyTableGrid.SAVE_BTN, MyTableGrid.REASSIGN_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
  	selectedQuoteListingIndex = -1; // added by andrew - 01.17.2012 - to clear the selected record 
	objGIPIQuote.quoteId = 0; // added by andrew - 01.17.2012 - to clear the selected record
  
	try{
		var quotationObj = new Object();
		quotationObj.quotationObjListTableGrid = JSON.parse('${gipiQuotationListTableGrid}'.replace(/\\/g,'\\\\'));		
		quotationObj.quotationObjList = quotationObj.quotationObjListTableGrid.rows || [];
		
		var qLineCode = quotationObj.quotationObjListTableGrid.lineCd;
		var qLineName = quotationObj.quotationObjListTableGrid.lineName;
		var src = contextPath+"/GIPIQuotationController?action=initialQuotationListing&lineCd="+qLineCode+"&lineName="+qLineName;

        var quotationTableModel = {
				url: contextPath + "/GIPIQuotationController?action=refreshQuotationListing&lineCd="+qLineCode,
    	      	options:{
	              	title: '',
	              	height:'307px',
		          	width:'900px',
				  	onCellFocus: function(element, value, x, y, id){
						var mtgId = quotationTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					     	selectedIndex = y;
					     	selectedQuoteListingIndex = y;
					     	objGIPIQuote.quoteId = quotationTableGrid.geniisysRows[y].quoteId;
					     	objGIPIQuote.quoteNo = quotationTableGrid.geniisysRows[y].quoteNo; //added by steven 10/30/2012
						}
						observeChangeTagInTableGrid(quotationTableGrid);
						quotationTableGrid.keys.releaseKeys();
				  	},
				  	onCellBlur: function(){
			  			observeChangeTagInTableGrid(quotationTableGrid);			  			
				  	},
				  	onRemoveRowFocus : function(){
				  		selectedQuoteListingIndex = -1;		
				  		objGIPIQuote.quoteId = 0;
				  		selectedIndex = -1; //added by steven 10/30/2012
				  		quotationTableGrid.keys.releaseKeys();
				  	},
				  	onRowDoubleClick: function(param){
		          		if(fromReassignQuotation != 1){
		          			var quotationRow = quotationTableGrid.geniisysRows[param];
							var qQuoteId = quotationRow.quoteId;
							var qUserId = 	quotationRow.userId;										              
							quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrenctFocus, true);
							quotationTableGrid.keys.releaseKeys();
					    	observeChangeTagInTableGrid(quotationTableGrid);
							if(validateUserEntryForQuotation(objUser, qUserId, directParOpenAccess)){
								objGIPIQuote.quoteId = qQuoteId;
								editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+qQuoteId+"&ajax=1");
		                    	//editQuotation(src, qLineName, qLineCode, qQuoteId);  
							}
		          		} else {
		          			/* marco - open underwriter lov(paginated) */
		          			selectedQuoteListingIndex = selectedIndex;
				          	showUnderwriterForReassignQuote();
		          		}
                  	},
                  	onSort: function(){ //marco - 12.06.2012
                  		quotationTableGrid.onRemoveRowFocus();
                  	},
                  	toolbar: {
                   	 	elements:	(fromReassignQuotation == 1 ? arrGIIMM013Buttons : arrGIIMM001Buttons),
                     	onAdd: function(){
                            createQuotationTableGrid(qLineName, qLineCode);
    				 	},
    				 	onEdit: function(){
   							quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrenctFocus, true);
   							quotationTableGrid.keys.releaseKeys();
   					    	observeChangeTagInTableGrid(quotationTableGrid);
   							if(selectedIndex >= 0){
   								var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
   								var qUserId = 	quotationRow.userId;
   								var qQuoteId = quotationRow.quoteId;
							    	if(validateUserEntryForQuotation(objUser, qUserId, directParOpenAccess)){
							    		editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+qQuoteId+"&ajax=1");
			                       		//editQuotation(src, qLineName, qLineCode, qQuoteId);  
							   		}
   							}else{
   								showMessageBox("Please select a quotation.", imgMessage.ERROR);
   							}   
 				     	},
 					 	onDelete:function(){
 						 	if(selectedIndex >= 0){
 								var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
 								var qUserId = 	quotationRow.userId;
 								var qQuoteId = quotationRow.quoteId;
 								if (qQuoteId  == "") {
 									showQuotationListingError("Please select a quotation.");
 									return false;
 								} else {
 									if(validateDeleteQuotation(objUser, qUserId)){
	 									showConfirmBox(/*"Delete Confirmation"*/ "Confirmation", // changed by shan 07.07.2014 
	 										   	   "Are you sure you want to delete quotation number "+unescapeHTML2(objGIPIQuote.quoteNo)+"?", // added unescapeHTML2 by robert 11.11.13  //change by steven 10/30/2012 base on SR 0011159
	 										   	   "Yes", "No", continueDeleteQuotation,"");
 									}
 								}
 						 	}else{
 								 showMessageBox("Please select a quotation.", imgMessage.ERROR);
 							 	return false;
 						 	}
 					 	},
 						onCopy: function(){
  						  	if(selectedIndex >= 0){
    							var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
     							var qQuoteId = quotationRow.quoteId;
     						 	var qQuoteNo = unescapeHTML2(quotationRow.quoteNo); // added unescapeHTML2 by robert 11.11.13
     						 	if (qQuoteId== "") {
     							   	showQuotationListingError("Please select a quotation.");
     							   	return false;
     						 	} else {
     							   	showConfirmBox(/*"Copy Confirmation"*/ "Confirmation", // changed by shan 07.07.2014
     										   "Copy Quotation No. "+qQuoteNo+"?", 
     										   "Yes", "No", continueCopyQuotation,"");  
     							}
  							}else{
  								showMessageBox("Please select a quotation.", imgMessage.ERROR);
  							}
  						},
  						onDuplicate: function(){
 						 	if(selectedIndex >= 0){
 								var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
 								var qQuoteId = quotationRow.quoteId;
 								var qQuoteNo = unescapeHTML2(quotationRow.quoteNo); // added unescapeHTML2 by robert 11.11.13
 								if (qQuoteId  == "") {
 									showQuotationListingError("Please select a quotation.");
 									return false;
 								} else {
 									showConfirmBox(/*"Duplicate Confirmation"*/ "Confirmation",	// changed by shan 07.07.2014 
 										   	   "Duplicate Quotation No. "+qQuoteNo+"?", 
 										   	   "Yes", "No", continueDuplicateQuotation,"");
 								}
 						 	}else{
 							 	showMessageBox("Please select a quotation.", imgMessage.ERROR);
 							 	return false;
 						 	}				
  						},
                    	onDeny: function(){
                    		selectedIndex = selectedQuoteListingIndex;	// added to pass correct quotation because selectedIndex is set to 0 if user did not proceed : shan 08.12.2014
 						 	if(selectedIndex >= 0){
 								var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
 								var qQuoteId = quotationRow.quoteId;
 								var qUserId = 	quotationRow.userId;
 								var qReasonCd = quotationRow.reasonCd;
 								var qQuoteNo = unescapeHTML2(quotationRow.quoteNo); // added unescapeHTML2 by robert 11.11.13
 								if (qQuoteId  == "") {
 									showQuotationListingError("Please select a quotation.");
 									return false;
 								} else {
 									/*if(qUserId != userId){
 										showQuotationListingError("Record created by another user cannot be denied.");
 										return false;
 									}*/
 									if(!(validateDenyQuotation(objUser, qUserId))){
 										return false; 	 	
 									}else {
 	 									if (qReasonCd == null){
 	 	 									qReasonCd = 0;
 	 	 									//chooseReason(qQuoteId, qQuoteNo);
 	 	 									chooseReasonOverlay(qQuoteId, qQuoteNo);
 										} else {
 											denyQuote(qId, qQuoteNo);
 										}	
 									}
 								}
 						 	}else{
 							 	showMessageBox("Please select a quotation.", imgMessage.ERROR);
 							 	return false;
 						 	}
 	  	            	},
 	  	            	onReassign: function(){
 	  	            		if(selectedQuoteListingIndex < 0){
 	  	            			showMessageBox("Please select a quotation.", imgMessage.ERROR);
 	  	            		}else{
 	  	            			/* marco - open underwriter lov(paginated) */
 	  	            			quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrenctFocus, true);
								quotationTableGrid.keys.releaseKeys();
						    	observeChangeTagInTableGrid(quotationTableGrid);
 	  	            			showUnderwriterForReassignQuote();
 	  	            			
 	  	            			/* uncomment to revert */
 	  	            			/* lovUnderwriter = Overlay.show(contextPath + "/GIISUserController", {
 	  	            				urlContent : true,
 	  	            				urlParameters : {
 	  	            					action : "showUnderwriterForReassignQuote",
 	  	            					page : 1},
 	  	            				width : 460,
 	  	            				height : 300,
 	  	            				draggable : true}); */
 	  	            		}        		
 	  	            	},
 	  	            	onSave: function(){ 	  	            		
 	  	            		reassignQuotation();
 	  	            		quotationTableGrid.refresh();
 	  	            	},
 	  	            	postSave: function(){
 	  	            		quotationTableGrid.clear();
 	  	            		quotationTableGrid.refresh();
 							changeTag = 0;
 							//selectedIndex = -1;
 							selectedQuoteListingIndex = -1;
 						},
 						onFilter: function(){
 							if(changeTag == 1){
 								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", reassignQuotation, hideOverlay, "");
 							}
 						},
 						onRefresh: function(){ //marco - 12.06.2012
 							quotationTableGrid.onRemoveRowFocus();
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
     							filterOption: true,
     							filterOptionType: 'integerNoNegative'
     						},
     						{	id: 'quotationNo',
     							title:  'Quote No.',
     							width: '0',
     							visible: false,
     							filterOption: true,
     							filterOptionType: 'integerNoNegative'
     						},
     						{	id: 'proposalNo',
     							title:  'Proposal No.',
     							width: '0',
     							visible: false,
     							filterOption: true,
     							filterOptionType: 'integerNoNegative'
     						},
     					    {	id: 'quoteNo',
     							title:  'Quotation No.',
     							width: '225px',
     							filterOption: true,
     							filterOptionType: 'integerNoNegative',
   								renderer: function(value){ //added by jeffdojello 10/21/2013
       								return unescapeHTML2(value);
   								}
     						},
     					    {	id: 'assdName',
     							title:  'Assured Name',
     							width: '270px',
     							filterOption: true,
     							renderer: function(value){ //added by steven 10/29/2012
     								return unescapeHTML2(value);
     							}
     						},
     					    {	id: 'inceptDate', 
     							title:  'Incept Date',
     							titleAlign: 'center',
     							width: '100px',
     							align: 'center',
     							filterOption: true,
     							filterOptionType: 'formattedDate'
     						},
     					    {	id: 'expiryDate',
     							titleAlign: 'center',
     							title:  'Expiry Date',
     							width: '100px',
     							align: 'center',
     							filterOption: true,
     							filterOptionType: 'formattedDate'
     						},
     					    {	id: 'validDate',
     							title:  'Validity Date',
     							titleAlign: 'center',
     							width: '100px',
     							align: 'center',
     							filterOption: true,
     							filterOptionType: 'formattedDate'
     						},
     						{	id: 'userId',
     							titleAlign: 'center',
     							width: '77px',
     							title: 'User',
     							align: 'center',
     							visible: true,
     							filterOption: true
     						}
     					], 	  
     				rows: quotationObj.quotationObjList	  
      	};  
		quotationTableGrid = new MyTableGrid(quotationTableModel);
		quotationTableGrid.pager = quotationObj.quotationObjListTableGrid;	
		quotationTableGrid.render('quotationTableGrid');	

		function continueCopyQuotation() {
			var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
			var qQuoteId = quotationRow.quoteId;
			new Ajax.Request(contextPath+"/GIPIQuotationController?action=copyQuotation", {
				asynchronous: true,
				evalScripts: true,
				parameters: {
					lineName: qLineName,
					lineCd: qLineCode,
					quoteId: qQuoteId
				},
				onCreate: function () {
					showNotice("Copying quotation, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						showMessageBox("New Quotation No. "+(response.responseText.toString().split(","))[1] +".", imgMessage.INFO); 
						hideNotice("Done!");
						if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
							quotationTableGrid.clear();
							quotationTableGrid.refresh();
							selectedIndex = -1;
						}
					}
				}
			}); 
		}

		function continueDeleteQuotation() {
		    var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
		    var qQuoteId = quotationRow.quoteId;
		    var qQuoteNo = unescapeHTML2(quotationRow.quoteNo); // added unescapeHTML2 by robert 11.11.13
			new Ajax.Request(contextPath+"/GIPIQuotationController?action=deleteQuotation", {
				asynchronous: true,
				evalScripts: true,
				parameters: {
					quoteId: qQuoteId
				    },
				onCreate: function () {
					showNotice("Deleting quotation, please wait...");
				    },
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						hideNotice(response.responseText);
						if ("SUCCESS" == response.responseText) {
							showMessageBox("The Quotation "+qQuoteNo+" has been deleted.", imgMessage.INFO);
							quotationTableGrid.clear();
							quotationTableGrid.refresh();
							selectedIndex = -1;
						}
					}
				}
			});
			return true;
		}

		function continueDuplicateQuotation() {
		    var quotationRow = quotationTableGrid.geniisysRows[selectedIndex];
		    var qQuoteId = quotationRow.quoteId;
			new Ajax.Request(contextPath+"/GIPIQuotationController?action=duplicateQuotation", {
				asynchronous: true,
				evalScripts: true,
				parameters: {
					lineName: qLineName,
					lineCd: qLineCode,
					quoteId: qQuoteId
				},
				onCreate: function () {
					showNotice("Duplicating quotation, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						showMessageBox("New quotation no. " +(response.responseText.toString().split(","))[1] + "", imgMessage.INFO); 
						hideNotice("Done!");
						if ("SUCCESS" == (response.responseText.toString().split(","))[0]) {
							quotationTableGrid.clear();
							quotationTableGrid.refresh();
							selectedIndex = -1;
						}
				}}
			});
		}
		function chooseReason(quoteId, quoteNo){
			showOverlayContent2(contextPath+"/GIPIQuotationController?action=showReasons&quoteId="+quoteId+"&quoteNo="+quoteNo+"&lineCd="+qLineCode, 
					"Select Reason", 475, null, null);
		}
		
		function chooseReasonOverlay(quoteId, quoteNo){
			quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrentFocus, true);
			quotationTableGrid.keys.releaseKeys();
			selectedIndex = -1; //added by steven 04.11.2014
			denyReasonOverlay = Overlay.show(contextPath+"/GIPIQuotationController", {
				urlContent : true,
				draggable: true,
				urlParameters: {
					action		: "showReasons",
					quoteId		: quoteId,
					quoteNo		: quoteNo,
					lineCd		: qLineCode
				},
			    title: "SELECT REASON",
			    height: 100,
			    width: 475
			});
		}
		
		refreshQuotationMenu();// added by mark jm 04.14.2011 @UCPBGEN		
		
		function setSelectedIndex(){ // bonok :: 05.07.2014
			selectedIndex = 0;
		}
		
		objUWGlobal.setSelectedIndexGIIMM001 = setSelectedIndex;
		
		function reassignQuotation(){
			try{
				var modifiedRows = quotationTableGrid.getModifiedRows();
           		var objParameters = new Object();
           		
           		objParameters.setRows = prepareJsonAsParameter(modifiedRows);
           		var strParameters = JSON.stringify(objParameters);           		
           		
				new Ajax.Request(contextPath + "/GIPIQuotationController?action=reassignQuotation2", {
					asynchronous : true,
					parameters : {
						updatedRows : strParameters
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							if(response.responseText == "SUCCESS"){
								changeTag = 0;
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								return false;
							}
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
							return false;
						}
					}
				});
			}catch(e){
				showErrorMessage("reassignQuotation", e);
			}
		}
		if(lineCd == "SU"){
			bondPolicyDataCtr = 1;
		}else{
			bondPolicyDataCtr = 0;
		}
		if(fromReassignQuotation == 1){
			initializeChangeTagBehavior(reassignQuotation);
		}
		if(bondPolicyDataCtr == 1){
			enableMenu("bondPolicyData");
			bondPolicyDataCtr = 0;
		}else{
			disableMenu("bondPolicyData");
			bondPolicyDataCtr = 0;
		}
	}catch(e){
		showMessageBox("Error in Quotation Listing: " + e, imgMessage.ERROR);		
	}
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
	});
</script>