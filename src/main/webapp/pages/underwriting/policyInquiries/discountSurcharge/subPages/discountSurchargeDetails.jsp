<div class="sectionDiv">
	<div style="float: left; width: 100%; margin: 10px 0px 10px 50px;">
		<table>
			<tr>
				<td class="rightAligned">Policy No.</td>
				<td>
					<input type="text" id="txtPolicyNoDtl" style="width: 350px; " readonly="readonly" />
				</td>
				<td class="rightAligned" width="150px">Endorsement No.</td>
				<td>
					<input type="text" id="txtEndtNoDtl" style="width: 200px; " readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="3">
					<input type="text" id="txtAssdNameDtl" style="width: 716px; " readonly="readonly" />
				</td>
			</tr>
		</table>	
	</div>
	<div id="tabComponentsDiv1" class="tabComponents1" style="align:center;width:100%">
		<ul>
			<li class="tab1 selectedTab1" style="width:20.9%"><a id="polDiscSurcTab">Policy Discount/Surcharge</a></li>
			<li class="tab1" style="width:20%"><a id="itemDiscSurcTab">Item Discount/Surcharge</a></li>
			<li class="tab1" style="width:19.9%"><a id="perilDiscSurcTab">Peril Discount/Surcharge</a></li>
		</ul>			
	</div>
	<div id="tabBorderBottom" class="tabBorderBottom1"></div>
	<div id="tabPageContents1" name="tabPageContents1" style="width: 100%; float: left;">	
		<div id="polDiscSurcDiv" name="polDiscSurcDiv" style="width: 100%; height: 347px; float: left;"></div>
		<div id="itemDiscSurcDiv" name="itemDiscSurcDiv" style="width: 100%; height: 347px; float: left;"></div>
		<div id="perilDiscSurcDiv" name="perilDiscSurcDiv" style="width: 100%; height: 347px; float: left;"></div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 150px;" />
	</div>
</div>
<script type="text/JavaScript">
try{
	initializeTabs();
	
	$("polDiscSurcTab").observe("click", function(){
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
		    parameters : {
		    	action : "showDiscSurcDetail",
		    	policyId : objGIPIS190.policyId,
		    	pge : "policyDiscSurc",
		    	type : "pol"
		    },
		    onCreate: showNotice("Loading page... Please wait..."),
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("polDiscSurcDiv").update(response.responseText);
				}
			} 
		});
		
		$("polDiscSurcDiv").show();
		$("itemDiscSurcDiv").hide();
		$("perilDiscSurcDiv").hide();
	});
	
	$("itemDiscSurcTab").observe("click", function(){
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
		    parameters : {
		    	action : "showDiscSurcDetail",
		    	policyId : objGIPIS190.policyId,
		    	pge : "itemDiscSurc",
		    	type : "itm"
		    },
		    onCreate: showNotice("Loading page... Please wait..."),
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("itemDiscSurcDiv").update(response.responseText);
				}
			} 
		});
		
		$("polDiscSurcDiv").hide();
		$("itemDiscSurcDiv").show();
		$("perilDiscSurcDiv").hide();
	});
	
	$("perilDiscSurcTab").observe("click", function(){
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
		    parameters : {
		    	action : "showDiscSurcDetail",
		    	policyId : objGIPIS190.policyId,
		    	pge : "perilDiscSurc",
		    	type : "prl"
		    },
		    onCreate: showNotice("Loading page... Please wait..."),
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("perilDiscSurcDiv").update(response.responseText);
				}
			} 
		});
		
		$("polDiscSurcDiv").hide();
		$("itemDiscSurcDiv").hide();
		$("perilDiscSurcDiv").show();
	});
	
	$("btnReturn").observe("click", function(){
		fireEvent($("btnToolbarExit"), "click");
	});
}catch(e){
	showErrorMessage("discountSurchargeDetails.jsp", e);
}
</script>