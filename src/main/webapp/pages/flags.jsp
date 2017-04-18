<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<div id="flags" name="flags">
	<span style="float: left;">
		<img src="./images/flags/philippines.jpg" class="flag" name="PH"/>
		<img src="./images/flags/china.jpg" class="flag" name="CN"/>
		<img src="./images/flags/france.jpg" class="flag" name="FR"/>
		<img src="./images/flags/italy.jpg" class="flag" name="IT"/>
		<img src="./images/flags/netherlands.jpg" class="flag" name="NL"/>
		<img src="./images/flags/portugal.jpg" class="flag" name="PT"/>
		<img src="./images/flags/saudi arabia.jpg" class="flag" name="SA"/>
		<img src="./images/flags/spain.jpg" class="flag" name="ES"/>
		<img src="./images/flags/usa.jpg" class="flag" name="US"/>
	</span>
</div>
<script type="text/javascript">
	$$("img.flag").each(
		function (flag)	{
			flag.observe("click", function ()	{
				new Ajax.Request(contextPath+"/GIISController?action=setLocale", {
					asynchronous: true,
					evalScripts: true,
					parameters: {
						code: flag.getAttribute("name")
					}, onComplete : function(){window.location.reload();}
				});
			});	
		}	
	);
</script>