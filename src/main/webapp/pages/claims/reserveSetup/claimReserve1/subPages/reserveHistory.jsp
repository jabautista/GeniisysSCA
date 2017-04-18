<div>
	<!-- <div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Reserve History</label> 
			<span class="refreshers" style="margin-top: 0;"> 
			<label name="gro"style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div> -->
	<div class="sectionDiv" id="claimReserveHistorySectionDiv">
		<div id="reserveHistoryTGDiv" name="reserveHistoryTGDiv" style="height: 170px; width: 99%; padding: 10px 0 0 10px;">
		</div>
		<div style="margin-top: 10px; margin-left:80px; float: left; width: 750px;  ">
			<table align="center" border="0">
				<tr>
					<td class="rightAligned"  width="90px">History Number</td>
					<td class="leftAligned"><input type="text" style="width: 258px;" id="txtHistoryNumber" name="txtHistoryNumber" readonly="readonly" value="" class="rightAligned"/></td>
					<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="150px">Booking Date</td>
					<td class="leftAligned">
						<div style="width:250px; border: none;">
							<input type="text" style="width: 140px;" id="txtBookingMonth" name="txtBookingMonth" value="" readonly="readonly" class="upper" maxlength="10"/>
							<input type="text" style="width: 65px;" id="txtBookingYear" name="txtBookingYear" value="" class="rightAligned integerNoNegativeUnformattedNoComma" readonly="readonly" maxlength="4"/>
							<input type="hidden">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="bookDateLOV" name="bookDateLOV" alt="Go" style="margin-top: 2px; float: right;" title="Search Booking Date"/>
						</div>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Convert Rate</td>
					<td class="leftAligned">
						<div>
							<input type="text" style="width: 100px; float: left;" id="txtConvertRate" name="txtConvertRate" readonly="readonly" value="" class="moneyRate"/>
							<label id="lblCurrency" style="float: left; font-weight: bolder; margin-top: 5px; margin-left: 2px;">&nbsp;</label>
						</div>
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned"><label id="lblDistType" style="float: right; font-weight: bolder;">&nbsp;</label></td>
				</tr>
				<tr>
					<td class="rightAligned"  width="220px">Remarks</td>
					<td class="leftAligned" colspan="3"  width="600px">
						<div style="border: 1px solid gray; height: 20px; width: 100%" changeTagAttr="true">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 95.5%; border: none; height: 13px;" readonly="readonly"></textarea>
							<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div id="reserveHistoryButtonsDiv" name="reserveHistoryButtonsDiv" class="buttonsDiv" style="margin-bottom: 15px;">
			<input id="btnUpdateRsrvHist" name="btnUpdateRsrvHist" type="button" class="button" value="Update" >
		</div>
	</div>
</div>

<script type="text/javascript">

	initializeAll();
	disableSearch("bookDateLOV");
	$("editRemarks").hide();
	disableButton("btnUpdateRsrvHist");
	
	var selectedRsrvHistRow = new Object();
	var selectedRsrvHist = null;
	
	var objRsrvHist = new Object();
	objRsrvHist.objRsrvHistTableGrid = {};
	try{
		var reserveHistTableModel = {
			options: {
				id: 2,
				title: '',
	          	height: '150px',
	          	width: '900px',
	          	hideColumnChildTitle: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		reserveHistTableGrid.keys.releaseKeys();
	          		selectedRsrvHist = y;
	          		selectedRsrvHistRow = reserveHistTableGrid.geniisysRows[y];
	          		objCurrGICLClmResHist = selectedRsrvHistRow;
	          		objGICLS024.setClmResHistory(selectedRsrvHistRow);
	            },
	            onRemoveRowFocus: function(){
	            	reserveHistTableGrid.keys.releaseKeys();
	            	objGICLS024.setClmResHistory(null);
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh : function() {
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
						{	id: 'histSeqNo',
							title: 'History Number',
							width: '100px',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							type: 'number',
							renderer : function(value){
								return lpad(value.toString(), 3, "0");					
							}
						},
						{
							id : 'bookingMonth bookingYear',
							title : 'Booking Date',
							width : '180px',
							sortable : false,					
							children : [
								{
									id : 'bookingMonth',							
									width : 120,							
									sortable : false,
									editable : false
								},
								{
									id : 'bookingYear',							
									width : 60,
									sortable : false,
									editable : false,
									align: 'right'
								}
							]					
						},
						{	id: 'dspCurrencyDesc',
							title: 'Currency',
							width: '180px',
							filterOption: true
						},
						{	id: 'convertRate',
							title: 'Convert Rate',
							width: '130px',
							geniisysClass: 'rate',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'remarks',
							title: 'Remarks',
							width: '270px',
							filterOption: true
						}
						],  				
					rows: []
		};
		reserveHistTableGrid = new MyTableGrid(reserveHistTableModel);
		reserveHistTableGrid.pager = objRsrvHist.objRsrvHistTableGrid;
		reserveHistTableGrid.render('reserveHistoryTGDiv');
		reserveHistTableGrid.afterRender = function(){
			if(objGICLClaims.lineCd == "SU" && objGICLS024.SU.initial){
				objGICLS024.SU.initial = false;
				reserveHistTableGrid._refreshList();
			};
		};
	}catch(e){
		showMessageBox("Error in Peril Information TableGrid: " + e, imgMessage.ERROR);
	}
	
	function createRsrvHistDtls(){
		try {	
			var obj 								= selectedRsrvHistRow;
			obj.recordStatus 				= 1;
			obj.bookingMonth			= $F("txtBookingMonth");
			obj.bookingYear				= $F("txtBookingYear");
			obj.dspBookingDate		= $F("txtBookingMonth")+" - " +$F("txtBookingYear");; 
			obj.remarks						= $F("txtRemarks");
			return obj;
		} catch (e){
			showErrorMessage("createItemInfoDtls", e);
		}			
	}

	$("btnUpdateRsrvHist").observe("click", function(){
		var item = createRsrvHistDtls();		
		reserveHistTableGrid.updateRowAt(item, selectedRsrvHist);
		objGICLS024.setClmResHistory(null);
	});
	
	function getBookingDate(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getBookingDateLOV",
					claimId : objGICLClaims.claimId,
					page : 1			
				},
				title: "Select Booking Month and Year",
				width : 370,
				height : 350,
				columnModel : [
				               {
				            	   id : "bookingMonth",
				            	   title : "Month",
				            	   width : '200px'
				               },
				               {
				            	   id : "bookingYear",
				            	   title : "Year",
				            	   width : '100px'
				               }
				              ],
				draggable : true,
				onSelect : function(row){
					$("txtBookingYear").value	= row.bookingYear;
					$("txtBookingMonth").value	= unescapeHTML2(row.bookingMonth);
				},
				onCancel: function(){
					$("txtBookingMonth").focus();
				}
			});
		}catch(e){
			showErrorMessage("getEngineSeriesAdverseLOV", e);
		}
	}
	
	function validateBookingDate(func){
		new Ajax.Request(contextPath+"/GIACTranMmController", {
			method: "POST",
			parameters: {action : "checkBookingDate",
									   claimId : objGICLClaims.claimId,
									   bookingYear : func == "year" ? $F("txtBookingYear") : "",
									   bookingMonth : $F("txtBookingMonth")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var valid = response.responseText;
						if(func == "month"){
							if(valid=="N"){
								showWaitingMessageBox("Invalid Booking Month.", "I", getBookingDate);
							}
						}else{
							if(valid=="N"){
								showWaitingMessageBox("Invalid Booking Year.", "I", getBookingDate);
							}
						}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("bookDateLOV").observe("click",getBookingDate);
	$("txtBookingMonth").observe("blur", function(){		
		if($("txtBookingMonth").getAttribute("readonly") != "readonly"){
			validateBookingDate("month");
		}
	});
	
	$("txtBookingYear").observe("blur", function(){
		if($("txtBookingYear").getAttribute("readonly") != "readonly"){
			validateBookingDate("year");
		}
	});

</script>