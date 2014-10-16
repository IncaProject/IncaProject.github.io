#!/bin/sh

###############################################################################
#
# NAME: incaInstall.sh
#
# DESCRIPTION
#
# An installer script for the Inca 2.0 distribution.
#
# SYNOPSIS
#
# incaInstall.sh  all|agent|common|consumers|depot|incat|reporters|server
#
###############################################################################

#=============================================================================#
# Global Vars
#=============================================================================#

SERVER="common-java agent consumers depot Inca-WS"
CORE="common-java agent consumers depot incat Inca-Reporter"
ALL="${SERVER} incat Inca-Reporter"
REAL_ALL="${ALL} reporters incaws"
INCA_RELEASES="http://inca.sdsc.edu/releases/latest"
HTTP_GET_METHODS="wget curl"

#=============================================================================#
# Functions
#=============================================================================#

#-----------------------------------------------------------------------------#
# echoError 
#
# Prints out an error message to stderr
#-----------------------------------------------------------------------------#
printUsage() {
  echo "Installer script for the Inca 2.0 distribution";
  echo;
  echo "Usage:  ./incaInstall.sh [-r releasesUrl] installdir all|<component>|server"
  echo;
  echo "where";
  echo;
  echo "  installdir  the target installation directory";
  echo;
  echo "  all         install all of the Inca components";
  echo;
  echo "  <component> is one of the following values:";
  echo;
  echo "    agent     the Inca component responsible for reporter data ";
  echo "              collection"
  echo "    consumers Jetty web server that serves JSP pages for displaying";
  echo "              collected Inca reporter data";
  echo "    depot     the Inca component responsible for storing and archiving";
  echo "              reporter data";
  echo "    incat     GUI for configuring and administering an Inca deployment";
  echo "    incaws    the Web Services server";
  echo "    reporters the Inca reporter API and repository tools";
  echo;
  echo "  core        the Inca agent, consumers, depot, components";
  echo "  server      the Inca agent, consumers, depot, and incaws components";
  echo;
  echo "Options:";
  echo "  r     Specify an alternative release directory [default: $INCA_RELEASES]";
}

#-----------------------------------------------------------------------------#
# checkForHttpGet
#
# Find out whether curl or wget exists on machine to fetch urls
#-----------------------------------------------------------------------------#
checkForHttpGet() {
  for method in $HTTP_GET_METHODS; do
    ${method} http://inca.sdsc.edu >/dev/null 2>&1
    if test $? -eq 0; then
      echo ${method};
      return;
    fi
  done
}

#-----------------------------------------------------------------------------#
# installWS
#
# Runs the installer script for the Inca-WS component
#-----------------------------------------------------------------------------#
installWS() {
  wsdir=""; #in case there are multiple Inca-WS dirs (e.g., one or more updates)
  wsdirs=`ls -d Inca-WS* 2>/dev/null | grep -v tar`
  if ( test $? -eq 0 ); then
    for dir in ${wsdirs}; do
      # get the last listed dir (latest version)
      wsdir=${dir}
    done
    if ( test -d ${wsdir} ); then
      cd ${wsdir} 2>&1 >> ${installdir}/install.log
      perl -I${installdir}/lib/perl Makefile.PL \
           PREFIX=${installdir} INSTALLDIRS=perl \
           LIB=${installdir}/lib/perl \
           INSTALLSCRIPT=${installdir}/bin \
           INSTALLMAN1DIR=${installdir}/man/man1 \
           INSTALLMAN3DIR=${installdir}/man/man3  2>&1 ${installdir}/install.log
      make >> ${installdir}/install.log
      make install >> ${installdir}/install.log
      cd ${installdir} 2>&1 >> ${installdir}/install.log
    fi
  fi
}

#=============================================================================#
# Main
#=============================================================================#

# read options
releasesUrl=${INCA_RELEASES}
getMethod="";
while getopts r: opt; do
  case $opt in
  r) releasesUrl=$OPTARG
     case $releasesUrl in
     file://*) localDir=`echo $releasesUrl | sed 's/^file:\/\///'`
               releasesUrl=${localDir}
               getMethod=cp ;;
     '?' ) ;;
     esac
     ;;
 '?') echo "$0: invalid option $OPTARG" >&2
      printUsage;
      exit 1;
      ;;
  esac
done
shift `expr $OPTIND - 1`

# find wget or curl
if test "${getMethod}" = ""; then
  getMethod=`checkForHttpGet`;
  if test "${getMethod}" = ""; then
    echo "Error, unable to find one of the following tools on your system: " \
         "$HTTP_GET_METHODS";
    exit 1;
  fi
fi

# read user's choice
installdir=""
modules=""
if test "$1" = ""; then
  printUsage;
  exit 1;
else
  installdir=$1
fi
if test "$2" = ""; then
  echo "Error, missing Inca component name to install"
  exit 1;
elif test "$2" = "all"; then
  modules=${ALL}
elif test "$2" = "core"; then
  modules=${CORE}
elif test "$2" = "server"; then
  modules=${SERVER}
else
  validmodule=`echo ${REAL_ALL} | grep $2`
  if test "${validmodule}" != ""; then
    if test "$2" = "reporters"; then
      modules="Inca-Reporter"
    elif test "$2" = "incaws"; then
      modules="Inca-WS"
    elif test "$2" = "manager"; then
      modules="Inca-ReporterManager"
    elif test "$2" = "common-java"; then
      modules="common-java"
    else
      modules="common-java $2"
    fi
  else
    echo "'$2' is not a valid Inca component name"
    exit 1;
  fi
fi
  
if test ! -d $installdir; then
  echo "Creating directory $installdir";
  mkdir -p $installdir;
fi
cd $installdir;
installdir=`pwd`
for component in $modules; do
  name="";
  if test "${component}" = "Inca-Reporter" -o "${component}" = "Inca-WS"; then
    name=${component}
  elif test "${component}" = "incat"; then
    name="${component}-bin"
  else 
    name="inca-${component}-bin"
  fi
  echo "Retrieving ${releasesUrl}/${name}.tar.gz";
  if test "${getMethod}" = "cp"; then
    ${getMethod} "${releasesUrl}/${name}.tar.gz" .
  elif test "${getMethod}" = "wget"; then
    ${getMethod} "${releasesUrl}/${name}.tar.gz"
  else
    ${getMethod} "${releasesUrl}/${name}.tar.gz" > ${name}.tar.gz
  fi
  if test ! -f "${name}.tar.gz"; then
    echo "Unable to retrieve Inca component ${component}";
    exit 1;
  fi
  echo "Unpacking ${releasesUrl}/${name}.tar.gz";
  gunzip "${name}.tar.gz";
  gtar xvf "${name}.tar";
  rm -f "${name}.tar";
  if ( test "${component}" = "Inca-WS" ); then
    installWS
  fi
  echo "${component} installed";
done

