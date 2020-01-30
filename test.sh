#!/bin/bash
#
# Test the JMeter Docker image using a trivial test plan.

# Example for using User Defined Variables with JMeter
# These will be substituted in JMX test script
# See also: http://stackoverflow.com/questions/14317715/jmeter-changing-user-defined-variables-from-command-line

T_DIR=tests/krungthai-next
JMX_FILE=Transfer_Intranal_KTB_to_KTB.jmx
JTL_FILE=Transfer_Intranal_KTB_to_KTB.jtl
LOG_FILE=jmeter.log

# Reporting dir: start fresh
R_DIR=${T_DIR}/report
rm -rf ${R_DIR} > /dev/null 2>&1
mkdir -p ${R_DIR}

/bin/rm -f ${T_DIR}/${JTL_FILE} ${T_DIR}/${LOG_FILE}  > /dev/null 2>&1

./run.sh -Dlog_level.jmeter=DEBUG \
	-n -t ${T_DIR}/${JMX_FILE} -l ${T_DIR}/${JTL_FILE} -j ${T_DIR}/${LOG_FILE} \
	-e -o ${R_DIR}

echo "==== jmeter.log ===="
cat ${T_DIR}/${LOG_FILE}

echo "==== Raw Test Report ===="
cat ${T_DIR}/${JTL_FILE}

echo "==== HTML Test Report ===="
echo "See HTML test report in ${R_DIR}/index.html"

echo "==== JTL Test Report ===="
echo "pbcopy < ${T_DIR}/${JTL_FILE}"
