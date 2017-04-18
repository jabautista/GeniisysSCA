<div id="addLevelMainDiv" name="addLevelMainDiv" style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;">
	<div id="motherGlHeaderDiv" class="sectionDiv">
		<div id="headerDiv" style="margin-bottom: 10px; margin-top: 10px;">
			<table align="center">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Mother GL Account</td>
					<td class="leftAligned"> 
						<input type="text" id="txtMotherGlAccount" name="txtMotherGlAccount" readonly="readonly" style="width: 180px;" tabindex="501"/>
					</td>
					<td class="rightAligned" style="padding-right: 5px; padding-left: 10px;">Mother GL Name</td>
					<td class="leftAligned">
						<input type="text" id="txtMotherGlName" name="txtMotherGlName" readonly="readonly" style="width: 250px;" tabindex="502"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="TableDiv" class="sectionDiv" style="height: 210px;">
		<div id="childGlTableGridDiv" name="childGlTableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 220px;">
			<div id="childGlTableGrid" style="height: 190px;"></div>
		</div>
	</div>	
	<div id="addLevelDetailDiv" name="addLevelDetailDiv"  class="sectionDiv">
		<table style="margin-top: 10px; margin-bottom: 10px; margin-left: 10px;">
			<tr>
				<td class="rightAligned" style="width: 101px;">GL Account Code</td>
				<td class="leftAligned" style="width: 445px; padding-left: 5px;">
					<div id="glCodeDiv" style="float: left;">
						<input type="text" style="width: 22px;" id="txtChildGlAcctCategory" name="glAccountCode"	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit01" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9"  customLabel="GL Account Code" readonly="readonly" tabindex=503/>
						<input type="text" style="width: 22px;" id="txtChildGlControlAcct"  name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=504/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct1" 	name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=505/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct2" 	name="glAccountCode"	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=506/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct3"		name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=507/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct4"		name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=508/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct5"		name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=509/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct6"		name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=510/>
						<input type="text" style="width: 22px;" id="txtChildGlSubAcct7"		name="glAccountCode" 	value="" class="rightAligned glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" readonly="readonly" tabindex=511/>
					</div>
				</td>
			</tr>
			<tr>
				<td align="right">GL Account Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<input type="text" class="required" id="txtChildGlName" name="txtChildGlName" style="width: 580px; " tabindex="512" maxlength="100"/> 
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" style="margin-top: 10px; float: left; margin-left: 210px;">
		<input type="button" class="button" id="btnCreateRecord" name="btnCreateRecord" value="Create Record" style="width: 140px;" tabindex="601"/>
		<input type="button" class="button" id="btnCancelAddLevel" name="btnCancelAddLevel" value="Cancel" style="width: 140px;" tabindex="602"/>
	</div>
</div>
<script>
	try{
		$("txtChildGlName").focus();
		var objTriggerItem = '${level}';
		var objCurrGlAcctId = '${glAcctId}';
		var motherGlAcctId = null;

		function getGlMotherAcct() {
			new Ajax.Request(contextPath+"/GIACChartOfAcctsController?action=getGlMotherAcct",{
				method: "POST",
				parameters:{
				    glAcctId : objCurrGlAcctId,
					level : objTriggerItem
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						var message = response.responseText.split("-#-");
						motherGlAcctId = message[0];
						$("txtMotherGlAccount").value = message[1];
						$("txtMotherGlName").value = message[2];
					}
				}
			});
		}getGlMotherAcct();
		
		var objAddLevelList = JSON.parse('${jsonChildRecList}');
		var addLevelTable = { 
			url: contextPath+"/GIACChartOfAcctsController?action=getChildRecList&glAcctId="+objCurrGlAcctId+"&motherGlAcctId="+motherGlAcctId+"&level="+objTriggerItem,
			options:{
				width: '700px',
				title: '',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus: function(element, value, x, y, id){
					setDetails(tbgAddLevel.geniisysRows[y]);
					tbgAddLevel.keys.releaseKeys();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					getNextRecord();
					tbgAddLevel.keys.releaseKeys();
				},
				onSort: function() {
					getNextRecord();
					tbgAddLevel.keys.releaseKeys();
				},
				prePager: function () {
					getNextRecord();
					tbgAddLevel.keys.releaseKeys();
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
		        	   title: 'GL Account Code',
		        	   width: 288,
		        	   children: [
		        	               {
									   id : 'glAcctCategory',
									   width: 32,
									   align: 'right'
								   },
								   {
									   id : 'glControlAcct',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct1',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct2',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct3',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct4',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct5',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct6',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct7',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   }
				       ]
		        },
				{
					   id: "glAcctName",
					   title: "GL Account Name",
					   width: '360px',
					   titleAlign: 'left',
					   align: 'left'
				}
			],
			rows: objAddLevelList.rows
		};
		
		tbgAddLevel = new MyTableGrid(addLevelTable);
		tbgAddLevel.pager = objAddLevelList;
		tbgAddLevel.render('childGlTableGrid');
		tbgAddLevel.afterRender = function(y) {
			getNextRecord();
		};
	}catch(e){
		showErrorMessage("Add Level table grid.",e);
	}
	
	function getNextRecord() {
		new Ajax.Request(contextPath+"/GIACChartOfAcctsController?action=getChildChartOfAccts&glAcctId="+objCurrGlAcctId+"&motherGlAcctId="+motherGlAcctId+"&level="+objTriggerItem,{
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					temp = new Array();
					temp = JSON.parse(response.responseText);
					if (temp.list.length > 0) {
						for ( var i = 0; i < temp.list.length; i++) {
				 			if (temp.list.length == temp.list[i]['rownum']) {
				 				setDetails(temp.list[i]);
				 				getIncrementedLevel();
				 			}
			 			}
					}else {
						getIncrementedLevel();
					}
				}
			}							 
		});	
	}
	
	function setDetails(rec){
		try {
			$("txtChildGlAcctCategory").value = (rec == null ? "" : rec.glAcctCategory);
			$("txtChildGlControlAcct").value  = (rec == null ? "" : parseInt(rec.glControlAcct).toPaddedString(2));
			$("txtChildGlSubAcct1").value	  = (rec == null ? "" : parseInt(rec.glSubAcct1).toPaddedString(2));
			$("txtChildGlSubAcct2").value	  = (rec == null ? "" : parseInt(rec.glSubAcct2).toPaddedString(2));
			$("txtChildGlSubAcct3").value	  = (rec == null ? "" : parseInt(rec.glSubAcct3).toPaddedString(2));
			$("txtChildGlSubAcct4").value	  = (rec == null ? "" : parseInt(rec.glSubAcct4).toPaddedString(2));
			$("txtChildGlSubAcct5").value	  = (rec == null ? "" : parseInt(rec.glSubAcct5).toPaddedString(2));
			$("txtChildGlSubAcct6").value	  = (rec == null ? "" : parseInt(rec.glSubAcct6).toPaddedString(2));
			$("txtChildGlSubAcct7").value	  = (rec == null ? "" : parseInt(rec.glSubAcct7).toPaddedString(2));
			$("txtChildGlName").value		  =  rec == null ? "" : (rec.glAcctName);
		} catch (e) {
			showErrorMessage("setDetails", e);
		}
	}
	
	function getIncrementedLevel() {
		new Ajax.Request(contextPath+"/GIACChartOfAcctsController?action=getIncrementedLevel",{
			method: "POST",
			parameters:{
			    glAcctId : objCurrGlAcctId,
				level : objTriggerItem
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					var message = response.responseText.split("-#-");
					$$("input[name='glAccountCode']").each(function(txt) {
						if (message[1] == txt.id.substring(8)) {
							$(txt).value =  parseInt(message[0]).toPaddedString(2);
						}
					});
				}
			}
		});
	}
	
	function createRecord() {
		tbgChartOfAccounts._refreshList();
		$("txtGlAcctName").value 	 = $F("txtChildGlName");
		$("txtGlAcctCategory").value = $F("txtChildGlAcctCategory");
		$("txtGlControlAcct").value  = $F("txtChildGlControlAcct");
		$("txtGlSubAcct1").value 	 = $F("txtChildGlSubAcct1");
		$("txtGlSubAcct2").value	 = $F("txtChildGlSubAcct2");
		$("txtGlSubAcct3").value  	 = $F("txtChildGlSubAcct3");
		$("txtGlSubAcct4").value  	 = $F("txtChildGlSubAcct4");
		$("txtGlSubAcct5").value 	 = $F("txtChildGlSubAcct5");
		$("txtGlSubAcct6").value 	 = $F("txtChildGlSubAcct6");
		$("txtGlSubAcct7").value 	 = $F("txtChildGlSubAcct7");
		$("txtLeafTag").value 		 = "N";
		$("txtGlAcctCategory").focus();
	}
	
	$("txtChildGlName").observe("keyup", function(){
		$("txtChildGlName").value = $F("txtChildGlName").toUpperCase();
	});
	
	$("btnCreateRecord").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("addLevelDetailDiv")) {
			createRecord();
			overlayAddLevel.close();
		}
	});
	
	$("btnCancelAddLevel").observe("click", function(){
		overlayAddLevel.close();
	});
	
</script>