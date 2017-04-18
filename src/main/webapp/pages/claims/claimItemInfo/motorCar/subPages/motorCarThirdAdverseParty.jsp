<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<div id="thirdAdverseInfoDiv" class="sectionDiv" >
	<input type="hidden" value="${itemNo }" id="itemNo"/> 
	<!-- <div id="thirdAdverseInfoGrid" style="width: 720px; padding: 10px; height: 305px;">
	</div> -->
	<div id="thirdAdverseInfoGrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 740px;"> </div>
	<div style="margin-top: 30px;">
		<table border="0"  align="center">
			<tr>
				<td class="rightAligned">Third/Adverse Party</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
						<input id="payeeClassCd" type="hidden" value=""/>
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="payeeClass" name="payeeClass" type="text" value="${details.sendToCd}" readonly="readonly" class="required"/>
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="payeeClassGo" name="payeeClassGo" alt="Go" />
			    	</div>	
					<div style="border: 1px solid gray; width: 276px; height: 21px; float: left; margin-right: 3px;">
						<input type="hidden" id="payeeNo" value=""/>
			    		<input style="float: left; border: none; margin-top: 0px; width: 250px;" id="payee" name="payee" type="text" value="${assuredName}" readonly="readonly" class="required"/>
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="payeeGo" name="payeeGo" alt="Go" />
			    	</div>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Address</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 456px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 430px; border: none; height: 13px;" id="payeeAddress" name="payeeAddress" readonly="readonly" ignoreDelKey="1"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editPayeeAddress" id="editPayeeAddress" />
					</div>
					<!-- <input style="width: 300px;" value="" id="payeeAddress" name="payeeAddress"> -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Type</td>
				<td class="leftAligned">
					<select id="tpTypeOpt" name="tpTypeOpt" style="width: 200px;" class="required">
						<option></option>
						<option value="T">Third Party</option>
						<option value="A">Adverse Party</option>
						<option value="B">Bodily Injured Third Party</option>
						<option value="P">Property Damage Third Party</option>
					</select>
				</td>
			</tr>
		</table>
		
		<div class="" style="margin: 10px 10px;">
			<input type="button" id="btnAdd"	name="btnAdd" class="button hover"	value="Add"/>
			<input type="button" id="btnDelete" name="btnDelete" style="width: 90px;" class="button hover"   value="Delete" />
		</div>
	</div>
	<div id="lowerSection" style="display: none;">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
				<div id="innerDiv" name="innerDiv">
					<label id="lowerSectionLabel"></label>
					<span class="refreshers" style="margin-top: 0;">
						<label id="gro" name="gro" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>
		<div id="otherDetailsDiv" name="otherDetailsDiv" class="sectionDiv" style="margin: 0px; width: 100%; display: none;"> <!--  changeTagAttribute="true" -->
			<table border="0" style="margin-top: 10px; margin-bottom: 10px;" align="center"> 
				<tr>
					<td class="rightAligned" >Owner</td>
					<td class="leftAligned"  style="width: 300px;"; colspan="3">
						<input type="text" id="detClassName" value="" style="width: 65px; text-align: right;" readonly="readonly">
						<input type="text" id="detPayee"  value="" style="width: 200px;" readonly="readonly">
					</td>
					<td class="rightAligned" >Basic Color</td>
					<td class="leftAligned" colspan="1">
						<input type="hidden" id="detBasicColorCd" value=""/>
						<!-- <input type="text" id="detBasicColor" name="detBasicColor" value="" style="width: 200px;" readonly="readonly"> -->
						<div style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 180px;" id="detBasicColor" name="detBasicColor" type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detBasicColorGo" name="detBasicColorGo" alt="Go" />
				    	</div>	
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" >Plate No.</td>
					<td class="leftAligned"  >
						<input type="text" id="detPlateNo" name="detPlateNo" value="" class="upper" style="width: 90px; float: left;" maxlength="10">
					</td>
					<td class="rightAligned" >Model Year</td> <!--modified class of Model Year label from leftAligned to rightAligned to have the same font size as other labels by MAC 07/18/2013-->
					<td>
						<input type="text" id="detModelYear" name="detPlateNo" value="" style="width: 90px; float: left;" maxlength="4" class="integerUnformatted">	<!--modified class of Model Year from integerNoNegative to integerUnformatted to allow it to accept number inputs only by MAC 07/12/2013.-->	
					</td>
					<td class="rightAligned">Color</td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 180px;" id="detColor"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detColorGo" alt="Go" />
				    	</div>	
						<input type="hidden" id="detColorCd" name="detColor" value="" >
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" >Motor No.</td>
					<td class="leftAligned" colspan="3" >
						<input type="text" id="detMotorNo" name="detMotorNo" class="upper" value="" style="width: 278px; float: left;" maxlength="30">
					</td>
					<td class="rightAligned" >Car Company</td>
					<td class="leftAligned" colspan="3" >
						<input type="hidden" id="detCarCompanyCd" name="detCarCompanyCd" value="">
						<div style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 180px;" id="detCarCompany"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detCarCompanyGo" alt="Go" />
				    	</div>	
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Serial No.</td>
					<td class="leftAligned" colspan="3" >
						<input type="text" id="detSerialNo" name="detSerialNo" class="upper" value="" style="width: 278px; float: left;" maxlength="25">
					</td>
					<td class="rightAligned" >Make</td>
					<td class="leftAligned" colspan="3" >
						<div style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 180px;" id="detMake"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detMakeGo" alt="Go" />
				    	</div>	
						<input type="hidden" id="detMakeCd" name="detMakeCd" value="" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Motor Type</td>
					<td class="leftAligned" colspan="3" >
						<div style="border: 1px solid gray; width: 284px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 258px;" id="detMotorTypeDesc"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detMotorTypeDescGo" alt="Go" />
				    	</div>
						<!-- <input type="text" id="detMotorTypeDesc" name="detMotorTypeDesc" value="" style="width: 278px; float: left;" readonly="readonly"/> -->
						<input type="hidden" id="detTypeCd" />
					</td>
					<td class="rightAligned" >Engine Series</td>
					<td class="leftAligned" colspan="3" >
						<div style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 180px;" id="detEngineSeries"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detEngineSeriesGo" alt="Go" />
				    	</div>
						<input type="hidden" id="detSeriesCd" name="detSeriesCd" value="" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Other Info</td>
					<td class="leftAligned" colspan="7" > <!-- 2000 max lenght -->
					<div style="border: 1px solid gray; height: 20px; width: 576px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 430px; border: none; height: 13px;" id="detOtherInfo" name="detOtherInfo"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editDetOtherInfo" id="editDetOtherInfo" />
					</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >TP Insurer</td>
					<td class="leftAligned"  style="width: 497px;"; colspan="8">
						<input type="text" id="detRiCd" value="" style="width: 65px; text-align: right; float: left;" readonly="readonly">
						<div style="border: 1px solid gray; height: 21px; width: 497px;  float: left; margin-left: 5px; margin-top: 2px;">
				    		<input style="float: left; border: none; height: 15px; width: 470px;  margin-top: 0px;" id="detRiName"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detRiNameGo" alt="Go" />
				    	</div>	
						<!-- <input type="text" id="detRiName"  value="" style="width: 497px;" readonly="readonly"> -->
					</td>
				</tr>	
				
			</table>
			<table border="0" style="margin-top: 10px; margin-bottom: 10px;" align="center"> 
				<tr>
					<td class="rightAligned" >Driver Name</td>
					<td class="leftAligned"  style="width: 300px;"; colspan="1">
						<input type="text" id="detDriverName" value="" style="width: 278px; text-align: left;" class="upper" maxlength="100">
					</td>
					<td class="rightAligned" >Age</td>
					<td class="leftAligned" colspan="1">
						<input type="text" id="detDriverAge" name="detDriverAge" value="" style="width: 120px;" maxlength="2" class="integerNoNegative" errorMsg="Invalid Age. Valid value should be from 0 to 99.">
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Occupation</td>
					<td class="leftAligned"  style="width: 300px;"; colspan="1"><!-- lov to -->
						<div style="border: 1px solid gray; width: 284px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 258px;" id="detDriverOccupation"  type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detDriverOccupationGo" alt="Go" />
				    	</div>
						<input type="hidden" id="detDriverOccupationCd" value="" style="width: 278px; text-align: left;" readonly="readonly">
					</td>
					<td class="rightAligned"  width="150px;">Driving Experience</td>
					<td class="leftAligned" >
						<input type="text" id="detDrivingExperience" name="detDrivingExperience" value="" style="width: 120px;" maxlength="3" class="integerNoNegative" errorMsg="Invalid Driving Experience. Valid value should be from 0 to 999.">
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Address</td> <!-- 100 -->
					<td class="leftAligned"  style="width: 300px;"; colspan="1"><!-- lov to -->
						 <div style="border: 1px solid gray; height: 20px; width: 285px;">
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 250px; border: none; height: 13px;" id="detDriverAddress" name="detDriverAddress"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editDetDriverAddress" id="editDetDriverAddress" />
						</div>
					</td>
					<td class="rightAligned" >Sex</td>
					<td class="leftAligned" >
						<select id="detDriverSex" style="width: 128px">
							<option></option>
							<option value="M">Male</option>
							<option value="F">Female</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="1" width="300px;"><td>
					<td class="rightAligned" >Nationality</td> <!-- 100 -->
					<td class="leftAligned"  style="width: 250px;"; colspan="1"><!-- lov to -->
						<input type="hidden" id="detNationalityCd" value="" style="width: 101px; text-align: left;" >
						<div style="border: 1px solid gray; width: 126px; height: 21px; float: left; margin-right: 3px;">
				    		<input style="float: left; border: none; margin-top: 0px; width: 100px;" id="detNationalityDesc" name="detDriverNationalityDesc" type="text" value="" readonly="readonly" />
				    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="detNationalityDescGo" name="detDriverNationalityDescGo" alt="Go" />
				    	</div>
					</td>
				</tr>
			</table>	
		</div>
	</div>	
</div>

<div class="buttonsDiv">
	<input type="button" id="btnSave"	name="btnSave" class="button hover"	value="Save"/>
	<input type="button" id="btnReturn" name="btnReturn" style="width: 90px;" class="button hover"   value="Return" />
	<input type="button" id="btnMaintainTpClaimant" name="btnMaintainTpClaimant" style="width: 150px;" class="button hover"   value="Maintain TP Claimant" />
</div>

<script type="text/javascript">
	disableButton("btnDelete");
	try{
		$("btnMaintainTpClaimant").observe("click",function(){
			objCLMGlobal.callingForm = "GICLS014";
			showMenuClaimPayeeClass(null, null);
		});
		changeTag = 0;
		var objMcTpDtlGrid = JSON.parse('${giclMcTpDtlGrid}'.replace(/\\/g, '\\\\'));
		function setTpType(){
			for ( var i = 0; i < mcTpDtlGrid.rows.length; i++) {
				var tpType = mcTpDtlGrid.getValueAt(mcTpDtlGrid.getColumnIndex("tpType"),i);
				var mtgId = mcTpDtlGrid._mtgId;
				if("T" == tpType){
					$('mtgInput'+mtgId+'_'+mcTpDtlGrid.getColumnIndex("thirdParty")+','+i).checked = true;
				}else if("A" == tpType){
					$('mtgInput'+mtgId+'_'+mcTpDtlGrid.getColumnIndex("adverseParty")+','+i).checked = true;
				}else if("B" == tpType){
					$('mtgInput'+mtgId+'_'+mcTpDtlGrid.getColumnIndex("bodilyInjuredThirdParty")+','+i).checked = true;
				}else if("P" == tpType){
					$('mtgInput'+mtgId+'_'+mcTpDtlGrid.getColumnIndex("propertyDamageThirdParty")+','+i).checked = true;
				} 
			}
		}
		
		var mcTpDtlIndex = null;
		var tableModel = {
			url: contextPath+"/GICLMotorCarDtlController?action=getGiclMcTpDtl&claimId="+objCLMGlobal.claimId+"&itemNo="+objCLMItem.selected[itemGrid.getColumnIndex('itemNo')]
						+"&sublineCd="+objCLMGlobal.sublineCd+"&refresh=1",
			options:{
				//height: '305px',
				hideColumnChildTitle: true,
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){
					mcTpDtlIndex = y;
					if(y < 0){
						populationThirdAverseDetails(mcTpDtlGrid.newRowsAdded[Math.abs(y)-1]);
					}else{
						populationThirdAverseDetails(mcTpDtlGrid.rows[y]);	
					}
					//enableButton("btnThirdAverseParty"); 
					observeChangeTagInTableGrid(mcTpDtlGrid);
					mcTpDtlGrid.releaseKeys();
				},
				onCellBlur : function(element, value, x, y, id) {
					observeChangeTagInTableGrid(mcTpDtlGrid);
				},onRemoveRowFocus: function(){
					mcTpDtlIndex = null;
					populationThirdAverseDetails(null);
					//disableButton("btnThirdAverseParty");
				},toolbar: {

				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{
					id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					title: '&#160;D',
				 	altTitle: 'Delete?',
				 	titleAlign: 'center',
					width: 19,
					sortable: false,
				 	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
				  	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
				 	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
						editor: 'checkbox',
				 	hideSelectAllBox: true,
				 	visible: false 
				},
				{
					id: 'divCtrId',
				  	width: '0',
				  	visible: false 
				},
				{
					id: 'claimId',
				  	width: '0',
				  	visible: false 
				},
				{
					id: 'payeeClassCd',
				  	width: '0',
				  	visible: false 
				},{
					id: 'payeeNo',
				  	width: '0',
				  	visible: false 
				},{
					id: 'tpType',
				  	width: '0',
				  	visible: false 
				},{
					id: 'classDesc payeeDesc',
					title: 'Third Party/Adverse Party',
					titleAlign : 'center',
					width: 300,
					sortable: true,
					align : 'center',
					children: [
						{
							id : 'classDesc',
							width: 100,
							visible: true,
							maxlength: 10,
							editable: false
						},{
							id : 'payeeDesc',
			                width :200,
			                editable: false,
			                sortable: false		
						}           
					]
				},{
					id : 'dspPayeeAdd',//'drvrAdd', changed by Gzelle 09032014
	                width : 250,
	                title: 'Address',
	                editable: false,
	                sortable: true		
				},{
					id:"thirdParty",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;T',
					altTitle: 'Third Party',
					width: '23px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "T";
							} /* else {
								return "N";
							} */
						}
					})
				},{
					id:"adverseParty",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;A',
					altTitle: 'adverseParty',
					width: '23px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "A";
							} /* else {
								return "N";
							} */
						}
					})
				},{
					id:"bodilyInjuredThirdParty",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;B',
					altTitle: 'Bodily Injured Third Party',
					width: '23px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "B";
							} /* else {
								return "N";
							} */
						}
					})
				},{
					id:"propertyDamageThirdParty",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;P',
					altTitle: 'Property Damage Third Party',
					width: '23px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "P";
							} /* else {
								return "N";
							} */
						}
					})
				},{
					id : 'colorCd',
					width: '0',
				  	visible: false 
				},{
					id : 'colorDesc',
					width: '0',
				  	visible: false 
				},{
					id : 'basicColorDesc',
					width: '0',
				  	visible: false 
				},{
					id : 'basicColorCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'motorNo',
					width: '0',
				  	visible: false 	
				},{
					id : 'plateNo',
					width: '0',
				  	visible: false 	
				},{
					id : 'modelYear',
					width: '0',
				  	visible: false 	
				}
				,{
					id : 'serialNo',
					width: '0',
				  	visible: false 
				},{
					id : 'carComDesc',
					width: '0',
				  	visible: false 		
				},{
					id : 'motorcarCompCd',
					width: '0',
				  	visible: false 
				},{
					id : 'makeCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'makeDesc',
					width: '0',
				  	visible: false 	
				},{
					id : 'engineSeries',
					width: '0',
				  	visible: false 	
				},{
					id : 'seriesCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'motType',
					width: '0',
				  	visible: false 	
				},{
					id : 'motorTypeDesc',
					width: '0',
				  	visible: false 	
				},{
					id : 'otherInfo',
					width: '0',
				  	visible: false 	
				},{
					id : 'riCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'riName',
					width: '0',
				  	visible: false 	
				},{             
					id : 'drvrOccDesc',
					width: '0',
				  	visible: false 	
				},{
					id : 'drvrOccCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'drvrName',
					width: '0',
				  	visible: false 	
				},{
					id : 'drvrAge',
					width: '0',
				  	visible: false 	
				},{
					id : 'drvrSex',
					width: '0',
				  	visible: false 	
				},{
					id : 'drvngExp',
					width: '0',
				  	visible: false 	
				} ,{
					id : 'nationalityDesc',
					width: '0',
				  	visible: false 	
				},{
					id : 'nationalityCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'newPayeeClassCd',
					width: '0',
				  	visible: false 	
				},{
					id : 'newPayeeNo',
					width: '0',
				  	visible: false 	
				},{
					id : 'drvrAdd',
					width: '0',
				  	visible: false 	
				}      
			],
			resetChangeTag: true,
			requiredColumns: '',
			rows : objMcTpDtlGrid.rows
		};
		mcTpDtlGrid = new MyTableGrid(tableModel);
		mcTpDtlGrid.pager = objMcTpDtlGrid;
		mcTpDtlGrid.render('thirdAdverseInfoGrid');	
		mcTpDtlGrid.afterRender = setTpType;
		
		$("tpTypeOpt").observe("change",function(){
			/*disallow showing of Third/Adverse Party other details if Payee is not yet added by MAC 07/18/2013.
			var tpType = $("tpTypeOpt").options[$("tpTypeOpt").options.selectedIndex].value;
			if (tpType == "T" || tpType == "A") {
				Effect.Appear("lowerSection", {
					duration: .2
				});
			}else{*/
				fadeElement("lowerSection",.2,null);
				//populateOtherDetails(null);
			//}
		});
		
		function saveMcTpDtl(){
			try{
				var addedRows = mcTpDtlGrid.getNewRowsAdded();
				var modifiedRows = mcTpDtlGrid.getModifiedRows();
				var deletedRows = mcTpDtlGrid.getDeletedRows();
				
				var objParameters = new Object();
				objParameters.delRows = deletedRows;
				objParameters.modRows = modifiedRows;
				objParameters.setRows = addedRows;
				objParameters.claimId = objCLMGlobal.claimId;
				objParameters.itemNo = objCLMItem.selected[itemGrid.getColumnIndex('itemNo')];
				
				var strParameters = JSON.stringify(objParameters);
				
				new Ajax.Request(contextPath+"/GICLMotorCarDtlController",{
					method: "POST",
					evalScripts: true,
					asynchronous: false,
					parameters:{
						action: "saveMcTpDtl",
						strParameters: strParameters
					},onCreate: function(){
						showNotice("Saving, please wait...");
					},
					onComplete: function (response) {	
						hideNotice();
						if (!checkErrorOnResponse(response)) {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}else{
							changeTag = 0;
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								Windows.close("modal_dialog_mcTpDtl");	
							});
						}
					}
				}); 
			}catch (e) {
				showErrorMessage("saveMcTpDtl",e);
			}
		}
		
		function validateFields(){
			var bool = true;
			if($F("payeeClass") == "" || $F("payee") == "" || $F("tpTypeOpt")== ""){
				showMessageBox("Required fields must be entered.", imgMessage.INFO);
				bool = false;
			}
			return bool;
		}
		var objNewMcTpDtl = [];
		//observe functions
		$("btnAdd").observe("click",function(){
			if (validateFields()){
				changeTag = 1;
				objNewMcTpDtl = [];
				var tpType = $F("tpTypeOpt");
				if($F("btnAdd") == "Add"){
					try{
						// some validation here
						objNewMcTpDtl.claimId = objCLMGlobal.claimId;
						objNewMcTpDtl.payeeClassCd = $F("payeeClassCd");
						objNewMcTpDtl.classDesc = $F("payeeClass");
						objNewMcTpDtl.payeeNo = $F("payeeNo");
						objNewMcTpDtl.payeeDesc = $F("payee");
						objNewMcTpDtl.dspPayeeAdd = $F("payeeAddress");
						objNewMcTpDtl.tpType = tpType;
						//other details
						objNewMcTpDtl.colorCd = $F("detColorCd") == null ? null : $F("detColorCd");
						objNewMcTpDtl.colorDesc =$F("detColor") ==null?null:$F("detColor");
						objNewMcTpDtl.basicColorDesc =	$F("detBasicColor") == null ? null :$F("detBasicColor");
						objNewMcTpDtl.basicColorCd =	$F("detBasicColorCd") == null ? null : $F("detBasicColorCd") ;
						objNewMcTpDtl.motorNo = $F("detMotorNo") == null ? null : $F("detMotorNo");
						objNewMcTpDtl.serialNo = $F("detSerialNo") == null ? null : $F("detSerialNo");
						objNewMcTpDtl.plateNo = $F("detPlateNo") == null ? null : $F("detPlateNo");
						objNewMcTpDtl.modelYear = $F("detModelYear") == null ? null : $F("detModelYear");
						objNewMcTpDtl.carComDesc = $F("detCarCompany") == null ? null : $F("detCarCompany");
						objNewMcTpDtl.motorcarCompCd = $F("detCarCompanyCd") == null ? null : $F("detCarCompanyCd");
						objNewMcTpDtl.makeCd = $F("detMakeCd") == null ? null : $F("detMakeCd");
						objNewMcTpDtl.makeDesc = $F("detMake") == null ? null :  $F("detMake");
						objNewMcTpDtl.engineSeries = $F("detEngineSeries") == null ? null : $F("detEngineSeries");
						objNewMcTpDtl.seriesCd = $F("detSeriesCd") == null ? null : $F("detSeriesCd");
						objNewMcTpDtl.motType = $F("detTypeCd") == null ? null : $F("detTypeCd");
						objNewMcTpDtl.motorTypeDesc = $F("detMotorTypeDesc") == null ? null : $F("detMotorTypeDesc");
						objNewMcTpDtl.otherInfo = $F("detOtherInfo") == null ? null : $F("detOtherInfo"); 
						objNewMcTpDtl.riCd = $F("detRiCd") == null ? null : $F("detRiCd");
						objNewMcTpDtl.riName = $F("detRiName") == null ? null :  $F("detRiName"); 
						objNewMcTpDtl.drvrOccDesc = $F("detDriverOccupation") == null ? null : $F("detDriverOccupation");
						objNewMcTpDtl.drvrOccCd = $F("detDriverOccupationCd") == null ? null : $F("detDriverOccupationCd");
						objNewMcTpDtl.drvrName = $F("detDriverName") == null ? null : $F("detDriverName");
						objNewMcTpDtl.drvrAge = $F("detDriverAge") == null ? null : $F("detDriverAge");
						objNewMcTpDtl.drvrAdd = $F("detDriverAddress") == null ? null : $F("detDriverAddress");	//uncomment by Gzelle 09022014
						objNewMcTpDtl.drvrSex = $F("detDriverSex") == null ? null : $F("detDriverSex");
						objNewMcTpDtl.drvngExp = $F("detDrivingExperience") == null ? null : $F("detDrivingExperience");
						objNewMcTpDtl.nationalityCd = $F("detNationalityCd") == null ? null : $F("detNationalityCd");
						objNewMcTpDtl.nationalityDesc = $F("detNationalityDesc") == null ? null : $F("detNationalityDesc");  
							
						mcTpDtlGrid.createNewRow(objNewMcTpDtl, "bottom");
						var tpIndex;
						if (tpType == "T") {
							tpIndex = mcTpDtlGrid.getColumnIndex("thirdParty");
						}else if(tpType == "A"){
							tpIndex = mcTpDtlGrid.getColumnIndex("adverseParty");
						}else if(tpType =="B"){
							tpIndex = mcTpDtlGrid.getColumnIndex("bodilyInjuredThirdParty");
						}else if(tpType == "P"){
							tpIndex = mcTpDtlGrid.getColumnIndex("propertyDamageThirdParty");
						}
						var input = $('mtgInput' + mcTpDtlGrid._mtgId + '_' + tpIndex + ',' + (0 - mcTpDtlGrid.newRowsAdded.length));
						input.checked = true;
					}catch(e){
						showErrorMessage("add mc tp dl",e);
					}
					populationThirdAverseDetails(null);
				}else{
					try{
						// mcTpDtlGrid.updateRowAt : cannot be used because of the radio button element
						mcTpDtlGrid.setValueAt($F("payeeClassCd"),mcTpDtlGrid.getColumnIndex("newPayeeClassCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("payeeNo"),mcTpDtlGrid.getColumnIndex("newPayeeNo"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("payeeClass")),mcTpDtlGrid.getColumnIndex("classDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("payee")),mcTpDtlGrid.getColumnIndex("payeeDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("payeeAddress")),mcTpDtlGrid.getColumnIndex("dspPayeeAdd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(tpType,mcTpDtlGrid.getColumnIndex("tpType"),mcTpDtlIndex,true);
					 	mcTpDtlGrid.setValueAt($F("detColorCd"),mcTpDtlGrid.getColumnIndex("colorCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detColor")),mcTpDtlGrid.getColumnIndex("colorDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detBasicColor")),mcTpDtlGrid.getColumnIndex("basicColorDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detBasicColorCd"),mcTpDtlGrid.getColumnIndex("basicColorCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detMotorNo")),mcTpDtlGrid.getColumnIndex("motorNo"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detSerialNo")),mcTpDtlGrid.getColumnIndex("serialNo"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detPlateNo")),mcTpDtlGrid.getColumnIndex("plateNo"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detModelYear"),mcTpDtlGrid.getColumnIndex("modelYear"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detCarCompany")),mcTpDtlGrid.getColumnIndex("carComDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detCarCompanyCd"),mcTpDtlGrid.getColumnIndex("motorcarCompCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detMakeCd"),mcTpDtlGrid.getColumnIndex("makeCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detMake")),mcTpDtlGrid.getColumnIndex("makeDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detEngineSeries")),mcTpDtlGrid.getColumnIndex("engineSeries"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detSeriesCd"),mcTpDtlGrid.getColumnIndex("seriesCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detTypeCd"),mcTpDtlGrid.getColumnIndex("motType"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detMotorTypeDesc")),mcTpDtlGrid.getColumnIndex("motorTypeDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detOtherInfo")),mcTpDtlGrid.getColumnIndex("otherInfo"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detRiCd"),mcTpDtlGrid.getColumnIndex("riCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detRiName")),mcTpDtlGrid.getColumnIndex("riName"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detDriverOccupation")),mcTpDtlGrid.getColumnIndex("drvrOccDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detOtherInfo")),mcTpDtlGrid.getColumnIndex("otherInfo"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detRiCd"),mcTpDtlGrid.getColumnIndex("riCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detRiName")),mcTpDtlGrid.getColumnIndex("riName"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detDriverOccupation")),mcTpDtlGrid.getColumnIndex("drvrOccDesc"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detDriverOccupationCd"),mcTpDtlGrid.getColumnIndex("drvrOccCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detDriverName")),mcTpDtlGrid.getColumnIndex("drvrName"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detDriverAge"),mcTpDtlGrid.getColumnIndex("drvrAge"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detDriverAddress"),mcTpDtlGrid.getColumnIndex("drvrAdd"),mcTpDtlIndex,true);		//uncomment by Gzelle 09022014
						mcTpDtlGrid.setValueAt($F("detDriverSex"),mcTpDtlGrid.getColumnIndex("drvrSex"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detDrivingExperience"),mcTpDtlGrid.getColumnIndex("drvngExp"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt($F("detNationalityCd"),mcTpDtlGrid.getColumnIndex("nationalityCd"),mcTpDtlIndex,true);
						mcTpDtlGrid.setValueAt(escapeHTML2($F("detNationalityDesc")),mcTpDtlGrid.getColumnIndex("nationalityDesc"),mcTpDtlIndex,true);
						
						//other details
						//uncheck all first
						$('mtgInput' + mcTpDtlGrid._mtgId + '_' + mcTpDtlGrid.getColumnIndex("thirdParty") + ',' + mcTpDtlIndex).checked = false;
						$('mtgInput' + mcTpDtlGrid._mtgId + '_' + mcTpDtlGrid.getColumnIndex("adverseParty") + ',' + mcTpDtlIndex).checked = false;
						$('mtgInput' + mcTpDtlGrid._mtgId + '_' + mcTpDtlGrid.getColumnIndex("bodilyInjuredThirdParty") + ',' + mcTpDtlIndex).checked = false;
						$('mtgInput' + mcTpDtlGrid._mtgId + '_' + mcTpDtlGrid.getColumnIndex("propertyDamageThirdParty") + ',' + mcTpDtlIndex).checked = false;
						
						var tpIndex;
						if (tpType == "T") {
							tpIndex = mcTpDtlGrid.getColumnIndex("thirdParty");
						}else if(tpType == "A"){
							tpIndex = mcTpDtlGrid.getColumnIndex("adverseParty");
						}else if(tpType =="B"){
							tpIndex = mcTpDtlGrid.getColumnIndex("bodilyInjuredThirdParty");
						}else if(tpType == "P"){
							tpIndex = mcTpDtlGrid.getColumnIndex("propertyDamageThirdParty");
						}
						var input = $('mtgInput' + mcTpDtlGrid._mtgId + '_' + tpIndex + ',' + mcTpDtlIndex);
						input.checked = true;  
						mcTpDtlGrid.releaseKeys();
						//mcTpDtlGrid.releaseKeys();
						
					}catch(e){
						showErrorMessage("update mc tp dtl",e);
					}
				}
				populationThirdAverseDetails(null);
			}
		});
		
		
		$("detPlateNo").observe("blur" , function(){
			checkClaimPlateNo($F("detPlateNo"),objCLMGlobal.strDspLossDate,"detPlateNo");
		});
		
		$("detMotorNo").observe("blur", function(){
			checkClaimMotorNo($F("detMotorNo"),objCLMGlobal.strDspLossDate,"detMotorNo");
			//checkClaimMotorNo($F("detMotorNo"),'6-01-2011',"detMotorNo");
		});
		
		$("detSerialNo").observe("blur", function(){
			checkClaimSerialNo($F("detSerialNo"),objCLMGlobal.strDspLossDate,"detSerialNo");
		});
		
		$("btnDelete").observe("click", function(){
			mcTpDtlGrid.deleteRow(mcTpDtlIndex);
			populationThirdAverseDetails(null);
			changeTag = 1;
		});
		
		$("btnSave").observe("click",saveMcTpDtl);
		observeSaveForm("btnSave", saveMcTpDtl);
		
		$("detNationalityDescGo").observe("click",function(){
			showNationalityLOV("GICLS014other");
		});
		$("detDriverOccupationGo").observe("click",function(){
			showDriverOccupationLOV("GICLS014other");
		});
		$("detMotorTypeDescGo").observe("click",function(){
			showMotorTypeLOV(objCLMGlobal.sublineCd,"GICLS014other");
		});
		$("detEngineSeriesGo").observe("click",function(){
			//showEngineSeriesLOV2(objCLMGlobal.sublineCd, $F("detCarCompanyCd"), $F("detMakeCd"),"GICLS014other");
			getEngineSeriesAdverseLOV($F("detCarCompanyCd"), $F("detMakeCd"));
			
		});
		$("detMakeGo").observe("click",function(){
			showMakeLOV2(objCLMGlobal.sublineCd,$F("detCarCompanyCd"),"GICLS014other");
		});
		$("detBasicColorGo").observe("click",function(){
			showBasicColorLOV2("GICLS014other");
		});
		$("detColorGo").observe("click",function(){
			showColorLOV2($F("detBasicColorCd"), "GICLS014other");
		});
		
		$("payeeClassGo").observe("click",function(){
			showClmPayeeClassLov("GICLS014", "MC");
		});
		
		$("payeeGo").observe("click",function(){
			if($F("payeeClassCd") == "" || $F("payeeClassCd") == null){
				showMessageBox("Please enter class description first.", imgMessage.INFO);
				return false;
			}
			showClmPayeesLov("GICLS014","MC",$F("payeeClassCd"),unescapeHTML2(String(objCLMItem.selected[itemGrid.getColumnIndex('itemNo')])));
			
		});
		
		$("detCarCompanyGo").observe("click",function(){
			showCarCompanyLOV2("GICLS014other");
		});
		
		$("detRiNameGo").observe("click", function(){
			showReinsurerLOV3("", "GICLS014other");
		});
		
		$("btnReturn").observe("click", function(){
			if(changeTag == 1){
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",saveMcTpDtl, function(){
					Windows.close("modal_dialog_mcTpDtl");	
				},"");
				
			}else{
				Windows.close("modal_dialog_mcTpDtl");	
			}
			
		}); 
		$("editDetOtherInfo").observe("click", function () {
			showOverlayEditor("detOtherInfo", 2000);
		});
		$("editPayeeAddress").observe("click", function () {
			//showOverlayEditor("payeeAddress", 2000);	commented out by Gzelle 09022014 replaced with codes below
			showOverlayEditor("payeeAddress", 2000, $("payeeAddress").hasAttribute("readonly"), function() {
				limitText($("payeeAddress"),2000);
			});
		});
		//uncomment by Gzelle 09022014
		 $("editDetDriverAddress").observe("click", function () {
			showOverlayEditor("detDriverAddress", 2000);
		}); 
		
		//added set of codes to allow clearing of fields with LOV by MAC 07/12/2013.
		deleteOnBackSpace("detBasicColorCd","detBasicColor","detBasicColorGo",function(){
			$("detColorCd").clear();
			$("detColor").clear();
		});	//Basic Color
		deleteOnBackSpace("detColorCd","detColor");				//Color
		deleteOnBackSpace("detCarCompanyCd","detCarCompany","detCarCompanyGo",function(){
			$("detMakeCd").clear();
			$("detMake").clear();
			$("detSeriesCd").clear();
			$("detEngineSeries").clear();
		});	//Car Company
		deleteOnBackSpace("detMakeCd","detMake","detMakeGo",function(){
			$("detSeriesCd").clear();
			$("detEngineSeries").clear();
		});	//Make
		deleteOnBackSpace("detTypeCd","detMotorTypeDesc");		//Motor Type
		deleteOnBackSpace("detSeriesCd","detEngineSeries");		//Engine Series
		deleteOnBackSpace("detRiCd","detRiName");				//TP Insurer
		deleteOnBackSpace("detDriverOccupationCd","detDriverOccupation"); //Occupation
		deleteOnBackSpace("detNationalityCd","detNationalityDesc"); //Nationality

		
	}catch(e){
		showErrorMessage("motorCarThirdAdverseParty",e);
	}
	makeInputFieldUpperCase();
	initializeAccordion();
	initializeAll();
</script>
