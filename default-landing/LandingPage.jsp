<%@ page import="java.util.*" %>
<%!
    Date theDate = new Date();
    Date getDate()
    {
        System.out.println( "In getDate() method" );
        return theDate;
    }
	 
	 String repoName = "Geologic Timescale";
	 String serviceName = "api/isc2009";
	 String repoNote = "*Single document view contains >10000 RDF triples";

	 String conceptSchemes = serviceName+"/conceptscheme";
	 String conceptCollections = serviceName+"/collection";
	 String concepts = serviceName+"/concept";
	 String conceptResource = serviceName+"/resource";

	 String sparqlEndPoint = "http://services-test.auscope.org/openrdf-workbench/repositories/ischart/summary";

	 String sissvoc3wiki = "https://www.seegrid.csiro.au/wiki/Siss/VocabularyService3";
	 String isc2010 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2009.ttl";
	 String isc2009 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2009.ttl";
	 String isc2008 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2008.ttl";
	 String isc2006 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2006.ttl";
	 String isc2005 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2005.ttl";
	 String isc2004 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2004.ttl";


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


		//document.getElementById('conceptScheme_url').href = getAllResultOptions(conceptSchemeUrl);
		//document.getElementById('conceptCollection_url').href = getAllResultOptions(conceptCollectionUrl);
		//document.getElementById('concept_url').href = getAllResultOptions(conceptUrl);
		//document.getElementById('conceptResource_url').href = getAllResultOptions(conceptSchemeUrl);
		document.getElementById('conceptLabel_url').href = getAllResultOptions(conceptSchemeUrl);

	}

	/*
	function testGet() {
		alert('getRelationship = ' + getRelationship());
		alert('getAllResultOptions1 = ' + getAllResultOptions('http://localhost:8082/elda/api/isc/concept'));
		alert('getAllResultOptions2 = ' + getAllResultOptions('http://localhost:8082/elda/api/isc/resource?uri=http://resource.geosciml.org/classifier/ics/ischart/Furongian'));

	}*/

	function updateUrl(conceptResource) {		
		var resource = getResource();		
		document.getElementById('conceptResource_url').href = conceptResource+"?uri="+resource;
	}



	function getAllResultOptions(url) {
		var label = getLabel();
		var relationship = getRelationship();
		var lang = getLang();
		var format = getFormat();
		var pageSize = getPageSize();
		var metadata = getMetadata();

		if(metadata !='') metadata = '&'+metadata;

		var prefix = "";
		var index = url.indexOf("?");

		if(index == -1) //check for other fitlers
			prefix = "?";
		else prefix = "&";

		if(relationship != "") {
			if(index == -1)  // no filters added yet just append relationship
				url = url + "/" + relationship;
			else {
				url = url.substring(0,index) + "/" + relationship + url.substring(index,url.length)
				index = url.indexOf("?"); // have to find the index after appending text to url.
			}
		}

		var resourceIndex = url.indexOf("uri");
		var resource = "";

		if(resourceIndex != -1) {
			resource = url.substring(resourceIndex,url.length);
			pageSize = ""; //_pageSize can only be used with a list endpoint.
			label = "?"; //label not used for resource
		}
		else {
			pageSize = "&" + pageSize;
			label = "?"+label;
		}

		if(index!=-1) url = url.substring(0,index) + format + label +"&"+ resource + prefix+lang+pageSize+metadata;	
		else url = url+format+label+"&"+lang+pageSize+metadata

		return url;

	}

	function getResource() {
		return document.forms['form_resource'].elements['resource'].value;
	}

	function getLabel() {
		var labelMatch = getLabelMatch();
		
		if(labelMatch == "includes")	labelMatch = "anylabel=";		
		else if(labelMatch == "matches") labelMatch = "labelcontains=";
		
		var label = document.forms['form_label'].elements['label'].value;
		if(label) label = labelMatch+label;
		else label = "";
		return label;
	}

	function getLabelMatch() {
		var form = document.forms['form_label'];
		var labelMatch = "";

		for (var i = 0; i < form.labelMatch.length; i++) {
			if (form.labelMatch[i].checked) {
   	   	break;
	      }
		}
		if(i<form.labelMatch.length) 
			labelMatch = form.labelMatch[i].value;
		
		return labelMatch;
	}

	function getRelationship() {
		var form = document.forms['form_result_options'];
		var relationship = "";

		for (var i = 0; i < form.relationship.length; i++) {
			if (form.relationship[i].checked) {
   	   	break;
	      }
		}
		if(i<form.relationship.length) 
			relationship = form.relationship[i].value;
		
		return relationship;
	}

	function getLang() {
		var form = document.forms['form_result_options'].elements['language'];
		return "_lang="+form.options[form.selectedIndex].value;
	}

	function getFormat() {
		var form = document.forms['form_result_options'].elements['format'];
		return "."+form.options[form.selectedIndex].value;
	}

	function getPageSize() {
		var form = document.forms['form_result_options'].elements['pagesize'];
		return "_pageSize="+form.options[form.selectedIndex].value;
	}

	function getMetadata() {
		var form = document.forms['form_result_options'];
		var metadata = "";
		for (var i = 0; i < form.metadata.length; i++) {
			if (form.metadata[i].checked) {
				break;
			}
		}
		if(i<form.metadata.length) {
			var metadataValue = form.metadata[i].value;
			if(metadataValue == 'yes') 
				metadata = "_metadata=all";			
		}
		return metadata;		
	}


	</script>


	<body>
		<h2><%= repoName %></h2>
		This service provides a <a href="<%= sissvoc3wiki %>">SISSVoc</a> interface to an OWL representation of the <a href="<%= isc2009 %>">2009</a> edition of the International Stratigraphic Chart</a>
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
					<form id="form_resource">
						<a id="conceptResource_url" href="<%=conceptResource%>">Description of</a>: <input type="text" size="150" name="resource" value="http://resource.geosciml.org/classifier/ics/ischart/Furongian"/> <input type="button" value="Apply" onclick="updateUrl('<%=conceptResource%>');"/>
					</form> 
				</td>
			</tr>		
			<tr>
				<td style="vertical-align: middle;">&nbsp
					<form id="form_label">
						<a id="conceptLabel_url" href="<%=concepts%>">Concept whose label</a><input type="radio" name="labelMatch" value="matches" checked="true" />matches <input type="radio" name="labelMatch" value="includes" />includes the text: <input type="text" size="50" name="label" value="Cambrian"/> <input type="button" value="Apply" onclick="applyOptions('<%=conceptSchemes%>','<%=conceptCollections%>','<%=concepts%>','<%=conceptResource%>');"/>
					</form> 
				</td>
			</tr>
		</table> 
		<table border="1">
			<th>Result options</th>
			<tr>
				<td style="vertical-align: middle;">
					<form id="form_result_options">
						<a>Concepts: </a>
						<input type="radio" name="relationship" value="" checked="true" />exact
						<input type="radio" name="relationship" value="narrower" />narrower
						<input type="radio" name="relationship" value="narrowerTransitive" />narrowerTransitive
						<input type="radio" name="relationship" value="broader" />broader
						<input type="radio" name="relationship" value="broaderTransitive" />broaderTransitive
						<br>
						<br>
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
						<!--input type="button" value="SUPER!" onclick="testGet();"/-->
					</form>
				</td>
			</tr>
		</table>
		<br>
		<br>
		<a href="<%= sparqlEndPoint %>">SPARQL end-point</a>
		<br>
		<br>
		Other versions of this vocabulary: <a href="<%= isc2010 %>">2010</a> <a href="<%= isc2008 %>">2008</a> <a href="<%= isc2006 %>">2006</a> <a href="<%= isc2005 %>">2005</a> <a href="<%= isc2004 %>">2004</a>
		<br>
		<br>
		<a>Ontologies used by this service</a>


	</body>



</html>
