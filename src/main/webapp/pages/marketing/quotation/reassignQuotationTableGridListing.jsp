<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

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

<script type="text/javascript">
	selectedQuoteListingIndex = -1;
	quotationFlag = "${quotationFlag}";
	$("home").hide();
	$("marketingMainMenu").hide();
	$("quotationProcessing").hide();
	$("reassignMenu").show();
	initializeMenu();
	setModuleId("GIIMM013");
	setDocumentTitle("Quotation Assignment");
	
	var directParOpenAccess = '${directParOpenAccess}';
	var userId = '${userId}';
	var misSw = '${misSw}';
	var mgrSw = '${mgrSw}';
	var lineCd = '${lineCd}';
   	var arrGIIMM013Buttons = [MyTableGrid.SAVE_BTN, MyTableGrid.REASSIGN_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
   	var reassignChangeTag = 0;
   	var assdTitle = "";
   	var underwriterFilter = true;
   	var exitFlag = false;
   	
   	//modified condition - Patrick 02/08/2012
   	if(lineCd == 'SU'){
   		assdTitle = 'Principal Name';
   		underwriterFilter = false;
   	}else{
   		assdTitle = 'Assured Name';
   		underwriterFilter = true;
   	}
   	
	try{
		var quotationObj = new Object();
		quotationObj.quotationObjListTableGrid = JSON.parse('${gipiQuotationListTableGrid}');		
		quotationObj.quotationObjList = quotationObj.quotationObjListTableGrid.rows || [];
		
		var qLineCode = quotationObj.quotationObjListTableGrid.lineCd;
		var qLineName = quotationObj.quotationObjListTableGrid.lineName;
		var src = contextPath+"/GIPIQuotationController?action=initialReassignQuotationListing&lineCd="+qLineCode+"&lineName="+qLineName;

        var quotationTableModel = {
				url: contextPath + "/GIPIQuotationController?action=refreshReassignQuotationListing&lineCd="+qLineCode,
    	      	options:{
    	      		id : 1,
	              	title: '',
	              	height:'307px',
		          	width:'900px',
				  	onCellFocus: function(element, value, x, y, id){
				     	selectedQuoteListingIndex = y;
				     	objGIPIQuote.quoteId = quotationTableGrid.geniisysRows[y].quoteId;
						observeChangeTagInTableGrid(quotationTableGrid);
						
						/* if(x == quotationTableGrid.getColumnIndex("remarks")){
							$("mtgInput"+quotationTableGrid._mtgId+"_"+x+","+y).setStyle("width: 277px");
						} */
				  	},
				  	onCellBlur: function(){
			  			observeChangeTagInTableGrid(quotationTableGrid);
				  	},
				  	onRemoveRowFocus : function(){
				  		//selectedQuoteListingIndex = y;	//steven 3.8.2012
				  		selectedQuoteListingIndex = -1;
				  	},
				  	onRowDoubleClick: function(y){
			  			selectedQuoteListingIndex = y;
	            		var quotation = quotationTableGrid.geniisysRows[selectedQuoteListingIndex];
				    	observeChangeTagInTableGrid(quotationTableGrid);
				    	checkIfAllowedToReassignQuote(quotation); // Nica 05.31.2012
                  	},
					beforeSort : function(){
						if(changeTag == 1 || reassignChangeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		            		return false;
		            	}
					},
					onSort: function(){
						selectedQuoteListingIndex = -1;
					},
                  	toolbar: {
                   	 	elements:	(arrGIIMM013Buttons),
 	  	            	onReassign: function(){
 	  	            		if(selectedQuoteListingIndex < 0){
 	  	            			showMessageBox("Please select a quotation.", imgMessage.ERROR);
 	  	            		}else{
 	  	            			var quotation = quotationTableGrid.geniisysRows[selectedQuoteListingIndex];
 	  	            			//quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrenctFocus, true);
								//quotationTableGrid.keys.releaseKeys();
						    	observeChangeTagInTableGrid(quotationTableGrid);
						    	checkIfAllowedToReassignQuote(quotation); // Nica 05.31.2012
 	  	            		}
 	  	            	},
 	  	            	onSave: function(){
 	  	            		quotationTableGrid.keys.removeFocus(quotationTableGrid.keys._nCurrentFocus, true);
 							quotationTableGrid.keys.releaseKeys();
 	  	            		reassignQuotation();
 	  	            	},
 	  	            	postSave: function(){
 							changeTag = 0;
 							reassignChangeTag = 0;
 							selectedQuoteListingIndex = -1;
 						},
 						onFilter: function(){
 							if(changeTag == 1){
 								return false;
 								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", reassignQuotation, hideOverlay, ""); 								
 							}
 							selectedQuoteListingIndex = -1;
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
     					    {	id: 'packQuoteLineCd',	// shan 08.27.2014
     							width: '0',
     							visible: false
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
     						{	id: 'packPolFlag',
     							title: 'packPolFlag',
     							width: '0',
     							visible: false,
     							filterOption: false
     						},
        					{	id: 'packQuoteID',
     							title: 'packQuoteId',
     							width: '0',
     							visible: false,
     							filterOption: false
        					},
        					{	id: 'packQuoteNo',
        						title: 'packQuoteNo',
        						width: '0',
        						visible: false,
        						filterOption: false
        					},
     					    {	id: 'quoteNo',
     							title:  'Quotation No.',
     							width: '201px',
     							filterOption: false
     						},
     					    {	id: 'assdName',
     							title:  assdTitle,
     							width: '265px',
     							filterOption: true
     						},
     						{	id: 'remarks',
     							title: 'Remarks',
     							width: '307px',
     							filterOption: false,
     							editable: true,
     							maxlength: 4000,
     							editor: new MyTableGrid.EditorInput({
     								onClick: function(){
	     								var coords = quotationTableGrid.getCurrentPosition();
	     								var x = coords[0];
	     								var y = coords[1];
	     								quotationTableGrid.setValueAt(nvl($F("mtgInput"+quotationTableGrid._mtgId+"_"+x+","+y),""), x, y, true);
	     								var title = "Remarks ("+ quotationTableGrid.geniisysRows[y].quoteNo+")";
	     								showTableGridEditor2(quotationTableGrid, x, y, title, 4000, false);
	     							}
     							})
     						},
     						{	id: 'userId',
     							width: '95px',
     							title: 'Underwriter',
     							align: 'left', //steven 3.9.2012
     							visible: true,
     							filterOption: underwriterFilter
     						},
     						{	id: 'quoteId',
     							width: '0',
     							title: '',
     							visible: false
     						}
     					], 	  
     				resetChangeTag: true,
     				rows: quotationObj.quotationObjList
      	};  
		quotationTableGrid = new MyTableGrid(quotationTableModel);
		quotationTableGrid.pager = quotationObj.quotationObjListTableGrid;
		quotationTableGrid._mtgId = 1;
		quotationTableGrid.render('quotationTableGrid');
		
		//refreshQuotationMenu(); // added by mark jm 04.14.2011 @UCPBGEN
		
		function checkIfAllowedToReassignQuote(quotation){ // added by: Nica 05.31.2012
			quotationTableGrid._blurCellElement(quotationTableGrid.keys._nCurrentFocus == null ? quotationTableGrid.keys._nOldFocus : quotationTableGrid.keys._nCurrentFocus);
			
			if(misSw != 'Y' && quotation.userId != userId){
	    		showMessageBox("You are not allowed to assign this quotation to another user unless MIS allows you.");
	    		return false;
	    	}else if(mgrSw != 'Y' && quotation.userId != userId){
	    		showMessageBox("You are not allowed to re-assign this quotation to another user unless you have a Manager permission.");
	    		return false;
	    	}else{
		    	if(quotation.packPolFlag == 'Y'){
		    		showConfirmBox("Package Quotation", "This is a package quotation (" + quotation.packQuoteNo + ").  Do you want to continue?",
            				"Ok", "Cancel", function(){showUnderwriterForReassignQuote(quotation.packQuoteLineCd, quotation.issCd, quotation.userId);}, "", "1");
		    	}else {
		    		showUnderwriterForReassignQuote(lineCd, quotation.issCd, quotation.userId);	
		    	}
		    }
		}
		
		function reassignQuotation(){
			try{
				var modifiedRows = quotationTableGrid.getModifiedRows();
           		var objParameters = new Object();
           		
           		objParameters.setRows = modifiedRows;
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
								reassignChangeTag = 0;
								showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
									quotationTableGrid._refreshList();
									if(exitFlag){
										goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
									}
								});
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								return false;
							}
						}
					}
				});
			}catch(e){
				showErrorMessage("reassignQuotation", e);
			}
		}
		
		initializeChangeTagBehavior(reassignQuotation);
	}catch(e){
		showMessageBox("Error in Quotation Listing: " + e, imgMessage.ERROR);		
	}
	
	function updateListByRemarks(rows){
		try {
			quotationTableGrid.setValueAt(rows.remarks, quotationTableGrid.getColumnIndex("remarks"), selectedQuoteListingIndex, true);
			quotationTableGrid.geniisysRows[selectedQuoteListingIndex].remarks = rows.remarks;
			if((objGIPIQuoteArr.filter(function(obj){ return obj.quoteId == quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId;	})).length > 0 ){
				for(var i=0, length=objGIPIQuoteArr.length; i < length; i++){
					if(objGIPIQuoteArr[i].quoteId == quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId){
						objGIPIQuoteArr.splice(i, 1, quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
					}
				}
			}else{
				objGIPIQuoteArr.push(quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
			}
			quotationTableGrid.modifiedRows.push(quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
		} catch(e) {
			showErrorMessage("updateListByRemarks", e);
		}
	}
	
	function showUnderwriterForReassignQuote(nbtLineCd, issCd, userId) {	// added parameter : shan 08.13.2014
		var notIn = "('"+userId+"')";
		LOV.show({
			controller : "MarketingLOVController",
			urlContent : true,
			urlParameters : {
				action : "getUnderwriterForReassignQuoteLOV",
				page : 1,
				lineCd:	nbtLineCd,		// shan 08.13.2014
				issCd:	issCd,		// shan 08.13.2014
				notIn:	notIn		// shan 08.20.2014
			},
			title : "Assign Quotation",
			width : 471,
			height : 386,
			draggable : true,
			columnModel : [
			               {
			            	   id : "recordStatus",
			            	   title : "",
			            	   width : "0",
			            	   visible : false
			               },
			               {
			            	   id : "divCtdId",
			            	   width : "0",
			            	   visible : false
			               },
			               {
			            	   id : "userId",
			            	   title : "Underwriter",
			            	   width : "150px",
			            	   filterOption : true
			               },
			               {
			            	   id : "userGrp",
			            	   title : "User Group",
			            	   width : "150px"
			               },
			               {
			            	   id : "username",
			            	   title : "User Name",
			            	   width : "150px"
			               }
			               ],
			onSelect : function(row){
				reassignChangeTag = 1;
				updateListByReassign(row);
			}
		});
	}
	
	$("reassignExit").stopObserving("click");
	$("reassignExit").observe("click", function(){
		if(changeTag == 1 || reassignChangeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				exitFlag = 1;
				reassignQuotation();
			}, function(){
				goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
			}, "");
		}else{
			goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
		}
	});
</script>