#!/usr/bin/env bash

JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"

java \
  -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044 \
  -javaagent:/usr/share/java/lombok/lombok.jar \
  -Xbootclasspath/a:/usr/share/java/lombok/lombok.jar \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1g \
  -Xmx2G \
  -jar $(echo "${JAR}") \
  -configuration "/usr/share/java/jdtls/config_linux" \
  -data "${1}" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED
