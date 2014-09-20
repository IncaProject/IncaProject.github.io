---
layout: article
permalink: /
title: "Inca Monitoring"
excerpt: "Periodic, automated, user-level testing of Grid software and services"
image:
  feature: 
id: home
---

## Enables consistent user-level testing across resources

Emulates a Grid user by running under a standard user account and executing tests using a standard GSI credential. Ensures consistent testing across resources with centralized test configuration.

## Easy to configure and maintain

Manages and collects a large number of results through a GUI interface (incat). Measures resource usage of tests and benchmarks to help Inca administrators balance data freshness with system impact.

## Easy to collect data from resources

Data is collected by reporters, executables that measure some aspect of the system and output the result as XML. Multiple types of data can be collected. Perl APIs are provided to make it easy to write reporters; most are less than 30 lines of code.

## Large variety of tests

Inca offers a number of prewritten test scripts, called reporters, for monitoring Grid health. Reporter APIs make it easy to create new Inca tests.

## Archived results support troubleshooting

Furthers understanding of Grid behavior by storing and archiving complete monitoring results. Allows system administrators to debug detected failures using archived execution details.

## Comprehensive views of data

Offers a variety of Grid data views from cumulative summaries to reporter execution details and result histories.

## Secure

Inca components communicate using SSL. Securely manages short-term proxies for Grid service testing.
