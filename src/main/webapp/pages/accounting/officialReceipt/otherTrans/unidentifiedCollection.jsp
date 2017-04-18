<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="unidentifiedCollectionDiv">
	<!-- HIDDEN FIELDS -->
	<input type="hidden" id="ucHiddenSlTypeCd" value="" />
	<input type="hidden" id="ucGuncTranId" value="" />
	<input type="hidden" id="ucHiddenGlAcctId" value="" />
	<input type="hidden" id="ucHiddenSlCd" value="" />
	<input type="hidden" id="ucHiddenGuncTranId" value="" />	
	<input type="hidden" id="ucHiddenOrPrintTag" value="" />
	
	<input type="hidden" id="ucHiddenAmount" value="" />
	<!-- END HIDDEN FIELDS -->
	
	<div id="unspecifiedCollnsTableGridDiv" style= "padding: 10px;">
		<div id="unspecifiedCollnsTableGrid" style="height: 300px;"></div>
	</div>
	<div style="height:30px; width: 900px; margin:0 auto; padding:5px 0 10px;">
		<table  align="right">
			<tr>
				<td class="rightAligned" >Total Collection:</td>
				<td ><input class="rightAligned"  type="text" id="ucCollnsTotal" name="ucCollnsTotal" readonly="readonly" tabindex=101/></td>
			</tr>
		</table>
	</div>
	<div id="unspecifiedCollnsFormDiv" name="unspecifiedCollnsFormDiv">
		<table align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned" style="width: 130px;"> Item No.</td>
				<td class="leftAligned" style="width: 320px;"><input type="text" id="ucItemNo" style="width: 130px;" class="rightAligned required" maxlength="2" tabIndex="101"/></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px">Tran Type</td>
				<td class="leftAligned" style="width: 320px">
					<select id="ucTranType" style="width: 327px;" class="required" tabIndex="102">
						<option></option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px;"> Old Transaction No.</td>
				<td class="leftAligned" style="width: 50px;">
					<table style="border-collapse:collapse;">
						<td style="width:178px">
								<input type="text" id="ucTranYear" name="ucTranYear" maxLength="4"  style="width: 50px;" value="" class="rightAligned refund txtReadOnly" tabIndex="103"/> 
								<input type="text" id="ucTranMonth" name="ucTranMonth" maxLength="2" style="width: 25px;" value="" class="rightAligned refund" tabIndex="104"/> 
								<input type="text" id="ucTranSeqNo" name="ucTranSeqNo" maxLength="5" style="width: 50px;" value="" class="rightAligned refund" tabIndex="105"/> 
								<div  style="width: 10px; height: 15px; padding:3px 0 0 2px; float:right;">
									<img id="oscmOldTranNo" name="imgSearch" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" tabIndex="106"/>
								</div>
						</td>
						<td>
							<label style="float: none; margin-left: 11px;">Old Item No.</label>
							<input type="text" id="ucOldItemNo" name="ucOldItemNo" maxLength="2" style="width: 50px;" value="" class="rightAligned refund" tabIndex="107"/> 
						</td>
					</table>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px">Account Code</td>	
				<td class="leftAligned" style="width: 320px; padding-right:2px;">
					<input type="text" id="glAcctCategory" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="108" />
					<input type="text" id="glControlAcct" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="109" />
					<input type="text" id="acctCode1" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="110" />
					<input type="text" id="acctCode2" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="111" />
					<input type="text" id="acctCode3" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="112" />
					<input type="text" id="acctCode4" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="113" />
					<input type="text" id="acctCode5" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="114" />
					<input type="text" id="acctCode6" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="115" />
					<input type="text" id="acctCode7" style="width: 22px; height: 15px;" maxLength="2" class="rightAligned acctCds"  tabIndex="116" />
					<div  style="width: 10px; height: 15px; padding:3px 2px 0 0; float:right;">
						<img id="oscmAcctCode" name="oscmAcctCode" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" tabIndex="117"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px">Account Name</td>
				<td class="leftAligned" style="width: 320px"><input type="text" id="ucAcctName" readonly="readonly" style="width: 320px;" tabIndex="118"/></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px">SL Name</td>
				<td class="leftAligned" style="width: 320px">
					<div id="slNameDiv" style=" border: 1px solid gray; width: 326px; height: 21px; float: left; overflow:hidden;">
						<input style="width: 300px; border: none; float: left;" id="ucSlName" name="ucSlName" type="text" value="" class="leftAligned" disabled="disabled" tabIndex="119"/> 
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmSlName" name="oscmSlName" alt="Go" tabIndex="120"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px">Amount</td>
				<!-- added errorMsg attribute : shan 10.29.2013 -->
				<td class="leftAligned" style="width: 320px"><input type="text" id="ucAmount" style="width: 320px;" class="money  required" tabIndex="121" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px">Particulars</td>
				<td class="leftAligned" style="width: 320px">  
					<div id="ucParticularsDiv" style="border: 1px solid gray; height: 21px; width: 326px;">
						<input type="text" id="ucParticulars" style="width: 300px; border: none; height: 13px; float: left;" tabIndex="122"/>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" name="editParticulars" maxlength="300" tabIndex="123"/>
					</div>
				</td>	
			</tr>
		</table>
	</div>
	<div style="margin-top: 30px; margin-bottom: 10px;">
		<input type="button" style="width:90px;" id="btnSlAdd" name="btnSlAdd" class="button cancelORBtn" value="Add" tabIndex="124"/>
		<input type="button" style="width:90px;" id="btnSlDelete" name="btnSlDelete"	class="disabledButton cancelORBtn" value="Delete" tabIndex="125"/>
	</div>	
</div>
<div id="unspecifiedCollnsFormButtonsDiv" class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 90px;" id="btnSlCancel" name="btnSlCancel" class="button" value="Cancel" tabIndex="126"/>
	<input type="button" style="width: 90px;" id="btnSlSave" name="btnSlSave" class="button cancelORBtn" value="Save" tabIndex="127"/>
</div> 

<script>
	setModuleId("GIACS014");
	setDocumentTitle("Unspecified Collections");
	var objLblValues = new Object();
	//var itemNoList = ('${itemNoList}');	
	var objTranType = eval('${tranTypeListJSON}');
	populateTranTypeDtls(objTranType, 0);
	initializeAllMoneyFields();
	$("ucCollnsTotal").value = formatCurrency('${totalCollnAmt}').truncate(13, "...");
	
	try {
		var objCollnsArray = [];
		var objUnspecifiedCollns = new Object();
		objUnspecifiedCollns.objUnspecifiedCollnsTableGrid = JSON.parse('${unspecifiedCollnsListJSON}'.replace(/\\/g, '\\\\'));
		objUnspecifiedCollns.unspecifiedCollnsList = objUnspecifiedCollns.objUnspecifiedCollnsTableGrid.rows || [];
		
		var tableModel = {
				url: contextPath+"/GIACUnidentifiedCollnsController?action=showUnidentifiedCollection&refresh=1&gaccTranId="+objACGlobal.gaccTranId+"&fundCd="+objACGlobal.fundCd,
				
				options:{
					hideColumnChildTitle: true,
					title: '',
					height: '285px',
					onCellFocus: function(element, value, x, y, id) {
						unspecifiedCollnsTableGrid.keys.releaseKeys();
						var obj = unspecifiedCollnsTableGrid.geniisysRows[y];
						populateUnspecifiedCollns(obj);
					},
					onCellBlur : function() {
						observeChangeTagInTableGrid(unspecifiedCollnsTableGrid);
					},
					onRemoveRowFocus: function(){
						unspecifiedCollnsTableGrid.keys.releaseKeys();
						$("ucTranType").selectedIndex 	= 0;
						populateUnspecifiedCollns(null, "");
					},
					onSort: function () {
						unspecifiedCollnsTableGrid.keys.releaseKeys();
						populateUnspecifiedCollns(null , "");
					},
					beforeSort: function(){
						if (changeTag == 1) {
							showConfirmBox4("CONFIRMATION",
									objCommonMessage.WITH_CHANGES, "Yes", "No",
									"Cancel", function() {
										saveUnidentifiedCollns();
									}, 
									function() {
										showUnidentifiedCollection();
										changeTag = 0;
									}, "");
							return false;
						}else{
							return true;
						}
					},
					postPager: function() {
						unspecifiedCollnsTableGrid.keys.releaseKeys();
						populateUnspecifiedCollns(null , "");
					},
					toolbar : {
						elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
						onRefresh: function(){
							unspecifiedCollnsTableGrid.keys.releaseKeys();
							populateUnspecifiedCollns(null , "");
						},
						onFilter: function(){
							unspecifiedCollnsTableGrid.keys.releaseKeys();
							populateUnspecifiedCollns(null , "");
						}
					}
				},
				columnModel: [
					{	id: 'recordStatus', 	
					    title: '',
					    width: '0',
					   	visible: false,
					    editor: 'checkbox' 					
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					
				    {	id: 'itemNo',
				    	title: 'Item No.',
		 			    width: '54px',
		 			    align: 'right',
		 			    filterOption : true,
		 			   	renderer: function(value){
	            			return lpad(value, 2, 0);
	            	    }
				    },
					{
					    id : 'tranType',
					    width: '0',
					    visible: false
					},
					{
		                id : 'tranTypeDesc',
		                title: 'Tran Type',
		                width : 130,
					    align: 'left',
		 			    filterOption : true
		            },
				    {	id: 'fundCode',
				    	title: 'Fund Code',
		 			    width: '64px',
		 			    align: 'left',
		 			    defaultValue: objACGlobal.fundCd,
		 			    filterOption : true
				    },
				    {	id: 'oldTranNos2',
				    	title: 'Old Tran No.',
		 			    width: '90px',
		 			    align: 'left',
		 			    filterOption : true
				    },
				    {	id: 'guncItemNo',
				    	title: 'Old Item No.',
		 			    width: '70px',
		 			    align: 'right',
		 			    filterOption : true,
		 			   	renderer: function(value){
	            			return value == "" ? "" : lpad(value, 2, 0);
	            	    }
				    },
				    {	id: 'glAcctName',
				    	title: 'Account Name',
		 			    width: '170px',
		 			    align: 'left',
		 			    filterOption : true
				    },
				    {	id: 'particulars',
				    	title: 'Particulars',
		 			    width: '150px',
		 			    align: 'left',
		 			    filterOption : true
				    },
				    {	id: 'collAmt',
				    	title: 'Amount',
		 			    width: '135px',
		 			    align: 'right',
		 			    filterOption : true,
					    renderer: function(value){
	            			return formatCurrency(value);
	            	    }
				    },
				    {	id: 'glAcctId',
				    	width: '0',
						visible: false
				    },
				    {	id: 'slCd',
				    	width: '0',
						visible: false
				    },
				    {	id: 'guncTranId',
				    	width: '0',
						visible: false
				    },
				    {	id: 'gsltSlTypeCd',
				    	width: '0',
						visible: false
				    },
				    {	id: 'tranYear',
				    	width: '0',
						visible: false
				    },
				    {	id: 'tranMonth',
				    	width: '0',
						visible: false
				    },
				    {	id: 'tranSeqNo',
				    	width: '0',
						visible: false
				    }
				],
				rows: objUnspecifiedCollns.unspecifiedCollnsList
			};

			unspecifiedCollnsTableGrid = new MyTableGrid(tableModel);
			unspecifiedCollnsTableGrid.pager = objUnspecifiedCollns.objUnspecifiedCollnsTableGrid;
			unspecifiedCollnsTableGrid.render('unspecifiedCollnsTableGrid');
			unspecifiedCollnsTableGrid.afterRender = function(){
				objCollnsArray = unspecifiedCollnsTableGrid.geniisysRows;
				totalCollnAmt = 0;
				if(objCollnsArray.length != 0){
					totalCollnAmt = objCollnsArray[0].totalCollnAmt;
				}
				$("ucCollnsTotal").value = formatCurrency(totalCollnAmt).truncate(13, "...");
				
				generateItemNo();	
			};
	} catch (e) {
		showErrorMessage("unidentifiedCollection.jsp",e);
	}	
	
	$("ucTranType").observe("change", function (){
		if (this.value == 1) {
			resetFieldBehavior();
			resetFieldsForTranTypeOne();	
		}else if (this.value == 2){
			resetFieldBehavior();
			resetFieldsForTranTypeTwo();
		}else{
			resetFieldBehavior();
		}
	});
	
	$("btnSlAdd").observe("click", function () {
		var selectedTrans = $("ucTranType").options[$("ucTranType").selectedIndex].getAttribute("tranTypeCode");
		if(selectedTrans == 1){ 
			if(checkRequiredFields()){
				validateAcctCodes();
			}
		}else{
			if(checkRequiredFields()){
				if (checkIfOldTranExistInList($F("ucHiddenGuncTranId"), $F("ucOldItemNo"))){
					validateOldTranNo();
				}
			}
		}
	});
	
	function addUnidentifiedCollns(){
		try{
			//var ok = checkRequiredFields();
			var newObj = setGIACUnidentifiedCollns();
			if ($F("btnSlAdd") == "Update"){
				newObj = setGIACUnidentifiedCollns();
				for(var i=0; i<objCollnsArray.length; i++){
					if(( objCollnsArray[i].recordStatus != -1)
							&&(objCollnsArray[i].gaccTranId == newObj.gaccTranId)
							&&(objCollnsArray[i].itemNo == newObj.itemNo)){
						newObj.recordStatus = 1;
						computeTotalCollnsAmt(newObj.collAmt);
						objCollnsArray.splice(i, 1, newObj);
						unspecifiedCollnsTableGrid.updateVisibleRowOnly(newObj, unspecifiedCollnsTableGrid.getCurrentPosition()[1]);
					}
				} 
			}else{
				newObj.recordStatus = 0;
				computeTotalCollnsAmt(newObj.collAmt);
				unspecifiedCollnsTableGrid.addBottomRow(newObj);	
				objCollnsArray.push(newObj);
			}
			changeTag = 1;
			populateUnspecifiedCollns(null);
		}catch (e){
			showErrorMessage("unidentifiedCollection.jsp - Add Unidentified Collection", e);
		}
	}
	
	function deleteUnidentifiedCollns(){
		try{
			var delObj = setGIACUnidentifiedCollns();
			
			if(delObj.orPrintTag == "Y"){
				showMessageBox("Delete not allowed. This record was created before the OR was printed",
								imgMessage.ERROR);
				return false;
			}else{
				new Ajax.Request(contextPath+"/GIACUnidentifiedCollnsController", {		// validation added by shan 10.30.2013
					parameters: {
						action:		"validateDelRec",
						gaccTranId:	delObj.gaccTranId,
						itemNo:		delObj.itemNo
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							for(var i=0; i<objCollnsArray.length; i++){
								if(( objCollnsArray[i].recordStatus != -1)
										&&(objCollnsArray[i].gaccTranId == delObj.gaccTranId)
										&&(objCollnsArray[i].itemNo == delObj.itemNo)){
									delObj.recordStatus = -1;
									computeTotalCollnsAmt(-1*delObj.collAmt);
									objCollnsArray.splice(i, 1, delObj);
									unspecifiedCollnsTableGrid.deleteRow(unspecifiedCollnsTableGrid.getCurrentPosition()[1]);
									changeTag = 1;
								}
							}
							resetFieldBehavior();
						}
					}
				});
			}
		}catch (e){
			showErrorMessage("unidentifiedCollection.jsp - Delete Unidentified Collection", e);

		}
	}
	
	$("btnSlDelete").observe("click", function (){
		deleteUnidentifiedCollns();
	});


	function setGIACUnidentifiedCollns(){
		var newObj = new Object();
		var selectedTrans = $("ucTranType").options[$("ucTranType").selectedIndex].getAttribute("tranTypeCode");

		try{
			newObj.gaccTranId  		= objACGlobal.gaccTranId;
			newObj.itemNo			= $F("ucItemNo");
			newObj.tranType			= $("ucTranType").options[$("ucTranType").selectedIndex].getAttribute("tranTypeCode");
			newObj.tranTypeDesc		= $("ucTranType").options[$("ucTranType").selectedIndex].text;
			newObj.collAmt			= unformatCurrency("ucAmount");		
			newObj.glAcctCategory 	= $F("glAcctCategory");
			newObj.glCtrlAcct		= $F("glControlAcct");
			newObj.glSubAcct1   	= $F("acctCode1");
			newObj.glSubAcct2   	= $F("acctCode2");
			newObj.glSubAcct3   	= $F("acctCode3");
			newObj.glSubAcct4   	= $F("acctCode4");
			newObj.glSubAcct5   	= $F("acctCode5");
			newObj.glSubAcct6   	= $F("acctCode6");
			newObj.glSubAcct7   	= $F("acctCode7");
			newObj.glAcctName   	= $F("ucAcctName");
			newObj.orPrintTag		= $F("ucHiddenOrPrintTag") == "" ? "N" : $F("ucHiddenOrPrintTag");		// "N"; modified by shan 10.29.2013
			newObj.fundCode     	= objACGlobal.fundCd;
			newObj.oldTranNos2 		= selectedTrans == 1 ? "" : $F("ucTranYear") + "-" + lpad($F("ucTranMonth"), 2, 0) + "-" + lpad($F("ucTranSeqNo"), 5, 0);
			newObj.tranYear  		= $F("ucTranYear");
			newObj.tranMonth 		= $F("ucTranMonth");
			newObj.tranSeqNo 		= $F("ucTranSeqNo");
/* 			newObj.collectionAmt 	= unformatCurrency("ucAmount");	 */
			newObj.slName			= $F("ucSlName");
			newObj.guncItemNo		= $F("ucOldItemNo");
			newObj.particulars		= escapeHTML2($F("ucParticulars"));			
			newObj.glAcctId			= $F("ucHiddenGlAcctId");
			newObj.slCd				= $F("ucHiddenSlCd"); 
			newObj.guncTranId 		= $F("ucHiddenGuncTranId");
			newObj.gsltSlTypeCd 	= $F("ucHiddenSlTypeCd");
			
			return newObj;			    			
		}catch(e){
			showErrorMessage("setGIACUnidentifiedCollns", e);
		}
	}
	
	function saveUnidentifiedCollns(){
		try{
			var objParameters = new Object();
			
			objParameters.addModifiedUnidentifiedCollns = getAddedAndModifiedJSONObjects(objCollnsArray);
			objParameters.deletedUnidentifiedCollns  = getDeletedJSONObjects(objCollnsArray);
			
			new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=saveUnidentifiedCollnsDtls" , {
				method: "POST",
				parameters: {
					parameter: JSON.stringify(objParameters),
					gaccTranId: objACGlobal.gaccTranId,
					fundCd: objACGlobal.fundCd,
					branchCd: objACGlobal.branchCd,
					tranSource: objACGlobal.tranSource,
					orFlag: objACGlobal.orFlag
				},
				onCreate: function(){
					showNotice("Saving information, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if(nvl(response.responseText, "Saving successful.") == "Saving successful."){
						showMessageBox(response.responseText, imgMessage.SUCCESS);
						changeTag = 0;
						populateUnspecifiedCollns(null);
						unspecifiedCollnsTableGrid.refresh();
						lastAction();
						lastAction = "";
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveUnidentifiedCollns", e);
		}
	}	
	
	$("ucItemNo").observe("change", function () {
		var ucItemNo = this.value;
		if(parseInt($F("ucItemNo")) == 0){
			customShowMessageBox("Invalid value of Item No.", imgMessage.ERROR, "ucItemNo");
			this.clear();
		}else if (parseInt($F("ucItemNo")) <= 0 || parseFloat($F("ucItemNo")) <= 0){
			customShowMessageBox("Field must be of form 09.", imgMessage.ERROR, "ucItemNo");
			this.clear();
		}else if ($F("ucItemNo") == "" || $F("ucItemNo") == null){	
			customShowMessageBox("Field must be entered.", imgMessage.ERROR, "ucItemNo");
			this.clear();
		}else if (isNaN($F("ucItemNo")) || checkDecimal($F("ucItemNo"))){		
			customShowMessageBox("Field must be of form 09.", imgMessage.ERROR, "ucItemNo");
			this.clear();
		}else if(!checkExistingItemNoInList(ucItemNo)){
			customShowMessageBox("Item no is already existing.", imgMessage.ERROR, "ucItemNo");
			generateItemNo();
		}else{
			$("ucItemNo").value = parseInt($F("ucItemNo")).toPaddedString(2);
		}
	});
	
	$("ucAmount").observe("change", function () {
		var validAmount = $("ucHiddenAmount").value;
		var selectedTrans = $("ucTranType").options[$("ucTranType").selectedIndex].getAttribute("tranTypeCode");
		//added by shan 12.16.2013
		if (selectedTrans == 1){
			this.setAttribute("errorMsg", "Invalid amount. Valid value should be from 0.01 to 99,999,999,999,999.99.");
		}else if (selectedTrans == 2){
			this.setAttribute("errorMsg", "Invalid amount. Valid value should be from -0.01 to -99,999,999,999,999.99.");
		}
		// end
		if (selectedTrans == 1 && (isNaN(unformatCurrency("ucAmount")) || parseFloat($F("ucAmount")) > 99999999999999.99 || parseFloat($F("ucAmount")) < 0.01)){
			customShowMessageBox("Invalid amount. Valid value should be from  0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, "ucAmount");
			this.clear();
		}else if (selectedTrans == 2 && (isNaN(unformatCurrency("ucAmount")) || parseFloat($F("ucAmount")) < -99999999999999.99 || parseFloat($F("ucAmount")) > -0.01)){
			customShowMessageBox("Invalid amount. Valid value should be from  -0.01 to -99,999,999,999,999.99.", imgMessage.ERROR, "ucAmount");
			this.clear();
		}else if (selectedTrans == 2 && Math.abs($F("ucAmount")) > Math.abs(validAmount)){	
			customShowMessageBox("Reversible amount for this transaction should not exceed " + formatCurrency(Math.abs(validAmount) * -1) + ".", imgMessage.ERROR, "ucAmount");
			this.value = $F("ucHiddenAmount");
		}
		/* else if ($F("ucAmount") == "") {
			customShowMessageBox("Field must be entered", imgMessage.ERROR, "ucAmount");
		} */
	});
	
	$("ucTranYear").observe("change", function () {
		if (isNaN($F("ucTranYear")) || parseInt($F("ucTranYear")) < 0 || parseInt($F("ucTranYear")) > 9999 ||checkDecimal($F("ucTranYear"))){		
			customShowMessageBox("Invalid transaction year. Valid value should be from  0000 to 9999.", imgMessage.ERROR, "ucTranYear");
			this.clear();
		}
		// shan 10.29.2013
		if ($F("ucTranYear") != "" && $F("ucTranMonth") != "" && $F("ucTranSeqNo") != "" && $F("ucOldItemNo") != ""){
			showOldItemDtlsLOV();
		}else if ($F("ucTranYear") == "" || $F("ucTranMonth") == "" || $F("ucTranSeqNo") == ""){
			clearAcctCodeName();	
		}
	});
	
	$("ucTranMonth").observe("change", function () {
		if (isNaN($F("ucTranMonth")) || parseInt($F("ucTranMonth")) < 0 || parseInt($F("ucTranMonth")) > 12 ||checkDecimal($F("ucTranMonth"))){		
			customShowMessageBox("Invalid transaction month.  Valid value should be from 01 to 12.", imgMessage.ERROR, "ucTranMonth");
			this.clear();
		}
		// shan 10.29.2013
		if (this.value != ""){		
			this.value = formatNumberDigits(this.value, 2);
		}
		if ($F("ucTranYear") != "" && $F("ucTranMonth") != "" && $F("ucTranSeqNo") != "" && $F("ucOldItemNo") != ""){
			showOldItemDtlsLOV();
		}else if ($F("ucTranYear") == "" || $F("ucTranMonth") == "" || $F("ucTranSeqNo") == ""){
			clearAcctCodeName();	
		}
	});
	
	$("ucTranSeqNo").observe("change", function () {
		if (isNaN($F("ucTranSeqNo")) || parseInt($F("ucTranSeqNo")) < 0 || parseInt($F("ucTranSeqNo")) > 99999 ||checkDecimal($F("ucTranSeqNo"))){		
			customShowMessageBox("Invalid tran seq no.  Valid value should be from 00000 to 99999.", imgMessage.ERROR, "ucTranSeqNo");
			this.clear();
		}
		// shan 10.29.2013
		if (this.value != ""){		
			this.value = formatNumberDigits(this.value, 5);
		}
		if ($F("ucTranYear") != "" && $F("ucTranMonth") != "" && $F("ucTranSeqNo") != "" && $F("ucOldItemNo") != ""){
			showOldItemDtlsLOV();
		}else if ($F("ucTranYear") == "" || $F("ucTranMonth") == "" || $F("ucTranSeqNo") == ""){
			clearAcctCodeName();	
		}
	});
	
	$("ucOldItemNo").observe("change", function () {
		if (isNaN($F("ucOldItemNo")) || parseInt($F("ucOldItemNo")) < 0 || parseInt($F("ucOldItemNo")) > 99 ||checkDecimal($F("ucOldItemNo"))){		
			customShowMessageBox("Invalid old item no.  Valid value should be from 00 to 99.", imgMessage.ERROR, "ucOldItemNo");
			this.clear();
		}
		// shan 10.29.2013
		if (this.value != ""){		
			this.value = formatNumberDigits(this.value, 2);
		}
		if ($F("ucTranYear") != "" && $F("ucTranMonth") != "" && $F("ucTranSeqNo") != "" && $F("ucOldItemNo") != ""){
			showOldItemDtlsLOV();
		}else if ($F("ucTranYear") == "" && $F("ucTranMonth") == "" && $F("ucTranSeqNo") == ""){
			clearAcctCodeName();	
		}
	});

	/** shan 10.29.2013 **/
	function clearAcctCodeName(){
		$("ucTranYear").clear();
		$("ucTranMonth").clear();
		$("ucTranSeqNo").clear();
		$("ucOldItemNo").clear();
		$("glAcctCategory").clear();
		$("glControlAcct").clear();
		$("acctCode1").clear();
		$("acctCode2").clear();
		$("acctCode3").clear();
		$("acctCode4").clear();
		$("acctCode5").clear();
		$("acctCode6").clear();
		$("acctCode7").clear();
		$("ucAcctName").clear();
		$("ucSlName").clear();
		$("ucHiddenSlTypeCd").clear();
		$("ucHiddenGlAcctId").clear();
		$("ucHiddenSlCd").clear();
		$("ucHiddenGuncTranId").clear();
	}
	/** end 10.29.2013 **/
	
	function checkExistingItemNoInList(itemNo){
		try{
			var isOk = true;		
			for(var i=0; i<objCollnsArray.length; i++){
				if(itemNo == objCollnsArray[i].itemNo && objCollnsArray[i].recordStatus != -1){
					isOk = false;
				}
			}
			if(isOk){
				new Ajax.Request(contextPath+"/GIACUnidentifiedCollnsController?action=validateItemNo",{
					method: "POST",
					asynchronous: true,
					parameters:{
						itemNo: itemNo,
						gaccTranId: objACGlobal.gaccTranId
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							if(response.responseText == "Y"){
								customShowMessageBox("Item No is already existing.", imgMessage.ERROR, "ucItemNo");
								//$("ucItemNo").clear();
								//$("ucItemNo").focus();
								generateItemNo();
								isOk = false;
							}
						}
					}
				});
			}
			return isOk;
		}catch(e){
			showErrorMessage("checkExistingItemNoInList", e);
		}
	} 
	
	function checkIfOldTranExistInList(guncTranId, guncItemNo){
		try{
			var isOk = true;
			for(var i=0; i<objCollnsArray.length; i++){
				if(guncItemNo == objCollnsArray[i].guncItemNo && guncTranId == objCollnsArray[i].guncTranId && objCollnsArray[i].recordStatus != -1){
					isOk = false;
					showMessageBox("Row exists already!", imgMessage.ERROR);
				}
			}
			return isOk;
		}catch(e){
			showErrorMessage("checkIfOldTranExistInList", e);
		}
	}
	

	function checkDecimal(txtId){
		for(var i = 0; i < txtId.length; i++){
			if (txtId.charAt(i)=='.'){
				return true;
			}
		}
		return false;
	}
	
	function initializeAllOldTranNoFields(){
		$$("input[type='text'].refund").each(function (m) {
			m.observe("change", function() {
				if (m.value == null || m.value == "") {
					customShowMessageBox("Field must be entered.", imgMessage.ERROR, m.id);
				}
			});
		});
	} 
	
	function initializeAllAcctCdFields() {
		$$("input[type='text'].acctCds").each(function (m) {
			m.observe("change", function() {
				if (isNaN((m.value)) || parseInt(m.value) < 0 || checkDecimal(m.value) || parseInt(m.value) > 99) {
					customShowMessageBox("Invalid account code. Valid value should be from 01 to 99.", imgMessage.ERROR, m.id);
					m.clear();
				}else{
					getGLAccount();
				}
			});
		});
	}
	
	function validateOldTranNo(){
		try{
			new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=validateOldTranNo" , {
				method: "GET",
				parameters: {
					gaccFundCd: objACGlobal.fundCd,		//shan 10.29.2013
					gibrBranchCd: objACGlobal.branchCd,	//shan 10.29.2013
					gaccTranId: objACGlobal.gaccTranId,
					tranYear: $F("ucTranYear") == "" ? "" : $F("ucTranYear"),
					tranMonth: $F("ucTranMonth") == "" ? "" : $F("ucTranMonth"),
					tranSeqNo: $F("ucTranSeqNo") == "" ? "" : $F("ucTranSeqNo"),
					itemNo:	$F("ucOldItemNo") == "" ? "" : $F("ucOldItemNo")
				},
				onComplete: function (response) {
					var res = response.responseText;
					if (res == "Y"){
						validateOldItemNo();
						//addUnidentifiedCollns();
					}else{
						showMessageBox("Invalid Transaction No.", imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("validateOldTranNo", e);
		}
	}
	
	function validateOldItemNo(){
		try{
			new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=validateOldItemNo" , {
				method: "GET",
				parameters: {
					gaccTranId: $F("ucHiddenGuncTranId") == "" ? "" : $F("ucHiddenGuncTranId"),
					itemNo:	$F("ucOldItemNo") == "" ? "" : $F("ucOldItemNo")
				},
				onComplete: function (response) {
					var res = response.responseText;
					if (res == "Y"){
						addUnidentifiedCollns();
					}else{
						showMessageBox("This Old Item No. does not exist.", imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("validateOldItemNo", e);
		}
	}

	function validateAcctCodes(){
		try{
			new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=validateAcctCode" , {
				method: "GET",
				parameters: {
					glAcctCategory: $F("glAcctCategory"), //== "" ? $F("glAcctCategory") : parseInt($F("glAcctCategory")),
					glControlAcct: $F("glControlAcct"), //== "" ? $F("glControlAcct") : parseInt($F("glControlAcct")),
					glSubAcct1: $F("acctCode1"), //== "" ? $F("acctCode1") : parseInt($F("acctCode1")),
					glSubAcct2: $F("acctCode2"), //== "" ? $F("acctCode2") : parseInt($F("acctCode2")),
					glSubAcct3: $F("acctCode3"), //== "" ? $F("acctCode3") : parseInt($F("acctCode3")),
					glSubAcct4: $F("acctCode4"), //== "" ? $F("acctCode4") : parseInt($F("acctCode4")),
					glSubAcct5: $F("acctCode5"), //== "" ? $F("acctCode5") : parseInt($F("acctCode5")),
					glSubAcct6: $F("acctCode6"), //== "" ? $F("acctCode6") : parseInt($F("acctCode6")),
					glSubAcct7: $F("acctCode7"), //== "" ? $F("acctCode7") : parseInt($F("acctCode7")),
					fundCd: objACGlobal.fundCd
				},
				onComplete: function (response) {
					var res = response.responseText;
					if (res.length <= 2){
						showMessageBox("Account Code does not exist.", imgMessage.ERROR);
					}else{
						validAcctCd = "true";
						addUnidentifiedCollns();
					}
				}
			});
		}catch(e){
			showErrorMessage("validateAcctCodes", e);
		}
	}
	
	function getGlAcctObj() {
		var acctIdObj = new Object();
		acctIdObj.glAcctCategory	=	$F("glAcctCategory") == "" ? "" : parseInt($F("glAcctCategory"));
		acctIdObj.glControlAcct		=	$F("glControlAcct") == "" ? "" : parseInt($F("glControlAcct"));
		acctIdObj.glSubAcct1		=	$F("acctCode1") == "" ? "" : parseInt($F("acctCode1"));
		acctIdObj.glSubAcct2		=	$F("acctCode2") == "" ? "" : parseInt($F("acctCode2"));
		acctIdObj.glSubAcct3		=	$F("acctCode3") == "" ? "" : parseInt($F("acctCode3"));
		acctIdObj.glSubAcct4		=	$F("acctCode4") == "" ? "" : parseInt($F("acctCode4"));
		acctIdObj.glSubAcct5		=	$F("acctCode5") == "" ? "" : parseInt($F("acctCode5"));
		acctIdObj.glSubAcct6		=	$F("acctCode6") == "" ? "" : parseInt($F("acctCode6"));
		acctIdObj.glSubAcct7		=	$F("acctCode7") == "" ? "" : parseInt($F("acctCode7"));
		return JSON.stringify(acctIdObj);
	}
	
	function getGLAccount() {
		try {
			var valid = true;
			$$("input[type='text'].acctCds").each(function(gl) {
				if(gl.value == "") {
					valid = false;
				}
			});
			
			if(valid) {
				new Ajax.Request(contextPath+"/GIACUnidentifiedCollnsController", {
					method: "GET",
					parameters: {
						action: "retrieveGlAcct",
						glAcctObj: getGlAcctObj()
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response) {
						var res = JSON.parse(response.responseText);
						if(res.empty != true) {
							$("ucAcctName").value 	= res.glAcctName;
							$("ucHiddenGlAcctId").value 	= res.glAcctId;
							$("ucHiddenSlTypeCd").value	= res.gsltSlTypeCd;
							if(res.gsltSlTypeCd == null || res.gsltSlTypeCd == "") {
								$("ucSlName").removeClassName("required");
								$("slNameDiv").removeClassName("required");
								$("ucSlName").style.backgroundColor = "#FFFFFF";
								disableSearch("oscmSlName");
							} else {
								$("ucSlName").addClassName("required");
								$("slNameDiv").addClassName("required");
								$("ucSlName").style.backgroundColor = "#FFFACD";
								enableSearch("oscmSlName");
							}
						} else {
							showMessageBox("Account Code does not exist.", imgMessage.ERROR);
							$("ucAcctName").value 	= "";
							$("ucSlName").value 	= "";
							$("ucHiddenGlAcctId").value 	= "";
							$("ucHiddenSlTypeCd").value   = "";
							$("ucHiddenSlCd").value = "";
							/* shan 10.29.2013 */
							$("glAcctCategory").value = "";
							$("glControlAcct").value = "";
							$("acctCode1").value = "";
							$("acctCode2").value = "";
							$("acctCode3").value = "";
							$("acctCode4").value = "";
							$("acctCode5").value = "";
							$("acctCode6").value = "";
							$("acctCode7").value = "";
							/* end 10.29.2013 */
							
							$("ucSlName").removeClassName("required");
							$("slNameDiv").removeClassName("required");
							$("ucSlName").style.backgroundColor = "#FFFFFF";
							disableSearch("oscmSlName");
						}
					}
				});
			} else {
				$("ucAcctName").value 	= "";
				$("ucSlName").value 	= "";
				$("ucHiddenGlAcctId").value 	= "";
				$("ucHiddenSlTypeCd").value 	= "";
			}
		} catch(e) {
			showErrorMessage("getGLAccount", e);
		}
	}
	
	function checkRequiredFields(){
		try{
			var isOk = true;
			var fields = ["ucItemNo", "ucTranType", "ucAmount"];
			var collnsFields = ["ucTranType", "glAcctCategory", "glControlAcct", "acctCode1", "acctCode2",
			                    "acctCode3", "acctCode4", "acctCode5", "acctCode6", "acctCode7", "ucAmount"]; //"ucAcctName", 
			var refundFields = ["ucTranYear", "ucTranMonth", "ucTranSeqNo", "ucOldItemNo", "ucAmount"];
			
			/* shan 10.29.2013 */
			if ($("ucItemNo").value.blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "ucItemNo");
				isOk = false;
				return false;
			}
			/* end 10.29.2013 */
			
			if($("ucTranType").value.blank()){
				for(var i=0; i<fields.length; i++){
					if($(fields[i]).value.blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "ucTranType");
						$(fields[i]).focus();
						isOk = false;
						return false;
					}
				}
			}
			
			if($("ucTranType").value == 1){
				for(var i=0; i<collnsFields.length; i++){
					if($(collnsFields[i]).value.blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "ucTranType");
						$(collnsFields[i]).focus();
						isOk = false;
						return false;
					}
				}
			}
	
			if($("ucTranType").value == 2){
				for(var i=0; i<refundFields.length; i++){
					if($(refundFields[i]).value.blank()){
						customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "ucTranType");
						$(refundFields[i]).focus();
						isOk = false;
						return false;
					}
				}
			}
			
			$$("input[type='text'].acctCds").each(function (m) {
				if (isNaN((m.value)) || parseInt(m.value) < 0 || checkDecimal(m.value) || parseInt(m.value) > 99) {
					customShowMessageBox("Invalid account code. Valid value should be from 01 to 99.", imgMessage.ERROR, m.id);
					m.clear();
					isOk = false;
					return false;
				}
			});
			return isOk;
		}catch(e){
			showErrorMessage("checkRequiredFields", e);
		}
	}
	
	$("oscmAcctCode").observe("click", function() {
		showAccountCodeLOV();
	});

	$("oscmSlName").observe("click", function() {
		var slTypeCd = $F("ucHiddenSlTypeCd");
		var fundCd = objACGlobal.fundCd;
		showUnidentifiedCollnsSlListLOV(slTypeCd, fundCd);
	});

	$$("img[name='imgSearch']").each(function(img) {
		img.observe("click", function() {
			//var notIn = "";
			//var notIn2 = "";
			/* var withPrevious = false;
			for ( var i = 0; i < objCollnsArray.length; i++) {
				if (objCollnsArray[i].recordStatus != -1) {
					if(withPrevious) notIn += ",";
					if(withPrevious) notIn2 += ",";
					notIn += nvl(objCollnsArray[i].guncTranId, 0);
					notIn2 += nvl(objCollnsArray[i].guncItemNo, 0);
					withPrevious = true;
				}
			}
			notIn = (notIn != "" ? "("+notIn+")" : "");
			notIn2 = (notIn2 != "" ? "("+notIn2+")" : ""); */
			showOldItemDtlsLOV();
		});
	});

	$("editParticulars").observe("click", function() {
		if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){ //added by steven 8.16.2012
			showEditor("ucParticulars", 300,"true");
		}else{
			if($F("btnSlAdd") == "Update" && $("btnSlAdd").disabled == true){
				showEditor("ucParticulars", 300, "true");
			}else{
				showEditor("ucParticulars", 300);
			}
		}
	});

	function showAddDeleteButton(param, recStatus) {
		if (param) {
			$("btnSlAdd").value = "Add";
			disableButton("btnSlDelete");
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){	//added by steve 8.16.2012
				enableButton("btnSlAdd");
			}
		} else {
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){	//added by steve 8.16.2012
				enableButton("btnSlDelete");
			}
			if (recStatus === 0 || recStatus === 1) {
				$("btnSlAdd").value = "Update";
				if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){	//added by steve 8.16.2012
					enableButton("btnSlAdd");
				}
			} else if (recStatus === "") {
				$("btnSlAdd").value = "Update";
				disableButton("btnSlAdd");
				disableAllFields();
			} else {
				$("btnSlAdd").value = "Add";
				disableButton("btnSlAdd");
			}
		}
	}

	function populateTranTypeDtls(obj, value) {
		$("ucTranType").update(
				'<option value="" tranTypeCode="" tranTypeDesc=""></option>');
		var options = "";
		for ( var i = 0; i < obj.length; i++) {
			options += '<option value="'+obj[i].rvLowValue+'" tranTypeCode="'+obj[i].rvLowValue+'" tranTypeDesc="'+obj[i].rvMeaning+'">'
					+ obj[i].rvLowValue
					+ " - "
					+ obj[i].rvMeaning
					+ '</option>';
		}
		$("ucTranType").insert({
			bottom : options
		});
		$("ucTranType").selectedIndex = value;
	}

	function generateItemNo() {
		var maxItemNo = '${maxItemNo}';
		var lastItemNo = 0;
		for ( var i = 0; i < objCollnsArray.length; i++) {
			if ((parseInt(objCollnsArray[i].itemNo) > lastItemNo)
					&& (objCollnsArray[i].recordStatus != -1)) {
				lastItemNo = parseInt(objCollnsArray[i].itemNo);
			}
		}
		if (parseInt(maxItemNo) > parseInt(lastItemNo)) {
			lastItemNo = parseInt(maxItemNo);
		}
		return $("ucItemNo").value = (parseInt(lastItemNo) + 1).toPaddedString(2);
	}

	function disableAllFields() {
		$("ucItemNo").readOnly = true;	
		$("ucTranType").disabled = true;
		$("glAcctCategory").disabled = true;
		$("glControlAcct").disabled = true;
		$("acctCode1").disabled = true;
		$("acctCode2").disabled = true;
		$("acctCode3").disabled = true;
		$("acctCode4").disabled = true;
		$("acctCode5").disabled = true;
		$("acctCode6").disabled = true;
		$("acctCode7").disabled = true;
		$("ucAmount").disabled = true;
		$("ucTranYear").readOnly = true;
		$("ucTranMonth").readOnly = true;
		$("ucTranSeqNo").readOnly = true;
		$("ucOldItemNo").readOnly = true;
		$("ucParticulars").readOnly = true;

		disableSearch("oscmOldTranNo");
		disableSearch("oscmAcctCode");
		disableSearch("oscmSlName");

		/* $$("img[name='editParticulars']").each(function(image) {
			image.hide();
		}); */
	}
	
	function resetFieldBehavior() {
		resetFields();
		showAddDeleteButton(true, "");
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ //added by steven 08.16.2012
			$("ucTranType").disabled = false;
		}
		//$("ucItemNo").readOnly = true;		// shan 10.29.2013 ucItemNo should not be read-only		
		$("ucAmount").disabled = true;
		$("ucParticulars").readOnly = true;
		$("ucSlName").style.backgroundColor = "#FFFFFF";
		disableSearch("oscmOldTranNo");
		disableSearch("oscmAcctCode");
		disableSearch("oscmSlName");
		$("ucAmount").style.backgroundColor = "#FFFFFF";
		$$("img[name='editParticulars']").each(function(image) {
			image.hide();
		});
		$$("input[type='text'].acctCds").each(function(m) {
			$(m.id).disabled = true;
			m.style.backgroundColor = "#FFFFFF";
		});
		$$("input[type='text'].refund").each(function(m) {
			$(m.id).disabled = true;
			m.style.backgroundColor = "#FFFFFF";
		});
		removeClassNameRequired();
	}

	function removeClassNameRequired() {
		$("ucTranYear").removeClassName("required");
		$("ucTranMonth").removeClassName("required");
		$("ucTranSeqNo").removeClassName("required");
		$("ucOldItemNo").removeClassName("required");
		$("ucSlName").removeClassName("required");
		$("slNameDiv").removeClassName("required");
		$("ucAmount").removeClassName("required");
	}

	function resetFieldsForTranTypeOne() {
		$("ucTranType").selectedIndex = 1;
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ //added by steven 8.16.2012
			enableSearch("oscmAcctCode");
			$("glAcctCategory").disabled = false;
			$("glControlAcct").disabled = false;
			$("acctCode1").disabled = false;
			$("acctCode2").disabled = false;
			$("acctCode3").disabled = false;
			$("acctCode4").disabled = false;
			$("acctCode5").disabled = false;
			$("acctCode6").disabled = false;
			$("acctCode7").disabled = false;
			$("ucAmount").disabled = false;
			$("ucAmount").readOnly = false;
			$("ucParticulars").readOnly = false;
			$("ucAmount").addClassName("required");
			$$("input[type='text'].acctCds").each(function(m) {
				m.style.backgroundColor = "#FFFACD";
			});
			$("ucAmount").style.backgroundColor = "#FFFACD";
		}
		$$("img[name='editParticulars']").each(function(image) {
			image.show();
		});
	}

	function resetFieldsForTranTypeTwo() {
		$("ucTranType").selectedIndex = 2;
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ //added by steven 8/15/2012
			enableSearch("oscmOldTranNo");
			$("ucTranYear").readOnly = false;
			$("ucTranMonth").readOnly = false;
			$("ucTranSeqNo").readOnly = false;
			$("ucOldItemNo").readOnly = false;
			$("ucAmount").disabled = false;
			$("ucAmount").readOnly = false;
			$("ucParticulars").readOnly = false;
			$("ucAmount").style.backgroundColor = "#FFFACD";
			$$("input[type='text'].refund").each(function(m) {
				$(m.id).disabled = false;
			});
			$$("input[type='text'].refund").each(function(m) {
				m.style.backgroundColor = "#FFFACD";
				$(m.id).addClassName("required");
			});
		}
		$$("img[name='editParticulars']").each(function(image) {
			image.show();
		});
	}

	function resetFields() {
		$("ucTranType").selectedIndex = 0;
		$("glAcctCategory").value = "";
		$("glControlAcct").value = "";
		$("acctCode1").value = "";
		$("acctCode2").value = "";
		$("acctCode3").value = "";
		$("acctCode4").value = "";
		$("acctCode5").value = "";
		$("acctCode6").value = "";
		$("acctCode7").value = "";
		$("ucAmount").value = "";
		$("ucTranYear").value = "";
		$("ucTranMonth").value = "";
		$("ucTranSeqNo").value = "";
		$("ucOldItemNo").value = "";
		$("ucParticulars").value = "";
		$("ucAcctName").value = "";
		$("ucSlName").value = "";
		$("ucHiddenSlTypeCd").value = "";
		$("ucGuncTranId").value = "";
		$("ucHiddenGlAcctId").value = "";
		$("ucHiddenSlCd").value = "";
		//$("ucHiddenSlName").value = "";
		$("ucHiddenGuncTranId").value = "";
		$("ucHiddenAmount").value = "";
	}

	function populateUnspecifiedCollns(obj) {
		resetFieldBehavior();
		if (obj == null) {
			showAddDeleteButton(true, "");
			generateItemNo();
		} else {
			if (obj.tranType == '2') {
				resetFieldsForTranTypeTwo();

			} else {
				resetFieldsForTranTypeOne();
			}
			$("ucItemNo").readOnly = true;		
			$("ucTranType").disabled = true;

			if (obj.oldTranNos2 != null) {
				var oldTranNoArray = (nvl(obj.oldTranNos2.split("-"), ""));
				$("ucTranYear").value = oldTranNoArray[0]  == null || oldTranNoArray[0] == "" ? "" : oldTranNoArray[0];
				$("ucTranMonth").value = oldTranNoArray[1] == null || oldTranNoArray[1] == "" ? "" : oldTranNoArray[1];
				$("ucTranSeqNo").value = oldTranNoArray[2] == null || oldTranNoArray[2] == "" ? "" : oldTranNoArray[2];
				$("ucOldItemNo").value = obj.oldTranNos2   == null || obj.oldTranNos2 == "" ? "" : parseInt(obj.guncItemNo).toPaddedString(2);
			}
			$("ucItemNo").value = (nvl(parseInt(obj.itemNo).toPaddedString(2),""));
			$("ucTranType").value = obj.tranType;
			$("ucAmount").value = (nvl(formatCurrency(obj.collAmt), ""));
			$("ucParticulars").value = (nvl(unescapeHTML2(obj.particulars), ""));
			$("glAcctCategory").value = parseInt(obj.glAcctCategory).toPaddedString(2);
			$("glControlAcct").value = parseInt(obj.glCtrlAcct).toPaddedString(2);
			$("acctCode1").value = parseInt(obj.glSubAcct1).toPaddedString(2);
			$("acctCode2").value = parseInt(obj.glSubAcct2).toPaddedString(2);
			$("acctCode3").value = parseInt(obj.glSubAcct3).toPaddedString(2);
			$("acctCode4").value = parseInt(obj.glSubAcct4).toPaddedString(2);
			$("acctCode5").value = parseInt(obj.glSubAcct5).toPaddedString(2);
			$("acctCode6").value = parseInt(obj.glSubAcct6).toPaddedString(2);
			$("acctCode7").value = parseInt(obj.glSubAcct7).toPaddedString(2);
			$("ucAcctName").value = (nvl(obj.glAcctName, ""));
			$("ucHiddenSlTypeCd").value = (nvl(obj.gsltSlTypeCd, ""));
			$("ucHiddenGlAcctId").value = (nvl(obj.glAcctId, ""));
			$("ucHiddenSlCd").value = (nvl(obj.slCd, ""));
			$("ucHiddenGuncTranId").value = (nvl(obj.guncGaccTranId, ""));
			$("ucSlName").value = obj.slName;
			$("ucHiddenOrPrintTag").value = obj.orPrintTag;	//shan 10.29.2013

			var recStatus = obj.recordStatus;
			showAddDeleteButton(false, recStatus);
		}
		if (objACGlobal.tranFlagState == 'C'                                        
				|| objACGlobal.tranFlagState == 'D' 
				|| objACGlobal.queryOnly == "Y" ) { // added by shan 10.30.2013
			showMessageBox(
					"Page is in query mode only. Cannot change database fields.",
					imgMessage.INFO);
			disableButton("btnSlAdd");
			disableButton("btnSlDelete");
			if (obj != null && obj.orPrintTag == "Y"){	//added by shan 10.30.2013
				enableButton("btnSlDelete");
			}
			disableButton("btnSlSave");
			$("ucItemNo").readOnly = true;
			$("ucTranType").disabled = true;
			$("ucParticulars").readOnly = true;
			$$("input[type='text'].acctCds").each(function(m) {
				$(m.id).disabled = true;
				m.style.backgroundColor = "#FFFFFF";
			});
			$$("input[type='text'].refund").each(function(m) {
				$(m.id).disabled = true;
				m.style.backgroundColor = "#FFFFFF";
			});
		}
	}

	/* function computeTotalCollnsAmt(dec) {
		try {
			var collnTotal = 0;
			for ( var i = 0; i < (objCollnsArray.length - dec); i++) {
				if (objCollnsArray[i].recordStatus != -1) {
					collnTotal += parseFloat(objCollnsArray[i].collAmt);
				}
			}
			$("ucCollnsTotal").value = formatCurrency(collnTotal).truncate(13,
					"...");
		} catch (e) {
			showErrorMessage("computeTotalCollnsAmt", e);
		}
	} */
	
	function computeTotalCollnsAmt(collnAmt) {
		try {
			var totalColln = unformatCurrency("ucCollnsTotal");
			
			totalColln = parseFloat(totalColln) + parseFloat(collnAmt);
			
			$("ucCollnsTotal").value = formatCurrency(totalColln).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalCollnsAmt", e);
		}
	}

	$("btnSlCancel").stopObserving("click");
	$("btnSlCancel").observe(
			"click",
			function() {
				if (changeTag == 1) {
					showConfirmBox4("CONFIRMATION",
							objCommonMessage.WITH_CHANGES, "Yes", "No",
							"Cancel", function() {
								saveUnidentifiedCollns();
								if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
									$("giacs031MainDiv").hide();
									$("giacs032MainDiv").show();
									$("mainNav").hide();
								}else{
									editORInformation();	
									
								}
							}, function() {
								if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
									$("giacs031MainDiv").hide();
									$("giacs032MainDiv").show();
									$("mainNav").hide();
								}else{
									editORInformation();	
									
								}
								changeTag = 0;
							}, "");
				} else {
					if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
						showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
					}else if(objACGlobal.previousModule == "GIACS002"){
						showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS003"){
						if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
							showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
						}else{
							showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
						}
						objACGlobal.previousModule = null;							
					}else if(objACGlobal.previousModule == "GIACS071"){
						updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
						showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
						showGIACS070Page();
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
						$("giacs031MainDiv").hide();
						$("giacs032MainDiv").show();
						$("mainNav").hide();
					}else{
						editORInformation();	
						
					}
				}
			});

	$("acExit").stopObserving("click");
	$("acExit").observe(
			"click",
			function() {
				if (changeTag == 1) {
					showConfirmBox4("CONFIRMATION",
							objCommonMessage.WITH_CHANGES, "Yes", "No",
							"Cancel", function() {
								saveUnidentifiedCollns();
								if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
									showGIACS070Page();
									objACGlobal.previousModule = null;
								}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
									$("giacs031MainDiv").hide();
									$("giacs032MainDiv").show();
									$("mainNav").hide();
								}else{
									editORInformation();
								}
							}, function() {
								if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
									showGIACS070Page();
									objACGlobal.previousModule = null;
								}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
									$("giacs031MainDiv").hide();
									$("giacs032MainDiv").show();
									$("mainNav").hide();
								}else{
									editORInformation();	
								}
								changeTag = 0;
							}, "");
				} else {
					if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
						showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
					}else if(objACGlobal.previousModule == "GIACS002"){
						showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS003"){
						if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
							showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
						}else{
							showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
						}
						objACGlobal.previousModule = null;							
					}else if(objACGlobal.previousModule == "GIACS071"){
						updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
						showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
						showGIACS070Page();
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
						$("giacs031MainDiv").hide();
						$("giacs032MainDiv").show();
						$("mainNav").hide();
					}else{
						editORInformation();	
					}
				}
			});
	
	/* added by shan 10.29.2013 */
	$("glAcctCategory").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("glControlAcct").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode1").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode2").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode3").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode4").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode5").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode6").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("acctCode7").observe("blur", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});

	/* end 10.29.2013 */
	
	initializeAllAcctCdFields();
	//initializeAllOldTranNoFields();
	populateUnspecifiedCollns(null);
	changeTag = 0;
	generateItemNo();
	initializeChangeTagBehavior(saveUnidentifiedCollns);
	observeSaveForm("btnSlSave", saveUnidentifiedCollns);
	observeAcctgHome(saveUnidentifiedCollns);
	
	//added by steven 8.16.2012
	function disableGIACS014(){
// 		reqDivArray = new Array("unspecifiedCollnsFormDiv");
// 		readArray = new Array("ucItemNo","ucTranYear");
// 		buttonArray = new Array("btnSlAdd","btnSlDelete","btnSlSave");
// 		disableModuleFields(reqDivArray,null,null,readArray,null,buttonArray);
		reqDivArray = new Array("unidentifiedCollectionDiv","unspecifiedCollnsFormButtonsDiv");
		disableCancelORFields(reqDivArray);
	}
	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS014();
	}
</script>