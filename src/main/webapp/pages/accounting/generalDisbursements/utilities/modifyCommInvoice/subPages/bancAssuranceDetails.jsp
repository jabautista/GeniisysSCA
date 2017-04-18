<div class="sectionDiv" id="bancAssuranceMainDiv" style="margin-top: 7px; width: 594px;">
	<!-- <div id="bancAssuranceType" name="bancAssuranceType" style="margin: 10px;">
		<div id="bancAssuranceTypeTable" name="bancAssuranceTypeTable" style="height:200px;"></div>
	</div> -->
	<div class="sectionDiv" style="border: none;">
		<table align="center" width="80%">
			<tr>
				<td class="rightAligned">Bancassurance Type</td>
				<td class="leftAligned">
					<div id="nbtBancTypeCdDiv" class="sectionDiv" style="float: left; width: 49px; height: 19px; margin-top: 2px; margin-left: 5px; border: 1px solid gray;">
						<input id="nbtBancTypeCd" title="Bancassurance Type" type="text" maxlength="2" text-align="right" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;" readonly="readonly" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchNbtBancTypeCdLOV" name="searchNbtBancTypeCdLOV" alt="Go" style="float: right;"/>
					</div>
					<input type="text" id="nbtBancTypeDesc" style="width: 250px; margin-left: 1px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Bancassurance Rate</td>
				<td class="leftAligned">
					<input type="text" id="nbtRate" style="width: 302px; margin-left: 5px;" text-align="right" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="bancAssuranceTypeDtl" class="sectionDiv" style="border: none; margin: 10px; width: 400px;">
		<div id="bancAssuranceTypeDtlTable" name="bancAssuranceTypeDtlTable" style="height:200px;"></div>
	</div>
	<div class="sectionDiv" style="border: none; margin-top: 5px;">
		<table align="center" width="80%">
			<tr>
				<td class="rightAligned">Intermediary Number</td>
				<td class="leftAligned">
					<div id="intmNoDiv" class="sectionDiv" style="float: left; width: 49px; height: 19px; margin-top: 2px; margin-left: 5px; border: 1px solid gray;">
						<input id="intmNo" title="Intermediary Number" type="text" maxlength="2" text-align="right" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;" readonly="readonly">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNoLOV" name="searchIntmNoLOV" alt="Go" style="float: right;"/>
					</div>
					<input type="text" id="intmName" style="width: 250px; margin-left: 1px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Intermediary Type</td>
				<td class="leftAligned">
					<input type="text" id="intmType" style="width: 302px; margin-left: 5px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" class="sectionDiv" style="border: none; text-align: center; margin-bottom: 10px;">
		<input type="button" id="btnApplyGiacs408" class="button" value="Apply" style="width: 100px;"/>
		<input type="button" id="btnCancelGiacs408" class="button" value="Cancel" style="width: 100px;"/>
	</div>
</div>
<script>
try{
	var jsonBancAssurance = JSON.parse('${jsonBancAssurance}');
	var objBanca = new Object();
	var objBancaB = new Object();
	var bancTypeCdLOVSw = false;
	var objParams;
	
	$("nbtBancTypeCd").value = jsonBancAssurance.bancTypeCd;
	$("nbtBancTypeDesc").value = jsonBancAssurance.bancTypeDesc;
	$("nbtRate").value = jsonBancAssurance.rate;
	
	objBanca.nbtBancTypeCd = $F("nbtBancTypeCd");
	objBanca.nbtBancTypeDesc = $F("nbtBancTypeDesc");
	objBanca.nbtRate = $F("nbtRate");

	function showBancaTypeLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getBancaTypeLov"
			},
			title: "Bancassurance Type",
			width: 400,
			height: 400,
			columnModel : [
			               {
			            	   id : "bancTypeCd",
			            	   title : "Type",
			            	   width : "80px",
			            	   align : "right"
			               },
			               {
			            	   id : "bancTypeDesc",
			            	   title : "Description",
			            	   width : "200px"
			               },
			               {
			            	   id : "rate",
			            	   title : "Rate",
			            	   width : "100px",
			            	   align : "right",
			            	   renderer : function(value){
			            		   return formatToNineDecimal(value);
			            	   }
			               }
			              ],
			draggable: true,
			onSelect: function(row) {
				$("nbtBancTypeCd").value = row.bancTypeCd;
				$("nbtBancTypeDesc").value = unescapeHTML2(row.bancTypeDesc);
				$("nbtRate").value = formatToNineDecimal(row.rate);
				
				if(nbtBancTypeCd != row.bancTypeCd){
					showBancAssuranceDtlTG(true);
					setBancaBFields(null);
				}
				disableSearch("searchIntmNoLOV");
			}
		});
	}
	
	var tempNbtBancTypeCd;
	$("searchNbtBancTypeCdLOV").observe("click", function(){
		tempNbtBancTypeCd = $F("nbtBancTypeCd");
		showBancaTypeLOV();
	});
	
	function showBancIntmLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getBancIntmLov",
				paramIntmType : $F("hidParamIntmType")
			},
			title: "Intermediary",
			width: 400,
			height: 400,
			columnModel : [
			               {
			            	   id : "intmNo",
			            	   title : "Type",
			            	   width : "80px",
			            	   align : "right"
			               },
			               {
			            	   id : "intmName",
			            	   title : "Description",
			            	   width : "200px"
			               },
			               {
			            	   id : "intmType",
			            	   title : "Rate",
			            	   width : "100px"			            	   
			               }
			              ],
			draggable: true,
			onSelect: function(row) {
				$("intmNo").value = row.intmNo;
				$("intmName").value = unescapeHTML2(row.intmName);
				$("intmType").value = row.intmType;
							
				if(tempBancaBIntmNo != $F("intmNo")){
					$("hidBancaBModTag").value = "Y";
				} 
				for(var i = 0; i < tbgBancAssuranceDtls.geniisysRows.length; i++){
					tbgBancAssuranceDtls.geniisysRows[i].intmNo = $F("intmNo");
					tbgBancAssuranceDtls.geniisysRows[i].nbtIntmName = $F("intmName");
					tbgBancAssuranceDtls.geniisysRows[i].intmType = $F("intmType");
					tbgBancAssuranceDtls.geniisysRows[i].modTag = $F("hidBancaBModTag");
					
					updateBancAssuranceDtlsTG(tbgBancAssuranceDtls.geniisysRows[i], i);
				}
			}
		});
	}
	
	function updateBancAssuranceDtlsTG(obj, i){
		objBancAssuranceArray.splice(i, 1, obj);
		tbgBancAssuranceDtls.updateVisibleRowOnly(obj, i);
	}
	
	var tempBancaBIntmNo;
	$("searchIntmNoLOV").observe("click", function(){
		$("hidVLovIntm").value = "Y";
		tempBancaBIntmNo = $F("intmNo");
		if(objBancaB.fixedTag == "N"){
			if(nvl(objACGlobal.objGIACS408.ORA2010SW,"N") == "Y"){
				checkBancAssurance();
			}	
		}else{
			showMessageBox("You cannot update this record.", "I");
		}
	});
	
	function checkBancAssurance(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=checkBancAssurance", {
				method: "POST",
				parameters: {
					issCd : $F("txtIssCd"),
					premSeqNo : $F("txtPremSeqNo"),
					intmNo : $F("hidInvIntmNo"),
					vModBtyp : $F("hidVModBtyp"),
					commRecId : $F("hidInvCommRecId"),
					intmType : objBancaB.intmType, 
					bancTypeCd : $F("nbtBancTypeCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var res = JSON.parse(response.responseText);
					if(res.paramIntmType == null){
						$("hidParamIntmType").value = res.ityp;
					}else{
						$("hidParamIntmType").value = $F("hidParamIntmType") + "," + res.ityp;
					}
					showBancIntmLOV();
				}
			});
		}catch(e){
			showErrorMessage("checkBancAssurance ", e);
		}
	}
		
	var jsonBancAssuranceDtls = JSON.parse('${jsonBancAssuranceDtls}');
	var objBancaB = new Object();
	var objBancAssuranceArray = [];
	
	bancAssuranceDtlsTableModel = {
		url : contextPath+ "/GIACDisbursementUtilitiesController?action=showBancAssuranceDtls&bancTypeCd="+$F("nbtBancTypeCd")
		   				 +"&vModBtyp="+$F("hidVModBtyp")+"&issCd="+$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo"),
		options : {
			width : '574px',
			height : '200px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				tbgBancAssuranceDtls.keys.removeFocus(tbgBancAssuranceDtls.keys._nCurrentFocus, true);
				tbgBancAssuranceDtls.keys.releaseKeys();
				
				objBancaB = tbgBancAssuranceDtls.geniisysRows[y];
				setBancaBFields(objBancaB);
				
				if(bancTypeCdLOVSw){
					enableSearch("searchIntmNoLOV");
				}
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgBancAssuranceDtls.keys.removeFocus(tbgBancAssuranceDtls.keys._nCurrentFocus, true);
				tbgBancAssuranceDtls.keys.releaseKeys();
				
				setBancaBFields(null);
			},
			onSort : function(){
				tbgBancAssuranceDtls.keys.removeFocus(tbgBancAssuranceDtls.keys._nCurrentFocus, true);
				tbgBancAssuranceDtls.keys.releaseKeys();
			}
		},
		columnModel : [ 
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id : "itemNo",
					title : "No.",
					width : '70px',
					align : 'right'
				},
				{
					id : "intmNo",
					title : "Intm. No.",
					width : '70px',
					align : 'right'
				},
				{
					id : "nbtIntmName",
					title : "Intermediary Name",
					width : '275px'
				},
				{
					id : "intmType",
					title : "Intermediary Type",
					width : '120px'
				},
				{
					id : "fixedTag",
					title : "F",
					width : '25px',
					sortable: false,
					editable: false,
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
				    	getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
				    })
				}
			],
			rows : jsonBancAssuranceDtls.rows
		};
		tbgBancAssuranceDtls = new MyTableGrid(bancAssuranceDtlsTableModel);
		tbgBancAssuranceDtls.pager = jsonBancAssuranceDtls;
		tbgBancAssuranceDtls.render('bancAssuranceTypeDtlTable');
		tbgBancAssuranceDtls.afterRender = function(){
			objBancaB.nbtIntmNo = tbgBancAssuranceDtls.geniisysRows[0].intmNo;
			objBancaB.nbtIntmType = tbgBancAssuranceDtls.geniisysRows[0].intmType;
			objBancaB.fixedTag = tbgBancAssuranceDtls.geniisysRows[0].fixedTag;
			$("hidParamIntmType").value = tbgBancAssuranceDtls.geniisysRows[0].intmType;
			
			if(objBanca.nbtBancTypeCd != tbgBancAssuranceDtls.geniisysRows[0].bancTypeCd){
				$("hidVModBtyp").value = 'Y';
				$("hidVModIntm").value = 'Y';
				$("hidBancaBModTag").value = 'Y';
				bancTypeCdLOVSw = true;
			}
			
			if($F("hidVLovIntm") == "N"){
				$("hidVPrvIntm").value = tbgBancAssuranceDtls.geniisysRows[0].intmNo;
			}
			objBancAssuranceArray = tbgBancAssuranceDtls.geniisysRows;
		};
		
	function setBancaBFields(obj){
		try{
			$("intmNo").value   = obj == null ? "" : obj.intmNo;
			$("intmName").value = obj == null ? "" : unescapeHTML2(obj.nbtIntmName);
			$("intmType").value = obj == null ? "" : obj.intmType;
		}catch(e){
			showErrorMessage("setBancaBFields ", e);
		}
	}
		
	function showBancAssuranceDtlTG(show){
		try{
			if(show){
				tbgBancAssuranceDtls.url = contextPath+"/GIACDisbursementUtilitiesController?action=showBancAssuranceDtls&bancTypeCd="+$F("nbtBancTypeCd")
				 						   +"&vModBtyp="+$F("hidVModBtyp")+"&issCd="+$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo"), 
				tbgBancAssuranceDtls._refreshList();	
			}else{
				if($("bancAssuranceTypeDtlTable") != null){
					clearTableGridDetails(tbgBancAssuranceDtls); 
				}
			}
		}catch(e){
			showErrorMessage("showBancAssuranceDtlTG ", e);
		}
	}
	
	function applyBancAssurance(){
		try{
			objParams = new Object();
			objParams.setBancAssurance = objBancAssuranceArray;
			objParams.vModBtyp = $F("hidVModBtyp");
			objParams.b140PremAmt = $F("hidPremAmt");
			objParams.b140NbtLineCd = $F("hidLineCd");
			objParams.b140IssCd = $F("txtIssCd");
			objParams.b140PremSeqNo = $F("txtPremSeqNo");
			objParams.bancaNbtBancTypeCd = $F("nbtBancTypeCd");
			objParams.fundCd = objACGlobal.objGIACS408.fundCd;
			objParams.branchCd = objACGlobal.objGIACS408.branchCd;
			objParams.b140PolicyId = $F("hidPolicyId");
			
			var strObjParameters = JSON.stringify(objParams);
			
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=applyBancAssurance", {
				method: "POST",
				parameters: {
					parameters : strObjParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkCustomErrorOnResponse(response)){
						$("hidVModBtyp").value = 'N';
						$("hidVModIntm").value = 'N';
						$("hidVLovIntm").value = 'N';
						changeTag = 1;
						overlayBancAssrnceDtls.close();
					}
				}
			});
		}catch(e){
			showErrorMessage("applyBancAssurance ", e);
		}
	}
	
	$("btnApplyGiacs408").observe("click", function(){
		applyBancAssurance();
	});
		
	$("btnCancelGiacs408").observe("click", function(){
		$("hidVModBtyp").value = "N";
		$("hidVModIntm").value = "N";
		$("hidVLovIntm").value = "N";
		overlayBancAssrnceDtls.close();	
	});
	
	disableSearch("searchIntmNoLOV");
	//showBancAssuranceDtlTG(true);
}catch(e){
	showErrorMessage("Bancassurance overlay ", e);
}
</script>