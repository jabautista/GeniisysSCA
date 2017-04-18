<!-- move to principalSignatory.jsp
move by steven 
date 05.26.2014 -->

<div id="cosignorResTableGrid" style="height: 220px; width: 850px;"></div>

<div id="coSignatoryInfo" style="margin-top: 20px;">
	<table align="center">
		<tr>
			<td class="rightAligned">Signatory ID</td>
			<td class="leftAligned" colspan="2"><input type="text" id="txtCoSignId" name="txtCoSignId" value="" readonly="readonly" style="width: 65px;" tabindex=301/></td>
			
			<td class="rightAligned" colspan="2">Designation</td>
			<td class="leftAligned" colspan="5"><input type="text" id="txtCoSignDesignation" name ="txtCoSignDesignation" value="" style="width: 233px;" maxlength="30" class="required" tabindex=302/></td>
		</tr>
		<tr>
			<td class="rightAligned">Name</td>
			<td class="leftAligned" colspan="9"><input type="text" id="txtCoSignor" name="txtCoSignor" value="" style="width: 409px;" maxlength="50" class="required" tabindex=303/></td>
		</tr>
		<tr>
			<td class="rightAligned">ID Type</td>
			<td class="leftAligned" colspan="4">
<!-- 				<div style="border: 1px solid gray; width: 166px; height: 21px; float: left; margin-right: 3px;"  class="required" > -->
<!-- 		    		<input id="txtCoSignControlCd" name="txtCoSignControlCd" type="hidden" /> -->
<!-- 		    		<input style="float: left; border: none; margin-top: 0px; width: 141px;" id="txtCoSignControlDesc" name="txtCoSignControlDesc" type="text" class="required" tabindex=304/> -->
<%-- 		    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="controlTypeLOV" name="controlTypeLOV" alt="Go" /> --%>
<!-- 	    		</div> -->
				<select style="width: 168px;" id="selCoSignControlType" name="selCoSignControlType" tabindex="304" class="required">
					<option></option>
				</select>
			</td>
			
			<td class="rightAligned" colspan="2">ID Number</td>
			<td class="leftAligned" colspan="3"><input type="text" id="txtCoSignCtcNo" name="txtCoSignCtcNo" value="" style="width: 164px;" maxlength="15" class="required" tabindex=305/></td>
		</tr>
		<tr>
			<td class="rightAligned">Issue Date</td>
			<td class="leftAligned" colspan="4">
				<!-- <div id="divCoSignCtcDate" style="width: 166px;" class="required withIconDiv">
					<input type="text" id="txtCoSignCtcDate" name ="txtCoSignCtcDate" value="" class=" required withIcon" style="width: 138px;" readonly="readonly" tabindex=306 alt="mayDate"/>
					<img style="float: right;" alt="To Date" src="/Geniisys/images/misc/but_calendar.gif" id="calCoSignCtcDate" name="calCoSignCtcDate" onclick="scwShow($('txtCoSignCtcDate'),this, null);" class="hover" tabindex=307/>
				</div> -->
				<div id="divCoSignCtcDate" style="border: solid 1px gray; width: 166px; height: 21px;" class="required">
		    		<input style="width: 138px; border: none; float: left;" id="txtCoSignCtcDate" name="txtCoSignCtcDate" type="text" readonly="readonly" tabindex=306 class="required"/>
		    		<img name="calCoSignCtcDate" id="calCoSignCtcDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex=307 onclick="scwShow($('txtCoSignCtcDate'),this, null);"/>
				</div>
			</td>
			
			<td class="rightAligned" colspan="2">Issue Place</td>
			<td class="leftAligned" colspan="3"><input type="text" id="txtCoSignCtcPlace" name ="txtCoSignCtcPlace" value="" style="width: 164px;" maxlength="100" class="required" tabindex=308/></td>
		</tr>
		<tr>
			<td class="rightAligned">Address</td>
			<td colspan="9" class="leftAligned"><input type="text" id="txtCoSignAddress" name ="txtCoSignAddress" value="" style="width: 409px;" maxlength="150" tabindex=309/></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="9" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 415px; ">
					<textarea id="txtCoSignRemarks" name="txtCoSignRemarks" maxlength="4000" style="width: 389px; border: none; height: 13px; resize: none;" tabindex=310></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editCoSignRemarks" tabindex=311/>
				</div>
			</td>
		</tr>
	</table>
	<div align="center"><input type="button" id="btnAddCoSign" name="btnAddCoSign" value="Add" class="button" style="width: 80px;" tabindex=312/></div>
	
</div>
<script>
	var selectedIndex2 = -1;
	var cosignorResObj = new Object();
	cosignorResObj.cosignorResTableGrid = JSON.parse('${cosignorResObj}'.replace(/\\/g,'\\\\'));
	cosignorResObj.cosignorResObjRows = cosignorResObj.cosignorResTableGrid.rows || [];
	coSignRows = [];
	var cosignorResTableModel = {
		url: contextPath + "/GIISPrincipalSignatoryController?action=refreshCosignRes&assdNo="+$F("principalAssdNo"),
		options: {
			title: '',
			querySort: true,
	      	height:'200px',
	      	width:'900px',
	      	onCellFocus: function(element, value, x, y, id){
				cosignorResTableGrid.keys.releaseKeys();
				var obj = cosignorResTableGrid.geniisysRows[y];
				cosignorResTableGrid.keys.releaseKeys();
				populateCoSignDetails(obj);  
		  	},	
		  	onCellBlur: function(element, value, x, y, id){
				if(selectedIndex2 < 0 && id == 'cosignName') {
				}
				observeChangeTagInTableGrid(cosignorResTableGrid);		  			
		  	},	
		  	onRemoveRowFocus : function(){
		  		selectedIndex = -1;
		  		cosignorResTableGrid.keys.releaseKeys();
		  		populateCoSignDetails(null);
		  	},
		  	postPager : function(){
		  		selectedIndex = -1;
		  		cosignorResTableGrid.keys.releaseKeys();
		  		populateCoSignDetails(null);
			},
			onSort: function () {
				selectedIndex = -1;
		  		cosignorResTableGrid.keys.releaseKeys();
		  		populateCoSignDetails(null);
			},
	      	toolbar:{
		 		elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN],
		 		onRefresh : function(){
		 			cosignorResTableGrid.keys.releaseKeys();
		 			populateCoSignDetails(null);
		 		},
		 		onFilter : function(){
		 			cosignorResTableGrid.keys.releaseKeys();
		 			populateCoSignDetails(null);
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
			{	id: 'cosignId',
				titleAlign: 'right',
				width: '100px',
				title: 'Signatory Id',
				align: 'right',
				visible: true,
				filterOption: true
			},
			{	id: 'cosignName',
				titleAlign: 'left',
				width: '200px',
				title: 'Co-Signatory',
				align: 'left',
				visible: true,
				filterOption: true,
				toUpperCase: true
				
			},
			{	id: 'designation',
				titleAlign: 'left',
				width: '150px',
				title: 'Designation',
				align: 'left',
				visible: true,
				filterOption: true
			},
			{	id: 'idNumber',
				titleAlign: 'left',
				width: '150px',
				title: 'ID Number',
				align: 'left',
				visible: true
			},
			{	id: 'cosignResNo',
				titleAlign: 'right',
				width: '150px',
				title: 'CTC No.',
				align: 'right',
				visible: false
			},
			{	id: 'cosignResDate',
				titleAlign: 'center',
				width: '150px',
				title: 'CTC Date',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'cosignResPlace',
				titleAlign: 'left',
				width: '150px',
				title: 'CTC Place',
				align: 'left',
				visible: true,
				filterOption: true
			},
			{	id: 'address',
				titleAlign: 'left',
				width: '150px',
				title: 'Address',
				align: 'left',
				visible: true,
				filterOption: true
			},
			{	id: 'remarks',
				titleAlign: 'left',
				width: '150px',
				title: 'Remarks',
				align: 'left',
				visible: true,
				filterOption: true
			},
			{	id: 'lastupdate',
				titleAlign: 'center',
				width: '150px',
				title: 'Last Update',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'userId',
				titleAlign: 'left',
				width: '75px',
				title: 'User',
				align: 'left',
				visible: true,
				filterOption: true
			},
			{	id: 'controlTypeCd',
				visible: false
			},
			{	id: 'controlTypeDesc',
				visible: false
			}
		],
		requiredColumns: 'cosignName designation',
		rows: cosignorResObj.cosignorResObjRows
		
	}; 
	$("cosignorResTableGrid").update("");
	cosignorResTableGrid = new MyTableGrid(cosignorResTableModel);
	cosignorResTableGrid.pager = cosignorResObj.cosignorResTableGrid;	
	cosignorResTableGrid.render('cosignorResTableGrid');
	cosignorResTableGrid.afterRender = function(){
		coSignRows = cosignorResTableGrid.geniisysRows;
	};
	
	var ctList = document.getElementById("selCoSignControlType");
	for (var i = ctList.length-1; i >= 0; i--){
		ctList.remove(i);
	}
	controlTypeList.each(function(item){ // controlTypeList variable assignment on principalSignatoryTableGrid.jsp 
		addOption("selCoSignControlType", item.controlTypeCd, item.controlTypeDesc);
	});
	
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
	
	function checkPrincipalIdTableGrid(value){
		var principalRows = principalSignatoryTableGrid.rows;
		var matched = false;
		for ( var i = 0; i < principalRows.length; i++) {
			if(principalRows[i][principalSignatoryTableGrid.getColumnIndex('prinSignor')] == value){
				matched = true;
			}
		}
		for ( var a = 0; a < principalRows.length; a++) {
			if(principalRows[a].prinSignor == value){
				matched = true;
			}
		}
		return matched;
	}
	
	function checkCoSignReqFields(){
		try{
			var reqdFields = ["txtCoSignor", "txtCoSignCtcNo", "txtCoSignCtcDate", "txtCoSignDesignation", "txtCoSignCtcPlace"];
			var ok = true;
			for ( var a = 0; a < reqdFields.length; a++) {
				if($(reqdFields[a]) == null || $(reqdFields[a]) == ""){
					showMessageBox("Required fields must be entered.", imgMessage.INFO);
					$(reqdFields[a]).focus();
					ok = false;
					return ok;
				}
			}
			return ok;
		}catch(e){
			showErrorMessage("checkCoSignReqFields", e);
		}
	}
	
	function populateCoSignDetails(obj){
		try{ 
			$("txtCoSignId").value = (obj==null ? "" : (obj.cosignId));
			$("txtCoSignor").value = (obj==null ? "" : unescapeHTML2(obj.cosignName));
			$("txtCoSignCtcNo").value = (obj==null ? "" : unescapeHTML2(obj.cosignResNo));
			$("txtCoSignCtcDate").value = (obj==null ? "" : unescapeHTML2(obj.cosignResDate));
			$("txtCoSignDesignation").value = (obj==null ? "" : unescapeHTML2(obj.designation));
			$("txtCoSignCtcPlace").value = (obj==null ? "" : unescapeHTML2(obj.cosignResPlace));
			$("txtCoSignAddress").value = (obj==null ? "" : unescapeHTML2(obj.address));
			$("txtCoSignRemarks").value = (obj==null ? "" : unescapeHTML2(obj.remarks));
			$("btnAddCoSign").value = (obj == null ? "Add" : "Update");
			selectOption("selCoSignControlType", (obj == null ? defaultCtcNo : obj.controlTypeCd));
			toggleReadOnlyFields();
		}catch(e){
			showErrorMessage("populateCoSignDetails", e);
		}
	}
	
	function setCoSignObj(){
		try{
			var obj = new Object();
			var objLastUpdate = new Date();
			obj.lastupdate = dateFormat(objLastUpdate, "mm-dd-yyyy HH:MM:ss");
			obj.cosignId = escapeHTML2($F("txtCoSignId"));
			obj.cosignName = escapeHTML2($F("txtCoSignor"));
			obj.cosignResNo = escapeHTML2($F("txtCoSignCtcNo"));
			obj.cosignResDate = escapeHTML2($F("txtCoSignCtcDate"));
			obj.designation = escapeHTML2($F("txtCoSignDesignation"));
			obj.cosignResPlace = escapeHTML2($F("txtCoSignCtcPlace"));
			obj.address = escapeHTML2($F("txtCoSignAddress"));
			obj.remarks = escapeHTML2($F("txtCoSignRemarks"));
			//obj.userId = objGIPIWPolbas.userId;
			obj.userId = $F("userId"); //marco - 05.14.2013
			obj.controlTypeCd = $("selCoSignControlType").value;
			obj.controlTypeDesc = $("selCoSignControlType").selectedIndex >= 0 ? $("selCoSignControlType").options[$("selCoSignControlType").selectedIndex].innerHTML : "";
			obj.idNumber = obj.controlTypeDesc + (obj.cosignResNo == "" ? "" : "-" + obj.cosignResNo);
			return obj;
		}catch(e){
			showErrorMessage("setCoSignObj",e);
		}
	}
	
	/* revised by Halley 10.07.2013 */
	function toggleReadOnlyFields(){
		/* if ($("selCoSignControlType").options[$("selCoSignControlType").selectedIndex].text == "TIN"){
			$("txtCoSignCtcNo").readOnly = false;
			$("divCoSignCtcDate").readOnly = false;
			$("txtCoSignCtcDate").readOnly = false;
			$("txtCoSignCtcPlace").readOnly = false;
			$("calCoSignCtcDate").setAttribute("onClick", "scwShow($('txtCoSignCtcDate'),this, null);"); 
			$("txtCoSignCtcNo").setAttribute("class", "required");
			$("divCoSignCtcDate").removeAttribute("class");
			$("divCoSignCtcDate").setStyle('background-color', 'white');
			$("txtCoSignCtcDate").removeAttribute("class");
			$("txtCoSignCtcPlace").removeAttribute("class");
		}else if ($("selCoSignControlType").options[$("selCoSignControlType").selectedIndex].text == "Company ID" || $("selCoSignControlType").options[$("selCoSignControlType").selectedIndex].text == "SSS"){
			$("txtCoSignCtcNo").readOnly = false;
			$("divCoSignCtcDate").readOnly = false;
			$("txtCoSignCtcDate").readOnly = false;
			$("txtCoSignCtcPlace").readOnly = false;
			$("calCoSignCtcDate").setAttribute("onClick", "scwShow($('txtCoSignCtcDate'),this, null);"); 
			$("txtCoSignCtcNo").setAttribute("class", "required");
			$("divCoSignCtcDate").setAttribute("class", "required");
			$("txtCoSignCtcDate").setAttribute("class", "required");
			$("txtCoSignCtcPlace").setAttribute("class", "required");
		}else{
			$("txtCoSignCtcNo").readOnly = true;
			$("divCoSignCtcDate").readOnly = true;
			$("txtCoSignCtcDate").readOnly = true;
			$("txtCoSignCtcPlace").readOnly = true;
			$("calCoSignCtcDate").removeAttribute("onClick"); 
			$("txtCoSignCtcNo").removeAttribute("class");
			$("divCoSignCtcDate").removeAttribute("class");
			$("divCoSignCtcDate").setStyle('background-color', 'white');
			$("txtCoSignCtcDate").removeAttribute("class");
			$("txtCoSignCtcPlace").removeAttribute("class");
		} */
		//Revised by jeffdojello 12.26.2013
		//Please refer to http://cpi-sr.com.ph/genqa/view.php?id=1501
		$("calCoSignCtcDate").setAttribute("onClick", "scwShow($('txtCoSignCtcDate'),this, null);"); 
		if ($("selCoSignControlType").options[$("selCoSignControlType").selectedIndex].text == "CTC"){
			$("txtCoSignCtcNo").addClassName("required");
			$("divCoSignCtcDate").addClassName("required");
			$("txtCoSignCtcDate").addClassName("required");
			$("txtCoSignCtcPlace").addClassName("required");
		}else{
			$("txtCoSignCtcNo").removeClassName("required");
			$("divCoSignCtcDate").removeClassName("required");
			$("txtCoSignCtcDate").removeClassName("required");
			$("txtCoSignCtcPlace").removeClassName("required");
		}
	}
	
	function addCoSignatory(obj){
		 var newObj = setCoSignObj();
			 if($F("btnAddCoSign") == "Add"){
				 newObj.recordStatus = 0;
				 coSignRows.push(newObj);
				 cosignorResTableGrid.addBottomRow(newObj);
				 changeTag =1;
			 }else{
				 for ( var a = 0; a < coSignRows.length; a++) {
					 if(coSignRows[a].cosignId == newObj.cosignId
						&& coSignRows[a].recordStatus != -1){
						 newObj.recordStatus = 1;
						 coSignRows.splice(i, 1, newObj);
						 cosignorResTableGrid.updateVisibleRowOnly(newObj, cosignorResTableGrid.getCurrentPosition()[1]);
						 changeTag = 1;
					 }
				}
			 }
		populateCoSignDetails(obj);
	}
	
	/* Deprecated. There will be no longer checking of same Co-Signatory name on Principal Signatory and vice versa. */
	function checkCoSignor() {
		try{
			var value = $("txtCoSignor").value;
			var assdNo = $F("principalAssdNo");  //added by Halley 10.07.13
			if(!checkPrincipalIdTableGrid(value)){
				if(!validatePrincipalORCoSignorId(value, "C", assdNo)){
					$("txtCoSignor").value = value;
					return true;
				}else{
					showMessageBox("Cannot enter the same name for signor and co-signor in the database.", imgMessage.INFO);
					$("txtCoSignor").clear();
					$("txtCoSignor").focus();
					return false;
				}
			}else{
				showMessageBox("Cannot enter the same name for signor and co-signor.", imgMessage.INFO);
				$("txtCoSignor").clear();
				$("txtCoSignor").focus();
				return false;
			}
		}catch (e) {
			showErrorMessage("checkCoSignor",e);
		}
	}
	function checkCoSignCtcNo() {
			var ctcNo1 = "";
			var ctcNo2 = $("txtCoSignCtcNo").value;
			var id1 = 0;
			var id2 = nvl($("txtCoSignId").value,1);
			var coords =  cosignorResTableGrid.getCurrentPosition();
	        var x = coords[0];
	        var y = coords[1];
	        //added by jeffdojello 05.16.2014
	        if($F("btnAddCoSign") == "Add"){
	        	y =-1; 
	        }
			if(nvl(ctcNo2, "") != ""){  //added nvl ctcNo2 condition - Halley 10.07.13
				/* if(checkCosignorCTCNo2(ctcNo2,coSignRows,y,"N")){   //commented out by jeffdojello 05.16.2014
					$("txtCoSignCtcNo").clear();
					$("txtCoSignCtcNo").focus();
					return false;
				}else  */if(checkCosignorCTCNo2(ctcNo2,coSignRows,y,'Y')){  
					$("txtCoSignCtcNo").clear();
					$("txtCoSignCtcNo").focus();
					return false;
				}else if(ctcNo2 == $F("principalResNo")) {  
					showMessageBox("CTC No. already exist.", imgMessage.INFO);
					$("txtCoSignCtcNo").clear();
					$("txtCoSignCtcNo").focus();
					return false;
					
				/* }else if(validateCTCNo2(ctcNo1,ctcNo2,id1,id2)){
					showMessageBox("CTC no. already exist in the database, it must be unique.", imgMessage.INFO);
					$("txtCoSignCtcNo").clear();
					$("txtCoSignCtcNo").focus();
					return false; */ //commented out by jeffdojello 05.16.2014
				}else{
					$("txtCoSignCtcNo").value = ctcNo2;
					hideNotice();
					return true;
				}
			}else{
				$("txtCoSignCtcNo").value = ctcNo2;
				hideNotice();
				return true;
			}
			
	}
	
	$("txtCoSignCtcDate").observe("blur", function(){
		if(this.value != ""){
			if (checkDate2(this.value)) {
				var iDateArray = this.value.split("-");
				var iDate = new Date();
				var date = parseInt(iDateArray[1], 10);
				var month = parseInt(iDateArray[0], 10);
				var year = parseInt(iDateArray[2], 10);
				iDate.setFullYear(year, month-1, date);
				iDate.format('mm-dd-yyyy');
	        	value = Date.parse(this.value, "mm-dd-yyyy").format('mm-dd-yyyy');
	        	var dateToday = new Date();
	            if(iDate > dateToday){
					showMessageBox("Cannot record future issuance of IDENTIFICATION.", imgMessage.INFO); //CTC to IDENTIFICATION - 05.14.2013 - SR #12502
					$("txtCoSignCtcDate").clear();
					$("txtCoSignCtcDate").focus();
					return false;
	            }else{
	            	return true;
	            }
			}else{
				$("txtCoSignCtcDate").clear();
				$("txtCoSignCtcDate").focus();
			}
		}	
		
	});
	
	$("txtCoSignCtcPlace").observe("blur", function(){
		this.value = this.value.toUpperCase();
	});
	
	$("editCoSignRemarks").observe("click", function(){
		showEditor("txtCoSignRemarks", 4000);
	});
	
	$("btnAddCoSign").observe("click", function(){
		ct = $("selCoSignControlType");
		controlTypeCd = ct.value;
		controlTypeDesc = ct.selectedIndex >= 0 ? ct.options[ct.selectedIndex].innerHTML :undefined;
/* 		if (controlTypeCd == defaultCtcNo && ($("txtCoSignCtcNo").value != "" || $("txtCoSignCtcDate").value != "" || $("txtCoSignCtcPlace").value != "")){ //comment out by koks 
			showConfirmBox("CONFIRMATION", "ID Type "+controlTypeDesc+" for Principal Co-Signatory requires no entries on ID Number, Issue Date, and Issue Place. These fields will be blank. Do you want to continue?",
					"Yes", "No",
					function(){
						$("txtCoSignCtcNo").value = "";
						$("txtCoSignCtcDate").value = "";
						$("txtCoSignCtcPlace").value = "";
 						if (checkCoSignor()){
 							if(checkAllRequiredFieldsInDiv("coSignatoryInfo")){ //jeffdojello 12.26.2013
 								addCoSignatory();	
 							}
 						}
						//addCosignatory(); //jeffdojello 12.26.2013
					}, "", "");
		} else {
 			if (checkCoSignReqFields() && checkCoSignor() && checkCoSignCtcNo()) {
				if (checkCoSignReqFields() && checkCoSignCtcNo()) {
					if(checkAllRequiredFieldsInDiv("coSignatoryInfo")){ //marco - 05.11.2013
						addCoSignatory();	
					}
				}
 			}
		} */
		
		if (checkCoSignReqFields() && checkCoSignor() && checkCoSignCtcNo()) { //koks 3.19.14
			if (checkCoSignReqFields() && checkCoSignCtcNo()) {
				if(checkAllRequiredFieldsInDiv("coSignatoryInfo")){ //marco - 05.11.2013
					addCoSignatory();	
				}
			}
		}
	});
	$("txtCoSignDesignation").observe("blur", function(){
		this.value = this.value.toUpperCase();
	});
	$("txtCoSignor").observe("blur", function(){
		this.value = this.value.toUpperCase();
	});
	populateCoSignDetails(null);
	
	$("selCoSignControlType").observe("change", function(){
		toggleReadOnlyFields();
	});
</script>