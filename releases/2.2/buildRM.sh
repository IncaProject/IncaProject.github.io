#!/bin/sh

#-----------------------------------------------------------------------------
# buildRM.sh - Build script for reporter manager
#
# This script is used by the Inca reporter agent to build reporter managers
# on remote machines.  
#
# Usage:
#
# buildRM.sh <INSTALLDIR> <RMFILE>
#
# Arguments:
#
#   INSTALLDIR - A string containing the path of the directory to install
#                the reporter manager to.
#   RMFILE - A string containing the name of the tarball containing the
#            the reporter manager distribution
#
# Notes:
# 
# The script assumes that the INSTALLDIR exists and contains the RMFILE.
#-----------------------------------------------------------------------------

# check options
upgrade=""
while getopts u: opt; do
  case $opt in     
  u) upgrade=$OPTARG
     if test "${upgrade}" != "true" -a "${upgrade}" != "false"; then
       echo "Invalid value '${upgrade}' to -u" >&2
       echo "Usage: $0 [-u true|false] installdir rmtgzname" >&2
       exit 1
     fi
     ;;
 '?') echo "$0: invalid option -$OPTARG" >&2
      echo "Usage: $0 [-u true|false] installdir rmtgzname" >&2
      exit 1
      ;;
  esac
done
shift `expr $OPTIND - 1`

INSTALLDIR=$1
RMFILE=$2

# create an absolute path if we have a relative path
case ${1} in
  /*) LOG=${1}/build.log;;
  *) LOG=`pwd`/${1}/build.log;;
esac

cd ${INSTALLDIR}

# untar reporter manager distribution and change to the directory
gunzip -f ${RMFILE} >> ${LOG}
rm_tarname=`echo $RMFILE | sed "s/.gz$//"`
tar=`which gtar`
if ( test $? -ne 0 -o ! -f "${tar}" ); then
  tar=tar
fi
${tar} xvf ${rm_tarname} >> ${LOG}
rm_basename=`echo $RMFILE | sed "s/.tar.gz$//"`
rmdir=""; # in case there are multiple rm dirs (e.g., one or more updates)
for dir in `ls -d ${rm_basename}* | grep -v tar`; do 
  # get the last listed dir (latest version)
  rmdir=${dir}
done
cd ${rmdir} 2>&1 >> ${LOG} 

# configure it to install in INSTALLDIR
perl -I${INSTALLDIR}/lib/perl Makefile.PL \
     PREFIX=${INSTALLDIR} INSTALLDIRS=perl \
     LIB=${INSTALLDIR}/lib/perl \
     INSTALLSCRIPT=${INSTALLDIR}/bin \
     INSTALLMAN1DIR=${INSTALLDIR}/man/man1 \
     INSTALLMAN3DIR=${INSTALLDIR}/man/man3  2>&1 >> ${LOG}

# determine make on system
make=`which gmake`
if ( test $? -ne  0 -o ! -f "${make}" ); then
  make=make
fi

# either upgrade or do full install.  upgrade just installs inca common and 
# manager (i.e., no contrib libs are updated)
if test "${upgrade}" = "true" ;then
  cd ${INSTALLDIR}/${rmdir}
  ${make} install >> ${LOG}
else
  ${make} >> ${LOG}
  ${make} install >> ${LOG}
fi

# prep certs if there
if ( test -e ${INSTALLDIR}/trusted0.pem ); then
  echo "Installing credentials " >> ${LOG}
  if test ! -d ${INSTALLDIR}/etc/trusted; then 
    mkdir ${INSTALLDIR}/etc/trusted
  fi
  mv ${INSTALLDIR}/trusted*.pem ${INSTALLDIR}/etc/trusted
  if test  $? -ne 0; then
    echo "Move of trusted certificates failed" >> ${LOG}
    exit 1;
  fi
  trustedcerts=`ls ${INSTALLDIR}/etc/trusted`
  for cert in ${trustedcerts}; do
    hash=`openssl x509 -in ${INSTALLDIR}/etc/trusted/${cert} -hash -noout`
    openssl x509 -in ${INSTALLDIR}/etc/trusted/${cert} -trustout -out \
            ${INSTALLDIR}/etc/trusted/${hash}.0
    if test  $? -ne 0; then
      echo "Creation of trusted certificate ${hash} failed" >> ${LOG}
      exit 1;
    fi
  done
else
  echo "No credentials to install" >> ${LOG}
fi

