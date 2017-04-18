<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<!-- <label>Assured Type</label> -->
   		<label>Corporate Tag</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" id="lblHideCorporateTag" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div id="assuredType" class="sectionDiv">
	<div style="margin: 10px; margin-left: 230px; display: block; height: 20px;">
		<input type="hidden" id="corporateTag" name="corporateTag">
		<span style="float: left; width: 120px; text-align: left;"><input type="radio" value="I" id="personal" name="rdoCorporateTag" tabindex="1" /> <label for="personal" style="float: none;">Individual</label></span>
		<span style="float: left; width: 120px; text-align: left;"><input type="radio" value="C" id="corporate" name="rdoCorporateTag" tabindex="2" checked="checked" /> <label for="corporate" style="float: none;">Corporate</label></span>
		<span style="float: left; width: 120px; text-align: left;"><input type="radio" value="J" id="joint" name="rdoCorporateTag" tabindex="3" /> <label for="joint" style="float: none;">Joint</label></span>
	</div>
</div>
<script>
	showCorporate(); //default settings
	
	if(assuredMaintainExitCtr==1){
		$("assuredListingTableGridDiv").hide();
		assuredMaintainGimmExitCtr = 2;
	}
	
	<c:if test="${assured.corporateTag eq 'I'}">
		$("personal").checked = true;
		showPersonal();
	</c:if>
	<c:if test="${assured.corporateTag eq 'C'}">
		$("corporate").checked = true;
		showCorporate();
	</c:if>
	<c:if test="${assured.corporateTag eq 'J'}">
		$("joint").checked = true;
		showJoint();
	</c:if>

	$("personal").observe("click", showPersonal);
	
	$("corporate").observe("click", showCorporate);

	$("joint").observe("click", showJoint);

	function showPersonal() {
		$("corporateTag").value = "I";
		$("selectedAssuredType").innerHTML = "Individual";
		
		$$("tr[name='forPersonal'], td[name='forPersonal']").invoke("show");
		//$$("tr[name='forCorporate'], td[name='forCorporate']").invoke("hide");
		$$("tr[name='forJoint'], td[name='forJoint']").invoke("hide");
		$("firstName").addClassName("required");
		$("lastName").addClassName("required");
		$("assuredName2Corp").hide();
		$("assuredName2").hide();
		
		for (var i = 0; i < $("industry").length; i++){
			if ($("industry").options[i].innerHTML == "INDIVIDUAL"){
				$("industry").options.selectedIndex = i;
			}
		}
		
		enableButton("btnIndividualInformation");
		$("birthDateLabel").innerHTML = "Birthdate";
		$("assuredNoTd").setStyle("width: 100px;");
	}

	function showCorporate() {
		$("corporateTag").value = "C";
		$("selectedAssuredType").innerHTML = "Corporate";
		
		$$("tr[name='forPersonal'], td[name='forPersonal']").invoke("hide");
		$$("tr[name='forCorporate'], td[name='forCorporate']").invoke("show");
		$$("tr[name='forJoint'], td[name='forJoint']").invoke("hide");
		$("assuredName2Corp").show();
		$("assuredName2").hide();

		nvl('${assured.industryCd}', "") == "" ? $("industry").options.selectedIndex = 0 : null;
		
		disableButton("btnIndividualInformation"); //robert
		$("birthDateLabel").innerHTML = "Date of Incorporation";
		$("assuredNoTd").setStyle("width: 150px;");
	}

	function showJoint() {
		$("corporateTag").value = "J";
		$("selectedAssuredType").innerHTML = "Joint";
		
		$$("tr[name='forPersonal'], td[name='forPersonal']").invoke("show");
		$$("tr[name='forCorporate'], td[name='forCorporate']").invoke("show");
		$$("tr[name='forJoint'], td[name='forJoint']").invoke("show");
		$("assuredName2Corp").hide();
		$("assuredName2").show();

		nvl('${assured.industryCd}', "") == "" ? $("industry").options.selectedIndex = 0 : null;
		
		$("firstName").removeClassName("required");
		$("lastName").removeClassName("required");
		disableButton("btnIndividualInformation"); //robert
		$("birthDateLabel").innerHTML = "Birthdate/Date of Incorporation";
		$("assuredNoTd").setStyle("width: 180px;");
	}

</script>