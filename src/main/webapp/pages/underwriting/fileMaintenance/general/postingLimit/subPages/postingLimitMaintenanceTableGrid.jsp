<!-- 
Date       : 11.14.2012
Modified by: Gzelle 
-->
<script type="text/javascript">

	objGiiss207.selectedIndex = null;
	changeCounter = 0;
 	unsavedStatus = 0;
	changeTag = 0;
	var postLimitObj;
	var postingLimitRowValue = null;
	var postingLimit = null;
	isRecordSelected = false;

	try{
		var row = 0;
		objPostingLimitMain = [];
		var objUserList = new Object();
		objUserList.objPostingLimit = [];
		objUserList.objPostingLimitRows = objUserList.objPostingLimit.rows || [];
		
		var postingLimitTable = {
				id: 3,
				url: contextPath + "/GIISPostingLimitController?action=getPostingLimits",
				options: {
					height: '200px',
					width: '816px',
					masterDetail: true,
					masterDetailRequireSaving: true,
					onCellFocus: function(element, value, x, y, id){
						objGiiss207.selectedIndex = y;
						postingLimitRowValue = postingLimitTableGrid.geniisysRows[y];
						populatePostingLimitMaintenance(postingLimitRowValue);
						disableEdit();
						isRecordSelected = true;
					},
				 	onRemoveRowFocus: function(){
				 		postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
						formatAppearance();
						resetForm();
						objGiiss207.displayValue();
	            	},
	            	beforeSort: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	}
	            	},
	            	onSort: function(){
	            		lineResponse = "";
	            		formatAppearance();
	            		resetForm();
	            		objGiiss207.displayValue();
	            	},
	            	prePager: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		formatAppearance();
							resetForm();
							objGiiss207.displayValue();
	                	}
	                },
					masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
					onRefresh: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		lineResponse = "";
	                		formatAppearance();
							resetForm();
							objGiiss207.displayValue();
	                	}
					},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
			            	if (changeTag == 1){
			            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
								return false;
		                	} else {
		                		formatAppearance();
								resetForm();
								objGiiss207.displayValue();
		                	}
						},
					 }
				},
				columnModel: [
					{   
						id: 'recordStatus',
						title: '',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	
						id: 'lineName',
						title: 'Line Name',
						width: '190px',
						filterOption: true,
						visible: true,
						sortable: true
					},
					{	
						id: 'postLimit',
						title: 'Posting Limit',
						titleAlign: 'right',
						width: '130px',
						align: 'right',
						visible: true,
						filterOption: true,
						sortable: true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
				 	{
					   	id: 'allAmtSw',
				    	title: 'A',
				    	width: '25px',
						titleAlign: 'center',
		            	align: 'center',
		            	altTitle: "All Amount",
		            	sortable: false,
				    	defaultValue: false,
						otherValue: false,
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
						id: 'endtPostLimit',
						title: 'Endt. Posting Limit',
						titleAlign: 'right',
						width: '130px',
						align: 'right',
						visible: true,
						sortable: true,
						filterOption: true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
				 	{
					   	id: 'endtAllAmtSw',
				    	title: 'E',
				    	width: '25px',
						titleAlign: 'center',
		            	align: 'center',
		            	altTitle: "Endt. All Amount",
		            	sortable: false,
				    	defaultValue: false,
						otherValue: false,
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
						id: 'userId',
						title: 'User ID',
						width: '120px',
						visible: true
					},
					{	
						id: 'lastUpdate',
						title: 'Last Update',
						width: '150px',
						visible: true
					}
			   ],
			   rows: objUserList.objPostingLimitRows
			   
		};
		postingLimitTableGrid = new MyTableGrid(postingLimitTable);
		postingLimitTableGrid.pager = objUserList.objPostingLimit;
		postingLimitTableGrid.render('postingLimitTableGridDiv');
		postingLimitTableGrid.afterRender = function(){
			objPostingLimitMain = postingLimitTableGrid.geniisysRows;
		};
	
	}catch (e) {
		showErrorMessage("Posting Limit Table Grid", e);
	}
	
	function populatePostingLimitMaintenance(obj){
		try {
			$("hidIssCd").value 			= (obj == null ? "" : issueSourceListingRowValue.issCd);
			$("hidPostingUser").value 		= (obj == null ? "" : userListingRowValue.userId);
			$("hidLastValidPostingLimit").value 	= (obj == null ? "" : obj.postLimit);
			$("hidLastValidEndtPostingLimit").value = (obj == null ? "" : obj.endtPostLimit);
			$("hidLineCd").value 			= (obj == null ? "" : obj.lineCd);
			$("hidLineName").value 			= (obj == null ? "" : obj.lineName);
			$("txtLineName").value 			= (obj == null ? "" : obj.lineName);
			//$("txtPostingLimit").value 		= (obj == null ? "" : formatToNthDecimal(obj.postLimit,2)); //replaced by: Nica 05.27.2013
			$("txtPostingLimit").value 		= (obj == null ? "" : nvl(obj.postLimit,"") == "" ? "" : formatCurrency(obj.postLimit));
			$("chkAllAmountSw").checked 	= (obj == null ? false : (obj.allAmtSw == 'Y' ? true : false));
			$("chkAllAmount").checked 		= (obj == null ? false : (obj.allAmtSw == 'Y' ? true : false));
			//$("txtEndtPostingLimit").value 	= (obj == null ? "" : formatToNthDecimal(obj.endtPostLimit,2)); //replaced by: Nica 05.27.2013
			$("txtEndtPostingLimit").value 	= (obj == null ? "" : nvl(obj.endtPostLimit,"") == "" ? "" : formatCurrency(obj.endtPostLimit));
			$("chkEndtAllAmountSw").checked = (obj == null ? false : (obj.endtAllAmtSw == 'Y' ? true : false));
			$("chkEndtAllAmount").checked 	= (obj == null ? false : (obj.endtAllAmtSw == 'Y' ? true : false));
			$("txtUserId").value 			= (obj == null ? "" : obj.userId);			
			$("txtLastUpdate").value 		= (obj == null ? "" : obj.lastUpdate);
		} catch (e) {
			showErrorMessage("Populate Posting Limit Maintenance", e);
		}
	}
	
	function createPostLimitObj(func){
 	    try {
 	       var limit = new Object();
 	       limit.postingUser 	= userListingRowValue.userId;
 	       limit.issCd 			= issueSourceListingRowValue.issCd;
 	       limit.lineName 		= $("txtLineName").value;
 	       limit.postLimit 		= $("txtPostingLimit").value;
 	       limit.allAmtSw 		= $("chkAllAmountSw").checked ? "Y" : "N";
 	       limit.endtPostLimit 	= $("txtEndtPostingLimit").value; 	       
 	       limit.endtAllAmtSw 	= $("chkEndtAllAmountSw").checked ? "Y" : "N"; 
 	       limit.userId 		= func == "Update" ? "${PARAMETERS['USER'].userId}" : $("txtUserId").value;
 	       limit.lastUpdate 	= $("txtLastUpdate").value;
 	       limit.lineCd 		= $("hidLineCd").value;
 	       limit.recordStatus   = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
 	       return limit;
 	     } catch (e) {
 	       showErrorMessage("createPostLimitObj", e);
 	     }
 	}
 	
  	function resetForm() {
  		//$("txtLineName").focus(); Gzelle 03202014
		$("prevAllAmount").checked = false;
		$("chkAllAmount").checked = false;
		$("prevEndtAllAmount").checked = false;
		$("chkEndtAllAmount").checked = false;
		$("txtPostingLimit").addClassName("required");
		$("txtEndtPostingLimit").addClassName("required");
		$("hidLastValidEndtPostingLimit").value = "";
		$("hidLastValidPostingLimit").value = "";
		enableInputField("txtPostingLimit");
		enableInputField("txtEndtPostingLimit");
	} 
 	
 	function formatAppearance() {
		$("btnAddPostingLimit").value = "Add";
		disableButton("btnDeletePostingLimit");
		enableSearch("btnSearchLine");
		postingLimitTableGrid.keys.releaseKeys();
		populatePostingLimitMaintenance(null);
		isRecordSelected = false;
	} 
	
	function disableEdit() {
		$("txtPostingLimit").value = addSeparatorToNumber2(formatNumberByRegExpPattern($("txtPostingLimit")), ",");
		$("txtEndtPostingLimit").value = addSeparatorToNumber2(formatNumberByRegExpPattern($("txtEndtPostingLimit")), ",");
		postingLimitTableGrid.keys.releaseKeys();
		$("btnAddPostingLimit").value = "Update";
		//$("txtLineName").focus();   Gzelle 03202014
		enableButton("btnDeletePostingLimit");
		//disableSearch("btnSearchLine");
		toggleFieldClass($("chkAllAmountSw"), $("txtPostingLimit"));
		toggleFieldClass($("chkEndtAllAmountSw"), $("txtEndtPostingLimit"));
	}
	
	/**
	 * params:	chkAmtSw - hidden checkbox that stores value from db
	 * 			prevAmtSw - hidden checkbox that stores the previous state of checkbox
	 *			customLabel - dynamic label for confirm box
	 *			txtLimit - textfield 
	 *			onNoFunc - function called on click of <No>
	 *			onYesFunc - function called on click of <Yes> 
	 */
	
	//for posting limit and endt. posting limit fields
	function toggleFieldClass(chkAmtSw, txtLimit) {
		if (chkAmtSw.checked == true) {
			txtLimit.removeClassName("required");
			txtLimit.setAttribute("readonly","readonly");
		} else {
			txtLimit.addClassName("required");
			txtLimit.removeAttribute("readonly");
		}
	}
	
	//called on confirm message box
	function onYesFunc(chkSw, chkAmt, txtLimit, prevAmt) {
		chkAmt.checked = true;
		chkSw.checked = true;
		txtLimit.value = "";
		txtLimit.removeClassName("required");
		txtLimit.setAttribute("readonly","readonly");
		prevAmt.checked = true;
	}
	
	//called on confirm message box
	function onNoFunc(chkSw, chkAmt, txtLimit) {
		chkSw.checked = false;
		chkAmt.checked = false;
		//txtLimit.value = "";	Gzelle 03212014
		txtLimit.removeAttribute("readonly");
		txtLimit.addClassName("required");
	}
	
	//checkbox validation - confirm on switch to check
	function validateCheckbox(chkAmtSw, prevAmtSw, label, onNoFunc, onYesFunc) {
		objGiiss207.onNoFunc = onNoFunc;
		objGiiss207.onYesFunc = onYesFunc;
		if (chkAmtSw.checked == true) {
			prevAmtSw.checked = true;
		}
		if (prevAmtSw.checked == false) {
			showConfirmBox("Confirm", "Tagging this field will allow " + userListingRowValue.userId + " to issue " +  label + " with no Sum Insured Limit." 
										+ " Do you want to continue?", "Yes", "No", onYesFunc, onNoFunc);
		}else if (prevAmtSw.checked == true) {
			onNoFunc();
			prevAmtSw.checked = false;
		}
	}
	
	//validate posting limit
	function validatePostingLimit(limit, lastValidValue, focus){
		if (isNaN(limit.value)) {
			limit.value = lastValidValue.value;
		} else if ((limit.value < (parseInt(limit.getAttribute("min")))) || (limit.value > 999999999.99)) {
			customShowMessageBox("Invalid " + limit.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
			limit.value = lastValidValue.value;
		} else if ((limit.value).include("-")) {
			customShowMessageBox("Invalid " + limit.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
			limit.value = lastValidValue.value;
		} 
		else {
			limit.value = addSeparatorToNumber2(formatNumberByRegExpPattern(limit), ",");
			var decimalLimit = ((limit.value).include(".") ? limit.value : (limit.value)).split(".");
			if(decimalLimit[1].length > 2){				
				customShowMessageBox("Invalid " + limit.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
				limit.value = lastValidValue.value;
			}else{				
				lastValidValue.value = limit.value;
			}
		}
	}
	
	//all amount switch observer
	$("chkAllAmount").observe("click", function(){
		validateCheckbox($("chkAllAmountSw"), $("prevAllAmount"), "policy", function() {
			onNoFunc($("chkAllAmountSw"), $("chkAllAmount"), $("txtPostingLimit"));
		}, function() {
			onYesFunc($("chkAllAmountSw"), $("chkAllAmount"), $("txtPostingLimit"), $("prevAllAmount"));
		});
 	});
	
	//endt. all amount switch observer
	$("chkEndtAllAmount").observe("click", function(){
		validateCheckbox($("chkEndtAllAmountSw"), $("prevEndtAllAmount"), "endorsement", function() {
			onNoFunc($("chkEndtAllAmountSw"), $("chkEndtAllAmount"), $("txtEndtPostingLimit"));
		}, function() {
			onYesFunc($("chkEndtAllAmountSw"), $("chkEndtAllAmount"), $("txtEndtPostingLimit"), $("prevEndtAllAmount"));
		});
 	});	
	
	//posting limit field observer
	$("txtPostingLimit").observe("change", function() {
		if ($("txtPostingLimit").value != "") {
			validatePostingLimit($("txtPostingLimit"), $("hidLastValidPostingLimit"), "txtPostingLimit");	
		}
	});	
	
	$("txtPostingLimit").observe("blur", function() {
		if ($("txtPostingLimit").value != "") {
			validatePostingLimit($("txtPostingLimit"), $("hidLastValidPostingLimit"), "txtPostingLimit");	
		}
	});	
	
	//endt. posting limit field observer
	$("txtEndtPostingLimit").observe("change", function() {
		if ($("txtEndtPostingLimit").value != "") {
			validatePostingLimit($("txtEndtPostingLimit"), $("hidLastValidEndtPostingLimit"), "txtEndtPostingLimit");
		}
	});
	
	$("txtEndtPostingLimit").observe("blur", function() {
		if ($("txtEndtPostingLimit").value != "") {
			validatePostingLimit($("txtEndtPostingLimit"), $("hidLastValidEndtPostingLimit"), "txtEndtPostingLimit");
		}
	});
 	
	//global
 	objGiiss207.createPostLimitObj = createPostLimitObj;
	
</script>