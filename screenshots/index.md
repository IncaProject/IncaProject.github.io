---
layout: archive
title: Screenshots
---

<p>The following are screenshots of Inca data consumers. For live examples, visit our <a href="/users">Inca users</a> page.</p>

<ul>
	<li><a href="#map">Map View using Google Map API</a></li>
	<li><a href="#sum"> Tabular Suite Summary View</a></li>
	<li><a href="#detail">Test Detail View </a></li>
	<li><a href="#hist">Historical Views</a></li>
	<li><a href="#reports">Reports</a></li>
</ul>

<h3><a name="map"></a>Map View using Google Map API </h3>

<p>The map view provides a summary view of the current status of resources on a Google map. For each resource, the summary view will provide the percentage of reports passed, number of passed reports, number of failed reports, and a list of the failed tests (with a link to the report details page). A resource is represented on the map as a marker and colored red, green, or orange based on the number of tests that have passed and/or failed. The figure below shows the Inca Google map view for the NEON testbed (four resources at SDSC and one resource at James Reserve). All resources are passing their tests so every resource marker is green.</p>

<p><img src="map1.png" alt="google map view" border="0" /></p>

<p>Clicking on a marker will display an info window with the name of the resource and the status information as show below.</p>

<p><img src="map2.png" alt="google map view" border="0" /></p>

<p>Clicking on the "Toggle ping status" button will display the status of the cross-site ping test as show below.</p>

<p><img src="map3.png" alt="google map view" border="0" /></p>

<h3><a name="sum"></a>Tabular Suite Summary View </h3>

<p>A summary table of test suite results with links to test detail pages:</p>

<p><img src="table.jpg" alt="tabular suite summary" border="0" /></p>

<h3><a name="detail"></a>Test Detail View </h3>

<p>Test execution detail view:</p>

<p><img src="details.jpg" alt="test details" border="0" /></p>

<h3><a name="hist"></a>Historical Views </h3>

<p>Customizable graphs of test status history and distribution of test error types:</p>

<p><img src="graph1.jpg" alt="historical graphs" border="0" /></p>

<p>Customizable graphs of test status history and distribution of test error types:</p>

<p><img src="2.3graph.png" alt="historical graphs" border="0" /></p>

<p><img src="2.3hist.png" alt="historical graphs" border="0" /></p>

<h3><a name="reports"></a>Reports </h3>

<p>Historical summary reports with pass/fail status and error information:</p>

<p><img src="summary_report.jpg" alt="Pass/Fail Graphs and Error Messages" border="0" /></p>

<p>Average series pass rate by resource and suite for the past week. Each bar label shows the value of the average series pass rate for the last week and the difference in percentage from the previous week:</p>

<p><img src="summaryJsp.gif" alt="Average Pass Rate by Resource/Suite" border="0" /></p>

<p>More detailed report for resource/suite (linked from report above):</p>

<p><img src="summaryDetailsJsp.gif" alt="Detailed Report for Resource/Suite" border="0" /></p>

<p>Summary of test series errors by time period. Each time period includes the number of errors for the series during the time period, the number of unique or distinct errors during the period, and the percentage of the total results that passed during the period:</p>

<p><img src="error-summary.gif" alt="Series Error Summary" border="0" /></p>

<p>Average series pass rate over time grouped by resource and suite:</p>

<p><img src="summaryHistoryJsp.gif" alt="Average Pass History" border="0" /></p>
