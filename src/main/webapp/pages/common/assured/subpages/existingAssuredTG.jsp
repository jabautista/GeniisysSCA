<div id="depreciationDetailsInfoDiv" style="padding: 10px;">
	<!-- <div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>VAT Details</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div> -->
	
	<div class="sectionDiv" >
		<div style="height: 265px;">
			<div id="assuredTgDiv" style="height: 240px; "></div>
		</div>
		<div  style="padding: 10px;  height: 100px; margin-bottom:10px; "  >
			<table align="center">
				<tr>
					<td align="right" style="width: 120px;">Mailing Address:</td>
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="mailAddress1Overlay" type="text" readonly="readonly"/>
					</td>
					<td align="right" style="width: 100px;">Billing Address:</td>
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="billingAddress1Overlay" type="text"  readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 120px;"></td>
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="mailAddress2Overlay" type="text"  readonly="readonly"/>
					</td>
					<td align="right" style="width: 100px;"></td>
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="billingAddress2Overlay" type="text"  readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td align="right" style="width: 120px;"></td>
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="mailAddress3Overlay" type="text" readonly="readonly"/>
					</td>
					<td align="right" style="width: 100px;"></td>
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="billingAddress3Overlay" type="text"  readonly="readonly"/>
					</td>
				</tr>
			</table>
		</div>
		<input id="phoneNoOverlay" type="hidden" />
	</div>
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 10px; margin-bottom:10px; " >
		<div style="text-align:center">
			<label id="promptDsp" style="float: none;"></label>
			<div style="margin-top:10px;text-align:center">
				<input type="button" class="button" id="btnYes" value="Yes" style="width:170px;"/>
				<input type="button" class="button" id="btnNo" value="No" style="width:170px;"/>
			</div>
		</div>
	</div>

</div>	



<script>
    var lastName, firstName, middleInitial, assdName; //Added by Jerome Bautista 07.28.2015 SR 19507
	disableButton("btnYes");

	if(objTempAssured.assdName != "" && objTempAssured.lastName != ""){
		if(objTempAssured.middleInitial != ""){ //marco - 12.11.2012 - added condition
			$("promptDsp").innerHTML = "Assured is already existing. Do you want to create a new record?";
		}else{
			$("promptDsp").innerHTML = "Assured with the same first name and last name already exist. Do you want to continue?";
		}
	}else{
		$("promptDsp").innerHTML = "Assured is already existing. Do you want to create a new record?";
	}

	$("btnNo").observe("click", function(){
		genericObjOverlay.close();
// 		updateMainContentsDiv("/GIISAssuredController?action=maintainAssured&assuredNo="+$F("generatedAssuredNo")+"&divToShow=assuredListingMainDiv",
// 		"Creating assured form, please wait...");  //remove by steven 8/30/2012 it causes an errror if you try to reload the page.
		maintainAssuredTG("assuredListingTGMainDiv", $F("generatedAssuredNo"), $("hidViewOnly").value); //added by steven 8/30/2012
	});
	
	$("btnYes").observe("click", function(){
		assignAssdAddressValues();
		assignAssdNameValues(); //Added by Jerome Bautista 07.28.2015 SR 19507
		checkIfJointAssured();
		genericObjOverlay.close();
	});
	
	hideNotice("");
	try{
		var existingAssuredTGObj =  JSON.parse('${jsonExistingAssured}'.replace(/\\/g, '\\\\'));
		var assuredTableModel= {
			id: 15,
			url: contextPath+"/GIISAssuredController?action=getGiiss006bExistingAssdTg&refresh=1&assdName="+objTempAssured.assdName+"&lastName="+objTempAssured.assdName+"&firstName="+objTempAssured.assdName+
					"&middleInitial="+objTempAssured.middleInitial,
			options: {
				onCellFocus: function(element, value, x, y, id) {
					enableButton("btnYes");
					populateAddressFields(assuredGrid.getRow(y));
					populateAssdNameVariables(assuredGrid.getRow(y)); //Added by Jerome Bautista 07.28.2015 SR 19507
					assuredGrid.releaseKeys();
				},onRemoveRowFocus : function(){
					disableButton("btnYes");
					populateAddressFields(null);
			  	},toolbar: {
					elements: [/* MyTableGrid.FILTER_BTN */, MyTableGrid.REFRESH_BTN]// removed filter for now
					
				}
			},columnModel : [
				{   
					id: 'recordStatus',
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
					id: 'assdNo',
					width: '90',
					title: 'Assd No.',
					titleAlign: 'right',
					align: 'right'
					
				},
				{	
					id: 'assdName',
					width: '200',
					title: 'Assd Name'
				},{	
					id: 'lastName',
					width: '150',
					title: 'Last Name'
				},{	
					id: 'firstName',
					width: '150',
					title: 'First Name'
				},{	
					id: 'middleInitial',
					width: '30',
					title: 'MI'
				},{	
					id: 'phoneNo',
					width: '100',
					title: 'Phone No.'
				},{	
					id: 'contactPersons',
					width: '120',
					title: 'Contact Person'
				},{	
					id: 'mailAddress1',
					width: '0',
					title: '',
					visible: false
				},{	
					id: 'mailAddress2',
					width: '0',
					title: '',
					visible: false
				},{	
					id: 'mailAddress3',
					width: '0',
					title: '',
					visible: false
				},{	
					id: 'billingAddress1',
					width: '0',
					title: '',
					visible: false
				},{	
					id: 'billingAddress2',
					width: '0',
					title: '',
					visible: false
				},{	
					id: 'billingAddress3',
					width: '0',
					title: '',
					visible: false
				}
			],
			rows: existingAssuredTGObj.rows
		};
		
		assuredGrid = new MyTableGrid(assuredTableModel);
		assuredGrid.pager = existingAssuredTGObj;
		assuredGrid.render('assuredTgDiv');
	
	}catch(e){
		showErrorMessage("existing assured TG.",e);
	}
	
	function populateAddressFields(obj){
		try{
			$("mailAddress1Overlay").value = obj == null ? "" : unescapeHTML2(obj.mailAddress1);
			$("mailAddress2Overlay").value = obj == null ? "" : unescapeHTML2(obj.mailAddress2);
			$("mailAddress3Overlay").value = obj == null ? "" : unescapeHTML2(obj.mailAddress3);
			$("billingAddress1Overlay").value = obj == null ? "" : unescapeHTML2(obj.billingAddress1);
			$("billingAddress2Overlay").value = obj == null ? "" : unescapeHTML2(obj.billingAddress2);
			$("billingAddress3Overlay").value = obj == null ? "" : unescapeHTML2(obj.billingAddress3);
			$("phoneNoOverlay").value = obj == null ? "" : unescapeHTML2(obj.phoneNo);
		}catch(e){
			showErrorMessage("populateAddressFields",e);
		}
	}
	function populateAssdNameVariables(obj){ //Added by Jerome Bautista 07.28.2015 SR 19507
		try{
			firstName = obj.firstName;
			lastName = obj.lastName;
			middleInitial = obj.middleInitial;
			assdName = obj.assdName;
		}catch(e){
			showErrorMessage("populateAssdNameValues",e);
		}
	}
	function assignAssdNameValues(){ //Added by Jerome Bautista 07.28.2015 SR 19507
		try{
			if(firstName != null && lastName != null){
				$("firstName").value = firstName;
				$("lastName").value = lastName;
				$("middleInitial").value = middleInitial;
			}else{
				$("assuredNameMaint").value = assdName;
		    }
		}catch(e){
			showErrorMessage("assignAssdNameValues",e);
		}
	}
</script>