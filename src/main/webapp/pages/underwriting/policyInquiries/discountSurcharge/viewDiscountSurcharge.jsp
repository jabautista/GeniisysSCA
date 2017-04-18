<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>View Policy with Discount/Surcharges</label>
		<span class="refreshers" style="margin-top: 0;">
	 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
		</span>
	</div>
</div>
<div id="discountsSurchargesMainDiv" class="sectionDiv" style="margin-bottom: 40px;">
	<div style="margin-top: 10px; width: 100%; height: 20px; float: left;">
		<label style="margin: 6px 0px 0px 295px; ">Line</label>
		<div id="lineCdDiv" class="required" style="float: left; width: 70px; height: 19px; margin: 2px 0px 0px 5px; border: 1px solid gray;" >
			<input id="txtLineCd" class="required" title="Line Code" type="text" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" lastValidValue="" tabindex="101">
			<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdLOV" name="imgLineCdLOV" alt="Go" style="float: right;"/>
		</div>
		<input type="text" id="txtLineName" style="margin: 2px 0px 0px 5px; width: 200px; float: left;" readonly="readonly" tabindex="102"/>
	</div>
	<div id="discountSurchargeTGDiv" class="sectionDiv" style="margin: 15px 0px 0px 10px; height: 300px; width: 711px; border: none;">
	
	</div>
	<div id="discountSurchargeRadioDiv" class="sectionDiv" style="margin: 15px 0px 0px 10px; height: 300px; width: 176px;">
		<label style="margin: 5px 0px 0px 62px;"><b>Discount</b></label>
		<div class="sectionDiv" style="margin: 5px 0px 0px 7px; height: 105px; width: 160px;">
			<table>
				<tr>
					<td>
						<input type="radio" id="rdoPolDisc" name="discSw" style="float: left;" value="1" tabindex="103"/>
						<label for="rdoPolDisc" style="margin-top: 2px;">w/ Policy Discount</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoItemDisc" name="discSw" style="float: left;" value="2"/>
						<label for="rdoItemDisc" style="margin-top: 2px;">w/ Item Discount</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoPerilDisc" name="discSw" style="float: left;" value="3"/>
						<label for="rdoPerilDisc" style="margin-top: 2px;">w/ Peril Discount</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoAllDisc" name="discSw" style="float: left;" value="4"/>
						<label for="rdoAllDisc" style="margin-top: 2px;">Multiple Discount</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoNoDisc" name="discSw" style="float: left;" value="5"/>
						<label for="rdoNoDisc" style="margin-top: 2px;">No Discount</label>
					</td>
				</tr>
			</table>
		</div>
		<label style="margin: 5px 0px 0px 62px;"><b>Surcharge</b></label>
		<div class="sectionDiv" style="margin: 5px 0px 0px 7px; height: 105px; width: 160px;">
			<table>
				<tr>
					<td>
						<input type="radio" id="rdoPolSurc" name="surcSw" style="float: left;" value="1" tabindex="104"/>
						<label for="rdoPolSurc" style="margin-top: 2px;">w/ Policy Surcharge</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoItemSurc" name="surcSw" style="float: left;" value="2" />
						<label for="rdoItemSurc" style="margin-top: 2px;">w/ Item Surcharge</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoPerilSurc" name="surcSw" style="float: left;" value="3" />
						<label for="rdoPerilSurc" style="margin-top: 2px;">w/ Peril Surcharge</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoAllSurc" name="surcSw" style="float: left;" value="4" />
						<label for="rdoAllSurc" style="margin-top: 2px;">Multiple Surcharge</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoNoSurc" name="surcSw" style="float: left;" value="5" />
						<label for="rdoNoSurc" style="margin-top: 2px;">No Surcharge</label>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left;">
			<label style="margin: 11px 0px 0px 7px;">Crediting Branch</label>
			<input type="text" id="txtCredBranch" style="margin: 8px 0px 0px 7px; width: 50px;" readonly="readonly" tabindex="105"/>
		</div>
	</div>
	<div class="sectionDiv" style="margin: 10px 0px 0px 10px; width: 897px; height: 72px;">
		<table style="margin-top: 6px;">
			<tr>
				<td class="rightAligned" width="150px">Assured</td>
				<td colspan="3"><input type="text" id="txtDrvAssdName" style="width: 600px;" readonly="readonly" tabindex="106"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Premium</td>
				<td><input type="text" id="txtPremAmt" style="width: 200px;" readonly="readonly" tabindex="107"/></td>
				<td class="rightAligned" width="184px">Sum Insured</td>
				<td><input type="text" id="txtTsiAmt" style="width: 200px;" readonly="readonly" tabindex="108"/></td>
			</tr>
		</table>
	</div>
	<div width="100%" style="text-align: center;">
		<input type="button" id="btnDiscountSurchargeDtls" class="button" style="margin-top: 10px; margin-bottom: 10px; width: 200px;" value="Discount/Surcharge Details" tabindex="109"/>
	</div>
</div>
<div id="discountSurchargeDetailsDiv">
	<jsp:include page="/pages/underwriting/policyInquiries/discountSurcharge/subPages/discountSurchargeDetails.jsp"></jsp:include>
</div>
<div>
	<input type="hidden" id="hidExitSw" value="M"/>
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIPIS190");
	setDocumentTitle("View Policy with Discount/Surcharge");
	objGIPIS190 = new Object();
	
	try{
		objGIPIS190.objDiscountSurchargeTableGrid = JSON.parse('${jsonDiscSurc}');
		objGIPIS190.objDiscountSurcharge = objGIPIS190.objDiscountSurchargeTableGrid.rows || []; 
		
		var discountSurchargeModel = {
			url:contextPath+"/GIPIPolbasicController?action=showDiscountSurcharge&refresh=1",
			options:{
				id: 1,
				width: '711px',
				height: '279px',
				onCellFocus: function(element, value, x, y, id){
					var obj = discountSurchargeTableGrid.geniisysRows[y];
					populateFields(obj);
					
					objGIPIS190.policyId = discountSurchargeTableGrid.geniisysRows[y].policyId;
					objGIPIS190.assdName = discountSurchargeTableGrid.geniisysRows[y].assdName;
					objGIPIS190.policyNo = discountSurchargeTableGrid.geniisysRows[y].policyNo;
					objGIPIS190.endtNo = discountSurchargeTableGrid.geniisysRows[y].endtNo;
					
					enableButton("btnDiscountSurchargeDtls");
					
					discountSurchargeTableGrid.keys.removeFocus(discountSurchargeTableGrid.keys._nCurrentFocus, true);
					discountSurchargeTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					populateFields(null);
					disableButton("btnDiscountSurchargeDtls");
					
					discountSurchargeTableGrid.keys.removeFocus(discountSurchargeTableGrid.keys._nCurrentFocus, true);
					discountSurchargeTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						populateFields(null);
						disableButton("btnDiscountSurchargeDtls");
						
						discountSurchargeTableGrid.keys.removeFocus(discountSurchargeTableGrid.keys._nCurrentFocus, true);
						discountSurchargeTableGrid.keys.releaseKeys();
					}
				},
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'policyNo',
					title: 'Policy No.',
					width: '170px',
					visible: true,
					filterOption: true
				},
				{	id: 'endtNo',
					title: 'Endt. No.',
					width: '130px',
					visible: true,
					filterOption: true
				},
				{	id: 'discAmt',
					title: 'Total Discount',
					titleAlign: 'right',
					align: 'right',
					width: '170px',
					visible: true,
					filterOption: true,
					renderer: function(value){
						return formatCurrency(nvl(value, 0));
					}
				},
				{	id: 'surcAmt',
					title: 'Total Surcharge',
					titleAlign: 'right',
					align: 'right',
					width: '170px',
					visible: true,
					filterOption: true,
					renderer: function(value){
						return formatCurrency(nvl(value, 0));
					}
				},
			],
			rows: objGIPIS190.objDiscountSurcharge
		};
		
		discountSurchargeTableGrid = new MyTableGrid(discountSurchargeModel);
		discountSurchargeTableGrid.pager = objGIPIS190.objDiscountSurchargeTableGrid;
		discountSurchargeTableGrid._mtgId = 1;
		discountSurchargeTableGrid.render('discountSurchargeTGDiv');
	}catch(e){
		showErrorMessage("discountSurchargeTableGrid",e);
	}
	
	function populateFields(obj){
		$("txtDrvAssdName").value = obj == null ? null : unescapeHTML2(obj.assdName);
		$("txtPremAmt").value = obj == null ? null : formatCurrency(obj.tsiAmt);
		$("txtTsiAmt").value = obj == null ? null : formatCurrency(obj.premAmt);
		$("txtCredBranch").value = obj == null ? null : obj.credBranch;
		
		if(obj != null){
			$$("input[name='discSw']").each(function(a){
				if(obj.discSw == $(a.id).value){
					$(a.id).checked = true;	
				}
			});
			$$("input[name='surcSw']").each(function(a){
				if(obj.surcSw == $(a.id).value){
					$(a.id).checked = true;	
				}
			});
		}else{
			$$("input[name='discSw']").each(function(a){
				$(a.id).checked = false;	
			});
			$$("input[name='surcSw']").each(function(a){
				$(a.id).checked = false;
			});
		}
	}
	
	function showGIPIS190LineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIPIS190LineLOV",
							moduleId : "GIPIS190",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "lineCd",
								title: "Line Code",
								width : '100px',
							}, {
								id : "lineName",
								title : "Line Name",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					disableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgLineCdLOV").observe("click", showGIPIS190LineLOV);
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();	
	});
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGIPIS190LineLOV();
			}
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		$("txtLineCd").clear();
		$("txtLineCd").focus();
		$("txtLineName").clear();
		$("txtDrvAssdName").clear();
		$("txtPremAmt").clear();
		$("txtTsiAmt").clear();
		$("txtCredBranch").clear();
		
		disableButton("btnDiscountSurchargeDtls");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		$("txtLineCd").removeAttribute("readonly");
		enableSearch("imgLineCdLOV");
		
		$$("input[name='discSw']").each(function(a){
			$(a.id).disabled = false;
			$(a.id).checked = false;
		});
		$$("input[name='surcSw']").each(function(a){
			$(a.id).disabled = false;
			$(a.id).checked = false;
		});
		
		$("rdoAllDisc").disabled = true;
		$("rdoAllSurc").disabled = true;
		
		discountSurchargeTableGrid.url = contextPath+"/GIPIPolbasicController?action=showDiscountSurcharge&refresh=1";	
		discountSurchargeTableGrid._refreshList();
	});
	
	function getDiscSurcSw(){
		var params = "";
		
		params = params + "&discSw=";
		$$("input[name='discSw']").each(function(a){
			if($(a.id).checked){
				params = params + $F(a.id);
			}
		});
		params = params + "&surcSw=";
		$$("input[name='surcSw']").each(function(a){
			if($(a.id).checked){
				params = params + $F(a.id);
			}
		});

		return params;
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		try{
			if($F("txtLineCd") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtLineCd");
			}else{
				discountSurchargeTableGrid.url = contextPath+"/GIPIPolbasicController?action=showDiscountSurcharge&refresh=1&moduleId=GIPIS190"+
				"&lineCd="+$F("txtLineCd")+getDiscSurcSw();	

				discountSurchargeTableGrid._refreshList();	
				
				if(discountSurchargeTableGrid.geniisysRows.length > 0){
					enableToolbarButton("btnToolbarEnterQuery");
					disableToolbarButton("btnToolbarExecuteQuery");
					
					$$("input[name='discSw']").each(function(a){
						$(a.id).disabled = true;
						$(a.id).checked = false;
					});
					$$("input[name='surcSw']").each(function(a){
						$(a.id).disabled = true;
						$(a.id).checked = false;
					});
					
					$("txtLineCd").writeAttribute("readonly", "readonly");
					disableSearch("imgLineCdLOV");
				}else{
					customShowMessageBox("Query caused no records to be retrieved.", "I", "txtLineCd");
				}
			}
		}catch(e){
			showErrorMessage("btnToolbarExecuteQuery", e);
		}	
	});
	
	$("btnDiscountSurchargeDtls").observe("click", function(){
		$("discountsSurchargesMainDiv").hide();
		$("discountSurchargeDetailsDiv").show();
		$("btnToolbarEnterQuery").hide();
		$("btnToolbarEnterSep").hide();
		$("btnToolbarExecuteQuery").hide();
		$("btnToolbarExecuteQueryDisabled").hide();
		$("btnToolbarPrint").hide();
		$("btnToolbarPrintSep").hide();
		$("hidExitSw").value = "S";
		fireEvent($("perilDiscSurcTab"), "click");
		
		$("txtAssdNameDtl").value = objGIPIS190.assdName;
		$("txtPolicyNoDtl").value = objGIPIS190.policyNo;
		$("txtEndtNoDtl").value = objGIPIS190.endtNo;
	});
	
	$("rdoAllDisc").disabled = true;
	$("rdoAllSurc").disabled = true;
	$("discountSurchargeDetailsDiv").hide();
	$("btnToolbarPrint").hide();
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableButton("btnDiscountSurchargeDtls");
	$("txtLineCd").focus();
	observeReloadForm("reloadForm", showGIPIS190);
	
	$("btnToolbarExit").observe("click", function() {
		if($F("hidExitSw") == "M"){
			delete objGIPIS190;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		}else{
			$("discountSurchargeDetailsDiv").hide();
			$("discountsSurchargesMainDiv").show();
			$("btnToolbarEnterQuery").show();
			$("btnToolbarEnterSep").show();
			$("btnToolbarExecuteQuery").hide();
			$("btnToolbarExecuteQueryDisabled").show();
			$("btnToolbarPrint").show();
			$("btnToolbarPrintSep").show();
			$("btnToolbarPrint").hide();
			$("hidExitSw").value = "M";
		}
		
	});
}catch(e){
	showErrorMessage("viewDiscountSurcharge.jsp", e);
}
</script>