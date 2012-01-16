<%@ page import="java.util.*" %>
<%!
    Date theDate = new Date();
    Date getDate()
    {
        System.out.println( "In getDate() method" );
        return theDate;
    }
	 
	 String repoName = "Geologic Timescale";
	 String serviceName = "api/isc";
	 String repoDescription = "This service provides a [SISSvoc interface] to [{an OWL representation of the 2009 edition of the International Stratigraphic Chart}]";
	 String repoNote = "*Single document view contains >10000 RDF triples";

	 String conceptSchemes = serviceName+"/conceptscheme";
	 String conceptCollections = serviceName+"/collection";
	 String concepts = serviceName+"/concept";
	 String conceptResource = serviceName+"/resource";

	 String sparqlEndPoint = "http://services-test.auscope.org/openrdf-workbench/repositories/ischart/summary";
%>

<html>
	
	<head>
	</head>
	<title>API configuration</title>
	<!--
   <link rel="stylesheet" type="text/css" href="/sdx-api/styles/style.css" />
   <link rel="stylesheet" type="text/css" href="/styles/style.css" />
	-->

	<script type="text/javascript">

	function toggle(id) {
   	var div = document.getElementById( id );
	   div.className = (div.className == "show" ? "hide" : "show");
	}

function applyOptions(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl) {

		var urls=new Array(); 
		urls[0] = conceptSchemeUrl;       
		urls[1] = conceptCollectionUrl;
		urls[2] = conceptUrl;
		urls[3] = conceptResourceUrl;		
		urls[4] = conceptUrl;
		urls[5] = conceptUrl;

		var form_lang = document.forms['form_result_options'].elements['language'];
		var form_pagesize = document.forms['form_result_options'].elements['pagesize'];
		var form_format = document.forms['form_result_options'].elements['format'];
		var form_metadata = document.forms['form_result_options'];

		urls = updateFormat(form_format.options[form_format.selectedIndex].value, urls);
		urls = updateLang(form_lang.options[form_lang.selectedIndex].value, urls);
		urls = updatePageSize(form_pagesize.options[form_pagesize.selectedIndex].value, urls);
		urls = updateMetadata(form_metadata, urls);

		updateAll(urls);

		var conceptResource_url = document.getElementById('conceptResource_url').href;
		var resource = document.forms['form_resource'].elements['resource'].value;
		if(resource && resource.length > 0) updateUrl(conceptResource_url);

		var conceptLabel_url = document.getElementById('conceptLabel_url').href;
		var label = document.forms['form_label'].elements['label'].value;
		if(label && label.length > 0) updateLabel(conceptLabel_url);

		//(form_pagesize.options[form_pagesize.selectedIndex].value);
	}

	function updateAll(urls) {
		document.getElementById('conceptScheme_url').href = urls[0];
		document.getElementById('conceptCollection_url').href = urls[1];
		document.getElementById('concept_url').href = urls[2];
		document.getElementById('conceptResource_url').href = urls[3];
		document.getElementById('conceptLabel_url').href = urls[4];
		document.getElementById('conceptLabelRelational_url').href = urls[5];
	}

	function updateUrl(url) {
		//document.getElementById(id).innerHTML = label;
		
		var form_resource = document.forms['form_resource'].elements['resource'];
		//var conceptResourceUrl = document.getElementById('conceptResource_url').href;
		document.getElementById('conceptResource_url').href = insertFilter(url,'uri',form_resource.value);	
	}

	function updateLabel(url) {
		var form_label = document.forms['form_label'].elements['label'];
		document.getElementById('conceptLabel_url').href = insertFilter(url,'label',form_label.value);	
	}

	function updateLabelRelational(url,form) {
		for (var i = 0; i < form.relationship.length; i++) {
			if (form.relationship[i].checked) {
   	   	break
	      }
		}
		if(i<form.relationship.length) {
			var relationship = form.relationship[i].value;
			url = insertRelationship(url,relationship);
			var form_label = document.forms['form_label_relational'].elements['label'];
			document.getElementById('conceptLabelRelational_url').href = insertFilter(url,'anylabel',form_label.value);	
		}
	}

	function updateLang(lang, urls) {	

		for (var i=0;i<urls.length;i++) {
			urls[i] = insertFilter(urls[i],'_lang',lang);
		}
		return urls;
	}

	function updateFormat(format, urls) {		
		for (var i=0;i<urls.length;i++) {
			urls[i] = insertFormat(format, urls[i]);
		}
		return urls;		
	}

	function updatePageSize(pagesize, urls) {
		for (var i=0;i<urls.length;i++) {
			urls[i] = insertFilter(urls[i],'_pageSize',pagesize);
		}
		return urls;		
	}

	function updateMetadata(form, urls) {
		for (var i = 0; i < form.metadata.length; i++) {
			if (form.metadata[i].checked) {
				break
			}
		}
		if(i<form.metadata.length) {
			var metadata = form.metadata[i].value;
			if(metadata == 'yes') {
				for (var i=0;i<urls.length;i++) {
					urls[i] = insertFilter(urls[i],'_metadata','all');
				}
			}
		}
		return urls;		
	}

	function insertFormat(format, url) {

		var index = url.indexOf("?"); //check for other fitlers
		if(index == -1) url = url + "." + format;
		else url = url.substring(0,index-1) + "." + format + url.substring(index,url.length);

		return url;
	}

	function insertRelationship(url, relationship) {

		var index = url.indexOf("?"); //check for other fitlers
		if(index == -1) url = url + "/" + relationship;
		else url = url.substring(0,index-1) + "/" + relationship + url.substring(index,url.length);

		return url;
	}

	function insertFilter(url,param,value) {
	   var str = param + "=";
		var index = url.indexOf(str);
		var prefix = "";

		if(url.indexOf("?") == -1) //check for other fitlers
			prefix = '?';
		else prefix = '&';

		if(index == -1)  // filter not specified, add it
			url += prefix + str + value;
		else             // filter previously specified, update to new value specified
			url = url.substring(0,index-1) + prefix + str + value + url.substring(index+(param.length+3),url.length);		

		return url;
	}


	</script>


	<body>
		<h2><%= repoName %></h2>
		<a><%= repoDescription %></a>
		<br>
		<a><%= repoNote %></a>
		<br>
		<br>
		<table border="1">
			<tr>
				<th>Query options</th>
			</tr>
			<tr>
				<td><a id="conceptScheme_url" href="<%=conceptSchemes%>">All Concept Schemes</a></td>				
			</tr>
			<tr>
				<td><a id="conceptCollection_url"href="<%=conceptCollections%>">All Concept Collections</a></td>
			</tr>
			<tr>
				<td><a id="concept_url" href="<%=concepts%>">All Concepts</a></td>
			</tr>
			<tr>
				<td style="vertical-align: middle;">&nbsp
					<form id="form_label">
						<a id="conceptLabel_url" href="<%=concepts%>">Concept by Label</a>: <input type="text" size="50" name="label"/> <input type="button" value="Apply" onclick="updateLabel('<%=concepts%>');"/>
					</form> 
				</td>
			</tr>
			<tr>
				<td style="vertical-align: middle;">&nbsp
					<form id="form_label_relational">
						<a id="conceptLabelRelational_url" href="<%=concepts%>">Concept by Label</a>
						<input type="radio" name="relationship" value="narrower" checked="true" />narrower
						<input type="radio" name="relationship" value="narrowerTransitive" />narrowerTransitive
						<input type="radio" name="relationship" value="broader" />broader
						<input type="radio" name="relationship" value="broaderTransitive" />broaderTransitive
						than: <input type="text" name="label"/> <input type="button" value="Apply" onclick="updateLabelRelational('<%=concepts%>', this.form);"/>
					</form> 
				</td>
			</tr>
			<tr>
				<td style="vertical-align: middle;">&nbsp
					<form id="form_resource">
						<a id="conceptResource_url" href="<%=conceptResource%>">Concept by Resource</a>: <input type="text" size="50" name="resource"/> <input type="button" value="Apply" onclick="updateUrl('<%=conceptResource%>');"/>
					</form> 
				</td>
			</tr>		
		</table> 
		<table border="1">
			<th>Result options</th>
			<tr>
				<td style="vertical-align: middle;">
					<form id="form_result_options">
						<a>Report result in</a>
						<select name="language">
							<option value="bg">bg</option>
							<option value="cs">cs</option>
							<option value="da">da</option>
							<option value="de">de</option>
							<option value="en" selected="selected">en</option>
							<option value="es">es</option>
							<option value="et">et</option>
							<option value="fi">fi</option>
							<option value="fr">fr</option>
							<option value="hu">hu</option>
							<option value="it">it</option>
							<option value="ja">ja</option>
							<option value="lt">lt</option>
							<option value="nl">nl</option>
							<option value="no">no</option>
							<option value="pl">pl</option>
							<option value="pt">pt</option>
							<option value="sk">sk</option>
							<option value="sl">sl</option>
							<option value="sv">sv</option>
							<option value="zh">zh</option>
						</select>
						<br>
						<br>
						<a>Report result in</a>
						<select name="format">
							<option value="html" selected="selected">HTML</option> 
							<option value="rdf" >RDF/XML</option>
							<option value="ttl" >Turtle</option>
							<option value="json" >JSON</option>
							<option value="xml" >XML</option>
						</select>
						<br>
						<br>
						<a>Page size</a>
						<select name="pagesize">
							<option value="10" selected="selected">10</option>
							<option value="20">20</option>
							<option value="50">50</option>
						</select>
						<br>
						<br>
						<a>Metadata [flag full]</a> <input type="radio" name="metadata" value="no" checked="true" /> No	<input type="radio" name="metadata" value="yes"/> Yes
						<br>
						<br>
						<input type="button" value="Apply" onclick="applyOptions('<%=conceptSchemes%>','<%=conceptCollections%>','<%=concepts%>','<%=conceptResource%>');"/>
					</form>
				</td>
			</tr>
		</table>
		<br>
		<br>
		<a href="<%= sparqlEndPoint %>">SPARQL end-point</a><a> - Other versions of this vocabulary</a>
		<br>
		<br>
		<a>Ontologies used by this service</a>


	</body>



</html>
