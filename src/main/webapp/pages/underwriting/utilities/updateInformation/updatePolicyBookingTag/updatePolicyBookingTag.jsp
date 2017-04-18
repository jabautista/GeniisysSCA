<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="updatePolicyBookingTagMainDiv" name="updatePolicyBookingTagMainDiv">
	<div id="uwReportsMenuDiv" name="uwReportsMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit" name="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Update Booking Tag</label>
			<span class="refreshers" style="margin-top: 0px	;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="bookingTagDiv" name="bookingTagDiv" style="height: 600px;">
		<div id="policyBooking" name="policyBooking" class="sectionDiv" style="height: 540px;">
			<div id="policyBookingTG" name="policyBookingTG" style="margin: 10px 25px 30px 140px; height: 306px;"></div>
			
			<div id="policyBookingInfoDiv" name="policyBookingInfoDiv" style="height: 130px; width: 94%; float: left; padding: 12px 0px 0px 25px; margin: 5px 0px 15px 0px;">
				<!-- commented out by shan 11.14.2013
				<label style="padding-top: 3px;">User ID:</label>
				<input id="txtUserId" name="txtUserId" type="text" style="width: 100px; float: left; margin: 0px 25px 0px 5px;" readonly="readonly">
				<label style="padding-top: 3px;">Last Update:</label>
				<input id="txtLastUpdate" name="txtLastUpdate" type="text" style="width: 100px; float: left; margin: 0px 25px 0px 5px;" readonly="readonly">  -->
				<table style="margin: 10px 0 0 120px;">
					<tr>
						<td class="rightAligned">Booking Month</td>
						<td class="leftAligned">
							<input id="txtBookingMth" type="text" readonly="readonly" style="width: 170px;" tabindex="201" >
						</td>
						<td class="rightAligned">Booking Year</td>
						<td class="leftAligned" colspan="2">
							<input id="txtBookingYear" type="text" class="rightAligned" readonly="readonly" style="width: 80px; text-align: right; float: left;" tabindex="202" >					
							<input id="chkBookedTag" type="checkbox" style="float: left; margin: 5px 7px 0 25px;"><label for="chkBookedTag" style="margin: 5px 4px 2px 2px;">Booked Tag</label>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 510px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 484px; margin-top: 0; border: none; resize: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 170px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned" style="padding-left: 45px;" colspan="2">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>	
				</table>
				
				<div align="center" style="margin-top: 5px;">
					<input id="btnUpdate" type="button" class="button" value="Update" tabindex="207">					
				</div>
				
				<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
					<input id="btnGenBookingMonths" name="btnGenBookingMonths" type="button" class="button" value="Generate Booking Months" style="width: 200px;" tabindex="208">
				</div>
			</div>
		</div>
	</div>
	
	<div id="buttonsDiv" name="buttonsDiv" align="center" class="buttonsDiv" style="">
		<input id="btnCancel" name="btnCancel" type="button" class="button" value="Cancel" style="width: 100px;" tabindex="208">
		<input id="btnSave" name="btnSave" type="button" class="button" value="Save" style="width: 100px;" tabindex="209">			
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIPIS162");
	setDocumentTitle("Enter Booking Details");
	changeTag = 0;
	initializeAccordion();
	
	var exitPage = "";
	
	var selectedIndex = -1;
	var selectedRowInfo = null;
	objUW.hideGIPIS162 = {};
	
	var objBooking = new Object();
	objBooking.bookingTableGrid = JSON.parse('${bookingGrid}'.replace(/\\/g, '\\\\'));
	objBooking.bookingObjRows = objBooking.bookingTableGrid.rows || [];
	objBooking.bookingList = [];
	
	try{
		var bookingTableModel = {
			url: contextPath+"/UpdateUtilitiesController?action=getGipis162BookingList",
			options: {
				width: '620px',
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = bookingListingTableGrid.geniisysRows[y];
					objUW.hideGIPIS162.bookingMth = selectedRowInfo.bookingMth;
					objUW.hideGIPIS162.bookingYear = selectedRowInfo.bookingYear;
					populateBookingInfo(selectedRowInfo); //marco - 05.06.2013
					$("txtRemarks").focus();
					bookingListingTableGrid.keys.releaseKeys();
				},
				onCellBlur: function(element, value, x, y, id){
					/*var origYy = bookingListingTableGrid.getValueAt(bookingListingTableGrid.getColumnIndex('origBookingYy'), y);
					var bookingYear = bookingListingTableGrid.getValueAt(bookingListingTableGrid.getColumnIndex('bookingYear'), y);
					
					if (origYy != bookingYear){
						chkBookingMthYear(y);
					}*/ 	// shan 10.04.2013
					observeChangeTagInTableGrid(bookingListingTableGrid);
				},
				onRemoveRowFocus: function(){
					//bookingListingTableGrid.keys.releaseKeys();	//shan 10.04.2013
					selectedIndex = -1;
					selectedRowInfo = "";
					populateBookingInfo(false); //marco - 05.06.2013
				},
				onSort: function(){
					bookingListingTableGrid.onRemoveRowFocus();
				},
				beforeSort: function(){ 	//shan 10.04.2013
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						bookingListingTableGrid.onRemoveRowFocus();
					}
				},
				prePager: function(){ 	//shan 10.04.2013
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						bookingListingTableGrid.onRemoveRowFocus();
					}
				},
				checkChanges: function(){ 	//shan 10.04.2013
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
						bookingListingTableGrid.onRemoveRowFocus();
					},
					onRefresh: function(){
						bookingListingTableGrid.onRemoveRowFocus();
					},
					onSave: function(){ //marco - 05.07.2013 
						bookingListingTableGrid.keys.releaseKeys();	//shan 10.04.2013
						updateBookingTag();
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
								id: 'bookingMth',
								title: 'Booking Month',
								titleAlign: 'center',
								width: '150px',
								maxlength: 10,
								filterOption: true
							},
							{
								id: 'origBookingYy',
								width: '0px',
								visible: false
							},
							{
								id: 'bookingYear',
								title: 'Booking Year',
								titleAlign: 'center',
								width: '130px',
								maxlength: 4,
								//editable: true, //marco - 05.07.2013 - as per SR 12969, confirmed with QA
								filterOption: true,
								filterOptionType: 'integerNoNegative', //marco - 05.07.2013
								geniisysClass: 'integerNoNegativeUnformattedNoComma',
								geniisysErrorMsg: 'Invalid input.',
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var coords = bookingListingTableGrid.getCurrentPosition();
										var x = coords[0]*1;
										var y = coords[1]*1;
										var origYy = bookingListingTableGrid.getValueAt(bookingListingTableGrid.getColumnIndex('origBookingYy'), y);
										
										if (value == "" || value == null){
											showMessageBox("Field must be entered.", "E");
											bookingListingTableGrid.setValueAt(origYy, x, y);
											return false;
										}else{
											return true;											
										}
									}
								})
							},
							{
								id: 'remarks',
								title: 'Remarks',
								titleAlign: 'center',
								width: '285px',
								maxlength: 4000,
								sortable: false,
								//editable: true,	//shan 11.15.2013
								renderer : function(value){ 
									return escapeHTML2(value);
								},
								/*editor: new MyTableGrid.EditorInput({
									onClick: function(){
										var coords = bookingListingTableGrid.getCurrentPosition();
										var x = coords[0];
										var y = coords[1];
										var title = "Remarks ("+bookingListingTableGrid.geniisysRows[y].bookingMth+" "+
														bookingListingTableGrid.geniisysRows[y].bookingYear+")";
											showTableGridEditor(bookingListingTableGrid, x, y, title, 4000, false);
										}
									})	*/							
							},
							{
								id: 'bookedTag',
								title: 'T',
								altTitle: 'Booked Tag',
								titleAlign: 'center',
								align: 'center',
								width: '35px',
								//editable: true,	//shan 11.15.2013
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
								width: '0px',
								visible: false
							},
							{
								id: 'lastUpdate',
								width: '0px',
								visible: false
							}
							
						],
						resetChangeTag: true,
						rows: objBooking.bookingObjRows
		};
		
		bookingListingTableGrid = new MyTableGrid(bookingTableModel);
		bookingListingTableGrid.pager = objBooking.bookingTableGrid;
		bookingListingTableGrid.render('policyBookingTG');
		bookingListingTableGrid.afterRender = function(){
			objBooking.bookingList = bookingListingTableGrid.geniisysRows;
			changeTag = 0;
		};
	}catch(e){
		showMessageBox("Error in Policy Booking table grid: "+ e, imgMessage.ERROR);
	}

	
	$("btnGenBookingMonths").observe("click", function(){
		if(changeTag == 1){ //marco - 05.07.2013
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genBookingMthOverlay = Overlay.show(contextPath+"/UpdateUtilitiesController",{
				urlContent: true,
				urlParameters: {
					action:	"showGenerateBookingMthPopup"
				},
				title: "Generate Booking Months",
				width: 330,
				height: 120,
				draggable: true
			});
		}
	});
	
	$("btnSave").observe("click", function(){
		if(changeTag == 1){
			exitPage = "";
			updateBookingTag(true);	
		}else{
			showMessageBox("No changes to save.", "I");
		}
		
	});
	
	$("btnCancel").observe("click", function(){
		bookingListingTableGrid.keys.removeFocus(bookingListingTableGrid.keys._nCurrentFocus, true);
		bookingListingTableGrid.keys.releaseKeys();
		
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						exitPage = exitModule;
						updateBookingTag();
					},
					function(){	
						changeTag = 0;
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					},
					""
			);
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		}
	});
	
	$("btnExit").observe("click", function(){
		/*if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						exitPage = exitModule;
						updateBookingTag();
					},
					function(){
						changeTag = 0;
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
					},
					""
			);
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}*/
		fireEvent($("btnCancel"), "click");
	});
	
	
	function chkBookingMthYear(y){
		try{
			var bookingMth = bookingListingTableGrid.getValueAt(bookingListingTableGrid.getColumnIndex('bookingMth'), y);
			var bookingYear = bookingListingTableGrid.getValueAt(bookingListingTableGrid.getColumnIndex('bookingYear'), y);
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "GET",
				parameters: {
					action:		 "chkBookingMthYear",
					bookingMth:	 bookingMth,
					bookingYear: bookingYear
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == "Y"){
						var origYy = bookingListingTableGrid.getValueAt(bookingListingTableGrid.getColumnIndex('origBookingYy'), y);
						showMessageBox(bookingMth + " " + bookingYear + " already exists.", "E");
						bookingListingTableGrid.setValueAt(origYy, bookingListingTableGrid.getColumnIndex('bookingYear'), y);
					}
				}
			});
		}catch(e){
			showErrorMessage("chkBookingMthYear", e);
		}
	}
	
	function updateBookingTag(update){
		try{
			var objBookings = getAddedAndModifiedJSONObjects(bookingListingTableGrid.geniisysRows); //bookingListingTableGrid.getModifiedRows();
			//shan 05.28.2013 as per SR-13175
			for (var i=0; i < objBookings.length; i++){
				if (objBookings[i].remarks != "" && objBookings[i].remarks != null){
					objBookings[i].remarks = changeSingleAndDoubleQuotes2(objBookings[i].remarks);
				}				
			} 
			// end SR-13175
			var strParams = prepareJsonAsParameter(objBookings);
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				methos: "GET",
				parameters: {
					action:		"updateGiisBookingMonth",
					bookings: 	strParams
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: showNotice("Updating Booking Months..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Success"){
							changeTag = 0;
							bookingListingTableGrid.refresh();
							bookingListingTableGrid.onRemoveRowFocus();
							
							var message = "";
							if (update){
								message = "Update successful.";
							}else{
								message = objCommonMessage.SUCCESS;
							}
							showWaitingMessageBox(message, "S", function(){
								if (exitPage != ""){
									exitPage();
								}
							});
							/*bookingListingTableGrid.url = contextPath+"/UpdateUtilitiesController?action=getGipis162BookingList";
							bookingListingTableGrid.refreshURL(bookingListingTableGrid);*/  	//shan 10.04.2013							
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("updateBookingTag", e);
		}
	}
	
	function setRec(rec){	//shan 11.15.2013
		try {
			var obj = (rec == null ? {} : rec);
			obj.bookingMth = $F("txtBookingMth");
			obj.bookingYear = $F("txtBookingYear");
			obj.bookedTag = $("chkBookedTag").checked ? "Y" : "N";
			obj.remarks = $F("txtRemarks");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');

			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function updateRec(){
		try {
			if (checkAllRequiredFieldsInDiv('policyBookingInfoDiv')){
				changeTagFunc = updateBookingTag;
				var booking = setRec(selectedRowInfo);
				bookingListingTableGrid.updateVisibleRowOnly(booking, selectedIndex);
				changeTag = 1;
				populateBookingInfo(false);
				bookingListingTableGrid.keys.removeFocus(bookingListingTableGrid.keys._nCurrentFocus, true);
				bookingListingTableGrid.keys.releaseKeys();
			}				
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}	
	
	//marco - 05.06.2013
	function populateBookingInfo(populate){
		$("txtUserId").value = populate ? selectedRowInfo.userId : "";
		$("txtLastUpdate").value = populate ? dateFormat(selectedRowInfo.lastUpdate, 'mm-dd-yyyy') : "";
		//shan 11.15.2013
		$("txtBookingMth").value = populate ? selectedRowInfo.bookingMth : "";
		$("txtBookingYear").value = populate ? selectedRowInfo.bookingYear : "";
		$("chkBookedTag").checked = populate ? (selectedRowInfo.bookedTag == "Y" ? true : false) : false;
		$("txtRemarks").value = populate ? unescapeHTML2(selectedRowInfo.remarks) : "";
		populate ? enableButton("btnUpdate") : disableButton("btnUpdate");
		populate ? $("chkBookedTag").disabled = false : $("chkBookedTag").disabled = true;
		populate ? $("txtRemarks").readOnly = false : $("txtRemarks").readOnly =  true;
	}
	
	function exitModule(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("btnUpdate").observe("click", updateRec);
	
	initializeChangeTagBehavior(updateBookingTag);	//shan 10.04.2013
	populateBookingInfo(false);	//shan 11.15.2013
</script>
