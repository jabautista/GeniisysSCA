<!-- move to principalSignatory.jsp
move by steven 
date 05.26.2014 -->

<div id="principalSignatoryTableGrid" style="height: 220px; width: 850px;"></div>

<div id="principalSignatoryInfo" style="margin-top: 20px;">
	<table align="center">
		<tr>
			<td class="rightAligned">Signatory ID</td>
			<td class="leftAligned" colspan="2"><input type="text" id="txtPrinId" name="txtPrinId" value="" readonly="readonly" style="width: 65px;" tabindex=201 /></td>
			
			<td class="rightAligned" colspan="2">Designation</td>
			<td class="leftAligned" colspan="5"><input type="text" id="txtDesignation" name ="txtDesignation" value="" style="width: 233px;" maxlength="30" class="required" tabindex=202/></td>
		</tr>
		<tr>
			<td class="rightAligned">Name</td>
			<td class="leftAligned" colspan="9"><input type="text" id="txtPrinSign" name="txtPrinSign" value="" style="width: 409px;" maxlength="50" class="required" tabindex=203/></td>
		</tr>
		<tr>
			<td class="rightAligned">ID Type</td>
			<td class="leftAligned" colspan="4">
				<select style="width: 168px;" id="selPrinControlType" name="selPrinControlType" tabindex="204" class="required">
					<option></option>
				</select>
			</td>
			
			<td class="rightAligned" colspan="2">ID Number</td>
			<td class="leftAligned" colspan="3"><input type="text" id="txtCtcNo" name="txtCtcNo" value="" style="width: 164px;" maxlength="15" class="required" tabindex=205/></td>
		</tr>
		<tr>
			<td class="rightAligned">Issue Date</td>
			<td class="leftAligned" colspan="4">
				<!-- <div id="divCtcDate" style="width: 166px;" class="required withIconDiv">
					<input type="text" id="txtCtcDate" name ="txtCtcDate" value="" class="required withIcon" style="width: 138px;" readonly="readonly" tabindex=206/>
					<img style="float: right;" alt="To Date" src="/Geniisys/images/misc/but_calendar.gif" id="calCtcDate" name="calCtcDate" onclick="scwShow($('txtCtcDate'),this, null);" class="hover" tabindex=207/>
				</div> --> 
				<div id="divCtcDate" style="border: solid 1px gray; width: 166px; height: 21px;" class="required">
		    		<input style="width: 138px; border: none; float: left;" id="txtCtcDate" name="txtCtcDate" type="text" readonly="readonly" tabindex=206 class="required" lastValidValue=""/>
		    		<img name="calCtcDate" id="calCtcDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex=307 onclick="scwShow($('txtCoSignCtcDate'),this, null);"/>
				</div>
			</td>
			
			<td class="rightAligned" colspan="2">Issue Place</td>
			<td class="leftAligned" colspan="3"><input type="text" id="txtCtcPlace" name ="txtCtcPlace" value="" style="width: 164px;" maxlength="100" class="required" tabindex=208/></td>
		</tr>
		<tr>
			<td class="rightAligned">Address</td>
			<td colspan="9" class="leftAligned"><input type="text" id="txtAddress" name ="txtAddress" value="" style="width: 409px;" maxlength="150" tabindex=209/></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="9" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 415px; ">
					<textarea id="txtRemarks" name="txtRemarks" maxlength="4000" style="width: 389px; border: none; height: 13px; resize: none;" tabindex=210></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=211/>
				</div>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned">Bond</td>
			<td><div style="padding: 5px;"><input type="checkbox" id="chkBondSw" name="chkBondSw" tabindex="212" /></div></td>
		
			<td class="rightAligned">Indemnity</td>
			<td><div style="padding: 5px;"><input type="checkbox" id="chkIndemSw" name="chkIndemSw" tabindex="213" /></div></td>
		
			<td class="rightAligned">Acknowledgement</td>
			<td><div style="padding: 5px;"><input type="checkbox" id="chkAckSw" name="chkAckSw" tabindex="214" /></div></td>
		
			<td class="rightAligned">Certificate</td>
			<td><div style="padding: 5px;"><input type="checkbox" id="chkCertSw" name="chkCertSw" tabindex="215" /></div></td>
		
			<td class="rightAligned">RI Agreement</td>
			<td><div style="padding: 5px;"><input type="checkbox" id="chkRiSw" name="chkRiSw" tabindex="216" /></div></td>
		</tr>
	</table>
	<div align="center"><input type="button" id="btnAddPSign" name="btnAddPSign" value="Add" class="button" style="width: 80px;" tabindex=217/></div>
</div>
<script>
	var selectedIndex = -1;
	var principalSelectedIndex; 
	var principalSignatoryObj = new Object();
	principalSignatoryObj.principalSignatoryTableGrid = JSON.parse('${principalSignatoryObj}'.replace(/\\/g,'\\\\'));
	principalSignatoryObj.principalSignatoryObjRows = principalSignatoryObj.principalSignatoryTableGrid.rows || [];
	principalSignatoryRows = [];
	
// 	var prinIdList = JSON.parse('${prinIdList}');
// 	var lastPrinId = 0;
// 	if(prinIdList.length > 0){
// 		lastPrinId = Math.max.apply(Math, prinIdList);
// 	}
	var principalSignatoryTableModel = {
		url: contextPath + "/GIISPrincipalSignatoryController?action=refreshPrincipalSignatory&assdNo="+$F("principalAssdNo"),
		options: {
			title: '',
			querySort: true,
	      	height:'200px',
	      	width:'900px',
	      	onCellFocus: function(element, value, x, y, id){
			 	principalSignatoryTableGrid.keys.releaseKeys();
				var obj = principalSignatoryTableGrid.geniisysRows[y];
				populateDetails(obj); 
				principalSignatoryTableGrid.keys.releaseKeys();
		  	},	onCellBlur: function(element, value, x, y, id){
				observeChangeTagInTableGrid(principalSignatoryTableGrid);
				
		  	},	onRemoveRowFocus : function(){
		  		selectedIndex = -1;
		  		principalSignatoryTableGrid.keys.releaseKeys();
		  		populateDetails(null); 
		  	},
		  	postPager : function(){
		  		principalSignatoryTableGrid.keys.releaseKeys();
				populateDetails(null);
			},
			onSort: function () {
				principalSignatoryTableGrid.keys.releaseKeys();
				populateDetails(null);
			},
	      	toolbar:{
		 		elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN],
		 		onRefresh: function(){
		 			principalSignatoryTableGrid.keys.releaseKeys();
					populateDetails(null);
				},
				onFilter: function(){
					principalSignatoryTableGrid.keys.releaseKeys();
					populateDetails(null);
				}
	  		}
		},
		columnModel:[
			{
			    id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
	        {	id: 'divCtrId',
					width: '0px',
					visible: false						    
			},
			{
				id: 'tbgBondSw',
				title: 'B',
				width: '19px',
				tooltip: 'Bond Switch',
				align: 'center',
				titleAlign: 'center',
				editor:	 'checkbox',
				sortable: false
			},
			{
				id: 'tbgIndemSw',
				title: 'I',
				width: '19px',
				tooltip: 'Indemnity Switch',
				align: 'center',
				titleAlign: 'center',
				editor:	 'checkbox',
				sortable: false
			},
			{
				id: 'tbgAckSw',
				title: 'A',
				width: '19px',
				tooltip: 'Acknowledgement Switch',
				align: 'center',
				titleAlign: 'center',
				editor:	 'checkbox',
				sortable: false
			},
			{
				id: 'tbgCertSw',
				title: 'C',
				width: '19px',
				tooltip: 'Certificate Switch',
				align: 'center',
				titleAlign: 'center',
				editor:	 'checkbox',
				sortable: false
			},
			{
				id: 'tbgRiSw',
				title: 'R',
				width: '19px',
				tooltip: 'RI Switch',
				align: 'center',
				titleAlign: 'center',
				editor:	 'checkbox',
				sortable: false
			},
			{	id: 'prinId',
				titleAlign: 'right',
				width: '70px',
				title: 'Signatory Id',
				align: 'right',
				filterOption: true
			},
			{	id: 'prinSignor',
				titleAlign: 'left',
				width: '150px',
				title: 'Principal Signatory',
				align: 'left',
				filterOption: true
			},
			{	id: 'designation',
				titleAlign: 'left',
				width: '150px',
				title: 'Designation',
				align: 'left',
				filterOption: true
			},
			{	id: 'idNumber',
				titleAlign: 'left',
				width: '150px',
				title: 'ID Number',
				align: 'left',
			},
			{	id: 'resCert',
				titleAlign: 'right',
				width: '0px',//'150px', //jeffdojello 05.02.2013
				title: 'CTC No.',
				align: 'right',
				visible: false
			},
			{	id: 'issueDate',
				titleAlign: 'center',
				width: '150px',
				title: 'CTC Date',
				align: 'center',
				filterOption: true
			},
			{	id: 'issuePlace',
				titleAlign: 'left',
				width: '150px',
				title: 'CTC Place',
				align: 'left',
				filterOption: true
			},
			{	id: 'address',
				titleAlign: 'left',
				width: '150px',
				title: 'Address',
				align: 'left',
				filterOption: true
			},
			{	id: 'remarks',
				titleAlign: 'left',
				width: '150px',
				title: 'Remarks',
				align: 'left',
				filterOption: true,
				maxlength: 4000
			},
			{	id: 'lastupdate',
				titleAlign: 'center',
				width: '150px',
				title: 'Last Update',
				align: 'center',
				filterOption: true
			},
			{	id: 'userId',
				titleAlign: 'left',
				width: '75px',
				title: 'User',
				align: 'left',
				filterOption: true
			},
			{	id: 'controlTypeCd',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			},
			{	id: 'controlTypeDesc',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			},
			{	id: 'bondSw',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			},
			{	id: 'indemSw',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			},
			{	id: 'ackSw',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			},
			{	id: 'certSw',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			},
			{	id: 'riSw',
				width: '0px', //jeffdojello 05.02.2013
				visible: false
			}
		],
		requiredColumns: 'prinSignor designation',
		resetChangeTag: true,
		rows: principalSignatoryObj.principalSignatoryObjRows
	};
	$("principalSignatoryTableGrid").update("");
	principalSignatoryTableGrid = new MyTableGrid(principalSignatoryTableModel);
	principalSignatoryTableGrid.pager = principalSignatoryObj.principalSignatoryTableGrid;	
	principalSignatoryTableGrid.render('principalSignatoryTableGrid');	
	principalSignatoryTableGrid.afterRender = function(){
		principalSignatoryRows = principalSignatoryTableGrid.geniisysRows;
	};
	
	var ctList = document.getElementById("selPrinControlType");
	for (var i = ctList.length-1; i >= 0; i--){
		ctList.remove(i);
	}
	controlTypeList.each(function(item){
		addOption("selPrinControlType", item.controlTypeCd, item.controlTypeDesc);
	});
	populateDetails(null);
	
	function addOption(id, value, text){
		var newOpts = document.createElement('option');
		var selectElement = document.getElementById(id);
		newOpts.text = text;
		newOpts.value = value;
		try{
			selectElement.add(newOpts, null);
		} catch(e){
			selectElement.add(newOpts);
		}
	}
	
	function selectOption(id, selected){
		$$("select#"+id+" option").each(function(o){
			if (o.value == selected){
				o.selected = true;
				throw $break;
			}
		});
	}
	
	function checkCosignorIdTableGrid(value){
		var cosignorRows = cosignorResTableGrid.rows;
		var matched = false;
		for ( var i = 0; i < cosignorRows.length; i++) {
			if(cosignorRows[i][cosignorResTableGrid.getColumnIndex('cosignName')] == value){
				matched = true;
			}
		}
		for ( var a = 0; a < cosignorRows.length; a++) {
			if(cosignorRows[a].cosignName == value){
				matched = true;
			}
		}
		return matched;
	}

	function populateDetails(obj){
		try{ 
			$("txtPrinId").value = (obj==null ? ""  : obj.prinId);
			$("txtPrinSign").value = (obj==null ? "" : unescapeHTML2(obj.prinSignor));
			$("txtCtcNo").value = (obj==null ? "" : unescapeHTML2(obj.resCert));
			$("txtCtcDate").value = (obj==null ? "" : unescapeHTML2(obj.issueDate));
			$("txtDesignation").value = (obj==null ? "" : unescapeHTML2(obj.designation));
			$("txtCtcPlace").value = (obj==null ? "" : unescapeHTML2(obj.issuePlace));
			$("txtAddress").value = (obj==null ? "" : unescapeHTML2(obj.address));
			$("txtRemarks").value = (obj==null ? "" : unescapeHTML2(obj.remarks));
			$("btnAddPSign").value = (obj == null ? "Add" : "Update");
			$("chkBondSw").checked = (obj == null ? false : obj.tbgBondSw);
			$("chkIndemSw").checked = (obj == null ? false : obj.tbgIndemSw);
			$("chkAckSw").checked = (obj == null ? false : obj.tgbAckSw);
			$("chkCertSw").checked = (obj == null ? false : obj.tbgCertSw);
			$("chkRiSw").checked = (obj == null ? false : obj.tbgRiSw);
			selectOption("selPrinControlType", (obj == null ? defaultCtcNo : obj.controlTypeCd));
			toggleReadOnlyFields();
		}catch(e){
			showErrorMessage("populateDetails", e);
		} 
	}
	
	function setPrinSignatoryObj(){
		try{
			var obj = new Object();
			var objLastUpdate = new Date();
			obj.lastupdate = dateFormat(objLastUpdate, "mm-dd-yyyy HH:MM:ss");
			obj.prinId = ($F("txtPrinId"));
			obj.prinSignor =  escapeHTML2($F("txtPrinSign"));
			obj.resCert = escapeHTML2($F("txtCtcNo"));
			obj.issueDate = escapeHTML2($F("txtCtcDate"));
			obj.designation = escapeHTML2($F("txtDesignation"));
			obj.issuePlace = escapeHTML2($F("txtCtcPlace"));
			obj.address = escapeHTML2($F("txtAddress"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2($F("userId"));
			obj.controlTypeCd = $("selPrinControlType").value;
			obj.controlTypeDesc = $("selPrinControlType").selectedIndex >= 0 ? $("selPrinControlType").options[$("selPrinControlType").selectedIndex].innerHTML : "";
			obj.idNumber = obj.controlTypeDesc + (obj.resCert == "" ? "" : "-" + obj.resCert);
			obj.tbgBondSw = $("chkBondSw").checked;
			obj.tbgIndemSw = $("chkIndemSw").checked;
			obj.tbgAckSw = $("chkAckSw").checked;
			obj.tbgCertSw = $("chkCertSw").checked;
			obj.tbgRiSw = $("chkRiSw").checked;
			obj.bondSw = obj.tbgBondSw == true ? "Y" : "N";
			obj.indemSw = obj.tbgIndemSw == true ? "Y" : "N";
			obj.ackSw = obj.tbgAckSw == true ? "Y" : "N";
			obj.certSw = obj.tbgCertSw == true ? "Y" : "N";
			obj.riSw = obj.tbgRiSw == true ? "Y" : "N";
			
			return obj;
		}catch(e){
			showErrorMessage("setPrinSignatoryObj", e);
		}
	}
	
	function checkReqFields(){
		try{
			var reqdFields = ["txtPrinSign", "txtCtcNo", "txtCtcDate", "txtDesignation", "txtCtcPlace"];
			var ok = true;
			if($("selPrinControlType").value != defaultCtcNo){ //added by jeffdojello 05.02.2013
				for ( var a = 0; a < reqdFields.length; a++) {
					if($F(reqdFields[a]) == null || $F(reqdFields[a]) == ""){	
						showMessageBox("Required fields must be entered.", imgMessage.INFO);
						$(reqdFields[a]).focus();
						ok = false;
						return ok;
					}
				}
				return ok;
			}else{ //added by jeffdojello 05.02.2013
				return ok;
			}
		}catch(e){
			showErrorMessage("checkReqFields", e);
		}
	}
	
	function reValidateDate(value){
		try{
			var iDateArray = value.split("-");
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10);
			var year = parseInt(iDateArray[2], 10);
			iDate.setFullYear(year, month-1, date);
			iDate.format('mm-dd-yyyy');
	     	value = Date.parse(value, "mm-dd-yyyy").format('mm-dd-yyyy');
	     	var dateToday = new Date();
	        if(iDate > dateToday){
				customShowMessageBox("Cannot record future issuance of IDENTIFICATION.", "I", "txtCtcDate"); //CTC to IDENTIFICATION - 05.14.2013 - SR #12502
				$("txtCtcDate").value = $("txtCtcDate").readAttribute("lastValidValue");
				return false;
	        }else{
	        	$("txtCtcDate").setAttribute("lastValidValue", $F("txtCtcDate"));
	         	return true;
	        }
		}catch(e){
			showErrorMessage("reValidateDate",e);
		}
	}
	
	function addPrinSignatory(obj){
		try{
		var newObj = setPrinSignatoryObj();
		 if($F("btnAddPSign") == "Add"){
			 newObj.recordStatus = 0;
			 principalSignatoryRows.push(newObj);
			 principalSignatoryTableGrid.addBottomRow(newObj);
			 changeTag =1;
		 }else{
			 for ( var a = 0; a < principalSignatoryRows.length; a++) {
				 if(principalSignatoryRows[a].prinId == newObj.prinId
						&& principalSignatoryRows[a].recordStatus != -1){
					 newObj.recordStatus = 1;
					 principalSignatoryRows.splice(i, 1, newObj);
					 principalSignatoryTableGrid.updateVisibleRowOnly(newObj, principalSignatoryTableGrid.getCurrentPosition()[1]);
					 changeTag = 1;
				 }
			}
		 }
		 populateDetails(null);
		}catch (e) {
			showErrorMessage("addPrinSignatory",e);
		}
	}
	
	/* Deprecated. There will be no longer checking of same Co-Signatory name on Principal Signatory and vice versa. */
	/* 09.30.2013 - Putting back checking of same Co-Signatory name on Principal Signatory and v.v. as per advice from Implementation */
	function checkSignor() {
		var value = $F("txtPrinSign");
		var assdNo = $F("principalAssdNo");  //added by Halley 10.07.13
		if(!checkCosignorIdTableGrid(value)){
			if(!validatePrincipalORCoSignorId(value, "P", assdNo)){
				this.value = value;
				return true;
			}else{
				showMessageBox("Cannot enter the same name for signor and co-signor in the database.", imgMessage.INFO);
				this.value = "";
				$("txtPrinSign").focus();
				return false;
			}
		}else{
			showMessageBox("Cannot enter the same name for signor and co-signor.", imgMessage.INFO);
			this.value = "";
			$("txtPrinSign").focus();
			return false;
		}
	}
	function checkSignCtcNo() {
		var ctcNo1 = $("txtCtcNo").value;
		var ctcNo2 = "";
		var id1 = nvl($("txtPrinId").value,1);
		var id2 = 0;
		//var coords =  cosignorResTableGrid.getCurrentPosition(); //commented out by jeffdojello 05.16.2014
		var coords = principalSignatoryTableGrid.getCurrentPosition();  //replaced by jeffdojello 05.16.2014
        var x = coords[0];
        var y = coords[1];
        //added by jeffdojello 05.16.2014
        if($F("btnAddPSign") == "Add"){
        	y =-1; 
        }
		if(checkCosignorCTCNo2(ctcNo1,principalSignatoryRows,y,"N")){
			$("txtCtcNo").clear();
			$("txtCtcNo").focus();
			return false;
		/* }else if(checkCosignorCTCNo2(ctcNo1,principalSignatoryRows,y,'Y')){
			$("txtCtcNo").clear();
			$("txtCtcNo").focus();
			return false; */  //commented out by jeffdojello 05.16.2014 
		}else if(ctcNo1 == $F("principalResNo") && (nvl(ctcNo1, "") != "")) { //jeffdojello 05.02.2013 to ignore blank for Not Applicable  //replaced to nvl - Halley 10.07.13
			showMessageBox("CTC No. already exist.", imgMessage.INFO);
			$("txtCtcNo").clear();
			$("txtCtcNo").focus();
			return false;
		}/* else if(validateCTCNo2(ctcNo1,ctcNo2,id1,id2)){
			showMessageBox("CTC no. already exist in the database, it must be unique.", imgMessage.INFO);
			$("txtCtcNo").clear();
			$("txtCtcNo").focus();
			return false; //commented out by jeffdojello 05.07.2013 as per SR 12502 Note 31382
		}*/else{
			$("txtCtcNo").value = ctcNo1;
			hideNotice();
			return true;
		}
	}
	
	/* revised by Halley 10.07.2013 */
	function toggleReadOnlyFields(){
		/* if ($("selPrinControlType").options[$("selPrinControlType").selectedIndex].text == "TIN"){
			$("txtCtcNo").readOnly = false;
			$("divCtcDate").readOnly = false;
			$("txtCtcDate").readOnly = false;
			$("txtCtcPlace").readOnly = false;
			$("calCtcDate").setAttribute("onClick", "scwShow($('txtCtcDate'),this, null);"); 
			$("txtCtcNo").setAttribute("class", "required");
			$("divCtcDate").removeAttribute("class");
			$("divCtcDate").setStyle('background-color', 'white');
			$("txtCtcDate").removeAttribute("class");
			$("txtCtcPlace").removeAttribute("class");
		}else if ($("selPrinControlType").options[$("selPrinControlType").selectedIndex].text == "Company ID" || $("selPrinControlType").options[$("selPrinControlType").selectedIndex].text == "SSS"){
			$("txtCtcNo").readOnly = false;
			$("divCtcDate").readOnly = false;
			$("txtCtcDate").readOnly = false;
			$("txtCtcPlace").readOnly = false;
			$("calCtcDate").setAttribute("onClick", "scwShow($('txtCtcDate'),this, null);"); 
			$("txtCtcNo").setAttribute("class", "required");
			$("divCtcDate").setAttribute("class", "required");
			$("txtCtcDate").setAttribute("class", "required");
			$("txtCtcPlace").setAttribute("class", "required");
		}else{
			$("txtCtcNo").readOnly = true;
			$("divCtcDate").readOnly = true;
			$("txtCtcDate").readOnly = true;
			$("txtCtcPlace").readOnly = true;
			$("calCtcDate").removeAttribute("onClick"); 
			$("txtCtcNo").removeAttribute("class");
			$("divCtcDate").removeAttribute("class");
			$("divCtcDate").setStyle('background-color', 'white');
			$("txtCtcDate").removeAttribute("class");
			$("txtCtcPlace").removeAttribute("class");
		} */
		
		//Revised by jeffdojello 12.26.2013
		//Please refer to http://cpi-sr.com.ph/genqa/view.php?id=1501
		$("calCtcDate").setAttribute("onClick", "scwShow($('txtCtcDate'),this, null);"); 
		if ($("selPrinControlType").options[$("selPrinControlType").selectedIndex].text == "CTC"){
			$("txtCtcNo").addClassName("required");
			$("divCtcDate").addClassName("required");
			$("txtCtcDate").addClassName("required");
			$("txtCtcPlace").addClassName("required");
		}else{
			$("txtCtcNo").removeClassName("required");
			$("divCtcDate").removeClassName("required");
			$("txtCtcDate").removeClassName("required");
			$("txtCtcPlace").removeClassName("required");
		}
	}
	
	
	$("txtDesignation").observe("blur", function(){
		this.value = this.value.toUpperCase();
	});
	
	$("txtPrinSign").observe("blur", function(){
		this.value = this.value.toUpperCase();
	});
	
	$("txtCtcDate").observe("blur", function(){
		if(this.value != ""){
			if (!checkDate2(this.value)){
				$("txtCtcDate").clear();
				$("txtCtcDate").focus();
				return false;
			}else{
				reValidateDate(this.value);
			}
		}else{
			$("txtCtcDate").setAttribute("lastValidValue", "");
		}
		
	});
	
	$("txtCtcPlace").observe("blur", function(){
		this.value = this.value.toUpperCase();
	});
	
	$("editRemarksText").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	 
	$("btnAddPSign").observe("click", function(){	
		ct = $("selPrinControlType");
		controlTypeCd = ct.value;
		controlTypeDesc = ct.selectedIndex >= 0 ? ct.options[ct.selectedIndex].innerHTML : undefined;

		/*if (controlTypeCd == defaultCtcNo && ($("txtCtcNo").value != "" || $("txtCtcDate").value != "" || $("txtCtcPlace").value != "") ){  //comment out by koks
			showConfirmBox("CONFIRMATION", "ID Type "+controlTypeDesc+" for Principal Signatory requires no entries on ID Number, Issue Date, and Issue Place. These fields will be blank. Do you want to continue?",
					"Yes", "No",
					function(){
						$("txtCtcNo").value = "";
						$("txtCtcDate").value = "";
						$("txtCtcPlace").value = "";
	 					if (checkSignor()){
	 						if(checkAllRequiredFieldsInDiv("principalSignatoryInfo")){  //added by jeffdojello 12.26.2013 to prevent user from adding signatory with no name and designation when not applicable is selected
	 							addPrinSignatory();
	 						}
	 					}
							//addPrinSignatory();  //commented out by Halley 09.27.2013
					}, "", "");
		} else {
	 		if (checkSignor() && checkSignCtcNo()) {	//removed checkReqFields() by Halley 09.30.2013
				if (checkSignCtcNo()) {
					if(checkAllRequiredFieldsInDiv("principalSignatoryInfo")){
						addPrinSignatory();
					}
				}
	 		}
		}*/
		
		if (checkSignor() && checkSignCtcNo()) {	//added by koks 
			if (checkSignCtcNo()) {
				if(checkAllRequiredFieldsInDiv("principalSignatoryInfo")){
					addPrinSignatory();
				}
			}
 		}
	});
	
	
	$("selPrinControlType").observe("change", function (){
		toggleReadOnlyFields();
	});
/***END OF PRINCIPAL SIGNATORY SCRIPTS***/
</script>
